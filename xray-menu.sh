#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

XRAY_CACHE="/data/data/com.termux/files/home/.xray-patched"
if [ ! -x "$XRAY_CACHE" ]; then
  cp "$SCRIPT_DIR/xray-patched" "$XRAY_CACHE" 2>/dev/null
  chmod +x "$XRAY_CACHE" 2>/dev/null
fi
if [ -x "$XRAY_CACHE" ]; then
  XRAY="$XRAY_CACHE"
else
  XRAY="$SCRIPT_DIR/xray-patched"
fi
REPORT_DIR="$SCRIPT_DIR/reports"
POC_DIR="$SCRIPT_DIR/poc"
LIST_DIR="$SCRIPT_DIR/lists"

R='\033[31m'; G='\033[32m'; Y='\033[33m'; B='\033[34m'
M='\033[35m'; C='\033[36m'; W='\033[37m'; N='\033[0m'
BOLD='\033[1m'

mkdir -p "$REPORT_DIR" "$LIST_DIR"

show_banner() {
  echo -e "${R}____  ___.________.    ____.   _____.___.${N}"
  echo -e "${Y}\\   \\/  /\\_   __   \\  /  _  \\  \\__  |   |${N}"
  echo -e "${G} \\     /  |    _  _/ /  /_\\  \\  /   |   |${N}"
  echo -e "${C} /     \\  |    |   \\/    |    \\ \\____   |${N}"
  echo -e "${B}\\___/\\  \\ |____|   /\\____|_   / / _____/${N}"
  echo -e "${M}      \\_/       \\_/        \\_/  \\/${N}"
  echo ""
  echo -e "${BOLD}${C}Version:${N} ${W}1.9.11/eb0c331d/ADVANCED${N}"
  echo ""
  echo -e "${BOLD}${R}Author:${N} ${Y}Arif${N} ${W}(${R}hacked${Y} by${G} arif${R}😹${W})${N}"
  echo ""
}

show_menu() {
  echo -e "  ${R} 1)${N}  ${W}webscan${N}         ${C}-${N} Scan website tunggal"
  echo -e "  ${Y} 2)${N}  ${W}servicescan${N}      ${C}-${N} Scan service/port"
  echo -e "  ${G} 3)${N}  ${W}subdomain${N}        ${C}-${N} Scan subdomain"
  echo -e "  ${C} 4)${N}  ${W}x${N}                ${C}-${N} Scan semua plugin"
  echo -e "  ${B} 5)${N}  ${W}webscan massal${N}   ${C}-${N} Scan dari file list"
  echo -e "  ${M} 6)${N}  ${W}schedule scan${N}    ${C}-${N} Scan otomatis berulang"
  echo -e "  ${R} 7)${N}  ${W}poclint${N}           ${C}-${N} Validasi POC yaml"
  echo -e "  ${Y} 8)${N}  ${W}reverse${N}           ${C}-${N} Jalankan reverse server"
  echo -e "  ${G} 9)${N}  ${W}genca${N}             ${C}-${N} Generate CA"
  echo -e "  ${C}10)${N}  ${W}version${N}           ${C}-${N} Tampilkan versi"
  echo -e "  ${B}11)${N}  ${W}convert${N}           ${C}-${N} Convert hasil scan"
  echo -e "  ${M}12)${N}  ${W}burp-gamma${N}        ${C}-${N} Convert Burp export"
  echo -e "  ${R}13)${N}  ${W}transform${N}         ${C}-${N} Transform script"
  echo -e "  ${Y}14)${N}  ${W}update POC${N}        ${C}-${N} Download POCs terbaru"
  echo -e "  ${G}15)${N}  ${W}upgrade${N}           ${C}-${N} Update Xray"
  echo -e "  ${R} 0)${N}  ${W}Keluar${N}"
  echo ""
}

webscan_single() {
  echo -ne "${C}URL target${N}: "; read url
  [ -z "$url" ] && return
  ts=$(date +%Y%m%d-%H%M%S)
  outfile="$REPORT_DIR/webscan-$ts.html"
  echo -e "${Y}Output: $outfile${N}"
  cd "$SCRIPT_DIR" && $XRAY webscan --url "$url" --html-output "$outfile"
  echo -e "${G}Selesai. Hasil: $outfile${N}"
}

servicescan_menu() {
  echo -ne "${C}Target (host:port)${N}: "; read target
  [ -z "$target" ] && return
  echo -ne "${C}Module (default: weblogic)${N}: "; read module
  module=${module:-weblogic}
  cd "$SCRIPT_DIR" && $XRAY servicescan --target "$target" --module "$module"
}

subdomain_menu() {
  echo -ne "${C}Domain${N}: "; read domain
  [ -z "$domain" ] && return
  ts=$(date +%Y%m%d-%H%M%S)
  outfile="$REPORT_DIR/subdomain-$ts.html"
  cd "$SCRIPT_DIR" && $XRAY subdomain --target "$domain" --html-output "$outfile"
  echo -e "${G}Selesai. Hasil: $outfile${N}"
}

x_scan() {
  echo -ne "${C}URL target${N}: "; read url
  [ -z "$url" ] && return
  ts=$(date +%Y%m%d-%H%M%S)
  outfile="$REPORT_DIR/fullscan-$ts.html"
  echo -e "${Y}Output: $outfile${N}"
  cd "$SCRIPT_DIR" && $XRAY x --url "$url" --html-output "$outfile"
  echo -e "${G}Selesai. Hasil: $outfile${N}"
}

webscan_massal() {
  echo -ne "${C}File list (1 URL/baris)${N}: "; read listfile
  [ -z "$listfile" ] && return
  [ ! -f "$listfile" ] && echo -e "${R}File tidak ditemukan${N}" && return
  total=$(wc -l < "$listfile")
  echo -e "${Y}Total target: $total${N}"
  i=0
  while IFS= read -r url; do
    [ -z "$url" ] && continue
    i=$((i+1))
    ts=$(date +%Y%m%d-%H%M%S)
    safe=$(echo "$url" | sed 's|https\?://||;s|[/:]|_|g')
    outfile="$REPORT_DIR/massal-${i}-${safe}-$ts.html"
    echo -e "${B}[$i/$total]${N} Scanning: ${C}$url${N}"
    cd "$SCRIPT_DIR" && $XRAY webscan --url "$url" --html-output "$outfile" 2>/dev/null
    echo -e "${G}  -> $outfile${N}"
  done < "$listfile"
  echo -e "${G}=== SEMUA SELESAI === ${total} target${N}"
}

schedule_scan() {
  echo -ne "${C}URL target${N}: "; read url
  [ -z "$url" ] && return
  echo -ne "${C}Interval (detik, default: 3600)${N}: "; read interval
  interval=${interval:-3600}
  echo -ne "${C}Jumlah scan (0 = unlimited)${N}: "; read count
  count=${count:-0}
  echo -e "${Y}Schedule: setiap ${interval}s, $count kali${N}"
  c=0
  while true; do
    [ "$count" -gt 0 ] && [ "$c" -ge "$count" ] && break
    c=$((c+1))
    ts=$(date +%Y%m%d-%H%M%S)
    outfile="$REPORT_DIR/schedule-${c}-$ts.html"
    echo -e "${B}[$c]${N} Scanning: ${C}$url${N} ${Y}$(date)${N}"
    cd "$SCRIPT_DIR" && $XRAY webscan --url "$url" --html-output "$outfile" 2>/dev/null
    echo -e "${G}  -> $outfile${N}"
    echo -e "${Y}  -> Next: ${interval}s${N}"
    if [ "$count" -le 0 ] || [ "$c" -lt "$count" ]; then
      sleep "$interval"
    fi
  done
  echo -e "${B}=== SCHEDULE SELESAI ===${N}"
}

validate_poc() {
  echo -ne "${C}POC file/pattern${N}: "; read pattern
  [ -z "$pattern" ] && return
  cd "$SCRIPT_DIR" && $XRAY poclint --script "$pattern"
}

start_reverse() {
  echo -e "${Y}Starting reverse server...${N}"
  echo -e "${W}Pastikan config.yaml sudah di-set.${N}"
  cd "$SCRIPT_DIR" && $XRAY reverse
}

gen_ca() {
  cd "$SCRIPT_DIR" && $XRAY genca
  echo -e "${G}CA cert: $SCRIPT_DIR/ca.crt${N}"
  echo -e "${G}CA key:  $SCRIPT_DIR/ca.key${N}"
}

show_version() {
  cd "$SCRIPT_DIR" && $XRAY version
}

convert_file() {
  echo -ne "${C}File input (json/html)${N}: "; read input
  [ -z "$input" ] && return
  echo -ne "${C}File output${N}: "; read output
  cd "$SCRIPT_DIR" && $XRAY convert "$input" "$output"
}

burp_convert() {
  echo -ne "${C}File export Burp${N}: "; read file
  [ -z "$file" ] && return
  echo -ne "${C}Output POC${N}: "; read output
  cd "$SCRIPT_DIR" && $XRAY burp-gamma "$file" "$output"
}

transform_script() {
  echo -ne "${C}File input${N}: "; read input
  [ -z "$input" ] && return
  echo -ne "${C}Output${N}: "; read output
  cd "$SCRIPT_DIR" && $XRAY transform "$input" "$output"
}

update_poc() {
  echo -e "${Y}Download POC terbaru dari github...${N}"
  mkdir -p "$POC_DIR"
  echo -e "${W}Clone repo POC xray...${N}"
  if [ -d "$POC_DIR/.git" ]; then
    cd "$POC_DIR" && git pull
  else
    git clone --depth 1 https://github.com/ARIFxVOID/xray-patched.git "$POC_DIR" 2>/dev/null || \
    git clone --depth 1 https://github.com/chaitin/xray.git /tmp/xray-pocs 2>/dev/null && \
    cp -r /tmp/xray-pocs/pocs/* "$POC_DIR/" 2>/dev/null
  fi
  total=$(find "$POC_DIR" -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
  echo -e "${G}Total POC: $total${N}"
}

upgrade_xray() {
  echo -e "${Y}Upgrade Xray...${N}"
  cd "$SCRIPT_DIR" && $XRAY upgrade
}

while true; do
  clear
  show_banner
  show_menu
  echo -ne "${BOLD}${Y}Pilih menu [0-15]:${N} "
  read pilihan

  case $pilihan in
    1) webscan_single ;;
    2) servicescan_menu ;;
    3) subdomain_menu ;;
    4) x_scan ;;
    5) webscan_massal ;;
    6) schedule_scan ;;
    7) validate_poc ;;
    8) start_reverse ;;
    9) gen_ca ;;
    10) show_version ;;
    11) convert_file ;;
    12) burp_convert ;;
    13) transform_script ;;
    14) update_poc ;;
    15) upgrade_xray ;;
    0) echo -e "${R}Keluar...${N}"; exit 0 ;;
    *) echo -e "${R}Pilihan tidak valid!${N}" ;;
  esac

  if [ "$pilihan" != "0" ] && [ "$pilihan" != "10" ]; then
    echo ""
    echo -ne "${BOLD}${Y}Tekan Enter untuk kembali...${N}"
    read
  fi
done
