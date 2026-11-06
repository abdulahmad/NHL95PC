; The home roster, and the jersey numbers that go with it.
bits 32
%include "hockey.inc"
section s_DB218 nobits alloc noexec write align=1
global hmroster, hmrosterjersey, byte_DB3AE, unk_DB218
unk_DB218:
resb 400
hmroster:
resb 5
hmrosterjersey:
resb 1
byte_DB3AE:
resb 1086
