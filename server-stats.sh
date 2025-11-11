#!/bin/bash
# server-stats.sh - Display basic Linux server performance stats
# Usage: ./server-stats.sh

echo "============================================"
echo "📊 SERVER PERFORMANCE STATISTICS"
echo "============================================"
echo "Hostname     : $(hostname)"
echo "Date & Time  : $(date)"
echo "Uptime       : $(uptime -p)"
echo

# ---------------------------------------------------------
# 1. Total CPU Usage
# ---------------------------------------------------------
echo "===== 🧠 CPU USAGE ====="

# Get total CPU usage (user + system + nice + iowait + steal)
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | grep -oP '\d+\.\d+(?=\s*id)')
CPU_USED=$(echo "100 - $CPU_IDLE" | bc)
echo "Total CPU Usage : ${CPU_USED}%"
echo

# ---------------------------------------------------------
# 2. Memory Usage
# ---------------------------------------------------------
echo "===== 🧮 MEMORY USAGE ====="

# Use 'free -m' for memory in MB
read -r MEM_TOTAL MEM_USED MEM_FREE <<<$(free -m | awk '/^Mem:/{print $2, $3, $4}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}")
echo "Total Memory : ${MEM_TOTAL} MB"
echo "Used Memory  : ${MEM_USED} MB"
echo "Free Memory  : ${MEM_FREE} MB"
echo "Usage Percent: ${MEM_PERCENT}%"
echo

# ---------------------------------------------------------
# 3. Disk Usage
# ---------------------------------------------------------
echo "===== 💾 DISK USAGE ====="

# Show total disk usage for all mounted filesystems
df -h --total | awk '
/^total/ {
  print "Total Disk Space : " $2;
  print "Used Disk Space  : " $3;
  print "Free Disk Space  : " $4;
  print "Usage Percent    : " $5;
}'
echo

# ---------------------------------------------------------
# 4. Top 5 Processes by CPU Usage
# ---------------------------------------------------------
echo "===== 🔥 TOP 5 PROCESSES BY CPU ====="
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
echo

# ---------------------------------------------------------
# 5. Top 5 Processes by Memory Usage
# ---------------------------------------------------------
echo "===== 💡 TOP 5 PROCESSES BY MEMORY ====="
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6
echo

echo "============================================"
echo "✅ END OF REPORT"
echo "============================================"
