; Tables the scoring text adds up, and the picture list the animation player steps through.
bits 32
%include "hockey.inc"
section s_DEB78 nobits alloc noexec write align=1
global rinkobjs_b3, dword_DEB78, dword_DEB7C, dword_DEB80, ovlstepart, ovlstepart_e21, ovlstepart_e30, rinkobjs
global rinkobjs_w2, word_DEF84, word_DEF88
dword_DEB78:
resb 4
dword_DEB7C:
resb 4
dword_DEB80:
resb 788
rinkobjs:
resb 2
rinkobjs_w2:
resb 1
rinkobjs_b3:
resb 237
word_DEF84:
resb 4
word_DEF88:
resb 4
ovlstepart:
resb 84
ovlstepart_e21:
resb 36
ovlstepart_e30:
resb 8
