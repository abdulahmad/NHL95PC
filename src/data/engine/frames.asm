; Sprite animation tables. First the SPF equates: the first frame number of each group of frames in the
; player sprite sheet (frame numbers count from 0). Then SPAlist and one sequence per animation, in SPA number
; order. The code files take the SPA numbers from src/inc/spa.inc; tools/build/check_spa.py checks them.
;
; A sequence is a flags word, which is also direction 0's offset (bit 15 set: the animation loops at the end
; of its list; clear: updateanim clears SPA there), 7 word offsets for directions 1-7 counted in words from
; .0, then per direction a list of frame,time word pairs. A negative time ends a list.
;
; A SPA number is a sequence's byte offset from SPAlist / 2. Frames from 649 up have no SPF name and the
; tables list their numbers, as the faceoff tables do: their frames sit in the SPFgloves .. SPFfinjury groups.
; The high byte of the last sequence's final time is priolist_m1 in data/engine/game_state.asm.
bits 32
%include "hockey.inc"
section s_C921D progbits alloc noexec write align=1
global SPAlist

; Sprite Frame (SPF) base indices
SPFskatewp equ 0                                ; 0 skating, stick down
SPFskate equ SPFskatewp+40                      ; 40 skating, stick up
SPFturnl equ SPFskate+40                        ; 80 turning left
SPFturnr equ SPFturnl+8                         ; 88 turning right
SPFswing equ SPFturnr+8                         ; 96 pass and shot swings
SPFstop equ SPFswing+48                         ; 144 scrape stop
SPFskateb equ SPFstop+16                        ; 160 skating backwards
SPFcelebrate equ SPFskateb+24                   ; 184 celebrating
SPFpump equ SPFcelebrate+16                     ; 200 arm pump
SPFcup equ SPFpump+16                           ; 216 skating with the cup
SPFhipl equ SPFcup+8                            ; 224 hip check left
SPFhipr equ SPFhipl+8                           ; 232 hip check right
SPFshoulderl equ SPFhipr+8                      ; 240 shoulder check left
SPFshoulderr equ SPFshoulderl+8                 ; 248 shoulder check right
SPFsweep equ SPFshoulderr+8                     ; 256 sweep check
SPFfallback equ SPFsweep+16                     ; 272 falling backward
SPFfallfwd equ SPFfallback+32                   ; 304 falling forward
SPFduck equ SPFfallfwd+32                       ; 336 ducking
SPFHold equ SPFduck+8                           ; 344 holding
SPFgloves equ SPFHold+8                         ; 352 gloves on the ice (fights)
SPFfight equ SPFgloves+1                        ; 353 fighting
SPFfinjury equ SPFfight+17                      ; 370 fight injury
SPFPen equ SPFfinjury+6                         ; 376 frames used by the wall jump animations
SPFarrow equ SPFPen+7                           ; 383 arrows for off screen players
SPFpad equ SPFarrow+6                           ; 389 face off pads
SPFreplay equ SPFpad+3                          ; 392 replay marker
SPFpuck equ SPFreplay+1                         ; 393 puck
SPFgoal equ SPFpuck+11                          ; 404 goal
SPFGoalie equ SPFgoal+2                         ; 406 goalie
SPFgdive equ SPFGoalie+112                      ; 518 goalie dive
SPFglovel2 equ SPFgdive+16                      ; 534 goalie second glove save
SPFgready equ SPFglovel2+4                      ; 538 goalie ready
SPFSiren equ SPFgready+16                       ; 554 siren
SPFcatch equ SPFSiren+14                        ; 568 catching a puck hit
SPFhook equ SPFcatch+16                         ; 584 hooking
SPFstumble equ SPFhook+16                       ; 600 stumbling
SPFflip equ SPFstumble+24                       ; 624 flipping over
SPFinjury1 equ SPFflip+8                        ; 632 injured on the ice
SPFbglass equ SPFinjury1+12                     ; 644 glass bang

SPAlist:                                        ; base of the sequences: a SPA number is the byte offset of a
                                                ; sequence from here / 2; used by updateanim
        dw 0
SPAgready:                                      ; SPA 0x1: goalie in ready position; used by dbg_spalist,
                                                ; goalieacc
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie, 180, SPFgready, 10, SPFgready+1, 10, SPFgready, 10, SPFgready+1, 10, SPFGoalie, 240, SPFgready, 10, SPFgready+1, 10, SPFgready, -10
.1:
        dw SPFGoalie+3, 130, SPFgready+2, 10, SPFgready+3, 10, SPFgready+2, 10, SPFgready+3, 10, SPFGoalie+3, 300, SPFgready+2, 10, SPFgready+3, 10, SPFgready+2, -10
.2:
        dw SPFGoalie+6, 210, SPFgready+4, 10, SPFgready+5, 10, SPFgready+4, 10, SPFgready+5, 10, SPFGoalie+6, 120, SPFgready+4, 10, SPFgready+5, 10, SPFgready+4, -10
.3:
        dw SPFGoalie+9, 100, SPFgready+6, 10, SPFgready+7, 10, SPFgready+6, 10, SPFgready+7, 10, SPFGoalie+9, 200, SPFgready+6, 10, SPFgready+7, 10, SPFgready+6, -10
.4:
        dw SPFGoalie+12, 240, SPFgready+8, 10, SPFgready+9, 10, SPFgready+8, 10, SPFgready+9, 10, SPFGoalie+12, 60, SPFgready+8, 10, SPFgready+9, 10, SPFgready+8, -10
.5:
        dw SPFGoalie+15, 180, SPFgready+10, 10, SPFgready+11, 10, SPFgready+10, 10, SPFgready+11, 10, SPFGoalie+15, 240, SPFgready+10, 10, SPFgready+11, 10, SPFgready+10, -10
.6:
        dw SPFGoalie+18, 120, SPFgready+12, 10, SPFgready+13, 10, SPFgready+12, 10, SPFgready+13, 10, SPFGoalie+18, 120, SPFgready+12, 10, SPFgready+13, 10, SPFgready+12, -10
.7:
        dw SPFGoalie+21, 180, SPFgready+14, 10, SPFgready+15, 10, SPFgready+14, 10, SPFgready+15, 10, SPFGoalie+21, 180, SPFgready+14, 10, SPFgready+15, 10, SPFgready+14, -10
SPAgready2:                                     ; SPA 0x99: goalie ready position, held frame (used by the
                                                ; goalie scripts); used by dbg_spalist, asstakeposition,
                                                ; assgoalie, PreGameIntro ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie, -30
.1:
        dw SPFGoalie+3, -30
.2:
        dw SPFGoalie+6, -30
.3:
        dw SPFGoalie+9, -30
.4:
        dw SPFGoalie+12, -30
.5:
        dw SPFGoalie+15, -30
.6:
        dw SPFGoalie+18, -30
.7:
        dw SPFGoalie+21, -30
SPAgglover:                                     ; SPA 0xB1: goalie does glove save right; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist, SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+1, -32
.1:
        dw SPFGoalie+4, -32
.2:
        dw SPFGoalie+7, -32
.3:
        dw SPFGoalie+10, -32
.4:
        dw SPFGoalie+13, -32
.5:
        dw SPFGoalie+16, -32
.6:
        dw SPFGoalie+19, -32
.7:
        dw SPFGoalie+22, -32
SPAgglovel:                                     ; SPA 0xC9: goalie does glove save left; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist, SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+2, -32
.1:
        dw SPFGoalie+5, -32
.2:
        dw SPFGoalie+8, -32
.3:
        dw SPFGoalie+11, -32
.4:
        dw SPFGoalie+14, -32
.5:
        dw SPFGoalie+17, -32
.6:
        dw SPFGoalie+20, -32
.7:
        dw SPFGoalie+23, -32
SPAgglovel2:                                    ; SPA 0xE1: goalie second glove save (SPFglovel2 frames, from
                                                ; the other glove); used by dbg_spalist, SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFglovel2, 4, SPFglovel2+1, 8, SPFglovel2, -4
.1:
        dw SPFGoalie+5, -32
.2:
        dw SPFGoalie+8, -32
.3:
        dw SPFGoalie+11, -32
.4:
        dw SPFglovel2+2, 4, SPFglovel2+3, 8, SPFglovel2+2, -4
.5:
        dw SPFGoalie+17, -32
.6:
        dw SPFGoalie+20, -32
.7:
        dw SPFGoalie+23, -32
SPAgstickr:                                     ; SPA 0x101: goalie stick save right; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist, SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+64, -32
.1:
        dw SPFGoalie+66, -32
.2:
        dw SPFGoalie+68, -32
.3:
        dw SPFGoalie+70, -32
.4:
        dw SPFGoalie+72, -32
.5:
        dw SPFGoalie+74, -32
.6:
        dw SPFGoalie+76, -32
.7:
        dw SPFGoalie+78, -32
SPAgstickl:                                     ; SPA 0x119: goalie stick save left; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist, SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+65, -32
.1:
        dw SPFGoalie+67, -32
.2:
        dw SPFGoalie+69, -32
.3:
        dw SPFGoalie+71, -32
.4:
        dw SPFGoalie+73, -32
.5:
        dw SPFGoalie+75, -32
.6:
        dw SPFGoalie+77, -32
.7:
        dw SPFGoalie+79, -32
SPAgstackr:                                     ; SPA 0x131: goalie stack (pad save) right; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+40, 8, SPFGoalie+41, -32
.1:
        dw SPFGoalie+42, 8, SPFGoalie+43, -32
.2:
        dw SPFGoalie+42, 8, SPFGoalie+43, -32
.3:
        dw SPFGoalie+44, 8, SPFGoalie+45, -32
.4:
        dw SPFGoalie+46, 8, SPFGoalie+47, -32
.5:
        dw SPFGoalie+48, 8, SPFGoalie+49, -32
.6:
        dw SPFGoalie+48, 8, SPFGoalie+49, -32
.7:
        dw SPFGoalie+50, 8, SPFGoalie+51, -32
SPAgstackl:                                     ; SPA 0x159: goalie stack (pad save) left; used by
                                                ; goaliesave_saveanim_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+52, 8, SPFGoalie+53, -32
.1:
        dw SPFGoalie+54, 8, SPFGoalie+55, -32
.2:
        dw SPFGoalie+54, 8, SPFGoalie+55, -32
.3:
        dw SPFGoalie+56, 8, SPFGoalie+57, -32
.4:
        dw SPFGoalie+58, 8, SPFGoalie+59, -32
.5:
        dw SPFGoalie+60, 8, SPFGoalie+61, -32
.6:
        dw SPFGoalie+60, 8, SPFGoalie+61, -32
.7:
        dw SPFGoalie+62, 8, SPFGoalie+63, -32
SPAgdive:                                       ; SPA 0x181: goalie diving save (SPFgdive frames); used by
                                                ; dbg_spalist, assgoalie, puckglue
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFgdive, 8, SPFgdive+1, 48, SPFgdive, -8
.1:
        dw SPFgdive+2, 8, SPFgdive+3, 48, SPFgdive+2, -8
.2:
        dw SPFgdive+4, 8, SPFgdive+5, 48, SPFgdive+4, -8
.3:
        dw SPFgdive+6, 8, SPFgdive+7, 48, SPFgdive+6, -8
.4:
        dw SPFgdive+8, 8, SPFgdive+9, 48, SPFgdive+8, -8
.5:
        dw SPFgdive+10, 8, SPFgdive+11, 48, SPFgdive+10, -8
.6:
        dw SPFgdive+12, 8, SPFgdive+13, 48, SPFgdive+12, -8
.7:
        dw SPFgdive+14, 8, SPFgdive+15, 48, SPFgdive+14, -8
SPAgswing:                                      ; SPA 0x1B9: goalie passes puck; used by dbg_spalist, dopass
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+24, 5, SPFGoalie+25, 8, SPFGoalie+24, -16
.1:
        dw SPFGoalie+26, 5, SPFGoalie+27, 8, SPFGoalie+26, -16
.2:
        dw SPFGoalie+28, 5, SPFGoalie+29, 8, SPFGoalie+28, -16
.3:
        dw SPFGoalie+30, 5, SPFGoalie+31, 8, SPFGoalie+30, -16
.4:
        dw SPFGoalie+32, 5, SPFGoalie+33, 8, SPFGoalie+32, -16
.5:
        dw SPFGoalie+34, 5, SPFGoalie+35, 8, SPFGoalie+34, -16
.6:
        dw SPFGoalie+36, 5, SPFGoalie+37, 8, SPFGoalie+36, -16
.7:
        dw SPFGoalie+38, 5, SPFGoalie+39, 8, SPFGoalie+38, -16
SPAgskate:                                      ; SPA 0x1F1: goalie skates; used by dbg_spalist, SkateToSpot,
                                                ; stopna, goalieacc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFGoalie+80, 10, SPFGoalie+81, 10, SPFGoalie+82, 10, SPFGoalie+83, -15
.1:
        dw SPFGoalie+84, 10, SPFGoalie+85, 10, SPFGoalie+86, 10, SPFGoalie+87, -15
.2:
        dw SPFGoalie+88, 10, SPFGoalie+89, 10, SPFGoalie+90, 10, SPFGoalie+91, -15
.3:
        dw SPFGoalie+92, 10, SPFGoalie+93, 10, SPFGoalie+94, 10, SPFGoalie+95, -15
.4:
        dw SPFGoalie+96, 10, SPFGoalie+97, 10, SPFGoalie+98, 10, SPFGoalie+99, -15
.5:
        dw SPFGoalie+100, 10, SPFGoalie+101, 10, SPFGoalie+102, 10, SPFGoalie+103, -15
.6:
        dw SPFGoalie+104, 10, SPFGoalie+105, 10, SPFGoalie+106, 10, SPFGoalie+107, -15
.7:
        dw SPFGoalie+108, 10, SPFGoalie+109, 10, SPFGoalie+110, 10, SPFGoalie+111, -15
SPApflip:                                       ; SPA 0x239: puck animation (flipping puck); used by
                                                ; dbg_spalist, a2touchpuck, puckflip
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFpuck+2, 4, SPFpuck+3, 4, SPFpuck+4, 4, SPFpuck+5, 4, SPFpuck+6, 4, SPFpuck+3, 4, SPFpuck+7, 4, SPFpuck+1, -4
.1:
        dw SPFpuck+9, 2, SPFpuck+1, 2, SPFpuck+8, 2, SPFpuck+5, 2, SPFpuck+10, 2, SPFpuck+5, 2, SPFpuck+8, 2, SPFpuck+1, -2
.2:
        dw SPFpuck+4, 2, SPFpuck+3, 2, SPFpuck+2, 2, SPFpuck+1, 2, SPFpuck+7, 2, SPFpuck+3, 2, SPFpuck+6, 2, SPFpuck+5, -2
.3:
        dw SPFpuck+8, 4, SPFpuck+1, 4, SPFpuck+9, 4, SPFpuck+1, 4, SPFpuck+8, 4, SPFpuck+5, 4, SPFpuck+10, 4, SPFpuck+5, -4
.4:
        dw SPFpuck+1, -4096
.5:
        dw SPFpuck+1, -4096
.6:
        dw SPFpuck+5, -4096
.7:
        dw SPFpuck+5, -4096
SPAglide:                                       ; SPA 0x289: player gliding with stick down; used by
                                                ; dbg_spalist, assleavebox, puckfaceoff2, asstakeposition ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskatewp, -8
.1:
        dw SPFskatewp+5, -8
.2:
        dw SPFskatewp+10, -8
.3:
        dw SPFskatewp+15, -8
.4:
        dw SPFskatewp+20, -8
.5:
        dw SPFskatewp+25, -8
.6:
        dw SPFskatewp+30, -8
.7:
        dw SPFskatewp+35, -8
SPAskatewp:                                     ; SPA 0x2A1: player skating with stick down (SPFskatewp
                                                ; frames); used by dbg_spalist, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskatewp+1, 10, SPFskatewp+2, 10, SPFskatewp+3, 10, SPFskatewp+4, -10
.1:
        dw SPFskatewp+6, 10, SPFskatewp+7, 10, SPFskatewp+8, 10, SPFskatewp+9, -10
.2:
        dw SPFskatewp+11, 10, SPFskatewp+12, 10, SPFskatewp+13, 10, SPFskatewp+14, -10
.3:
        dw SPFskatewp+16, 10, SPFskatewp+17, 10, SPFskatewp+18, 10, SPFskatewp+19, -10
.4:
        dw SPFskatewp+21, 10, SPFskatewp+22, 10, SPFskatewp+23, 10, SPFskatewp+24, -10
.5:
        dw SPFskatewp+26, 10, SPFskatewp+27, 10, SPFskatewp+28, 10, SPFskatewp+29, -10
.6:
        dw SPFskatewp+31, 10, SPFskatewp+32, 10, SPFskatewp+33, 10, SPFskatewp+34, -10
.7:
        dw SPFskatewp+36, 10, SPFskatewp+37, 10, SPFskatewp+38, 10, SPFskatewp+39, -10
SPAskate:                                       ; SPA 0x2E9: player skating with stick up (SPFskate frames);
                                                ; used by dbg_spalist, MoveInDir, SkateToSpot, goalieacc ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskate+1, 10, SPFskate+2, 10, SPFskate+3, 10, SPFskate+4, -10
.1:
        dw SPFskate+6, 10, SPFskate+7, 10, SPFskate+8, 10, SPFskate+9, -10
.2:
        dw SPFskate+11, 10, SPFskate+12, 10, SPFskate+13, 10, SPFskate+14, -10
.3:
        dw SPFskate+16, 10, SPFskate+17, 10, SPFskate+18, 10, SPFskate+19, -10
.4:
        dw SPFskate+21, 10, SPFskate+22, 10, SPFskate+23, 10, SPFskate+24, -10
.5:
        dw SPFskate+26, 10, SPFskate+27, 10, SPFskate+28, 10, SPFskate+29, -10
.6:
        dw SPFskate+31, 10, SPFskate+32, 10, SPFskate+33, 10, SPFskate+34, -10
.7:
        dw SPFskate+36, 10, SPFskate+37, 10, SPFskate+38, 10, SPFskate+39, -10
SPAturnl:                                       ; SPA 0x331: player turning left; used by dbg_spalist,
                                                ; doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFturnl, -8
.1:
        dw SPFturnl+1, -8
.2:
        dw SPFturnl+2, -8
.3:
        dw SPFturnl+3, -8
.4:
        dw SPFturnl+4, -8
.5:
        dw SPFturnl+5, -8
.6:
        dw SPFturnl+6, -8
.7:
        dw SPFturnl+7, -8
SPAturnr:                                       ; SPA 0x349: player turning right; used by dbg_spalist,
                                                ; doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFturnr, -8
.1:
        dw SPFturnr+1, -8
.2:
        dw SPFturnr+2, -8
.3:
        dw SPFturnr+3, -8
.4:
        dw SPFturnr+4, -8
.5:
        dw SPFturnr+5, -8
.6:
        dw SPFturnr+6, -8
.7:
        dw SPFturnr+7, -8
SPAstop:                                        ; SPA 0x361: player scrape stopping; used by dbg_spalist,
                                                ; avdgoal, dostop
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFstop, 4, SPFstop+1, -4
.1:
        dw SPFstop+2, 4, SPFstop+3, -4
.2:
        dw SPFstop+4, 4, SPFstop+5, -4
.3:
        dw SPFstop+6, 4, SPFstop+7, -4
.4:
        dw SPFstop+8, 4, SPFstop+9, -4
.5:
        dw SPFstop+10, 4, SPFstop+11, -4
.6:
        dw SPFstop+12, 4, SPFstop+13, -4
.7:
        dw SPFstop+14, 4, SPFstop+15, -4
SPApassf:                                       ; SPA 0x389: forward pass swing; used by dbg_spalist, dopass
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+4, 4, SPFswing+5, -20
.1:
        dw SPFswing+9, 4, SPFswing+10, 4, SPFswing+11, -20
.2:
        dw SPFswing+15, 4, SPFswing+16, 4, SPFswing+17, -20
.3:
        dw SPFswing+21, 4, SPFswing+22, 4, SPFswing+23, -20
.4:
        dw SPFswing+27, 4, SPFswing+28, 4, SPFswing+29, -20
.5:
        dw SPFswing+33, 4, SPFswing+34, 4, SPFswing+35, -20
.6:
        dw SPFswing+39, 4, SPFswing+40, 4, SPFswing+41, -20
.7:
        dw SPFswing+45, 4, SPFswing+46, 4, SPFswing+47, -20
SPApassb:                                       ; SPA 0x3C1: back hand pass swing; used by dbg_spalist, dopass
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+2, 4, SPFswing+1, -20
.1:
        dw SPFswing+9, 4, SPFswing+8, 4, SPFswing+7, -20
.2:
        dw SPFswing+15, 4, SPFswing+14, 4, SPFswing+13, -20
.3:
        dw SPFswing+21, 4, SPFswing+20, 4, SPFswing+19, -20
.4:
        dw SPFswing+27, 4, SPFswing+26, 4, SPFswing+25, -20
.5:
        dw SPFswing+33, 4, SPFswing+32, 4, SPFswing+31, -20
.6:
        dw SPFswing+39, 4, SPFswing+38, 4, SPFswing+37, -20
.7:
        dw SPFswing+45, 4, SPFswing+44, 4, SPFswing+43, -20
SPAshotf:                                       ; SPA 0x3F9: player shoots forehand; used by dbg_spalist,
                                                ; CanBlockShot, SetShotMode, ShotMode
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+2, 4, SPFswing+1, 4, SPFswing, 4, SPFswing+1, 4, SPFswing+2, 4, SPFswing+3, 4, SPFswing+4, 4, SPFswing+5, -20
.1:
        dw SPFswing+9, 4, SPFswing+8, 4, SPFswing+7, 4, SPFswing+6, 4, SPFswing+7, 4, SPFswing+8, 4, SPFswing+9, 4, SPFswing+10, 4, SPFswing+11, -20
.2:
        dw SPFswing+15, 4, SPFswing+14, 4, SPFswing+13, 4, SPFswing+12, 4, SPFswing+13, 4, SPFswing+14, 4, SPFswing+15, 4, SPFswing+16, 4, SPFswing+17, -20
.3:
        dw SPFswing+21, 4, SPFswing+20, 4, SPFswing+19, 4, SPFswing+18, 4, SPFswing+19, 4, SPFswing+20, 4, SPFswing+21, 4, SPFswing+22, 4, SPFswing+23, -20
.4:
        dw SPFswing+27, 4, SPFswing+26, 4, SPFswing+25, 4, SPFswing+24, 4, SPFswing+25, 4, SPFswing+26, 4, SPFswing+27, 4, SPFswing+28, 4, SPFswing+29, -20
.5:
        dw SPFswing+33, 4, SPFswing+32, 4, SPFswing+31, 4, SPFswing+30, 4, SPFswing+31, 4, SPFswing+32, 4, SPFswing+33, 4, SPFswing+34, 4, SPFswing+35, -20
.6:
        dw SPFswing+39, 4, SPFswing+38, 4, SPFswing+37, 4, SPFswing+36, 4, SPFswing+37, 4, SPFswing+38, 4, SPFswing+39, 4, SPFswing+40, 4, SPFswing+41, -20
.7:
        dw SPFswing+45, 4, SPFswing+44, 4, SPFswing+43, 4, SPFswing+42, 4, SPFswing+43, 4, SPFswing+44, 4, SPFswing+45, 4, SPFswing+46, 4, SPFswing+47, -20
SPAshotb:                                       ; SPA 0x491: player shoots backhand; used by dbg_spalist,
                                                ; CanBlockShot, SetShotMode, ShotMode ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+4, 4, SPFswing+5, 4, SPFswing+5, 4, SPFswing+5, 4, SPFswing+4, 4, SPFswing+3, 4, SPFswing+2, 4, SPFswing+1, -20
.1:
        dw SPFswing+9, 4, SPFswing+10, 4, SPFswing+11, 4, SPFswing+11, 4, SPFswing+11, 4, SPFswing+10, 4, SPFswing+9, 4, SPFswing+8, 4, SPFswing+7, -20
.2:
        dw SPFswing+15, 4, SPFswing+16, 4, SPFswing+17, 4, SPFswing+17, 4, SPFswing+17, 4, SPFswing+16, 4, SPFswing+15, 4, SPFswing+14, 4, SPFswing+13, -20
.3:
        dw SPFswing+21, 4, SPFswing+22, 4, SPFswing+23, 4, SPFswing+23, 4, SPFswing+23, 4, SPFswing+22, 4, SPFswing+21, 4, SPFswing+20, 4, SPFswing+19, -20
.4:
        dw SPFswing+27, 4, SPFswing+28, 4, SPFswing+29, 4, SPFswing+29, 4, SPFswing+29, 4, SPFswing+28, 4, SPFswing+27, 4, SPFswing+26, 4, SPFswing+25, -20
.5:
        dw SPFswing+33, 4, SPFswing+34, 4, SPFswing+35, 4, SPFswing+35, 4, SPFswing+35, 4, SPFswing+34, 4, SPFswing+33, 4, SPFswing+32, 4, SPFswing+31, -20
.6:
        dw SPFswing+39, 4, SPFswing+40, 4, SPFswing+41, 4, SPFswing+41, 4, SPFswing+41, 4, SPFswing+40, 4, SPFswing+39, 4, SPFswing+38, 4, SPFswing+37, -20
.7:
        dw SPFswing+45, 4, SPFswing+46, 4, SPFswing+47, 4, SPFswing+47, 4, SPFswing+47, 4, SPFswing+46, 4, SPFswing+45, 4, SPFswing+44, 4, SPFswing+43, -20
SPAglideback:                                   ; SPA 0x529: player gliding backwards; used by dbg_spalist,
                                                ; doplayeracc, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskateb, -8
.1:
        dw SPFskateb+3, -8
.2:
        dw SPFskateb+6, -8
.3:
        dw SPFskateb+9, -8
.4:
        dw SPFskateb+12, -8
.5:
        dw SPFskateb+15, -8
.6:
        dw SPFskateb+18, -8
.7:
        dw SPFskateb+21, -8
SPAskateback:                                   ; SPA 0x541: player skating backwards; used by dbg_spalist,
                                                ; noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskateb, 10, SPFskateb+1, 10, SPFskateb, 10, SPFskateb+2, -10
.1:
        dw SPFskateb+3, 10, SPFskateb+4, 10, SPFskateb+3, 10, SPFskateb+5, -10
.2:
        dw SPFskateb+6, 10, SPFskateb+7, 10, SPFskateb+6, 10, SPFskateb+8, -10
.3:
        dw SPFskateb+9, 10, SPFskateb+10, 10, SPFskateb+9, 10, SPFskateb+11, -10
.4:
        dw SPFskateb+12, 10, SPFskateb+13, 10, SPFskateb+12, 10, SPFskateb+14, -10
.5:
        dw SPFskateb+15, 10, SPFskateb+16, 10, SPFskateb+15, 10, SPFskateb+17, -10
.6:
        dw SPFskateb+18, 10, SPFskateb+19, 10, SPFskateb+18, 10, SPFskateb+20, -10
.7:
        dw SPFskateb+21, 10, SPFskateb+22, 10, SPFskateb+21, 10, SPFskateb+23, -10
SPAsweepchk:                                    ; SPA 0x589: player stick (sweep) checking; used by
                                                ; dbg_spalist, Sweepcheck, checkcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFsweep, 4, SPFsweep+1, 8, SPFsweep, -4
.1:
        dw SPFsweep+2, 4, SPFsweep+3, 8, SPFsweep+2, -4
.2:
        dw SPFsweep+4, 4, SPFsweep+5, 8, SPFsweep+4, -4
.3:
        dw SPFsweep+6, 4, SPFsweep+7, 8, SPFsweep+6, -4
.4:
        dw SPFsweep+8, 4, SPFsweep+9, 8, SPFsweep+8, -4
.5:
        dw SPFsweep+10, 4, SPFsweep+11, 8, SPFsweep+10, -4
.6:
        dw SPFsweep+12, 4, SPFsweep+13, 8, SPFsweep+12, -4
.7:
        dw SPFsweep+14, 4, SPFsweep+15, 8, SPFsweep+14, -4
SPAshoulderchkl:                                ; SPA 0x5C1: player shoulder checking left; used by
                                                ; checkinglist_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFshoulderl, -24
.1:
        dw SPFshoulderl+1, -24
.2:
        dw SPFshoulderl+2, -24
.3:
        dw SPFshoulderl+3, -24
.4:
        dw SPFshoulderl+4, -24
.5:
        dw SPFshoulderl+5, -24
.6:
        dw SPFshoulderl+6, -24
.7:
        dw SPFshoulderl+7, -24
SPAshoulderchkr:                                ; SPA 0x5D9: player shoulder checking right; used by
                                                ; checkinglist_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFshoulderr, -24
.1:
        dw SPFshoulderr+1, -24
.2:
        dw SPFshoulderr+2, -24
.3:
        dw SPFshoulderr+3, -24
.4:
        dw SPFshoulderr+4, -24
.5:
        dw SPFshoulderr+5, -24
.6:
        dw SPFshoulderr+6, -24
.7:
        dw SPFshoulderr+7, -24
SPAhipchkl:                                     ; SPA 0x5F1: player hip checking left; used by
                                                ; checkinglist_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFhipl, -24
.1:
        dw SPFhipl+1, -24
.2:
        dw SPFhipl+2, -24
.3:
        dw SPFhipl+3, -24
.4:
        dw SPFhipl+4, -24
.5:
        dw SPFhipl+5, -24
.6:
        dw SPFhipl+6, -24
.7:
        dw SPFhipl+7, -24
SPAhipchkr:                                     ; SPA 0x609: player hip checking right; used by
                                                ; checkinglist_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFhipr, -24
.1:
        dw SPFhipr+1, -24
.2:
        dw SPFhipr+2, -24
.3:
        dw SPFhipr+3, -24
.4:
        dw SPFhipr+4, -24
.5:
        dw SPFhipr+5, -24
.6:
        dw SPFhipr+6, -24
.7:
        dw SPFhipr+7, -24
SPAburst:                                       ; SPA 0x621: player doing c button (speed/no check); used by
                                                ; dbg_spalist, burst, checkcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskate, -24
.1:
        dw SPFskate+5, -24
.2:
        dw SPFskate+10, -24
.3:
        dw SPFskate+15, -24
.4:
        dw SPFskate+20, -24
.5:
        dw SPFskate+25, -24
.6:
        dw SPFskate+30, -24
.7:
        dw SPFskate+35, -24
SPAHold:                                        ; SPA 0x639: player trying to hold; used by dbg_spalist,
                                                ; holdcheck, checkcheck, Acheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFHold, -30
.1:
        dw SPFHold+1, -30
.2:
        dw SPFHold+2, -30
.3:
        dw SPFHold+3, -30
.4:
        dw SPFHold+4, -30
.5:
        dw SPFHold+5, -30
.6:
        dw SPFHold+6, -30
.7:
        dw SPFHold+7, -30
SPAHold2:                                       ; SPA 0x651: player holding opponent; used by dbg_spalist,
                                                ; holdcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFHold, -30
.1:
        dw SPFHold+1, -30
.2:
        dw SPFHold+2, -30
.3:
        dw SPFHold+3, -30
.4:
        dw SPFHold+4, -30
.5:
        dw SPFHold+5, -30
.6:
        dw SPFHold+6, -30
.7:
        dw SPFHold+7, -30
SPAflail:                                       ; SPA 0x669: player being held by opponent; used by
                                                ; dbg_spalist, holdcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFskate, -30
.1:
        dw SPFskate+5, -30
.2:
        dw SPFskate+10, -30
.3:
        dw SPFskate+15, -30
.4:
        dw SPFskate+20, -30
.5:
        dw SPFskate+25, -30
.6:
        dw SPFskate+30, -30
.7:
        dw SPFskate+35, -30
SPAfallfwd:                                     ; SPA 0x681: player falling forward; used by dbg_spalist,
                                                ; FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFfallfwd, 6, SPFfallfwd+1, 6, SPFfallfwd+2, 100, SPFfallfwd+3, 8, SPFduck, -8
.1:
        dw SPFfallfwd+4, 6, SPFfallfwd+5, 6, SPFfallfwd+6, 100, SPFfallfwd+7, 8, SPFduck+1, -8
.2:
        dw SPFfallfwd+8, 6, SPFfallfwd+9, 6, SPFfallfwd+10, 100, SPFfallfwd+11, 8, SPFduck+2, -8
.3:
        dw SPFfallfwd+12, 6, SPFfallfwd+13, 6, SPFfallfwd+14, 100, SPFfallfwd+15, 8, SPFduck+3, -8
.4:
        dw SPFfallfwd+16, 6, SPFfallfwd+17, 6, SPFfallfwd+18, 100, SPFfallfwd+19, 8, SPFduck+4, -8
.5:
        dw SPFfallfwd+20, 6, SPFfallfwd+21, 6, SPFfallfwd+22, 100, SPFfallfwd+23, 8, SPFduck+5, -8
.6:
        dw SPFfallfwd+24, 6, SPFfallfwd+25, 6, SPFfallfwd+26, 100, SPFfallfwd+27, 8, SPFduck+6, -8
.7:
        dw SPFfallfwd+28, 6, SPFfallfwd+29, 6, SPFfallfwd+30, 100, SPFfallfwd+31, 8, SPFduck+7, -8
SPAfallback:                                    ; SPA 0x6D9: player falling backward; used by dbg_spalist,
                                                ; FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFfallback, 6, SPFfallback+1, 6, SPFfallback+2, 100, SPFfallback+3, 8, SPFduck, -8
.1:
        dw SPFfallback+4, 6, SPFfallback+5, 6, SPFfallback+6, 100, SPFfallback+7, 8, SPFduck+1, -8
.2:
        dw SPFfallback+8, 6, SPFfallback+9, 6, SPFfallback+10, 100, SPFfallback+11, 8, SPFduck+2, -8
.3:
        dw SPFfallback+12, 6, SPFfallback+13, 6, SPFfallback+14, 100, SPFfallback+15, 8, SPFduck+3, -8
.4:
        dw SPFfallback+16, 6, SPFfallback+17, 6, SPFfallback+18, 100, SPFfallback+19, 8, SPFduck+4, -8
.5:
        dw SPFfallback+20, 6, SPFfallback+21, 6, SPFfallback+22, 100, SPFfallback+23, 8, SPFduck+5, -8
.6:
        dw SPFfallback+24, 6, SPFfallback+25, 6, SPFfallback+26, 100, SPFfallback+27, 8, SPFduck+6, -8
.7:
        dw SPFfallback+28, 6, SPFfallback+29, 6, SPFfallback+30, 100, SPFfallback+31, 8, SPFduck+7, -8
SPAcelebrate:                                   ; SPA 0x731: player raising stick/arms up; used by
                                                ; dbg_spalist, assstarskate, assscore
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFcelebrate, 12, SPFcelebrate+1, 40, SPFcelebrate, -5
.1:
        dw SPFcelebrate+2, 12, SPFcelebrate+3, 40, SPFcelebrate+2, -5
.2:
        dw SPFcelebrate+4, 12, SPFcelebrate+5, 40, SPFcelebrate+4, -5
.3:
        dw SPFcelebrate+6, 12, SPFcelebrate+7, 40, SPFcelebrate+6, -5
.4:
        dw SPFcelebrate+8, 12, SPFcelebrate+9, 40, SPFcelebrate+8, -5
.5:
        dw SPFcelebrate+10, 12, SPFcelebrate+11, 40, SPFcelebrate+10, -5
.6:
        dw SPFcelebrate+12, 12, SPFcelebrate+13, 40, SPFcelebrate+12, -5
.7:
        dw SPFcelebrate+14, 12, SPFcelebrate+15, 40, SPFcelebrate+14, -5
SPApump:                                        ; SPA 0x769: player doing pump (arm pump) animation; used by
                                                ; dbg_spalist, assscore
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFpump, 8, SPFpump+1, 16, SPFpump, -8
.1:
        dw SPFpump+2, 8, SPFpump+3, 16, SPFpump+2, -8
.2:
        dw SPFpump+4, 8, SPFpump+5, 16, SPFpump+4, -8
.3:
        dw SPFpump+6, 8, SPFpump+7, 16, SPFpump+6, -8
.4:
        dw SPFpump+8, 8, SPFpump+9, 16, SPFpump+8, -8
.5:
        dw SPFpump+10, 8, SPFpump+11, 16, SPFpump+10, -8
.6:
        dw SPFpump+12, 8, SPFpump+13, 16, SPFpump+12, -8
.7:
        dw SPFpump+14, 8, SPFpump+15, 16, SPFpump+14, -8
SPAwallright:                                   ; SPA 0x7A1: player jumps wall with legs to the right; used by
                                                ; dbg_spalist, updateanim, asseben, asspenalty
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2
.0:
        dw SPFPen+4, 8, SPFPen+5, 8, SPFPen+6, -8
.1:
        dw SPFPen, 8, SPFPen+1, 8, SPFPen+2, 8, SPFPen+3, -8
.3:
        dw SPFPen+3, 8, SPFPen+2, 8, SPFPen+1, 8, SPFPen, -8
SPAwallleft:                                    ; SPA 0x7BF: player jumps wall with legs to the left; used by
                                                ; dbg_spalist, TakePlayerFromBox, asspsclear, assleaveice ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2
.0:
        dw SPFPen+6, 8, SPFPen+5, 8, SPFPen+4, -8
.1:
        dw SPFPen+3, 8, SPFPen+2, 8, SPFPen+1, 8, SPFPen, -8
.3:
        dw SPFPen, 8, SPFPen+1, 8, SPFPen+2, 8, SPFPen+3, -8
SPAfaceoff:                                     ; SPA 0x7DD: player does faceoff stick check; used by
                                                ; dbg_spalist, faceoffinput, assfaceoffpl
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2
.0:
        dw 366, 6, 367, 8, 368, -8
.1:
        dw 361, 6, 362, 8, 363, -8
SPAfaceoffr:                                    ; SPA 0x7F1: ready position for faceoff; used by dbg_spalist,
                                                ; faceoffinput, assfaceoffpl
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2
.0:
        dw 365, -5
.1:
        dw 360, -5
SPAsiren:                                       ; SPA 0x7FD: siren animation; used by dbg_spalist, Goal,
                                                ; puckshadow
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw SPFSiren, 3, SPFSiren+1, 3, SPFSiren+2, 3, SPFSiren+3, 3, SPFSiren+4, 3, SPFSiren+5, 3, SPFSiren+6, 3, SPFSiren+7, 3, SPFSiren+8, 3, SPFSiren+9, 3, SPFSiren+10, 3, SPFSiren+11, 3, SPFSiren+12, 3, SPFSiren+13, -3
SPAbglass:                                      ; SPA 0x821: puck hits the glass: glass bang animation
                                                ; (SPFbglass frames); used by dbg_spalist, wallcollb
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw SPFbglass, 8, SPFbglass+1, 8, SPFbglass+2, 8, SPFbglass+3, 8, SPFbglass+4, -1000
SPAstanley:                                     ; SPA 0x833: player skates with stanley cup over head; used by
                                                ; dbg_spalist, assstanley
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFcup, -30
.1:
        dw SPFcup+1, -30
.2:
        dw SPFcup+2, -30
.3:
        dw SPFcup+3, -30
.4:
        dw SPFcup+4, -30
.5:
        dw SPFcup+5, -30
.6:
        dw SPFcup+6, -30
.7:
        dw SPFcup+7, -30
SPAcatch:                                       ; SPA 0x84B: player hit by a slower puck (puckbody); used by
                                                ; dbg_spalist, puckbody
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFcatch, 6, SPFcatch+1, -6
.1:
        dw SPFcatch+2, 6, SPFcatch+3, -6
.2:
        dw SPFcatch+4, 6, SPFcatch+5, -6
.3:
        dw SPFcatch+6, 6, SPFcatch+7, -6
.4:
        dw SPFcatch+8, 6, SPFcatch+9, -6
.5:
        dw SPFcatch+10, 6, SPFcatch+11, -6
.6:
        dw SPFcatch+12, 6, SPFcatch+13, -6
.7:
        dw SPFcatch+14, 6, SPFcatch+15, -6
SPAhook:                                        ; SPA 0x873: player hooking, also a hold animation; used by
                                                ; dbg_spalist, checkcheck, Acheck, Holdplayer
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFhook, -30
.1:
        dw SPFhook+2, -30
.2:
        dw SPFhook+4, -30
.3:
        dw SPFhook+6, -30
.4:
        dw SPFhook+8, -30
.5:
        dw SPFhook+10, -30
.6:
        dw SPFhook+12, -30
.7:
        dw SPFhook+14, -30
SPAhook2:                                       ; SPA 0x88B: holding animation after SPAhook; used by
                                                ; dbg_spalist, holdcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFhook, 9, SPFhook+1, 9, SPFhook, 9, SPFhook+1, -9
.1:
        dw SPFhook+2, 9, SPFhook+3, 9, SPFhook+2, 9, SPFhook+3, -9
.2:
        dw SPFhook+4, 9, SPFhook+5, 9, SPFhook+4, 9, SPFhook+5, -9
.3:
        dw SPFhook+6, 9, SPFhook+7, 9, SPFhook+6, 9, SPFhook+7, -9
.4:
        dw SPFhook+8, 9, SPFhook+9, 9, SPFhook+8, 9, SPFhook+9, -9
.5:
        dw SPFhook+10, 9, SPFhook+11, 9, SPFhook+10, 9, SPFhook+11, -9
.6:
        dw SPFhook+12, 9, SPFhook+13, 9, SPFhook+12, 9, SPFhook+13, -9
.7:
        dw SPFhook+14, 9, SPFhook+15, 9, SPFhook+14, 9, SPFhook+15, -9
SPAstumble:                                     ; SPA 0x8D3: player stumbles instead of falling; used by
                                                ; dbg_spalist, FallDown, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFstumble, 6, SPFstumble+1, 6, SPFstumble+2, 8, SPFstumble+1, 6, SPFstumble, -6
.1:
        dw SPFstumble+3, 6, SPFstumble+4, 6, SPFstumble+5, 8, SPFstumble+4, 6, SPFstumble+3, -6
.2:
        dw SPFstumble+6, 6, SPFstumble+7, 6, SPFstumble+8, 8, SPFstumble+7, 6, SPFstumble+6, -6
.3:
        dw SPFstumble+9, 6, SPFstumble+10, 6, SPFstumble+11, 8, SPFstumble+10, 6, SPFstumble+9, -6
.4:
        dw SPFstumble+12, 6, SPFstumble+13, 6, SPFstumble+14, 8, SPFstumble+13, 6, SPFstumble+12, -6
.5:
        dw SPFstumble+15, 6, SPFstumble+16, 6, SPFstumble+17, 8, SPFstumble+16, 6, SPFstumble+15, -6
.6:
        dw SPFstumble+18, 6, SPFstumble+19, 6, SPFstumble+20, 8, SPFstumble+19, 6, SPFstumble+18, -6
.7:
        dw SPFstumble+21, 6, SPFstumble+22, 6, SPFstumble+23, 8, SPFstumble+22, 6, SPFstumble+21, -6
SPAfake:                                        ; SPA 0x92B: skater fake: turn left, sweep, turn right frames;
                                                ; used by dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFturnl, 4, SPFturnl+7, 4, SPFsweep+12, 20, SPFturnr+7, 4, SPFturnr, 4, SPFturnr+1, -4
.1:
        dw SPFturnl+1, 4, SPFturnl, 4, SPFsweep+14, 20, SPFturnr, 4, SPFturnr+1, 4, SPFturnr+2, -4
.2:
        dw SPFturnl+2, 4, SPFturnl+1, 4, SPFsweep, 20, SPFturnr+1, 4, SPFturnr+2, 4, SPFturnr+3, -4
.3:
        dw SPFturnl+3, 4, SPFturnl+2, 4, SPFsweep+2, 20, SPFturnr+2, 4, SPFturnr+3, 4, SPFturnr+4, -4
.4:
        dw SPFturnl+4, 4, SPFturnl+3, 4, SPFsweep+4, 20, SPFturnr+3, 4, SPFturnr+4, 4, SPFturnr+5, -4
.5:
        dw SPFturnl+5, 4, SPFturnl+4, 4, SPFsweep+6, 20, SPFturnr+4, 4, SPFturnr+5, 4, SPFturnr+6, -4
.6:
        dw SPFturnl+6, 4, SPFturnl+5, 4, SPFsweep+8, 20, SPFturnr+5, 4, SPFturnr+6, 4, SPFturnr+7, -4
.7:
        dw SPFturnl+7, 4, SPFturnl+6, 4, SPFsweep+10, 20, SPFturnr+6, 4, SPFturnr+7, 4, SPFturnr, -4
SPAflip:                                        ; SPA 0x993: player flips over, third fall animation; used by
                                                ; dbg_spalist, FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFflip, 6, SPFflip+1, 6, SPFflip+2, 6, SPFflip+3, 6, SPFfallback+2, 100, SPFfallback+3, 8, SPFduck, -8
.1:
        dw SPFflip, 6, SPFflip+1, 6, SPFflip+2, 6, SPFflip+3, 6, SPFfallback+6, 100, SPFfallback+7, 8, SPFduck+1, -8
.2:
        dw SPFflip, 6, SPFflip+1, 6, SPFflip+2, 6, SPFflip+3, 6, SPFfallback+10, 100, SPFfallback+11, 8, SPFduck+2, -8
.3:
        dw SPFflip+4, 6, SPFflip+5, 6, SPFflip+6, 6, SPFflip+7, 6, SPFfallback+14, 100, SPFfallback+15, 8, SPFduck+3, -8
.4:
        dw SPFflip+4, 6, SPFflip+5, 6, SPFflip+6, 6, SPFflip+7, 6, SPFfallback+18, 100, SPFfallback+19, 8, SPFduck+4, -8
.5:
        dw SPFflip+4, 6, SPFflip+5, 6, SPFflip+6, 6, SPFflip+7, 6, SPFfallback+22, 100, SPFfallback+23, 8, SPFduck+5, -8
.6:
        dw SPFflip+4, 6, SPFflip+5, 6, SPFflip+6, 6, SPFflip+7, 6, SPFfallback+26, 100, SPFfallback+27, 8, SPFduck+6, -8
.7:
        dw SPFflip, 6, SPFflip+1, 6, SPFflip+2, 6, SPFflip+3, 6, SPFfallback+30, 100, SPFfallback+31, 8, SPFduck+7, -8
SPAinjury1:                                     ; SPA 0xA0B: player falls and lies injured; used by
                                                ; dbg_spalist, FallDown, updateplayers
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.0-.0)/2
.0:
        dw SPFfallback, 6, SPFfallback+1, 6, SPFfallback+2, 30, SPFinjury1, 10, SPFinjury1+1, 10, SPFinjury1+2, 10, SPFinjury1+3, 8, SPFinjury1+4, 8, SPFinjury1+5, 8, SPFinjury1+3, 8, SPFinjury1+4, 8, SPFinjury1+5, 8, SPFinjury1+3, 8, SPFinjury1+4, 8, SPFinjury1+5, 8, SPFinjury1+3, 8, SPFinjury1+4, 8, SPFinjury1+5, -2900
.3:
        dw SPFfallback+16, 6, SPFfallback+17, 6, SPFfallback+18, 30, SPFinjury1+6, 10, SPFinjury1+7, 10, SPFinjury1+8, 10, SPFinjury1+9, 8, SPFinjury1+10, 8, SPFinjury1+11, 8, SPFinjury1+9, 8, SPFinjury1+10, 8, SPFinjury1+11, 8, SPFinjury1+9, 8, SPFinjury1+10, 8, SPFinjury1+11, 8, SPFinjury1+9, 8, SPFinjury1+10, 8, SPFinjury1+11, -2900
SPArefglide:                                    ; SPA 0xA5B; used by dbg_spalist, assrefpenshot, assintroline,
                                                ; assreffollow ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 650, -8
.1:
        dw 685, -8
.2:
        dw 680, -8
.3:
        dw 675, -8
.4:
        dw 670, -8
.5:
        dw 665, -8
.6:
        dw 660, -8
.7:
        dw 655, -8
SPArefskate:                                    ; SPA 0xA73; used by dbg_spalist, SkateToSpot, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 653, 10, 654, 10, 651, 10, 652, -10
.1:
        dw 688, 10, 689, 10, 686, 10, 687, -10
.2:
        dw 683, 10, 684, 10, 681, 10, 682, -10
.3:
        dw 678, 10, 679, 10, 676, 10, 677, -10
.4:
        dw 673, 10, 674, 10, 671, 10, 672, -10
.5:
        dw 668, 10, 669, 10, 666, 10, 667, -10
.6:
        dw 663, 10, 664, 10, 661, 10, 662, -10
.7:
        dw 658, 10, 659, 10, 656, 10, 657, -10
SPArefturnl:                                    ; SPA 0xABB; used by dbg_spalist, doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 755, -8
.1:
        dw 756, -8
.2:
        dw 757, -8
.3:
        dw 758, -8
.4:
        dw 759, -8
.5:
        dw 760, -8
.6:
        dw 761, -8
.7:
        dw 762, -8
SPArefturnr:                                    ; SPA 0xAD3; used by dbg_spalist, doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 763, -8
.1:
        dw 764, -8
.2:
        dw 765, -8
.3:
        dw 766, -8
.4:
        dw 767, -8
.5:
        dw 768, -8
.6:
        dw 769, -8
.7:
        dw 770, -8
SPArefstop:                                     ; SPA 0xAEB; used by dbg_spalist, dostop
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 771, 4, 772, -4
.1:
        dw 773, 4, 774, -4
.2:
        dw 775, 4, 776, -4
.3:
        dw 777, 4, 778, -4
.4:
        dw 779, 4, 780, -4
.5:
        dw 781, 4, 782, -4
.6:
        dw 783, 4, 784, -4
.7:
        dw 785, 4, 786, -4
SPAreffallback:                                 ; SPA 0xB13; used by dbg_spalist, FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 787, 10, 788, 28, 789, -10
.1:
        dw 790, 10, 791, 28, 792, -10
.2:
        dw 793, 10, 794, 28, 795, -10
.3:
        dw 796, 10, 797, 28, 798, -10
.4:
        dw 799, 10, 800, 28, 801, -10
.5:
        dw 802, 10, 803, 28, 804, -10
.6:
        dw 805, 10, 806, 28, 807, -10
.7:
        dw 808, 10, 809, 28, 810, -10
SPAarmupglide:                                  ; SPA 0xB4B; used by dbg_spalist, doplayeracc, dostop, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 715, -8
.1:
        dw 750, -8
.2:
        dw 745, -8
.3:
        dw 740, -8
.4:
        dw 737, -8
.5:
        dw 730, -8
.6:
        dw 725, -8
.7:
        dw 720, -8
SPAarmupskate:                                  ; SPA 0xB63; used by dbg_spalist, noturn0
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 718, 10, 719, 10, 716, 10, 717, -10
.1:
        dw 753, 10, 754, 10, 752, 10, 751, -10
.2:
        dw 748, 10, 749, 10, 746, 10, 747, -10
.3:
        dw 743, 10, 744, 10, 741, 10, 742, -10
.4:
        dw 738, 10, 735, 10, 736, 10, 739, -10
.5:
        dw 733, 10, 734, 10, 731, 10, 732, -10
.6:
        dw 728, 10, 729, 10, 726, 10, 727, -10
.7:
        dw 723, 10, 724, 10, 721, 10, 722, -10
SPAarmupturnl:                                  ; SPA 0xBAB; used by dbg_spalist, doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 811, -8
.1:
        dw 812, -8
.2:
        dw 813, -8
.3:
        dw 814, -8
.4:
        dw 815, -8
.5:
        dw 816, -8
.6:
        dw 817, -8
.7:
        dw 818, -8
SPAarmupturnr:                                  ; SPA 0xBC3; used by dbg_spalist, doplayeracc
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 819, -8
.1:
        dw 820, -8
.2:
        dw 821, -8
.3:
        dw 822, -8
.4:
        dw 823, -8
.5:
        dw 824, -8
.6:
        dw 825, -8
.7:
        dw 826, -8
SPAarmupstop:                                   ; SPA 0xBDB; used by dbg_spalist, dostop
        dw 8000h                                ; loops (bit 15); direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 827, 4, 828, -4
.1:
        dw 829, 4, 830, -4
.2:
        dw 831, 4, 832, -4
.3:
        dw 833, 4, 834, -4
.4:
        dw 835, 4, 836, -4
.5:
        dw 837, 4, 838, -4
.6:
        dw 839, 4, 840, -4
.7:
        dw 841, 4, 842, -4
SPArefpickup:                                   ; SPA 0xC03; used by dbg_spalist, assrefpenshot, assrefgoalpa
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 691, -12
.1:
        dw 698, -12
.2:
        dw 697, -12
.3:
        dw 696, -12
.4:
        dw 695, -12
.5:
        dw 694, -12
.6:
        dw 693, -12
.7:
        dw 692, -12
SPArefpointgoa:                                 ; SPA 0xC1B; used by dbg_spalist, ass_popx, assrefgoalline
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 699, 8, 700, -24
.1:
        dw 701, 8, 702, -24
.2:
        dw 703, 8, 704, -24
.3:
        dw 705, 8, 706, -24
.4:
        dw 707, 8, 708, -24
.5:
        dw 709, 8, 710, -24
.6:
        dw 711, 8, 712, -24
.7:
        dw 713, 8, 714, -24
SPArefdrop:                                     ; SPA 0xC43; used by dbg_spalist, puckfaceoff2
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.0-.0)/2
.0:
        dw 843, 8, 844, 8, 703, -8
.3:
        dw 845, 8, 846, 8, 711, -8
SPAreffowait:                                   ; SPA 0xC57; used by dbg_spalist, puckfaceoff2, assintroline,
                                                ; assrefatdot
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.0-.0)/2
.0:
        dw 703, -8
.3:
        dw 711, -8
SPArefrough:                                    ; SPA 0xC63; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 859, 12, 860, 24, 847, -12
SPArefcharge:                                   ; SPA 0xC73; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 863, 12, 864, 12, 865, 12, 863, 12, 864, 12, 865, 12, 847, -12
SPArefslash:                                    ; SPA 0xC8B; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 852, 12, 853, 24, 847, -12
SPArefxcheck:                                   ; SPA 0xC9B; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 854, 12, 855, 24, 847, -12
SPArefhook:                                     ; SPA 0xCAB; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 850, 12, 851, 24, 847, -12
SPAreftrip:                                     ; SPA 0xCBB; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 861, 12, 862, 24, 847, -12
SPArefinterfer:                                 ; SPA 0xCCB; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 857, 48, 847, -12
SPArefhold:                                     ; SPA 0xCD9; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 856, 48, 847, -12
SPArefabuseoff:                                 ; SPA 0xCE7; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 858, 48, 847, -12
SPArefbehind:                                   ; SPA 0xCF5; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 848, 12, 849, 24, 847, -12
SPAfaceoffpoke:                                 ; SPA 0xD05; used by dbg_spalist, faceoffinput, assfaceoffpl
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.1-.0)/2
.0:
        dw 366, 6, 367, -8
.1:
        dw 361, 6, 362, -8
SPAgwallright:                                  ; SPA 0xD15; used by dbg_spalist, asseben
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.0-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2
.0:
        dw 372, 8, 373, 8, 374, 8, 375, -8
.4:
        dw 375, 8, 374, 8, 373, 8, 372, -8
SPAgwallleft:                                   ; SPA 0xD2D; used by dbg_spalist, asspsclear, assleaveice,
                                                ; assbench
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.0-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2
.0:
        dw 375, 8, 374, 8, 373, 8, 372, -8
.4:
        dw 372, 8, 373, 8, 374, 8, 375, -8
SPAanthem1:                                     ; SPA 0xD45; used by introstandanims_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 369, 30, 370, 30, 371, 30, 370, 30, 369, -60
SPAanthem2:                                     ; SPA 0xD57; used by introstandanims_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 369, 30, 370, 30, 371, 30, 369, -60
SPAanthem3:                                     ; SPA 0xD67; used by introstandanims_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 369, 30, 370, 30, 371, 30, 370, 30, 371, 30, 369, -60
SPAanthem4:                                     ; SPA 0xD7B; used by introstandanims_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 369, 30, SPFPen+4, 45, 369, -60
SPAanthem5:                                     ; SPA 0xD89; used by introstandanims_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 369, 30, SPFPen+5, 45, 369, -60
SPAdrink:                                       ; SPA 0xD97; used by dbg_spalist, assleavebox
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.0-.0)/2, (.0-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2, (.4-.0)/2
.0:
        dw 699, 30, 700, 45, 699, -30
.4:
        dw 701, 30, 702, 45, 701, -30
SPArefanthem1:                                  ; SPA 0xDAB; used by dbg_spalist, assintroline
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 649, 30, 705, 30, 706, 30, 707, 30, 706, 30, 707, 30, 705, 30, 649, -30
SPArefanthem2:                                  ; SPA 0xDC3; used by dbg_spalist, assintroline
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 649, 30, 690, 30, 705, 30, 649, -30
SPAonetimef:                                    ; SPA 0xDD3; used by dbg_spalist, CanBlockShot, assonetimer,
                                                ; ShotMode ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+1, 24, SPFswing+2, 4, SPFswing+3, 4, SPFswing+4, 4, SPFswing+5, -20
.1:
        dw SPFswing+7, 24, SPFswing+8, 4, SPFswing+9, 4, SPFswing+10, 4, SPFswing+11, -20
.2:
        dw SPFswing+13, 24, SPFswing+14, 4, SPFswing+15, 4, SPFswing+16, 4, SPFswing+17, -20
.3:
        dw SPFswing+19, 24, SPFswing+20, 4, SPFswing+21, 4, SPFswing+22, 4, SPFswing+23, -20
.4:
        dw SPFswing+25, 24, SPFswing+26, 4, SPFswing+27, 4, SPFswing+28, 4, SPFswing+29, -20
.5:
        dw SPFswing+31, 24, SPFswing+32, 4, SPFswing+33, 4, SPFswing+34, 4, SPFswing+35, -20
.6:
        dw SPFswing+37, 24, SPFswing+38, 4, SPFswing+39, 4, SPFswing+40, 4, SPFswing+41, -20
.7:
        dw SPFswing+43, 24, SPFswing+44, 4, SPFswing+45, 4, SPFswing+46, 4, SPFswing+47, -20
SPAonetimeb:                                    ; SPA 0xE2B; used by dbg_spalist, CanBlockShot, assonetimer,
                                                ; ShotMode ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+5, 24, SPFswing+4, 4, SPFswing+3, 4, SPFswing+2, 4, SPFswing+1, -20
.1:
        dw SPFswing+11, 24, SPFswing+10, 4, SPFswing+9, 4, SPFswing+8, 4, SPFswing+7, -20
.2:
        dw SPFswing+17, 24, SPFswing+16, 4, SPFswing+15, 4, SPFswing+14, 4, SPFswing+13, -20
.3:
        dw SPFswing+23, 24, SPFswing+22, 4, SPFswing+21, 4, SPFswing+20, 4, SPFswing+19, -20
.4:
        dw SPFswing+29, 24, SPFswing+28, 4, SPFswing+27, 4, SPFswing+26, 4, SPFswing+25, -20
.5:
        dw SPFswing+35, 24, SPFswing+34, 4, SPFswing+33, 4, SPFswing+32, 4, SPFswing+31, -20
.6:
        dw SPFswing+41, 24, SPFswing+40, 4, SPFswing+39, 4, SPFswing+38, 4, SPFswing+37, -20
.7:
        dw SPFswing+47, 24, SPFswing+46, 4, SPFswing+45, 4, SPFswing+44, 4, SPFswing+43, -20
SPAgetcup:                                      ; SPA 0xE83; used by dbg_spalist, assboxenter
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 357, 16, 358, 16, 872, 32, 358, 12, 873, 12, SPFcup+4, -32
SPAbrcup:                                       ; SPA 0xE97; used by dbg_spalist, assbenchside
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 866, 12, 867, 12, 866, 12, 867, 12, 868, -4
SPAgvcup:                                       ; SPA 0xEA9; used by dbg_spalist, assboxenter
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 868, 17, 869, -12
SPAclap:                                        ; SPA 0xEB5; used by dbg_spalist, assbenchside
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 871, 12, 870, 12, 871, 12, 870, 12, 871, 12, 870, 12, 869, -12
SPAstansk:                                      ; SPA 0xECB; used by dbg_spalist, assstanley
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 874, 12, 875, -12
SPAcrosscheck:                                  ; SPA 0xED7: the checker stops after a hit into the boards
                                                ; away from the crease; used by dbg_spalist, checkcheck
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 888, 5, 889, 10, 888, -6
.1:
        dw 890, 5, 891, 10, 890, -6
.2:
        dw 892, 5, 893, 10, 892, -6
.3:
        dw 894, 5, 895, 10, 894, -6
.4:
        dw 896, 5, 897, 10, 896, -6
.5:
        dw 898, 5, 899, 10, 898, -6
.6:
        dw 900, 5, 901, 10, 900, -6
.7:
        dw 902, 5, 903, 10, 902, -6
SPAboardback:                                   ; SPA 0xF0F: checked into the end boards behind the bottom
                                                ; goal line; used by dbg_spalist, NetCollide, FallDown,
                                                ; checkcoll ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.6-.0)/2
.0:
        dw 945, 10, 905, 10, SPFfallback+1, 10, SPFfallback+2, 55, SPFfallback+3, 10, SPFduck, -10
.2:
        dw 948, 10, 920, 10, 921, 65, 922, 10, 923, -10
.3:
        dw 919, 10, 920, 10, 921, 65, 922, 10, 923, -10
.4:
        dw 924, 10, 925, 10, 926, 65, 927, 10, 928, -10
.5:
        dw 929, 10, 930, 10, 931, 65, 932, 10, 933, -10
.6:
        dw 954, 10, 930, 10, 931, 65, 932, 10, 933, -10
SPAboardfront:                                  ; SPA 0xF55: checked into the end boards behind the top goal
                                                ; line; used by dbg_spalist, NetCollide, FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.3-.0)/2, (.3-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 904, 10, 905, 10, 906, 65, 907, 10, 908, -10
.1:
        dw 914, 10, 915, 10, 916, 65, 917, 10, 918, -10
.2:
        dw 949, 10, 915, 10, 916, 65, 917, 10, 918, -10
.3:
        dw 950, 10, 925, 10, SPFfallback+17, 10, SPFfallback+18, 55, SPFfallback+19, 10, SPFduck+4, -10
.6:
        dw 955, 10, 940, 10, 941, 65, 942, 10, 943, -10
.7:
        dw 939, 10, 940, 10, 941, 65, 942, 10, 943, -10
SPAboardright:                                  ; SPA 0xF9B: checked into the right side boards
                                                ; (FallDown.FallList 1; flipped; used by dbg_spalist,
                                                ; NetCollide, FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.1-.0)/2, (.1-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 944, 10, 940, 10, 941, 65, 942, 10, 943, -10
.1:
        dw 947, 10, 910, 10, SPFfallback+9, 10, SPFfallback+10, 55, SPFfallback+11, 10, SPFduck+2, -10
.4:
        dw 951, 10, 930, 10, 931, 65, 932, 10, 933, -10
.5:
        dw 929, 10, 930, 10, 931, 65, 932, 10, 933, -10
.6:
        dw 934, 10, 935, 10, 936, 65, 937, 10, 938, -10
.7:
        dw 939, 10, 940, 10, 941, 65, 942, 10, 943, -10
SPAboardleft:                                   ; SPA 0xFE1: checked into the left side boards
                                                ; (FallDown.FallList 3; flipped; used by dbg_spalist,
                                                ; NetCollide, FallDown
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.5-.0)/2, (.5-.0)/2
.0:
        dw 946, 10, 915, 10, 916, 65, 917, 10, 918, -10
.1:
        dw 914, 10, 915, 10, 916, 65, 917, 10, 918, -10
.2:
        dw 909, 10, 910, 10, 911, 65, 912, 10, 913, -10
.3:
        dw 919, 10, 920, 10, 921, 65, 922, 10, 923, -10
.4:
        dw 952, 10, 920, 10, 921, 65, 922, 10, 923, -10
.5:
        dw 953, 10, 935, 10, SPFfallback+25, 10, SPFfallback+26, 55, SPFfallback+27, 10, SPFduck+6, -10
SPAbenchcheckr:                                 ; SPA 0x1027: checked into the right boards near center ice
                                                ; (FallDown, from; used by dbg_spalist, FallDown, updateanim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.2-.0)/2, (.2-.0)/2, (.4-.0)/2, (.4-.0)/2, (.6-.0)/2, (.6-.0)/2
.0:
        dw 944, 10, 876, 10, 877, 10, 878, 10, 879, -40
.2:
        dw 947, 10, 968, 10, 969, 10, 970, -40
.4:
        dw 951, 10, 960, 10, 961, 10, 962, 10, 963, -40
.6:
        dw 955, 10, 956, 10, 957, 10, 958, 10, 959, -40
SPAbenchcheckl:                                 ; SPA 0x1055: checked into the left boards near center ice
                                                ; (FallDown, from; used by dbg_spalist, FallDown, checkcoll,
                                                ; updateplayers ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.0-.0)/2, (.2-.0)/2, (.2-.0)/2, (.4-.0)/2, (.4-.0)/2, (.6-.0)/2, (.6-.0)/2
.0:
        dw 946, 10, 880, 10, 881, 10, 882, 10, 883, -40
.2:
        dw 949, 10, 884, 10, 885, 10, 886, 10, 887, -40
.4:
        dw 952, 10, 964, 10, 965, 10, 966, 10, 967, -40
.6:
        dw 953, 10, 971, 10, 972, 10, 973, -40
SPArefpenshot:                                  ; SPA 0x1083; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 847, 12, 711, 12, 712, 24, 711, 8, 847, -12
SPAgoaliepoke:                                  ; SPA 0x1095; used by dbg_spalist, assgoalie
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 978, 4, 979, 15, 978, -6
.1:
        dw 980, 4, 981, 15, 980, -6
.2:
        dw 982, 4, 983, 15, 982, -6
.3:
        dw 984, 4, 985, 15, 984, -6
.4:
        dw 986, 4, 987, 15, 986, -6
.5:
        dw 988, 4, 989, 15, 988, -6
.6:
        dw 990, 4, 991, 15, 990, -6
.7:
        dw 992, 4, 993, 15, 992, -6
SPAgoalieknee:                                  ; SPA 0x10CD; used by dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 994, 6, 995, 6, 996, 20, 995, 6, 994, 6, SPFGoalie, -8
.1:
        dw 997, 6, 998, 6, 999, 20, 998, 6, 997, 6, SPFGoalie+3, -8
.2:
        dw SPFGoalie+6, 6, 1000, 6, 1001, 20, 1000, 6, SPFGoalie+6, 4, SPFGoalie+6, -4
.3:
        dw SPFGoalie+9, 6, 1002, 6, 1003, 20, 1002, 6, SPFGoalie+9, 4, SPFGoalie+9, -4
.4:
        dw SPFGoalie+12, 6, 1004, 6, 1005, 20, 1004, 6, SPFGoalie+12, 4, SPFGoalie+12, -4
.5:
        dw SPFGoalie+15, 6, 1006, 6, 1007, 20, 1006, 6, SPFGoalie+15, 4, SPFGoalie+15, -4
.6:
        dw SPFGoalie+18, 6, 1008, 6, 1009, 20, 1008, 6, SPFGoalie+18, 4, SPFGoalie+18, -4
.7:
        dw SPFGoalie+21, 6, 1010, 6, 1011, 20, 1010, 6, SPFGoalie+21, 4, SPFGoalie+21, -4
SPAgokneehold:                                  ; SPA 0x1135; used by dbg_spalist, assgoalie
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 994, 6, 995, 6, 996, 90, 995, 6, 994, 6, SPFGoalie, -4
.1:
        dw 997, 6, 998, 6, 999, 90, 998, 6, 997, 6, SPFGoalie+3, -4
.2:
        dw SPFGoalie+6, 6, 1000, 6, 1001, 90, 1000, 6, SPFGoalie+6, 6, SPFGoalie+6, -4
.3:
        dw SPFGoalie+9, 6, 1002, 6, 1003, 90, 1002, 6, SPFGoalie+9, 6, SPFGoalie+9, -4
.4:
        dw SPFGoalie+12, 6, 1004, 6, 1005, 90, 1004, 6, SPFGoalie+12, 6, SPFGoalie+12, -4
.5:
        dw SPFGoalie+15, 6, 1006, 6, 1007, 90, 1006, 6, SPFGoalie+15, 6, SPFGoalie+15, -4
.6:
        dw SPFGoalie+18, 6, 1008, 6, 1009, 90, 1008, 6, SPFGoalie+18, 6, SPFGoalie+18, -4
.7:
        dw SPFGoalie+21, 6, 1010, 6, 1011, 90, 1010, 6, SPFGoalie+21, 6, SPFGoalie+21, -4
SPAgofallback:                                  ; SPA 0x119D; used by goaliesave_saveanim_m2, dbg_spalist,
                                                ; puckgoalie, puckstick
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1012, 8, 1013, 20, SPFGoalie, -4
.1:
        dw 1014, 8, 1015, 20, SPFGoalie+3, -4
.2:
        dw 1016, 8, 1017, 20, SPFGoalie+6, -4
.3:
        dw 1018, 8, 1019, 20, SPFGoalie+9, -4
.4:
        dw 1020, 8, 1021, 20, SPFGoalie+12, -4
.5:
        dw 1022, 8, 1023, 20, SPFGoalie+15, -4
.6:
        dw 1024, 8, 1025, 20, SPFGoalie+18, -4
.7:
        dw 1026, 8, 1027, 20, SPFGoalie+21, -4
SPAgofallglove:                                 ; SPA 0x11D5; used by goaliesave_saveanim_m2, dbg_spalist,
                                                ; SkillForAnim
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1028, 4, 1029, 4, 1030, 20, SPFGoalie, -4
.1:
        dw 1031, 4, 1032, 4, 1033, 20, SPFGoalie+3, -4
.2:
        dw 1034, 4, 1035, 4, 1036, 20, SPFGoalie+6, -4
.3:
        dw 1037, 4, 1038, 4, 1039, 20, SPFGoalie+9, -4
.4:
        dw 1040, 4, 1041, 4, 1042, 20, SPFGoalie+12, -4
.5:
        dw 1046, 4, 1047, 4, 1048, 20, SPFGoalie+18, -4
.6:
        dw 1043, 4, 1044, 4, 1045, 20, SPFGoalie+15, -4
.7:
        dw 1049, 4, 1050, 4, 1051, 20, SPFGoalie+21, -4
SPAgofallstick:                                 ; SPA 0x121D; used by goaliesave_saveanim_m2, dbg_spalist,
                                                ; SkillForAnim, puckgoalie ...
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1052, 4, 1053, 4, 1054, 20, SPFGoalie, -4
.1:
        dw 1055, 4, 1056, 4, 1057, 20, SPFGoalie+3, -4
.2:
        dw 1058, 4, 1059, 4, 1060, 20, SPFGoalie+6, -4
.3:
        dw 1061, 4, 1062, 4, 1063, 20, SPFGoalie+9, -4
.4:
        dw 1064, 4, 1065, 4, 1066, 20, SPFGoalie+12, -4
.5:
        dw 1067, 4, 1068, 4, 1069, 20, SPFGoalie+15, -4
.6:
        dw 1070, 4, 1071, 4, 974, 20, SPFGoalie+18, -4
.7:
        dw 975, 4, 976, 4, 977, 20, SPFGoalie+21, -4
SPAfakeshotf:                                   ; SPA 0x1265; used by dbg_spalist, CanBlockShot, ShotMode
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+2, 4, SPFswing+1, 4, SPFswing, 4, SPFswing+1, 4, SPFswing+2, 4, SPFskatewp, -4
.1:
        dw SPFswing+9, 4, SPFswing+8, 4, SPFswing+7, 4, SPFswing+6, 4, SPFswing+7, 4, SPFswing+8, 4, SPFskatewp+5, -4
.2:
        dw SPFswing+15, 4, SPFswing+14, 4, SPFswing+13, 4, SPFswing+12, 4, SPFswing+13, 4, SPFswing+14, 4, SPFskatewp+10, -4
.3:
        dw SPFswing+21, 4, SPFswing+20, 4, SPFswing+19, 4, SPFswing+18, 4, SPFswing+19, 4, SPFswing+20, 4, SPFskatewp+15, -4
.4:
        dw SPFswing+27, 4, SPFswing+26, 4, SPFswing+25, 4, SPFswing+24, 4, SPFswing+25, 4, SPFswing+26, 4, SPFskatewp+20, -4
.5:
        dw SPFswing+33, 4, SPFswing+32, 4, SPFswing+31, 4, SPFswing+30, 4, SPFswing+31, 4, SPFswing+32, 4, SPFskatewp+25, -4
.6:
        dw SPFswing+39, 4, SPFswing+38, 4, SPFswing+37, 4, SPFswing+36, 4, SPFswing+37, 4, SPFswing+38, 4, SPFskatewp+30, -4
.7:
        dw SPFswing+45, 4, SPFswing+44, 4, SPFswing+43, 4, SPFswing+42, 4, SPFswing+43, 4, SPFswing+44, 4, SPFskatewp+35, -4
SPAfakeshotb:                                   ; SPA 0x12DD; used by dbg_spalist, CanBlockShot, ShotMode
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+3, 4, SPFswing+4, 4, SPFswing+5, 4, SPFswing+5, 4, SPFswing+5, 4, SPFswing+4, 4, SPFskatewp, -4
.1:
        dw SPFswing+9, 4, SPFswing+10, 4, SPFswing+11, 4, SPFswing+11, 4, SPFswing+11, 4, SPFswing+10, 4, SPFskatewp+5, -4
.2:
        dw SPFswing+15, 4, SPFswing+16, 4, SPFswing+17, 4, SPFswing+17, 4, SPFswing+17, 4, SPFswing+16, 4, SPFskatewp+10, -4
.3:
        dw SPFswing+21, 4, SPFswing+22, 4, SPFswing+23, 4, SPFswing+23, 4, SPFswing+23, 4, SPFswing+22, 4, SPFskatewp+15, -4
.4:
        dw SPFswing+27, 4, SPFswing+28, 4, SPFswing+29, 4, SPFswing+29, 4, SPFswing+29, 4, SPFswing+28, 4, SPFskatewp+20, -4
.5:
        dw SPFswing+33, 4, SPFswing+34, 4, SPFswing+35, 4, SPFswing+35, 4, SPFswing+35, 4, SPFswing+34, 4, SPFskatewp+25, -4
.6:
        dw SPFswing+39, 4, SPFswing+40, 4, SPFswing+41, 4, SPFswing+41, 4, SPFswing+41, 4, SPFswing+40, 4, SPFskatewp+30, -4
.7:
        dw SPFswing+45, 4, SPFswing+46, 4, SPFswing+47, 4, SPFswing+47, 4, SPFswing+47, 4, SPFswing+46, 4, SPFskatewp+35, -4
SPAfakeonetimef:                                ; SPA 0x1355; used by dbg_spalist, CanBlockShot, assonetimer,
                                                ; ShotMode
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+1, 24, SPFswing+2, 4, SPFskatewp, -4
.1:
        dw SPFswing+7, 24, SPFswing+8, 4, SPFskatewp+5, -4
.2:
        dw SPFswing+13, 24, SPFswing+14, 4, SPFskatewp+10, -4
.3:
        dw SPFswing+19, 24, SPFswing+20, 4, SPFskatewp+15, -4
.4:
        dw SPFswing+25, 24, SPFswing+26, 4, SPFskatewp+20, -4
.5:
        dw SPFswing+31, 24, SPFswing+32, 4, SPFskatewp+25, -4
.6:
        dw SPFswing+37, 24, SPFswing+38, 4, SPFskatewp+30, -4
.7:
        dw SPFswing+43, 24, SPFswing+44, 4, SPFskatewp+35, -4
SPAfakeonetimeb:                                ; SPA 0x138D; used by dbg_spalist, CanBlockShot, assonetimer,
                                                ; ShotMode
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw SPFswing+5, 24, SPFswing+4, 4, SPFskatewp, -4
.1:
        dw SPFswing+11, 24, SPFswing+10, 4, SPFskatewp+5, -4
.2:
        dw SPFswing+17, 24, SPFswing+16, 4, SPFskatewp+10, -4
.3:
        dw SPFswing+23, 24, SPFswing+22, 4, SPFskatewp+15, -4
.4:
        dw SPFswing+29, 24, SPFswing+28, 4, SPFskatewp+20, -4
.5:
        dw SPFswing+35, 24, SPFswing+34, 4, SPFskatewp+25, -4
.6:
        dw SPFswing+41, 24, SPFswing+40, 4, SPFskatewp+30, -4
.7:
        dw SPFswing+47, 24, SPFswing+46, 4, SPFskatewp+35, -4
SPAblockleft:                                   ; SPA 0x13C5; used by dbg_spalist, FallDown, BlockShotDive,
                                                ; puckstick
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1072, 8, 1073, 24, SPFfallfwd+11, 8, SPFduck+2, 8, SPFskate+5, -4
.1:
        dw 1074, 8, 1075, 24, SPFfallfwd+15, 8, SPFduck+3, 8, SPFskate+10, -4
.2:
        dw 1076, 8, 1077, 24, SPFfallfwd+19, 8, SPFduck+4, 8, SPFskate+15, -4
.3:
        dw 1078, 8, 1079, 24, SPFfallfwd+23, 8, SPFduck+5, 8, SPFskate+20, -4
.4:
        dw 1080, 8, 1081, 24, SPFfallfwd+27, 8, SPFduck+6, 8, SPFskate+25, -4
.5:
        dw 1082, 8, 1083, 24, SPFfallfwd+31, 8, SPFduck+7, 8, SPFskate+30, -4
.6:
        dw 1084, 8, 1085, 24, SPFfallfwd+3, 8, SPFduck, 8, SPFskate+35, -4
.7:
        dw 1086, 8, 1087, 24, SPFfallfwd+7, 8, SPFduck+1, 8, SPFskate, -4
SPAblockright:                                  ; SPA 0x141D; used by dbg_spalist, FallDown, BlockShotDive
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1088, 8, 1089, 24, SPFfallfwd+27, 8, SPFduck+6, 8, SPFskate+35, -4
.1:
        dw 1090, 8, 1091, 24, SPFfallfwd+31, 8, SPFduck+7, 8, SPFskate, -4
.2:
        dw 1092, 8, 1093, 24, SPFfallfwd+3, 8, SPFduck, 8, SPFskate+5, -4
.3:
        dw 1094, 8, 1095, 24, SPFfallfwd+7, 8, SPFduck+1, 8, SPFskate+10, -4
.4:
        dw 1096, 8, 1097, 24, SPFfallfwd+11, 8, SPFduck+2, 8, SPFskate+15, -4
.5:
        dw 1098, 8, 1099, 24, SPFfallfwd+15, 8, SPFduck+3, 8, SPFskate+20, -4
.6:
        dw 1100, 8, 1101, 24, SPFfallfwd+19, 8, SPFduck+4, 8, SPFskate+25, -4
.7:
        dw 1102, 8, 1103, 24, SPFfallfwd+23, 8, SPFduck+5, 8, SPFskate+30, -4
SPAblockfront:                                  ; SPA 0x1475; used by dbg_spalist, BlockShotDive
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1104, 8, 1105, 20, 1104, -8
.1:
        dw 1107, 8, 1108, 20, 1107, -8
.2:
        dw 1110, 8, 1111, 20, 1110, -8
.3:
        dw 1113, 8, 1114, 20, 1113, -8
.4:
        dw 1116, 8, 1117, 20, 1116, -8
.5:
        dw 1119, 8, 1120, 20, 1119, -8
.6:
        dw 1122, 8, 1122, 20, 1122, -8
.7:
        dw 1125, 8, 1126, 20, 1125, -8
SPAblockknee:                                   ; SPA 0x14AD; used by dbg_spalist, BlockShotDive, puckstick
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw (.1-.0)/2, (.2-.0)/2, (.3-.0)/2, (.4-.0)/2, (.5-.0)/2, (.6-.0)/2, (.7-.0)/2
.0:
        dw 1105, 8, 1106, 24, 1105, -8
.1:
        dw 1108, 8, 1109, 24, 1108, -8
.2:
        dw 1111, 8, 1112, 24, 1111, -8
.3:
        dw 1114, 8, 1115, 24, 1114, -8
.4:
        dw 1117, 8, 1118, 24, 1117, -8
.5:
        dw 1120, 8, 1121, 24, 1120, -8
.6:
        dw 1122, 8, 1124, 24, 1122, -8
.7:
        dw 1125, 8, 1127, 24, 1125, -8
SPArefelbow:                                    ; SPA 0x14E5; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 705, 12, 1128, 10, 1129, 10, 1130, 24, 1128, 12, 705, -12
SPArefhistick:                                  ; SPA 0x14F9; used by refsigspa_m2, dbg_spalist
        dw 0                                    ; flags 0; direction 0 starts at .0
        dw 0, 0, 0, 0, 0, 0, 0                  ; every direction uses .0
.0:
        dw 705, 12, 1131, 10, 1132, 10, 1133, 24, 1131, 12
        dw 705
        db -12                                  ; low byte of the final time (-12); its high byte is priolist_m1
