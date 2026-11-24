; Sprite animation tables: SPAtab and one sequence per animation, in SPA number order.
; The high byte of the last sequence's final time is priolist_m1 in data/engine/game_state.asm.
bits 32
%include "hockey.inc"
section s_C921D progbits alloc noexec write align=1
global SPAtab
SPAtab:                                         ; the SPA table, used by updateanim: a word 0, then each sequence (flags and 7 direction offsets, then frame/time pairs); a sequence number is its byte offset / 2
        db 00h,00h
SPAgready:                                        ; SPA number 0x1
        db 00h,080h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h,07Eh,00h
        db 096h,01h,0B4h,00h,01Ah,02h,0Ah,00h,01Bh,02h,0Ah,00h,01Ah,02h,0Ah,00h
        db 01Bh,02h,0Ah,00h,096h,01h,0F0h,00h,01Ah,02h,0Ah,00h,01Bh,02h,0Ah,00h
        db 01Ah,02h,0F6h,0FFh,099h,01h,082h,00h,01Ch,02h,0Ah,00h,01Dh,02h,0Ah,00h
        db 01Ch,02h,0Ah,00h,01Dh,02h,0Ah,00h,099h,01h,02Ch,01h,01Ch,02h,0Ah,00h
        db 01Dh,02h,0Ah,00h,01Ch,02h,0F6h,0FFh,09Ch,01h,0D2h,00h,01Eh,02h,0Ah,00h
        db 01Fh,02h,0Ah,00h,01Eh,02h,0Ah,00h,01Fh,02h,0Ah,00h,09Ch,01h,078h,00h
        db 01Eh,02h,0Ah,00h,01Fh,02h,0Ah,00h,01Eh,02h,0F6h,0FFh,09Fh,01h,064h,00h
        db 020h,02h,0Ah,00h,021h,02h,0Ah,00h,020h,02h,0Ah,00h,021h,02h,0Ah,00h
        db 09Fh,01h,0C8h,00h,020h,02h,0Ah,00h,021h,02h,0Ah,00h,020h,02h,0F6h,0FFh
        db 0A2h,01h,0F0h,00h,022h,02h,0Ah,00h,023h,02h,0Ah,00h,022h,02h,0Ah,00h
        db 023h,02h,0Ah,00h,0A2h,01h,03Ch,00h,022h,02h,0Ah,00h,023h,02h,0Ah,00h
        db 022h,02h,0F6h,0FFh,0A5h,01h,0B4h,00h,024h,02h,0Ah,00h,025h,02h,0Ah,00h
        db 024h,02h,0Ah,00h,025h,02h,0Ah,00h,0A5h,01h,0F0h,00h,024h,02h,0Ah,00h
        db 025h,02h,0Ah,00h,024h,02h,0F6h,0FFh,0A8h,01h,078h,00h,026h,02h,0Ah,00h
        db 027h,02h,0Ah,00h,026h,02h,0Ah,00h,027h,02h,0Ah,00h,0A8h,01h,078h,00h
        db 026h,02h,0Ah,00h,027h,02h,0Ah,00h,026h,02h,0F6h,0FFh,0ABh,01h,0B4h,00h
        db 028h,02h,0Ah,00h,029h,02h,0Ah,00h,028h,02h,0Ah,00h,029h,02h,0Ah,00h
        db 0ABh,01h,0B4h,00h,028h,02h,0Ah,00h,029h,02h,0Ah,00h,028h,02h,0F6h,0FFh
SPAgready2:                                        ; SPA number 0x99
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 096h,01h,0E2h,0FFh,099h,01h,0E2h,0FFh,09Ch,01h,0E2h,0FFh,09Fh,01h,0E2h,0FFh
        db 0A2h,01h,0E2h,0FFh,0A5h,01h,0E2h,0FFh,0A8h,01h,0E2h,0FFh,0ABh,01h,0E2h,0FFh
SPAgglover:                                        ; SPA number 0xB1
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 097h,01h,0E0h,0FFh,09Ah,01h,0E0h,0FFh,09Dh,01h,0E0h,0FFh,0A0h,01h,0E0h,0FFh
        db 0A3h,01h,0E0h,0FFh,0A6h,01h,0E0h,0FFh,0A9h,01h,0E0h,0FFh,0ACh,01h,0E0h,0FFh
SPAgglovel:                                        ; SPA number 0xC9
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 098h,01h,0E0h,0FFh,09Bh,01h,0E0h,0FFh,09Eh,01h,0E0h,0FFh,0A1h,01h,0E0h,0FFh
        db 0A4h,01h,0E0h,0FFh,0A7h,01h,0E0h,0FFh,0AAh,01h,0E0h,0FFh,0ADh,01h,0E0h,0FFh
SPAgglovel2:                                        ; SPA number 0xE1
        db 00h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,012h,00h,014h,00h,016h,00h
        db 016h,02h,04h,00h,017h,02h,08h,00h,016h,02h,0FCh,0FFh,09Bh,01h,0E0h,0FFh
        db 09Eh,01h,0E0h,0FFh,0A1h,01h,0E0h,0FFh,018h,02h,04h,00h,019h,02h,08h,00h
        db 018h,02h,0FCh,0FFh,0A7h,01h,0E0h,0FFh,0AAh,01h,0E0h,0FFh,0ADh,01h,0E0h,0FFh
SPAgstickr:                                        ; SPA number 0x101
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0D6h,01h,0E0h,0FFh,0D8h,01h,0E0h,0FFh,0DAh,01h,0E0h,0FFh,0DCh,01h,0E0h,0FFh
        db 0DEh,01h,0E0h,0FFh,0E0h,01h,0E0h,0FFh,0E2h,01h,0E0h,0FFh,0E4h,01h,0E0h,0FFh
SPAgstickl:                                        ; SPA number 0x119
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0D7h,01h,0E0h,0FFh,0D9h,01h,0E0h,0FFh,0DBh,01h,0E0h,0FFh,0DDh,01h,0E0h,0FFh
        db 0DFh,01h,0E0h,0FFh,0E1h,01h,0E0h,0FFh,0E3h,01h,0E0h,0FFh,0E5h,01h,0E0h,0FFh
SPAgstackr:                                        ; SPA number 0x131
        db 00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 0BEh,01h,08h,00h,0BFh,01h,0E0h,0FFh,0C0h,01h,08h,00h,0C1h,01h,0E0h,0FFh
        db 0C0h,01h,08h,00h,0C1h,01h,0E0h,0FFh,0C2h,01h,08h,00h,0C3h,01h,0E0h,0FFh
        db 0C4h,01h,08h,00h,0C5h,01h,0E0h,0FFh,0C6h,01h,08h,00h,0C7h,01h,0E0h,0FFh
        db 0C6h,01h,08h,00h,0C7h,01h,0E0h,0FFh,0C8h,01h,08h,00h,0C9h,01h,0E0h,0FFh
SPAgstackl:                                        ; SPA number 0x159
        db 00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 0CAh,01h,08h,00h,0CBh,01h,0E0h,0FFh,0CCh,01h,08h,00h,0CDh,01h,0E0h,0FFh
        db 0CCh,01h,08h,00h,0CDh,01h,0E0h,0FFh,0CEh,01h,08h,00h,0CFh,01h,0E0h,0FFh
        db 0D0h,01h,08h,00h,0D1h,01h,0E0h,0FFh,0D2h,01h,08h,00h,0D3h,01h,0E0h,0FFh
        db 0D2h,01h,08h,00h,0D3h,01h,0E0h,0FFh,0D4h,01h,08h,00h,0D5h,01h,0E0h,0FFh
SPAgdive:                                        ; SPA number 0x181
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 06h,02h,08h,00h,07h,02h,030h,00h,06h,02h,0F8h,0FFh,08h,02h,08h,00h
        db 09h,02h,030h,00h,08h,02h,0F8h,0FFh,0Ah,02h,08h,00h,0Bh,02h,030h,00h
        db 0Ah,02h,0F8h,0FFh,0Ch,02h,08h,00h,0Dh,02h,030h,00h,0Ch,02h,0F8h,0FFh
        db 0Eh,02h,08h,00h,0Fh,02h,030h,00h,0Eh,02h,0F8h,0FFh,010h,02h,08h,00h
        db 011h,02h,030h,00h,010h,02h,0F8h,0FFh,012h,02h,08h,00h,013h,02h,030h,00h
        db 012h,02h,0F8h,0FFh,014h,02h,08h,00h,015h,02h,030h,00h,014h,02h,0F8h,0FFh
SPAgswing:                                        ; SPA number 0x1B9
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 0AEh,01h,05h,00h,0AFh,01h,08h,00h,0AEh,01h,0F0h,0FFh,0B0h,01h,05h,00h
        db 0B1h,01h,08h,00h,0B0h,01h,0F0h,0FFh,0B2h,01h,05h,00h,0B3h,01h,08h,00h
        db 0B2h,01h,0F0h,0FFh,0B4h,01h,05h,00h,0B5h,01h,08h,00h,0B4h,01h,0F0h,0FFh
        db 0B6h,01h,05h,00h,0B7h,01h,08h,00h,0B6h,01h,0F0h,0FFh,0B8h,01h,05h,00h
        db 0B9h,01h,08h,00h,0B8h,01h,0F0h,0FFh,0BAh,01h,05h,00h,0BBh,01h,08h,00h
        db 0BAh,01h,0F0h,0FFh,0BCh,01h,05h,00h,0BDh,01h,08h,00h,0BCh,01h,0F0h,0FFh
SPAgskate:                                        ; SPA number 0x1F1
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 0E6h,01h,0Ah,00h,0E7h,01h,0Ah,00h,0E8h,01h,0Ah,00h,0E9h,01h,0F1h,0FFh
        db 0EAh,01h,0Ah,00h,0EBh,01h,0Ah,00h,0ECh,01h,0Ah,00h,0EDh,01h,0F1h,0FFh
        db 0EEh,01h,0Ah,00h,0EFh,01h,0Ah,00h,0F0h,01h,0Ah,00h,0F1h,01h,0F1h,0FFh
        db 0F2h,01h,0Ah,00h,0F3h,01h,0Ah,00h,0F4h,01h,0Ah,00h,0F5h,01h,0F1h,0FFh
        db 0F6h,01h,0Ah,00h,0F7h,01h,0Ah,00h,0F8h,01h,0Ah,00h,0F9h,01h,0F1h,0FFh
        db 0FAh,01h,0Ah,00h,0FBh,01h,0Ah,00h,0FCh,01h,0Ah,00h,0FDh,01h,0F1h,0FFh
        db 0FEh,01h,0Ah,00h,0FFh,01h,0Ah,00h,00h,02h,0Ah,00h,01h,02h,0F1h,0FFh
        db 02h,02h,0Ah,00h,03h,02h,0Ah,00h,04h,02h,0Ah,00h,05h,02h,0F1h,0FFh
SPApflip:                                        ; SPA number 0x239
        db 00h,080h,010h,00h,020h,00h,030h,00h,040h,00h,042h,00h,044h,00h,046h,00h
        db 08Bh,01h,04h,00h,08Ch,01h,04h,00h,08Dh,01h,04h,00h,08Eh,01h,04h,00h
        db 08Fh,01h,04h,00h,08Ch,01h,04h,00h,090h,01h,04h,00h,08Ah,01h,0FCh,0FFh
        db 092h,01h,02h,00h,08Ah,01h,02h,00h,091h,01h,02h,00h,08Eh,01h,02h,00h
        db 093h,01h,02h,00h,08Eh,01h,02h,00h,091h,01h,02h,00h,08Ah,01h,0FEh,0FFh
        db 08Dh,01h,02h,00h,08Ch,01h,02h,00h,08Bh,01h,02h,00h,08Ah,01h,02h,00h
        db 090h,01h,02h,00h,08Ch,01h,02h,00h,08Fh,01h,02h,00h,08Eh,01h,0FEh,0FFh
        db 091h,01h,04h,00h,08Ah,01h,04h,00h,092h,01h,04h,00h,08Ah,01h,04h,00h
        db 091h,01h,04h,00h,08Eh,01h,04h,00h,093h,01h,04h,00h,08Eh,01h,0FCh,0FFh
        db 08Ah,01h,00h,0F0h,08Ah,01h,00h,0F0h,08Eh,01h,00h,0F0h,08Eh,01h,00h,0F0h
SPAglide:                                        ; SPA number 0x289
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 00h,00h,0F8h,0FFh,05h,00h,0F8h,0FFh,0Ah,00h,0F8h,0FFh,0Fh,00h,0F8h,0FFh
        db 014h,00h,0F8h,0FFh,019h,00h,0F8h,0FFh,01Eh,00h,0F8h,0FFh,023h,00h,0F8h,0FFh
SPAskatewp:                                        ; SPA number 0x2A1
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 01h,00h,0Ah,00h,02h,00h,0Ah,00h,03h,00h,0Ah,00h,04h,00h,0F6h,0FFh
        db 06h,00h,0Ah,00h,07h,00h,0Ah,00h,08h,00h,0Ah,00h,09h,00h,0F6h,0FFh
        db 0Bh,00h,0Ah,00h,0Ch,00h,0Ah,00h,0Dh,00h,0Ah,00h,0Eh,00h,0F6h,0FFh
        db 010h,00h,0Ah,00h,011h,00h,0Ah,00h,012h,00h,0Ah,00h,013h,00h,0F6h,0FFh
        db 015h,00h,0Ah,00h,016h,00h,0Ah,00h,017h,00h,0Ah,00h,018h,00h,0F6h,0FFh
        db 01Ah,00h,0Ah,00h,01Bh,00h,0Ah,00h,01Ch,00h,0Ah,00h,01Dh,00h,0F6h,0FFh
        db 01Fh,00h,0Ah,00h,020h,00h,0Ah,00h,021h,00h,0Ah,00h,022h,00h,0F6h,0FFh
        db 024h,00h,0Ah,00h,025h,00h,0Ah,00h,026h,00h,0Ah,00h,027h,00h,0F6h,0FFh
SPAskate:                                        ; SPA number 0x2E9
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 029h,00h,0Ah,00h,02Ah,00h,0Ah,00h,02Bh,00h,0Ah,00h,02Ch,00h,0F6h,0FFh
        db 02Eh,00h,0Ah,00h,02Fh,00h,0Ah,00h,030h,00h,0Ah,00h,031h,00h,0F6h,0FFh
        db 033h,00h,0Ah,00h,034h,00h,0Ah,00h,035h,00h,0Ah,00h,036h,00h,0F6h,0FFh
        db 038h,00h,0Ah,00h,039h,00h,0Ah,00h,03Ah,00h,0Ah,00h,03Bh,00h,0F6h,0FFh
        db 03Dh,00h,0Ah,00h,03Eh,00h,0Ah,00h,03Fh,00h,0Ah,00h,040h,00h,0F6h,0FFh
        db 042h,00h,0Ah,00h,043h,00h,0Ah,00h,044h,00h,0Ah,00h,045h,00h,0F6h,0FFh
        db 047h,00h,0Ah,00h,048h,00h,0Ah,00h,049h,00h,0Ah,00h,04Ah,00h,0F6h,0FFh
        db 04Ch,00h,0Ah,00h,04Dh,00h,0Ah,00h,04Eh,00h,0Ah,00h,04Fh,00h,0F6h,0FFh
SPAturnl:                                        ; SPA number 0x331
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 050h,00h,0F8h,0FFh,051h,00h,0F8h,0FFh,052h,00h,0F8h,0FFh,053h,00h,0F8h,0FFh
        db 054h,00h,0F8h,0FFh,055h,00h,0F8h,0FFh,056h,00h,0F8h,0FFh,057h,00h,0F8h,0FFh
SPAturnr:                                        ; SPA number 0x349
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 058h,00h,0F8h,0FFh,059h,00h,0F8h,0FFh,05Ah,00h,0F8h,0FFh,05Bh,00h,0F8h,0FFh
        db 05Ch,00h,0F8h,0FFh,05Dh,00h,0F8h,0FFh,05Eh,00h,0F8h,0FFh,05Fh,00h,0F8h,0FFh
SPAstop:                                        ; SPA number 0x361
        db 00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 090h,00h,04h,00h,091h,00h,0FCh,0FFh,092h,00h,04h,00h,093h,00h,0FCh,0FFh
        db 094h,00h,04h,00h,095h,00h,0FCh,0FFh,096h,00h,04h,00h,097h,00h,0FCh,0FFh
        db 098h,00h,04h,00h,099h,00h,0FCh,0FFh,09Ah,00h,04h,00h,09Bh,00h,0FCh,0FFh
        db 09Ch,00h,04h,00h,09Dh,00h,0FCh,0FFh,09Eh,00h,04h,00h,09Fh,00h,0FCh,0FFh
SPApassf:                                        ; SPA number 0x389
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 063h,00h,04h,00h,064h,00h,04h,00h,065h,00h,0ECh,0FFh,069h,00h,04h,00h
        db 06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Fh,00h,04h,00h,070h,00h,04h,00h
        db 071h,00h,0ECh,0FFh,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h,0ECh,0FFh
        db 07Bh,00h,04h,00h,07Ch,00h,04h,00h,07Dh,00h,0ECh,0FFh,081h,00h,04h,00h
        db 082h,00h,04h,00h,083h,00h,0ECh,0FFh,087h,00h,04h,00h,088h,00h,04h,00h
        db 089h,00h,0ECh,0FFh,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h,0ECh,0FFh
SPApassb:                                        ; SPA number 0x3C1
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 063h,00h,04h,00h,062h,00h,04h,00h,061h,00h,0ECh,0FFh,069h,00h,04h,00h
        db 068h,00h,04h,00h,067h,00h,0ECh,0FFh,06Fh,00h,04h,00h,06Eh,00h,04h,00h
        db 06Dh,00h,0ECh,0FFh,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h,0ECh,0FFh
        db 07Bh,00h,04h,00h,07Ah,00h,04h,00h,079h,00h,0ECh,0FFh,081h,00h,04h,00h
        db 080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,087h,00h,04h,00h,086h,00h,04h,00h
        db 085h,00h,0ECh,0FFh,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h,0ECh,0FFh
SPAshotf:                                        ; SPA number 0x3F9
        db 00h,00h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h,07Eh,00h
        db 063h,00h,04h,00h,062h,00h,04h,00h,061h,00h,04h,00h,060h,00h,04h,00h
        db 061h,00h,04h,00h,062h,00h,04h,00h,063h,00h,04h,00h,064h,00h,04h,00h
        db 065h,00h,0ECh,0FFh,069h,00h,04h,00h,068h,00h,04h,00h,067h,00h,04h,00h
        db 066h,00h,04h,00h,067h,00h,04h,00h,068h,00h,04h,00h,069h,00h,04h,00h
        db 06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Fh,00h,04h,00h,06Eh,00h,04h,00h
        db 06Dh,00h,04h,00h,06Ch,00h,04h,00h,06Dh,00h,04h,00h,06Eh,00h,04h,00h
        db 06Fh,00h,04h,00h,070h,00h,04h,00h,071h,00h,0ECh,0FFh,075h,00h,04h,00h
        db 074h,00h,04h,00h,073h,00h,04h,00h,072h,00h,04h,00h,073h,00h,04h,00h
        db 074h,00h,04h,00h,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h,0ECh,0FFh
        db 07Bh,00h,04h,00h,07Ah,00h,04h,00h,079h,00h,04h,00h,078h,00h,04h,00h
        db 079h,00h,04h,00h,07Ah,00h,04h,00h,07Bh,00h,04h,00h,07Ch,00h,04h,00h
        db 07Dh,00h,0ECh,0FFh,081h,00h,04h,00h,080h,00h,04h,00h,07Fh,00h,04h,00h
        db 07Eh,00h,04h,00h,07Fh,00h,04h,00h,080h,00h,04h,00h,081h,00h,04h,00h
        db 082h,00h,04h,00h,083h,00h,0ECh,0FFh,087h,00h,04h,00h,086h,00h,04h,00h
        db 085h,00h,04h,00h,084h,00h,04h,00h,085h,00h,04h,00h,086h,00h,04h,00h
        db 087h,00h,04h,00h,088h,00h,04h,00h,089h,00h,0ECh,0FFh,08Dh,00h,04h,00h
        db 08Ch,00h,04h,00h,08Bh,00h,04h,00h,08Ah,00h,04h,00h,08Bh,00h,04h,00h
        db 08Ch,00h,04h,00h,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h,0ECh,0FFh
SPAshotb:                                        ; SPA number 0x491
        db 00h,00h,012h,00h,024h,00h,036h,00h,048h,00h,05Ah,00h,06Ch,00h,07Eh,00h
        db 063h,00h,04h,00h,064h,00h,04h,00h,065h,00h,04h,00h,065h,00h,04h,00h
        db 065h,00h,04h,00h,064h,00h,04h,00h,063h,00h,04h,00h,062h,00h,04h,00h
        db 061h,00h,0ECh,0FFh,069h,00h,04h,00h,06Ah,00h,04h,00h,06Bh,00h,04h,00h
        db 06Bh,00h,04h,00h,06Bh,00h,04h,00h,06Ah,00h,04h,00h,069h,00h,04h,00h
        db 068h,00h,04h,00h,067h,00h,0ECh,0FFh,06Fh,00h,04h,00h,070h,00h,04h,00h
        db 071h,00h,04h,00h,071h,00h,04h,00h,071h,00h,04h,00h,070h,00h,04h,00h
        db 06Fh,00h,04h,00h,06Eh,00h,04h,00h,06Dh,00h,0ECh,0FFh,075h,00h,04h,00h
        db 076h,00h,04h,00h,077h,00h,04h,00h,077h,00h,04h,00h,077h,00h,04h,00h
        db 076h,00h,04h,00h,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h,0ECh,0FFh
        db 07Bh,00h,04h,00h,07Ch,00h,04h,00h,07Dh,00h,04h,00h,07Dh,00h,04h,00h
        db 07Dh,00h,04h,00h,07Ch,00h,04h,00h,07Bh,00h,04h,00h,07Ah,00h,04h,00h
        db 079h,00h,0ECh,0FFh,081h,00h,04h,00h,082h,00h,04h,00h,083h,00h,04h,00h
        db 083h,00h,04h,00h,083h,00h,04h,00h,082h,00h,04h,00h,081h,00h,04h,00h
        db 080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,087h,00h,04h,00h,088h,00h,04h,00h
        db 089h,00h,04h,00h,089h,00h,04h,00h,089h,00h,04h,00h,088h,00h,04h,00h
        db 087h,00h,04h,00h,086h,00h,04h,00h,085h,00h,0ECh,0FFh,08Dh,00h,04h,00h
        db 08Eh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h,04h,00h,08Fh,00h,04h,00h
        db 08Eh,00h,04h,00h,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h,0ECh,0FFh
SPAglideback:                                        ; SPA number 0x529
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0A0h,00h,0F8h,0FFh,0A3h,00h,0F8h,0FFh,0A6h,00h,0F8h,0FFh,0A9h,00h,0F8h,0FFh
        db 0ACh,00h,0F8h,0FFh,0AFh,00h,0F8h,0FFh,0B2h,00h,0F8h,0FFh,0B5h,00h,0F8h,0FFh
SPAskateback:                                        ; SPA number 0x541
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 0A0h,00h,0Ah,00h,0A1h,00h,0Ah,00h,0A0h,00h,0Ah,00h,0A2h,00h,0F6h,0FFh
        db 0A3h,00h,0Ah,00h,0A4h,00h,0Ah,00h,0A3h,00h,0Ah,00h,0A5h,00h,0F6h,0FFh
        db 0A6h,00h,0Ah,00h,0A7h,00h,0Ah,00h,0A6h,00h,0Ah,00h,0A8h,00h,0F6h,0FFh
        db 0A9h,00h,0Ah,00h,0AAh,00h,0Ah,00h,0A9h,00h,0Ah,00h,0ABh,00h,0F6h,0FFh
        db 0ACh,00h,0Ah,00h,0ADh,00h,0Ah,00h,0ACh,00h,0Ah,00h,0AEh,00h,0F6h,0FFh
        db 0AFh,00h,0Ah,00h,0B0h,00h,0Ah,00h,0AFh,00h,0Ah,00h,0B1h,00h,0F6h,0FFh
        db 0B2h,00h,0Ah,00h,0B3h,00h,0Ah,00h,0B2h,00h,0Ah,00h,0B4h,00h,0F6h,0FFh
        db 0B5h,00h,0Ah,00h,0B6h,00h,0Ah,00h,0B5h,00h,0Ah,00h,0B7h,00h,0F6h,0FFh
SPAsweepchk:                                        ; SPA number 0x589
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 00h,01h,04h,00h,01h,01h,08h,00h,00h,01h,0FCh,0FFh,02h,01h,04h,00h
        db 03h,01h,08h,00h,02h,01h,0FCh,0FFh,04h,01h,04h,00h,05h,01h,08h,00h
        db 04h,01h,0FCh,0FFh,06h,01h,04h,00h,07h,01h,08h,00h,06h,01h,0FCh,0FFh
        db 08h,01h,04h,00h,09h,01h,08h,00h,08h,01h,0FCh,0FFh,0Ah,01h,04h,00h
        db 0Bh,01h,08h,00h,0Ah,01h,0FCh,0FFh,0Ch,01h,04h,00h,0Dh,01h,08h,00h
        db 0Ch,01h,0FCh,0FFh,0Eh,01h,04h,00h,0Fh,01h,08h,00h,0Eh,01h,0FCh,0FFh
SPAshoulderchkl:                                        ; SPA number 0x5C1
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0F0h,00h,0E8h,0FFh,0F1h,00h,0E8h,0FFh,0F2h,00h,0E8h,0FFh,0F3h,00h,0E8h,0FFh
        db 0F4h,00h,0E8h,0FFh,0F5h,00h,0E8h,0FFh,0F6h,00h,0E8h,0FFh,0F7h,00h,0E8h,0FFh
SPAshoulderchkr:                                        ; SPA number 0x5D9
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0F8h,00h,0E8h,0FFh,0F9h,00h,0E8h,0FFh,0FAh,00h,0E8h,0FFh,0FBh,00h,0E8h,0FFh
        db 0FCh,00h,0E8h,0FFh,0FDh,00h,0E8h,0FFh,0FEh,00h,0E8h,0FFh,0FFh,00h,0E8h,0FFh
SPAhipchkl:                                        ; SPA number 0x5F1
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0E0h,00h,0E8h,0FFh,0E1h,00h,0E8h,0FFh,0E2h,00h,0E8h,0FFh,0E3h,00h,0E8h,0FFh
        db 0E4h,00h,0E8h,0FFh,0E5h,00h,0E8h,0FFh,0E6h,00h,0E8h,0FFh,0E7h,00h,0E8h,0FFh
SPAhipchkr:                                        ; SPA number 0x609
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0E8h,00h,0E8h,0FFh,0E9h,00h,0E8h,0FFh,0EAh,00h,0E8h,0FFh,0EBh,00h,0E8h,0FFh
        db 0ECh,00h,0E8h,0FFh,0EDh,00h,0E8h,0FFh,0EEh,00h,0E8h,0FFh,0EFh,00h,0E8h,0FFh
SPAburst:                                        ; SPA number 0x621
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 028h,00h,0E8h,0FFh,02Dh,00h,0E8h,0FFh,032h,00h,0E8h,0FFh,037h,00h,0E8h,0FFh
        db 03Ch,00h,0E8h,0FFh,041h,00h,0E8h,0FFh,046h,00h,0E8h,0FFh,04Bh,00h,0E8h,0FFh
SPAHold:                                        ; SPA number 0x639
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 058h,01h,0E2h,0FFh,059h,01h,0E2h,0FFh,05Ah,01h,0E2h,0FFh,05Bh,01h,0E2h,0FFh
        db 05Ch,01h,0E2h,0FFh,05Dh,01h,0E2h,0FFh,05Eh,01h,0E2h,0FFh,05Fh,01h,0E2h,0FFh
SPAHold2:                                        ; SPA number 0x651
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 058h,01h,0E2h,0FFh,059h,01h,0E2h,0FFh,05Ah,01h,0E2h,0FFh,05Bh,01h,0E2h,0FFh
        db 05Ch,01h,0E2h,0FFh,05Dh,01h,0E2h,0FFh,05Eh,01h,0E2h,0FFh,05Fh,01h,0E2h,0FFh
SPAflail:                                        ; SPA number 0x669
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 028h,00h,0E2h,0FFh,02Dh,00h,0E2h,0FFh,032h,00h,0E2h,0FFh,037h,00h,0E2h,0FFh
        db 03Ch,00h,0E2h,0FFh,041h,00h,0E2h,0FFh,046h,00h,0E2h,0FFh,04Bh,00h,0E2h,0FFh
SPAfallfwd:                                        ; SPA number 0x681
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 030h,01h,06h,00h,031h,01h,06h,00h,032h,01h,064h,00h,033h,01h,08h,00h
        db 050h,01h,0F8h,0FFh,034h,01h,06h,00h,035h,01h,06h,00h,036h,01h,064h,00h
        db 037h,01h,08h,00h,051h,01h,0F8h,0FFh,038h,01h,06h,00h,039h,01h,06h,00h
        db 03Ah,01h,064h,00h,03Bh,01h,08h,00h,052h,01h,0F8h,0FFh,03Ch,01h,06h,00h
        db 03Dh,01h,06h,00h,03Eh,01h,064h,00h,03Fh,01h,08h,00h,053h,01h,0F8h,0FFh
        db 040h,01h,06h,00h,041h,01h,06h,00h,042h,01h,064h,00h,043h,01h,08h,00h
        db 054h,01h,0F8h,0FFh,044h,01h,06h,00h,045h,01h,06h,00h,046h,01h,064h,00h
        db 047h,01h,08h,00h,055h,01h,0F8h,0FFh,048h,01h,06h,00h,049h,01h,06h,00h
        db 04Ah,01h,064h,00h,04Bh,01h,08h,00h,056h,01h,0F8h,0FFh,04Ch,01h,06h,00h
        db 04Dh,01h,06h,00h,04Eh,01h,064h,00h,04Fh,01h,08h,00h,057h,01h,0F8h,0FFh
SPAfallback:                                        ; SPA number 0x6D9
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 010h,01h,06h,00h,011h,01h,06h,00h,012h,01h,064h,00h,013h,01h,08h,00h
        db 050h,01h,0F8h,0FFh,014h,01h,06h,00h,015h,01h,06h,00h,016h,01h,064h,00h
        db 017h,01h,08h,00h,051h,01h,0F8h,0FFh,018h,01h,06h,00h,019h,01h,06h,00h
        db 01Ah,01h,064h,00h,01Bh,01h,08h,00h,052h,01h,0F8h,0FFh,01Ch,01h,06h,00h
        db 01Dh,01h,06h,00h,01Eh,01h,064h,00h,01Fh,01h,08h,00h,053h,01h,0F8h,0FFh
        db 020h,01h,06h,00h,021h,01h,06h,00h,022h,01h,064h,00h,023h,01h,08h,00h
        db 054h,01h,0F8h,0FFh,024h,01h,06h,00h,025h,01h,06h,00h,026h,01h,064h,00h
        db 027h,01h,08h,00h,055h,01h,0F8h,0FFh,028h,01h,06h,00h,029h,01h,06h,00h
        db 02Ah,01h,064h,00h,02Bh,01h,08h,00h,056h,01h,0F8h,0FFh,02Ch,01h,06h,00h
        db 02Dh,01h,06h,00h,02Eh,01h,064h,00h,02Fh,01h,08h,00h,057h,01h,0F8h,0FFh
SPAcelebrate:                                        ; SPA number 0x731
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 0B8h,00h,0Ch,00h,0B9h,00h,028h,00h,0B8h,00h,0FBh,0FFh,0BAh,00h,0Ch,00h
        db 0BBh,00h,028h,00h,0BAh,00h,0FBh,0FFh,0BCh,00h,0Ch,00h,0BDh,00h,028h,00h
        db 0BCh,00h,0FBh,0FFh,0BEh,00h,0Ch,00h,0BFh,00h,028h,00h,0BEh,00h,0FBh,0FFh
        db 0C0h,00h,0Ch,00h,0C1h,00h,028h,00h,0C0h,00h,0FBh,0FFh,0C2h,00h,0Ch,00h
        db 0C3h,00h,028h,00h,0C2h,00h,0FBh,0FFh,0C4h,00h,0Ch,00h,0C5h,00h,028h,00h
        db 0C4h,00h,0FBh,0FFh,0C6h,00h,0Ch,00h,0C7h,00h,028h,00h,0C6h,00h,0FBh,0FFh
SPApump:                                        ; SPA number 0x769
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 0C8h,00h,08h,00h,0C9h,00h,010h,00h,0C8h,00h,0F8h,0FFh,0CAh,00h,08h,00h
        db 0CBh,00h,010h,00h,0CAh,00h,0F8h,0FFh,0CCh,00h,08h,00h,0CDh,00h,010h,00h
        db 0CCh,00h,0F8h,0FFh,0CEh,00h,08h,00h,0CFh,00h,010h,00h,0CEh,00h,0F8h,0FFh
        db 0D0h,00h,08h,00h,0D1h,00h,010h,00h,0D0h,00h,0F8h,0FFh,0D2h,00h,08h,00h
        db 0D3h,00h,010h,00h,0D2h,00h,0F8h,0FFh,0D4h,00h,08h,00h,0D5h,00h,010h,00h
        db 0D4h,00h,0F8h,0FFh,0D6h,00h,08h,00h,0D7h,00h,010h,00h,0D6h,00h,0F8h,0FFh
SPAwallright:                                        ; SPA number 0x7A1
        db 00h,00h,06h,00h,06h,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h
        db 07Ch,01h,08h,00h,07Dh,01h,08h,00h,07Eh,01h,0F8h,0FFh,078h,01h,08h,00h
        db 079h,01h,08h,00h,07Ah,01h,08h,00h,07Bh,01h,0F8h,0FFh,07Bh,01h,08h,00h
        db 07Ah,01h,08h,00h,079h,01h,08h,00h,078h,01h,0F8h,0FFh
SPAwallleft:                                        ; SPA number 0x7BF
        db 00h,00h,06h,00h,06h,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h,0Eh,00h
        db 07Eh,01h,08h,00h,07Dh,01h,08h,00h,07Ch,01h,0F8h,0FFh,07Bh,01h,08h,00h
        db 07Ah,01h,08h,00h,079h,01h,08h,00h,078h,01h,0F8h,0FFh,078h,01h,08h,00h
        db 079h,01h,08h,00h,07Ah,01h,08h,00h,07Bh,01h,0F8h,0FFh
SPAfaceoff:                                        ; SPA number 0x7DD
        db 00h,00h,06h,00h,06h,00h,06h,00h,06h,00h,06h,00h,06h,00h,06h,00h
        db 06Eh,01h,06h,00h,06Fh,01h,08h,00h,070h,01h,0F8h,0FFh,069h,01h,06h,00h
        db 06Ah,01h,08h,00h,06Bh,01h,0F8h,0FFh
SPAfaceoffr:                                        ; SPA number 0x7F1
        db 00h,00h,02h,00h,02h,00h,02h,00h,02h,00h,02h,00h,02h,00h,02h,00h
        db 06Dh,01h,0FBh,0FFh,068h,01h,0FBh,0FFh
SPAsiren:                                        ; SPA number 0x7FD
        db 00h,080h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 02Ah,02h,03h,00h,02Bh,02h,03h,00h,02Ch,02h,03h,00h,02Dh,02h,03h,00h
        db 02Eh,02h,03h,00h,02Fh,02h,03h,00h,030h,02h,03h,00h,031h,02h,03h,00h
        db 032h,02h,03h,00h,033h,02h,03h,00h,034h,02h,03h,00h,035h,02h,03h,00h
        db 036h,02h,03h,00h,037h,02h,0FDh,0FFh
SPAbglass:                                        ; SPA number 0x821
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 084h,02h,08h,00h,085h,02h,08h,00h,086h,02h,08h,00h,087h,02h,08h,00h
        db 088h,02h,018h,0FCh
SPAstanley:                                        ; SPA number 0x833
        db 00h,080h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0D8h,00h,0E2h,0FFh,0D9h,00h,0E2h,0FFh,0DAh,00h,0E2h,0FFh,0DBh,00h,0E2h,0FFh
        db 0DCh,00h,0E2h,0FFh,0DDh,00h,0E2h,0FFh,0DEh,00h,0E2h,0FFh,0DFh,00h,0E2h,0FFh
SPAcatch:                                        ; SPA number 0x84B
        db 00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 038h,02h,06h,00h,039h,02h,0FAh,0FFh,03Ah,02h,06h,00h,03Bh,02h,0FAh,0FFh
        db 03Ch,02h,06h,00h,03Dh,02h,0FAh,0FFh,03Eh,02h,06h,00h,03Fh,02h,0FAh,0FFh
        db 040h,02h,06h,00h,041h,02h,0FAh,0FFh,042h,02h,06h,00h,043h,02h,0FAh,0FFh
        db 044h,02h,06h,00h,045h,02h,0FAh,0FFh,046h,02h,06h,00h,047h,02h,0FAh,0FFh
SPAhook:                                        ; SPA number 0x873
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 048h,02h,0E2h,0FFh,04Ah,02h,0E2h,0FFh,04Ch,02h,0E2h,0FFh,04Eh,02h,0E2h,0FFh
        db 050h,02h,0E2h,0FFh,052h,02h,0E2h,0FFh,054h,02h,0E2h,0FFh,056h,02h,0E2h,0FFh
SPAhook2:                                        ; SPA number 0x88B
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 048h,02h,09h,00h,049h,02h,09h,00h,048h,02h,09h,00h,049h,02h,0F7h,0FFh
        db 04Ah,02h,09h,00h,04Bh,02h,09h,00h,04Ah,02h,09h,00h,04Bh,02h,0F7h,0FFh
        db 04Ch,02h,09h,00h,04Dh,02h,09h,00h,04Ch,02h,09h,00h,04Dh,02h,0F7h,0FFh
        db 04Eh,02h,09h,00h,04Fh,02h,09h,00h,04Eh,02h,09h,00h,04Fh,02h,0F7h,0FFh
        db 050h,02h,09h,00h,051h,02h,09h,00h,050h,02h,09h,00h,051h,02h,0F7h,0FFh
        db 052h,02h,09h,00h,053h,02h,09h,00h,052h,02h,09h,00h,053h,02h,0F7h,0FFh
        db 054h,02h,09h,00h,055h,02h,09h,00h,054h,02h,09h,00h,055h,02h,0F7h,0FFh
        db 056h,02h,09h,00h,057h,02h,09h,00h,056h,02h,09h,00h,057h,02h,0F7h,0FFh
SPAstumble:                                        ; SPA number 0x8D3
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 058h,02h,06h,00h,059h,02h,06h,00h,05Ah,02h,08h,00h,059h,02h,06h,00h
        db 058h,02h,0FAh,0FFh,05Bh,02h,06h,00h,05Ch,02h,06h,00h,05Dh,02h,08h,00h
        db 05Ch,02h,06h,00h,05Bh,02h,0FAh,0FFh,05Eh,02h,06h,00h,05Fh,02h,06h,00h
        db 060h,02h,08h,00h,05Fh,02h,06h,00h,05Eh,02h,0FAh,0FFh,061h,02h,06h,00h
        db 062h,02h,06h,00h,063h,02h,08h,00h,062h,02h,06h,00h,061h,02h,0FAh,0FFh
        db 064h,02h,06h,00h,065h,02h,06h,00h,066h,02h,08h,00h,065h,02h,06h,00h
        db 064h,02h,0FAh,0FFh,067h,02h,06h,00h,068h,02h,06h,00h,069h,02h,08h,00h
        db 068h,02h,06h,00h,067h,02h,0FAh,0FFh,06Ah,02h,06h,00h,06Bh,02h,06h,00h
        db 06Ch,02h,08h,00h,06Bh,02h,06h,00h,06Ah,02h,0FAh,0FFh,06Dh,02h,06h,00h
        db 06Eh,02h,06h,00h,06Fh,02h,08h,00h,06Eh,02h,06h,00h,06Dh,02h,0FAh,0FFh
SPAfake:                                        ; SPA number 0x92B
        db 00h,00h,0Ch,00h,018h,00h,024h,00h,030h,00h,03Ch,00h,048h,00h,054h,00h
        db 050h,00h,04h,00h,057h,00h,04h,00h,0Ch,01h,014h,00h,05Fh,00h,04h,00h
        db 058h,00h,04h,00h,059h,00h,0FCh,0FFh,051h,00h,04h,00h,050h,00h,04h,00h
        db 0Eh,01h,014h,00h,058h,00h,04h,00h,059h,00h,04h,00h,05Ah,00h,0FCh,0FFh
        db 052h,00h,04h,00h,051h,00h,04h,00h,00h,01h,014h,00h,059h,00h,04h,00h
        db 05Ah,00h,04h,00h,05Bh,00h,0FCh,0FFh,053h,00h,04h,00h,052h,00h,04h,00h
        db 02h,01h,014h,00h,05Ah,00h,04h,00h,05Bh,00h,04h,00h,05Ch,00h,0FCh,0FFh
        db 054h,00h,04h,00h,053h,00h,04h,00h,04h,01h,014h,00h,05Bh,00h,04h,00h
        db 05Ch,00h,04h,00h,05Dh,00h,0FCh,0FFh,055h,00h,04h,00h,054h,00h,04h,00h
        db 06h,01h,014h,00h,05Ch,00h,04h,00h,05Dh,00h,04h,00h,05Eh,00h,0FCh,0FFh
        db 056h,00h,04h,00h,055h,00h,04h,00h,08h,01h,014h,00h,05Dh,00h,04h,00h
        db 05Eh,00h,04h,00h,05Fh,00h,0FCh,0FFh,057h,00h,04h,00h,056h,00h,04h,00h
        db 0Ah,01h,014h,00h,05Eh,00h,04h,00h,05Fh,00h,04h,00h,058h,00h,0FCh,0FFh
SPAflip:                                        ; SPA number 0x993
        db 00h,00h,0Eh,00h,01Ch,00h,02Ah,00h,038h,00h,046h,00h,054h,00h,062h,00h
        db 070h,02h,06h,00h,071h,02h,06h,00h,072h,02h,06h,00h,073h,02h,06h,00h
        db 012h,01h,064h,00h,013h,01h,08h,00h,050h,01h,0F8h,0FFh,070h,02h,06h,00h
        db 071h,02h,06h,00h,072h,02h,06h,00h,073h,02h,06h,00h,016h,01h,064h,00h
        db 017h,01h,08h,00h,051h,01h,0F8h,0FFh,070h,02h,06h,00h,071h,02h,06h,00h
        db 072h,02h,06h,00h,073h,02h,06h,00h,01Ah,01h,064h,00h,01Bh,01h,08h,00h
        db 052h,01h,0F8h,0FFh,074h,02h,06h,00h,075h,02h,06h,00h,076h,02h,06h,00h
        db 077h,02h,06h,00h,01Eh,01h,064h,00h,01Fh,01h,08h,00h,053h,01h,0F8h,0FFh
        db 074h,02h,06h,00h,075h,02h,06h,00h,076h,02h,06h,00h,077h,02h,06h,00h
        db 022h,01h,064h,00h,023h,01h,08h,00h,054h,01h,0F8h,0FFh,074h,02h,06h,00h
        db 075h,02h,06h,00h,076h,02h,06h,00h,077h,02h,06h,00h,026h,01h,064h,00h
        db 027h,01h,08h,00h,055h,01h,0F8h,0FFh,074h,02h,06h,00h,075h,02h,06h,00h
        db 076h,02h,06h,00h,077h,02h,06h,00h,02Ah,01h,064h,00h,02Bh,01h,08h,00h
        db 056h,01h,0F8h,0FFh,070h,02h,06h,00h,071h,02h,06h,00h,072h,02h,06h,00h
        db 073h,02h,06h,00h,02Eh,01h,064h,00h,02Fh,01h,08h,00h,057h,01h,0F8h,0FFh
SPAinjury1:                                        ; SPA number 0xA0B
        db 00h,00h,00h,00h,00h,00h,024h,00h,024h,00h,024h,00h,024h,00h,00h,00h
        db 010h,01h,06h,00h,011h,01h,06h,00h,012h,01h,01Eh,00h,078h,02h,0Ah,00h
        db 079h,02h,0Ah,00h,07Ah,02h,0Ah,00h,07Bh,02h,08h,00h,07Ch,02h,08h,00h
        db 07Dh,02h,08h,00h,07Bh,02h,08h,00h,07Ch,02h,08h,00h,07Dh,02h,08h,00h
        db 07Bh,02h,08h,00h,07Ch,02h,08h,00h,07Dh,02h,08h,00h,07Bh,02h,08h,00h
        db 07Ch,02h,08h,00h,07Dh,02h,0ACh,0F4h,020h,01h,06h,00h,021h,01h,06h,00h
        db 022h,01h,01Eh,00h,07Eh,02h,0Ah,00h,07Fh,02h,0Ah,00h,080h,02h,0Ah,00h
        db 081h,02h,08h,00h,082h,02h,08h,00h,083h,02h,08h,00h,081h,02h,08h,00h
        db 082h,02h,08h,00h,083h,02h,08h,00h,081h,02h,08h,00h,082h,02h,08h,00h
        db 083h,02h,08h,00h,081h,02h,08h,00h,082h,02h,08h,00h,083h,02h,0ACh,0F4h
SPArefglide:                                        ; SPA number 0xA5B
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 08Ah,02h,0F8h,0FFh,0ADh,02h,0F8h,0FFh,0A8h,02h,0F8h,0FFh,0A3h,02h,0F8h,0FFh
        db 09Eh,02h,0F8h,0FFh,099h,02h,0F8h,0FFh,094h,02h,0F8h,0FFh,08Fh,02h,0F8h,0FFh
SPArefskate:                                        ; SPA number 0xA73
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 08Dh,02h,0Ah,00h,08Eh,02h,0Ah,00h,08Bh,02h,0Ah,00h,08Ch,02h,0F6h,0FFh
        db 0B0h,02h,0Ah,00h,0B1h,02h,0Ah,00h,0AEh,02h,0Ah,00h,0AFh,02h,0F6h,0FFh
        db 0ABh,02h,0Ah,00h,0ACh,02h,0Ah,00h,0A9h,02h,0Ah,00h,0AAh,02h,0F6h,0FFh
        db 0A6h,02h,0Ah,00h,0A7h,02h,0Ah,00h,0A4h,02h,0Ah,00h,0A5h,02h,0F6h,0FFh
        db 0A1h,02h,0Ah,00h,0A2h,02h,0Ah,00h,09Fh,02h,0Ah,00h,0A0h,02h,0F6h,0FFh
        db 09Ch,02h,0Ah,00h,09Dh,02h,0Ah,00h,09Ah,02h,0Ah,00h,09Bh,02h,0F6h,0FFh
        db 097h,02h,0Ah,00h,098h,02h,0Ah,00h,095h,02h,0Ah,00h,096h,02h,0F6h,0FFh
        db 092h,02h,0Ah,00h,093h,02h,0Ah,00h,090h,02h,0Ah,00h,091h,02h,0F6h,0FFh
SPArefturnl:                                        ; SPA number 0xABB
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0F3h,02h,0F8h,0FFh,0F4h,02h,0F8h,0FFh,0F5h,02h,0F8h,0FFh,0F6h,02h,0F8h,0FFh
        db 0F7h,02h,0F8h,0FFh,0F8h,02h,0F8h,0FFh,0F9h,02h,0F8h,0FFh,0FAh,02h,0F8h,0FFh
SPArefturnr:                                        ; SPA number 0xAD3
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0FBh,02h,0F8h,0FFh,0FCh,02h,0F8h,0FFh,0FDh,02h,0F8h,0FFh,0FEh,02h,0F8h,0FFh
        db 0FFh,02h,0F8h,0FFh,00h,03h,0F8h,0FFh,01h,03h,0F8h,0FFh,02h,03h,0F8h,0FFh
SPArefstop:                                        ; SPA number 0xAEB
        db 00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 03h,03h,04h,00h,04h,03h,0FCh,0FFh,05h,03h,04h,00h,06h,03h,0FCh,0FFh
        db 07h,03h,04h,00h,08h,03h,0FCh,0FFh,09h,03h,04h,00h,0Ah,03h,0FCh,0FFh
        db 0Bh,03h,04h,00h,0Ch,03h,0FCh,0FFh,0Dh,03h,04h,00h,0Eh,03h,0FCh,0FFh
        db 0Fh,03h,04h,00h,010h,03h,0FCh,0FFh,011h,03h,04h,00h,012h,03h,0FCh,0FFh
SPAreffallback:                                        ; SPA number 0xB13
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 013h,03h,0Ah,00h,014h,03h,01Ch,00h,015h,03h,0F6h,0FFh,016h,03h,0Ah,00h
        db 017h,03h,01Ch,00h,018h,03h,0F6h,0FFh,019h,03h,0Ah,00h,01Ah,03h,01Ch,00h
        db 01Bh,03h,0F6h,0FFh,01Ch,03h,0Ah,00h,01Dh,03h,01Ch,00h,01Eh,03h,0F6h,0FFh
        db 01Fh,03h,0Ah,00h,020h,03h,01Ch,00h,021h,03h,0F6h,0FFh,022h,03h,0Ah,00h
        db 023h,03h,01Ch,00h,024h,03h,0F6h,0FFh,025h,03h,0Ah,00h,026h,03h,01Ch,00h
        db 027h,03h,0F6h,0FFh,028h,03h,0Ah,00h,029h,03h,01Ch,00h,02Ah,03h,0F6h,0FFh
SPAarmupglide:                                        ; SPA number 0xB4B
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0CBh,02h,0F8h,0FFh,0EEh,02h,0F8h,0FFh,0E9h,02h,0F8h,0FFh,0E4h,02h,0F8h,0FFh
        db 0E1h,02h,0F8h,0FFh,0DAh,02h,0F8h,0FFh,0D5h,02h,0F8h,0FFh,0D0h,02h,0F8h,0FFh
SPAarmupskate:                                        ; SPA number 0xB63
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 0CEh,02h,0Ah,00h,0CFh,02h,0Ah,00h,0CCh,02h,0Ah,00h,0CDh,02h,0F6h,0FFh
        db 0F1h,02h,0Ah,00h,0F2h,02h,0Ah,00h,0F0h,02h,0Ah,00h,0EFh,02h,0F6h,0FFh
        db 0ECh,02h,0Ah,00h,0EDh,02h,0Ah,00h,0EAh,02h,0Ah,00h,0EBh,02h,0F6h,0FFh
        db 0E7h,02h,0Ah,00h,0E8h,02h,0Ah,00h,0E5h,02h,0Ah,00h,0E6h,02h,0F6h,0FFh
        db 0E2h,02h,0Ah,00h,0DFh,02h,0Ah,00h,0E0h,02h,0Ah,00h,0E3h,02h,0F6h,0FFh
        db 0DDh,02h,0Ah,00h,0DEh,02h,0Ah,00h,0DBh,02h,0Ah,00h,0DCh,02h,0F6h,0FFh
        db 0D8h,02h,0Ah,00h,0D9h,02h,0Ah,00h,0D6h,02h,0Ah,00h,0D7h,02h,0F6h,0FFh
        db 0D3h,02h,0Ah,00h,0D4h,02h,0Ah,00h,0D1h,02h,0Ah,00h,0D2h,02h,0F6h,0FFh
SPAarmupturnl:                                        ; SPA number 0xBAB
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 02Bh,03h,0F8h,0FFh,02Ch,03h,0F8h,0FFh,02Dh,03h,0F8h,0FFh,02Eh,03h,0F8h,0FFh
        db 02Fh,03h,0F8h,0FFh,030h,03h,0F8h,0FFh,031h,03h,0F8h,0FFh,032h,03h,0F8h,0FFh
SPAarmupturnr:                                        ; SPA number 0xBC3
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 033h,03h,0F8h,0FFh,034h,03h,0F8h,0FFh,035h,03h,0F8h,0FFh,036h,03h,0F8h,0FFh
        db 037h,03h,0F8h,0FFh,038h,03h,0F8h,0FFh,039h,03h,0F8h,0FFh,03Ah,03h,0F8h,0FFh
SPAarmupstop:                                        ; SPA number 0xBDB
        db 00h,080h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 03Bh,03h,04h,00h,03Ch,03h,0FCh,0FFh,03Dh,03h,04h,00h,03Eh,03h,0FCh,0FFh
        db 03Fh,03h,04h,00h,040h,03h,0FCh,0FFh,041h,03h,04h,00h,042h,03h,0FCh,0FFh
        db 043h,03h,04h,00h,044h,03h,0FCh,0FFh,045h,03h,04h,00h,046h,03h,0FCh,0FFh
        db 047h,03h,04h,00h,048h,03h,0FCh,0FFh,049h,03h,04h,00h,04Ah,03h,0FCh,0FFh
SPArefpickup:                                        ; SPA number 0xC03
        db 00h,00h,02h,00h,04h,00h,06h,00h,08h,00h,0Ah,00h,0Ch,00h,0Eh,00h
        db 0B3h,02h,0F4h,0FFh,0BAh,02h,0F4h,0FFh,0B9h,02h,0F4h,0FFh,0B8h,02h,0F4h,0FFh
        db 0B7h,02h,0F4h,0FFh,0B6h,02h,0F4h,0FFh,0B5h,02h,0F4h,0FFh,0B4h,02h,0F4h,0FFh
SPArefpointgoa:                                        ; SPA number 0xC1B
        db 00h,00h,04h,00h,08h,00h,0Ch,00h,010h,00h,014h,00h,018h,00h,01Ch,00h
        db 0BBh,02h,08h,00h,0BCh,02h,0E8h,0FFh,0BDh,02h,08h,00h,0BEh,02h,0E8h,0FFh
        db 0BFh,02h,08h,00h,0C0h,02h,0E8h,0FFh,0C1h,02h,08h,00h,0C2h,02h,0E8h,0FFh
        db 0C3h,02h,08h,00h,0C4h,02h,0E8h,0FFh,0C5h,02h,08h,00h,0C6h,02h,0E8h,0FFh
        db 0C7h,02h,08h,00h,0C8h,02h,0E8h,0FFh,0C9h,02h,08h,00h,0CAh,02h,0E8h,0FFh
SPArefdrop:                                        ; SPA number 0xC43
        db 00h,00h,00h,00h,00h,00h,06h,00h,06h,00h,06h,00h,06h,00h,00h,00h
        db 04Bh,03h,08h,00h,04Ch,03h,08h,00h,0BFh,02h,0F8h,0FFh,04Dh,03h,08h,00h
        db 04Eh,03h,08h,00h,0C7h,02h,0F8h,0FFh
SPAreffowait:                                        ; SPA number 0xC57
        db 00h,00h,00h,00h,00h,00h,02h,00h,02h,00h,02h,00h,02h,00h,00h,00h
        db 0BFh,02h,0F8h,0FFh,0C7h,02h,0F8h,0FFh
SPArefrough:                                        ; SPA number 0xC63
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,05Bh,03h,0Ch,00h,05Ch,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPArefcharge:                                        ; SPA number 0xC73
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,05Fh,03h,0Ch,00h,060h,03h,0Ch,00h,061h,03h,0Ch,00h
        db 05Fh,03h,0Ch,00h,060h,03h,0Ch,00h,061h,03h,0Ch,00h,04Fh,03h,0F4h,0FFh
SPArefslash:                                        ; SPA number 0xC8B
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,054h,03h,0Ch,00h,055h,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPArefxcheck:                                        ; SPA number 0xC9B
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,056h,03h,0Ch,00h,057h,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPArefhook:                                        ; SPA number 0xCAB
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,052h,03h,0Ch,00h,053h,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPAreftrip:                                        ; SPA number 0xCBB
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,05Dh,03h,0Ch,00h,05Eh,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPArefinterfer:                                        ; SPA number 0xCCB
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,059h,03h,030h,00h,04Fh,03h,0F4h,0FFh
SPArefhold:                                        ; SPA number 0xCD9
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,058h,03h,030h,00h,04Fh,03h,0F4h,0FFh
SPArefabuseoff:                                        ; SPA number 0xCE7
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,05Ah,03h,030h,00h,04Fh,03h,0F4h,0FFh
SPArefbehind:                                        ; SPA number 0xCF5
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,050h,03h,0Ch,00h,051h,03h,018h,00h,04Fh,03h,0F4h,0FFh
SPAfaceoffpoke:                                        ; SPA number 0xD05
        db 00h,00h,04h,00h,04h,00h,04h,00h,04h,00h,04h,00h,04h,00h,04h,00h
        db 06Eh,01h,06h,00h,06Fh,01h,0F8h,0FFh,069h,01h,06h,00h,06Ah,01h,0F8h,0FFh
SPAgwallright:                                        ; SPA number 0xD15
        db 00h,00h,00h,00h,00h,00h,00h,00h,08h,00h,08h,00h,08h,00h,08h,00h
        db 074h,01h,08h,00h,075h,01h,08h,00h,076h,01h,08h,00h,077h,01h,0F8h,0FFh
        db 077h,01h,08h,00h,076h,01h,08h,00h,075h,01h,08h,00h,074h,01h,0F8h,0FFh
SPAgwallleft:                                        ; SPA number 0xD2D
        db 00h,00h,00h,00h,00h,00h,00h,00h,08h,00h,08h,00h,08h,00h,08h,00h
        db 077h,01h,08h,00h,076h,01h,08h,00h,075h,01h,08h,00h,074h,01h,0F8h,0FFh
        db 074h,01h,08h,00h,075h,01h,08h,00h,076h,01h,08h,00h,077h,01h,0F8h,0FFh
SPAanthem1:                                        ; SPA number 0xD45
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 071h,01h,01Eh,00h,072h,01h,01Eh,00h,073h,01h,01Eh,00h,072h,01h,01Eh,00h
        db 071h,01h,0C4h,0FFh
SPAanthem2:                                        ; SPA number 0xD57
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 071h,01h,01Eh,00h,072h,01h,01Eh,00h,073h,01h,01Eh,00h,071h,01h,0C4h,0FFh
SPAanthem3:                                        ; SPA number 0xD67
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 071h,01h,01Eh,00h,072h,01h,01Eh,00h,073h,01h,01Eh,00h,072h,01h,01Eh,00h
        db 073h,01h,01Eh,00h,071h,01h,0C4h,0FFh
SPAanthem4:                                        ; SPA number 0xD7B
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 071h,01h,01Eh,00h,07Ch,01h,02Dh,00h,071h,01h,0C4h,0FFh
SPAanthem5:                                        ; SPA number 0xD89
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 071h,01h,01Eh,00h,07Dh,01h,02Dh,00h,071h,01h,0C4h,0FFh
SPAdrink:                                        ; SPA number 0xD97
        db 00h,00h,00h,00h,00h,00h,00h,00h,06h,00h,06h,00h,06h,00h,06h,00h
        db 0BBh,02h,01Eh,00h,0BCh,02h,02Dh,00h,0BBh,02h,0E2h,0FFh,0BDh,02h,01Eh,00h
        db 0BEh,02h,02Dh,00h,0BDh,02h,0E2h,0FFh
SPArefanthem1:                                        ; SPA number 0xDAB
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 089h,02h,01Eh,00h,0C1h,02h,01Eh,00h,0C2h,02h,01Eh,00h,0C3h,02h,01Eh,00h
        db 0C2h,02h,01Eh,00h,0C3h,02h,01Eh,00h,0C1h,02h,01Eh,00h,089h,02h,0E2h,0FFh
SPArefanthem2:                                        ; SPA number 0xDC3
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 089h,02h,01Eh,00h,0B2h,02h,01Eh,00h,0C1h,02h,01Eh,00h,089h,02h,0E2h,0FFh
SPAonetimef:                                        ; SPA number 0xDD3
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 061h,00h,018h,00h,062h,00h,04h,00h,063h,00h,04h,00h,064h,00h,04h,00h
        db 065h,00h,0ECh,0FFh,067h,00h,018h,00h,068h,00h,04h,00h,069h,00h,04h,00h
        db 06Ah,00h,04h,00h,06Bh,00h,0ECh,0FFh,06Dh,00h,018h,00h,06Eh,00h,04h,00h
        db 06Fh,00h,04h,00h,070h,00h,04h,00h,071h,00h,0ECh,0FFh,073h,00h,018h,00h
        db 074h,00h,04h,00h,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h,0ECh,0FFh
        db 079h,00h,018h,00h,07Ah,00h,04h,00h,07Bh,00h,04h,00h,07Ch,00h,04h,00h
        db 07Dh,00h,0ECh,0FFh,07Fh,00h,018h,00h,080h,00h,04h,00h,081h,00h,04h,00h
        db 082h,00h,04h,00h,083h,00h,0ECh,0FFh,085h,00h,018h,00h,086h,00h,04h,00h
        db 087h,00h,04h,00h,088h,00h,04h,00h,089h,00h,0ECh,0FFh,08Bh,00h,018h,00h
        db 08Ch,00h,04h,00h,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h,0ECh,0FFh
SPAonetimeb:                                        ; SPA number 0xE2B
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 065h,00h,018h,00h,064h,00h,04h,00h,063h,00h,04h,00h,062h,00h,04h,00h
        db 061h,00h,0ECh,0FFh,06Bh,00h,018h,00h,06Ah,00h,04h,00h,069h,00h,04h,00h
        db 068h,00h,04h,00h,067h,00h,0ECh,0FFh,071h,00h,018h,00h,070h,00h,04h,00h
        db 06Fh,00h,04h,00h,06Eh,00h,04h,00h,06Dh,00h,0ECh,0FFh,077h,00h,018h,00h
        db 076h,00h,04h,00h,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h,0ECh,0FFh
        db 07Dh,00h,018h,00h,07Ch,00h,04h,00h,07Bh,00h,04h,00h,07Ah,00h,04h,00h
        db 079h,00h,0ECh,0FFh,083h,00h,018h,00h,082h,00h,04h,00h,081h,00h,04h,00h
        db 080h,00h,04h,00h,07Fh,00h,0ECh,0FFh,089h,00h,018h,00h,088h,00h,04h,00h
        db 087h,00h,04h,00h,086h,00h,04h,00h,085h,00h,0ECh,0FFh,08Fh,00h,018h,00h
        db 08Eh,00h,04h,00h,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h,0ECh,0FFh
SPAgetcup:                                        ; SPA number 0xE83
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 065h,01h,010h,00h,066h,01h,010h,00h,068h,03h,020h,00h,066h,01h,0Ch,00h
        db 069h,03h,0Ch,00h,0DCh,00h,0E0h,0FFh
SPAbrcup:                                        ; SPA number 0xE97
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 062h,03h,0Ch,00h,063h,03h,0Ch,00h,062h,03h,0Ch,00h,063h,03h,0Ch,00h
        db 064h,03h,0FCh,0FFh
SPAgvcup:                                        ; SPA number 0xEA9
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 064h,03h,011h,00h,065h,03h,0F4h,0FFh
SPAclap:                                        ; SPA number 0xEB5
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 067h,03h,0Ch,00h,066h,03h,0Ch,00h,067h,03h,0Ch,00h,066h,03h,0Ch,00h
        db 067h,03h,0Ch,00h,066h,03h,0Ch,00h,065h,03h,0F4h,0FFh
SPAstansk:                                        ; SPA number 0xECB
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 06Ah,03h,0Ch,00h,06Bh,03h,0F4h,0FFh
SPAcrosscheck:                                        ; SPA number 0xED7
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 078h,03h,05h,00h,079h,03h,0Ah,00h,078h,03h,0FAh,0FFh,07Ah,03h,05h,00h
        db 07Bh,03h,0Ah,00h,07Ah,03h,0FAh,0FFh,07Ch,03h,05h,00h,07Dh,03h,0Ah,00h
        db 07Ch,03h,0FAh,0FFh,07Eh,03h,05h,00h,07Fh,03h,0Ah,00h,07Eh,03h,0FAh,0FFh
        db 080h,03h,05h,00h,081h,03h,0Ah,00h,080h,03h,0FAh,0FFh,082h,03h,05h,00h
        db 083h,03h,0Ah,00h,082h,03h,0FAh,0FFh,084h,03h,05h,00h,085h,03h,0Ah,00h
        db 084h,03h,0FAh,0FFh,086h,03h,05h,00h,087h,03h,0Ah,00h,086h,03h,0FAh,0FFh
SPAboardback:                                        ; SPA number 0xF0F
        db 00h,00h,00h,00h,0Ch,00h,016h,00h,020h,00h,02Ah,00h,034h,00h,034h,00h
        db 0B1h,03h,0Ah,00h,089h,03h,0Ah,00h,011h,01h,0Ah,00h,012h,01h,037h,00h
        db 013h,01h,0Ah,00h,050h,01h,0F6h,0FFh,0B4h,03h,0Ah,00h,098h,03h,0Ah,00h
        db 099h,03h,041h,00h,09Ah,03h,0Ah,00h,09Bh,03h,0F6h,0FFh,097h,03h,0Ah,00h
        db 098h,03h,0Ah,00h,099h,03h,041h,00h,09Ah,03h,0Ah,00h,09Bh,03h,0F6h,0FFh
        db 09Ch,03h,0Ah,00h,09Dh,03h,0Ah,00h,09Eh,03h,041h,00h,09Fh,03h,0Ah,00h
        db 0A0h,03h,0F6h,0FFh,0A1h,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h,041h,00h
        db 0A4h,03h,0Ah,00h,0A5h,03h,0F6h,0FFh,0BAh,03h,0Ah,00h,0A2h,03h,0Ah,00h
        db 0A3h,03h,041h,00h,0A4h,03h,0Ah,00h,0A5h,03h,0F6h,0FFh
SPAboardfront:                                        ; SPA number 0xF55
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,01Eh,00h,01Eh,00h,02Ah,00h,034h,00h
        db 088h,03h,0Ah,00h,089h,03h,0Ah,00h,08Ah,03h,041h,00h,08Bh,03h,0Ah,00h
        db 08Ch,03h,0F6h,0FFh,092h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h
        db 095h,03h,0Ah,00h,096h,03h,0F6h,0FFh,0B5h,03h,0Ah,00h,093h,03h,0Ah,00h
        db 094h,03h,041h,00h,095h,03h,0Ah,00h,096h,03h,0F6h,0FFh,0B6h,03h,0Ah,00h
        db 09Dh,03h,0Ah,00h,021h,01h,0Ah,00h,022h,01h,037h,00h,023h,01h,0Ah,00h
        db 054h,01h,0F6h,0FFh,0BBh,03h,0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h,041h,00h
        db 0AEh,03h,0Ah,00h,0AFh,03h,0F6h,0FFh,0ABh,03h,0Ah,00h,0ACh,03h,0Ah,00h
        db 0ADh,03h,041h,00h,0AEh,03h,0Ah,00h,0AFh,03h,0F6h,0FFh
SPAboardright:                                        ; SPA number 0xF9B
        db 00h,00h,0Ah,00h,0Ah,00h,0Ah,00h,016h,00h,020h,00h,02Ah,00h,034h,00h
        db 0B0h,03h,0Ah,00h,0ACh,03h,0Ah,00h,0ADh,03h,041h,00h,0AEh,03h,0Ah,00h
        db 0AFh,03h,0F6h,0FFh,0B3h,03h,0Ah,00h,08Eh,03h,0Ah,00h,019h,01h,0Ah,00h
        db 01Ah,01h,037h,00h,01Bh,01h,0Ah,00h,052h,01h,0F6h,0FFh,0B7h,03h,0Ah,00h
        db 0A2h,03h,0Ah,00h,0A3h,03h,041h,00h,0A4h,03h,0Ah,00h,0A5h,03h,0F6h,0FFh
        db 0A1h,03h,0Ah,00h,0A2h,03h,0Ah,00h,0A3h,03h,041h,00h,0A4h,03h,0Ah,00h
        db 0A5h,03h,0F6h,0FFh,0A6h,03h,0Ah,00h,0A7h,03h,0Ah,00h,0A8h,03h,041h,00h
        db 0A9h,03h,0Ah,00h,0AAh,03h,0F6h,0FFh,0ABh,03h,0Ah,00h,0ACh,03h,0Ah,00h
        db 0ADh,03h,041h,00h,0AEh,03h,0Ah,00h,0AFh,03h,0F6h,0FFh
SPAboardleft:                                        ; SPA number 0xFE1
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,032h,00h,032h,00h
        db 0B2h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h,095h,03h,0Ah,00h
        db 096h,03h,0F6h,0FFh,092h,03h,0Ah,00h,093h,03h,0Ah,00h,094h,03h,041h,00h
        db 095h,03h,0Ah,00h,096h,03h,0F6h,0FFh,08Dh,03h,0Ah,00h,08Eh,03h,0Ah,00h
        db 08Fh,03h,041h,00h,090h,03h,0Ah,00h,091h,03h,0F6h,0FFh,097h,03h,0Ah,00h
        db 098h,03h,0Ah,00h,099h,03h,041h,00h,09Ah,03h,0Ah,00h,09Bh,03h,0F6h,0FFh
        db 0B8h,03h,0Ah,00h,098h,03h,0Ah,00h,099h,03h,041h,00h,09Ah,03h,0Ah,00h
        db 09Bh,03h,0F6h,0FFh,0B9h,03h,0Ah,00h,0A7h,03h,0Ah,00h,029h,01h,0Ah,00h
        db 02Ah,01h,037h,00h,02Bh,01h,0Ah,00h,056h,01h,0F6h,0FFh
SPAbenchcheckr:                                        ; SPA number 0x1027
        db 00h,00h,00h,00h,0Ah,00h,0Ah,00h,012h,00h,012h,00h,01Ch,00h,01Ch,00h
        db 0B0h,03h,0Ah,00h,06Ch,03h,0Ah,00h,06Dh,03h,0Ah,00h,06Eh,03h,0Ah,00h
        db 06Fh,03h,0D8h,0FFh,0B3h,03h,0Ah,00h,0C8h,03h,0Ah,00h,0C9h,03h,0Ah,00h
        db 0CAh,03h,0D8h,0FFh,0B7h,03h,0Ah,00h,0C0h,03h,0Ah,00h,0C1h,03h,0Ah,00h
        db 0C2h,03h,0Ah,00h,0C3h,03h,0D8h,0FFh,0BBh,03h,0Ah,00h,0BCh,03h,0Ah,00h
        db 0BDh,03h,0Ah,00h,0BEh,03h,0Ah,00h,0BFh,03h,0D8h,0FFh
SPAbenchcheckl:                                        ; SPA number 0x1055
        db 00h,00h,00h,00h,0Ah,00h,0Ah,00h,014h,00h,014h,00h,01Eh,00h,01Eh,00h
        db 0B2h,03h,0Ah,00h,070h,03h,0Ah,00h,071h,03h,0Ah,00h,072h,03h,0Ah,00h
        db 073h,03h,0D8h,0FFh,0B5h,03h,0Ah,00h,074h,03h,0Ah,00h,075h,03h,0Ah,00h
        db 076h,03h,0Ah,00h,077h,03h,0D8h,0FFh,0B8h,03h,0Ah,00h,0C4h,03h,0Ah,00h
        db 0C5h,03h,0Ah,00h,0C6h,03h,0Ah,00h,0C7h,03h,0D8h,0FFh,0B9h,03h,0Ah,00h
        db 0CBh,03h,0Ah,00h,0CCh,03h,0Ah,00h,0CDh,03h,0D8h,0FFh
SPArefpenshot:                                        ; SPA number 0x1083
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 04Fh,03h,0Ch,00h,0C7h,02h,0Ch,00h,0C8h,02h,018h,00h,0C7h,02h,08h,00h
        db 04Fh,03h,0F4h,0FFh
SPAgoaliepoke:                                        ; SPA number 0x1095
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 0D2h,03h,04h,00h,0D3h,03h,0Fh,00h,0D2h,03h,0FAh,0FFh,0D4h,03h,04h,00h
        db 0D5h,03h,0Fh,00h,0D4h,03h,0FAh,0FFh,0D6h,03h,04h,00h,0D7h,03h,0Fh,00h
        db 0D6h,03h,0FAh,0FFh,0D8h,03h,04h,00h,0D9h,03h,0Fh,00h,0D8h,03h,0FAh,0FFh
        db 0DAh,03h,04h,00h,0DBh,03h,0Fh,00h,0DAh,03h,0FAh,0FFh,0DCh,03h,04h,00h
        db 0DDh,03h,0Fh,00h,0DCh,03h,0FAh,0FFh,0DEh,03h,04h,00h,0DFh,03h,0Fh,00h
        db 0DEh,03h,0FAh,0FFh,0E0h,03h,04h,00h,0E1h,03h,0Fh,00h,0E0h,03h,0FAh,0FFh
SPAgoalieknee:                                        ; SPA number 0x10CD
        db 00h,00h,0Ch,00h,018h,00h,024h,00h,030h,00h,03Ch,00h,048h,00h,054h,00h
        db 0E2h,03h,06h,00h,0E3h,03h,06h,00h,0E4h,03h,014h,00h,0E3h,03h,06h,00h
        db 0E2h,03h,06h,00h,096h,01h,0F8h,0FFh,0E5h,03h,06h,00h,0E6h,03h,06h,00h
        db 0E7h,03h,014h,00h,0E6h,03h,06h,00h,0E5h,03h,06h,00h,099h,01h,0F8h,0FFh
        db 09Ch,01h,06h,00h,0E8h,03h,06h,00h,0E9h,03h,014h,00h,0E8h,03h,06h,00h
        db 09Ch,01h,04h,00h,09Ch,01h,0FCh,0FFh,09Fh,01h,06h,00h,0EAh,03h,06h,00h
        db 0EBh,03h,014h,00h,0EAh,03h,06h,00h,09Fh,01h,04h,00h,09Fh,01h,0FCh,0FFh
        db 0A2h,01h,06h,00h,0ECh,03h,06h,00h,0EDh,03h,014h,00h,0ECh,03h,06h,00h
        db 0A2h,01h,04h,00h,0A2h,01h,0FCh,0FFh,0A5h,01h,06h,00h,0EEh,03h,06h,00h
        db 0EFh,03h,014h,00h,0EEh,03h,06h,00h,0A5h,01h,04h,00h,0A5h,01h,0FCh,0FFh
        db 0A8h,01h,06h,00h,0F0h,03h,06h,00h,0F1h,03h,014h,00h,0F0h,03h,06h,00h
        db 0A8h,01h,04h,00h,0A8h,01h,0FCh,0FFh,0ABh,01h,06h,00h,0F2h,03h,06h,00h
        db 0F3h,03h,014h,00h,0F2h,03h,06h,00h,0ABh,01h,04h,00h,0ABh,01h,0FCh,0FFh
SPAgokneehold:                                        ; SPA number 0x1135
        db 00h,00h,0Ch,00h,018h,00h,024h,00h,030h,00h,03Ch,00h,048h,00h,054h,00h
        db 0E2h,03h,06h,00h,0E3h,03h,06h,00h,0E4h,03h,05Ah,00h,0E3h,03h,06h,00h
        db 0E2h,03h,06h,00h,096h,01h,0FCh,0FFh,0E5h,03h,06h,00h,0E6h,03h,06h,00h
        db 0E7h,03h,05Ah,00h,0E6h,03h,06h,00h,0E5h,03h,06h,00h,099h,01h,0FCh,0FFh
        db 09Ch,01h,06h,00h,0E8h,03h,06h,00h,0E9h,03h,05Ah,00h,0E8h,03h,06h,00h
        db 09Ch,01h,06h,00h,09Ch,01h,0FCh,0FFh,09Fh,01h,06h,00h,0EAh,03h,06h,00h
        db 0EBh,03h,05Ah,00h,0EAh,03h,06h,00h,09Fh,01h,06h,00h,09Fh,01h,0FCh,0FFh
        db 0A2h,01h,06h,00h,0ECh,03h,06h,00h,0EDh,03h,05Ah,00h,0ECh,03h,06h,00h
        db 0A2h,01h,06h,00h,0A2h,01h,0FCh,0FFh,0A5h,01h,06h,00h,0EEh,03h,06h,00h
        db 0EFh,03h,05Ah,00h,0EEh,03h,06h,00h,0A5h,01h,06h,00h,0A5h,01h,0FCh,0FFh
        db 0A8h,01h,06h,00h,0F0h,03h,06h,00h,0F1h,03h,05Ah,00h,0F0h,03h,06h,00h
        db 0A8h,01h,06h,00h,0A8h,01h,0FCh,0FFh,0ABh,01h,06h,00h,0F2h,03h,06h,00h
        db 0F3h,03h,05Ah,00h,0F2h,03h,06h,00h,0ABh,01h,06h,00h,0ABh,01h,0FCh,0FFh
SPAgofallback:                                        ; SPA number 0x119D
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 0F4h,03h,08h,00h,0F5h,03h,014h,00h,096h,01h,0FCh,0FFh,0F6h,03h,08h,00h
        db 0F7h,03h,014h,00h,099h,01h,0FCh,0FFh,0F8h,03h,08h,00h,0F9h,03h,014h,00h
        db 09Ch,01h,0FCh,0FFh,0FAh,03h,08h,00h,0FBh,03h,014h,00h,09Fh,01h,0FCh,0FFh
        db 0FCh,03h,08h,00h,0FDh,03h,014h,00h,0A2h,01h,0FCh,0FFh,0FEh,03h,08h,00h
        db 0FFh,03h,014h,00h,0A5h,01h,0FCh,0FFh,00h,04h,08h,00h,01h,04h,014h,00h
        db 0A8h,01h,0FCh,0FFh,02h,04h,08h,00h,03h,04h,014h,00h,0ABh,01h,0FCh,0FFh
SPAgofallglove:                                        ; SPA number 0x11D5
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 04h,04h,04h,00h,05h,04h,04h,00h,06h,04h,014h,00h,096h,01h,0FCh,0FFh
        db 07h,04h,04h,00h,08h,04h,04h,00h,09h,04h,014h,00h,099h,01h,0FCh,0FFh
        db 0Ah,04h,04h,00h,0Bh,04h,04h,00h,0Ch,04h,014h,00h,09Ch,01h,0FCh,0FFh
        db 0Dh,04h,04h,00h,0Eh,04h,04h,00h,0Fh,04h,014h,00h,09Fh,01h,0FCh,0FFh
        db 010h,04h,04h,00h,011h,04h,04h,00h,012h,04h,014h,00h,0A2h,01h,0FCh,0FFh
        db 016h,04h,04h,00h,017h,04h,04h,00h,018h,04h,014h,00h,0A8h,01h,0FCh,0FFh
        db 013h,04h,04h,00h,014h,04h,04h,00h,015h,04h,014h,00h,0A5h,01h,0FCh,0FFh
        db 019h,04h,04h,00h,01Ah,04h,04h,00h,01Bh,04h,014h,00h,0ABh,01h,0FCh,0FFh
SPAgofallstick:                                        ; SPA number 0x121D
        db 00h,00h,08h,00h,010h,00h,018h,00h,020h,00h,028h,00h,030h,00h,038h,00h
        db 01Ch,04h,04h,00h,01Dh,04h,04h,00h,01Eh,04h,014h,00h,096h,01h,0FCh,0FFh
        db 01Fh,04h,04h,00h,020h,04h,04h,00h,021h,04h,014h,00h,099h,01h,0FCh,0FFh
        db 022h,04h,04h,00h,023h,04h,04h,00h,024h,04h,014h,00h,09Ch,01h,0FCh,0FFh
        db 025h,04h,04h,00h,026h,04h,04h,00h,027h,04h,014h,00h,09Fh,01h,0FCh,0FFh
        db 028h,04h,04h,00h,029h,04h,04h,00h,02Ah,04h,014h,00h,0A2h,01h,0FCh,0FFh
        db 02Bh,04h,04h,00h,02Ch,04h,04h,00h,02Dh,04h,014h,00h,0A5h,01h,0FCh,0FFh
        db 02Eh,04h,04h,00h,02Fh,04h,04h,00h,0CEh,03h,014h,00h,0A8h,01h,0FCh,0FFh
        db 0CFh,03h,04h,00h,0D0h,03h,04h,00h,0D1h,03h,014h,00h,0ABh,01h,0FCh,0FFh
SPAfakeshotf:                                        ; SPA number 0x1265
        db 00h,00h,0Eh,00h,01Ch,00h,02Ah,00h,038h,00h,046h,00h,054h,00h,062h,00h
        db 063h,00h,04h,00h,062h,00h,04h,00h,061h,00h,04h,00h,060h,00h,04h,00h
        db 061h,00h,04h,00h,062h,00h,04h,00h,00h,00h,0FCh,0FFh,069h,00h,04h,00h
        db 068h,00h,04h,00h,067h,00h,04h,00h,066h,00h,04h,00h,067h,00h,04h,00h
        db 068h,00h,04h,00h,05h,00h,0FCh,0FFh,06Fh,00h,04h,00h,06Eh,00h,04h,00h
        db 06Dh,00h,04h,00h,06Ch,00h,04h,00h,06Dh,00h,04h,00h,06Eh,00h,04h,00h
        db 0Ah,00h,0FCh,0FFh,075h,00h,04h,00h,074h,00h,04h,00h,073h,00h,04h,00h
        db 072h,00h,04h,00h,073h,00h,04h,00h,074h,00h,04h,00h,0Fh,00h,0FCh,0FFh
        db 07Bh,00h,04h,00h,07Ah,00h,04h,00h,079h,00h,04h,00h,078h,00h,04h,00h
        db 079h,00h,04h,00h,07Ah,00h,04h,00h,014h,00h,0FCh,0FFh,081h,00h,04h,00h
        db 080h,00h,04h,00h,07Fh,00h,04h,00h,07Eh,00h,04h,00h,07Fh,00h,04h,00h
        db 080h,00h,04h,00h,019h,00h,0FCh,0FFh,087h,00h,04h,00h,086h,00h,04h,00h
        db 085h,00h,04h,00h,084h,00h,04h,00h,085h,00h,04h,00h,086h,00h,04h,00h
        db 01Eh,00h,0FCh,0FFh,08Dh,00h,04h,00h,08Ch,00h,04h,00h,08Bh,00h,04h,00h
        db 08Ah,00h,04h,00h,08Bh,00h,04h,00h,08Ch,00h,04h,00h,023h,00h,0FCh,0FFh
SPAfakeshotb:                                        ; SPA number 0x12DD
        db 00h,00h,0Eh,00h,01Ch,00h,02Ah,00h,038h,00h,046h,00h,054h,00h,062h,00h
        db 063h,00h,04h,00h,064h,00h,04h,00h,065h,00h,04h,00h,065h,00h,04h,00h
        db 065h,00h,04h,00h,064h,00h,04h,00h,00h,00h,0FCh,0FFh,069h,00h,04h,00h
        db 06Ah,00h,04h,00h,06Bh,00h,04h,00h,06Bh,00h,04h,00h,06Bh,00h,04h,00h
        db 06Ah,00h,04h,00h,05h,00h,0FCh,0FFh,06Fh,00h,04h,00h,070h,00h,04h,00h
        db 071h,00h,04h,00h,071h,00h,04h,00h,071h,00h,04h,00h,070h,00h,04h,00h
        db 0Ah,00h,0FCh,0FFh,075h,00h,04h,00h,076h,00h,04h,00h,077h,00h,04h,00h
        db 077h,00h,04h,00h,077h,00h,04h,00h,076h,00h,04h,00h,0Fh,00h,0FCh,0FFh
        db 07Bh,00h,04h,00h,07Ch,00h,04h,00h,07Dh,00h,04h,00h,07Dh,00h,04h,00h
        db 07Dh,00h,04h,00h,07Ch,00h,04h,00h,014h,00h,0FCh,0FFh,081h,00h,04h,00h
        db 082h,00h,04h,00h,083h,00h,04h,00h,083h,00h,04h,00h,083h,00h,04h,00h
        db 082h,00h,04h,00h,019h,00h,0FCh,0FFh,087h,00h,04h,00h,088h,00h,04h,00h
        db 089h,00h,04h,00h,089h,00h,04h,00h,089h,00h,04h,00h,088h,00h,04h,00h
        db 01Eh,00h,0FCh,0FFh,08Dh,00h,04h,00h,08Eh,00h,04h,00h,08Fh,00h,04h,00h
        db 08Fh,00h,04h,00h,08Fh,00h,04h,00h,08Eh,00h,04h,00h,023h,00h,0FCh,0FFh
SPAfakeonetimef:                                        ; SPA number 0x1355
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 061h,00h,018h,00h,062h,00h,04h,00h,00h,00h,0FCh,0FFh,067h,00h,018h,00h
        db 068h,00h,04h,00h,05h,00h,0FCh,0FFh,06Dh,00h,018h,00h,06Eh,00h,04h,00h
        db 0Ah,00h,0FCh,0FFh,073h,00h,018h,00h,074h,00h,04h,00h,0Fh,00h,0FCh,0FFh
        db 079h,00h,018h,00h,07Ah,00h,04h,00h,014h,00h,0FCh,0FFh,07Fh,00h,018h,00h
        db 080h,00h,04h,00h,019h,00h,0FCh,0FFh,085h,00h,018h,00h,086h,00h,04h,00h
        db 01Eh,00h,0FCh,0FFh,08Bh,00h,018h,00h,08Ch,00h,04h,00h,023h,00h,0FCh,0FFh
SPAfakeonetimeb:                                        ; SPA number 0x138D
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 065h,00h,018h,00h,064h,00h,04h,00h,00h,00h,0FCh,0FFh,06Bh,00h,018h,00h
        db 06Ah,00h,04h,00h,05h,00h,0FCh,0FFh,071h,00h,018h,00h,070h,00h,04h,00h
        db 0Ah,00h,0FCh,0FFh,077h,00h,018h,00h,076h,00h,04h,00h,0Fh,00h,0FCh,0FFh
        db 07Dh,00h,018h,00h,07Ch,00h,04h,00h,014h,00h,0FCh,0FFh,083h,00h,018h,00h
        db 082h,00h,04h,00h,019h,00h,0FCh,0FFh,089h,00h,018h,00h,088h,00h,04h,00h
        db 01Eh,00h,0FCh,0FFh,08Fh,00h,018h,00h,08Eh,00h,04h,00h,023h,00h,0FCh,0FFh
SPAblockleft:                                        ; SPA number 0x13C5
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 030h,04h,08h,00h,031h,04h,018h,00h,03Bh,01h,08h,00h,052h,01h,08h,00h
        db 02Dh,00h,0FCh,0FFh,032h,04h,08h,00h,033h,04h,018h,00h,03Fh,01h,08h,00h
        db 053h,01h,08h,00h,032h,00h,0FCh,0FFh,034h,04h,08h,00h,035h,04h,018h,00h
        db 043h,01h,08h,00h,054h,01h,08h,00h,037h,00h,0FCh,0FFh,036h,04h,08h,00h
        db 037h,04h,018h,00h,047h,01h,08h,00h,055h,01h,08h,00h,03Ch,00h,0FCh,0FFh
        db 038h,04h,08h,00h,039h,04h,018h,00h,04Bh,01h,08h,00h,056h,01h,08h,00h
        db 041h,00h,0FCh,0FFh,03Ah,04h,08h,00h,03Bh,04h,018h,00h,04Fh,01h,08h,00h
        db 057h,01h,08h,00h,046h,00h,0FCh,0FFh,03Ch,04h,08h,00h,03Dh,04h,018h,00h
        db 033h,01h,08h,00h,050h,01h,08h,00h,04Bh,00h,0FCh,0FFh,03Eh,04h,08h,00h
        db 03Fh,04h,018h,00h,037h,01h,08h,00h,051h,01h,08h,00h,028h,00h,0FCh,0FFh
SPAblockright:                                        ; SPA number 0x141D
        db 00h,00h,0Ah,00h,014h,00h,01Eh,00h,028h,00h,032h,00h,03Ch,00h,046h,00h
        db 040h,04h,08h,00h,041h,04h,018h,00h,04Bh,01h,08h,00h,056h,01h,08h,00h
        db 04Bh,00h,0FCh,0FFh,042h,04h,08h,00h,043h,04h,018h,00h,04Fh,01h,08h,00h
        db 057h,01h,08h,00h,028h,00h,0FCh,0FFh,044h,04h,08h,00h,045h,04h,018h,00h
        db 033h,01h,08h,00h,050h,01h,08h,00h,02Dh,00h,0FCh,0FFh,046h,04h,08h,00h
        db 047h,04h,018h,00h,037h,01h,08h,00h,051h,01h,08h,00h,032h,00h,0FCh,0FFh
        db 048h,04h,08h,00h,049h,04h,018h,00h,03Bh,01h,08h,00h,052h,01h,08h,00h
        db 037h,00h,0FCh,0FFh,04Ah,04h,08h,00h,04Bh,04h,018h,00h,03Fh,01h,08h,00h
        db 053h,01h,08h,00h,03Ch,00h,0FCh,0FFh,04Ch,04h,08h,00h,04Dh,04h,018h,00h
        db 043h,01h,08h,00h,054h,01h,08h,00h,041h,00h,0FCh,0FFh,04Eh,04h,08h,00h
        db 04Fh,04h,018h,00h,047h,01h,08h,00h,055h,01h,08h,00h,046h,00h,0FCh,0FFh
SPAblockfront:                                        ; SPA number 0x1475
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 050h,04h,08h,00h,051h,04h,014h,00h,050h,04h,0F8h,0FFh,053h,04h,08h,00h
        db 054h,04h,014h,00h,053h,04h,0F8h,0FFh,056h,04h,08h,00h,057h,04h,014h,00h
        db 056h,04h,0F8h,0FFh,059h,04h,08h,00h,05Ah,04h,014h,00h,059h,04h,0F8h,0FFh
        db 05Ch,04h,08h,00h,05Dh,04h,014h,00h,05Ch,04h,0F8h,0FFh,05Fh,04h,08h,00h
        db 060h,04h,014h,00h,05Fh,04h,0F8h,0FFh,062h,04h,08h,00h,062h,04h,014h,00h
        db 062h,04h,0F8h,0FFh,065h,04h,08h,00h,066h,04h,014h,00h,065h,04h,0F8h,0FFh
SPAblockknee:                                        ; SPA number 0x14AD
        db 00h,00h,06h,00h,0Ch,00h,012h,00h,018h,00h,01Eh,00h,024h,00h,02Ah,00h
        db 051h,04h,08h,00h,052h,04h,018h,00h,051h,04h,0F8h,0FFh,054h,04h,08h,00h
        db 055h,04h,018h,00h,054h,04h,0F8h,0FFh,057h,04h,08h,00h,058h,04h,018h,00h
        db 057h,04h,0F8h,0FFh,05Ah,04h,08h,00h,05Bh,04h,018h,00h,05Ah,04h,0F8h,0FFh
        db 05Dh,04h,08h,00h,05Eh,04h,018h,00h,05Dh,04h,0F8h,0FFh,060h,04h,08h,00h
        db 061h,04h,018h,00h,060h,04h,0F8h,0FFh,062h,04h,08h,00h,064h,04h,018h,00h
        db 062h,04h,0F8h,0FFh,065h,04h,08h,00h,067h,04h,018h,00h,065h,04h,0F8h,0FFh
SPArefelbow:                                        ; SPA number 0x14E5
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 0C1h,02h,0Ch,00h,068h,04h,0Ah,00h,069h,04h,0Ah,00h,06Ah,04h,018h,00h
        db 068h,04h,0Ch,00h,0C1h,02h,0F4h,0FFh,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,0C1h,02h,0Ch,00h,06Bh,04h,0Ah,00h
        db 06Ch,04h,0Ah,00h,06Dh,04h,018h,00h,06Bh,04h,0Ch,00h,0C1h,02h,0F4h
