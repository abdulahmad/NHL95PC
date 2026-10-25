#!/usr/bin/env python3
"""where.py RUNTIME_EIP -- map a runtime address of build/hockey-linux (or, when that is missing, build/win/hockey-win32.exe, which is
linked at a fixed address) to the original address and show the asm around it. $NM names the nm program (default nm)."""
import glob, os, re, subprocess, sys
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
exe = os.path.join(root, 'build/hockey-linux')
if not os.path.exists(exe):
    exe = os.path.join(root, 'build/win/hockey-win32.exe')
nm = subprocess.run([os.environ.get('NM', 'nm'), exe], capture_output=True, text=True).stdout
base = None
for l in nm.split('\n'):
    p = l.split()
    if len(p) == 3 and p[2] in ('sub_10000', '_sub_10000'):
        base = int(p[0], 16) - 0x10000
a = int(sys.argv[1], 16)
orig = a - base
print('original address %X' % orig)
for f in sorted(glob.glob(os.path.join(root, 'src/cseg01/*.asm'))):
    m = re.match(r'(\d+)_([0-9A-F]+)_', os.path.basename(f))
    if int(m.group(2), 16) <= orig:
        best = f
L = open(best, encoding='latin1').read().split('\n')
print(os.path.basename(best))
idx = None
for i, l in enumerate(L):
    m = re.search(r'; ([0-9A-F]{5})\s*$', l)
    if m and int(m.group(1), 16) >= orig:
        idx = i; break
lab = None
for j in range(idx or 0, 0, -1):
    if re.match(r'^[A-Za-z_][\w@.]*:', L[j]): lab = L[j]; break
print('label:', lab)
for l in L[max((idx or 0) - 8, 0):(idx or 0) + 3]: print('   ', l)
