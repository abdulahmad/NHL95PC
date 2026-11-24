; Strings and constants of pc/debug_dump (src/pc/debug_dump), in link order.
bits 32
%include "hockey.inc"
section s_C223B progbits alloc noexec write align=1
global str_pen, str_Dopen, str_Goalie2, str_Goalieget, str_Puckc, str_Nearest, str_Shoot, str_Passrec
global str_3star, str_R3star, str_Fowait, str_Pnorm, str_Pshad, str_Pnothing, str_Pface, str_Pface2
global str_Gamemiscon, str_Rfaceoff, str_Rnorm, str_Rcallpen, str_Rpickup, str_Rgotofo, str_Rpointgoal, str_Rgetnew
global str_Anth, str_Ranth, str_Agotofo, str_Benwait, str_Initper, str_Pgivecup, str_Rpenshot, str_Apswait
global str_Abreak, str_Error2, str_G5, str_LD, str_RD2, str_LW, str_C6, str_RW
global str_XC, str_dbgO, str_dbgDash, str_dbgClin, str_dbgPenShot, str_dbgLip, str_dbgHVpos, str_dbgRef
global str_dbgPb, str_dbgG, str_dbgGO, str_dbgGsp, str_dbgC12, str_dbgPuckc, str_dbgIdx, str_dbgD
global str_dbgLbD, str_dbgDRb, str_dbgDS, str_dbgPosVel, str_dbgVz, str_dbgAss, str_dbgL, str_dbgI
global str_dbgSpace, str_dbgSpa, str_dbgS, str_debError, str_newline, str_dbgBail, str_statslog, str_fmode_at
global str_ErrDumpStats, str_dumpPool, str_dumpTmstructs, str_dumpHex, str_dumpSortcords, str_dumpSortLine, str_dumpRule, str_dumpTeamHdrH
global str_dumpHome, str_dumpPlHdrH, str_dumpPlLineH, str_dumpGlHdrH, str_dumpGlLine, str_dumpTeamHdrA, str_dumpAway, str_dumpPlHdrA
global str_dumpPlLineA, str_dumpGlHdrA
str_pen:                                        ; string pen (DebugMonitor prints it for an object in the
                                                ; penalty box); used by DebugMonitor
        db 070h,065h,06Eh,00h
str_Dopen:                                      ; "dopen" string literal
        db 064h,06Fh,070h,065h,06Eh,00h
str_Goalie2:                                    ; "goalie" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,00h
str_Goalieget:                                  ; "goalieget" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,067h,065h,074h,00h
str_Puckc:                                      ; "puckc" string literal
        db 070h,075h,063h,06Bh,063h,00h
str_Nearest:                                    ; "nearest" string literal
        db 06Eh,065h,061h,072h,065h,073h,074h,00h
str_Shoot:                                      ; "shoot" string literal
        db 073h,068h,06Fh,06Fh,074h,00h
str_Passrec:                                    ; "passrec" string literal
        db 070h,061h,073h,073h,072h,065h,063h,00h
str_3star:                                      ; "3star" string literal
        db 033h,073h,074h,061h,072h,00h
str_R3star:                                     ; "r3star" string literal
        db 072h,033h,073h,074h,061h,072h,00h
str_Fowait:                                     ; "fowait" string literal
        db 066h,06Fh,077h,061h,069h,074h,00h
str_Pnorm:                                      ; "pnorm" string literal
        db 070h,06Eh,06Fh,072h,06Dh,00h
str_Pshad:                                      ; "pshad" string literal
        db 070h,073h,068h,061h,064h,00h
str_Pnothing:                                   ; "pnothing" string literal
        db 070h,06Eh,06Fh,074h,068h,069h,06Eh,067h,00h
str_Pface:                                      ; "pface" string literal
        db 070h,066h,061h,063h,065h,00h
str_Pface2:                                     ; "pface2" string literal
        db 070h,066h,061h,063h,065h,032h,00h
str_Gamemiscon:                                 ; "gamemiscon" string literal
        db 067h,061h,06Dh,065h,06Dh,069h,073h,063h,06Fh,06Eh,00h
str_Rfaceoff:                                   ; "rfaceoff" string literal
        db 072h,066h,061h,063h,065h,06Fh,066h,066h,00h
str_Rnorm:                                      ; "rnorm" string literal
        db 072h,06Eh,06Fh,072h,06Dh,00h
str_Rcallpen:                                   ; "rcallpen" string literal
        db 072h,063h,061h,06Ch,06Ch,070h,065h,06Eh,00h
str_Rpickup:                                    ; "rpickup" string literal
        db 072h,070h,069h,063h,06Bh,075h,070h,00h
str_Rgotofo:                                    ; "rgotofo" string literal
        db 072h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Rpointgoal:                                 ; "rpointgoal" string literal
        db 072h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,06Ch,00h
str_Rgetnew:                                    ; "rgetnew" string literal
        db 072h,067h,065h,074h,06Eh,065h,077h,00h
str_Anth:                                       ; "anth" string literal
        db 061h,06Eh,074h,068h,00h
str_Ranth:                                      ; "ranth" string literal
        db 072h,061h,06Eh,074h,068h,00h
str_Agotofo:                                    ; "agotofo" string literal
        db 061h,067h,06Fh,074h,06Fh,066h,06Fh,00h
str_Benwait:                                    ; "benwait" string literal
        db 062h,065h,06Eh,077h,061h,069h,074h,00h
str_Initper:                                    ; "initper" string literal
        db 069h,06Eh,069h,074h,070h,065h,072h,00h
str_Pgivecup:                                   ; "pgivecup" string literal
        db 070h,067h,069h,076h,065h,063h,075h,070h,00h
str_Rpenshot:                                   ; "rpenshot" string literal
        db 072h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Apswait:                                    ; "apswait" string literal
        db 061h,070h,073h,077h,061h,069h,074h,00h
str_Abreak:                                     ; "abreak" string literal
        db 061h,062h,072h,065h,061h,06Bh,00h
str_Error2:                                     ; "error" string literal
        db 065h,072h,072h,06Fh,072h,00h
str_G5:                                         ; string 'G'
        db 047h,00h
str_LD:                                         ; "LD" string literal
        db 04Ch,044h,00h
str_RD2:                                        ; "RD" string literal
        db 052h,044h,00h
str_LW:                                         ; "LW" string literal
        db 04Ch,057h,00h
str_C6:                                         ; string 'C'
        db 043h,00h
str_RW:                                         ; "RW" string literal
        db 052h,057h,00h
str_XC:                                         ; "XC" string literal
        db 058h,043h,00h
str_dbgO:                                       ; string 'O'; used by DebugMonitor
        db 04Fh,00h
str_dbgDash:                                    ; string '-'; used by DebugMonitor
        db 02Dh,00h
str_dbgClin:                                    ; string '------------------------clin=%d %d '; used by
                                                ; DebugMonitor
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh
        db 02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,02Dh,063h,06Ch,069h,06Eh,03Dh,025h,064h,020h
        db 025h,064h,020h,00h
str_dbgPenShot:                                 ; string 'ps<%d %d %d %d %d> f(%d %d %d %d) b(%d %d)'; used by
                                                ; DebugMonitor
        db 070h,073h,03Ch,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,03Eh,020h,066h,028h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 029h,020h,062h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgLip:                                     ; string 'lip %d '; used by DebugMonitor
        db 06Ch,069h,070h,020h,025h,064h,020h,00h
str_dbgHVpos:                                   ; string 'HVpos<%d %d, %d %d> '; used by DebugMonitor
        db 048h,056h,070h,06Fh,073h,03Ch,025h,064h,020h,025h,064h,02Ch,020h,025h,064h,020h
        db 025h,064h,03Eh,020h,00h
str_dbgRef:                                     ; string 'ref<%d %d> '; used by DebugMonitor
        db 072h,065h,066h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgPb:                                      ; string 'pb[%d %d]'; used by DebugMonitor
        db 070h,062h,05Bh,025h,064h,020h,025h,064h,05Dh,00h
str_dbgG:                                       ; string 'G<%d %d> '; used by DebugMonitor
        db 047h,03Ch,025h,064h,020h,025h,064h,03Eh,020h,00h
str_dbgGO:                                      ; string 'GO=%d PO=%d go=%d gs=%d '; used by DebugMonitor
        db 047h,04Fh,03Dh,025h,064h,020h,050h,04Fh,03Dh,025h,064h,020h,067h,06Fh,03Dh,025h
        db 064h,020h,067h,073h,03Dh,025h,064h,020h,00h
str_dbgGsp:                                     ; string 'g=%d %d '; used by DebugMonitor
        db 067h,03Dh,025h,064h,020h,025h,064h,020h,00h
str_dbgC12:                                     ; string 'c12(%d %d)(%d %d) '; used by DebugMonitor
        db 063h,031h,032h,028h,025h,064h,020h,025h,064h,029h,028h,025h,064h,020h,025h,064h
        db 029h,020h,00h
str_dbgPuckc:                                   ; string 'puckc = %d gmclock%d gmpen%d pcdwn=%d\n'; used by
                                                ; DebugMonitor
        db 070h,075h,063h,06Bh,063h,020h,03Dh,020h,025h,064h,020h,067h,06Dh,063h,06Ch,06Fh
        db 063h,06Bh,025h,064h,020h,067h,06Dh,070h,065h,06Eh,025h,064h,020h,070h,063h,064h
        db 077h,06Eh,03Dh,025h,064h,0Ah,00h
str_dbgIdx:                                     ; string '%d) '; used by DebugMonitor
        db 025h,064h,029h,020h,00h
str_dbgD:                                       ; string '%d '; used by DebugMonitor
        db 025h,064h,020h,00h
str_dbgLbD:                                     ; string '[%d '; used by DebugMonitor
        db 05Bh,025h,064h,020h,00h
str_dbgDRb:                                     ; string '%d] '; used by DebugMonitor
        db 025h,064h,05Dh,020h,00h
str_dbgDS:                                      ; string '%d %s '; used by DebugMonitor
        db 025h,064h,020h,025h,073h,020h,00h
str_dbgPosVel:                                  ; string '@(%d %d) v(%d %d) %d(%d %d)'; used by DebugMonitor
        db 040h,028h,025h,064h,020h,025h,064h,029h,020h,076h,028h,025h,064h,020h,025h,064h
        db 029h,020h,025h,064h,028h,025h,064h,020h,025h,064h,029h,00h
str_dbgVz:                                      ; string 'vz%d '; used by DebugMonitor
        db 076h,07Ah,025h,064h,020h,00h
str_dbgAss:                                     ; string 'A%s '; used by DebugMonitor
        db 041h,025h,073h,020h,00h
str_dbgL:                                       ; string 'L'; used by DebugMonitor
        db 04Ch,00h
str_dbgI:                                       ; string 'I'; used by DebugMonitor
        db 049h,00h
str_dbgSpace:                                   ; string ' '; used by DebugMonitor
        db 020h,00h
str_dbgSpa:                                     ; string 'spa=%d'; used by DebugMonitor
        db 073h,070h,061h,03Dh,025h,064h,00h
str_dbgS:                                       ; string '%s'; used by DebugMonitor
        db 025h,073h,00h
str_debError:                                   ; string 'debError: %d frame %d \n'; used by DebugMonitor
        db 064h,065h,062h,045h,072h,072h,06Fh,072h,03Ah,020h,025h,064h,020h,066h,072h,061h
        db 06Dh,065h,020h,025h,064h,020h,0Ah,00h
str_newline:                                    ; string '\n'; used by DebugMonitor, DumpStatsLog
        db 0Ah,00h
str_dbgBail:                                    ; string 'bail\n'; used by DebugMonitor
        db 062h,061h,069h,06Ch,0Ah,00h
str_statslog:                                   ; string 'stats.log'; used by DebugMonitor
        db 073h,074h,061h,074h,073h,02Eh,06Ch,06Fh,067h,00h
str_fmode_at:                                   ; string 'a+t'; used by DumpStatsLog
        db 061h,02Bh,074h,00h
str_ErrDumpStats:                               ; string 'error dump stats\n'; used by DumpStatsLog
        db 065h,072h,072h,06Fh,072h,020h,064h,075h,06Dh,070h,020h,073h,074h,061h,074h,073h
        db 0Ah,00h
str_dumpPool:                                   ; string '===== pool(%d %d) gm%d ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,070h,06Fh,06Fh,06Ch,028h,025h,064h,020h,025h,064h
        db 029h,020h,067h,06Dh,025h,064h,020h,03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpTmstructs:                              ; string '===== tmstructs ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,074h,06Dh,073h,074h,072h,075h,063h,074h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpHex:                                    ; string '%x '; used by DumpStatsLog
        db 025h,078h,020h,00h
str_dumpSortcords:                              ; string '===== sortcords ====\n'; used by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,020h,073h,06Fh,072h,074h,063h,06Fh,072h,064h,073h,020h
        db 03Dh,03Dh,03Dh,03Dh,0Ah,00h
str_dumpSortLine:                               ; string '%d:%d[%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d
                                                ; %d %x]\n'; used by DumpStatsLog
        db 025h,064h,03Ah,025h,064h,05Bh,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h
        db 064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h
        db 025h,064h,020h,025h,064h,020h,025h,078h,05Dh,0Ah,00h
str_dumpRule:                                   ; string
                                                ; '==================================================\n'; used
                                                ; by DumpStatsLog
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh,03Dh
        db 03Dh,03Dh,0Ah,00h
str_dumpTeamHdrH:                               ; string ' shts score [shots score] ppg pp pen penmin atop
                                                ; pass passcomp\n'; used by DumpStatsLog
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpHome:                                   ; string 'home : %d %d [%d %d] %d %d %d %d %d %d %d\n'; used
                                                ; by DumpStatsLog
        db 068h,06Fh,06Dh,065h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrH:                                 ; string ' i pnum g a pen +/- ppg shg eng sht status\n'; used
                                                ; by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineH:                                ; string '%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n'; used
                                                ; by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrH:                                 ; string ' i pnum min sht sav status\n'; used by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpGlLine:                                 ; string '%3d %3d %5d %3d %3d %3d\n'; used by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,035h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpTeamHdrA:                               ; string ' shts score [shots score] ppg pp pen penmin atop
                                                ; pass passcomp\n'; used by DumpStatsLog
        db 020h,020h,020h,020h,020h,020h,020h,073h,068h,074h,073h,020h,073h,063h,06Fh,072h
        db 065h,020h,05Bh,073h,068h,06Fh,074h,073h,020h,073h,063h,06Fh,072h,065h,05Dh,020h
        db 070h,070h,067h,020h,070h,070h,020h,070h,065h,06Eh,020h,070h,065h,06Eh,06Dh,069h
        db 06Eh,020h,061h,074h,06Fh,070h,020h,070h,061h,073h,073h,020h,070h,061h,073h,073h
        db 063h,06Fh,06Dh,070h,0Ah,00h
str_dumpAway:                                   ; string 'away : %d %d [%d %d] %d %d %d %d %d %d %d\n'; used
                                                ; by DumpStatsLog
        db 061h,077h,061h,079h,020h,03Ah,020h,025h,064h,020h,025h,064h,020h,05Bh,025h,064h
        db 020h,025h,064h,05Dh,020h,025h,064h,020h,025h,064h,020h,025h,064h,020h,025h,064h
        db 020h,025h,064h,020h,025h,064h,020h,025h,064h,0Ah,00h
str_dumpPlHdrA:                                 ; string ' i pnum g a pen +/- ppg shg eng sht status\n'; used
                                                ; by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,067h,020h,020h,061h,020h,020h
        db 070h,065h,06Eh,020h,02Bh,02Fh,02Dh,020h,070h,070h,067h,020h,073h,068h,067h,020h
        db 065h,06Eh,067h,020h,073h,068h,074h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h
str_dumpPlLineA:                                ; string '%3d %3d %3d %3d %3d %3d %3d %3d %3d %3d %3d\n'; used
                                                ; by DumpStatsLog
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,020h
        db 025h,033h,064h,020h,025h,033h,064h,020h,025h,033h,064h,0Ah,00h
str_dumpGlHdrA:                                 ; string ' i pnum min sht sav status\n'; used by DumpStatsLog
        db 020h,020h,020h,069h,020h,070h,06Eh,075h,06Dh,020h,06Dh,069h,06Eh,020h,073h,068h
        db 074h,020h,073h,061h,076h,020h,073h,074h,061h,074h,075h,073h,0Ah,00h,00h,00h
        db 00h
