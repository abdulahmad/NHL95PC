; The penalty buffer, how excited the crowd is, and the period clock.
bits 32
%include "hockey.inc"
section s_E9A11 nobits alloc noexec write align=1
global Ylist_m2, PBnum, byte_E9A15, PenBuf, PenBuf_pl
global iflags, icingPlayer, curevent, curevent_b1, curevent_b2, curevent_b3, curevent_b4, curevent_b5
global curevent_b6, curevent_b7, curevent_b8, curevent_b9, curevent_b10, goalevent, goalevent_b1, goalevent_b2
global goalevent_b3, goalevent_b4, OOlist, byte_E9DB4, byte_E9E18, byte_E9E31, byte_E9E4A
global byte_E9F7E, byte_E9F8F, byte_E9F9B, byte_E9F9C, byte_E9FAB, byte_E9FAC, byte_E9FAD, byte_E9FAE
global byte_E9FAF, byte_E9FDC, byte_E9FDD, PenBuf_m5, dword_E9A14, dword_E9A9E, dword_E9AB6
global dword_E9AB7, gwgteam, gwgplayer, startm_m2, seqtimer
global rinkobjused_m2, defertab, defertab_a1, defertab_a2, defertab_a3, defertab_a4, defertab_a5, defertab_a6
global defertab_fn, dword_E9C24, dword_E9C85, dword_E9C88, dword_E9F16, dword_E9F32, dword_E9F34, dword_E9F38
global dword_E9F54, dword_E9F56, dword_E9F5A, dword_E9F76, dword_E9F78, dword_E9F7B, dword_E9F8C, dword_E9F98
global dword_E9FA5, dword_E9FA8, dword_E9FAA, dword_E9FD9, dword_E9FF0, ltx, gsumqueue, unk_E9CEC
global unk_E9D1E, unk_E9D50, unk_E9D82, unk_E9DE6, unk_E9E7C, unk_E9EAE, unk_E9EE0, Ylist
global OOlistpos, word_E9A9C, joysampling_save, word_E9AA2, MaxCwdExciteLvl, NumCwdExciteLvl, CwdExciteLvl, word_E9AAA
global periodendtime, word_E9AAE, word_E9AB0, ovlsteptimer, ovlstepidx, PerTimeTotal, lj2, lj1
global lasttouch, lty, startm, starpl, lastimpact, rinkobjused, word_E9F12, word_E9F14
global word_E9F18, word_E9F36, word_E9F3A, word_E9F58, word_E9F5C, word_E9F7A, word_E9FA7, word_E9FA9
global word_E9FB0, word_E9FB2, word_E9FB4
PenBuf_m5:
resb 2
resb 1
dword_E9A14:
resb 1
byte_E9A15:
resb 1
PenBuf:
resb 1
PenBuf_pl:
resb 63
Ylist_m2:
resb 2
Ylist:
resb 34
OOlistpos:
resb 34
word_E9A9C:
resb 2
dword_E9A9E:
resb 2
joysampling_save:
resb 2
word_E9AA2:
resb 2
MaxCwdExciteLvl:
resb 2
NumCwdExciteLvl:
resb 2
CwdExciteLvl:
resb 2
word_E9AAA:
resb 2
periodendtime:
resb 2
word_E9AAE:
resb 2
word_E9AB0:
resb 2
ovlsteptimer:
resb 2
ovlstepidx:
resb 2
dword_E9AB6:
resb 1
dword_E9AB7:
resb 1
PerTimeTotal:
resb 2
PBnum:
resb 1
resb 1
lj2:
resb 2
lj1:
resb 2
iflags:
resb 1
icingPlayer:
resb 1
lasttouch:
resb 2
lty:
resb 2
ltx:
resb 2
curevent:
resb 1
curevent_b1:
resb 1
curevent_b2:
resb 1
curevent_b3:
resb 1
curevent_b4:
resb 1
curevent_b5:
resb 1
curevent_b6:
resb 1
curevent_b7:
resb 1
curevent_b8:
resb 1
curevent_b9:
resb 1
curevent_b10:
resb 1
goalevent:
resb 1
goalevent_b1:
resb 1
goalevent_b2:
resb 1
goalevent_b3:
resb 1
goalevent_b4:
resb 3
resb 1
resb 1
resb 1
resb 1
OOlist:
resb 1
resb 17
gwgteam:
resb 2
resb 2
gwgplayer:
resb 2
startm_m2:
resb 2
startm:
resb 2
starpl:
resb 10
seqtimer:
resb 36
lastimpact:
resb 2
rinkobjused_m2:
resb 2
rinkobjused:
resb 32
gsumqueue:
resb 88
defertab:
resb 4
defertab_a1:
resb 4
defertab_a2:
resb 4
defertab_a3:
resb 4
defertab_a4:
resb 4
defertab_a5:
resb 4
defertab_a6:
resb 4
defertab_fn:
resb 100
dword_E9C24:
resb 97
dword_E9C85:
resb 3
dword_E9C88:
resb 100
unk_E9CEC:
resb 50
unk_E9D1E:
resb 50
unk_E9D50:
resb 50
unk_E9D82:
resb 50
byte_E9DB4:
resb 50
unk_E9DE6:
resb 50
byte_E9E18:
resb 25
byte_E9E31:
resb 25
byte_E9E4A:
resb 50
unk_E9E7C:
resb 50
unk_E9EAE:
resb 50
unk_E9EE0:
resb 50
word_E9F12:
resb 2
word_E9F14:
resb 2
dword_E9F16:
resb 2
word_E9F18:
resb 26
dword_E9F32:
resb 2
dword_E9F34:
resb 2
word_E9F36:
resb 2
dword_E9F38:
resb 2
word_E9F3A:
resb 26
dword_E9F54:
resb 2
dword_E9F56:
resb 2
word_E9F58:
resb 2
dword_E9F5A:
resb 2
word_E9F5C:
resb 26
dword_E9F76:
resb 2
dword_E9F78:
resb 2
word_E9F7A:
resb 1
dword_E9F7B:
resb 3
byte_E9F7E:
resb 14
dword_E9F8C:
resb 3
byte_E9F8F:
resb 9
dword_E9F98:
resb 3
byte_E9F9B:
resb 1
byte_E9F9C:
resb 9
dword_E9FA5:
resb 2
word_E9FA7:
resb 1
dword_E9FA8:
resb 1
word_E9FA9:
resb 1
dword_E9FAA:
resb 1
byte_E9FAB:
resb 1
byte_E9FAC:
resb 1
byte_E9FAD:
resb 1
byte_E9FAE:
resb 1
byte_E9FAF:
resb 1
word_E9FB0:
resb 2
word_E9FB2:
resb 2
word_E9FB4:
resb 37
dword_E9FD9:
resb 3
byte_E9FDC:
resb 1
byte_E9FDD:
resb 19
dword_E9FF0:
resb 68
