#!/bin/bash

#PingSweep/Nmap scanning Tool

BLEU='\033[0;34m'
NC='\033[0m'

echo -e "${BLEU}  ____       _            _   _           _      ${NC}"
echo -e "${BLEU} / ___| __ _| | __ _  ___| |_(_) ___ __ _| |     ${NC}"
echo -e "${BLEU}| |  _ / _\` | |/ _\` |/ __| __| |/ __/ _\` | |     ${NC}"
echo -e "${BLEU}| |_| | (_| | | (_| | (__| |_| | (_| (_| | |     ${NC}"
echo -e "${BLEU} \____|\__,_|_|\__,_|\___|\__|_|\___\__,_|_|     ${NC}"
echo -e "${BLEU}                                                   ${NC}"
echo -e "${BLEU}        ____  _             ____                  ${NC}"
echo -e "${BLEU}       |  _ \(_)_ __   __ _/ ___|_      _____  ___ _ __   ${NC}"
echo -e "${BLEU}       | |_) | | '_ \ / _\` \___ \ \ /\ / / _ \/ _ \ '_ \ ${NC}"
echo -e "${BLEU}       |  __/| | | | | (_| |___) \ V  V /  __/  __/ |_) |${NC}"
echo -e "${BLEU}       |_|   |_|_| |_|\__, |____/ \_/\_/ \___|\___| .__/ ${NC}"
echo -e "${BLEU}                        |___/                       |_|   ${NC}"

if [ "$1" == "" ]; then
    echo -e "${BLEU} Enter a IP range please...${NC}"
    echo ''
    echo -e "${BLEU} Syntax must be: ./PingSweep.sh x.x.x.${NC}"
    exit 1
fi

echo -e "${BLEU} [?] Choose your mission:${NC}"
echo -e "${BLEU}     1) Lord Vader    (Lab  T4 -p- -sVC Full scan)${NC}"
echo -e "${BLEU}     2) Jedi Mode     (Prod - T2 -sV Stealth scan)${NC}"
read -p " > " mode

if [ "$mode" == "1" ]; then
    NMAP_OPTS="-Pn -A -sVC -T4 -p-"
    echo -e "${BLEU} [+] Lord Vader mode engaged. The dark side is strong...${NC}"
elif [ "$mode" == "2" ]; then
    NMAP_OPTS="-Pn -sV -T2 --top-ports 1000"
    echo -e "${BLEU} [+] Jedi mode activated. May the Force be with you...${NC}"
else
    echo -e "${BLEU} [-] Unknown mission. Aborting.${NC}"
    exit 1
fi

RESULTS_DIR="results/$(date +%Y-%m-%d_%H-%M-%S)_$1"
mkdir -p "$RESULTS_DIR"

> "$RESULTS_DIR/sweep_result.txt"

echo -e "${BLEU} [+] Let's explore the galaxy...${NC}"

MAX_PING=20
count=0
for ip in $(seq 1 254); do
    ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> "$RESULTS_DIR/sweep_result.txt" &
    count=$((count + 1))
    if [ $count -ge $MAX_PING ]; then
        wait
        count=0
    fi
done
wait

if [ ! -s "$RESULTS_DIR/sweep_result.txt" ]; then
    echo -e "${BLEU} [-] No hosts found. Exiting.${NC}"
    exit 1
fi

echo -e "${BLEU} [+] $(wc -l < "$RESULTS_DIR/sweep_result.txt") host(s) found. Launching drones...${NC}"

MAX_NMAP=5
count=0
pids=()
while read ip; do
    echo -e "${BLEU} [*] Scanning $ip...${NC}"
    nmap $NMAP_OPTS $ip >> "$RESULTS_DIR/nmap_$ip.txt" &
    pids+=($!)
    count=$((count + 1))
    if [ $count -ge $MAX_NMAP ]; then
        wait
        count=0
        pids=()
    fi
done < "$RESULTS_DIR/sweep_result.txt"
wait

echo -e "${BLEU} [+] Results saved in $RESULTS_DIR${NC}"
echo -e "${BLEU} [+] It's Done, may the Hack be with you...${NC}"

