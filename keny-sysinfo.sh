#!/bin/bash

set -eu

fstr=$(tput bold)
fend=$(tput sgr0)

# Check OS version
echo "${fstr}System version:${fend}" $(lsb_release -ds)

# Check kernel release
echo "${fstr}Kernel release:${fend}" $(uname -sr)

# Check CPU model name
echo "${fstr}CPU model:${fend}" $(grep -e "model name" /proc/cpuinfo | uniq | cut -d ':' -f 2)

# Check number of CPU cores
echo "${fstr}Number of CPU cores:${fend}" $(grep "processor" /proc/cpuinfo | wc -l)

# Check architecture
echo "${fstr}Architecture:${fend}" $(arch)

# Check system uptime
echo "${fstr}System uptime:${fend}" $(uptime -p)

# Check load averages
echo "${fstr}Load averages:${fend}" $(awk '{printf "[1m] %s [5m] %s [10m] %s", $1, $2, $3}' /proc/loadavg)

# Check number of running processes
echo "${fstr}Number of running processes:${fend}" $(awk '{printf "%s", $4}' /proc/loadavg)

# Check memory usages
echo "${fstr}Memory usages:${fend}" $(awk '/MemTotal/ {t = $2/1048576} /MemFree/ {f = $2/1048576} /MemAvailable/ {a = $2/1048576} END {printf "[%.1f%%] Total: %.2f GB, Free: %.2f GB, Available: %.2f GB", (1 - a / t) * 100, t, f, a}' /proc/meminfo)

# Check swap usages
echo "${fstr}Swap usages:${fend}" $(awk '/SwapTotal/ {t = $2/1048576} /SwapCached/ {c = $2/1048576} /SwapFree/ {f = $2/1048576} END {printf "[%.1f%%] Total: %.2f GB, Cached: %.2f GB, Free: %.2f GB", (1 - f / t) * 100, t, c, f}' /proc/meminfo)

# Check disk usages
echo "${fstr}Disk usages:${fend}" && df -h --type=ext4 | awk '/\/dev\// {printf "[%4s of %4s] %s -> %s\n", $5, $2, substr($1, 6, length($1)), $6}'

# Check hostname
echo "${fstr}Hostname:${fend}" $(hostname)

# Check users logged in
echo "${fstr}Users logged in:${fend}" $(who | wc -l)

# Check if connected to Internet or not
ping -c 1 google.com &> /dev/null && echo "${fstr}Internet connection:${fend} active" || echo "${fstr}Internet:${fend} inactive"

# Check internal IP address
echo "${fstr}Internal IP address:${fend}" $(hostname -I)

# Check external IP address
echo "${fstr}External IP address:${fend}" $(curl -s ipinfo.io/ip)

# Check listening ports
# echo "${fstr}Listening ports:${fend}" && netstat -plnt

# Check services
echo "${fstr}Services:${fend}"  $(systemctl list-units | awk '/deluged|mysql|nmbd|plex|ssh|smbd|ufw/ {printf "%s [%s] ", substr($1, 1, length($1) - 8), $3 == "active" ? "+" : "-"}')
