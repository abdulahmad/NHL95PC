; The penalty buffer, how excited the crowd is, and the period clock.
bits 32
%include "hockey.inc"
section s_E9A11 nobits alloc noexec write align=1
global Ylist_m2, PBnum, PenBuf_pl_m2, PenBuf, PenBuf_pl
global iflags, icingPlayer, curevent, curevent_b1, curevent_b2, curevent_b3, curevent_b4, curevent_b5
global curevent_b6, curevent_b7, curevent_b8, curevent_b9, curevent_b10, goalevent, goalevent_b1, goalevent_b2
global goalevent_b3, goalevent_b4, OOlist, defsort_d, dressflags, dressflags_aw, offsort_fwd
global rpl_flip, rpl_jersey, rpl_pos, rpl_pos_b1, rpl_c1player, rpl_c2player, rpl_puckc, rpl_pbnum
global rpl_pbnum_b1, rpl_objstep, rpl_objstep_b1, PenBuf_m5, PenBuf_m2, dword_E9A9E, dword_E9AB6
global dword_E9AB7, gwgteam, gwgplayer, startm_m2, seqtimer
global rinkobjused_m2, defertab, defertab_a1, defertab_a2, defertab_a3, defertab_a4, defertab_a5, defertab_a6
global defertab_fn, lineslotmark, dword_E9C85, linesortidx, dressedskaters, rpl_x_e14_m2, rpl_x_e14, rpl_x_e16
global rpl_y_e14_m2, rpl_y_e14, rpl_y_e16, rpl_frame_e14_m2, rpl_frame_e14, rpl_flip_m3, rpl_jersey_m3, rpl_pos_m3
global rpl_puckz_m2, rpl_c1player_m3, rpl_puckc_m3, rpl_objstep_m3, rpl_ysort, ltx, gsumqueue, offsort_c
global defsort_r, offsort_d, defsort_c, offsort_l, defsort_l, offsort_r, defsort_fwd, Ylist
global OOlistpos, word_E9A9C, joysampling_save, word_E9AA2, MaxCwdExciteLvl, NumCwdExciteLvl, CwdExciteLvl, word_E9AAA
global periodendtime, penevteam, word_E9AB0, ovlsteptimer, ovlstepidx, PerTimeTotal, lj2, lj1
global lasttouch, lty, startm, starpl, lastimpact, rinkobjused, dressedfwds, dresseddefs
global rpl_x, rpl_x_e15, rpl_y, rpl_y_e15, rpl_frame, rpl_frame_e15, rpl_puckz, word_E9FA9
global rpl_camx, rpl_camy, rpl_objframe
PenBuf_m5:
        resb 2
        resb 1
PenBuf_m2:
        resb 1
PenBuf_pl_m2:
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
penevteam:
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
lineslotmark:
        resb 97
dword_E9C85:
        resb 3
linesortidx:
        resb 100
offsort_c:
        resb 50
defsort_r:
        resb 50
offsort_d:
        resb 50
defsort_c:
        resb 50
defsort_d:
        resb 50
offsort_l:
        resb 50
dressflags:
        resb 25
dressflags_aw:
        resb 25
offsort_fwd:
        resb 50
defsort_l:
        resb 50
offsort_r:
        resb 50
defsort_fwd:
        resb 50
dressedfwds:
        resb 2
dresseddefs:
        resb 2
dressedskaters:
        resb 2
rpl_x:
        resb 26
rpl_x_e14_m2:
        resb 2
rpl_x_e14:
        resb 2
rpl_x_e15:
        resb 2
rpl_x_e16:
        resb 2
rpl_y:
        resb 26
rpl_y_e14_m2:
        resb 2
rpl_y_e14:
        resb 2
rpl_y_e15:
        resb 2
rpl_y_e16:
        resb 2
rpl_frame:
        resb 26
rpl_frame_e14_m2:
        resb 2
rpl_frame_e14:
        resb 2
rpl_frame_e15:
        resb 1
rpl_flip_m3:
        resb 3
rpl_flip:
        resb 14
rpl_jersey_m3:
        resb 3
rpl_jersey:
        resb 9
rpl_pos_m3:
        resb 3
rpl_pos:
        resb 1
rpl_pos_b1:
        resb 9
rpl_puckz_m2:
        resb 2
rpl_puckz:
        resb 1
rpl_c1player_m3:
        resb 1
word_E9FA9:
        resb 1
rpl_puckc_m3:
        resb 1
rpl_c1player:
        resb 1
rpl_c2player:
        resb 1
rpl_puckc:
        resb 1
rpl_pbnum:
        resb 1
rpl_pbnum_b1:
        resb 1
rpl_camx:
        resb 2
rpl_camy:
        resb 2
rpl_objframe:
        resb 37
rpl_objstep_m3:
        resb 3
rpl_objstep:
        resb 1
rpl_objstep_b1:
        resb 19
rpl_ysort:
        resb 68
