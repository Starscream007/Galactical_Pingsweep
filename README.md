# 🌌 Galactical PingSweep

Automated ping sweep + Nmap scanner for Kali Linux, with two scan modes.

## Usage

chmod +x Galactical_Pingsweep.sh
./Galactical_Pingsweep.sh x.x.x.

Example:
./Galactical_Pingsweep.sh 192.168.1.

## Modes

| Mode | Style | Nmap options | Use case |
|------|-------|--------------|----------|
| Lord Vader | Guns blazing | -Pn -A -sVC -T4 -p- | Lab / CTF |
| Jedi Mode  | Ghost mode   | -Pn -sV -T2 --top-ports 1000 | Prod / Engagement |

## Features

- ICMP ping sweep with parallel jobs (max 20 simultaneous)
- Automatic Nmap scan on discovered hosts (max 5 simultaneous)
- Results saved in timestamped folders : results/YYYY-MM-DD_HH-MM-SS_range/
- One Nmap output file per host

## Requirements

- nmap
- ping (iputils-ping)

## Output structure

results/
└── 2026-05-02_21-42-00_192.168.1./
    ├── sweep_result.txt
    ├── nmap_192.168.1.1.txt
    └── nmap_192.168.1.254.txt

## Disclaimer

For educational purposes and authorized engagements only.
The author is not responsible for any misuse of this tool.
