#!/bin/bash
R='\033[31m'; G='\033[32m'; Y='\033[33m'; B='\033[34m'; C='\033[36m'; W='\033[37m'; N='\033[0m'
BOLD='\033[1m'
DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.xray-patched"
IS_TERMUX="false"
[ -d /data/data/com.termux ] && IS_TERMUX="true"

echo -e "${BOLD}${C}[*] Installing Xray Patched...${N}\n"

# 1. Binary
echo -e "${Y}[1/6]${N} Setting up binary..."
if [ -f "$DIR/xray-patched" ]; then
  cp "$DIR/xray-patched" "$BIN" 2>/dev/null
  chmod +x "$BIN" 2>/dev/null
  echo -e "  ${G}✓${N} Binary: $BIN"
else
  echo -e "  ${R}✗${N} xray-patched not found in $DIR"
  exit 1
fi

# 2. Config files
echo -e "${Y}[2/6]${N} Generating config files..."
cd "$DIR"

# config.yaml — auto-gen via binary if missing
if [ ! -f config.yaml ]; then
  "$BIN" webscan --url http://example.com &>/dev/null &
  PID=$!; sleep 3; kill $PID 2>/dev/null
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
[ -f config.yaml ] && echo -e "  ${G}✓${N} config.yaml"

# xray.yaml / module.xray.yaml / plugin.xray.yaml
python3 -c "
import yaml
d=yaml.dump
with open('xray.yaml','w') as f: d([{'name':'x','description':'All plugins','enabled_plugins':['printer','service-scan','target-parser','vuln-scan'],'disabled_plugins':[],'plugin_path':['./plugin'],'module_config':'module.xray.yaml','plugin_config':'plugin.xray.yaml'}],f,default_flow_style=False)
m={'Client':{'allow_methods':['HEAD','GET','POST','PUT','PATCH','DELETE','OPTIONS','CONNECT','TRACE'],'dial_timeout':5,'enable_http2':False,'fail_retries':0,'headers':{},'max_conns_per_host':50,'max_qps':500,'max_redirect':5,'max_resp_body_size':2097152.0,'passive_mode':False,'pkcs12':{'Password':'','Path':''},'proxy':'','proxy_rule':None,'read_timeout':10},'Pool':{'size':100},'Reverse':{'client':{'dns_server_ip':'','http_base_url':'','remote_server':False,'reverse_api':'','reverse_server_url':'','rmi_server_addr':''},'db_file_path':'','token':'','dns':{'enabled':False,'domain':'','is_domain_name_server':False,'listen_ip':'0.0.0.0','resolve':[{'record':'localhost','ttl':60,'type':'A','value':'127.0.0.1'}]},'http':{'enabled':False,'ip_header':'','listen_ip':'0.0.0.0','listen_port':''},'rmi':{'enabled':False,'listen_ip':'127.0.0.1','listen_port':''}}}
with open('module.xray.yaml','w') as f: d(m,f,default_flow_style=False)
p={'printer':{'disable_host_print':False,'disable_port_print':False,'disable_service_print':False,'disable_website_print':False},'service-scan':{'bandwidth':1000,'flag':{'bandwidth':'bandwidth,bw','max_service_per_host':'max-srv,ms','port':'port,p','skip_fingerprint':'skip-fingerprint,sf','skip_live':'skip-live,sl','skip_syn':'skip-syn,ss','skip_web_fingerprint':'skip-web,sw','timeout':'timeout'},'max_service_per_host':0,'port':'22,80,443','skip_fingerprint':False,'skip_live':False,'skip_syn':False,'skip_web_fingerprint':False,'timeout':2},'target-parser':{'flag':{'target':'target,t'},'group_size':256,'target':''},'vuln-scan':{'config_file':'config.yaml','flag':{'config_file':'config','html_output':'html-output,ho','json_output':'json_output,jo','level':'level','log_level':'log-level','plugins':'plugins','poc':'poc','stdout':'stdout','tags':'tags','text_output':'text-output,to','webhook_output':'webhook-output,wo'},'html_output':'','json_output':'','level':'','log_level':'','plugins':'','poc':'','stdout':True,'tags':'','text_output':'','webhook_output':''}}
with open('plugin.xray.yaml','w') as f: d(p,f,default_flow_style=False)
" 2>/dev/null
echo -e "  ${G}✓${N} xray.yaml, module.xray.yaml, plugin.xray.yaml"

# 3. Directories
echo -e "${Y}[3/6]${N} Creating directories..."
mkdir -p "$DIR/reports" "$DIR/poc" "$DIR/lists"
echo -e "  ${G}✓${N} reports/ poc/ lists/"

# 4. Install dependencies (any package manager)
echo -e "${Y}[4/6]${N} Installing dependencies..."
PM=""
PKGS_PYTHON=""; PKGS_PIP=""; PKGS_EXPLOIT=""
if $IS_TERMUX && command -v pkg &>/dev/null; then
  PM="pkg install -y"; PKGS_PYTHON="python"; PKGS_PIP=""; PKGS_EXPLOIT="exploitdb"
elif command -v apt &>/dev/null; then
  PM="apt install -y"; PKGS_PYTHON="python3"; PKGS_PIP="python3-pip"; PKGS_EXPLOIT="exploitdb"
elif command -v dnf &>/dev/null; then
  PM="dnf install -y"; PKGS_PYTHON="python3"; PKGS_PIP="python3-pip"; PKGS_EXPLOIT="exploitdb"
elif command -v yum &>/dev/null; then
  PM="yum install -y"; PKGS_PYTHON="python3"; PKGS_PIP="python3-pip"; PKGS_EXPLOIT="exploitdb"
elif command -v pacman &>/dev/null; then
  PM="pacman -S --noconfirm"; PKGS_PYTHON="python"; PKGS_PIP="python-pip"; PKGS_EXPLOIT="exploitdb"
elif command -v zypper &>/dev/null; then
  PM="zypper install -y"; PKGS_PYTHON="python3"; PKGS_PIP="python3-pip"; PKGS_EXPLOIT="exploitdb"
elif command -v apk &>/dev/null; then
  PM="apk add"; PKGS_PYTHON="python3"; PKGS_PIP="py3-pip"; PKGS_EXPLOIT=""
fi
if [ -n "$PM" ]; then
  $PM $PKGS_PYTHON $PKGS_PIP $PKGS_EXPLOIT 2>/dev/null || true
fi
pip3 install pyyaml 2>/dev/null || true
echo -e "  ${G}✓${N} Dependencies ready"

# 5. Shortcut / symlink
echo -e "${Y}[5/6]${N} Creating shortcut..."
if $IS_TERMUX; then
  SHORTCUT="/data/data/com.termux/files/usr/bin/xray"
  cat > "$SHORTCUT" << 'SHEOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/xray-menu.sh" ]; then
  bash "$SCRIPT_DIR/xray-menu.sh"
else
  echo "Xray patched not found"
  exit 1
fi
SHEOF
  chmod +x "$SHORTCUT" 2>/dev/null
  echo -e "  ${G}✓${N} Run with: ${BOLD}xray${N} (Termux)"
else
  ln -sf "$DIR/xray" /usr/local/bin/xray 2>/dev/null
  ln -sf "$DIR/xray-menu.sh" /usr/local/bin/xray-menu 2>/dev/null
  echo -e "  ${G}✓${N} Run with: ${BOLD}xray${N} or ${BOLD}xray-menu${N} (/usr/local/bin)"
fi

# 6. Set executable permissions
echo -e "${Y}[6/6]${N} Finalizing..."
chmod +x "$DIR/xray" "$DIR/xray-webui" "$DIR/xray-tools" 2>/dev/null
echo ""

echo -e "${BOLD}${G}✓ INSTALLATION COMPLETE${N}"
echo -e "${W}  Repo  :${N} $DIR"
echo -e "${W}  Binary:${N} $BIN"
echo -e "${W}  Menu  :${N} ${BOLD}xray-menu${N} or bash $DIR/xray-menu.sh"
echo -e "${W}  CLI   :${N} ${BOLD}xray${N} or bash $DIR/xray [command]"
