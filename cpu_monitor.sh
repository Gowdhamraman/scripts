#!/bin/bash

# Monitor CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU Usage: $cpu_usage%"

# Monitor Memory Usage
memory_usage=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
echo "Memory Usage: $memory_usage%"

# Monitor Disk Usage
disk_usage=$(df -h | awk '$NF=="/"{printf "%s", $5}')
echo "Disk Usage: $disk_usage"

# Example for monitoring disk usage on other partitions
# disk_usage_home=$(df -h | awk '$NF=="/home"{printf "%s", $5}')
# echo "Disk Usage (/home): $disk_usage_home"

