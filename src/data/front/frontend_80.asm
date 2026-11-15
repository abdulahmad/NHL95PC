; The saved-game name, the palette cycle on the loading picture, and the trade roster.
bits 32
%include "hockey.inc"
section s_DC834 nobits alloc noexec write align=1
global awayremap, awayremap_e43, awayremap_eFF, homeremap, homeremap_e05, homeremap_e07, homeremap_e10
global homeremap_e11, homeremap_e13, homeremap_e14, homeremap_e16, homeremap_e43, homeremap_e49, homeremap_e50, homeremap_e51
global homeremap_e60, homeremap_eFB, homeremap_eFC, homeremap_eFD, homeremap_eFE, homeremap_eFF, menuremap, menuremap2
global savefname, fdlgmask, leaguedbfmt2, leaguedbfmt, othergames, othergamesb
global otherscores, otherscoresb, leagueflags, lgteamflags, lgteam_17, lgteam_18, lgteam_19, savedname
global lgschedrec, lgschedrec_b1, lgschedrec_b2, lgschedrec_b3, lgschedrec_b5, traderoster, tradejersey, tradeslot
global byte_DE268, loadpals, palcyclephase, palcycledelay, dword_DC85C, dword_DC860, dword_DC868, deskptry
global deskptrx, dword_DC8A0, dword_DC8C8, dirtyrectptr, statspalshape, statsbgshapes, statsteamrecs, statsteambuf
global statsskaterbuf, statsgoaliebuf, statssortkeys, statsplayerbuf, statspal, exhfiles
global exhfilenames, pofiles, pofilenames, lgfiles
global lgfilenames, fdlg_tabexh, fdlg_none, fdlg_tabpo, fdlg_open
global fdlg_del, fdlg_up, fdlg_cancel, fdlg_tabnone, fdlg_down, fdlgtab, fdlg_arrow, fdlg_tablp
global fdlg_noarrow, hmcrestbmp, vscrestbmp, dlgsavex, dlgsavey, editcurw, editpos, editmaxw
global editbuf, editcuron, edity, editx, dword_DD6A6, rinkwtiles, rinkhtiles, bgscrolly
global otherperiod, floppyok, dbextension, calsel, floppyprobe, calexit, teamselresult
global traderesult, calmonth, criterrflag, leaguemaster, leaguesaved, lgteamver, humancount, calselday
global calredraw, calselmonth, dword_DDD34, lgplayteam, dword_DDD3C, lgschedrec_b4, gridcelly, gridcellx
global lgplayeridfile, tradeclick, traderemap1, traderemap2, tradecursor, jerseymsg
global tradeside, tradebitmap, dword_DE265, palcyclelock, dword_DEB74, statsplayer
global unk_DC890, awayremap_eC0, homeremap_eC0, printfbuf, leagueteams, treeteamnames, unk_DDCFB
global masterpw, savleague1, savleague2, scrolly, scrollx, bgscrollx, bgscrolly8
global lgteamver_hi, lggameidx, word_DDD48, word_DDD4A
statsplayer:
resb 2
resb 1
resb 16
resb 21
dword_DC85C:
resb 4
dword_DC860:
resb 8
dword_DC868:
resb 32
deskptry:
resb 4
deskptrx:
resb 4
unk_DC890:
resb 16
dword_DC8A0:
resb 40
dword_DC8C8:
resb 8
dirtyrectptr:
resb 8
awayremap:
resb 67
awayremap_e43:
resb 125
awayremap_eC0:
resb 63
awayremap_eFF:
resb 1
homeremap:
resb 5
homeremap_e05:
resb 2
homeremap_e07:
resb 9
homeremap_e10:
resb 1
homeremap_e11:
resb 2
homeremap_e13:
resb 1
homeremap_e14:
resb 2
homeremap_e16:
resb 45
homeremap_e43:
resb 6
homeremap_e49:
resb 7
homeremap_e50:
resb 1
homeremap_e51:
resb 15
homeremap_e60:
resb 96
homeremap_eC0:
resb 59
homeremap_eFB:
resb 1
homeremap_eFC:
resb 1
homeremap_eFD:
resb 1
homeremap_eFE:
resb 1
homeremap_eFF:
resb 1281
menuremap:
resb 128
menuremap2:
resb 128
printfbuf:
resb 40
statspalshape:
resb 4
statsbgshapes:
resb 4
statsteamrecs:
resb 4
statsteambuf:
resb 4
statsskaterbuf:
resb 4
statsgoaliebuf:
resb 4
statssortkeys:
resb 4
statsplayerbuf:
resb 4
statspal:
resb 4
exhfiles:
resb 4
resb 4
resb 4
resb 4
exhfilenames:
resb 128
pofiles:
resb 4
resb 4
resb 4
resb 4
pofilenames:
resb 128
lgfiles:
resb 4
resb 4
resb 4
resb 4
lgfilenames:
resb 128
savefname:
resb 8
resb 856
fdlg_tabexh:
resb 4
fdlg_none:
resb 4
fdlg_tabpo:
resb 4
fdlg_open:
resb 4
fdlg_del:
resb 4
fdlg_up:
resb 4
fdlg_cancel:
resb 4
fdlg_tabnone:
resb 4
fdlg_down:
resb 4
fdlgtab:
resb 4
fdlg_arrow:
resb 4
fdlg_tablp:
resb 4
fdlg_noarrow:
resb 4
fdlgmask:
resb 1
resb 3
hmcrestbmp:
resb 4
vscrestbmp:
resb 8
dlgsavex:
resb 16
dlgsavey:
resb 4
editcurw:
resb 4
editpos:
resb 4
editmaxw:
resb 4
editbuf:
resb 4
editcuron:
resb 4
edity:
resb 4
editx:
resb 2
dword_DD6A6:
resb 2
rinkwtiles:
resb 2
scrolly:
resb 2
scrollx:
resb 2
rinkhtiles:
resb 2
bgscrolly:
resb 2
bgscrollx:
resb 90
bgscrolly8:
resb 4
leaguedbfmt2:
resb 32
otherperiod:
resb 24
floppyok:
resb 4
resb 4
leaguedbfmt:
resb 32
dbextension:
resb 4
othergames:
resb 1
othergamesb:
resb 11
calsel:
resb 4
floppyprobe:
resb 4
otherscores:
resb 1
otherscoresb:
resb 11
calexit:
resb 4
teamselresult:
resb 4
traderesult:
resb 4
calmonth:
resb 4
criterrflag:
resb 4
leaguemaster:
resb 4
leaguesaved:
resb 4
leagueflags:
resb 4
leagueteams:
resb 22
lgteamflags:
resb 1
lgteam_17:
resb 1
lgteam_18:
resb 1
lgteam_19:
resb 1
lgteamver:
resb 2
lgteamver_hi:
resb 752
humancount:
resb 4
treeteamnames:
resb 546
resb 21
unk_DDCFB:
resb 21
savedname:
resb 13
masterpw:
resb 11
calselday:
resb 4
calredraw:
resb 4
calselmonth:
resb 4
dword_DDD34:
resb 4
lgplayteam:
resb 4
dword_DDD3C:
resb 4
lgschedrec:
resb 1
lgschedrec_b1:
resb 1
lgschedrec_b2:
resb 1
lgschedrec_b3:
resb 1
lgschedrec_b4:
resb 1
lgschedrec_b5:
resb 1
lggameidx:
resb 2
word_DDD48:
resb 2
word_DDD4A:
resb 2
savleague1:
resb 13
savleague2:
resb 15
gridcelly:
resb 4
gridcellx:
resb 4
lgplayeridfile:
resb 4
tradeclick:
resb 4
resb 4
traderemap1:
resb 4
traderemap2:
resb 4
tradecursor:
resb 4
resb 4
traderoster:
resb 1
tradejersey:
resb 1
tradeslot:
resb 614
resb 616
jerseymsg:
resb 4
tradeside:
resb 4
tradebitmap:
resb 1
dword_DE265:
resb 3
byte_DE268:
resb 4
loadpals:
resb 2304
palcyclelock:
resb 4
palcyclephase:
resb 1
palcycledelay:
resb 3
dword_DEB74:
resb 4
