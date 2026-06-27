#!/bin/bash
XRAY="/root/xray-patched"

R='\033[31m'; G='\033[32m'; Y='\033[33m'; B='\033[34m'
M='\033[35m'; C='\033[36m'; W='\033[37m'; N='\033[0m'
BOLD='\033[1m'

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
  echo -e "  ${R}1)${N}  ${W}webscan${N}       ${C}-${N} Scan website"
  echo -e "  ${Y}2)${N}  ${W}servicescan${N}   ${C}-${N} Scan service/port"
  echo -e "  ${G}3)${N}  ${W}subdomain${N}     ${C}-${N} Scan subdomain"
  echo -e "  ${C}4)${N}  ${W}x${N}             ${C}-${N} Scan dengan semua plugin"
  echo -e "  ${B}5)${N}  ${W}poclint${N}       ${C}-${N} Validasi POC yaml"
  echo -e "  ${M}6)${N}  ${W}reverse${N}       ${C}-${N} Jalankan reverse server"
  echo -e "  ${R}7)${N}  ${W}genca${N}         ${C}-${N} Generate CA certificate"
  echo -e "  ${Y}8)${N}  ${W}version${N}       ${C}-${N} Tampilkan versi"
  echo -e "  ${G}9)${N}  ${W}convert${N}       ${C}-${N} Convert hasil scan"
  echo -e "  ${C}10)${N} ${W}burp-gamma${N}    ${C}-${N} Convert export Burp"
  echo -e "  ${B}11)${N} ${W}transform${N}     ${C}-${N} Transform script"
  echo -e "  ${M}12)${N} ${W}upgrade${N}       ${C}-${N} Update Xray"
  echo -e "  ${R}0)${N}  ${W}Keluar${N}"
  echo ""
}

while true; do
  clear
  show_banner
  show_menu
  echo -ne "${BOLD}${Y}Pilih menu [0-12]:${N} "
  read pilihan

  case $pilihan in
    1)
      echo -ne "${C}URL target${N} (contoh: https://example.com): "
      read url
      echo -ne "${C}Output HTML${N} (opsional): "
      read output
      if [ -n "$output" ]; then
        $XRAY webscan --url "$url" --html-output "$output"
      else
        $XRAY webscan --url "$url"
      fi
      ;;
    2)
      echo -ne "${C}Target${N} (host:port): "
      read target
      echo -ne "${C}Module${N} (default: weblogic): "
      read module
      module=${module:-weblogic}
      $XRAY servicescan --target "$target" --module "$module"
      ;;
    3)
      echo -ne "${C}Target domain${N}: "
      read domain
      $XRAY subdomain --target "$domain"
      ;;
    4)
      echo -ne "${C}URL target${N}: "
      read url
      echo -ne "${C}Output HTML${N} (opsional): "
      read output
      if [ -n "$output" ]; then
        $XRAY x --url "$url" --html-output "$output"
      else
        $XRAY x --url "$url"
      fi
      ;;
    5)
      echo -ne "${C}Glob pattern POC${N} (contoh: /path/to/pocs/*.yml): "
      read pattern
      $XRAY poclint --script "$pattern"
      ;;
    6)
      echo -e "${Y}Menjalankan reverse server (butuh config.yaml)...${N}"
      $XRAY reverse
      ;;
    7)
      $XRAY genca
      echo -e "${G}CA certificate dan key telah digenerate.${N}"
      ;;
    8)
      $XRAY version
      ;;
    9)
      echo -ne "${C}File input${N} (json/html): "
      read input
      echo -ne "${C}File output${N}: "
      read output
      $XRAY convert "$input" "$output"
      ;;
    10)
      echo -ne "${C}File export Burp${N}: "
      read file
      echo -ne "${C}Output POC${N}: "
      read output
      $XRAY burp-gamma "$file" "$output"
      ;;
    11)
      echo -ne "${C}File script input${N}: "
      read input
      echo -ne "${C}Output file${N}: "
      read output
      $XRAY transform "$input" "$output"
      ;;
    12)
      echo -e "${Y}Upgrade Xray...${N}"
      $XRAY upgrade
      ;;
    0)
      echo -e "${R}Keluar...${N}"
      exit 0
      ;;
    *)
      echo -e "${R}Pilihan tidak valid!${N}"
      ;;
  esac

  if [ "$pilihan" != "0" ]; then
    echo ""
    echo -ne "${BOLD}${Y}Tekan Enter untuk kembali ke menu...${N}"
    read
  fi
done
