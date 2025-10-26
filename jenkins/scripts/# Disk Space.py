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


#!/usr/bin/env python3
import os
import sys

def find_symlinks(root_dir):
    """
    Recursively find all symbolic links in a given directory.
    """
    for dirpath, dirnames, filenames in os.walk(root_dir, followlinks=False):
        # Check directories
        for d in dirnames:
            full_path = os.path.join(dirpath, d)
            if os.path.islink(full_path):
                print(f"Directory symlink: {full_path} -> {os.readlink(full_path)}")

        # Check files
        for f in filenames:
            full_path = os.path.join(dirpath, f)
            if os.path.islink(full_path):
                print(f"File symlink: {full_path} -> {os.readlink(full_path)}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <directory>")
        sys.exit(1)

    root_directory = sys.argv[1]

    if not os.path.isdir(root_directory):
        print(f"Error: {root_directory} is not a valid directory.")
        sys.exit(1)

    find_symlinks(root_directory)
