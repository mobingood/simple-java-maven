# Disk Space

#python code for disk space check

import subprocess
#from unittest import result

def check_disk_space():
    check = subprocess.run(['df', '-h'], capture_output=True, text=True)
    split_line = check.stdout.strip().split('\n')

    headers = split_line[0].split()
    file_system_index = headers.index('Filesystem')
    avail_index = headers.index('Avail')

    print(f"{'Filesystem':<30} {'Avail':>10}")
    print("-" * 42)

    for line in split_line[1:]:
        parts = line.split()
        if len(parts) >= max(file_system_index, avail_index) +1:
            print(f"{parts[file_system_index]:<30} {parts[avail_index]:>10}")

check_disk_space()
