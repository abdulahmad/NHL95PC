; Hardware access for the Sound Blaster.
bits 32
%include "hockey.inc"
section s_A6BE1 progbits alloc exec nowrite align=1
extern __set_errno_, byte_C4B6C, byte_D6CE0, byte_D6CE1, byte_D6CE3, byte_D6D1E, byte_D6D1F, byte_D6D24
extern byte_D6E24, byte_D6E25, byte_D6E27, byte_D6E62, byte_D6E63, byte_D6E68, byte_D6F68, byte_D6F69
extern byte_D6F6B, byte_D6FA6, byte_D6FA7, byte_D6FAC, byte_D70AC, byte_D70AD, byte_D70AF, byte_D70EA
extern byte_D70EB, byte_D70F0, byte_D7618, byte_D7619, byte_D781C, dword_D6B00, dword_D6CE4, dword_D6CF8
extern dword_D6CFC, dword_D6D00, dword_D6D0C, dword_D6D10, dword_D6D14, dword_D6D18, dword_D6D20, dword_D6E28
extern dword_D6E3C, dword_D6E40, dword_D6E44, dword_D6E50, dword_D6E54, dword_D6E58, dword_D6E5C, dword_D6E64
extern dword_D6F6C, dword_D6F80, dword_D6F84, dword_D6F88, dword_D6F94, dword_D6F98, dword_D6F9C, dword_D6FA0
extern dword_D6FA8, dword_D70B0, dword_D70C4, dword_D70C8, dword_D70CC, dword_D70D8, dword_D70DC, dword_D70E0
extern dword_D70E4, dword_D70EC, dword_D7200, dword_D7204, dword_D7208, dword_D720C, dword_D7614, dword_D7A1E
extern dword_D7A22, off_D71F0, sub_A9E34, sub_A9F93, sub_AA1B2, tolower_, word_D7214, word_D7216
extern word_D7218, word_D721A, word_D721C, word_D721E, word_D7220, word_D7222, word_D7224, word_D7226
extern word_D7228, word_D722A, word_D722C, word_D722E, word_D7230, word_D7232, word_D7234, word_D7236
extern word_D7238, word_D723A, word_D723C, word_D723E, word_D7240, word_D7242, word_D7244, word_D7246
extern word_D7248, word_D724A, word_D724C, word_D724E, word_D7250, word_D7252, word_D7254, word_D7256
extern word_D7258, word_D725A, word_D725C, word_D725E, word_D7260, word_D7262, word_D7264, word_D7266
extern word_D7268, word_D726A, word_D726C, word_D726E, word_D7270, word_D7272, word_D7274, word_D7276
extern word_D7278, word_D727A, word_D727C, word_D727E, word_D7280, word_D7282, word_D7284, word_D7286
extern word_D7288, word_D728A, word_D728C, word_D728E, word_D7290, word_D7292, word_D7294, word_D7296
extern word_D7298, word_D729A, word_D729C, word_D729E, word_D72A0, word_D72A2, word_D72A4, word_D72A6
extern word_D72A8, word_D72AA, word_D72AC, word_D72AE, word_D72B0, word_D72B2, word_D72B4, word_D72B6
extern word_D72B8, word_D72BA, word_D72BC, word_D72BE, word_D72C0, word_D72C2, word_D72C4, word_D72C6
extern word_D72C8, word_D72CA, word_D72CC, word_D72CE, word_D72D0, word_D72D2, word_D72D4, word_D72D6
extern word_D72D8, word_D72DA, word_D72DC, word_D72DE, word_D72E0, word_D72E2, word_D72E4, word_D72E6
extern word_D72E8, word_D72EA, word_D72EC, word_D72EE, word_D72F0, word_D72F2, word_D72F4, word_D72F6
extern word_D72F8, word_D72FA, word_D72FC, word_D72FE, word_D7300, word_D7302, word_D7304, word_D7306
extern word_D7308, word_D730A, word_D730C, word_D730E, word_D7310, word_D7312, word_D7314, word_D7316
extern word_D7318, word_D731A, word_D731C, word_D731E, word_D7320, word_D7322, word_D7324, word_D7326
extern word_D7328, word_D732A, word_D732C, word_D732E, word_D7330, word_D7332, word_D7334, word_D7336
extern word_D7338, word_D733A, word_D733C, word_D733E, word_D7340, word_D7342, word_D7344, word_D7346
extern word_D7348, word_D734A, word_D734C, word_D734E, word_D7350, word_D7352, word_D7354, word_D7356
extern word_D7358, word_D735A, word_D735C, word_D735E, word_D7360, word_D7362, word_D7364, word_D7366
extern word_D7368, word_D736A, word_D736C, word_D736E, word_D7370, word_D7372, word_D7374, word_D7376
extern word_D7378, word_D737A, word_D737C, word_D737E, word_D7380, word_D7382, word_D7384, word_D7386
extern word_D7388, word_D738A, word_D738C, word_D738E, word_D7390, word_D7392, word_D7394, word_D7396
extern word_D7398, word_D739A, word_D739C, word_D739E, word_D73A0, word_D73A2, word_D73A4, word_D73A6
extern word_D73A8, word_D73AA, word_D73AC, word_D73AE, word_D73B0, word_D73B2, word_D73B4, word_D73B6
extern word_D73B8, word_D73BA, word_D73BC, word_D73BE, word_D73C0, word_D73C2, word_D73C4, word_D73C6
extern word_D73C8, word_D73CA, word_D73CC, word_D73CE, word_D73D0, word_D73D2, word_D73D4, word_D73D6
extern word_D73D8, word_D73DA, word_D73DC, word_D73DE, word_D73E0, word_D73E2, word_D73E4, word_D73E6
extern word_D73E8, word_D73EA, word_D73EC, word_D73EE, word_D73F0, word_D73F2, word_D73F4, word_D73F6
extern word_D73F8, word_D73FA, word_D73FC, word_D73FE, word_D7400, word_D7402, word_D7404, word_D7406
extern word_D7408, word_D740A, word_D740C, word_D740E, word_D7410, word_D7412, word_D7414
global StrToLong, loc_A6BF7, loc_A6BF9, loc_A6C0E, loc_A6C1C, loc_A6C1D, loc_A6C31, loc_A6C38
global loc_A6C44, loc_A6C49, loc_A6C53, loc_A6C64, loc_A6C7B, loc_A6C7E, loc_A6C89, loc_A6CA6
global loc_A6CA9, loc_A6CB0, loc_A6CB6, loc_A6CCE, loc_A6CD3, loc_A6CF3, loc_A6D01, loc_A6D08
global loc_A6D11, loc_A6D13, strtol_, loc_A6D1D, strtoul_, DigitValue, loc_A6D40, loc_A6D5D
global loc_A6D67, loc_A6D70, loc_A6D7A, SbStreamCheck, loc_A6D8B, SbMixRateDiv, SbMixerOpen, loc_A6DB2
global loc_A6DE5, SbMixerClose, SbStreamStopAll, loc_A6E02, SbStreamPlayNote, loc_A6E54, loc_A6E66, loc_A6E78
global SbStreamRelease, loc_A6E9F, SbStreamStop, loc_A6EC0, SbStreamSetVolume, loc_A6F08, loc_A6F17, SbStreamSetBend
global loc_A6F39, SbStreamSetRate, loc_A6F90, loc_A6F97, loc_A6F9C, loc_A6F9F, SbStreamSetSample, loc_A6FDE
global SbStreamStart, loc_A7013, loc_A7065, loc_A707D, loc_A708F, SbStreamIdle, loc_A70AF, loc_A70B7
global SbStreamGetVolume, loc_A70D8, SbStreamApplyBend, loc_A712E, loc_A713C, loc_A714A, loc_A7158, SbMixAdd8Vol
global SbMixAdd8, SbMixChannels, loc_A906C, loc_A90FB, loc_A9105, loc_A911C, loc_A9123, loc_A915C
global loc_A9197, loc_A91CE, loc_A91DA, loc_A91F6, loc_A9208, loc_A921A, loc_A9269, loc_A92A6
global loc_A92D0, loc_A92E6, loc_A9327, loc_A9333, loc_A933A, loc_A93C2, loc_A93CC, loc_A93E3
global loc_A93EA, loc_A9423, loc_A945E, loc_A9495, loc_A94A1, loc_A94BD, loc_A94CF, loc_A94E1
global loc_A9530, loc_A956D, loc_A9597, loc_A95AD, loc_A95EE, loc_A95FA, loc_A9601, loc_A9689
global loc_A9693, loc_A96AA, loc_A96B1, loc_A96EA, loc_A9725, loc_A975C, loc_A9768, loc_A9784
global loc_A9796, loc_A97A8, loc_A97F7, loc_A9834, loc_A985E, loc_A9874, loc_A98B5, loc_A98C1
global loc_A98C8, loc_A9950, loc_A995A, loc_A9971, loc_A9978, loc_A99B1, loc_A99EC, loc_A9A23
global loc_A9A2F, loc_A9A4B, loc_A9A5D, loc_A9A6F, loc_A9ABE, loc_A9AFB, loc_A9B25, loc_A9B3B
global loc_A9B7C, loc_A9B88, loc_A9B8F, SbDmaHalfReady, loc_A9BB5, loc_A9BBA, loc_A9BCA, SbDmaStart
global loc_A9C08, SbDmaStop, loc_A9C33, SbMixPause, SbConvertMix, loc_A9C60, unk_A9C80, unk_A9C81
global unk_A9C83, unk_A9C85, unk_A9C86, unk_A9C88, unk_A9C89, unk_A9C8A, unk_A9C8E, unk_A9C8F
global unk_A9C90, unk_A9C91, unk_A9C92, unk_A9C96, unk_A9C98
StrToLong:
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        mov ebp, eax
        mov edi, edx
        mov esi, ebx
        mov dword [byte esp+04h], ecx
        test edx, edx
        je short loc_A6BF7
        mov dword [edx], eax
loc_A6BF7:
        mov edx, ebp
loc_A6BF9:
        mov al, byte [edx]
        inc al
        and eax, 0FFh
        test byte [dword eax+byte_C4B6C], 2
        je short loc_A6C0E
        inc edx
        jmp short loc_A6BF9
loc_A6C0E:
        mov al, byte [edx]
        mov byte [byte esp+0Ch], al
        cmp al, 2Bh
        je short loc_A6C1C
        cmp al, 2Dh
        jne short loc_A6C1D
loc_A6C1C:
        inc edx
loc_A6C1D:
        test esi, esi
        jne short loc_A6C49
        cmp byte [edx], 30h
        jne short loc_A6C38
        mov al, byte [byte edx+01h]
        cmp al, 78h
        je short loc_A6C31
        cmp al, 58h
        jne short loc_A6C38
loc_A6C31:
        mov esi, 10h
        jmp short loc_A6C49
loc_A6C38:
        cmp byte [edx], 30h
        jne short loc_A6C44
        mov esi, 8
        jmp short loc_A6C49
loc_A6C44:
        mov esi, 0Ah
loc_A6C49:
        cmp esi, byte 2
        jl short loc_A6C53
        cmp esi, byte 24h
        jle short loc_A6C64
loc_A6C53:
        mov eax, 0Dh
        call __set_errno_
        xor eax, eax
        jmp near loc_A6D13
loc_A6C64:
        cmp esi, byte 10h
        jne short loc_A6C7E
        cmp byte [edx], 30h
        jne short loc_A6C7E
        mov cl, byte [byte edx+01h]
        cmp cl, 78h
        je short loc_A6C7B
        cmp cl, 58h
        jne short loc_A6C7E
loc_A6C7B:
        add edx, byte 2
loc_A6C7E:
        mov dword [esp], edx
        xor al, al
        xor ebx, ebx
        mov byte [byte esp+08h], al
loc_A6C89:
        xor eax, eax
        mov al, byte [edx]
        call DigitValue
        cmp eax, esi
        jge short loc_A6CA9
        mov ecx, ebx
        imul ebx, esi
        add ebx, eax
        cmp ebx, ecx
        jae short loc_A6CA6
        mov byte [byte esp+08h], 1
loc_A6CA6:
        inc edx
        jmp short loc_A6C89
loc_A6CA9:
        cmp edx, dword [esp]
        jne short loc_A6CB0
        mov edx, ebp
loc_A6CB0:
        test edi, edi
        je short loc_A6CB6
        mov dword [edi], edx
loc_A6CB6:
        cmp dword [byte esp+04h], byte 1
        jne short loc_A6CD3
        cmp ebx, 80000000h
        jb short loc_A6CD3
        jne short loc_A6CCE
        cmp byte [byte esp+0Ch], 2Dh
        je short loc_A6CD3
loc_A6CCE:
        mov byte [byte esp+08h], 1
loc_A6CD3:
        cmp byte [byte esp+08h], 0
        je short loc_A6D08
        mov eax, 0Eh
        mov edi, dword [byte esp+04h]
        call __set_errno_
        test edi, edi
        jne short loc_A6CF3
        mov eax, 0FFFFFFFFh
        jmp short loc_A6D13
loc_A6CF3:
        cmp byte [byte esp+0Ch], 2Dh
        jne short loc_A6D01
        mov eax, 80000000h
        jmp short loc_A6D13
loc_A6D01:
        mov eax, 7FFFFFFFh
        jmp short loc_A6D13
loc_A6D08:
        cmp byte [byte esp+0Ch], 2Dh
        jne short loc_A6D11
        neg ebx
loc_A6D11:
        mov eax, ebx
loc_A6D13:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
strtol_:
        push ecx
        xor ecx, ecx
loc_A6D1D:
        call StrToLong
        pop ecx
        ret
strtoul_:
        push ecx
        mov ecx, 1
        jmp short loc_A6D1D
DigitValue:
        push edx
        mov dl, al
        cmp al, 30h
        jb short loc_A6D40
        cmp al, 39h
        ja short loc_A6D40
        xor eax, eax
        mov al, dl
        sub eax, byte 30h
        pop edx
        ret
loc_A6D40:
        xor eax, eax
        mov al, dl
        call tolower_
        mov dl, al
        cmp al, 61h
        jb short loc_A6D5D
        cmp al, 69h
        ja short loc_A6D5D
        and eax, 0FFh
        sub eax, byte 57h
        pop edx
        ret
loc_A6D5D:
        cmp dl, 6Ah
        jb short loc_A6D70
        cmp dl, 72h
        ja short loc_A6D70
loc_A6D67:
        xor eax, eax
        mov al, dl
        sub eax, byte 57h
        pop edx
        ret
loc_A6D70:
        cmp dl, 73h
        jb short loc_A6D7A
        cmp dl, 7Ah
        jbe short loc_A6D67
loc_A6D7A:
        mov eax, 25h
        pop edx
        ret
        db 00h,00h,00h
SbStreamCheck:
        cmp esi, byte 4
        jb short loc_A6D8B
        stc
        ret
loc_A6D8B:
        clc
        ret
SbMixRateDiv:
        push edx
        push ecx
        mov eax, dword [unk_A9C8A]
        LD xor, edx, edx
        mov ecx, 100h
        div ecx
        pop ecx
        pop edx
        ret
SbMixerOpen:
        push ebp
        LD mov, ebp, esp
        push esi
        call SbStreamStopAll
        mov ecx, 4
        mov al, 0FFh
        LD xor, esi, esi
loc_A6DB2:
        mov ebx, dword [nosplit esi*4+off_D71F0]
        mov byte [byte ebx+01h], al
        inc esi
        loop loc_A6DB2
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        movzx eax, word [byte ebp+08h]
        movzx edx, word [byte ebp+0Ah]
        call SbDmaStart
        add esp, byte 0Ch
        cmp eax, byte 0FFFFFFFFh
        je short loc_A6DE5
        mov eax, 44h
        pop esi
        leave
        ret
loc_A6DE5:
        mov eax, 0FFFFFFFFh
        pop esi
        leave
        ret
SbMixerClose:
        call SbStreamStopAll
        call SbDmaStop
        ret
SbStreamStopAll:
        push esi
        mov ecx, 4
        mov al, 0
        LD xor, esi, esi
loc_A6E02:
        mov ebx, dword [nosplit esi*4+off_D71F0]
        mov byte [ebx], al
        inc esi
        loop loc_A6E02
        pop esi
        ret
SbStreamPlayNote:
        push ebp
        LD mov, ebp, esp
        push esi
        mov eax, dword [byte ebp+010h]
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6E78
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov bl, byte [byte ebp+0Ch]
        mov byte [byte esi+02h], bl
        cmp bl, 0FFh
        je short loc_A6E54
        mov eax, dword [nosplit ebx*4+dword_D6B00]
        mul dword [byte esi+020h]
        and eax, 0FFFF0000h
        and edx, 0FFFFh
        mov dword [byte esi+034h], edx
        mov dword [byte esi+038h], eax
        mov dword [byte esi+024h], edx
        mov dword [byte esi+028h], eax
loc_A6E54:
        mov eax, dword [byte esi+0Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [byte esi+010h]
        cmp dword [byte esi+04h], byte 0
        jne short loc_A6E66
        mov eax, dword [byte esi+014h]
loc_A6E66:
        mov dword [byte esi+01Ch], eax
        mov eax, dword [byte esi+08h]
        mov dword [byte esi+02Ch], eax
        LD xor, eax, eax
        mov dword [byte esi+030h], eax
        mov al, 1
        mov byte [esi], al
loc_A6E78:
        pop esi
        leave
        ret
SbStreamRelease:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6E9F
        cmp esi, byte 1
        jle short loc_A6E9F
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+01Ch], eax
        mov al, 0
        mov byte [esi], al
loc_A6E9F:
        pop esi
        leave
        ret
SbStreamStop:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6EC0
        cmp esi, byte 1
        jle short loc_A6EC0
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov al, 0
        mov byte [esi], al
loc_A6EC0:
        pop esi
        leave
        ret
SbStreamSetVolume:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6F17
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov al, byte [byte ebp+0Ch]
        cmp al, byte [byte esi+01h]
        je short loc_A6F17
        mov byte [byte esi+01h], al
        shl al, 1
        and eax, 0FFh
        lea edi, [byte esi+044h]
        LD mov, esi, eax
        LD xor, eax, eax
        LD xor, ebx, ebx
        sub ebx, dword [byte ebp+0Ch]
        shl ebx, 8
        mov byte [edi], ah
        mov byte [dword edi+080h], bh
        inc edi
        mov ecx, 7Fh
loc_A6F08:
        LD add, eax, esi
        mov byte [edi], ah
        LD add, ebx, esi
        mov byte [dword edi+080h], bh
        inc edi
        loop loc_A6F08
loc_A6F17:
        pop edi
        pop esi
        leave
        ret
SbStreamSetBend:
        push ebp
        LD mov, ebp, esp
        push esi
        movzx esi, word [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6F39
        mov esi, dword [nosplit esi*4+off_D71F0]
        movsx eax, word [byte ebp+0Ch]
        mov word [byte esi+03Ch], ax
loc_A6F39:
        pop esi
        leave
        ret
SbStreamSetRate:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6F9F
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov ecx, dword [unk_A9C8A]
        LD xor, edx, edx
        mov eax, dword [byte ebp+0Ch]
        div ecx
        mov dword [byte esi+034h], eax
        mov dword [byte esi+024h], eax
        LD mov, ebx, eax
        LD xor, eax, eax
        div ecx
        mov dword [byte esi+038h], eax
        mov dword [byte esi+028h], eax
        and eax, 0FFFF0000h
        LD or, eax, ebx
        ror eax, 10h
        mov dword [byte esi+020h], eax
        mov eax, dword [byte esi+020h]
        cmp eax, 10000h
        je short loc_A6F90
        ja short loc_A6F97
        mov eax, 40h
        jmp short loc_A6F9C
loc_A6F90:
        mov eax, 80h
        jmp short loc_A6F9C
loc_A6F97:
        mov eax, 100h
loc_A6F9C:
        mov dword [byte esi+040h], eax
loc_A6F9F:
        pop esi
        leave
        ret
SbStreamSetSample:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A6FDE
        mov esi, dword [nosplit esi*4+off_D71F0]
        LD xor, eax, eax
        mov byte [byte esi+03h], al
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte esi+08h], eax
        mov ebx, dword [byte ebp+010h]
        LD add, ebx, eax
        mov dword [byte esi+014h], ebx
        mov ebx, dword [byte ebp+014h]
        LD add, ebx, eax
        mov dword [byte esi+0Ch], ebx
        add ebx, dword [byte ebp+018h]
        mov dword [byte esi+010h], ebx
        mov eax, dword [byte ebp+018h]
        mov dword [byte esi+04h], eax
loc_A6FDE:
        pop esi
        leave
        ret
SbStreamStart:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        pushf
        cli
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb near loc_A708F
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov eax, dword [byte ebp+01Ch]
        cmp eax, byte 0
        jne short loc_A7013
        push dword [byte ebp+08h]
        call SbStreamRelease
        pop eax
        popf
        pop edi
        pop esi
        leave
        ret
loc_A7013:
        push eax
        push dword [byte ebp+08h]
        call SbStreamSetRate
        add esp, byte 8
        push dword [byte ebp+020h]
        push dword [byte ebp+08h]
        call SbStreamSetVolume
        add esp, byte 8
        push dword [byte ebp+018h]
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call SbStreamSetSample
        add esp, byte 14h
        LD xor, eax, eax
        mov byte [byte esi+03Eh], al
        mov byte [byte esi+03Fh], al
        mov eax, dword [byte ebp+024h]
        mov byte [byte esi+03h], al
        LD or, eax, eax
        je short loc_A707D
        cmp dword [byte ebp+014h], byte 0
        je short loc_A707D
        mov edi, dword [byte ebp+0Ch]
        LD xor, edx, edx
        LD xor, ecx, ecx
        LD xor, eax, eax
loc_A7065:
        mov al, byte [edi]
        mov bx, word [nosplit eax*2+word_D7414]
        inc edi
        LD add, dl, bl
        LD add, dl, bh
        inc ecx
        cmp ecx, dword [byte ebp+014h]
        jb short loc_A7065
        mov byte [byte esi+03Fh], dl
loc_A707D:
        push byte 7Fh
        push dword 0FFh
        push dword [byte ebp+08h]
        call SbStreamPlayNote
        add esp, byte 0Ch
loc_A708F:
        popf
        pop edi
        pop esi
        leave
        ret
SbStreamIdle:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A70AF
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov al, byte [esi]
        cmp al, 0
        jne short loc_A70B7
loc_A70AF:
        mov eax, 1
        pop esi
        leave
        ret
loc_A70B7:
        LD xor, eax, eax
        pop esi
        leave
        ret
SbStreamGetVolume:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A70D8
        mov esi, dword [nosplit esi*4+off_D71F0]
        movzx eax, byte [byte esi+01h]
        pop esi
        leave
        ret
loc_A70D8:
        LD xor, eax, eax
        pop esi
        leave
        ret
SbStreamApplyBend:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov eax, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short loc_A7158
        mov esi, dword [nosplit esi*4+off_D71F0]
        mov edi, dword [byte esi+028h]
        or edi, dword [byte esi+024h]
        ror edi, 10h
        add edi, dword [byte ebp+010h]
        cmp dword [byte ebp+014h], byte 0
        je short loc_A714A
        LD xor, ebx, ebx
        mov bl, byte [byte esi+02h]
        add bl, byte [byte ebp+018h]
        mov eax, dword [nosplit ebx*4+dword_D6B00]
        mul dword [byte esi+020h]
        shl edx, 10h
        shr eax, 10h
        LD or, eax, edx
        LD sub, eax, edi
        mov edx, dword [byte ebp+014h]
        cmp edx, byte 0
        jg short loc_A712E
        jl short loc_A713C
loc_A712E:
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD add, edi, eax
        jmp short loc_A714A
loc_A713C:
        neg edx
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD sub, edi, eax
loc_A714A:
        LD mov, ecx, edi
        shl edi, 10h
        mov dword [byte esi+038h], edi
        shr ecx, 10h
        mov dword [byte esi+034h], ecx
loc_A7158:
        pop edi
        pop esi
        leave
        ret
SbMixAdd8Vol:
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7214], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7216], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7218], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D721A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D721C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D721E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7220], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7222], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7224], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7226], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7228], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D722A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D722C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D722E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7230], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7232], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7234], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7236], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7238], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D723A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D723C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D723E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7240], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7242], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7244], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7246], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7248], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D724A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D724C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D724E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7250], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7252], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7254], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7256], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7258], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D725A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D725C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D725E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7260], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7262], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7264], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7266], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7268], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D726A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D726C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D726E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7270], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7272], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7274], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7276], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7278], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D727A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D727C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D727E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7280], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7282], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7284], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7286], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7288], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D728A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D728C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D728E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7290], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7292], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7294], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7296], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7298], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D729A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D729C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D729E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72A0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72A2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72A4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72A6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72A8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72AA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72AC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72AE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72B0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72B2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72B4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72B6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72B8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72BA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72BC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72BE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72C0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72C2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72C4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72C6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72C8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72CA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72CC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72CE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72D0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72D2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72D4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72D6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72D8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72DA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72DC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72DE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72E0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72E2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72E4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72E6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72E8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72EA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72EC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72EE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72F0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72F2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72F4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72F6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72F8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72FA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72FC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D72FE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7300], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7302], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7304], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7306], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7308], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D730A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D730C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D730E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7310], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7312], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7314], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7316], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7318], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D731A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D731C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D731E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7320], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7322], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7324], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7326], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7328], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D732A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D732C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D732E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7330], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7332], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7334], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7336], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7338], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D733A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D733C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D733E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7340], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7342], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7344], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7346], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7348], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D734A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D734C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D734E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7350], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7352], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7354], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7356], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7358], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D735A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D735C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D735E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7360], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7362], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7364], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7366], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7368], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D736A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D736C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D736E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7370], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7372], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7374], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7376], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7378], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D737A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D737C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D737E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7380], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7382], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7384], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7386], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7388], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D738A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D738C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D738E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7390], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7392], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7394], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7396], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7398], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D739A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D739C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D739E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73A0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73A2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73A4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73A6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73A8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73AA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73AC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73AE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73B0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73B2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73B4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73B6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73B8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73BA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73BC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73BE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73C0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73C2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73C4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73C6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73C8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73CA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73CC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73CE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73D0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73D2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73D4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73D6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73D8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73DA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73DC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73DE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73E0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73E2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73E4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73E6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73E8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73EA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73EC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73EE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73F0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73F2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73F4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73F6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73F8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73FA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73FC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D73FE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7400], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7402], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7404], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7406], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7408], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D740A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D740C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D740E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7410], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [word_D7412], ax
        LD add, ecx, edx
        LD adc, esi, edi
        ret
SbMixAdd8:
        mov al, byte [esi]
        cbw
        add word [word_D7214], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7216], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7218], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D721A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D721C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D721E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7220], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7222], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7224], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7226], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7228], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D722A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D722C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D722E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7230], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7232], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7234], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7236], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7238], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D723A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D723C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D723E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7240], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7242], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7244], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7246], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7248], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D724A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D724C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D724E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7250], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7252], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7254], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7256], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7258], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D725A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D725C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D725E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7260], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7262], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7264], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7266], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7268], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D726A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D726C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D726E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7270], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7272], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7274], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7276], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7278], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D727A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D727C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D727E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7280], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7282], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7284], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7286], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7288], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D728A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D728C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D728E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7290], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7292], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7294], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7296], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7298], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D729A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D729C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D729E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72A0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72A2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72A4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72A6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72A8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72AA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72AC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72AE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72B0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72B2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72B4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72B6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72B8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72BA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72BC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72BE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72C0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72C2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72C4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72C6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72C8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72CA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72CC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72CE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72D0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72D2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72D4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72D6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72D8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72DA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72DC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72DE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72E0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72E2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72E4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72E6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72E8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72EA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72EC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72EE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72F0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72F2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72F4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72F6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72F8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72FA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72FC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D72FE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7300], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7302], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7304], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7306], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7308], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D730A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D730C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D730E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7310], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7312], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7314], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7316], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7318], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D731A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D731C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D731E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7320], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7322], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7324], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7326], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7328], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D732A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D732C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D732E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7330], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7332], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7334], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7336], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7338], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D733A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D733C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D733E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7340], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7342], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7344], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7346], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7348], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D734A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D734C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D734E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7350], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7352], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7354], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7356], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7358], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D735A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D735C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D735E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7360], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7362], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7364], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7366], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7368], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D736A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D736C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D736E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7370], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7372], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7374], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7376], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7378], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D737A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D737C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D737E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7380], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7382], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7384], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7386], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7388], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D738A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D738C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D738E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7390], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7392], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7394], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7396], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7398], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D739A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D739C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D739E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73A0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73A2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73A4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73A6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73A8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73AA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73AC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73AE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73B0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73B2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73B4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73B6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73B8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73BA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73BC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73BE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73C0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73C2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73C4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73C6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73C8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73CA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73CC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73CE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73D0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73D2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73D4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73D6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73D8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73DA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73DC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73DE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73E0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73E2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73E4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73E6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73E8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73EA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73EC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73EE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73F0], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73F2], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73F4], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73F6], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73F8], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73FA], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73FC], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D73FE], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7400], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7402], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7404], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7406], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7408], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D740A], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D740C], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D740E], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7410], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [word_D7412], ax
        LD add, ecx, edx
        LD adc, esi, edi
        ret
SbMixChannels:
        push esi
        push edi
        mov ecx, 80h
        LD xor, eax, eax
        mov edi, word_D7214
loc_A906C:
        mov dword [edi], eax
        add edi, byte 4
        loop loc_A906C
        cmp byte [byte_D6CE0], 0
        je near loc_A933A
        cmp byte [byte_D6CE3], 0
        jne near loc_A91DA
        mov edx, dword [dword_D6D14]
        mov eax, dword [dword_D6D18]
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        add eax, dword [dword_D6D10]
        adc edx, dword [dword_D6D0C]
        cmp edx, dword [dword_D6CFC]
        jae short loc_A911C
        mov eax, dword [dword_D6D0C]
        LD mov, esi, eax
        mov dword [dword_D7200], esi
        mov ecx, dword [dword_D6D10]
        mov edi, dword [dword_D6D14]
        mov edx, dword [dword_D6D18]
        cmp byte [byte_D6CE1], 7Fh
        jb short loc_A90FB
        call SbMixAdd8
        jmp short loc_A9105
loc_A90FB:
        mov ebx, byte_D6D24
        call SbMixAdd8Vol
loc_A9105:
        mov dword [dword_D6D10], ecx
        sub esi, dword [dword_D7200]
        add dword [dword_D6D0C], esi
        jmp near loc_A933A
loc_A911C:
        LD xor, eax, eax
        mov dword [dword_D720C], eax
loc_A9123:
        mov eax, dword [dword_D6D0C]
        mov ebx, dword [dword_D6CFC]
        LD sub, ebx, eax
        mov dword [dword_D7204], ebx
        LD mov, esi, eax
        mov dword [dword_D7200], eax
        add eax, dword [dword_D7204]
        mov dword [dword_D7208], eax
        mov ecx, dword [dword_D6D10]
        mov edi, dword [dword_D6D14]
        mov edx, dword [dword_D6D18]
        LD xor, eax, eax
loc_A915C:
        mov al, byte [esi]
        mov ebx, byte_D6D24
        xlatb
        cbw
        mov ebx, dword [dword_D720C]
        add word [nosplit ebx*2+word_D7214], ax
        inc dword [dword_D720C]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [dword_D7208]
        jae short loc_A9197
        cmp dword [dword_D720C], 100h
        jne short loc_A915C
        jmp near loc_A9105
loc_A9197:
        mov al, byte [byte_D6CE0]
        cmp al, 1
        jne short loc_A91CE
        mov eax, dword [dword_D6CE4]
        LD or, eax, eax
        je short loc_A91CE
        mov eax, dword [dword_D6CF8]
        mov dword [dword_D6D10], ecx
        mov dword [dword_D6D0C], eax
        cmp dword [dword_D720C], 100h
        jne near loc_A9123
        jmp near loc_A933A
loc_A91CE:
        mov al, 0
        mov byte [byte_D6CE0], al
        jmp near loc_A933A
loc_A91DA:
        mov esi, dword [dword_D6D0C]
        mov ecx, dword [dword_D6CFC]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D6D20]
        jbe short loc_A91F6
        mov ecx, dword [dword_D6D20]
loc_A91F6:
        LD add, ecx, esi
        mov dword [dword_D720C], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D6D1E]
loc_A9208:
        mov eax, dword [dword_D6D00]
        cmp eax, 10000h
        je short loc_A9269
        ja near loc_A92A6
loc_A921A:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6D24]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6D24]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A921A
        jmp short loc_A92D0
loc_A9269:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6D24]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6D24]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9269
        jmp short loc_A92D0
loc_A92A6:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6D24]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A92A6
loc_A92D0:
        cmp esi, dword [dword_D6CFC]
        je short loc_A92E6
        mov byte [byte_D6D1E], dl
        mov dword [dword_D6D0C], esi
        jmp short loc_A933A
loc_A92E6:
        mov al, byte [byte_D6CE0]
        cmp al, 1
        jne short loc_A9333
        mov eax, dword [dword_D6CE4]
        LD or, eax, eax
        je short loc_A9333
        mov dl, byte [byte_D6D1F]
        mov byte [byte_D6D1E], dl
        mov eax, dword [dword_D6D0C]
        add eax, dword [dword_D6D20]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_A9327
        mov esi, dword [dword_D6CF8]
        LD add, eax, esi
        mov dword [dword_D720C], eax
        jmp near loc_A9208
loc_A9327:
        mov eax, dword [dword_D6CF8]
        mov dword [dword_D6D0C], eax
        jmp short loc_A933A
loc_A9333:
        mov al, 0
        mov byte [byte_D6CE0], al
loc_A933A:
        cmp byte [byte_D6E24], 0
        je near loc_A9601
        cmp byte [byte_D6E27], 0
        jne near loc_A94A1
        mov edx, dword [dword_D6E58]
        mov eax, dword [dword_D6E5C]
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        add eax, dword [dword_D6E54]
        adc edx, dword [dword_D6E50]
        cmp edx, dword [dword_D6E40]
        jae short loc_A93E3
        mov eax, dword [dword_D6E50]
        LD mov, esi, eax
        mov dword [dword_D7200], esi
        mov ecx, dword [dword_D6E54]
        mov edi, dword [dword_D6E58]
        mov edx, dword [dword_D6E5C]
        cmp byte [byte_D6E25], 7Fh
        jb short loc_A93C2
        call SbMixAdd8
        jmp short loc_A93CC
loc_A93C2:
        mov ebx, byte_D6E68
        call SbMixAdd8Vol
loc_A93CC:
        mov dword [dword_D6E54], ecx
        sub esi, dword [dword_D7200]
        add dword [dword_D6E50], esi
        jmp near loc_A9601
loc_A93E3:
        LD xor, eax, eax
        mov dword [dword_D720C], eax
loc_A93EA:
        mov eax, dword [dword_D6E50]
        mov ebx, dword [dword_D6E40]
        LD sub, ebx, eax
        mov dword [dword_D7204], ebx
        LD mov, esi, eax
        mov dword [dword_D7200], eax
        add eax, dword [dword_D7204]
        mov dword [dword_D7208], eax
        mov ecx, dword [dword_D6E54]
        mov edi, dword [dword_D6E58]
        mov edx, dword [dword_D6E5C]
        LD xor, eax, eax
loc_A9423:
        mov al, byte [esi]
        mov ebx, byte_D6E68
        xlatb
        cbw
        mov ebx, dword [dword_D720C]
        add word [nosplit ebx*2+word_D7214], ax
        inc dword [dword_D720C]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [dword_D7208]
        jae short loc_A945E
        cmp dword [dword_D720C], 100h
        jne short loc_A9423
        jmp near loc_A93CC
loc_A945E:
        mov al, byte [byte_D6E24]
        cmp al, 1
        jne short loc_A9495
        mov eax, dword [dword_D6E28]
        LD or, eax, eax
        je short loc_A9495
        mov eax, dword [dword_D6E3C]
        mov dword [dword_D6E54], ecx
        mov dword [dword_D6E50], eax
        cmp dword [dword_D720C], 100h
        jne near loc_A93EA
        jmp near loc_A9601
loc_A9495:
        mov al, 0
        mov byte [byte_D6E24], al
        jmp near loc_A9601
loc_A94A1:
        mov esi, dword [dword_D6E50]
        mov ecx, dword [dword_D6E40]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D6E64]
        jbe short loc_A94BD
        mov ecx, dword [dword_D6E64]
loc_A94BD:
        LD add, ecx, esi
        mov dword [dword_D720C], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D6E62]
loc_A94CF:
        mov eax, dword [dword_D6E44]
        cmp eax, 10000h
        je short loc_A9530
        ja near loc_A956D
loc_A94E1:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6E68]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6E68]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A94E1
        jmp short loc_A9597
loc_A9530:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6E68]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6E68]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9530
        jmp short loc_A9597
loc_A956D:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6E68]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A956D
loc_A9597:
        cmp esi, dword [dword_D6E40]
        je short loc_A95AD
        mov byte [byte_D6E62], dl
        mov dword [dword_D6E50], esi
        jmp short loc_A9601
loc_A95AD:
        mov al, byte [byte_D6E24]
        cmp al, 1
        jne short loc_A95FA
        mov eax, dword [dword_D6E28]
        LD or, eax, eax
        je short loc_A95FA
        mov dl, byte [byte_D6E63]
        mov byte [byte_D6E62], dl
        mov eax, dword [dword_D6E50]
        add eax, dword [dword_D6E64]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_A95EE
        mov esi, dword [dword_D6E3C]
        LD add, eax, esi
        mov dword [dword_D720C], eax
        jmp near loc_A94CF
loc_A95EE:
        mov eax, dword [dword_D6E3C]
        mov dword [dword_D6E50], eax
        jmp short loc_A9601
loc_A95FA:
        mov al, 0
        mov byte [byte_D6E24], al
loc_A9601:
        cmp byte [byte_D6F68], 0
        je near loc_A98C8
        cmp byte [byte_D6F6B], 0
        jne near loc_A9768
        mov edx, dword [dword_D6F9C]
        mov eax, dword [dword_D6FA0]
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        add eax, dword [dword_D6F98]
        adc edx, dword [dword_D6F94]
        cmp edx, dword [dword_D6F84]
        jae short loc_A96AA
        mov eax, dword [dword_D6F94]
        LD mov, esi, eax
        mov dword [dword_D7200], esi
        mov ecx, dword [dword_D6F98]
        mov edi, dword [dword_D6F9C]
        mov edx, dword [dword_D6FA0]
        cmp byte [byte_D6F69], 7Fh
        jb short loc_A9689
        call SbMixAdd8
        jmp short loc_A9693
loc_A9689:
        mov ebx, byte_D6FAC
        call SbMixAdd8Vol
loc_A9693:
        mov dword [dword_D6F98], ecx
        sub esi, dword [dword_D7200]
        add dword [dword_D6F94], esi
        jmp near loc_A98C8
loc_A96AA:
        LD xor, eax, eax
        mov dword [dword_D720C], eax
loc_A96B1:
        mov eax, dword [dword_D6F94]
        mov ebx, dword [dword_D6F84]
        LD sub, ebx, eax
        mov dword [dword_D7204], ebx
        LD mov, esi, eax
        mov dword [dword_D7200], eax
        add eax, dword [dword_D7204]
        mov dword [dword_D7208], eax
        mov ecx, dword [dword_D6F98]
        mov edi, dword [dword_D6F9C]
        mov edx, dword [dword_D6FA0]
        LD xor, eax, eax
loc_A96EA:
        mov al, byte [esi]
        mov ebx, byte_D6FAC
        xlatb
        cbw
        mov ebx, dword [dword_D720C]
        add word [nosplit ebx*2+word_D7214], ax
        inc dword [dword_D720C]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [dword_D7208]
        jae short loc_A9725
        cmp dword [dword_D720C], 100h
        jne short loc_A96EA
        jmp near loc_A9693
loc_A9725:
        mov al, byte [byte_D6F68]
        cmp al, 1
        jne short loc_A975C
        mov eax, dword [dword_D6F6C]
        LD or, eax, eax
        je short loc_A975C
        mov eax, dword [dword_D6F80]
        mov dword [dword_D6F98], ecx
        mov dword [dword_D6F94], eax
        cmp dword [dword_D720C], 100h
        jne near loc_A96B1
        jmp near loc_A98C8
loc_A975C:
        mov al, 0
        mov byte [byte_D6F68], al
        jmp near loc_A98C8
loc_A9768:
        mov esi, dword [dword_D6F94]
        mov ecx, dword [dword_D6F84]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D6FA8]
        jbe short loc_A9784
        mov ecx, dword [dword_D6FA8]
loc_A9784:
        LD add, ecx, esi
        mov dword [dword_D720C], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D6FA6]
loc_A9796:
        mov eax, dword [dword_D6F88]
        cmp eax, 10000h
        je short loc_A97F7
        ja near loc_A9834
loc_A97A8:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6FAC]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6FAC]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A97A8
        jmp short loc_A985E
loc_A97F7:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6FAC]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D6FAC]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A97F7
        jmp short loc_A985E
loc_A9834:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D6FAC]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9834
loc_A985E:
        cmp esi, dword [dword_D6F84]
        je short loc_A9874
        mov byte [byte_D6FA6], dl
        mov dword [dword_D6F94], esi
        jmp short loc_A98C8
loc_A9874:
        mov al, byte [byte_D6F68]
        cmp al, 1
        jne short loc_A98C1
        mov eax, dword [dword_D6F6C]
        LD or, eax, eax
        je short loc_A98C1
        mov dl, byte [byte_D6FA7]
        mov byte [byte_D6FA6], dl
        mov eax, dword [dword_D6F94]
        add eax, dword [dword_D6FA8]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_A98B5
        mov esi, dword [dword_D6F80]
        LD add, eax, esi
        mov dword [dword_D720C], eax
        jmp near loc_A9796
loc_A98B5:
        mov eax, dword [dword_D6F80]
        mov dword [dword_D6F94], eax
        jmp short loc_A98C8
loc_A98C1:
        mov al, 0
        mov byte [byte_D6F68], al
loc_A98C8:
        cmp byte [byte_D70AC], 0
        je near loc_A9B8F
        cmp byte [byte_D70AF], 0
        jne near loc_A9A2F
        mov edx, dword [dword_D70E0]
        mov eax, dword [dword_D70E4]
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        shl eax, 1
        rcl edx, 1
        add eax, dword [dword_D70DC]
        adc edx, dword [dword_D70D8]
        cmp edx, dword [dword_D70C8]
        jae short loc_A9971
        mov eax, dword [dword_D70D8]
        LD mov, esi, eax
        mov dword [dword_D7200], esi
        mov ecx, dword [dword_D70DC]
        mov edi, dword [dword_D70E0]
        mov edx, dword [dword_D70E4]
        cmp byte [byte_D70AD], 7Fh
        jb short loc_A9950
        call SbMixAdd8
        jmp short loc_A995A
loc_A9950:
        mov ebx, byte_D70F0
        call SbMixAdd8Vol
loc_A995A:
        mov dword [dword_D70DC], ecx
        sub esi, dword [dword_D7200]
        add dword [dword_D70D8], esi
        jmp near loc_A9B8F
loc_A9971:
        LD xor, eax, eax
        mov dword [dword_D720C], eax
loc_A9978:
        mov eax, dword [dword_D70D8]
        mov ebx, dword [dword_D70C8]
        LD sub, ebx, eax
        mov dword [dword_D7204], ebx
        LD mov, esi, eax
        mov dword [dword_D7200], eax
        add eax, dword [dword_D7204]
        mov dword [dword_D7208], eax
        mov ecx, dword [dword_D70DC]
        mov edi, dword [dword_D70E0]
        mov edx, dword [dword_D70E4]
        LD xor, eax, eax
loc_A99B1:
        mov al, byte [esi]
        mov ebx, byte_D70F0
        xlatb
        cbw
        mov ebx, dword [dword_D720C]
        add word [nosplit ebx*2+word_D7214], ax
        inc dword [dword_D720C]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [dword_D7208]
        jae short loc_A99EC
        cmp dword [dword_D720C], 100h
        jne short loc_A99B1
        jmp near loc_A995A
loc_A99EC:
        mov al, byte [byte_D70AC]
        cmp al, 1
        jne short loc_A9A23
        mov eax, dword [dword_D70B0]
        LD or, eax, eax
        je short loc_A9A23
        mov eax, dword [dword_D70C4]
        mov dword [dword_D70DC], ecx
        mov dword [dword_D70D8], eax
        cmp dword [dword_D720C], 100h
        jne near loc_A9978
        jmp near loc_A9B8F
loc_A9A23:
        mov al, 0
        mov byte [byte_D70AC], al
        jmp near loc_A9B8F
loc_A9A2F:
        mov esi, dword [dword_D70D8]
        mov ecx, dword [dword_D70C8]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D70EC]
        jbe short loc_A9A4B
        mov ecx, dword [dword_D70EC]
loc_A9A4B:
        LD add, ecx, esi
        mov dword [dword_D720C], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D70EA]
loc_A9A5D:
        mov eax, dword [dword_D70CC]
        cmp eax, 10000h
        je short loc_A9ABE
        ja near loc_A9AFB
loc_A9A6F:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D70F0]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D70F0]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9A6F
        jmp short loc_A9B25
loc_A9ABE:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D70F0]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+byte_D70F0]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9ABE
        jmp short loc_A9B25
loc_A9AFB:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        movsx ax, byte [dword edx+byte_D70F0]
        add word [nosplit ecx*2+word_D7214], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [dword_D720C]
        jb short loc_A9AFB
loc_A9B25:
        cmp esi, dword [dword_D70C8]
        je short loc_A9B3B
        mov byte [byte_D70EA], dl
        mov dword [dword_D70D8], esi
        jmp short loc_A9B8F
loc_A9B3B:
        mov al, byte [byte_D70AC]
        cmp al, 1
        jne short loc_A9B88
        mov eax, dword [dword_D70B0]
        LD or, eax, eax
        je short loc_A9B88
        mov dl, byte [byte_D70EB]
        mov byte [byte_D70EA], dl
        mov eax, dword [dword_D70D8]
        add eax, dword [dword_D70EC]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_A9B7C
        mov esi, dword [dword_D70C4]
        LD add, eax, esi
        mov dword [dword_D720C], eax
        jmp near loc_A9A5D
loc_A9B7C:
        mov eax, dword [dword_D70C4]
        mov dword [dword_D70D8], eax
        jmp short loc_A9B8F
loc_A9B88:
        mov al, 0
        mov byte [byte_D70AC], al
loc_A9B8F:
        mov ecx, 100h
        mov esi, word_D7214
        call SbConvertMix
        pop edi
        pop esi
        ret
        db 00h,00h,00h
SbDmaHalfReady:
        call sub_AA1B2
        cmp eax, dword [dword_D7A1E]
        jge short loc_A9BB5
        LD xor, eax, eax
        jmp short loc_A9BBA
loc_A9BB5:
        mov eax, dword [dword_D7A1E]
loc_A9BBA:
        mov ebx, dword [dword_D7614]
        LD cmp, eax, ebx
        je short loc_A9BCA
        mov eax, 1
        ret
loc_A9BCA:
        mov eax, 0
        ret
SbDmaStart:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+010h]
        shr ebx, 1
        mov dword [dword_D7A1E], ebx
        mov ebx, dword [byte ebp+0Ch]
        mov dword [dword_D7A22], ebx
        push dword [byte ebp+010h]
        push ebx
        push dword [byte ebp+08h]
        push edx
        push eax
        call sub_A9F93
        add esp, byte 14h
        cmp eax, byte 0FFFFFFFFh
        je short loc_A9C08
        mov al, 1
        mov byte [byte_D7618], al
        LD xor, eax, eax
        leave
        ret
loc_A9C08:
        LD xor, eax, eax
        mov byte [byte_D7618], al
        call sub_A9E34
        mov eax, 0FFFFFFFFh
        leave
        ret
SbDmaStop:
        push esi
        pushfw
        cmp byte [byte_D7618], 0
        je short loc_A9C33
        LD xor, eax, eax
        mov byte [byte_D7618], al
        call sub_A9E34
loc_A9C33:
        popfw
        pop esi
        ret
SbMixPause:
        mov eax, 1
        mov byte [byte_D7619], al
        ret
        LD xor, eax, eax
        mov byte [byte_D7619], al
        ret
SbConvertMix:
        push esi
        push edi
        cld
        mov ecx, dword [dword_D7A1E]
        mov eax, dword [dword_D7614]
        mov edi, dword [dword_D7A22]
        LD add, edi, eax
loc_A9C60:
        movsx ebx, word [esi]
        mov al, byte [dword ebx+byte_D781C]
        mov byte [edi], al
        add esi, byte 2
        inc edi
        loop loc_A9C60
        mov eax, dword [dword_D7A1E]
        xor dword [dword_D7614], eax
        pop edi
        pop esi
        ret
        db 00h
unk_A9C80:
        db 00h
unk_A9C81:
        db 00h,00h
unk_A9C83:
        db 00h,00h
unk_A9C85:
        db 00h
unk_A9C86:
        db 020h,02h
unk_A9C88:
        db 05h
unk_A9C89:
        db 01h
unk_A9C8A:
        db 00h,00h,00h,00h
unk_A9C8E:
        db 00h
unk_A9C8F:
        db 00h
unk_A9C90:
        db 00h
unk_A9C91:
        db 00h
unk_A9C92:
        db 00h,00h,00h,00h
unk_A9C96:
        db 00h,00h
unk_A9C98:
        db 087h,083h,081h,082h
