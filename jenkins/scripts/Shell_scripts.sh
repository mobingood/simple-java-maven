read -p "Enter any number" Number_1 Number_2
read -sp "Enter password" password

sed -i 's/find_teext/repalce/g' filepath

sed -i 's/^port=.*/port=9090/' filepath 
sed -i '32i insertline' filepath 


#!/bin/bash

# Title: disk_check.sh
# Description: A simple shell script to check disk utilization across all mounted filesystems.
#              It flags any filesystem that exceeds a predefined threshold.

# --- Configuration ---
# Set the utilization threshold percentage. If any disk usage is above this, a warning is displayed.
# Example: 80 means 80% used.
UTILIZATION_THRESHOLD=80

echo "==================================================="
echo "    Disk Utilization Check Script"
echo "    Threshold set to: ${UTILIZATION_THRESHOLD}%"
echo "==================================================="

# Command to get disk usage:
# df -h: Human-readable format
# | awk 'NR>1': Skip the header line
# | awk '{print $5, $6}': Print the usage percentage ($5) and the mount point ($6)
df -h | awk 'NR>1 {print $5, $6}' | while read usage mount_point; do
    
    # Remove the '%' sign from the usage value for comparison
    used_percentage=$(echo $usage | sed 's/%//g')
    
    # --- Check for high usage ---
    if [[ $used_percentage -ge $UTILIZATION_THRESHOLD ]]; then
        # If usage is above the threshold, print a critical warning
        echo "[CRITICAL] ${mount_point} is ${usage} used! (>= ${UTILIZATION_THRESHOLD}%)"
    else
        # If usage is below the threshold, print informational status
        echo "[OK] ${mount_point} is ${usage} used."
    fi

done

echo "==================================================="
echo "Full Disk Usage Report (df -h):"
echo "==================================================="





