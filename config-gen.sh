#!/bin/bash
# Shared config generator for xray-patched
# Generates xray.yaml, module.xray.yaml, plugin.xray.yaml if missing.
# Usage: bash config-gen.sh <target_dir>
TARGET="${1:-$(cd "$(dirname "$0")" && pwd)}"

[ -f "$TARGET/xray.yaml" ] && exit 0

cat > "$TARGET/xray.yaml" << 'EOF'
- description: All plugins
  disabled_plugins: []
  enabled_plugins:
  - printer
  - service-scan
  - target-parser
  - vuln-scan
  module_config: module.xray.yaml
  name: x
  plugin_config: plugin.xray.yaml
  plugin_path:
  - ./plugin
EOF

cat > "$TARGET/module.xray.yaml" << 'EOF'
Client:
  allow_methods:
  - HEAD
  - GET
  - POST
  - PUT
  - PATCH
  - DELETE
  - OPTIONS
  - CONNECT
  - TRACE
  dial_timeout: 5
  enable_http2: false
  fail_retries: 0
  headers: {}
  max_conns_per_host: 50
  max_qps: 500
  max_redirect: 5
  max_resp_body_size: 2.097152e+06
  passive_mode: false
  pkcs12:
    Password: ""
    Path: ""
  proxy: ""
  proxy_rule: null
  read_timeout: 10
Pool:
  size: 100
Reverse:
  client:
    dns_server_ip: ""
    http_base_url: ""
    remote_server: false
    reverse_api: ""
    reverse_server_url: ""
    rmi_server_addr: ""
  db_file_path: ""
  dns:
    domain: ""
    enabled: false
    is_domain_name_server: false
    listen_ip: 0.0.0.0
    resolve:
    - record: localhost
      ttl: 60
      type: A
      value: 127.0.0.1
  http:
    enabled: false
    ip_header: ""
    listen_ip: 0.0.0.0
    listen_port: ""
  rmi:
    enabled: false
    listen_ip: 127.0.0.1
    listen_port: ""
  token: ""
EOF

cat > "$TARGET/plugin.xray.yaml" << 'EOF'
printer:
  disable_host_print: false
  disable_port_print: false
  disable_service_print: false
  disable_website_print: false
service-scan:
  bandwidth: 1000
  flag:
    bandwidth: bandwidth,bw
    max_service_per_host: max-srv,ms
    port: port,p
    skip_fingerprint: skip-fingerprint,sf
    skip_live: skip-live,sl
    skip_syn: skip-syn,ss
    skip_web_fingerprint: skip-web,sw
    timeout: timeout
  max_service_per_host: 0
  port: 22,80,443
  skip_fingerprint: false
  skip_live: false
  skip_syn: false
  skip_web_fingerprint: false
  timeout: 2
target-parser:
  flag:
    target: target,t
  group_size: 256
  target: ""
vuln-scan:
  config_file: config.yaml
  flag:
    config_file: config
    html_output: html-output,ho
    json_output: json_output,jo
    level: level
    log_level: log-level
    plugins: plugins
    poc: poc
    stdout: stdout
    tags: tags
    text_output: text-output,to
    webhook_output: webhook-output,wo
  html_output: ""
  json_output: ""
  level: ""
  log_level: ""
  plugins: ""
  poc: ""
  stdout: true
  tags: ""
  text_output: ""
  webhook_output: ""
EOF
