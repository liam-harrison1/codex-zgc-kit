#!/usr/bin/env python3
import json
import socket
import subprocess
import sys
import time
import urllib.parse

SOCKET_PATH = "/tmp/verge/verge-mihomo.sock"
SECRET = "set-your-secret"
PROXY_PORTS = [7897, 7890, 8099, 8090]
THRESHOLD_MS = 400
TEST_URL = "https://www.gstatic.com/generate_204"
CLOUDFLARE_FILE = "https://separately-she-market-printing.trycloudflare.com/codex-zgc-kit/README.md"
CLOUDFLARE_SUB2API = "https://meal-anna-processes-selective.trycloudflare.com/login"
SWITCH_GROUPS = ["PROXY", "AUTO-US-SG"]


def run_curl(args, timeout=15):
    cmd = ["/usr/bin/curl", *args]
    proc = subprocess.run(cmd, text=True, capture_output=True, timeout=timeout)
    return proc.stdout.strip(), proc.stderr.strip(), proc.returncode


def curl_timing(url, proxy_port=None, head=False):
    args = ["-o", "/dev/null", "-sS", "--connect-timeout", "5", "--max-time", "12"]
    if head:
        args.append("-I")
    if proxy_port:
        args += ["--proxy", f"http://127.0.0.1:{proxy_port}"]
    args += ["-w", "%{http_code} %{time_total}", url]
    out, err, code = run_curl(args)
    if code != 0 or not out:
        return {"ok": False, "error": err or f"curl exit {code}"}
    parts = out.split()
    if len(parts) < 2:
        return {"ok": False, "error": out}
    http = int(parts[0]) if parts[0].isdigit() else 0
    ms = round(float(parts[1]) * 1000)
    return {"ok": 200 <= http < 400, "http": http, "ms": ms}


def best_proxy_latency():
    results = []
    for port in PROXY_PORTS:
        res = curl_timing(TEST_URL, proxy_port=port)
        res["port"] = port
        results.append(res)
    oks = [r for r in results if r.get("ok")]
    if not oks:
        return None, results
    return min(oks, key=lambda x: x["ms"]), results


def decode_body(headers, body):
    if "transfer-encoding: chunked" not in headers.lower():
        return body
    out = b""
    i = 0
    while True:
        j = body.find(b"\r\n", i)
        if j < 0:
            break
        size = int(body[i:j].split(b";")[0], 16)
        i = j + 2
        if size == 0:
            break
        out += body[i : i + size]
        i += size + 2
    return out


def mihomo_request(method, path, body=None):
    data = b"" if body is None else json.dumps(body, ensure_ascii=False).encode()
    lines = [
        f"{method} {path} HTTP/1.1",
        "Host: localhost",
        f"Authorization: Bearer {SECRET}",
        "Connection: close",
    ]
    if body is not None:
        lines += ["Content-Type: application/json", f"Content-Length: {len(data)}"]
    raw = ("\r\n".join(lines) + "\r\n\r\n").encode() + data
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.settimeout(10)
    sock.connect(SOCKET_PATH)
    sock.sendall(raw)
    chunks = []
    while True:
        try:
            chunk = sock.recv(65536)
        except socket.timeout:
            break
        if not chunk:
            break
        chunks.append(chunk)
    response = b"".join(chunks)
    headers, _, body_bytes = response.partition(b"\r\n\r\n")
    header_text = headers.decode("utf-8", "replace")
    status_line = header_text.split("\r\n", 1)[0]
    return status_line, decode_body(header_text, body_bytes)


def get_proxies():
    status, body = mihomo_request("GET", "/proxies")
    if "200" not in status:
        raise RuntimeError(status)
    return json.loads(body)["proxies"]


def node_delay(name, timeout_ms=3500):
    path = "/proxies/{}/delay?timeout={}&url={}".format(
        urllib.parse.quote(name, safe=""),
        timeout_ms,
        urllib.parse.quote(TEST_URL, safe=""),
    )
    status, body = mihomo_request("GET", path)
    if "200" not in status:
        return None
    try:
        data = json.loads(body)
    except json.JSONDecodeError:
        return None
    delay = data.get("delay")
    return int(delay) if isinstance(delay, (int, float)) and delay > 0 else None


def select_node(group, node):
    path = "/proxies/" + urllib.parse.quote(group, safe="")
    status, _ = mihomo_request("PUT", path, {"name": node})
    return "204" in status


def choose_best_node(proxies):
    group = proxies.get("PROXY") or proxies.get("AUTO-US-SG")
    if not group:
        return None, []
    candidates = [
        name
        for name in group.get("all", [])
        if name not in {"DIRECT", "REJECT"} and name in proxies and not proxies[name].get("all")
    ]
    results = []
    for name in candidates:
        delay = node_delay(name)
        if delay is not None:
            results.append({"name": name, "delay": delay})
    results.sort(key=lambda item: item["delay"])
    return (results[0] if results else None), results[:8]


def maybe_switch(best_latency):
    if best_latency and best_latency["ms"] <= THRESHOLD_MS:
        return {"switched": False, "reason": "latency-ok"}
    proxies = get_proxies()
    current = {
        group: proxies.get(group, {}).get("now")
        for group in SWITCH_GROUPS
        if proxies.get(group)
    }
    best_node, top = choose_best_node(proxies)
    if not best_node:
        return {"switched": False, "reason": "no-node", "current": current}
    changed = {}
    for group in SWITCH_GROUPS:
        if group in proxies and best_node["name"] in proxies[group].get("all", []):
            changed[group] = select_node(group, best_node["name"])
    time.sleep(1)
    return {
        "switched": any(changed.values()),
        "reason": "latency-bad",
        "current": current,
        "selected": best_node,
        "top": top,
        "groups": changed,
    }


def main():
    before, port_results = best_proxy_latency()
    switch = maybe_switch(before)
    after, _ = best_proxy_latency()
    file_cf = curl_timing(CLOUDFLARE_FILE, head=True)
    sub_cf = curl_timing(CLOUDFLARE_SUB2API, head=True)

    print("network_guard_result")
    if before:
        print(f"before_proxy port={before['port']} http={before['http']} ms={before['ms']}")
    else:
        print(f"before_proxy unavailable results={port_results}")
    print("switch=" + json.dumps(switch, ensure_ascii=False))
    if after:
        print(f"after_proxy port={after['port']} http={after['http']} ms={after['ms']} ok400={after['ms'] <= THRESHOLD_MS}")
    else:
        print("after_proxy unavailable")
    print(f"file_cloudflare http={file_cf.get('http')} ms={file_cf.get('ms')} ok={file_cf.get('ok')}")
    print(f"sub2api_cloudflare http={sub_cf.get('http')} ms={sub_cf.get('ms')} ok={sub_cf.get('ok')}")
    return 0 if after and after["ms"] <= THRESHOLD_MS and file_cf.get("ok") and sub_cf.get("ok") else 1


if __name__ == "__main__":
    sys.exit(main())
