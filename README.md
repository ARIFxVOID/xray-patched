# Xray Patched

**Version 1.9.11** | [ADVANCED] | ARM64 | Linux

Xray is a security assessment tool for discovering web vulnerabilities. This is a pre-patched build with all premium features unlocked, no license verification.

---

## Quick Start

```bash
# Clone & install
git clone https://github.com/ARIFxVOID/xray-patched.git
cd xray-patched
bash install.sh

# Run
xray webscan https://target.com
```

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [CLI Reference](#cli-reference)
- [Menu Reference](#menu-reference)
- [Advanced Usage](#advanced-usage)
- [Configuration](#configuration)
- [Project Structure](#project-structure)

---

## Features

| Feature | Description |
|---------|-------------|
| **Web Scanning** | 18 built-in plugins, 800+ POCs |
| **Service Scanning** | Tomcat AJP, Weblogic RCE |
| **Subdomain Enumeration** | Passive & active discovery |
| **Reverse Server** | Built-in HTTP/DNS/RMI reverse listener |
| **Interactsh Integration** | Cloud-based reverse (no port forwarding) |
| **Mass Scanning** | Scan multiple targets from a file |
| **Scheduled Scanning** | Recurring scans with configurable intervals |
| **POC Management** | Builder, validator, auto-updater |
| **CVE Lookup** | Fetch details from public CVE databases |
| **Exploit Integration** | Searchsploit integration for exploit discovery |
| **Auto Exploit** | Scan → CVE identification → exploit search → verification |
| **Dashboard** | Web-based UI for browsing scan results |
| **Diff Analysis** | Compare current and previous scan results |
| **Summary Reports** | Aggregate multiple reports into a single view |

---

## Installation

### Automatic

```bash
bash install.sh
```

This will:
1. Copy the binary to `$HOME/.xray-patched`
2. Generate configuration with reverse server enabled
3. Create required directories (`reports/`, `poc/`, `lists/`)
4. Install dependencies (Python, PyYAML, exploitdb)
5. Create a `xray` command shortcut

### Manual

```bash
cp xray-patched $HOME/.xray-patched
chmod +x $HOME/.xray-patched
mkdir -p reports poc lists
```

### Dependencies

- Python 3.6+ (required for tools and web UI)
- PyYAML (`pip3 install pyyaml`)
- searchsploit (`apt install exploitdb`) — optional, for exploit search
- nuclei (`go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei`) — optional, for verification

---

## CLI Reference

### Scanning

```bash
xray webscan <url>                         # Scan a single URL
xray servicescan <host:port> [module]      # Scan a service (default: weblogic)
xray subdomain <domain>                    # Enumerate subdomains
xray fullscan <url>                        # Run all plugins
xray massal <file>                         # Scan URLs from a file (one per line)
xray schedule <url> [interval] [count]     # Scheduled recurring scan
```

### POC Management

```bash
xray poclint <pattern>                     # Validate POC YAML files
xray genca                                 # Generate CA certificate and key
xray reverse                               # Start the reverse listener server
```

### Tools

```bash
xray webui                                 # Launch web dashboard on port 9998
xray tools cve <CVE-ID>                    # Look up CVE details + exploits
xray tools searchsploit <query>            # Search Exploit-DB
xray tools exploit <url>                   # Auto-exploit: scan, analyze, search
xray tools interactsh                      # Switch reverse server to interact.sh
xray tools diff                            # Compare scan result snapshots
```

### System

```bash
xray version                               # Display version information
xray menu                                  # Launch interactive menu mode
xray help                                  # Display this help message
```

### Usage Examples

```bash
# Basic scan with auto-generated report
xray webscan https://example.com

# Scan with specific module
xray servicescan 192.168.1.1:7001 weblogic

# Mass scan from target list
xray massal targets.txt

# Scheduled scan every 6 hours, 4 times
xray schedule https://example.com 21600 4

# CVE research with exploit lookup
xray tools cve CVE-2024-21626

# Full auto-exploitation pipeline
xray tools exploit https://target.com

# Launch the web dashboard
xray webui
# Then open http://localhost:9998 in your browser
```

---

## Menu Reference

The interactive menu provides 22 options covering all functionality:

| # | Command | Description |
|---|---------|-------------|
| 1 | `webscan` | Scan a single website |
| 2 | `servicescan` | Scan service or port |
| 3 | `subdomain` | Enumerate subdomains |
| 4 | `x` | Scan with all plugins enabled |
| 5 | `webscan massal` | Scan multiple targets from a file |
| 6 | `schedule scan` | Run recurring scans |
| 7 | `poclint` | Validate POC YAML syntax |
| 8 | `reverse` | Start the reverse listener |
| 9 | `genca` | Generate CA certificate and key |
| 10 | `version` | Display version |
| 11 | `convert` | Convert scan results |
| 12 | `burp-gamma` | Convert Burp Suite exports |
| 13 | `transform` | Transform scripts |
| 14 | `update POC` | Download latest POCs |
| 15 | `POC builder` | Create and validate POCs |
| 16 | `summary` | Aggregate all reports |
| 17 | `install` | Run setup |
| 18 | `web UI` | Launch browser dashboard |
| 19 | `CVE lookup` | Search CVE details |
| 20 | `searchsploit` | Search Exploit-DB |
| 21 | `diff scan` | Compare scan results |
| 22 | `auto exploit` | Full exploitation pipeline |

---

## Advanced Usage

### Web Dashboard

The web UI provides a real-time dashboard for browsing scan results:

```bash
xray webui
# Open http://localhost:9998
```

Features:
- Statistics cards (total scans, today, vulnerabilities, new)
- Filter by report type
- Search by filename or content
- Direct links to individual reports

### Auto Exploit Pipeline

The `xray tools exploit` command runs a multi-stage pipeline:

1. **Scan** — Run xray webscan against the target
2. **Analyze** — Parse results for CVE identifiers and vulnerability details
3. **Search** — Query Exploit-DB for matching exploits
4. **Verify** — Run Nuclei for confirmation (if installed)

```bash
xray tools exploit https://target.com
```

### Interactsh Integration

Switch the reverse server to use [interact.sh](https://app.interactsh.com) — a cloud-based solution that requires no local port forwarding:

```bash
xray tools interactsh
```

This enables all reverse-dependent POCs without additional infrastructure.

### CVE Research

Look up CVE details from public databases with automatic exploit correlation:

```bash
xray tools cve CVE-2024-21626
```

Output includes:
- CVSS score and severity
- Description
- Available exploits from Exploit-DB

### Diff Analysis

Track changes between scan runs:

```bash
# Run after at least one scan
xray tools diff
```

Displays newly added and removed reports since the last snapshot.

---

## Configuration

### config.yaml

The main configuration file is auto-generated on first run. Key settings:

| Setting | Default | Description |
|---------|---------|-------------|
| `reverse.http` | enabled:9999 | HTTP reverse listener |
| `reverse.dns` | enabled:5353 | DNS reverse listener |
| `reverse.rmi` | enabled:1099 | RMI reverse listener |
| `reverse.token` | auto-generated | Authentication token |

### module.xray.yaml / plugin.xray.yaml

These files define enabled modules and their parameters. Modify them to customize scan behavior.

### xray.yaml

Defines custom commands and plugin groups. The default `x` command enables all plugins.

---

## Project Structure

```
xray-patched/
├── xray-patched           # Binary (ADVANCED, patched)
├── xray                   # CLI entry point
├── xray-menu.sh           # Interactive menu (22 options)
├── xray-webui             # Web dashboard (Python)
├── xray-tools             # Tools: CVE, exploit, diff, interactsh
├── install.sh             # Automated installer
├── config.yaml            # Main configuration
├── module.xray.yaml       # Module configuration
├── plugin.xray.yaml       # Plugin configuration
├── xray.yaml              # Command configuration
├── reports/               # Scan results
│   └── .diffs/            # Diff snapshots
├── poc/                   # POC files
└── lists/                 # Target lists
```

---

## Credits

- **Original Project:** [chaitin/xray](https://github.com/chaitin/xray)
- **Patch & Enhancements:** [ARIFxVOID](https://github.com/ARIFxVOID)
- **Interactsh:** [projectdiscovery/interactsh](https://github.com/projectdiscovery/interactsh)

---

## License

This project is for educational and authorized security testing purposes only. Users are responsible for compliance with applicable laws.
