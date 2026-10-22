#!/usr/bin/env python3
"""state_probe.py - does a draft compile differently in another compiler state?

  python3 tools/state_probe.py src/c/<seg>/<File>.c:FUNC [...]

wcc386 can compile the same source differently after other files in the same DOSBox run (HANDOFF step 3, the
compiler state). For each draft this compiles, in one DOSBox run, the draft fresh and then after each of four
warm-up files, and prints the permute.py score of each (MATCH for a match). The same number in every column: the
draft is not state-sensitive. make compiles every file fresh, so only the first column counts for a match."""
import os, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import cc, permute

WARM = ['src/c/040_53294_engine_physics_ai/ChkPullGoalieLate.c', 'src/c/015_1D6E8_menu_system/CmpPoints.c',
        'src/c/018_27080_standings_playoffs/PlayoffTreeHitTest.c', 'src/c/046_644A8_engine_display/BuildDefaultLines.c']


def main():
    if len(sys.argv) < 2: raise SystemExit(__doc__)
    os.chdir(ROOT)
    print('%-22s %6s %s' % ('draft', 'fresh', ' '.join('%6s' % os.path.basename(w)[:6] for w in WARM)), flush=True)
    for spec in sys.argv[1:]:
        src, func = spec.rsplit(':', 1)
        seq = [src]
        for w in WARM: seq += [w, src]
        objs = [os.path.join(ROOT, 'build', 'permute', 'probe%d.obj' % k) for k in range(len(seq))]
        os.makedirs(os.path.dirname(objs[0]), exist_ok=True)
        oks = cc.compile_batch_raw([(s, o, cc.src_flags(s)) for s, o in zip(seq, objs)])
        out = []
        for s, o, ok in zip(seq, objs, oks):
            if s != src: continue
            if not ok: out.append('  fail'); continue
            try: r = permute.score(src, o, func, src)
            except (SystemExit, Exception): out.append('   err'); continue
            out.append('%6s' % ('MATCH' if r[2] else r[0]))
        for o in objs:
            if os.path.exists(o): os.remove(o)
        print('%-22s %s' % (func, ' '.join(out)), flush=True)


if __name__ == '__main__':
    main()
