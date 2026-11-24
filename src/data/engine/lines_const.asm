; Strings and constants of engine/lines (src/engine/lines), in link order.
bits 32
%include "hockey.inc"
section s_C1DB6 progbits alloc noexec write align=1
global str_04d2, str_HOMEPALS4, str_AWAYPALS, str_Rinkpal, str_Pal30, str_Gready, str_Gready2, str_Gglover
global str_Gglovel, str_Gglovel2, str_Gstickr, str_Gstickl, str_Gstackr, str_Gstackl, str_Gdive, str_Gswing
global str_Gskate, str_Pflip, str_Glide, str_Skatewp, str_Skate, str_Turnl, str_Turnr, str_Stop
global str_Passf, str_Passb, str_Shotf, str_Shotb, str_Glideback, str_Skateback, str_Sweepchk, str_Shoulderchkl
global str_Shoulderchkr, str_Hipchkl, str_Hipchkr, str_Burst, str_Hold, str_Hold2, str_Flail, str_Fallfwd
global str_Fallback, str_Celebrate, str_Pump, str_Wallright, str_Wallleft, str_Faceoff, str_Faceoffr, str_Siren
global str_Bglass, str_Stanley2, str_Catch, str_Hook, str_Hook2, str_Stumble, str_Fake, str_Flip
global str_Injury1, str_Refglide, str_Refskate, str_Refturnl, str_Refturnr, str_Refstop, str_Reffallback, str_Armupglide
global str_Armupskate, str_Armupturnl, str_Armupturnr, str_Armupstop, str_Refpickup, str_Refpointgoa, str_Refdrop, str_Reffowait
global str_Refrough, str_Refcharge, str_Refslash, str_Refxcheck, str_Refhook, str_Reftrip, str_Refinterfer, str_Refhold
global str_Refabuseoff, str_Refbehind, str_Faceoffpoke, str_Gwallright, str_Gwallleft, str_Anthem1, str_Anthem2, str_Anthem3
global str_Anthem4, str_Anthem5, str_Drink, str_Refanthem1, str_Refanthem2, str_Onetimef, str_Onetimeb, str_Getcup
global str_Brcup, str_Gvcup, str_Clap, str_Stansk, str_Crosscheck, str_Boardback, str_Boardfront, str_Boardright
global str_Boardleft, str_Benchcheckr, str_Benchcheckl, str_Refpenshot, str_Goaliepoke, str_Goalieknee, str_Gokneehold, str_Gofallback
global str_Gofallglove, str_Gofallstick, str_Fakeshotf, str_Fakeshotb, str_Fakeonetimef, str_Fakeonetimeb, str_Blockleft, str_Blockright
global str_Blockfront, str_Blockknee, str_Refelbow, str_Refhistick, str_ERROR, str_Null, str_Defo, str_Defd
global str_Wingd, str_Wingo, str_Centd, str_Cento, str_Score, str_Stan, str_Exben, str_Expen
global str_Bench
str_04d2:                                       ; string '%04d'; used by LoadTeamPPV
        db 025h,030h,034h,064h,00h,00h
str_HOMEPALS4:                                  ; string 'HOMEPALS'; used by LoadTeamPalette
        db 048h,04Fh,04Dh,045h,050h,041h,04Ch,053h,00h
str_AWAYPALS:                                   ; string 'AWAYPALS'; used by LoadTeamPalette
        db 041h,057h,041h,059h,050h,041h,04Ch,053h,00h
str_Rinkpal:                                    ; string 'rinkpal'; used by LoadTeamPalette
        db 072h,069h,06Eh,06Bh,070h,061h,06Ch,00h
str_Pal30:                                      ; string '!pal'; used by LoadTeamPalette
        db 021h,070h,061h,06Ch,00h,00h
str_Gready:                                     ; "gready" string literal
        db 067h,072h,065h,061h,064h,079h,00h
str_Gready2:                                    ; "gready2" string literal
        db 067h,072h,065h,061h,064h,079h,032h,00h
str_Gglover:                                    ; "gglover" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,072h,00h
str_Gglovel:                                    ; "gglovel" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,00h
str_Gglovel2:                                   ; "gglovel2" string literal
        db 067h,067h,06Ch,06Fh,076h,065h,06Ch,032h,00h
str_Gstickr:                                    ; "gstickr" string literal
        db 067h,073h,074h,069h,063h,06Bh,072h,00h
str_Gstickl:                                    ; "gstickl" string literal
        db 067h,073h,074h,069h,063h,06Bh,06Ch,00h
str_Gstackr:                                    ; "gstackr" string literal
        db 067h,073h,074h,061h,063h,06Bh,072h,00h
str_Gstackl:                                    ; "gstackl" string literal
        db 067h,073h,074h,061h,063h,06Bh,06Ch,00h
str_Gdive:                                      ; "gdive" string literal
        db 067h,064h,069h,076h,065h,00h
str_Gswing:                                     ; "gswing" string literal
        db 067h,073h,077h,069h,06Eh,067h,00h
str_Gskate:                                     ; "gskate" string literal
        db 067h,073h,06Bh,061h,074h,065h,00h
str_Pflip:                                      ; "pflip" string literal
        db 070h,066h,06Ch,069h,070h,00h
str_Glide:                                      ; "glide" string literal
        db 067h,06Ch,069h,064h,065h,00h
str_Skatewp:                                    ; "skatewp" string literal
        db 073h,06Bh,061h,074h,065h,077h,070h,00h
str_Skate:                                      ; "skate" string literal
        db 073h,06Bh,061h,074h,065h,00h
str_Turnl:                                      ; "turnl" string literal
        db 074h,075h,072h,06Eh,06Ch,00h
str_Turnr:                                      ; "turnr" string literal
        db 074h,075h,072h,06Eh,072h,00h
str_Stop:                                       ; "stop" string literal
        db 073h,074h,06Fh,070h,00h
str_Passf:                                      ; "passf" string literal
        db 070h,061h,073h,073h,066h,00h
str_Passb:                                      ; "passb" string literal
        db 070h,061h,073h,073h,062h,00h
str_Shotf:                                      ; "shotf" string literal
        db 073h,068h,06Fh,074h,066h,00h
str_Shotb:                                      ; "shotb" string literal
        db 073h,068h,06Fh,074h,062h,00h
str_Glideback:                                  ; "glideback" string literal
        db 067h,06Ch,069h,064h,065h,062h,061h,063h,06Bh,00h
str_Skateback:                                  ; "skateback" string literal
        db 073h,06Bh,061h,074h,065h,062h,061h,063h,06Bh,00h
str_Sweepchk:                                   ; "sweepchk" string literal
        db 073h,077h,065h,065h,070h,063h,068h,06Bh,00h
str_Shoulderchkl:                               ; "shoulderchkl" string literal
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,06Ch,00h
str_Shoulderchkr:                               ; "shoulderchkr" string literal
        db 073h,068h,06Fh,075h,06Ch,064h,065h,072h,063h,068h,06Bh,072h,00h
str_Hipchkl:                                    ; "hipchkl" string literal
        db 068h,069h,070h,063h,068h,06Bh,06Ch,00h
str_Hipchkr:                                    ; "hipchkr" string literal
        db 068h,069h,070h,063h,068h,06Bh,072h,00h
str_Burst:                                      ; "burst" string literal
        db 062h,075h,072h,073h,074h,00h
str_Hold:                                       ; "hold" string literal
        db 068h,06Fh,06Ch,064h,00h
str_Hold2:                                      ; "hold2" string literal
        db 068h,06Fh,06Ch,064h,032h,00h
str_Flail:                                      ; "flail" string literal
        db 066h,06Ch,061h,069h,06Ch,00h
str_Fallfwd:                                    ; "fallfwd" string literal
        db 066h,061h,06Ch,06Ch,066h,077h,064h,00h
str_Fallback:                                   ; "fallback" string literal
        db 066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Celebrate:                                  ; "celebrate" string literal
        db 063h,065h,06Ch,065h,062h,072h,061h,074h,065h,00h
str_Pump:                                       ; "pump" string literal
        db 070h,075h,06Dh,070h,00h
str_Wallright:                                  ; "wallright" string literal
        db 077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Wallleft:                                   ; "wallleft" string literal
        db 077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Faceoff:                                    ; "faceoff" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,00h
str_Faceoffr:                                   ; "faceoffr" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,072h,00h
str_Siren:                                      ; "siren" string literal
        db 073h,069h,072h,065h,06Eh,00h
str_Bglass:                                     ; "bglass" string literal
        db 062h,067h,06Ch,061h,073h,073h,00h
str_Stanley2:                                   ; "stanley" string literal
        db 073h,074h,061h,06Eh,06Ch,065h,079h,00h
str_Catch:                                      ; "catch" string literal
        db 063h,061h,074h,063h,068h,00h
str_Hook:                                       ; "hook" string literal
        db 068h,06Fh,06Fh,06Bh,00h
str_Hook2:                                      ; "hook2" string literal
        db 068h,06Fh,06Fh,06Bh,032h,00h
str_Stumble:                                    ; "stumble" string literal
        db 073h,074h,075h,06Dh,062h,06Ch,065h,00h
str_Fake:                                       ; "fake" string literal
        db 066h,061h,06Bh,065h,00h
str_Flip:                                       ; "flip" string literal
        db 066h,06Ch,069h,070h,00h
str_Injury1:                                    ; "injury1" string literal
        db 069h,06Eh,06Ah,075h,072h,079h,031h,00h
str_Refglide:                                   ; "refglide" string literal
        db 072h,065h,066h,067h,06Ch,069h,064h,065h,00h
str_Refskate:                                   ; "refskate" string literal
        db 072h,065h,066h,073h,06Bh,061h,074h,065h,00h
str_Refturnl:                                   ; "refturnl" string literal
        db 072h,065h,066h,074h,075h,072h,06Eh,06Ch,00h
str_Refturnr:                                   ; "refturnr" string literal
        db 072h,065h,066h,074h,075h,072h,06Eh,072h,00h
str_Refstop:                                    ; "refstop" string literal
        db 072h,065h,066h,073h,074h,06Fh,070h,00h
str_Reffallback:                                ; "reffallback" string literal
        db 072h,065h,066h,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Armupglide:                                 ; "armupglide" string literal
        db 061h,072h,06Dh,075h,070h,067h,06Ch,069h,064h,065h,00h
str_Armupskate:                                 ; "armupskate" string literal
        db 061h,072h,06Dh,075h,070h,073h,06Bh,061h,074h,065h,00h
str_Armupturnl:                                 ; "armupturnl" string literal
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,06Ch,00h
str_Armupturnr:                                 ; "armupturnr" string literal
        db 061h,072h,06Dh,075h,070h,074h,075h,072h,06Eh,072h,00h
str_Armupstop:                                  ; "armupstop" string literal
        db 061h,072h,06Dh,075h,070h,073h,074h,06Fh,070h,00h
str_Refpickup:                                  ; "refpickup" string literal
        db 072h,065h,066h,070h,069h,063h,06Bh,075h,070h,00h
str_Refpointgoa:                                ; "refpointgoa" string literal
        db 072h,065h,066h,070h,06Fh,069h,06Eh,074h,067h,06Fh,061h,00h
str_Refdrop:                                    ; "refdrop" string literal
        db 072h,065h,066h,064h,072h,06Fh,070h,00h
str_Reffowait:                                  ; "reffowait" string literal
        db 072h,065h,066h,066h,06Fh,077h,061h,069h,074h,00h
str_Refrough:                                   ; "refrough" string literal
        db 072h,065h,066h,072h,06Fh,075h,067h,068h,00h
str_Refcharge:                                  ; "refcharge" string literal
        db 072h,065h,066h,063h,068h,061h,072h,067h,065h,00h
str_Refslash:                                   ; "refslash" string literal
        db 072h,065h,066h,073h,06Ch,061h,073h,068h,00h
str_Refxcheck:                                  ; "refxcheck" string literal
        db 072h,065h,066h,078h,063h,068h,065h,063h,06Bh,00h
str_Refhook:                                    ; "refhook" string literal
        db 072h,065h,066h,068h,06Fh,06Fh,06Bh,00h
str_Reftrip:                                    ; "reftrip" string literal
        db 072h,065h,066h,074h,072h,069h,070h,00h
str_Refinterfer:                                ; "refinterfer" string literal
        db 072h,065h,066h,069h,06Eh,074h,065h,072h,066h,065h,072h,00h
str_Refhold:                                    ; "refhold" string literal
        db 072h,065h,066h,068h,06Fh,06Ch,064h,00h
str_Refabuseoff:                                ; "refabuseoff" string literal
        db 072h,065h,066h,061h,062h,075h,073h,065h,06Fh,066h,066h,00h
str_Refbehind:                                  ; "refbehind" string literal
        db 072h,065h,066h,062h,065h,068h,069h,06Eh,064h,00h
str_Faceoffpoke:                                ; "faceoffpoke" string literal
        db 066h,061h,063h,065h,06Fh,066h,066h,070h,06Fh,06Bh,065h,00h
str_Gwallright:                                 ; "gwallright" string literal
        db 067h,077h,061h,06Ch,06Ch,072h,069h,067h,068h,074h,00h
str_Gwallleft:                                  ; "gwallleft" string literal
        db 067h,077h,061h,06Ch,06Ch,06Ch,065h,066h,074h,00h
str_Anthem1:                                    ; "anthem1" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Anthem2:                                    ; "anthem2" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Anthem3:                                    ; "anthem3" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,033h,00h
str_Anthem4:                                    ; "anthem4" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,034h,00h
str_Anthem5:                                    ; "anthem5" string literal
        db 061h,06Eh,074h,068h,065h,06Dh,035h,00h
str_Drink:                                      ; "drink" string literal
        db 064h,072h,069h,06Eh,06Bh,00h
str_Refanthem1:                                 ; "refanthem1" string literal
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,031h,00h
str_Refanthem2:                                 ; "refanthem2" string literal
        db 072h,065h,066h,061h,06Eh,074h,068h,065h,06Dh,032h,00h
str_Onetimef:                                   ; "onetimef" string literal
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Onetimeb:                                   ; "onetimeb" string literal
        db 06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Getcup:                                     ; "getcup" string literal
        db 067h,065h,074h,063h,075h,070h,00h
str_Brcup:                                      ; "brcup" string literal
        db 062h,072h,063h,075h,070h,00h
str_Gvcup:                                      ; "gvcup" string literal
        db 067h,076h,063h,075h,070h,00h
str_Clap:                                       ; "clap" string literal
        db 063h,06Ch,061h,070h,00h
str_Stansk:                                     ; "stansk" string literal
        db 073h,074h,061h,06Eh,073h,06Bh,00h
str_Crosscheck:                                 ; "crosscheck" string literal
        db 063h,072h,06Fh,073h,073h,063h,068h,065h,063h,06Bh,00h
str_Boardback:                                  ; "boardback" string literal
        db 062h,06Fh,061h,072h,064h,062h,061h,063h,06Bh,00h
str_Boardfront:                                 ; "boardfront" string literal
        db 062h,06Fh,061h,072h,064h,066h,072h,06Fh,06Eh,074h,00h
str_Boardright:                                 ; "boardright" string literal
        db 062h,06Fh,061h,072h,064h,072h,069h,067h,068h,074h,00h
str_Boardleft:                                  ; "boardleft" string literal
        db 062h,06Fh,061h,072h,064h,06Ch,065h,066h,074h,00h
str_Benchcheckr:                                ; "benchcheckr" string literal
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,072h,00h
str_Benchcheckl:                                ; "benchcheckl" string literal
        db 062h,065h,06Eh,063h,068h,063h,068h,065h,063h,06Bh,06Ch,00h
str_Refpenshot:                                 ; "refpenshot" string literal
        db 072h,065h,066h,070h,065h,06Eh,073h,068h,06Fh,074h,00h
str_Goaliepoke:                                 ; "goaliepoke" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,070h,06Fh,06Bh,065h,00h
str_Goalieknee:                                 ; "goalieknee" string literal
        db 067h,06Fh,061h,06Ch,069h,065h,06Bh,06Eh,065h,065h,00h
str_Gokneehold:                                 ; "gokneehold" string literal
        db 067h,06Fh,06Bh,06Eh,065h,065h,068h,06Fh,06Ch,064h,00h
str_Gofallback:                                 ; "gofallback" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,062h,061h,063h,06Bh,00h
str_Gofallglove:                                ; "gofallglove" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,067h,06Ch,06Fh,076h,065h,00h
str_Gofallstick:                                ; "gofallstick" string literal
        db 067h,06Fh,066h,061h,06Ch,06Ch,073h,074h,069h,063h,06Bh,00h
str_Fakeshotf:                                  ; "fakeshotf" string literal
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,066h,00h
str_Fakeshotb:                                  ; "fakeshotb" string literal
        db 066h,061h,06Bh,065h,073h,068h,06Fh,074h,062h,00h
str_Fakeonetimef:                               ; "fakeonetimef" string literal
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,066h,00h
str_Fakeonetimeb:                               ; "fakeonetimeb" string literal
        db 066h,061h,06Bh,065h,06Fh,06Eh,065h,074h,069h,06Dh,065h,062h,00h
str_Blockleft:                                  ; "blockleft" string literal
        db 062h,06Ch,06Fh,063h,06Bh,06Ch,065h,066h,074h,00h
str_Blockright:                                 ; "blockright" string literal
        db 062h,06Ch,06Fh,063h,06Bh,072h,069h,067h,068h,074h,00h
str_Blockfront:                                 ; "blockfront" string literal
        db 062h,06Ch,06Fh,063h,06Bh,066h,072h,06Fh,06Eh,074h,00h
str_Blockknee:                                  ; "blockknee" string literal
        db 062h,06Ch,06Fh,063h,06Bh,06Bh,06Eh,065h,065h,00h
str_Refelbow:                                   ; "refelbow" string literal
        db 072h,065h,066h,065h,06Ch,062h,06Fh,077h,00h
str_Refhistick:                                 ; "refhistick" string literal
        db 072h,065h,066h,068h,069h,073h,074h,069h,063h,06Bh,00h
str_ERROR:                                      ; "ERROR" string literal
        db 045h,052h,052h,04Fh,052h,00h
str_Null:                                       ; "null" string literal
        db 06Eh,075h,06Ch,06Ch,00h
str_Defo:                                       ; "defo" string literal
        db 064h,065h,066h,06Fh,00h
str_Defd:                                       ; "defd" string literal
        db 064h,065h,066h,064h,00h
str_Wingd:                                      ; "wingd" string literal
        db 077h,069h,06Eh,067h,064h,00h
str_Wingo:                                      ; "wingo" string literal
        db 077h,069h,06Eh,067h,06Fh,00h
str_Centd:                                      ; "centd" string literal
        db 063h,065h,06Eh,074h,064h,00h
str_Cento:                                      ; "cento" string literal
        db 063h,065h,06Eh,074h,06Fh,00h
str_Score:                                      ; "score" string literal
        db 073h,063h,06Fh,072h,065h,00h
str_Stan:                                       ; "stan" string literal
        db 073h,074h,061h,06Eh,00h
str_Exben:                                      ; "exben" string literal
        db 065h,078h,062h,065h,06Eh,00h
str_Expen:                                      ; "expen" string literal
        db 065h,078h,070h,065h,06Eh,00h
str_Bench:                                      ; "bench" string literal
        db 062h,065h,06Eh,063h,068h,00h
