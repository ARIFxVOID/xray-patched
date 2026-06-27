# Xray 1.9.11 ARM64 - Patched Advanced

Xray community edition yang udah di-patch jadi **ADVANCED** (lisensi premium).  
Cocok untuk ARM64 (Termux Android, Raspberry Pi, dll).

## File

| File | Keterangan |
|------|-----------|
| `xray-patched` | Binary Xray 1.9.11 ARM64 yang udah di-patch |
| `xray-menu.sh` | Script menu wrapper biar gak perlu hafal command |

## Cara Pakai

### Via Menu (Rekomendasi)

```bash
bash xray-menu.sh
```
Tinggal milih angka, gampang.

### Langsung Binary

```bash
# Cek versi
./xray-patched version

# Scan website pake semua plugin
./xray-patched x --url https://target.com

# Scan website
./xray-patched webscan --url https://target.com

# Scan service
./xray-patched servicescan --target host:port

# Scan subdomain
./xray-patched subdomain --target example.com
```

### Contoh Lengkap

```bash
# Scan + output HTML
./xray-patched webscan --url https://example.com --html-output result.html

# Scan pake plugin tertentu
./xray-patched x --url https://example.com --plugins xss,sqli

# Validasi POC custom
./xray-patched poclint --script "/path/to/pocs/*.yml"
```

## Daftar Command

| Command | Fungsi |
|---------|--------|
| `webscan` | Scan website |
| `servicescan` | Scan service/port |
| `subdomain` | Scan subdomain |
| `x` | Scan pake semua plugin |
| `poclint` | Validasi POC yaml |
| `reverse` | Reverse server |
| `genca` | Generate CA certificate |
| `convert` | Convert hasil scan |
| `burp-gamma` | Convert export Burp |
| `transform` | Transform script |
| `upgrade` | Update Xray |

## Patches Applied

1. **parseLicenseContent** - Fungsi lisensi di-skip total, langsung return "ADVANCED"
2. **Display string** - "COMMUNITY" diganti "ADVANCED"

## Notes

- Hanya untuk ARM64 (aarch64)
- Gak perlu lisensi file, tinggal jalanin aja
- Output/log binary asli gak ada yang diubah

---
© 2026 Arif
