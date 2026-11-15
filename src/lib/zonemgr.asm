; The zone manager. Windows on screen, and which one has the mouse.
bits 32
%include "hockey.inc"
section s_6A033 progbits alloc exec nowrite align=1
extern __CHK, str_ZMHiddenWindowNoHiddenWindow, str_ZMBackgroundWindowNo, str_ZONEMGR, byte_D42C3, byte_EA058, dword_EA034, dword_EA038
extern dword_EA03C, dword_EA040, dword_EA044, dword_EA048, dword_EA04C, dword_EA050, dword_EA054, dword_EA05C
extern dword_EA060, dword_EA064, dword_EA068, dword_EA06C, dword_EA070, dword_EA074, dword_EA078, dword_EA07C
extern dword_EA080, dword_EA084, dword_EA088, dword_EA08C, dword_EA090, dword_EA094, dword_EA098, dword_EA09C
extern dword_EA0A0, dword_EA0A4, dword_EA0AC, dword_EA0B0, dword_EA0B4, dword_EA0B8, dword_EA0BC, dword_EA0C4
extern dword_EA0C8, dword_EA0CC, dword_EA0D0, FatalError, fputchar, FreeMemBlock, memset_, SetDrawBitmap
extern AllocMemBlock, PutBlock, sub_B4BA8, SetClipWindow, sub_B4FAC
global sub_6A033, sub_6A044, sub_6A057, sub_6A068, sub_6A078, sub_6A092, sub_6A0AA, sub_6A0C4
global sub_6A0DE, sub_6A0F6, sub_6A106, loc_6A12A, loc_6A13E, loc_6A149, sub_6A156, sub_6A166
global loc_6A18A, sub_6A1A0, sub_6A1D6, sub_6A234, sub_6A27A, sub_6A2BC, sub_6A2C7, sub_6A335
global sub_6A373, loc_6A3B9, loc_6A3BA, sub_6A3C0, loc_6A3FA, loc_6A41D, sub_6A439, loc_6A479
global sub_6A48E, loc_6A4A8, loc_6A4AD, loc_6A4CB, sub_6A4D3, loc_6A4FD, loc_6A4FF, loc_6A51E
global loc_6A520, loc_6A535, loc_6A53C, loc_6A542, loc_6A549, loc_6A561, loc_6A563, loc_6A57E
global loc_6A580, loc_6A593, loc_6A59C, loc_6A59E, sub_6A5A5, loc_6A5BF, loc_6A5C4, loc_6A5E2
global loc_6A5E7, sub_6A5EA, loc_6A60A, loc_6A61F, loc_6A632, loc_6A645, sub_6A649, loc_6A669
global loc_6A679, loc_6A693, loc_6A698, loc_6A6A6, sub_6A6CC, loc_6A6E5, loc_6A712, loc_6A748
global loc_6A755, loc_6A771, sub_6A791, loc_6A7E1, loc_6A7E8, loc_6A7FF, loc_6A801, loc_6A824
global loc_6A82B, loc_6A840, loc_6A842, loc_6A853, loc_6A855, loc_6A86C, loc_6A86E, loc_6A88B
global loc_6A8A9, sub_6A8B1, loc_6A8E2, loc_6A909, loc_6A916, loc_6A91C, loc_6A941, loc_6A94A
global loc_6A954, loc_6A95A, loc_6A97C, loc_6A989, loc_6A98E, sub_6A990, loc_6A9AB, loc_6A9B9
global sub_6A9CE, loc_6A9EA, loc_6AA6E, loc_6AA8A, loc_6AAA4, loc_6AAB0, sub_6AAD5, sub_6AAF5
global loc_6AB54, loc_6AB5C, loc_6AB64, loc_6AB70, loc_6AB78, sub_6AB7C, loc_6ABD2, loc_6ABD8
global loc_6ABE0, loc_6ABE8, loc_6ABF4, sub_6ABF9, sub_6AC31, loc_6AC63, loc_6AC73, loc_6AC7A
global loc_6AC85, loc_6AC8E, loc_6AC9A, sub_6ACA2, loc_6ACC5, loc_6ACE3, sub_6ACE9, sub_6AD22
global sub_6AD4F, loc_6AD6D, loc_6AD7A, loc_6AD80, sub_6ADA7, loc_6ADDB, loc_6ADE9, loc_6AE0C
global loc_6AE24, loc_6AE44, sub_6AE5C, loc_6AE79, loc_6AE8C, loc_6AE9B, loc_6AEAE, loc_6AEC2
global loc_6AED5, loc_6AEEB, loc_6AEFF, loc_6AF0E, loc_6AF1B, loc_6AF35, loc_6AF48, sub_6AF52
global sub_6AF97, sub_6AFAD, sub_6AFBE, loc_6AFDA, sub_6AFDF, loc_6B001, sub_6B008, loc_6B03F
global loc_6B05F
sub_6A033:
        push dword 4
        call __CHK
        or dword [byte_EA058], eax
        ret
sub_6A044:
        push dword 4
        call __CHK
        not eax
        and dword [byte_EA058], eax
        ret
sub_6A057:
        push dword 4
        call __CHK
        xor dword [byte_EA058], eax
        ret
sub_6A068:
        push dword 4
        call __CHK
        mov eax, dword [byte_EA058]
        ret
sub_6A078:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [dword_EA09C]
        or dword [ebx+eax], edx
        pop ebx
        ret
sub_6A092:
        push dword 8
        call __CHK
        push ebx
        mov ebx, dword [dword_EA09C]
        not edx
        and dword [ebx+eax*4], edx
        pop ebx
        ret
sub_6A0AA:
        push dword 8
        call __CHK
        push ebx
        mov ebx, eax
        shl ebx, 2
        mov eax, dword [dword_EA09C]
        xor dword [ebx+eax], edx
        pop ebx
        ret
sub_6A0C4:
        push dword 8
        call __CHK
        push edx
        mov edx, eax
        shl edx, 2
        mov eax, dword [dword_EA09C]
        mov eax, dword [edx+eax]
        pop edx
        ret
sub_6A0DE:
        push dword 8
        call __CHK
        push edx
        shl eax, 4
        mov edx, dword [dword_EA074]
        add eax, edx
        pop edx
        ret
sub_6A0F6:
        push dword 4
        call __CHK
        mov dword [dword_EA0AC], eax
        ret
sub_6A106:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [dword_EA0AC], byte 0
        jne short loc_6A12A
        push str_ZMHiddenWindowNoHiddenWindow
        call FatalError
        add esp, byte 4
loc_6A12A:
        mov ebx, dword [dword_EA0AC]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [dword_EA0AC]
loc_6A13E:
        mov ecx, dword [byte eax+04h]
        push ecx
        push byte 0
        mov esi, dword [eax]
        push esi
        push byte 0
loc_6A149:
        call SetClipWindow
        add esp, byte 10h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A156:
        push dword 4
        call __CHK
        mov dword [dword_EA0B0], eax
        ret
sub_6A166:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        cmp dword [dword_EA0B0], byte 0
        jne short loc_6A18A
        push str_ZMBackgroundWindowNo
        call FatalError
        add esp, byte 4
loc_6A18A:
        mov ebx, dword [dword_EA0B0]
        push ebx
        call SetDrawBitmap
        add esp, byte 4
        mov eax, dword [dword_EA0B0]
        jmp short loc_6A13E
sub_6A1A0:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [dword_EA0BC]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+08h]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+04h]
        mov esi, dword [dword_EA0B8]
        add edx, esi
        push edx
        mov eax, dword [eax]
        add eax, esi
        push eax
        jmp near loc_6A149
sub_6A1D6:
        push dword 28h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push ebp
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [dword_EA0BC]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+08h]
        add edx, ebx
        push edx
        mov edx, dword [byte eax+04h]
        mov esi, dword [dword_EA0B8]
        add edx, esi
        push edx
        mov eax, dword [eax]
        add eax, esi
        push eax
        call SetClipWindow
        add esp, byte 10h
        mov ebp, dword [dword_EA0BC]
        push ebp
        mov eax, dword [dword_EA0B8]
        push eax
        mov eax, dword [dword_EA0AC]
        mov edx, dword [byte eax+02Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
        pop ebp
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A234:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push dword 0A8h
        push byte 0
        push dword 140h
        push byte 0
        call SetClipWindow
        add esp, byte 10h
        mov edx, dword [dword_EA0BC]
        push edx
        mov ebx, dword [dword_EA0B8]
        push ebx
        mov eax, dword [dword_EA0AC]
        mov ecx, dword [byte eax+02Ch]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A27A:
        push dword 8
        call __CHK
        push edx
        mov eax, dword [dword_EA054]
        add dword [byte eax+04h], byte 2
        mov eax, dword [dword_EA054]
        mov edx, dword [eax]
        sar edx, 2
        shl edx, 2
        mov dword [eax], edx
        mov eax, dword [dword_EA054]
        mov edx, dword [byte eax+04h]
        dec edx
        sar edx, 2
        shl edx, 2
        add edx, byte 4
        mov dword [byte eax+04h], edx
        mov eax, dword [dword_EA054]
        inc dword [byte eax+0Ch]
        pop edx
        ret
sub_6A2BC:
        push dword 4
        call __CHK
        ret
sub_6A2C7:
        push dword 28h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        mov dword [esp], ecx
        mov edx, dword [byte esp+014h]
        push edx
        push ecx
        push eax
        push edi
        push eax
        call sub_B4FAC
        add esp, byte 14h
        mov ecx, dword [byte esp+014h]
        push ecx
        mov eax, dword [byte esp+04h]
        push eax
        push ebp
        push eax
        push esi
        call sub_B4FAC
        add esp, byte 14h
        mov ebx, dword [byte esp+014h]
        push ebx
        push edi
        push ebp
        mov ecx, dword [byte esp+0Ch]
        push ecx
        push ebp
        call sub_B4FAC
        add esp, byte 14h
        mov eax, dword [byte esp+014h]
        push eax
        push edi
        push esi
        push edi
        push ebp
        call sub_B4FAC
        add esp, byte 14h
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        ret 4
sub_6A335:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edx
        mov edx, dword [byte eax+0Ch]
        add edx, dword [dword_EA0BC]
        lea ecx, [byte edx-01h]
        mov edx, dword [byte eax+04h]
        mov esi, dword [dword_EA0B8]
        add edx, esi
        lea ebx, [byte edx-01h]
        mov edx, dword [byte eax+08h]
        add edx, dword [dword_EA0BC]
        mov eax, dword [eax]
        add eax, esi
        call sub_6A2C7
        pop esi
        pop ecx
        pop ebx
        ret
sub_6A373:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [byte eax+0Ch]
        push edx
        mov ebx, dword [byte eax+08h]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        mov esi, dword [eax]
        push esi
        call SetClipWindow
        add esp, byte 10h
        mov edi, dword [dword_EA0BC]
        push edi
        mov ebp, dword [dword_EA0B8]
        push ebp
        mov eax, dword [dword_EA0B0]
        mov edx, dword [byte eax+02Ch]
        push edx
        call PutBlock
        add esp, byte 0Ch
loc_6A3B9:
        pop ebp
loc_6A3BA:
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A3C0:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp dword [dword_EA098], byte 0
        je short loc_6A3FA
        mov eax, dword [dword_EA080]
        mov dword [dword_EA074], eax
        mov eax, dword [dword_EA0A4]
        mov dword [dword_EA09C], eax
        mov eax, dword [dword_EA084]
        mov dword [dword_EA094], eax
        mov eax, dword [dword_EA0A0]
        jmp short loc_6A41D
loc_6A3FA:
        mov eax, dword [dword_EA084]
        mov dword [dword_EA074], eax
        mov eax, dword [dword_EA0A0]
        mov dword [dword_EA09C], eax
        mov eax, dword [dword_EA080]
        mov dword [dword_EA094], eax
        mov eax, dword [dword_EA0A4]
loc_6A41D:
        mov dword [dword_EA08C], eax
        mov ebx, dword [dword_EA0B4]
        add ebx, ebx
        mov eax, dword [dword_EA09C]
        xor edx, edx
        call memset_
        pop edx
        pop ebx
        ret
sub_6A439:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        cmp dword [dword_EA07C], byte 0
        je short loc_6A479
        mov edx, dword [dword_EA064]
        shl edx, 2
        mov eax, dword [dword_EA090]
        add eax, edx
        mov edx, dword [dword_EA070]
        mov dword [eax], edx
        xor ebx, ebx
        mov dword [dword_EA07C], ebx
        mov eax, dword [dword_EA06C]
        mov dword [dword_EA070], eax
loc_6A479:
        mov ecx, 0FFFFFFFFh
        mov dword [dword_EA064], ecx
        mov dword [dword_EA06C], ecx
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A48E:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [dword_EA068]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+0Ch]
        jge short loc_6A4AD
loc_6A4A8:
        xor eax, eax
        pop edx
        pop ebx
        ret
loc_6A4AD:
        mov ebx, dword [byte eax+04h]
        cmp ebx, dword [byte edx+04h]
        jl short loc_6A4A8
        mov ebx, dword [eax]
        cmp ebx, dword [edx]
        jg short loc_6A4A8
        mov eax, dword [byte eax+08h]
        cmp eax, dword [byte edx+08h]
        jle short loc_6A4CB
        mov eax, 2
        pop edx
        pop ebx
        ret
loc_6A4CB:
        mov eax, 1
        pop edx
        pop ebx
        ret
sub_6A4D3:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [dword_EA068]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+08h]
        jne short loc_6A549
        mov ebx, dword [eax]
        sub ebx, dword [edx]
        test ebx, ebx
        jge short loc_6A4FD
        mov edx, ebx
        neg edx
        jmp short loc_6A4FF
loc_6A4FD:
        mov edx, ebx
loc_6A4FF:
        cmp edx, byte 10h
        jg near loc_6A59C
        mov ecx, dword [dword_EA068]
        mov edx, dword [byte eax+04h]
        sub edx, dword [byte ecx+04h]
        test edx, edx
        jge short loc_6A51E
        mov ecx, edx
        neg ecx
        jmp short loc_6A520
loc_6A51E:
        mov ecx, edx
loc_6A520:
        cmp ecx, byte 10h
        jg near loc_6A59C
        mov ecx, dword [dword_EA068]
        mov ecx, dword [byte ecx+0Ch]
        mov dword [byte eax+0Ch], ecx
loc_6A535:
        test edx, edx
        jge short loc_6A53C
        sub dword [byte eax+04h], edx
loc_6A53C:
        test ebx, ebx
        jle short loc_6A542
        sub dword [eax], ebx
loc_6A542:
        mov edx, 1
        jmp short loc_6A59E
loc_6A549:
        mov ebx, dword [byte eax+08h]
        mov esi, dword [byte edx+0Ch]
        cmp ebx, esi
        jne short loc_6A593
        mov ebx, dword [eax]
        sub ebx, dword [edx]
        test ebx, ebx
        jge short loc_6A561
        mov edx, ebx
        neg edx
        jmp short loc_6A563
loc_6A561:
        mov edx, ebx
loc_6A563:
        cmp edx, byte 10h
        jg short loc_6A59C
        mov ecx, dword [dword_EA068]
        mov edx, dword [byte eax+04h]
        sub edx, dword [byte ecx+04h]
        test edx, edx
        jge short loc_6A57E
        mov ecx, edx
        neg ecx
        jmp short loc_6A580
loc_6A57E:
        mov ecx, edx
loc_6A580:
        cmp ecx, byte 10h
        jg short loc_6A59C
        mov ecx, dword [dword_EA068]
        mov ecx, dword [byte ecx+08h]
        mov dword [byte eax+08h], ecx
        jmp short loc_6A535
loc_6A593:
        jle short loc_6A59C
        mov edx, 2
        jmp short loc_6A59E
loc_6A59C:
        xor edx, edx
loc_6A59E:
        mov eax, edx
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A5A5:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        mov edx, dword [dword_EA068]
        mov ebx, dword [byte eax+0Ch]
        cmp ebx, dword [byte edx+08h]
        jg short loc_6A5C4
loc_6A5BF:
        xor eax, eax
        pop edx
        pop ebx
        ret
loc_6A5C4:
        mov ebx, dword [byte eax+04h]
        cmp ebx, dword [edx]
        jle short loc_6A5BF
        mov ebx, dword [eax]
        cmp ebx, dword [byte edx+04h]
        jge short loc_6A5BF
        mov eax, dword [byte eax+08h]
        cmp eax, dword [byte edx+0Ch]
        jl short loc_6A5E2
        mov eax, 2
        pop edx
        pop ebx
        ret
loc_6A5E2:
        mov eax, 1
loc_6A5E7:
        pop edx
        pop ebx
        ret
sub_6A5EA:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov eax, dword [dword_EA068]
        mov edx, dword [eax]
        mov ebx, dword [dword_EA034]
        cmp edx, ebx
        jge short loc_6A60A
        mov dword [eax], ebx
loc_6A60A:
        mov eax, dword [dword_EA068]
        mov edx, dword [byte eax+08h]
        mov ecx, dword [dword_EA03C]
        cmp edx, ecx
        jge short loc_6A61F
        mov dword [byte eax+08h], ecx
loc_6A61F:
        mov eax, dword [dword_EA068]
        mov edx, dword [dword_EA038]
        cmp edx, dword [byte eax+04h]
        jge short loc_6A632
        mov dword [byte eax+04h], edx
loc_6A632:
        mov eax, dword [dword_EA068]
        mov edx, dword [dword_EA040]
        cmp edx, dword [byte eax+0Ch]
        jge short loc_6A645
        mov dword [byte eax+0Ch], edx
loc_6A645:
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A649:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov ebx, eax
        mov ecx, 0FFFFFFFFh
        mov eax, dword [dword_EA06C]
        mov edx, dword [dword_EA090]
loc_6A669:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6A679
        cmp eax, ebx
        je short loc_6A679
        mov ecx, eax
        mov eax, dword [edx+eax*4]
        jmp short loc_6A669
loc_6A679:
        mov edx, dword [dword_EA090]
        mov eax, dword [edx+eax*4]
        cmp ecx, byte 0FFFFFFFFh
        jne short loc_6A693
        mov eax, ebx
        mov eax, dword [edx+eax*4]
        mov dword [dword_EA06C], eax
        jmp short loc_6A698
loc_6A693:
        mov esi, ecx
        mov dword [edx+esi*4], eax
loc_6A698:
        cmp ebx, dword [dword_EA064]
        jne short loc_6A6A6
        mov dword [dword_EA064], ecx
loc_6A6A6:
        mov eax, ebx
        shl eax, 2
        mov edx, dword [dword_EA090]
        add eax, edx
        mov edx, dword [dword_EA070]
        mov dword [eax], edx
        mov dword [dword_EA070], ebx
        dec dword [dword_EA07C]
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6A6CC:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov eax, dword [dword_EA06C]
        mov ecx, 0FFFFFFFFh
loc_6A6E5:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6A712
        mov edx, eax
        shl edx, 4
        mov ebx, dword [dword_EA060]
        add ebx, edx
        mov edx, dword [dword_EA068]
        mov edx, dword [byte edx+08h]
        cmp edx, dword [byte ebx+08h]
        jl short loc_6A712
        mov ecx, eax
        mov edx, dword [dword_EA090]
        mov eax, dword [edx+eax*4]
        jmp short loc_6A6E5
loc_6A712:
        mov eax, dword [dword_EA070]
        mov esi, eax
        shl esi, 2
        mov ebx, dword [dword_EA090]
        lea edx, [ebx+esi]
        mov edi, dword [edx]
        mov dword [dword_EA070], edi
        cmp ecx, byte 0FFFFFFFFh
        je short loc_6A748
        mov edx, ecx
        shl edx, 2
        add edx, ebx
        mov ebx, dword [edx]
        mov dword [edx], eax
        mov edx, dword [dword_EA090]
        mov dword [edx+esi], ebx
        jmp short loc_6A755
loc_6A748:
        mov ebx, dword [dword_EA06C]
        mov dword [edx], ebx
        mov dword [dword_EA06C], eax
loc_6A755:
        cmp ecx, dword [dword_EA064]
        jne short loc_6A771
        mov dword [dword_EA064], eax
        mov edx, eax
        mov ebx, dword [dword_EA090]
        mov dword [ebx+edx*4], 0FFFFFFFFh
loc_6A771:
        mov esi, dword [dword_EA068]
        shl eax, 4
        mov edi, dword [dword_EA060]
        add edi, eax
        movsd
        movsd
        movsd
        movsd
        inc dword [dword_EA07C]
        jmp near loc_6A3BA
sub_6A791:
        push dword 4Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov ecx, eax
        mov edx, eax
        shl edx, 4
        mov eax, dword [dword_EA060]
        add edx, eax
        lea edi, [byte esp+020h]
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov ebx, dword [dword_EA068]
        mov eax, dword [byte edx+08h]
        mov esi, dword [byte ebx+08h]
        cmp eax, esi
        jge short loc_6A7E8
        lea edi, [byte esp+010h]
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte ebx+08h]
        mov dword [byte esp+01Ch], eax
        mov dword [byte esp+028h], eax
loc_6A7E1:
        mov ebp, 1
        jmp short loc_6A801
loc_6A7E8:
        cmp esi, eax
        jge short loc_6A7FF
        lea edi, [byte esp+010h]
        mov esi, ebx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte edx+08h]
        mov dword [byte esp+01Ch], eax
        jmp short loc_6A7E1
loc_6A7FF:
        xor ebp, ebp
loc_6A801:
        mov ebx, dword [dword_EA068]
        mov eax, dword [byte edx+0Ch]
        mov esi, dword [byte ebx+0Ch]
        cmp eax, esi
        jle short loc_6A82B
        mov edi, esp
        mov esi, edx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte ebx+0Ch]
        mov dword [byte esp+08h], eax
        mov dword [byte esp+02Ch], eax
loc_6A824:
        mov esi, 1
        jmp short loc_6A842
loc_6A82B:
        cmp esi, eax
        jle short loc_6A840
        mov edi, esp
        mov esi, ebx
        movsd
        movsd
        movsd
        movsd
        mov eax, dword [byte edx+0Ch]
        mov dword [byte esp+08h], eax
        jmp short loc_6A824
loc_6A840:
        xor esi, esi
loc_6A842:
        mov eax, dword [dword_EA068]
        mov ebx, dword [eax]
        mov edi, dword [edx]
        cmp ebx, edi
        jge short loc_6A853
        mov eax, ebx
        jmp short loc_6A855
loc_6A853:
        mov eax, edi
loc_6A855:
        mov dword [byte esp+020h], eax
        mov eax, dword [dword_EA068]
        mov ebx, dword [byte eax+04h]
        mov edi, dword [byte edx+04h]
        cmp ebx, edi
        jle short loc_6A86C
        mov eax, ebx
        jmp short loc_6A86E
loc_6A86C:
        mov eax, edi
loc_6A86E:
        mov dword [byte esp+024h], eax
        mov eax, ecx
        call sub_6A649
        test ebp, ebp
        je short loc_6A88B
        mov edx, 1
        lea eax, [byte esp+010h]
        call sub_6A8B1
loc_6A88B:
        mov edx, 1
        lea eax, [byte esp+020h]
        call sub_6A8B1
        test esi, esi
        je short loc_6A8A9
        mov edx, 1
        mov eax, esp
        call sub_6A8B1
loc_6A8A9:
        add esp, byte 30h
        jmp near loc_6A3B9
sub_6A8B1:
        push dword 8
        call __CHK
        push ebx
        mov dword [dword_EA068], eax
        test edx, edx
        jne short loc_6A916
        mov eax, dword_EA034
        call sub_6A5A5
        test eax, eax
        je near loc_6A98E
        call sub_6A5EA
        mov edx, dword [dword_EA06C]
loc_6A8E2:
        cmp edx, byte 0FFFFFFFFh
        je short loc_6A916
        mov eax, edx
        shl eax, 4
        mov ebx, dword [dword_EA060]
        add eax, ebx
        call sub_6A48E
        cmp eax, byte 1
        jb short loc_6A909
        jbe near loc_6A98E
        cmp eax, byte 2
        je short loc_6A916
loc_6A909:
        mov eax, edx
        mov edx, dword [dword_EA090]
        mov edx, dword [edx+eax*4]
        jmp short loc_6A8E2
loc_6A916:
        mov edx, dword [dword_EA06C]
loc_6A91C:
        cmp edx, byte 0FFFFFFFFh
        je short loc_6A954
        mov eax, edx
        shl eax, 4
        mov ebx, dword [dword_EA060]
        add eax, ebx
        call sub_6A5A5
        cmp eax, byte 1
        jb short loc_6A94A
        jbe short loc_6A941
        cmp eax, byte 2
        je short loc_6A954
        jmp short loc_6A94A
loc_6A941:
        mov eax, edx
        call sub_6A791
        pop ebx
        ret
loc_6A94A:
        mov eax, dword [dword_EA090]
        mov edx, dword [eax+edx*4]
        jmp short loc_6A91C
loc_6A954:
        mov edx, dword [dword_EA06C]
loc_6A95A:
        cmp edx, byte 0FFFFFFFFh
        je short loc_6A989
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [dword_EA060]
        add eax, ebx
        call sub_6A4D3
        cmp eax, byte 1
        jb short loc_6A97C
        jbe short loc_6A98E
        cmp eax, byte 2
        je short loc_6A989
loc_6A97C:
        mov eax, edx
        mov edx, dword [dword_EA090]
        mov edx, dword [edx+eax*4]
        jmp short loc_6A95A
loc_6A989:
        call sub_6A6CC
loc_6A98E:
        pop ebx
        ret
sub_6A990:
        push dword 0Ch
        call __CHK
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        mov ebx, dword [dword_EA0B4]
        shl ebx, 2
        add ebx, edx
loc_6A9AB:
        test byte [ecx], 4
        je short loc_6A9B9
        xor edx, edx
        mov eax, esi
        call sub_6A8B1
loc_6A9B9:
        add esi, byte 10h
        add ecx, byte 4
        cmp ecx, ebx
        setb al
        and eax, 0FFh
        jne short loc_6A9AB
        pop esi
        pop ecx
        ret
sub_6A9CE:
        push dword 20h
        call __CHK
        push ebx
        push ecx
        push edx
        push edi
        test eax, eax
        jne short loc_6A9EA
        mov dword [dword_EA078], eax
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
loc_6A9EA:
        mov dword [dword_EA078], 1
        mov dword [dword_EA0B4], eax
        xor ebx, ebx
        mov dword [dword_EA098], ebx
        push byte 20h
        mov edx, eax
        shl eax, 2
        add eax, edx
        shl eax, 4
        push eax
        push str_ZONEMGR
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword_EA088], eax
        mov dword [dword_EA084], eax
        mov edx, dword [dword_EA0B4]
        shl edx, 4
        add eax, edx
        mov dword [dword_EA080], eax
        add eax, edx
        mov dword [dword_EA060], eax
        mov eax, dword [dword_EA0B4]
        shl eax, 5
        mov edx, dword [dword_EA060]
        add edx, eax
        mov dword [dword_EA0A0], edx
        mov eax, dword [dword_EA0B4]
        shl eax, 2
        add edx, eax
        mov dword [dword_EA0A4], edx
        add edx, eax
        mov dword [dword_EA090], edx
        xor eax, eax
        jmp short loc_6AA8A
loc_6AA6E:
        mov ebx, eax
        mov edx, dword [dword_EA0A4]
        mov dword [edx+ebx*4], 0
        mov ecx, dword [edx+ebx*4]
        mov edx, dword [dword_EA0A0]
        mov dword [edx+ebx*4], ecx
        inc eax
loc_6AA8A:
        cmp eax, dword [dword_EA0B4]
        jl short loc_6AA6E
        xor edi, edi
        mov dword [dword_EA070], edi
        mov dword [dword_EA07C], edi
        xor eax, eax
        jmp short loc_6AAB0
loc_6AAA4:
        mov ebx, eax
        mov edx, dword [dword_EA090]
        inc eax
        mov dword [edx+ebx*4], eax
loc_6AAB0:
        mov edx, dword [dword_EA0B4]
        add edx, edx
        dec edx
        cmp eax, edx
        jl short loc_6AAA4
        mov edx, dword [dword_EA0B4]
        mov eax, dword [dword_EA090]
        mov dword [byte eax+edx*8-04h], 0FFFFFFFFh
        pop edi
        pop edx
        pop ecx
        pop ebx
        ret
sub_6AAD5:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [dword_EA088]
        push edx
        call FreeMemBlock
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
sub_6AAF5:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ecx, eax
        mov ebx, edx
        cmp dword [dword_EA078], byte 0
        je near loc_6AB78
        cmp eax, dword [dword_EA0B4]
        jg short loc_6AB78
        shl eax, 4
        mov edx, dword [dword_EA074]
        add eax, edx
        mov edx, dword [ebx]
        mov ebx, dword [byte ebx+04h]
        mov esi, ecx
        shl esi, 2
        mov ecx, dword [dword_EA09C]
        test byte [ecx+esi], 4
        jne short loc_6AB54
        mov dword [byte eax+04h], edx
        mov dword [eax], edx
        mov dword [byte eax+0Ch], ebx
        mov dword [byte eax+08h], ebx
        mov eax, dword [dword_EA09C]
        or byte [esi+eax], 4
        pop esi
        pop ecx
        pop ebx
        ret
loc_6AB54:
        cmp edx, dword [eax]
        jge short loc_6AB5C
        mov dword [eax], edx
        jmp short loc_6AB64
loc_6AB5C:
        cmp edx, dword [byte eax+04h]
        jle short loc_6AB64
        mov dword [byte eax+04h], edx
loc_6AB64:
        cmp ebx, dword [byte eax+08h]
        jge short loc_6AB70
        mov dword [byte eax+08h], ebx
        pop esi
        pop ecx
        pop ebx
        ret
loc_6AB70:
        cmp ebx, dword [byte eax+0Ch]
        jle short loc_6AB78
        mov dword [byte eax+0Ch], ebx
loc_6AB78:
        pop esi
        pop ecx
        pop ebx
        ret
sub_6AB7C:
        push dword 0Ch
        call __CHK
        push esi
        push edi
        mov esi, eax
        cmp dword [dword_EA078], byte 0
        je short loc_6ABF4
        cmp eax, dword [dword_EA0B4]
        jg short loc_6ABF4
        shl eax, 4
        mov edi, dword [dword_EA074]
        add eax, edi
        shl esi, 2
        mov edi, dword [dword_EA09C]
        test byte [edi+esi], 4
        jne short loc_6ABD2
        mov dword [eax], edx
        mov dword [byte eax+04h], ecx
        mov dword [byte eax+08h], ebx
        mov edx, dword [byte esp+0Ch]
        mov dword [byte eax+0Ch], edx
        mov eax, dword [dword_EA09C]
        or byte [esi+eax], 4
        pop edi
        pop esi
        ret 4
loc_6ABD2:
        cmp edx, dword [eax]
        jge short loc_6ABD8
        mov dword [eax], edx
loc_6ABD8:
        cmp ecx, dword [byte eax+04h]
        jle short loc_6ABE0
        mov dword [byte eax+04h], ecx
loc_6ABE0:
        cmp ebx, dword [byte eax+08h]
        jge short loc_6ABE8
        mov dword [byte eax+08h], ebx
loc_6ABE8:
        mov edx, dword [byte esp+0Ch]
        cmp edx, dword [byte eax+0Ch]
        jle short loc_6ABF4
        mov dword [byte eax+0Ch], edx
loc_6ABF4:
        pop edi
        pop esi
        ret 4
sub_6ABF9:
        push dword 14h
        call __CHK
        push esi
        push edi
        push ebp
        mov ebp, eax
        mov edi, ebx
        mov esi, ecx
        xor eax, eax
        mov al, byte [byte_D42C3]
        add eax, ecx
        push eax
        push edx
        call fputchar
        add esp, byte 4
        lea ecx, [edi+eax]
        mov ebx, esi
        mov edx, edi
        mov eax, ebp
        call sub_6AB7C
        pop ebp
        pop edi
        pop esi
        ret
sub_6AC31:
        push dword 1Ch
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        push eax
        mov eax, ebx
        cmp dword [dword_EA078], byte 0
        je short loc_6AC9A
        test edx, edx
        je short loc_6AC9A
        mov ecx, dword [esp]
        cmp ecx, dword [dword_EA0B4]
        jg short loc_6AC9A
        mov ecx, dword [ebx]
        mov edi, ecx
        mov esi, dword [byte ebx+04h]
        mov ebx, esi
loc_6AC63:
        dec edx
        je short loc_6AC8E
        add eax, byte 8
        mov ebp, dword [eax]
        cmp edi, ebp
        jle short loc_6AC73
        mov edi, ebp
        jmp short loc_6AC7A
loc_6AC73:
        cmp ecx, ebp
        jg short loc_6AC7A
        lea ecx, [byte ebp+01h]
loc_6AC7A:
        mov ebp, dword [byte eax+04h]
        cmp ebx, ebp
        jle short loc_6AC85
        mov ebx, ebp
        jmp short loc_6AC63
loc_6AC85:
        cmp esi, ebp
        jg short loc_6AC63
        lea esi, [byte ebp+01h]
        jmp short loc_6AC63
loc_6AC8E:
        push esi
        mov edx, edi
        mov eax, dword [byte esp+04h]
        call sub_6AB7C
loc_6AC9A:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
sub_6ACA2:
        push dword 18h
        call __CHK
        push esi
        push edi
        sub esp, byte 8
        test ecx, ecx
        jne short loc_6ACC5
        mov dword [esp], edx
        mov dword [byte esp+04h], ebx
        mov edx, esp
        call sub_6AAF5
        jmp short loc_6ACE3
loc_6ACC5:
        mov esi, ecx
        sar esi, 2
        mov edi, ecx
        sub edi, esi
        mov esi, edi
        add edi, ebx
        dec edi
        push edi
        lea edi, [edx+ecx]
        sub ebx, esi
        inc ebx
        sub edx, ecx
        mov ecx, edi
        call sub_6AB7C
loc_6ACE3:
        add esp, byte 8
        pop edi
        pop esi
        ret
sub_6ACE9:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ebx, dword [byte edx+0Ch]
        sar ebx, 10h
        mov eax, dword [byte edx+04h]
        sar eax, 10h
        add eax, ebx
        push eax
        mov eax, dword [byte edx+0Ah]
        sar eax, 10h
        mov ecx, dword [byte edx+02h]
        sar ecx, 10h
        add ecx, eax
        mov edx, eax
        mov eax, esi
        call sub_6AB7C
        pop esi
        pop ecx
        pop ebx
        ret
sub_6AD22:
        push dword 0Ch
        call __CHK
        push esi
        mov esi, eax
        mov eax, ebx
        mov ebx, ecx
        mov ecx, dword [byte edx+04h]
        sar ecx, 10h
        add ecx, ebx
        push ecx
        mov ecx, dword [byte edx+02h]
        sar ecx, 10h
        add ecx, eax
        mov edx, eax
        mov eax, esi
        call sub_6AB7C
        pop esi
        ret
sub_6AD4F:
        push dword 0Ch
        call __CHK
        push ebx
        push edx
        cmp dword [dword_EA07C], byte 0
        je short loc_6AD6D
        test byte [byte_EA058], 41h
        je short loc_6AD7A
loc_6AD6D:
        mov eax, dword_EA034
        call sub_6A373
        pop edx
        pop ebx
        ret
loc_6AD7A:
        mov edx, dword [dword_EA06C]
loc_6AD80:
        cmp edx, byte 0FFFFFFFFh
        je near loc_6A5E7
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [dword_EA060]
        add eax, ebx
        call sub_6A373
        mov eax, edx
        mov edx, dword [dword_EA090]
        mov edx, dword [edx+eax*4]
        jmp short loc_6AD80
sub_6ADA7:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        call sub_B4BA8
        mov edx, dword [dword_EA09C]
        mov eax, dword [dword_EA074]
        call sub_6A2BC
        cmp dword [dword_EA0B4], byte 0
        je short loc_6ADDB
        test byte [byte_EA058], 42h
        je short loc_6ADE9
loc_6ADDB:
        call sub_6A234
        and byte [byte_EA058], 0FDh
        jmp short loc_6AE44
loc_6ADE9:
        cmp dword [dword_EA05C], byte 0
        jne short loc_6AE0C
        call sub_6A439
        mov edx, dword [dword_EA08C]
        mov eax, dword [dword_EA094]
        mov ebx, 1
        call sub_6A990
loc_6AE0C:
        mov edx, dword [dword_EA09C]
        mov eax, dword [dword_EA074]
        xor ebx, ebx
        call sub_6A990
        mov edx, dword [dword_EA06C]
loc_6AE24:
        cmp edx, byte 0FFFFFFFFh
        je short loc_6AE44
        mov ebx, edx
        shl ebx, 4
        mov eax, dword [dword_EA060]
        add eax, ebx
        call sub_6A1D6
        mov eax, dword [dword_EA090]
        mov edx, dword [eax+edx*4]
        jmp short loc_6AE24
loc_6AE44:
        cmp dword [dword_EA098], byte 0
        sete al
        and eax, 0FFh
        mov dword [dword_EA098], eax
        pop edx
        pop ecx
        pop ebx
        ret
sub_6AE5C:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, 3E7h
        mov eax, dword [dword_EA06C]
        mov ecx, dword [dword_EA060]
loc_6AE79:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6AE9B
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [ecx+ebx]
        cmp ebx, edx
        jge short loc_6AE8C
        mov edx, ebx
loc_6AE8C:
        test edx, edx
        je short loc_6AE9B
        mov ebx, dword [dword_EA090]
        mov eax, dword [ebx+eax*4]
        jmp short loc_6AE79
loc_6AE9B:
        mov dword [dword_EA044], edx
        xor edx, edx
        mov eax, dword [dword_EA06C]
        mov ecx, dword [dword_EA060]
loc_6AEAE:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6AED5
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [byte ecx+ebx+04h]
        cmp ebx, edx
        jle short loc_6AEC2
        mov edx, ebx
loc_6AEC2:
        cmp edx, dword [dword_EA038]
        jge short loc_6AED5
        mov ebx, dword [dword_EA090]
        mov eax, dword [ebx+eax*4]
        jmp short loc_6AEAE
loc_6AED5:
        mov dword [dword_EA048], edx
        mov edx, 3E7h
        mov eax, dword [dword_EA06C]
        mov ecx, dword [dword_EA060]
loc_6AEEB:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6AF0E
        mov ebx, eax
        shl ebx, 4
        mov ebx, dword [byte ecx+ebx+08h]
        cmp ebx, edx
        jge short loc_6AEFF
        mov edx, ebx
loc_6AEFF:
        test edx, edx
        je short loc_6AF0E
        mov ebx, dword [dword_EA090]
        mov eax, dword [ebx+eax*4]
        jmp short loc_6AEEB
loc_6AF0E:
        mov dword [dword_EA04C], edx
        xor edx, edx
        mov eax, dword [dword_EA06C]
loc_6AF1B:
        cmp eax, byte 0FFFFFFFFh
        je short loc_6AF48
        mov ebx, eax
        shl ebx, 4
        mov ecx, dword [dword_EA060]
        mov ebx, dword [byte ecx+ebx+0Ch]
        cmp ebx, edx
        jle short loc_6AF35
        mov edx, ebx
loc_6AF35:
        cmp edx, dword [dword_EA040]
        jge short loc_6AF48
        mov ebx, dword [dword_EA090]
        mov eax, dword [ebx+eax*4]
        jmp short loc_6AF1B
loc_6AF48:
        mov dword [dword_EA050], edx
        pop edx
        pop ecx
        pop ebx
        ret
sub_6AF52:
        push dword 14h
        call __CHK
        mov dword [dword_EA0CC], eax
        mov dword [dword_EA034], eax
        mov dword [dword_EA0C8], ebx
        mov dword [dword_EA038], ebx
        mov dword [dword_EA0D0], edx
        mov dword [dword_EA03C], edx
        mov dword [dword_EA0C4], ecx
        mov dword [dword_EA040], ecx
        push ecx
        push edx
        push ebx
        push eax
        call SetClipWindow
        add esp, byte 10h
        ret
sub_6AF97:
        push dword 4
        call __CHK
        mov dword [dword_EA0B8], eax
        mov dword [dword_EA0BC], edx
        ret
sub_6AFAD:
        push dword 4
        call __CHK
        mov eax, dword_EA034
        jmp short sub_6AFDF
sub_6AFBE:
        push dword 4
        call __CHK
        test byte [byte_EA058], 20h
        je short loc_6AFDA
        cmp dword [dword_EA05C], byte 0
        jne short loc_6B001
loc_6AFDA:
        mov eax, dword_EA034
sub_6AFDF:
        push dword 24h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        mov edx, dword [byte eax+0Ch]
        push edx
        mov ebx, dword [byte eax+08h]
        push ebx
        mov ecx, dword [byte eax+04h]
        push ecx
        mov esi, dword [eax]
        push esi
        jmp near loc_6A149
loc_6B001:
        mov eax, dword_EA044
        jmp short sub_6AFDF
sub_6B008:
        push dword 2Ch
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        mov edx, dword [dword_EA0AC]
        push edx
        call SetDrawBitmap
        add esp, byte 4
        call sub_6A3C0
        test byte [byte_EA058], 1
        je short loc_6B03F
        xor ecx, ecx
        mov dword [dword_EA05C], ecx
        jmp short loc_6B05F
loc_6B03F:
        mov ebx, 1
        mov dword [dword_EA05C], ebx
        call sub_6A439
        mov edx, dword [dword_EA08C]
        mov eax, dword [dword_EA094]
        call sub_6A990
loc_6B05F:
        call sub_6AD4F
        and byte [byte_EA058], 0FEh
        mov esi, dword [dword_EA040]
        push esi
        mov edi, dword [dword_EA03C]
        push edi
        mov ebp, dword [dword_EA038]
        push ebp
        mov eax, dword [dword_EA034]
        push eax
        call SetClipWindow
        add esp, byte 10h
        jmp near loc_6A3B9
