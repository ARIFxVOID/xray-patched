# Xray Patched

**Version 1.9.11** | [ADVANCED] | ARM64 | Linux

Xray is a security assessment tool for discovering web vulnerabilities. This is a pre-patched build with all premium features unlocked, no license verification.

---

## Table of Contents

- [Quick Start](#quick-start)
- [Features Overview](#features-overview)
- [Installation](#installation)
  - [Automatic Install](#automatic-install)
  - [Manual Install](#manual-install)
  - [Verifying Installation](#verifying-installation)
  - [Dependencies](#dependencies)
- [CLI Mode (Step by Step)](#cli-mode-step-by-step)
  - [1. Web Scan](#1-web-scan)
  - [2. Service Scan](#2-service-scan)
  - [3. Subdomain Enumeration](#3-subdomain-enumeration)
  - [4. Full Scan (All Plugins)](#4-full-scan-all-plugins)
  - [5. POC Validation](#5-poc-validation)
  - [6. CVE Lookup](#6-cve-lookup)
  - [7. Search Exploit-DB](#7-search-exploit-db)
  - [8. Auto Exploit](#8-auto-exploit)
  - [9. Web Dashboard](#9-web-dashboard)
  - [10. Diff Analysis](#10-diff-analysis)
  - [11. Interactsh Setup](#11-interactsh-setup)
  - [12. Generate CA Certificate](#12-generate-ca-certificate)
  - [13. Start Reverse Server](#13-start-reverse-server)
  - [14. Scheduled Scan](#14-scheduled-scan)
  - [15. Mass Scan (Multiple Targets)](#15-mass-scan-multiple-targets)
- [Menu Mode (Step by Step)](#menu-mode-step-by-step)
  - [Opening the Menu](#opening-the-menu)
  - [Menu 1: Web Scan](#menu-1-web-scan)
  - [Menu 5: POC Builder](#menu-5-poc-builder)
  - [Menu 6: CVE Lookup](#menu-6-cve-lookup)
  - [Menu 7: Searchsploit](#menu-7-searchsploit)
  - [Menu 8: Diff Scan](#menu-8-diff-scan)
  - [Menu 9: Auto Exploit](#menu-9-auto-exploit)
  - [Menu 10: Summary Report](#menu-10-summary-report)
  - [Menu 11: Web UI Dashboard](#menu-11-web-ui-dashboard)
  - [Menu 12: Update POC](#menu-12-update-poc)
  - [Menu 20: Schedule Scan](#menu-20-schedule-scan)
  - [Menu 21: Mass Scan](#menu-21-mass-scan)
- [Complete Menu Reference](#complete-menu-reference)
- [Configuration](#configuration)
  - [config.yaml](#configyaml)
  - [Reverse Server Configuration](#reverse-server-configuration)
  - [Plugin & Module Configuration](#plugin--module-configuration)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Credits & License](#credits--license)

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/ARIFxVOID/xray-patched.git
cd xray-patched

# 2. Run installer
bash install.sh

# 3. Start scanning
xray webscan https://example.com
```

---

## Features Overview

| Feature | Description |
|---------|-------------|
| **Web Scanning** | 18 built-in plugins, 800+ POCs |
| **Service Scanning** | Tomcat AJP (CVE-2020-1938), Weblogic RCE (CVE-2023-21839) |
| **Subdomain Enumeration** | Passive & active subdomain discovery |
| **Reverse Server** | Built-in HTTP (9999), DNS (5353), RMI (1099) |
| **Interactsh Integration** | Cloud reverse server — no port forwarding needed |
| **Mass Scanning** | Scan hundreds of targets from a file |
| **Scheduled Scanning** | Automated recurring scans |
| **POC Builder** | Create, validate, and manage POC YAML files |
| **POC Updater** | Auto-download latest POCs from remote sources |
| **CVE Lookup** | Query public CVE databases for vulnerability details |
| **Exploit Search** | Search Exploit-DB for matching exploits |
| **Auto Exploit** | Scan → extract CVEs → find exploits → verify |
| **Web Dashboard** | Browser-based UI for browsing scan results |
| **Diff Analysis** | Track added and removed reports over time |
| **Summary Reports** | Aggregate all scan results into a single HTML file |

---

## Installation

### Automatic Install

```bash
bash install.sh
```

The installer performs the following steps:

**Step 1 — Binary Setup**
```
[1/6] Setting up binary...
  ✓ Binary copied to /root/.xray-patched
```

The xray binary is copied from the repository to your home directory where execute permissions work correctly.

**Step 2 — Config Generation**
```
[2/6] Generating config...
  ✓ Config ready (reverse server ON)
```

A configuration file (`config.yaml`) is generated with reverse server enabled. This ensures all POCs that require a callback server will work out of the box.

**Step 3 — Directory Creation**
```
[3/6] Creating directories...
  ✓ reports/ poc/ lists/
```

- `reports/` — All scan results are saved here automatically
- `poc/` — Store custom POC YAML files here
- `lists/` — Store target URL lists here

**Step 4 — Shortcut Creation**
```
[4/6] Creating shortcut...
  ✓ Run with: xray
```

A global `xray` command is created so you can run it from anywhere without specifying the full path.

**Step 5 — Dependencies**
```
[5/6] Installing dependencies...
  ✓ Dependencies ready
```

Installs Python, PyYAML, and exploitdb if available on your system.

**Step 6 — Finalize**
```
[6/6] Finalizing...

✓ INSTALLATION COMPLETE
  Repo  : /storage/emulated/0/xray
  Binary: /root/.xray-patched
  Menu  : bash xray-menu.sh
  Short : xray
```

### Manual Install

If the automatic installer fails or you prefer manual setup:

```bash
# Step 1: Copy binary to a writable location
cp xray-patched $HOME/.xray-patched
chmod +x $HOME/.xray-patched

# Step 2: Create required directories
mkdir -p reports poc lists

# Step 3: Generate config (first scan auto-creates it)
./xray-patched webscan --url http://example.com
```

### Verifying Installation

After installation, verify everything works:

```bash
# Check version — should show ADVANCED
xray version

# Expected output:
# ____  ___.________.    ____.   _____.___.
# ...
# Version: 1.9.11/eb0c331d/ADVANCED
# [xray 1.9.11/eb0c331d]
# Build: [2023-05-18] [linux/arm64] [RELEASE/ADVANCED]

# Check help
xray help

# Launch menu
xray menu
```

### Dependencies

| Dependency | Required | Installation |
|-----------|----------|-------------|
| Python 3.6+ | Yes (tools & web UI) | `pkg install python` or `apt install python3` |
| PyYAML | Yes (config parsing) | `pip3 install pyyaml` |
| searchsploit | No (exploit search) | `apt install exploitdb` |
| nuclei | No (verification) | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei` |

---

## CLI Mode (Step by Step)

This section covers every CLI command with detailed explanations and expected output.

---

### 1. Web Scan

Scan a single website for vulnerabilities.

```bash
xray webscan https://example.com
```

**What happens:**
1. Xray loads its configuration from `config.yaml`
2. Loads all enabled plugins (xstream, cmd-injection, path-traversal, xxe, shiro, sqldet, xss, ssrf, etc.)
3. Loads POC rules (typically 800+ POCs)
4. Crawls the target URL and tests each page against all plugins
5. Saves results to `reports/webscan-YYYYMMDD-HHMMSS.html`

**Expected output:**
```
Version: 1.9.11/eb0c331d/ADVANCED
[INFO] Loading config file from config.yaml
Enabled plugins: [xstream cmd-injection path-traversal xxe shiro redirect sqldet xss ...]
[INFO] shiro key count 117
[INFO] 819 pocs have been loaded
```

**Custom output location:**
```bash
xray webscan https://example.com --html-output /custom/path/report.html
```

**JSON output:**
```bash
xray webscan https://example.com --json-output results.json
```

---

### 2. Service Scan

Scan a specific service for known vulnerabilities.

```bash
# Scan default port
xray servicescan 192.168.1.1:7001

# Scan with specific module
xray servicescan 192.168.1.1:7001 weblogic

# Scan Tomcat AJP
xray servicescan 192.168.1.1:8009 tomcat
```

**Supported modules:**
- `weblogic` — WebLogic RCE (CVE-2023-21839, CVE-2023-21931, CVE-2023-21979)
- `tomcat` — Tomcat AJP Potential RCE (CVE-2020-1938)

**Expected output:**
```
Version: 1.9.11/eb0c331d/ADVANCED
Service Scan Support:
- Tomcat AJP Potential RCE (CVE-2020-1938)
- Weblogic RCE (CVE-2023-21839/21931/21979)
[INFO] your target: 192.168.1.1:7001
[INFO] Loading config file from config.yaml
```

---

### 3. Subdomain Enumeration

Discover subdomains of a target domain.

```bash
xray subdomain example.com
```

**What happens:**
1. Xray performs passive subdomain enumeration using public sources
2. Attempts active discovery techniques
3. Results are saved to `reports/subdomain-YYYYMMDD-HHMMSS.html`

---

### 4. Full Scan (All Plugins)

Run every available plugin against the target. This is the most comprehensive scan.

```bash
xray fullscan https://example.com
```

**What happens:**
- Uses the `x` command which enables ALL plugins
- Loads all modules defined in `xray.yaml`
- Runs webscan, servicescan, and subdomain enumeration in sequence
- Results saved to `reports/fullscan-YYYYMMDD-HHMMSS.html`

This is equivalent to running `xray x` from the menu.

---

### 5. POC Validation

Validate POC YAML files for syntax errors.

```bash
# Validate a single POC file
xray poclint path/to/poc.yaml

# Validate all POCs in a directory
xray poclint "poc/*.yaml"

# Validate with auto-fix
xray poclint path/to/poc.yaml --autofix
```

**What it checks:**
- YAML syntax validity
- Required fields (name, rules, expression)
- File naming conventions
- Rule structure correctness

---

### 6. CVE Lookup

Look up CVE details from public databases.

```bash
xray tools cve CVE-2024-21626
```

**What happens:**
1. Queries `cve.circl.lu` API for CVE information
2. If rate-limited, falls back to NVD (National Vulnerability Database) API
3. Displays: CVE ID, CVSS score, severity, description
4. If searchsploit is installed, searches for matching exploits

**Expected output:**
```
[CVE Lookup] Looking up CVE-2024-21626...
  ID      : CVE-2024-21626
  Score   : 8.6
  Severity: HIGH
  Desc    : runc is a CLI tool for spawning and running containers on Linux...
[Searchsploit] Looking for exploits...
  (exploit results if available)
```

**Other examples:**
```bash
xray tools cve CVE-2021-44228   # Log4Shell
xray tools cve CVE-2023-21839   # Weblogic
xray tools cve CVE-2024-27198   # JetBrains
```

---

### 7. Search Exploit-DB

Search the Exploit Database for exploits matching your query.

```bash
xray tools searchsploit wordpress
xray tools searchsploit "Apache Struts"
xray tools searchsploit "CVE-2024"
```

**Note:** Requires `searchsploit` to be installed:
```bash
apt install exploitdb
```

---

### 8. Auto Exploit

Run a full exploitation pipeline against a target.

```bash
xray tools exploit https://target.com
```

**Pipeline stages:**

| Stage | Action | Description |
|-------|--------|-------------|
| 1 | **Scan** | Runs `xray webscan` against the target with JSON output |
| 2 | **Analyze** | Parses scan results for CVE identifiers and vulnerability details |
| 3 | **Exploit Search** | Queries Exploit-DB for exploits matching found CVEs |
| 4 | **Verify** | Runs Nuclei for additional verification (if installed) |

**Expected output:**
```
[Auto Exploit] Target: https://target.com
[1] Scanning with Xray...
  (xray scan output)
[2] Analyzing results...
  Plugin: xss
  URL: https://target.com/page?q=test
  Detail: Reflected XSS vulnerability
  
  Plugin: sqldet
  URL: https://target.com/page?id=1
  CVE: CVE-2024-XXXXX
[3] Searching exploits...
  (searchsploit results)
[+] Done
```

---

### 9. Web Dashboard

Launch a browser-based dashboard for viewing scan results.

```bash
xray webui
```

**What happens:**
1. Starts a Python HTTP server on port 9998
2. Serves a dynamically generated HTML dashboard
3. Open `http://localhost:9998` in your browser

**Dashboard features:**
- **Stats cards:** Total scans, scans today, vulnerabilities found, new in 24h
- **Filter dropdown:** Filter reports by type (webscan, fullscan, subdomain, massal, schedule, summary)
- **Search box:** Real-time search by filename
- **Report table:** Sortable table with file name, type, target, size, timestamp
- **Direct links:** Click any report name to view its contents

**Expected dashboard:**
```
┌──────────────────────────────────────────────────────────────┐
│  🛡 Xray Dashboard                                           │
│  12 reports · 3 new · Last: 2026-06-27 12:00:00             │
├──────────┬──────────┬──────────┬──────────┬─────────────────┤
│ Total    │ Today    │ Vulns    │ New (24h)│                 │
│ Scans    │          │          │          │                 │
│   12     │   3      │   1      │   3      │                 │
├──────────┴──────────┴──────────┴──────────┴─────────────────┤
│ [Search...              ] [Type: All ▼] [Refresh]           │
├──────┬──────────────────┬───────┬────────┬──────────────────┤
│  #   │ Report           │ Type  │ Target │ Time             │
│  12  │ fullscan-...     │ full  │ ex...  │ 2026-06-27...    │
│  11  │ webscan-...      │ web   │ ex...  │ 2026-06-27...    │
│ ...  │ ...              │ ...   │ ...    │ ...              │
└──────┴──────────────────┴───────┴────────┴──────────────────┘
```

---

### 10. Diff Analysis

Compare current scan results with a previous snapshot to see what changed.

```bash
# First run — creates a baseline snapshot
xray tools diff
# Output: First diff snapshot saved. Run again after more scans.

# Run more scans
xray webscan https://target1.com
xray webscan https://target2.com

# Second run — shows differences
xray tools diff
```

**Expected output:**
```
[Diff Scan] Comparing scan results...
[NEW] New reports since last check:
  webscan-target1-com-20260627-120000.html
  webscan-target2-com-20260627-120100.html

[MISSING] Reports removed:
  (none)
```

**Use cases:**
- Track when specific targets were last scanned
- Verify new scans were created after configuration changes
- Monitor scan coverage over time

---

### 11. Interactsh Setup

Switch the reverse server to use interact.sh, a cloud-based reverse server. This eliminates the need for local port forwarding.

```bash
xray tools interactsh
```

**Expected output:**
```
[Interactsh] Setting up reverse server publik...
✓ Config updated: reverse → interactsh
   Semua POC reverse bakal pake interact.sh
```

**What this changes in config.yaml:**
- Sets `reverse.remote_server: true`
- Sets `reverse.client.reverse_api: https://api.interactsh.com`
- Keeps reverse ports configured but marks them as remote

**When to use:**
- Your target is behind NAT and cannot reach your reverse server
- You don't want to open ports on your firewall
- You're scanning from a restricted network

**When NOT to use:**
- When you need local control over the reverse server
- When scanning internal/private targets

To switch back to local reverse server, edit `config.yaml` and set `reverse.remote_server: false`.

---

### 12. Generate CA Certificate

Generate CA certificate and key for HTTPS scanning.

```bash
xray genca
```

**What happens:**
1. Creates `ca.crt` and `ca.key` in the repository directory
2. These are used for decrypting HTTPS traffic during scanning

**Expected output:**
```
Version: 1.9.11/eb0c331d/ADVANCED
CA certificate ca.crt and key ca.key generated
```

**Install CA on Android:**
```bash
# Copy to device storage
cp ca.crt /storage/emulated/0/

# Then go to Settings → Security → Install from storage → select ca.crt
```

---

### 13. Start Reverse Server

Start the reverse listener server for POCs that require callback connections.

```bash
xray reverse
```

**What it does:**
- Starts HTTP listener on port 9999
- Starts DNS listener on port 5353
- Starts RMI listener on port 1099
- Waits for incoming connections from target systems

This runs in the foreground. Press `Ctrl+C` to stop.

---

### 14. Scheduled Scan

Run scans automatically at specified intervals.

```bash
# Scan every hour, 5 times
xray schedule https://example.com 3600 5

# Scan every 30 minutes, unlimited
xray schedule https://example.com 1800 0

# Scan once after 10 seconds (testing)
xray schedule https://example.com 10 1
```

**Parameters:**
- `<url>` — Target URL
- `[interval]` — Seconds between scans (default: 3600 = 1 hour)
- `[count]` — Number of scans (0 = unlimited, default: 0)

**Expected output:**
```
[1] Sat Jun 27 12:00:00 UTC 2026 Scanning https://example.com
  -> reports/schedule-1-20260627-120000.html
  -> Next: 3600s
[2] Sat Jun 27 13:00:00 UTC 2026 Scanning https://example.com
  -> reports/schedule-2-20260627-130000.html
  -> Next: 3600s
```

---

### 15. Mass Scan (Multiple Targets)

Scan multiple targets from a text file. One URL per line.

**Step 1 — Create a target list:**
```bash
echo "https://target1.com" > targets.txt
echo "https://target2.com" >> targets.txt
echo "https://target3.com:8080" >> targets.txt
```

**Step 2 — Run mass scan:**
```bash
xray massal targets.txt
```

**What happens:**
1. Reads each URL from the file
2. For each URL, runs `webscan` with auto-generated HTML output
3. Files are saved as `reports/massal-1-target1-com-YYYYMMDD-HHMMSS.html`
4. Progress is displayed: `[1/3] Scanning: https://target1.com`

**Expected output:**
```
[1/3] Scanning: https://target1.com
  -> reports/massal-1-target1-com-20260627-120000.html
[2/3] Scanning: https://target2.com
  -> reports/massal-2-target2-com-20260627-120001.html
[3/3] Scanning: https://target3.com:8080
  -> reports/massal-3-target3-com-8080-20260627-120002.html
=== SEMUA SELESAI === 3 target
```

---

## Menu Mode (Step by Step)

The interactive menu provides all functionality through an easy-to-navigate interface. There are 22 options in total.

### Opening the Menu

```bash
xray menu
```

Or directly:

```bash
bash xray-menu.sh
```

The menu displays:
```
____  ___.________.    ____.   _____.___.
\   \/  /\_   __   \  /  _  \  \__  |   |
 \     /  |    _  _/ /  /_\  \  /   |   |
 /     \  |    |   \/    |    \ \____   |
\___/\  \ |____|   /\____|_   / / _____/
      \_/       \_/        \_/  \/

Version: 1.9.11/eb0c331d/ADVANCED

Author: Arif (hacked by arif😹)

  1)  webscan           - Scan website tunggal
  2)  servicescan        - Scan service/port
  ... (all 22 options)
 22)  auto exploit       - Scan + exploit target
  0)  Keluar

Pilih menu [0-22]:
```

Type the number and press Enter. After each menu action completes, press Enter to return to the menu.

---

### Menu 1: Web Scan

```
Pilih menu [0-22]: 1
URL target (contoh: https://example.com): https://target.com
Output: reports/webscan-20260627-120000.html
```

The scan runs automatically. Results are saved to `reports/`.

---

### Menu 5: POC Builder

```
Pilih menu [0-22]: 5
POC Builder
  1) Buat POC baru (template)
  2) Validasi POC
  3) Lihat daftar POC
Pilih [1-3]:
```

Create, validate, or list POC YAML files. See the CLI section for full details.

---

### Menu 6: CVE Lookup

```
Pilih menu [0-22]: 6
CVE ID: CVE-2024-21626
```

Displays CVE details from public databases. If searchsploit is installed, it also searches for exploits.

---

### Menu 7: Searchsploit

```
Pilih menu [0-22]: 7
Search: wordpress
```

Requires `searchsploit` to be installed (`apt install exploitdb`).

---

### Menu 8: Diff Scan

```
Pilih menu [0-22]: 8
[Diff Scan] Comparing scan results...
```

Compares current reports against the last snapshot.

---

### Menu 9: Auto Exploit

```
Pilih menu [0-22]: 9
Target URL: https://target.com
[Auto Exploit] Target: https://target.com
```

Runs the full exploitation pipeline: scan → analyze → exploit search → verify.

---

### Menu 10: Summary Report

Aggregate all scan results into a single HTML report.

```
Pilih menu [0-22]: 10
Summary Report
Menggabungkan semua laporan di reports/...
✓ Summary: reports/summary-20260627-120000.html
```

Open the generated HTML file in any browser to see all scan results in one place.

---

### Menu 11: Web UI Dashboard

```
Pilih menu [0-22]: 11
[+] Xray Web UI: http://0.0.0.0:9998
[+] Reports: /path/to/reports
```

Open `http://localhost:9998` in your browser. Press `Ctrl+C` to stop the server.

---

### Menu 12: Update POC

Download the latest POC rules from remote sources.

```
Pilih menu [0-22]: 12
Download POC terbaru dari github...
```

POCs are saved to the `poc/` directory.

---

### Menu 13: Validate POC

Check a POC YAML file for syntax and structural errors.

```
Pilih menu [0-22]: 13
POC file/pattern: ./poc/*.yaml
```

Uses xray's built-in `poclint` command.

---

### Menu 14: Reverse Server

Start the built-in reverse HTTP/DNS/RMI server for out-of-band detection.

```
Pilih menu [0-22]: 14
Starting reverse server...
```

Configured via `config.yaml` under the `reverse` section.

---

### Menu 15: Generate CA

Generate a CA certificate and key for HTTPS MITM interception.

```
Pilih menu [0-22]: 15
CA cert: /path/to/xray/ca.crt
CA key:  /path/to/xray/ca.key
```

---

### Menu 16: Version

Display the current xray version and build info.

```
Pilih menu [0-22]: 16
Version: 1.9.11/eb0c331d/ADVANCED
```

---

### Menu 17: Convert

Convert scan results between formats (JSON, HTML, etc.).

```
Pilih menu [0-22]: 17
File input (json/html): report.json
File output: report.html
```

---

### Menu 18: Burp Export Convert

Convert Burp Suite proxy export files into xray-compatible POC format.

```
Pilih menu [0-22]: 18
File export Burp: burp_export.xml
Output POC: burp_poc.yaml
```

---

### Menu 19: Transform Script

Transform xray scripts to different formats.

```
Pilih menu [0-22]: 19
File input: script.gamma
Output: script.yaml
```

---

### Menu 22: Install

Re-run the installation script to set up or update dependencies.

```
Pilih menu [0-22]: 22
Menjalankan install.sh...
```

Runs the full installer (binary copy, config gen, dependency install, symlink creation).

---

### Menu 20: Schedule Scan

```
Pilih menu [0-22]: 20
URL target: https://example.com
Interval (detik, default: 3600): 1800
Jumlah scan (0 = unlimited): 10
Schedule: setiap 1800s, 10 kali
```

Runs the specified number of scans at the specified interval.

---

### Menu 21: Mass Scan

```
Pilih menu [0-22]: 21
File list (1 URL/baris): targets.txt
Total target: 3
```

Scans all URLs in the specified file.
```

---

## Complete Menu Reference

| # | Command | Description | Input Required |
|---|---------|-------------|----------------|
| 1 | `webscan` | Scan a single website | URL |
| 2 | `servicescan` | Scan service or port | host:port, module |
| 3 | `subdomain` | Enumerate subdomains | Domain |
| 4 | `x` | Scan with all plugins | URL |
| 5 | `POC builder` | Create/validate POC | Sub-menu |
| 6 | `CVE lookup` | Search CVE | CVE ID |
| 7 | `searchsploit` | Search Exploit-DB | Search query |
| 8 | `diff scan` | Compare results | None |
| 9 | `auto exploit` | Full exploitation | URL |
| 10 | `summary` | Aggregate reports | None |
| 11 | `web UI` | Launch dashboard | None |
| 12 | `update POC` | Download POCs | None |
| 13 | `poclint` | Validate POC | File pattern |
| 14 | `reverse` | Start reverse server | None |
| 15 | `genca` | Generate CA cert | None |
| 16 | `version` | Display version | None |
| 17 | `convert` | Convert scan results | Input, output files |
| 18 | `burp-gamma` | Convert Burp exports | Input, output files |
| 19 | `transform` | Transform scripts | Input, output files |
| 20 | `schedule scan` | Recurring scans | URL, interval, count |
| 21 | `webscan massal` | Scan from file | File path |
| 22 | `install` | Run setup | None |
| 0 | Exit | Quit | None |

---

## Configuration

### config.yaml

Auto-generated on first scan. Located in the repository root.

**Key sections:**

```yaml
reverse:
  http:
    enabled: true
    listen_ip: 0.0.0.0
    listen_port: "9999"
  dns:
    enabled: true
    listen_ip: 0.0.0.0
    listen_port: "5353"
  rmi:
    enabled: true
    listen_ip: 0.0.0.0
    listen_port: "1099"
  token: "xray-reverse-token-1337"
```

**Common modifications:**

| Change | How |
|--------|-----|
| Change reverse ports | Edit `listen_port` under each protocol |
| Disable reverse DNS | Set `dns.enabled: false` |
| Change reverse token | Set a new value for `token` |
| Enable interactsh | Run `xray tools interactsh` |

### Reverse Server Configuration

The reverse server accepts callback connections from target systems during scanning. This is essential for:

- **Blind XSS detection** — JavaScript callback to reverse server
- **SSRF detection** — Outbound HTTP/DNS requests
- **RCE verification** — Reverse shell callback via RMI
- **XXE detection** — Outbound HTTP request to reverse server

**Local mode** (default): Listens on local ports 9999 (HTTP), 5353 (DNS), 1099 (RMI). Requires the target to reach your IP.

**Remote mode** (interactsh): Uses `interact.sh` cloud service. No port forwarding needed.

### Plugin & Module Configuration

**module.xray.yaml** — Configures scan modules:

```yaml
Client:
  dial_timeout: 5
  max_qps: 500
  proxy: ""
Pool:
  size: 100
Reverse:
  http:
    enabled: true
    listen_port: "9999"
```

**plugin.xray.yaml** — Configures plugin behavior:

```yaml
rinter:
  disable_host_print: false
  disable_port_print: false
service-scan:
  bandwidth: 1000
  port: 22,80,443
  timeout: 2
vuln-scan:
  stdout: true
```

**xray.yaml** — Defines custom commands:

```yaml
- name: x
  description: Command that enables all plugins
  enabled_plugins:
    - printer
    - service-scan
    - target-parser
    - vuln-scan
  plugin_path:
    - ./plugin
  module_config: module.xray.yaml
  plugin_config: plugin.xray.yaml
```

---

## Troubleshooting

### "Permission denied" when running xray

**Problem:** The binary in the storage directory cannot be executed.

**Solution:** The installer copies the binary to `$HOME/.xray-patched` (not the storage). If running manually:
```bash
cp xray-patched $HOME/.xray-patched
chmod +x $HOME/.xray-patched
```

### "config.yaml not found"

**Problem:** Xray cannot find its configuration file.

**Solution:** Run any scan command from the repository directory:
```bash
cd /path/to/xray-patched
xray webscan http://example.com
```
Xray will auto-generate `config.yaml` on first run.

### "please fill in the token of reverse"

**Problem:** The reverse server token is empty.

**Solution:** Run the interactsh setup or manually set a token:
```bash
xray tools interactsh
```
Or edit `config.yaml` and set `reverse.token` to any value.

### CVE lookup returns "CVE not found"

**Problem:** The CVE API did not return results.

**Solution:**
1. Check your internet connection
2. The API has rate limits (20 requests/minute for circl.lu)
3. Wait and try again
4. Verify the CVE ID format (e.g., `CVE-2024-21626` not `cve-2024-21626`)

### "yaml: line X: mapping values are not allowed"

**Problem:** A YAML configuration file has syntax errors.

**Solution:** Check and fix the indicated line in the YAML file. Common issues:
- Missing spaces after colons
- Mixed tabs and spaces
- Incorrect indentation

### Web UI not loading

**Problem:** Cannot open the web dashboard.

**Solution:**
1. Ensure the server started (check terminal output)
2. Use `http://localhost:9998` not `https`
3. The server runs on port 9998 by default — use `PORT=8080 xray webui` to change

---

## Project Structure

```
xray-patched/
├── xray-patched              # Binary (ADVANCED, patched, 68MB)
├── xray                      # CLI entry point (bash)
├── xray-menu.sh              # Interactive menu (22 options)
├── xray-webui                # Web dashboard server (Python)
├── xray-tools                # Tool functions (CVE, exploit, diff, interactsh)
├── install.sh                # Automated installer
├── README.md                 # This file
│
├── config.yaml               # Main xray configuration
├── module.xray.yaml          # Module configuration
├── plugin.xray.yaml          # Plugin configuration
├── xray.yaml                 # Command definition
│
├── reports/                  # Scan results directory
│   ├── webscan-*.html        # Single web scan reports
│   ├── fullscan-*.html       # Full scan reports
│   ├── subdomain-*.html      # Subdomain reports
│   ├── massal-*.html         # Mass scan reports
│   ├── schedule-*.html       # Scheduled scan reports
│   ├── summary-*.html        # Summary reports
│   └── .diffs/               # Diff snapshots
│
├── poc/                      # POC YAML files
└── lists/                    # Target URL lists
```

---

## Credits & License

**Original Project:** [chaitin/xray](https://github.com/chaitin/xray)

**Patch & Enhancements by:** [ARIFxVOID](https://github.com/ARIFxVOID)
- Binary patching and license removal
- CLI wrapper and interactive menu
- Web dashboard and tools
- Documentation

**Third-party:** [Interactsh](https://github.com/projectdiscovery/interactsh) by ProjectDiscovery

---

**Disclaimer:** This tool is for educational and authorized security testing purposes only. Users are responsible for compliance with applicable laws and regulations. Unauthorized scanning of systems you do not own or have explicit permission to test is illegal.
