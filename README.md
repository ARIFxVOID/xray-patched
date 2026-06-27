<div align="center">
  <pre>
____  ___.________.    ____.   _____.___.
\   \/  /\_   __   \  /  _  \  \__  |   |
 \     /  |    _  _/ /  /_\  \  /   |   |
 /     \  |    |   \/    |    \ \____   |
\___/\  \ |____|   /\____|_   / / _____/
      \_/       \_/        \_/  \/
  </pre>

  # Xray 1.9.11 - Patched Advanced

  [![Arch](https://img.shields.io/badge/arch-ARM64-red)](#)
  [![Status](https://img.shields.io/badge/status-stable-brightgreen)](#)
  [![License](https://img.shields.io/badge/license-ADVANCED-blueviolet)](#)
  [![Build](https://img.shields.io/badge/build-2023--05--18-orange)](#)

  **Xray Community Edition — Fully Patched to ADVANCED License**

  <sub>No license file required · All plugins enabled · 819+ POCs loaded</sub>

  <br>

  [🚀 Installation](#installation) •
  [📖 Usage](#usage) •
  [🎯 Examples](#examples) •
  [📋 Commands](#commands) •
  [🔧 Patches](#patches)

  <br>
</div>

---

## ✨ Features

- **Fully Unlocked** — All premium features enabled, no restrictions
- **Zero Config** — No license file needed, works straight out of the box
- **819+ POCs** — Full proof-of-concept engine loaded and ready
- **All Plugins** — xss, sqli, ssrf, rce, shiro, fastjson, xstream, and more
- **ARM64 Native** — Optimized for aarch64 devices (Termux, RPi, AWS Graviton)
- **Menu Wrapper** — User-friendly menu script included

<br>

## 🔧 Installation

### Prerequisites
- Linux ARM64 (aarch64) device
- Git (optional, for cloning)

### Clone & Run

```bash
git clone https://github.com/ARIFxVOID/xray-patched.git
cd xray-patched
chmod +x xray-patched xray-menu.sh
```

### Using the Menu (Recommended)

```bash
bash xray-menu.sh
```

A colorful interactive menu will appear — just pick a number and go.

### Direct Binary

```bash
./xray-patched version
```

<br>

## 📖 Usage

### Basic Scanning

```bash
# Single URL scan with all plugins
./xray-patched x --url https://target.com

# Single URL scan with specific plugins
./xray-patched webscan --url https://target.com --plugins xss,sqli

# Scan with HTML report
./xray-patched webscan --url https://target.com --html-output report.html
```

### Service Scanning

```bash
./xray-patched servicescan --target 192.168.1.100:8080
./xray-patched servicescan --target 10.0.0.50:7001 --module weblogic
```

### Subdomain Enumeration

```bash
./xray-patched subdomain --target example.com
./xray-patched subdomain --target example.com --no-brute
./xray-patched subdomain --target example.com --ip-only
```

### POC Linting

```bash
./xray-patched poclint --script "/path/to/pocs/*.yml"
```

<br>

## 🎯 Examples

### Full Security Scan

```bash
# Scan with all plugins + HTML output
./xray-patched x --url https://example.com \
  --html-output /tmp/scan-result.html \
  --json-output /tmp/scan-result.json
```

### Proxy Mode (Passive Scan)

```bash
# Start as reverse proxy on port 1111
./xray-patched webscan --listen 127.0.0.1:1111

# Then configure your browser to use proxy 127.0.0.1:1111
# Xray will automatically analyze all traffic
```

### Crawl + Scan

```bash
# Basic crawler
./xray-patched webscan --basic-crawler https://example.com

# Browser-based crawler (more thorough)
./xray-patched webscan --browser-crawler https://example.com
```

### Generate CA Certificate

```bash
./xray-patched genca
# Creates ca.crt and ca.key for HTTPS inspection
```

<br>

## 📋 Commands

| Command | Alias | Description |
|---------|-------|-------------|
| `webscan` | `ws` | Web vulnerability scanning |
| `servicescan` | `ss` | Service/port scanning |
| `subdomain` | `sd` | Subdomain enumeration |
| `x` | — | All plugins enabled |
| `poclint` | `pl`, `lint` | Validate YAML POC files |
| `reverse` | — | Standalone reverse server |
| `convert` | — | Convert JSON ↔ HTML results |
| `genca` | — | Generate CA certificate & key |
| `burp-gamma` | `btg` | Convert Burp exports to POC |
| `transform` | — | Transform scripts to gamma format |
| `upgrade` | — | Check and apply updates |
| `version` | — | Show version information |
| `help` | `h` | Show help |

<br>

## 🔧 Patches Applied

| Patch | Location | Description |
|-------|----------|-------------|
| **parseLicenseContent** | `VA 0x132bd50` | Skipped entire crypto/validation, returns `"ADVANCED"` directly |
| **Display string** | `VA 0x32dce08` | Changed `"COMMUNITY"` → `"ADVANCED"` in rodata |

The binary's original logic and output remain untouched — only the license enforcement was neutralized.

### Technical Details

- **AES-128 Key found**: `b293c506e0c7f60353c604961837b810`
- **Method**: Function prologue replaced with immediate return of `("ADVANCED", 8, nil)`
- **Result**: All premium features unlocked, zero crashes

<br>

## 💡 Tips

- Use `--html-output` or `--json-output` to persist scan results
- Configure `config.yaml` for reverse server settings (needed for blind plugins)
- For browser crawler mode, ensure Chrome/Chromium is installed
- The binary runs on any Linux ARM64 environment (Termux, Docker, native)

<br>

## ⚠️ Notes

- **ARM64 only** — will not run on x86/x64 without emulation
- No original Xray code was modified — only license validation was patched
- All credits go to the original Xray team at [chaitin](https://github.com/chaitin/xray)

<br>

<div align="center">
  <br>
  <sub>
    — <b>Author: Arif</b> ·
    <code>SELAMAT MAMAKAI TOOLS YA KONTOL</code> ·
    <a href="https://github.com/ARIFxVOID">@ARIFxVOID</a> —
  </sub>
  <br><br>
  <sub><i>For educational and authorized security testing purposes only.</i></sub>
  <br>
</div>
