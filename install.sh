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
echo -e "${Y}[2/5]${N} Generating config..."
cd "$DIR"
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
  echo -e "  ${G}✓${N} Config ready (reverse server ON)"
else
  echo -e "  ${Y}!${N} Config not generated, run menu and scan once"
fi

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
echo -e "${Y}[5/5]${N} Finalizing..."
echo ""
echo -e "${BOLD}${G}✓ INSTALLATION COMPLETE${N}"
echo -e "${W}  Repo  :${N} $DIR"
echo -e "${W}  Binary:${N} $BIN"
echo -e "${W}  Menu  :${N} bash $DIR/xray-menu.sh"
echo -e "${W}  Short :${N} xray"
echo ""
