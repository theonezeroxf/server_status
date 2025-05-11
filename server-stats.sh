#!/bin/bash
# filepath: /root/roadmap/server-stats.sh

echo "===== Server Performance Stats ====="

# Total CPU usage
echo "1. Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4 "%"}'

# Total memory usage
echo -e "\n2. Total Memory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB, Free: %sMB, Usage: %.2f%%\n", $3, $4, $3*100/($3+$4)}'

# Total disk usage
echo -e "\n3. Total Disk Usage:"
df -h --total | grep "total" | awk '{printf "Used: %s, Free: %s, Usage: %s\n", $3, $4, $5}'

# Top 5 processes by CPU usage
echo -e "\n4. Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by memory usage
echo -e "\n5. Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# Network status
echo -e "\n11. Network Status:"
echo "IP Addresses:"
ip -4 addr show | grep inet | awk '{print $2}' | cut -d/ -f1

echo -e "\nActive Network Connections:"
netstat -tunapl | grep ESTABLISHED 

# Stretch goal: Additional stats
echo -e "\n===== Additional Stats ====="

# OS version
echo "6. OS Version:"
cat /etc/os-release | grep -e "^PRETTY_NAME" | cut -d= -f2 | tr -d '"'

# Uptime
echo -e "\n7. System Uptime:"
uptime -p

# Load average
echo -e "\n8. Load Average:"
uptime | awk -F'load average:' '{print $2}'

# Logged in users
echo -e "\n9. Logged In Users:"
who | wc -l | awk '{print $1 " user(s) logged in"}'

# Failed login attempts
echo -e "\n10. Failed Login Attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || echo "Log file not accessible"

echo -e "\n===== End of Stats ====="
