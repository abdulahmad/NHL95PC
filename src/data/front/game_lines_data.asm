; Initialised data of front/game_lines (src/front/game_lines).
bits 32
%include "hockey.inc"
section s_D11BC progbits alloc noexec write align=1
global TeamJerseyBase, fadestart, fadestep, fadeend, fadestart2, fadestep2, fadeend2, jerseyremap
global jerseyremapteam, jerseyremaptrim, jerseypalslot0, jerseypalslot1, jerseypalslot2, jerseypalslot3, lineslotx, linesloty
global LineEdPairX, LineEdPairY, LineEdFiveX, LineEdFiveY, LineEdFourX, LineEdFourY, LineEdExtraX, LineEdExtraY
global LineEdGoalieX, LineEdGoalieY, jerseydigits
TeamJerseyBase:                                 ; Palette index of each team's jersey base colour (dword per
                                                ; team); used by DbLineEditorLoop, DrawGameLineJerseys,
                                                ; DrawLineJerseys ...
        db 0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h,0B0h,00h,00h,00h
        db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
        db 0A2h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h,0AAh,00h,00h,00h
        db 0AAh,00h,00h,00h,090h,00h,00h,00h,090h,00h,00h,00h,0ADh,00h,00h,00h
        db 0B0h,00h,00h,00h,0ACh,00h,00h,00h,0ADh,00h,00h,00h,0AEh,00h,00h,00h
        db 0AAh,00h,00h,00h,0B0h,00h,00h,00h,0ADh,00h,00h,00h,0ADh,00h,00h,00h
        db 0AAh,00h,00h,00h,0AAh,00h,00h,00h,0BCh,00h,00h,00h,09Ch
        db 00h,00h
        db 00h
fadestart:                                      ; FadePalStep start value per direction (word table indexed by
                                                ; edi; [0]+1 patched to steps-1); used by FadePalStep
        db 01h
        db 0Fh
fadestep:                                       ; FadePalStep step per direction (+1/-1); used by FadePalStep
        db 01h
        db 0FFh
fadeend:                                        ; FadePalStep end value per direction (word table, [edi]
                                                ; index; [1] patched to steps+1); used by FadePalStep
        db 011h
        db 0FFh
fadestart2:                                     ; FadePalStepSlow start value per direction; used by
                                                ; FadePalStepSlow
        db 01h
        db 0Fh
fadestep2:                                      ; FadePalStepSlow step per direction; used by FadePalStepSlow
        db 01h,0FFh
fadeend2:                                       ; FadePalStepSlow end value per direction; used by
                                                ; FadePalStepSlow
        db 011h,0FFh
jerseyremap:                                    ; 256-byte palette remap table (identity init) filled per team
                                                ; and passed to MakeJerseyShape / SetColorRemap by the line
                                                ; editors and trade screen; used by DbLineEditorLoop,
                                                ; DrawGameLineJerseys, DrawLineJerseys ...
        db 00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch,0Dh,0Eh,0Fh
        db 010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch,01Dh,01Eh,01Fh
        db 020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02Ah,02Bh,02Ch,02Dh,02Eh,02Fh
        db 030h,031h,032h,033h,034h,035h,036h,037h,038h,039h,03Ah,03Bh,03Ch,03Dh,03Eh,03Fh
        db 040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04Ah,04Bh,04Ch,04Dh,04Eh,04Fh
        db 050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05Ah,05Bh,05Ch,05Dh,05Eh,05Fh
        db 060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06Ah,06Bh,06Ch,06Dh,06Eh,06Fh
        db 070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07Ah,07Bh,07Ch,07Dh,07Eh,07Fh
        db 080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08Ah,08Bh,08Ch,08Dh,08Eh,08Fh
jerseyremapteam:                                ; Team colour part of jerseyremap (entries 90h to BFh); used
                                                ; by DrawTradeScreen, TradeScreenLoop
        db 090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09Ah,09Bh,09Ch,09Dh,09Eh,09Fh
        db 0A0h,0A1h,0A2h,0A3h,0A4h,0A5h
jerseyremaptrim:                                ; jerseyremap entry A6h: the trim colour the line editors
                                                ; read; used by DbLineEditorLoop, DrawGameLineJerseys,
                                                ; DrawLineJerseys ...
        db 0A6h,0A7h,0A8h,0A9h,0AAh,0ABh,0ACh,0ADh,0AEh,0AFh,0B0h,0B1h,0B2h,0B3h,0B4h,0B5h
        db 0B6h,0B7h,0B8h,0B9h,0BAh,0BBh,0BCh,0BDh,0BEh,0BFh,0C0h,0C1h,0C2h,0C3h,0C4h,0C5h
        db 0C6h,0C7h,0C8h,0C9h,0CAh,0CBh,0CCh,0CDh,0CEh,0CFh,0D0h,0D1h,0D2h,0D3h,0D4h,0D5h
        db 0D6h,0D7h,0D8h,0D9h,0DAh,0DBh,0DCh,0DDh,0DEh,0DFh,0E0h,0E1h,0E2h,0E3h,0E4h,0E5h
        db 0E6h,0E7h,0E8h,0E9h,0EAh,0EBh,0ECh,0EDh,0EEh,0EFh,0F0h,0F1h,0F2h,0F3h,0F4h,0F5h
        db 0F6h,0F7h,0F8h,0F9h,0FAh
jerseypalslot0:                                 ; first of four palette slots the jersey shapes use (FBh game
                                                ; lines, 7Bh trade); used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FBh
jerseypalslot1:                                 ; second jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FCh
jerseypalslot2:                                 ; third jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FDh
jerseypalslot3:                                 ; fourth jersey palette slot; used by LoadJerseyColours,
                                                ; LoadTradeTeamPals
        db 0FEh,0FFh
lineslotx:                                      ; [40] line slot x (8-byte x, y pairs); used by
                                                ; DbLineEditorLoop, DrawGameLineJerseys, DrawLineJerseys ...
        db 047h,00h,00h,00h
linesloty:                                      ; [40] line slot y; used by DbLineEditorLoop,
                                                ; DrawGameLineJerseys, DrawLineJerseys ...
        db 028h,00h,00h,00h,083h,00h,00h,00h,028h,00h,00h,00h,0BFh,00h,00h,00h
        db 028h,00h,00h,00h,047h,00h,00h,00h,059h,00h,00h,00h,083h,00h,00h,00h
        db 059h,00h,00h,00h,0BFh,00h,00h,00h,059h,00h,00h,00h,047h,00h,00h,00h
        db 08Ah,00h,00h,00h,083h,00h,00h,00h,08Ah,00h,00h,00h,0BFh,00h,00h,00h
        db 08Ah,00h,00h,00h,047h,00h,00h,00h,0BBh,00h,00h,00h,083h,00h,00h,00h
        db 0BBh,00h,00h,00h,0BFh,00h,00h,00h,0BBh,00h,00h,00h
LineEdPairX:                                    ; Line editor jersey X for the two-slot rows (two per page);
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 056h,01h,00h,00h
LineEdPairY:                                    ; Line editor jersey Y for the two-slot rows; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 028h,00h,00h,00h,092h,01h,00h,00h,028h,00h,00h,00h,056h,01h,00h,00h
        db 059h,00h,00h,00h,092h,01h,00h,00h,059h,00h,00h,00h,056h,01h,00h,00h
        db 08Ah,00h,00h,00h,092h,01h,00h,00h,08Ah,00h,00h,00h
LineEdFiveX:                                    ; Line editor jersey X for the five-player lines; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 047h,00h,00h,00h
LineEdFiveY:                                    ; Line editor jersey Y for the five-player lines; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 0F6h,00h,00h,00h,083h,00h,00h,00h,0F6h,00h,00h,00h,0BFh,00h,00h,00h
        db 0F6h,00h,00h,00h,0FBh,00h,00h,00h,0F6h,00h,00h,00h,037h,01h,00h,00h
        db 0F6h,00h,00h,00h,047h,00h,00h,00h,027h,01h,00h,00h,083h,00h,00h,00h
        db 027h,01h,00h,00h,0BFh,00h,00h,00h,027h,01h,00h,00h,0FBh,00h,00h,00h
        db 027h,01h,00h,00h,037h,01h,00h,00h,027h,01h,00h,00h
LineEdFourX:                                    ; Line editor jersey X for the four-player units; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 047h,00h,00h,00h
LineEdFourY:                                    ; Line editor jersey Y for the four-player units; used by
                                                ; DbLineEditorLoop, GameLineEditorLoop
        db 062h,01h,00h,00h,083h,00h,00h,00h,062h,01h,00h,00h,0BFh,00h,00h,00h
        db 062h,01h,00h,00h,0FBh,00h,00h,00h,062h,01h,00h,00h,047h,00h,00h,00h
        db 093h,01h,00h,00h,083h,00h,00h,00h,093h,01h,00h,00h,0BFh,00h,00h,00h
        db 093h,01h,00h,00h,0FBh,00h,00h,00h,093h,01h,00h,00h
LineEdExtraX:                                   ; Line editor jersey X for the first fixed pair of slots; used
                                                ; by DbLineEditorLoop, GameLineEditorLoop
        db 099h,01h,00h,00h
LineEdExtraY:                                   ; Line editor jersey Y for the first fixed pair of slots; used
                                                ; by DbLineEditorLoop, GameLineEditorLoop
        db 0F5h,00h,00h,00h,099h,01h,00h,00h,022h,01h,00h,00h
LineEdGoalieX:                                  ; Line editor jersey X for the second fixed pair of slots;
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 063h,01h,00h,00h
LineEdGoalieY:                                  ; Line editor jersey Y for the second fixed pair of slots;
                                                ; used by DbLineEditorLoop, GameLineEditorLoop
        db 093h,01h,00h,00h,09Fh,01h,00h,00h,093h,01h,00h,00h
jerseydigits:                                   ; 1-bit digit glyphs (0Ch bytes each); used by BlitJerseyDigit
        db 0FEh,0F7h,0FFh,01h,018h,080h,01h,0F8h,0FFh,0FEh,07h,00h,00h,00h,00h,02h
        db 0F8h,0FFh,0FFh,0Fh,080h,00h,00h,00h,06h,07Fh,0F8h,0C1h,019h,08Eh,071h,0F8h
        db 0C3h,01Eh,0Ch,00h,06h,076h,0E0h,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h
        db 0F0h,080h,0Fh,0CCh,060h,0Ch,0C3h,0FFh,0FFh,0C0h,00h,00h,03Fh,0F6h,0E3h,031h
        db 018h,083h,031h,038h,0FFh,0C3h,07h,00h,0FEh,0F7h,0FFh,061h,018h,086h,061h,078h
        db 0FEh,086h,07h,00h,07h,070h,00h,01h,01Eh,0FEh,0FDh,0F3h,03h,07h,00h,00h
        db 09Eh,0F7h,0FFh,061h,018h,086h,061h,0F8h,0FFh,09Eh,07h,00h,01Eh,0F6h,0E7h,061h
        db 018h,086h,061h,0F8h,0FFh,0FEh,07h,00h
