# Rules learned

This file is the learning edge of the repo. It holds one line per confirmed lesson: a C idiom that changes behaviour, a harness blind spot, or a process fact that was checked. Add lines in this format, newest last: `- YYYY-MM-DD <function or area>: <rule>. (<PR or evidence>)`. Read it before every unit. Any tool (Claude or Cursor) adds to it, in the same PR as the fix that confirmed the lesson.

## Functional track

- 2026-11-02 SeriesLength: when the original returns an unset local (whatever a register held on entry), the entry registers carry unique tags so it shows. If the draft returns the same tag in every such case it behaves the same: PASS with the note kept in `first_diff`. If not, FAIL. (step 5 pilot, step 6 review)
- 2026-11-02 harness: a case where the original traps (fault, insn limit) is still compared, never skipped: both sides must trap with the same kind, and the writes and calls before the trap must agree (for an insn limit, the shorter log must be a prefix of the longer). (step 6 review: FadePalette lost 37% of its cases)
- 2026-11-02 harness: PASS needs coverage. The check reports the share of the original's instructions executed over all cases; under 85% is NEEDS-REVIEW with the uncovered address ranges listed. (step 6 review)
- 2026-11-02 harness: a stack address passed to a callee is compared by the 16 bytes it points to, not as a bare "STK". The callee stub writes 4 seeded bytes there (an out-parameter), the same on both sides, and those bytes count as written. (step 6 review)
- 2026-11-02 harness: callee `ret N` is found by following the callee's code, including a jmp to a shared epilogue, never by taking the next `ret N` in memory. (step 5, SeriesWinner)
- 2026-11-02 harness: a planted one-constant bug must FAIL within the first 50 cases; if a buffer generator change makes it slower, the generator regressed. (step 5)
