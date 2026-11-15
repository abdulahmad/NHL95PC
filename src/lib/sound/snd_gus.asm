; The Gravis Ultrasound driver.
bits 32
%include "hockey.inc"
section s_9FFCA progbits alloc exec nowrite align=1
extern __CHK, __GETDS, str_PAT, str_ULTRADIR, str_MIDI, str_CULTRASNDMIDI, byte_F5320, byte_F5321
extern cliprect_x0, cliprect_x1, dword_D30A4, dword_D30A8, dword_D4F9A, dword_D53A0, dword_D53A4, dword_D53A8
extern dword_D53AC, dword_D53B0, dword_D53B4, dword_D5424, dword_D543C, dword_F371E, dword_F532A, dword_F5332
extern dword_F558C, dword_F55E4, dword_F55E8, dword_F55EC, dword_F55F0, dword_F55F4, dword_F58D0, fputchar
extern getenv_, int386x_, memcpy_, memset_, strcat_, strcpy_, sub_8F0D7, PrintString
extern sub_AA210, sub_AA300, sub_AAB5C, sub_AAC48, sub_AB79C, sub_AC0CC, sub_AC6E8, sub_AD298
extern sub_AD4DC, sub_AD6F4, sub_AE9EB, sub_AEA23, sub_AEDBC, sub_AEE54, sub_AEF0E, sub_AEF33
extern sub_AEFA2, sub_AEFC9, sub_AEFEA, sub_AF076, sub_AF0D5, sub_AF112, sub_AF198, sub_AF1A4
extern sub_AF1D0, sub_AF2E0, sub_AF340, sub_AF428, SetClipWindow, sub_B6F84, unk_D5382, unk_D5408
extern unk_F21FC, unk_F53AC, unk_F55F8, word_F371C, word_F531C, word_F531E, word_F5324, word_F5326
extern word_F53B0, word_F53C2, word_F58D2, word_F58D4, word_F58D6
global sub_9FFCA, loc_A004D, sub_A0064, sub_A00C1, loc_A00F7, loc_A0102, loc_A0107, loc_A0124
global loc_A013D, loc_A014B, loc_A0200, loc_A020C, loc_A0215, loc_A021C, loc_A027D, loc_A027F
global sub_A0288, loc_A0301, loc_A0308, loc_A0340, loc_A0358, loc_A0396, loc_A03D6, loc_A03DE
global loc_A03E3, loc_A0416, loc_A041D, loc_A0425, loc_A042A, loc_A0444, sub_A044D, loc_A0477
global loc_A0479, loc_A0482, loc_A0484, loc_A048D, loc_A048F, loc_A04B2, sub_A04B9, loc_A04FD
global loc_A0507, loc_A0521, loc_A052B, loc_A0532, sub_A053C, sub_A054C, loc_A056E, loc_A0591
global sub_A059B, sub_A05AB, loc_A05CE, sub_A05D3, sub_A05E3, loc_A0606, sub_A060B, sub_A061B
global loc_A063E, sub_A0643, sub_A0653, loc_A0676, sub_A067B, sub_A068B, loc_A06A4, loc_A06AC
global loc_A06B4, loc_A06EB, loc_A0700, loc_A0707, loc_A0709, loc_A0710, loc_A0718, loc_A071D
global loc_A0760, loc_A0762, sub_A076E, sub_A077E, loc_A07C2, loc_A07D2, loc_A07D4, loc_A07DD
global loc_A07E7, loc_A07FB, loc_A080F, loc_A0833, loc_A083A, loc_A083C, loc_A0843, sub_A0853
global sub_A0863, sub_A0886, sub_A0896, loc_A08D2, sub_A08D7, loc_A0950, loc_A0959, loc_A0979
global sub_A0981, sub_A09B9, sub_A0A08, sub_A0BAC, sub_A0C5B, loc_A0CDA, loc_A0CE1, sub_A0D0C
global sub_A0D43, loc_A0D92, sub_A0D99, sub_A0DA9, loc_A0DF7, loc_A0E03, loc_A0E0B, loc_A0E43
global loc_A0E4A, loc_A0E62, loc_A0EC5, loc_A0ECA, loc_A0EE1, loc_A0EE6, loc_A0EFF, loc_A0F1E
global loc_A0F5A, loc_A0F7B, loc_A0F7D, loc_A0F98, loc_A0FBC, loc_A0FBE, loc_A0FD7, loc_A0FDC
global sub_A0FEA, sub_A0FFA, loc_A1048, loc_A1054, loc_A105C, loc_A1094, loc_A109B, loc_A10B3
global loc_A1116, loc_A111B, loc_A1132, loc_A1137, loc_A1151, loc_A1171, loc_A1191, loc_A1193
global loc_A11B5, loc_A11CC, loc_A11EB, loc_A11F0, sub_A11FE, loc_A1245, loc_A124A, loc_A1269
global loc_A126F, loc_A1283, loc_A1288, loc_A12A4, loc_A12B0, loc_A12B8, loc_A12F5, loc_A12F7
global loc_A1307, loc_A132D, loc_A132F, loc_A133B, loc_A133D, loc_A135F, loc_A1364, loc_A1375
global loc_A138D, loc_A13C8, loc_A13D1, loc_A13DB, loc_A13DD, loc_A1412, loc_A143D, loc_A1446
global loc_A1450, loc_A1452, loc_A1484, loc_A14A8, sub_A14AF, loc_A14F6, loc_A1502, loc_A150A
global loc_A1548, loc_A154A, loc_A155F, loc_A159B, loc_A159D, loc_A15A2, sub_A15AA, sub_A1632
global loc_A1696, loc_A169B, loc_A16B5, loc_A16BA, loc_A16C8, loc_A16D6, loc_A16E4, loc_A1715
global loc_A171E, loc_A1726, loc_A1753, loc_A1755, loc_A1757, loc_A176D, loc_A1776, loc_A1780
global loc_A17A5, loc_A17A7, loc_A17BD, loc_A17C6, loc_A17D0, loc_A17F7, loc_A17F9, sub_A1800
global sub_A1840, sub_A185C
sub_9FFCA:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 30h
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte ebp-014h]
        call memset_
        mov word [byte ebp-030h], 100h
        mov word [byte ebp-02Ch], 100h
        lea ecx, [byte ebp-014h]
        lea ebx, [byte ebp-030h]
        lea edx, [byte ebp-030h]
        mov eax, 31h
        call int386x_
        xor eax, eax
        mov ax, word [byte ebp-030h]
        mov dword [dword_F55EC], eax
        xor eax, eax
        mov ax, word [byte ebp-024h]
        mov dword [dword_F55F0], eax
        mov eax, dword [dword_F55EC]
        shl eax, 4
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-04h]
        add eax, 7FFh
        xor ax, ax
        mov edx, dword [byte ebp-04h]
        xor dx, dx
        cmp edx, eax
        je short loc_A004D
        add dword [byte ebp-04h], 800h
loc_A004D:
        mov eax, dword [byte ebp-04h]
        add eax, 0FFFFh
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-08h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A0064:
        push dword 44h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov ebx, 0Ch
        xor edx, edx
        lea eax, [byte ebp-0Ch]
        call memset_
        mov word [byte ebp-028h], 101h
        mov ax, word [dword_F55F0]
        mov word [byte ebp-01Ch], ax
        lea ecx, [byte ebp-0Ch]
        lea ebx, [byte ebp-028h]
        lea edx, [byte ebp-028h]
        mov eax, 31h
        call int386x_
        mov dword [dword_D53A4], 0
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A00C1:
        push dword 15Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 134h
        mov dword [byte ebp-018h], 0
        mov eax, dword [dword_F55F4]
        mov dword [byte ebp-024h], eax
        mov eax, dword [dword_F55F4]
        mov dword [byte ebp-020h], eax
        mov dword [byte ebp-04h], 0
loc_A00F7:
        cmp dword [byte ebp-04h], 100h
        jl short loc_A0107
        jmp short loc_A0124
loc_A0102:
        inc dword [byte ebp-04h]
        jmp short loc_A00F7
loc_A0107:
        imul eax, dword [byte ebp-04h], byte 1Ch
        mov word [dword eax+word_F371C], 0
        imul eax, dword [byte ebp-04h], byte 1Ch
        mov dword [dword eax+dword_F371E], 0
        jmp short loc_A0102
loc_A0124:
        mov cl, byte [dword_F55E4]
        mov eax, 1
        shl eax, cl
        test dword [dword_D543C], eax
        jne short loc_A013D
        or byte [byte ebp-018h], 1
loc_A013D:
        mov dword [byte ebp-014h], unk_D5408
        mov dword [byte ebp-010h], 0
loc_A014B:
        mov eax, dword [byte ebp-014h]
        cmp dword [eax], byte 0FFFFFFFFh
        je near loc_A0215
        mov edx, str_CULTRASNDMIDI
        lea eax, [byte ebp-074h]
        call strcpy_
        mov edx, dword [byte ebp-014h]
        add edx, byte 4
        lea eax, [byte ebp-074h]
        call strcat_
        mov edx, str_PAT
        lea eax, [byte ebp-074h]
        call strcat_
        lea edx, [dword ebp-0134h]
        lea eax, [byte ebp-074h]
        call sub_AA210
        test eax, eax
        jne near loc_A020C
        xor eax, eax
        mov ax, word [dword ebp-0DFh]
        add eax, dword [byte ebp-010h]
        cmp eax, byte 0Ah
        jge short loc_A0215
        mov eax, dword [byte ebp-014h]
        mov eax, dword [eax]
        mov dword [byte ebp-01Ch], eax
        push dword [byte ebp-018h]
        imul edx, dword [byte ebp-010h], byte 49h
        mov eax, unk_F55F8
        add eax, edx
        push eax
        mov eax, 800h
        push eax
        lea ecx, [byte ebp-024h]
        imul ebx, dword [byte ebp-01Ch], byte 1Ch
        mov eax, word_F371C
        add ebx, eax
        lea edx, [dword ebp-0134h]
        lea eax, [byte ebp-074h]
        call sub_AA300
        test eax, eax
        je short loc_A0200
        imul eax, dword [byte ebp-01Ch], byte 1Ch
        mov word [dword eax+word_F371C], 0
        imul eax, dword [byte ebp-01Ch], byte 1Ch
        mov dword [dword eax+dword_F371E], 0
        jmp short loc_A020C
loc_A0200:
        xor eax, eax
        mov ax, word [dword ebp-0DFh]
        add dword [byte ebp-010h], eax
loc_A020C:
        add dword [byte ebp-014h], byte 0Eh
        jmp near loc_A014B
loc_A0215:
        mov dword [byte ebp-04h], 0
loc_A021C:
        mov eax, dword [byte ebp-04h]
        shl eax, 2
        cmp dword [dword eax+dword_D5424], byte 0FFFFFFFFh
        je short loc_A027F
        mov eax, dword [byte ebp-04h]
        inc dword [byte ebp-04h]
        shl eax, 2
        mov eax, dword [dword eax+dword_D5424]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-04h]
        inc dword [byte ebp-04h]
        shl eax, 2
        mov eax, dword [dword eax+dword_D5424]
        mov dword [byte ebp-0Ch], eax
        imul eax, dword [byte ebp-08h], byte 1Ch
        cmp word [dword eax+word_F371C], byte 0
        jne short loc_A027D
        mov ebx, 1Ch
        imul edx, dword [byte ebp-0Ch], byte 1Ch
        mov eax, word_F371C
        add edx, eax
        imul eax, dword [byte ebp-08h], byte 1Ch
        mov ecx, word_F371C
        add eax, ecx
        call memcpy_
loc_A027D:
        jmp short loc_A021C
loc_A027F:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A0288:
        push dword 38h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        cmp dword [dword_D53A8], byte 0
        jne near loc_A0444
        push byte 0
        call sub_A04B9
        add esp, byte 4
        test ax, ax
        je near loc_A0444
        call sub_9FFCA
        mov dword [dword_F55F4], eax
        mov word [word_F531C], 1Ch
        cmp byte [byte_F5320], 7
        jbe short loc_A0308
        cmp byte [byte_F5321], 7
        ja short loc_A0301
        mov al, byte [byte_F5321]
        mov byte [byte ebp-04h], al
        mov al, byte [byte_F5320]
        mov byte [byte_F5321], al
        mov al, byte [byte ebp-04h]
        mov byte [byte_F5320], al
        jmp short loc_A0308
loc_A0301:
        mov byte [byte_F5320], 5
loc_A0308:
        mov eax, word_F531C
        call sub_AAB5C
        test eax, eax
        jne near loc_A0444
        mov eax, 7Fh
        call sub_AB79C
        mov dword [dword_D53A8], 1
        mov dword [dword_F55E4], 0
        call sub_AD6F4
        mov dword [byte ebp-08h], eax
loc_A0340:
        cmp dword [byte ebp-08h], 40000h
        jle short loc_A0358
        inc dword [dword_F55E4]
        sub dword [byte ebp-08h], 40000h
        jmp short loc_A0340
loc_A0358:
        mov eax, 801h
        call sub_AD4DC
        mov dword [dword_F55E8], eax
        mov eax, str_ULTRADIR
        call getenv_
        mov dword [byte ebp-010h], eax
        cmp dword [byte ebp-010h], byte 0
        je short loc_A0396
        mov edx, dword [byte ebp-010h]
        mov eax, str_CULTRASNDMIDI
        call strcpy_
        mov edx, str_MIDI
        mov eax, str_CULTRASNDMIDI
        call strcat_
loc_A0396:
        call sub_A00C1
        push dword 800h
        push dword [dword_F55E8]
        push dword [dword_F55F4]
        call sub_AEA23
        add esp, byte 0Ch
        mov word [word_F58D4], 0Fh
        mov word [word_F58D6], 0
        mov word [word_F58D2], 0
        mov dword [byte ebp-0Ch], 0
loc_A03D6:
        cmp dword [byte ebp-0Ch], byte 4
        jl short loc_A03E3
        jmp short loc_A0416
loc_A03DE:
        inc dword [byte ebp-0Ch]
        jmp short loc_A03D6
loc_A03E3:
        mov cl, byte [byte ebp-0Ch]
        mov eax, 1
        shl eax, cl
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov word [dword edx+word_F5324], ax
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov eax, dword [byte ebp-0Ch]
        mov word [dword edx+word_F5326], ax
        imul edx, dword [byte ebp-0Ch], byte 22h
        mov dword [dword edx+dword_F5332], unk_D5382
        jmp short loc_A03DE
loc_A0416:
        mov dword [byte ebp-0Ch], 0
loc_A041D:
        cmp dword [byte ebp-0Ch], byte 10h
        jl short loc_A042A
        jmp short loc_A0444
loc_A0425:
        inc dword [byte ebp-0Ch]
        jmp short loc_A041D
loc_A042A:
        imul esi, dword [byte ebp-0Ch], byte 1Eh
        mov ecx, 7
        lea edi, [dword esi+unk_F53AC]
        mov esi, unk_D5382
        rep movsd
        movsw
        jmp short loc_A0425
loc_A0444:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A044D:
        push dword 1Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53A8], byte 0
        je short loc_A0477
        cmp dword [dword_D53B4], byte 0
        je short loc_A0479
loc_A0477:
        jmp short loc_A0482
loc_A0479:
        cmp dword [dword_D53B0], byte 0
        je short loc_A0484
loc_A0482:
        jmp short loc_A048D
loc_A0484:
        cmp dword [dword_D53AC], byte 0
        je short loc_A048F
loc_A048D:
        jmp short loc_A04B2
loc_A048F:
        call sub_AAC48
        call sub_A0064
        mov dword [dword_D53A4], 0
        mov dword [dword_D53A8], 0
        call sub_AEDBC
loc_A04B2:
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A04B9:
        push dword 18h
        call __CHK
        push ds
        call __GETDS
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        cmp dword [dword_D53A4], byte 0
        jne short loc_A052B
        cmp dword [dword_D53A0], byte 0
        jne short loc_A0507
        mov eax, word_F531C
        call sub_AF1D0
        test eax, eax
        jne short loc_A04FD
        mov dword [byte ebp-04h], 0
        jmp short loc_A0532
loc_A04FD:
        mov dword [dword_D53A0], 1
loc_A0507:
        xor eax, eax
        mov ax, word [word_F531E]
        call sub_AF2E0
        test eax, eax
        jne short loc_A0521
        mov dword [byte ebp-04h], 0
        jmp short loc_A0532
loc_A0521:
        mov dword [dword_D53A4], 1
loc_A052B:
        mov dword [byte ebp-04h], 1
loc_A0532:
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A053C:
        push dword 18h
        call __CHK
        push ds
        call __GETDS
sub_A054C:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        mov eax, word_F531C
        call sub_AF1D0
        test eax, eax
        jne short loc_A056E
        mov dword [byte ebp-04h], 0
        jmp short loc_A0591
loc_A056E:
        mov dword [dword_D53A0], 1
        xor eax, eax
        mov al, byte [byte_F5320]
        shl eax, 10h
        mov edx, eax
        xor eax, eax
        mov ax, word [word_F531E]
        or edx, eax
        mov dword [byte ebp-04h], edx
loc_A0591:
        mov eax, dword [byte ebp-04h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A059B:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
sub_A05AB:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53B4], byte 0
        jne short loc_A05CE
        call sub_A0288
        mov dword [dword_D53B4], 1
loc_A05CE:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A05D3:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
sub_A05E3:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53B0], byte 0
        jne short loc_A0606
        call sub_A0288
        mov dword [dword_D53B0], 1
loc_A0606:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A060B:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
sub_A061B:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53B4], byte 0
        je short loc_A063E
        mov dword [dword_D53B4], 0
        call sub_A044D
loc_A063E:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A0643:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
sub_A0653:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53B0], byte 0
        je short loc_A0676
        mov dword [dword_D53B0], 0
        call sub_A044D
loc_A0676:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A067B:
        push dword 3Ch
        call __CHK
        push ds
        call __GETDS
sub_A068B:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 14h
        mov dword [byte ebp-0Ch], 0
        mov dword [byte ebp-04h], 1
loc_A06A4:
        cmp dword [byte ebp-0Ch], byte 4
        jl short loc_A06B4
        jmp short loc_A0709
loc_A06AC:
        inc dword [byte ebp-0Ch]
        shl dword [byte ebp-04h], 1
        jmp short loc_A06A4
loc_A06B4:
        imul eax, dword [byte ebp-0Ch], byte 22h
        mov edx, word_F5324
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        mov eax, dword [word_F58D2-2]
        sar eax, 10h
        test edx, eax
        je short loc_A06EB
        push dword [byte ebp-0Ch]
        call sub_AEF0E
        add esp, byte 4
        test eax, eax
        je short loc_A06EB
        mov eax, dword [byte ebp-08h]
        call sub_A15AA
loc_A06EB:
        mov eax, dword [byte ebp-08h]
        cmp word [byte eax+06h], byte 1
        jge short loc_A0700
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+06h], 0
        jmp short loc_A0707
loc_A0700:
        mov eax, dword [byte ebp-08h]
        dec word [byte eax+06h]
loc_A0707:
        jmp short loc_A06AC
loc_A0709:
        mov dword [byte ebp-0Ch], 0
loc_A0710:
        cmp dword [byte ebp-0Ch], byte 4
        jl short loc_A071D
        jmp short loc_A0762
loc_A0718:
        inc dword [byte ebp-0Ch]
        jmp short loc_A0710
loc_A071D:
        imul eax, dword [byte ebp-0Ch], byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-010h], edx
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+0Ah], byte 0
        je short loc_A0760
        mov eax, dword [byte ebp-010h]
        mov eax, dword [eax]
        mov dword [byte ebp-014h], eax
        mov eax, dword [byte ebp-010h]
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        push eax
        push byte 0
        push byte 0
        push dword [byte ebp-0Ch]
        call sub_AF112
        add esp, byte 14h
loc_A0760:
        jmp short loc_A0718
loc_A0762:
        call sub_AE9EB
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A076E:
        push dword 28h
        call __CHK
        push ds
        call __GETDS
sub_A077E:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        cmp dword [dword_D53A8], byte 0
        je near loc_A083C
        mov eax, dword [byte ebp+014h]
        mov dword [byte ebp-0Ch], eax
        cmp word [byte ebp-0Ch], byte 9
        jb short loc_A07C2
        cmp word [byte ebp-0Ch], byte 9
        jbe short loc_A07E7
        cmp word [byte ebp-0Ch], byte 0Ah
        jbe short loc_A07FB
        cmp word [byte ebp-0Ch], byte 32h
        je short loc_A080F
        jmp near loc_A0833
        jmp near loc_A0833
loc_A07C2:
        cmp word [byte ebp-0Ch], byte 7
        jb short loc_A07D2
        cmp word [byte ebp-0Ch], byte 7
        jbe short loc_A07D4
        jmp short loc_A07DD
loc_A07D2:
        jmp short loc_A0833
loc_A07D4:
        mov dword [byte ebp-04h], 56h
        jmp short loc_A083A
loc_A07DD:
        call sub_AF198
        mov dword [byte ebp-04h], eax
        jmp short loc_A083A
loc_A07E7:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        push eax
        call sub_AEF0E
        add esp, byte 4
        mov dword [byte ebp-04h], eax
        jmp short loc_A083A
loc_A07FB:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        push eax
        call sub_AF1A4
        add esp, byte 4
        mov dword [byte ebp-04h], eax
        jmp short loc_A083A
loc_A080F:
        mov eax, dword [byte ebp+014h]
        sar eax, 10h
        and eax, 0FFh
        push eax
        mov eax, dword [byte ebp+014h]
        sar eax, 18h
        push eax
        call sub_AEFEA
        add esp, byte 8
        mov dword [byte ebp-04h], 0FFFFFFFFh
        jmp short loc_A083A
loc_A0833:
        mov dword [byte ebp-04h], 0FFFFFFFFh
loc_A083A:
        jmp short loc_A0843
loc_A083C:
        mov dword [byte ebp-04h], 0FFFFFFFFh
loc_A0843:
        mov eax, dword [byte ebp-04h]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-08h]
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A0853:
        push dword 14h
        call __CHK
        push ds
        call __GETDS
sub_A0863:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        mov edx, dword [byte ebp+012h]
        sar edx, 10h
        imul edx, byte 1Eh
        mov eax, dword [byte ebp+018h]
        mov word [dword edx+word_F53B0], ax
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A0886:
        push dword 34h
        call __CHK
        push ds
        call __GETDS
sub_A0896:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0
        cmp dword [dword_D53A8], byte 0
        je short loc_A08D2
        push dword [byte ebp+034h]
        push dword [byte ebp+030h]
        push dword [byte ebp+02Ch]
        push dword [byte ebp+028h]
        push dword [byte ebp+024h]
        push dword [byte ebp+020h]
        mov eax, dword [byte ebp+018h]
        add eax, dword [byte ebp+01Ch]
        push eax
        mov eax, dword [byte ebp+012h]
        sar eax, 10h
        push eax
        call sub_AEE54
        add esp, byte 20h
loc_A08D2:
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A08D7:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 0Ch
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], edx
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        imul edx, eax, byte 1Eh
        mov eax, unk_F53AC
        add eax, edx
        mov dword [byte ebp-0Ch], eax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        call sub_8F0D7
        mov edx, eax
        add esp, byte 4
        mov eax, dword [byte ebp-0Ch]
        mov dword [byte eax+0Eh], edx
        mov eax, dword [byte ebp-0Ch]
        cmp dword [byte eax+0Eh], byte 0
        je short loc_A0979
        mov eax, dword [byte ebp-0Ch]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte eax+010h]
        mov eax, dword [byte ebp-0Ch]
        mov dword [byte eax+0Ah], edx
        cmp word [byte ebp-08h], byte 9
        je short loc_A0950
        mov eax, dword [byte ebp-0Ch]
        mov eax, dword [byte eax+0Eh]
        xor edx, edx
        mov dl, byte [byte eax+06h]
        mov eax, dword [byte ebp-0Ch]
        mov word [byte eax+08h], dx
        jmp short loc_A0959
loc_A0950:
        mov eax, dword [byte ebp-0Ch]
        mov word [byte eax+08h], 4
loc_A0959:
        mov edx, dword [byte ebp-0Ch]
        mov eax, dword [byte edx+0Eh]
        mov ax, word [byte eax+02h]
        and eax, 0Fh
        mov edx, dword [byte ebp-0Ch]
        mov word [byte edx+04h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-0Ch]
        mov word [byte edx+06h], ax
loc_A0979:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_A0981:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], edx
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        imul edx, byte 1Eh
        mov eax, dword [byte ebp-04h]
        mov word [dword edx+word_F53C2], ax
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_A09B9:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-08h], edx
        mov eax, dword [byte ebp-08h]
        mov word [byte eax+0Ah], 0
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        push eax
        call sub_AEFC9
        add esp, byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A0A08:
        push dword 24h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        mov dword [byte ebp-04h], ebx
        mov dword [byte ebp-010h], ecx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A09B9
        mov eax, dword [byte ebp+010h]
        mov dx, word [eax]
        not edx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+0Eh]
        and word [eax], dx
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte ebp+010h]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp+010h]
        mov dword [byte edx+0Eh], eax
        mov eax, dword [byte ebp-010h]
        mov dx, word [byte eax+06h]
        mov eax, dword [byte ebp+010h]
        mov word [byte eax+0Ch], dx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte eax+0Ah]
        mov eax, dword [byte ebp+010h]
        mov dword [byte eax+012h], edx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte eax+0Eh]
        mov eax, dword [byte ebp+010h]
        mov dword [byte eax+016h], edx
        mov edx, dword [byte ebp+010h]
        mov edx, dword [byte edx+016h]
        xor eax, eax
        mov al, byte [byte edx+0Dh]
        cwde
        push eax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        movsx ax, byte [byte eax+0Ah]
        movsx ecx, ax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        movsx ax, byte [byte eax+08h]
        movsx ebx, ax
        mov edx, dword [byte ebp+010h]
        mov edx, dword [byte edx+012h]
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A0BAC
        mov eax, dword [byte ebp+010h]
        mov eax, dword [byte eax+016h]
        mov al, byte [byte eax+0Ch]
        xor ah, ah
        mov edx, dword [byte ebp+010h]
        shl eax, 6
        mov word [byte edx+06h], ax
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp+010h]
        mov word [byte edx+08h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp+010h]
        mov word [byte edx+0Ah], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        and word [word_F58D4], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        or word [word_F58D6], ax
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        and word [word_F58D2], ax
        mov eax, dword [byte ebp+010h]
        mov dx, word [eax]
        mov eax, dword [byte ebp-010h]
        or word [eax], dx
        mov eax, dword [byte ebp+010h]
        mov ax, word [eax]
        not eax
        mov edx, dword [byte ebp-010h]
        and word [byte edx+02h], ax
        mov edx, dword [byte ebp-010h]
        add edx, byte 12h
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A0D0C
        mov ebx, dword [byte ebp-06h]
        sar ebx, 10h
        mov eax, dword [byte ebp-010h]
        mov eax, dword [byte eax+0Eh]
        movsx ax, byte [byte eax+07h]
        add eax, dword [byte ebp-0Ch]
        movsx edx, ax
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A0C5B
        mov eax, dword [byte ebp-010h]
        movsx ax, byte [byte eax+015h]
        movsx ebx, ax
        mov edx, 1
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A0D43
        mov eax, dword [byte ebp-010h]
        movsx ax, byte [byte eax+012h]
        movsx ebx, ax
        mov edx, 7
        mov eax, dword [byte ebp+010h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A0D43
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret 4
sub_A0BAC:
        push dword 3Ch
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 18h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-014h], edx
        mov dword [byte ebp-08h], ebx
        mov dword [byte ebp-04h], ecx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-018h], edx
        mov eax, dword [byte ebp-014h]
        mov edx, dword [byte ebp-018h]
        mov dword [byte edx+04h], eax
        mov eax, dword [byte ebp-08h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+012h], ax
        mov eax, dword [byte ebp-04h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+010h], ax
        mov eax, dword [byte ebp+010h]
        mov edx, dword [byte ebp-018h]
        mov word [byte edx+014h], ax
        mov eax, dword [byte ebp-014h]
        add eax, byte 10h
        mov dword [byte ebp-010h], eax
        mov eax, dword [byte ebp-010h]
        mov ax, word [byte eax+02h]
        and eax, 0FFFFh
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_AF076
        add esp, byte 8
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+0Ch]
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+08h]
        mov eax, dword [byte ebp-010h]
        push dword [byte eax+04h]
        mov eax, dword [byte ebp-014h]
        push dword [byte eax+0Ch]
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_AF0D5
        add esp, byte 14h
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        ret 4
sub_A0C5B:
        push dword 38h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 18h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-010h], edx
        mov dword [byte ebp-04h], ebx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-014h], edx
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp-014h]
        mov word [byte edx+0Ch], ax
        mov eax, dword [byte ebp-014h]
        mov dx, word [byte eax+0Ch]
        mov eax, dword [byte ebp-014h]
        mov word [byte eax+0Eh], dx
        mov eax, dword [byte ebp-014h]
        mov word [byte eax+0Ah], 3
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+012h]
        sar eax, 10h
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        add eax, edx
        cmp eax, byte 7Fh
        jge short loc_A0CDA
        mov eax, dword [byte ebp-014h]
        mov eax, dword [byte eax+012h]
        sar eax, 10h
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        add edx, eax
        mov dword [byte ebp-018h], edx
        jmp short loc_A0CE1
loc_A0CDA:
        mov dword [byte ebp-018h], 7Fh
loc_A0CE1:
        mov eax, dword [byte ebp-018h]
        mov word [byte ebp-08h], ax
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_AEF33
        add esp, byte 0Ch
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_A0D0C:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 8
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp-06h]
        sar edx, 10h
        imul edx, byte 16h
        mov eax, dword [byte ebp-08h]
        mov dword [dword edx+dword_F558C], eax
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_A0D43:
        push dword 2Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 10h
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-04h], edx
        mov dword [byte ebp-08h], ebx
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-010h], edx
        cmp word [byte ebp-04h], byte 7
        jne short loc_A0D92
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        push eax
        mov eax, dword [byte ebp-0Eh]
        sar eax, 10h
        push eax
        call sub_AEFEA
        add esp, byte 8
loc_A0D92:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_A0D99:
        push dword 40h
        call __CHK
        push ds
        call __GETDS
sub_A0DA9:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [dword_D4F9A], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        cmp dword [dword_D53A8], byte 0
        je near loc_A0FDC
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
loc_A0DF7:
        cmp word [byte ebp+014h], byte 0
        jg short loc_A0E0B
        jmp near loc_A0FDC
loc_A0E03:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short loc_A0DF7
loc_A0E0B:
        xor ah, ah
        mov edx, dword [byte ebp-018h]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short loc_A0E62
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov eax, dword [byte ebp-010h]
        and eax, 0F0h
        cmp ax, 0C0h
        jne short loc_A0E43
        mov dword [byte ebp-024h], 1
        jmp short loc_A0E4A
loc_A0E43:
        mov dword [byte ebp-024h], 2
loc_A0E4A:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-08h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near loc_A0FD7
loc_A0E62:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [edx], al
        inc dword [byte ebp-01Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
        cmp eax, edx
        jne near loc_A0FD7
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short loc_A0ECA
        cmp byte [byte ebp-028h], 0B0h
        jbe near loc_A0F7D
        cmp byte [byte ebp-028h], 0C0h
        jb short loc_A0EC5
        cmp byte [byte ebp-028h], 0C0h
        jbe near loc_A0F98
        cmp byte [byte ebp-028h], 0E0h
        je near loc_A0FBE
        jmp near loc_A0FD7
loc_A0EC5:
        jmp near loc_A0FD7
loc_A0ECA:
        cmp byte [byte ebp-028h], 80h
        jb short loc_A0EE1
        cmp byte [byte ebp-028h], 80h
        jbe short loc_A0EE6
        cmp byte [byte ebp-028h], 90h
        je short loc_A0EFF
        jmp near loc_A0FD7
loc_A0EE1:
        jmp near loc_A0FD7
loc_A0EE6:
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        call sub_AC6E8
        jmp near loc_A0FD7
loc_A0EFF:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short loc_A0F1E
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        call sub_AC6E8
        jmp short loc_A0F7B
loc_A0F1E:
        cmp byte [byte ebp-04h], 9
        jne short loc_A0F5A
        push byte 9
        mov eax, dword [byte ebp-020h]
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [eax]
        mov edx, 1
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        add eax, 80h
        imul esi, eax, byte 1Ch
        mov eax, word_F371C
        add eax, esi
        call sub_AC0CC
        jmp short loc_A0F7B
loc_A0F5A:
        xor eax, eax
        mov al, byte [byte ebp-04h]
        push eax
        mov eax, dword [byte ebp-020h]
        xor ecx, ecx
        mov cl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [eax]
        mov edx, 1
        xor eax, eax
        call sub_AC0CC
loc_A0F7B:
        jmp short loc_A0FD7
loc_A0F7D:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call sub_AF428
        jmp short loc_A0FD7
loc_A0F98:
        cmp byte [byte ebp-04h], 9
        je short loc_A0FBC
        xor edx, edx
        mov dl, byte [byte ebp-04h]
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        and eax, 0FFh
        imul ebx, eax, byte 1Ch
        mov eax, word_F371C
        add eax, ebx
        call sub_AD298
loc_A0FBC:
        jmp short loc_A0FD7
loc_A0FBE:
        mov eax, dword [byte ebp-020h]
        xor ebx, ebx
        mov bl, byte [byte eax+01h]
        mov eax, dword [byte ebp-020h]
        xor edx, edx
        mov dl, byte [eax]
        xor eax, eax
        mov al, byte [byte ebp-04h]
        call sub_AF340
loc_A0FD7:
        jmp near loc_A0E03
loc_A0FDC:
        sub dword [dword_D4F9A], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A0FEA:
        push dword 3Ch
        call __CHK
        push ds
        call __GETDS
sub_A0FFA:
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 28h
        mov byte [byte ebp-0Ch], 0C0h
        mov byte [byte ebp-08h], 1
        mov byte [byte ebp-04h], 0
        mov dword [byte ebp-014h], 0
        mov eax, unk_F21FC
        mov edx, dword [dword_D4F9A]
        add edx, eax
        mov dword [byte ebp-020h], edx
        add dword [dword_D4F9A], byte 4
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        cmp dword [dword_D53A8], byte 0
        je near loc_A11F0
        mov eax, dword [byte ebp+018h]
        mov dword [byte ebp-018h], eax
loc_A1048:
        cmp word [byte ebp+014h], byte 0
        jg short loc_A105C
        jmp near loc_A11F0
loc_A1054:
        dec dword [byte ebp+014h]
        inc dword [byte ebp-018h]
        jmp short loc_A1048
loc_A105C:
        xor ah, ah
        mov edx, dword [byte ebp-018h]
        mov al, byte [edx]
        mov word [byte ebp-010h], ax
        test byte [byte ebp-010h], 80h
        je short loc_A10B3
        mov al, byte [byte ebp-010h]
        and al, 0F0h
        mov byte [byte ebp-0Ch], al
        mov al, byte [byte ebp-010h]
        and al, 0Fh
        mov byte [byte ebp-04h], al
        mov eax, dword [byte ebp-010h]
        and eax, 0F0h
        cmp ax, 0C0h
        jne short loc_A1094
        mov dword [byte ebp-024h], 1
        jmp short loc_A109B
loc_A1094:
        mov dword [byte ebp-024h], 2
loc_A109B:
        mov al, byte [byte ebp-024h]
        mov byte [byte ebp-08h], al
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        jmp near loc_A11EB
loc_A10B3:
        mov al, byte [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [edx], al
        inc dword [byte ebp-01Ch]
        inc dword [byte ebp-014h]
        xor eax, eax
        mov ax, word [byte ebp-014h]
        xor edx, edx
        mov dl, byte [byte ebp-08h]
        cmp eax, edx
        jne near loc_A11EB
        mov dword [byte ebp-014h], 0
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-01Ch], eax
        mov al, byte [byte ebp-0Ch]
        mov byte [byte ebp-028h], al
        cmp byte [byte ebp-028h], 0B0h
        jb short loc_A111B
        cmp byte [byte ebp-028h], 0B0h
        jbe near loc_A1193
        cmp byte [byte ebp-028h], 0C0h
        jb short loc_A1116
        cmp byte [byte ebp-028h], 0C0h
        jbe near loc_A11B5
        cmp byte [byte ebp-028h], 0E0h
        je near loc_A11CC
        jmp near loc_A11EB
loc_A1116:
        jmp near loc_A11EB
loc_A111B:
        cmp byte [byte ebp-028h], 80h
        jb short loc_A1132
        cmp byte [byte ebp-028h], 80h
        jbe short loc_A1137
        cmp byte [byte ebp-028h], 90h
        je short loc_A1151
        jmp near loc_A11EB
loc_A1132:
        jmp near loc_A11EB
loc_A1137:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A14AF
        jmp near loc_A11EB
loc_A1151:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+01h], 0
        jne short loc_A1171
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A14AF
        jmp short loc_A1191
loc_A1171:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A11FE
loc_A1191:
        jmp short loc_A11EB
loc_A1193:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        movsx ebx, ax
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A1632
        jmp short loc_A11EB
loc_A11B5:
        mov eax, dword [byte ebp-020h]
        mov al, byte [eax]
        xor ah, ah
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A08D7
        jmp short loc_A11EB
loc_A11CC:
        mov eax, dword [byte ebp-020h]
        mov al, byte [byte eax+01h]
        xor ah, ah
        shl eax, 8
        db 081h,0E8h,00h,040h,00h,00h           ; insn: sub eax,4000h
        movsx edx, ax
        xor eax, eax
        mov al, byte [byte ebp-04h]
        cwde
        call sub_A0981
loc_A11EB:
        jmp near loc_A1054
loc_A11F0:
        sub dword [dword_D4F9A], byte 4
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ds
        ret
sub_A11FE:
        push dword 4Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 34h
        mov dword [byte ebp-024h], eax
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-028h], ebx
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, unk_F53AC
        add edx, eax
        mov dword [byte ebp-030h], edx
        cmp word [byte ebp-024h], byte 9
        jne short loc_A1269
        cmp word [byte ebp-020h], byte 24h
        jl short loc_A1245
        cmp word [byte ebp-020h], byte 64h
        jl short loc_A124A
loc_A1245:
        jmp near loc_A14A8
loc_A124A:
        mov eax, dword [byte ebp-020h]
        add eax, 5Ch
        movsx edx, ax
        mov eax, dword [byte ebp-026h]
        sar eax, 10h
        call sub_A08D7
        mov dword [byte ebp-04h], 3Ch
        jmp short loc_A126F
loc_A1269:
        mov eax, dword [byte ebp-020h]
        mov dword [byte ebp-04h], eax
loc_A126F:
        mov eax, dword [byte ebp-030h]
        cmp word [byte eax+04h], byte 0
        je short loc_A1283
        mov eax, dword [byte ebp-030h]
        cmp word [byte eax+08h], byte 0
        jne short loc_A1288
loc_A1283:
        jmp near loc_A14A8
loc_A1288:
        mov dword [byte ebp-08h], 7D00h
        mov dword [byte ebp-02Ch], word_F5324
        mov dword [byte ebp-010h], 0
        mov dword [byte ebp-014h], 1
loc_A12A4:
        cmp word [byte ebp-010h], byte 4
        jl short loc_A12B8
        jmp near loc_A1364
loc_A12B0:
        inc dword [byte ebp-010h]
        shl dword [byte ebp-014h], 1
        jmp short loc_A12A4
loc_A12B8:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, word_F5324
        add edx, eax
        mov dword [byte ebp-034h], edx
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        mov eax, dword [word_F58D6-2]
        sar eax, 10h
        and edx, eax
        mov eax, dword [byte ebp-030h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        test edx, eax
        je short loc_A12F5
        mov eax, dword [byte ebp-034h]
        mov ax, word [byte eax+06h]
        cmp ax, word [byte ebp-08h]
        jl short loc_A12F7
loc_A12F5:
        jmp short loc_A1307
loc_A12F7:
        mov eax, dword [byte ebp-034h]
        mov ax, word [byte eax+06h]
        mov dword [byte ebp-08h], eax
        mov eax, dword [byte ebp-034h]
        mov dword [byte ebp-02Ch], eax
loc_A1307:
        mov eax, dword [byte ebp-030h]
        movsx eax, word [eax]
        mov edx, dword [byte ebp-016h]
        sar edx, 10h
        and edx, eax
        mov eax, dword [byte ebp-030h]
        mov eax, dword [byte eax+02h]
        sar eax, 10h
        test edx, eax
        je short loc_A132D
        mov eax, dword [byte ebp-030h]
        mov edx, dword [byte ebp-034h]
        cmp eax, dword [byte edx+0Eh]
        je short loc_A132F
loc_A132D:
        jmp short loc_A133B
loc_A132F:
        mov eax, dword [byte ebp-020h]
        mov edx, dword [byte ebp-034h]
        cmp ax, word [byte edx+08h]
        je short loc_A133D
loc_A133B:
        jmp short loc_A135F
loc_A133D:
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call sub_A0A08
        jmp near loc_A14A8
loc_A135F:
        jmp near loc_A12B0
loc_A1364:
        mov dword [byte ebp-0Ch], 0
        mov eax, dword [byte ebp-030h]
        mov ax, word [eax]
        mov word [byte ebp-014h], ax
loc_A1375:
        cmp word [byte ebp-014h], byte 0
        je short loc_A138D
        inc dword [byte ebp-0Ch]
        mov eax, dword [byte ebp-014h]
        neg eax
        and eax, dword [byte ebp-014h]
        xor word [byte ebp-014h], ax
        jmp short loc_A1375
loc_A138D:
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-030h]
        cmp ax, word [byte edx+08h]
        jge near loc_A1412
        mov ax, word [word_F58D4]
        mov edx, dword [byte ebp-030h]
        and ax, word [byte edx+04h]
        mov dword [byte ebp-018h], eax
        cmp word [byte ebp-018h], byte 0
        je short loc_A1412
        mov eax, dword [byte ebp-018h]
        neg eax
        mov edx, dword [byte ebp-018h]
        and edx, eax
        mov word [byte ebp-014h], dx
        mov word [byte ebp-010h], 0FFFFh
loc_A13C8:
        cmp word [byte ebp-014h], byte 0
        jne short loc_A13DB
        jmp short loc_A13DD
loc_A13D1:
        inc word [byte ebp-010h]
        sar word [byte ebp-014h], 1
        jmp short loc_A13C8
loc_A13DB:
        jmp short loc_A13D1
loc_A13DD:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, word_F5324
        add edx, eax
        mov dword [byte ebp-034h], edx
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call sub_A0A08
        jmp near loc_A14A8
loc_A1412:
        mov ax, word [word_F58D2]
        mov edx, dword [byte ebp-030h]
        and ax, word [byte edx+04h]
        mov dword [byte ebp-01Ch], eax
        cmp word [byte ebp-01Ch], byte 0
        je short loc_A1484
        mov eax, dword [byte ebp-01Ch]
        neg eax
        mov edx, dword [byte ebp-01Ch]
        and edx, eax
        mov word [byte ebp-014h], dx
        mov word [byte ebp-010h], 0FFFFh
loc_A143D:
        cmp word [byte ebp-014h], byte 0
        jne short loc_A1450
        jmp short loc_A1452
loc_A1446:
        inc word [byte ebp-010h]
        sar word [byte ebp-014h], 1
        jmp short loc_A143D
loc_A1450:
        jmp short loc_A1446
loc_A1452:
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, word_F5324
        add edx, eax
        mov dword [byte ebp-034h], edx
        push dword [byte ebp-034h]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call sub_A0A08
        jmp short loc_A14A8
loc_A1484:
        push dword [byte ebp-02Ch]
        mov ecx, dword [byte ebp-030h]
        mov ebx, dword [byte ebp-02Ah]
        sar ebx, 10h
        mov edx, dword [byte ebp-022h]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        call sub_A0A08
        mov dword [byte ebp-02Ch], 0
loc_A14A8:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_A14AF:
        push dword 3Ch
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 20h
        mov dword [byte ebp-014h], eax
        mov dword [byte ebp-0Ch], edx
        mov eax, dword [byte ebp-016h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, unk_F53AC
        add edx, eax
        mov dword [byte ebp-020h], edx
        mov eax, dword [byte ebp-020h]
        mov ax, word [eax]
        mov dword [byte ebp-08h], eax
        mov dword [byte ebp-04h], 0
        mov dword [byte ebp-010h], 1
loc_A14F6:
        cmp word [byte ebp-04h], byte 4
        jl short loc_A150A
        jmp near loc_A15A2
loc_A1502:
        inc dword [byte ebp-04h]
        shl dword [byte ebp-010h], 1
        jmp short loc_A14F6
loc_A150A:
        mov edx, dword [byte ebp-012h]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        test edx, eax
        je near loc_A159D
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 22h
        mov edx, word_F5324
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov eax, dword [byte ebp-020h]
        mov edx, dword [byte ebp-01Ch]
        cmp eax, dword [byte edx+0Eh]
        jne short loc_A1548
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-01Ch]
        cmp ax, word [byte edx+08h]
        je short loc_A154A
loc_A1548:
        jmp short loc_A159D
loc_A154A:
        mov eax, dword [byte ebp-020h]
        cmp byte [byte eax+014h], 0
        je short loc_A155F
        mov eax, dword [byte ebp-010h]
        mov edx, dword [byte ebp-020h]
        or word [byte edx+02h], ax
        jmp short loc_A159B
loc_A155F:
        mov eax, dword [byte ebp-010h]
        or word [word_F58D2], ax
        mov eax, dword [byte ebp-01Ch]
        sar word [byte eax+06h], 1
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        imul eax, byte 16h
        mov edx, dword_F558C
        add edx, eax
        mov dword [byte ebp-018h], edx
        mov eax, dword [byte ebp-018h]
        mov word [byte eax+0Ah], 1
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        push eax
        call sub_AEFA2
        add esp, byte 4
loc_A159B:
        jmp short loc_A15A2
loc_A159D:
        jmp near loc_A1502
loc_A15A2:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
sub_A15AA:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 4
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-04h]
        mov eax, dword [eax]
        sar eax, 10h
        call sub_A09B9
        mov eax, dword [byte ebp-04h]
        mov word [byte eax+06h], 0
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        or word [word_F58D4], ax
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        not eax
        and word [word_F58D6], ax
        mov eax, dword [byte ebp-04h]
        mov ax, word [eax]
        not eax
        and word [word_F58D2], ax
        mov eax, dword [byte ebp-04h]
        mov dx, word [eax]
        not edx
        mov eax, dword [byte ebp-04h]
        mov eax, dword [byte eax+0Eh]
        and word [eax], dx
        mov eax, dword [byte ebp-04h]
        mov eax, dword [byte eax+0Eh]
        mov edx, dword [byte ebp-04h]
        mov dx, word [edx]
        not edx
        and word [byte eax+02h], dx
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_A1632:
        push dword 34h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        mov ebp, esp
        sub esp, 20h
        mov dword [byte ebp-010h], eax
        mov dword [byte ebp-018h], edx
        mov dword [byte ebp-014h], ebx
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        imul eax, byte 1Eh
        mov edx, unk_F53AC
        add edx, eax
        mov dword [byte ebp-01Ch], edx
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp-020h], eax
        cmp word [byte ebp-020h], byte 0Ah
        jb short loc_A169B
        cmp word [byte ebp-020h], byte 0Ah
        jbe short loc_A16D6
        cmp word [byte ebp-020h], byte 40h
        jb short loc_A1696
        cmp word [byte ebp-020h], byte 40h
        jbe short loc_A16E4
        cmp word [byte ebp-020h], byte 7Bh
        je near loc_A1757
        jmp near loc_A17A7
loc_A1696:
        jmp near loc_A17A7
loc_A169B:
        cmp word [byte ebp-020h], byte 1
        jb short loc_A16B5
        cmp word [byte ebp-020h], byte 1
        jbe short loc_A16BA
        cmp word [byte ebp-020h], byte 7
        je short loc_A16C8
        jmp near loc_A17A7
loc_A16B5:
        jmp near loc_A17A7
loc_A16BA:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+015h], al
        jmp near loc_A17A7
loc_A16C8:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+012h], al
        jmp near loc_A17A7
loc_A16D6:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+013h], al
        jmp near loc_A17A7
loc_A16E4:
        mov al, byte [byte ebp-014h]
        mov edx, dword [byte ebp-01Ch]
        mov byte [byte edx+014h], al
        cmp word [byte ebp-014h], byte 0
        jne short loc_A1755
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [byte eax+02h]
        mov dword [byte ebp-04h], eax
        mov eax, dword [byte ebp-01Ch]
        mov word [byte eax+02h], 0
        mov dword [byte ebp-08h], 0
        mov dword [byte ebp-0Ch], 1
loc_A1715:
        cmp word [byte ebp-08h], byte 4
        jl short loc_A1726
        jmp short loc_A1755
loc_A171E:
        inc dword [byte ebp-08h]
        shl dword [byte ebp-0Ch], 1
        jmp short loc_A1715
loc_A1726:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short loc_A1753
        mov edx, dword [byte ebp-0Ah]
        sar edx, 10h
        imul edx, byte 22h
        mov edx, dword [dword edx+dword_F532A]
        sar edx, 10h
        mov eax, dword [byte ebp-012h]
        sar eax, 10h
        call sub_A14AF
loc_A1753:
        jmp short loc_A171E
loc_A1755:
        jmp short loc_A17A7
loc_A1757:
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [eax]
        mov word [byte ebp-04h], ax
        mov word [byte ebp-08h], 0
        mov word [byte ebp-0Ch], 1
loc_A176D:
        cmp word [byte ebp-08h], byte 4
        jl short loc_A1780
        jmp short loc_A17A7
loc_A1776:
        inc word [byte ebp-08h]
        shl word [byte ebp-0Ch], 1
        jmp short loc_A176D
loc_A1780:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short loc_A17A5
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        imul edx, eax, byte 22h
        mov eax, word_F5324
        add eax, edx
        call sub_A15AA
loc_A17A5:
        jmp short loc_A1776
loc_A17A7:
        mov eax, dword [byte ebp-01Ch]
        mov ax, word [eax]
        mov word [byte ebp-04h], ax
        mov word [byte ebp-08h], 0
        mov word [byte ebp-0Ch], 1
loc_A17BD:
        cmp word [byte ebp-08h], byte 4
        jl short loc_A17D0
        jmp short loc_A17F9
loc_A17C6:
        inc word [byte ebp-08h]
        shl word [byte ebp-0Ch], 1
        jmp short loc_A17BD
loc_A17D0:
        mov edx, dword [byte ebp-0Eh]
        sar edx, 10h
        mov eax, dword [byte ebp-06h]
        sar eax, 10h
        test edx, eax
        je short loc_A17F7
        mov ebx, dword [byte ebp-016h]
        sar ebx, 10h
        mov edx, dword [byte ebp-01Ah]
        sar edx, 10h
        mov eax, dword [byte ebp-0Ah]
        sar eax, 10h
        call sub_A0D43
loc_A17F7:
        jmp short loc_A17C6
loc_A17F9:
        mov esp, ebp
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_A1800:
        push esi
        push edi
        mov esi, dword [cliprect_x1]
        sub esi, dword [cliprect_x0]
        mov ebx, dword [byte esp+0Ch]
        push ebx
        call fputchar
        add esp, byte 4
        sub esi, eax
        mov eax, esi
        sar eax, 1
        add eax, dword [cliprect_x0]
        mov esi, dword [byte esp+010h]
        push esi
        inc eax
        push eax
        mov edi, dword [byte esp+014h]
        push edi
        call PrintString
        add esp, byte 0Ch
        pop edi
        pop esi
        ret
        db 00h,00h
sub_A1840:
        mov eax, dword [byte esp+04h]
        mov edx, dword [byte eax+04h]
        push edx
        push byte 0
        mov ebx, dword [eax]
        push ebx
        push byte 0
        push eax
        call sub_B6F84
        add esp, byte 14h
        ret
        db 08Dh,040h,00h
sub_A185C:
        mov edx, dword [dword_D30A8]
        push edx
        push byte 0
        mov ebx, dword [dword_D30A4]
        push ebx
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        ret
