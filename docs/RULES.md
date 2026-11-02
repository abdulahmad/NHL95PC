# Rules learned

This file is the learning edge of the repo. It holds one line per confirmed lesson: a C idiom that changes behaviour, a harness blind spot, or a process fact that was checked. Add lines in this format, newest last: `- YYYY-MM-DD <function or area>: <rule>. (<PR or evidence>)`. Read it before every unit. Any tool (Claude or Cursor) adds to it, in the same PR as the fix that confirmed the lesson.

## Functional track

- 2026-11-02 SeriesLength: a draft whose original returns an unset local (whatever a register held on entry) is NEEDS-REVIEW, not PASS; the harness must seed that register the same on both sides and flag it. (docs/FUNCTIONAL_PLAN.md)
