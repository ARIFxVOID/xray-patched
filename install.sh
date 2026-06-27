#!/bin/bash
R='\033[31m'; G='\033[32m'; Y='\033[33m'; B='\033[34m'; C='\033[36m'; W='\033[37m'; N='\033[0m'
BOLD='\033[1m'

DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"
BIN="$HOME_DIR/.xray-patched"

echo -e "${BOLD}${C}[*] Installing Xray Patched...${N}"
echo ""

# 1. Binary
echo -e "${Y}[1/5]${N} Setting up binary..."
if [ -f "$DIR/xray-patched" ]; then
  cp "$DIR/xray-patched" "$BIN" 2>/dev/null
  chmod +x "$BIN" 2>/dev/null
  echo -e "  ${G}✓${N} Binary copied to $BIN"
else
  echo -e "  ${R}✗${N} xray-patched not found!"
  exit 1
fi

# 2. Config
echo -e "${Y}[2/5]${N} Generating config files..."
cd "$DIR"
# config.yaml (vuln-scan settings)
if [ ! -f config.yaml ]; then
  "$BIN" webscan --url http://example.com &>/dev/null &
  PID=$!
  sleep 3
  kill $PID 2>/dev/null
fi
if [ -f config.yaml ]; then
  python3 -c "
import yaml
with open('config.yaml') as f: cfg = yaml.safe_load(f)
cfg.setdefault('reverse', {})
cfg['reverse']['http'] = {'enabled': True, 'listen_ip': '0.0.0.0', 'listen_port': '9999'}
cfg['reverse']['dns'] = {'enabled': True, 'listen_ip': '0.0.0.0', 'listen_port': '5353'}
cfg['reverse']['rmi'] = {'enabled': True, 'listen_ip': '0.0.0.0', 'listen_port': '1099'}
cfg['reverse']['token'] = 'xray-reverse-token'
with open('config.yaml', 'w') as f: yaml.dump(cfg, f, default_flow_style=False)
" 2>/dev/null
fi

# xray.yaml / module.xray.yaml / plugin.xray.yaml (command & plugin config)
python3 -c "
import yaml
# xray.yaml
xray_cfg = [{
    'name': 'x',
    'description': 'A command that enables all plugins.',
    'enabled_plugins': ['printer','service-scan','target-parser','vuln-scan'],
    'disabled_plugins': [],
    'plugin_path': ['./plugin'],
    'module_config': 'module.xray.yaml',
    'plugin_config': 'plugin.xray.yaml'
}]
with open('xray.yaml', 'w') as f: yaml.dump(xray_cfg, f, default_flow_style=False)

# module.xray.yaml
module_cfg = {
    'Client': {
        'allow_methods': ['HEAD','GET','POST','PUT','PATCH','DELETE','OPTIONS','CONNECT','TRACE'],
        'dial_timeout': 5, 'enable_http2': False, 'fail_retries': 0,
        'headers': {}, 'max_conns_per_host': 50, 'max_qps': 500,
        'max_redirect': 5, 'max_resp_body_size': 2097152.0,
        'passive_mode': False, 'pkcs12': {'Password': '', 'Path': ''},
        'proxy': '', 'proxy_rule': None, 'read_timeout': 10
    },
    'Pool': {'size': 100},
    'Reverse': {
        'client': {'dns_server_ip': '', 'http_base_url': '', 'remote_server': False,
                   'reverse_api': '', 'reverse_server_url': '', 'rmi_server_addr': ''},
        'db_file_path': '', 'token': '',
        'dns': {'enabled': False, 'domain': '', 'is_domain_name_server': False,
                'listen_ip': '0.0.0.0', 'resolve': [{'record':'localhost','ttl':60,'type':'A','value':'127.0.0.1'}]},
        'http': {'enabled': False, 'ip_header': '', 'listen_ip': '0.0.0.0', 'listen_port': ''},
        'rmi': {'enabled': False, 'listen_ip': '127.0.0.1', 'listen_port': ''}
    }
}
with open('module.xray.yaml', 'w') as f: yaml.dump(module_cfg, f, default_flow_style=False)

# plugin.xray.yaml
plugin_cfg = {
    'printer': {'disable_host_print': False, 'disable_port_print': False,
                'disable_service_print': False, 'disable_website_print': False},
    'service-scan': {'bandwidth': 1000,
        'flag': {'bandwidth':'bandwidth,bw','max_service_per_host':'max-srv,ms',
                 'port':'port,p','skip_fingerprint':'skip-fingerprint,sf',
                 'skip_live':'skip-live,sl','skip_syn':'skip-syn,ss',
                 'skip_web_fingerprint':'skip-web,sw','timeout':'timeout'},
        'max_service_per_host': 0, 'port': '22,80,443',
        'skip_fingerprint': False, 'skip_live': False, 'skip_syn': False,
        'skip_web_fingerprint': False, 'timeout': 2},
    'target-parser': {'flag': {'target':'target,t'}, 'group_size': 256, 'target': ''},
    'vuln-scan': {'config_file': 'config.yaml',
        'flag': {'config_file':'config','html_output':'html-output,ho',
                 'json_output':'json_output,jo','level':'level','log_level':'log-level',
                 'plugins':'plugins','poc':'poc','stdout':'stdout','tags':'tags',
                 'text_output':'text-output,to','webhook_output':'webhook-output,wo'},
        'html_output': '', 'json_output': '', 'level': '', 'log_level': '',
        'plugins': '', 'poc': '', 'stdout': True, 'tags': '',
        'text_output': '', 'webhook_output': ''}
}
with open('plugin.xray.yaml', 'w') as f: yaml.dump(plugin_cfg, f, default_flow_style=False)
" 2>/dev/null

echo -e "  ${G}✓${N} Config files ready (xray.yaml, module.xray.yaml, plugin.xray.yaml)"

# 3. Directories
echo -e "${Y}[3/5]${N} Creating directories..."
mkdir -p "$DIR/reports" "$DIR/poc" "$DIR/lists"
echo -e "  ${G}✓${N} reports/ poc/ lists/"

# 4. Termux shortcut
echo -e "${Y}[4/5]${N} Creating shortcut..."
if [ -d /data/data/com.termux ]; then
  SHORTCUT="/data/data/com.termux/files/usr/bin/xray"
  cat > "$SHORTCUT" << 'SHEOF'
#!/bin/bash
SCRIPT_DIR="/storage/emulated/0/xray"
if [ -f "$SCRIPT_DIR/xray-menu.sh" ]; then
  bash "$SCRIPT_DIR/xray-menu.sh"
else
  echo "Xray patched not found"
  exit 1
fi
SHEOF
  chmod +x "$SHORTCUT" 2>/dev/null
  echo -e "  ${G}✓${N} Run with: ${BOLD}xray${N}"
fi

# 5. Done
# 5. Install dependencies
echo -e "${Y}[5/6]${N} Installing dependencies..."
if command -v pkg &>/dev/null; then
  pkg install -y python python-pip exploitdb 2>/dev/null || true
elif command -v apt &>/dev/null; then
  apt install -y python3 python3-pip exploitdb 2>/dev/null || true
fi
pip3 install pyyaml 2>/dev/null || true
echo -e "  ${G}✓${N} Dependencies ready"

# 6. Make CLI executable
echo -e "${Y}[6/6]${N} Finalizing..."
chmod +x "$DIR/xray" 2>/dev/null
chmod +x "$DIR/xray-webui" 2>/dev/null
echo ""
echo -e "${BOLD}${G}✓ INSTALLATION COMPLETE${N}"
echo -e "${W}  Repo  :${N} $DIR"
echo -e "${W}  Binary:${N} $BIN"
echo -e "${W}  Menu  :${N} bash $DIR/xray-menu.sh"
echo -e "${W}  Short :${N} xray"
echo ""
