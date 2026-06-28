#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

XRAY_CACHE="$HOME/.xray-patched"
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

bash "$SCRIPT_DIR/config-gen.sh" "$SCRIPT_DIR" 2>/dev/null
bash "$SCRIPT_DIR/config-gen.sh" "$HOME" 2>/dev/null

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
  echo -e "  ${B} 5)${N}  ${W}POC builder${N}      ${C}-${N} Buat/validasi POC"
  echo -e "  ${M} 6)${N}  ${W}CVE lookup${N}       ${C}-${N} Cari detail CVE"
  echo -e "  ${R} 7)${N}  ${W}searchsploit${N}     ${C}-${N} Cari exploit DB"
  echo -e "  ${Y} 8)${N}  ${W}diff scan${N}         ${C}-${N} Banding hasil scan"
  echo -e "  ${G} 9)${N}  ${W}auto exploit${N}      ${C}-${N} Scan + exploit target"
  echo -e "  ${C}10)${N}  ${W}summary${N}           ${C}-${N} Gabung hasil scan"
  echo -e "  ${B}11)${N}  ${W}web UI${N}            ${C}-${N} Dashboard browser"
  echo -e "  ${M}12)${N}  ${W}update POC${N}        ${C}-${N} Download POCs terbaru"
  echo -e "  ${R}13)${N}  ${W}poclint${N}           ${C}-${N} Validasi POC yaml"
  echo -e "  ${Y}14)${N}  ${W}reverse${N}           ${C}-${N} Jalankan reverse server"
  echo -e "  ${G}15)${N}  ${W}genca${N}             ${C}-${N} Generate CA"
  echo -e "  ${C}16)${N}  ${W}version${N}           ${C}-${N} Tampilkan versi"
  echo -e "  ${B}17)${N}  ${W}convert${N}           ${C}-${N} Convert hasil scan"
  echo -e "  ${M}18)${N}  ${W}burp-gamma${N}        ${C}-${N} Convert Burp export"
  echo -e "  ${R}19)${N}  ${W}transform${N}         ${C}-${N} Transform script"
  echo -e "  ${Y}20)${N}  ${W}schedule scan${N}    ${C}-${N} Scan otomatis berulang"
  echo -e "  ${G}21)${N}  ${W}webscan massal${N}   ${C}-${N} Scan dari file list"
  echo -e "  ${B}22)${N}  ${W}install${N}           ${C}-${N} Setup tools"
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
  echo -e "${Y}Download POC terbaru dari chaitin/xray...${N}"
  mkdir -p "$POC_DIR"
  rm -rf /tmp/xray-pocs 2>/dev/null
  git clone --depth 1 https://github.com/chaitin/xray.git /tmp/xray-pocs 2>/dev/null
  if [ -d /tmp/xray-pocs/pocs ]; then
    cp -r /tmp/xray-pocs/pocs/* "$POC_DIR/" 2>/dev/null
    rm -rf /tmp/xray-pocs
    echo -e "${G}✓ POC berhasil diupdate${N}"
  else
    echo -e "${R}✗ Gagal clone repo POC${N}"
  fi
  total=$(find "$POC_DIR" -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
  echo -e "${G}Total POC: $total${N}"
}

upgrade_xray() {
  echo -e "${Y}Upgrade Xray...${N}"
  cd "$SCRIPT_DIR" && $XRAY upgrade
}

poc_builder() {
  echo -e "${BOLD}${C}POC Builder${N}"
  echo "  1) Buat POC baru (template)"
  echo "  2) Validasi POC"
  echo "  3) Lihat daftar POC"
  echo -ne "${C}Pilih [1-3]:${N} "; read sub
  case $sub in
    1)
      echo -ne "${C}Nama POC${N}: "; read name
      [ -z "$name" ] && return
      safe=$(echo "$name" | sed 's/[^a-zA-Z0-9_-]/-/g')
      file="$POC_DIR/${safe}.yaml"
      cat > "$file" << POCEOF
name: $name
rules:
  r0:
    request:
      method: GET
      path: "/"
    expression: "true"
detail:
  author: Arif
  links: []
POCEOF
      echo -e "${G}✓ POC created: $file${N}"
      echo -ne "${C}Validate sekarang? [y/N]${N}: "; read val
      if [ "$val" = "y" ] || [ "$val" = "Y" ]; then
        cd "$SCRIPT_DIR" && $XRAY poclint --script "$file"
      fi
      ;;
    2)
      echo -ne "${C}POC file/path${N}: "; read pattern
      [ -z "$pattern" ] && return
      cd "$SCRIPT_DIR" && $XRAY poclint --script "$pattern"
      ;;
    3)
      echo -e "${Y}POC list:${N}"
      find "$POC_DIR" -name "*.yaml" -o -name "*.yml" 2>/dev/null | while read f; do
        name=$(grep -m1 "^name:" "$f" 2>/dev/null | sed 's/name: *//')
        echo -e "  ${C}$(basename $f)${N} - ${W}$name${N}"
      done
      total=$(find "$POC_DIR" -name "*.yaml" -o -name "*.yml" 2>/dev/null | wc -l)
      echo -e "${B}Total: $total POC${N}"
      ;;
  esac
}

summary_report() {
  echo -e "${BOLD}${C}Summary Report${N}"
  echo -e "${Y}Menggabungkan semua laporan di $REPORT_DIR...${N}"
  ts=$(date +%Y%m%d-%H%M%S)
  summary="$REPORT_DIR/summary-$ts.html"
  cat > "$summary" << HTMLEOF
<!DOCTYPE html><html><head><title>Xray Summary Report</title>
<style>body{font-family:sans-serif;margin:20px;background:#1a1a2e;color:#eee}
h1{color:#e94560}table{border-collapse:collapse;width:100%}
th,td{padding:8px;text-align:left;border-bottom:1px solid #333}
th{background:#16213e;color:#0f3460}a{color:#53d8fb;text-decoration:none}
a:hover{color:#e94560}.ok{color:#4ecca3}.warn{color:#ffc300}</style></head><body>
<h1>Xray Patched - Summary Report</h1>
<p>Generated: $(date)</p>
<table><tr><th>#</th><th>File</th><th>Size</th><th>Target</th></tr>
HTMLEOF
  i=0
  for f in "$REPORT_DIR"/*.html; do
    [ -f "$f" ] || continue
    [ "$f" = "$summary" ] && continue
    i=$((i+1))
    name=$(basename "$f")
    size=$(du -h "$f" | cut -f1)
    target=$(grep -oP '(?<=<title>)[^<]+' "$f" 2>/dev/null | head -1)
    [ -z "$target" ] && target=$(echo "$name" | sed 's/\.[^.]*$//')
    echo "<tr><td>$i</td><td><a href=\"$name\">$name</a></td><td>$size</td><td>$target</td></tr>" >> "$summary"
  done
  echo "</table><hr><p>Total: $i reports</p></body></html>" >> "$summary"
  echo -e "${G}✓ Summary: $summary${N}"
}

install_tool() {
  echo -e "${Y}Menjalankan install.sh...${N}"
  if [ -f "$SCRIPT_DIR/install.sh" ]; then
    bash "$SCRIPT_DIR/install.sh"
  else
    echo -e "${R}install.sh tidak ditemukan${N}"
  fi
  echo -ne "${Y}Tekan Enter...${N}"; read
}

while true; do
  clear
  show_banner
  show_menu
  echo -ne "${BOLD}${Y}Pilih menu [0-22]:${N} "
  read pilihan

  case $pilihan in
    1) webscan_single ;;
    2) servicescan_menu ;;
    3) subdomain_menu ;;
    4) x_scan ;;
    5) poc_builder ;;
    6)
      echo -ne "${C}CVE ID${N}: "; read cve_id
      bash "$SCRIPT_DIR/xray-tools" cve "$cve_id"
      ;;
    7)
      echo -ne "${C}Search${N}: "; read sq
      bash "$SCRIPT_DIR/xray-tools" searchsploit "$sq"
      ;;
    8) bash "$SCRIPT_DIR/xray-tools" diff ;;
    9)
      echo -ne "${C}Target URL${N}: "; read tgt
      bash "$SCRIPT_DIR/xray-tools" exploit "$tgt"
      ;;
    10) summary_report ;;
    11) python3 "$SCRIPT_DIR/xray-webui" ;;
    12) update_poc ;;
    13) validate_poc ;;
    14) start_reverse ;;
    15) gen_ca ;;
    16) show_version ;;
    17) convert_file ;;
    18) burp_convert ;;
    19) transform_script ;;
    20) schedule_scan ;;
    21) webscan_massal ;;
    22) install_tool ;;
    0) echo -e "${R}Keluar...${N}"; exit 0 ;;
    *) echo -e "${R}Pilihan tidak valid!${N}" ;;
  esac

  if [ "$pilihan" != "0" ]; then
    echo ""
    echo -ne "${BOLD}${Y}Tekan Enter untuk kembali...${N}"
    read
  fi
done
