import subprocess

def disk_space():
    diskcheck = subprocess.run(["df", "-h"] capture_output=True, text=True)
    line = diskcheck.stdout.strip().split('\n')

    head = line[0].split()
    Index =  head.index('FileSystem')
    Avail = head.index('avail')

    for l in line[1:]:
        P = l.split()
        if len(l) >= max(Index, Avail) +1:
            print(f"")