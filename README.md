# Xray Patched

Xray 1.9.11 ARM64 — **ADVANCED** (patched, no license check)

## Installation

```bash
cd /storage/emulated/0/xray
bash install.sh
```

Selesai. Ketik `xray` aja langsung.

Atau manual: `bash xray-menu.sh`

## CLI Usage

```bash
xray webscan https://target.com          # Scan website
xray servicescan 192.168.1.1:8080        # Scan service/port
xray subdomain target.com                # Scan subdomain
xray fullscan https://target.com         # Scan semua plugin
xray massal list.txt                     # Scan dari file (1 URL/baris)
xray schedule https://target.com 3600 5  # Scan setiap 1 jam, 5 kali
xray poclint "poc/*.yaml"               # Validasi POC
xray reverse                             # Jalankan reverse server
xray genca                               # Generate CA certificate
xray version                             # Tampilkan versi
xray menu                                # Mode interaktif
xray help                                # Bantuan
```

## Menu Interaktif (17 opsi)

| # | Perintah | Fungsi |
|---|----------|--------|
| 1 | webscan | Scan website tunggal |
| 2 | servicescan | Scan service/port |
| 3 | subdomain | Scan subdomain |
| 4 | x | Scan semua plugin |
| 5 | **webscan massal** | Scan dari file list |
| 6 | **schedule scan** | Scan otomatis berulang |
| 7 | poclint | Validasi POC yaml |
| 8 | reverse | Jalankan reverse server |
| 9 | genca | Generate CA |
| 10 | version | Tampilkan versi |
| 11 | convert | Convert hasil scan |
| 12 | burp-gamma | Convert Burp export |
| 13 | transform | Transform script |
| 14 | update POC | Download POCs terbaru |
| 15 | **POC builder** | Buat/validasi POC |
| 16 | **summary** | Gabung semua hasil scan |
| 17 | **install** | Setup tools |

## Features

### Reverse Server
Reverse server aktif otomatis (HTTP:9999, DNS:5353, RMI:1099).
Semua POC yang butuh reverse server bakal jalan full.

### Report Auto-Save
Semua hasil scan otomatis ke folder `reports/` dengan timestamp.

### Summary Report
Gabung semua hasil scan jadi satu file HTML:
```
Menu > 16) summary
Atau: buka reports/summary-*.html
```

### POC Builder
Buat POC baru langsung dari menu (15) atau CLI.
Template otomatis, validasi langsung.

### Massal Scan
Taruh URL di file (1 per baris), scan semua otomatis.
```
echo "https://target1.com" > targets.txt
echo "https://target2.com" >> targets.txt
xray massal targets.txt
```

## Files

```
xray-patched       - Binary utama (ADVANCED)
xray-menu.sh       - Mode interaktif (17 menu)
xray               - CLI mode
install.sh         - Installer
config.yaml        - Konfigurasi (reverse ON)
module.xray.yaml   - Konfigurasi module
plugin.xray.yaml   - Konfigurasi plugin
xray.yaml          - Konfigurasi perintah
reports/           - Hasil scan
poc/               - POC files
lists/             - Daftar target
```

## Credits

- Original: [chaitin/xray](https://github.com/chaitin/xray)
- Patched by: [ARIFxVOID](https://github.com/ARIFxVOID)
