; Watcom floating-point emulator.
bits 32
%include "hockey.inc"
section s_A3274 progbits alloc exec nowrite align=1
extern __GETDS, _dos_setvect_, str_RATIONALDOS4G, Hook387Flag, Hook387Saved, dword_D4D11, unk_D657C, Hook387Save
global unk_A3274, unk_A3278, unk_A327C, unk_A327E, unk_A3280, unk_A3282, unk_A32CE, unk_A32D0
global unk_A32D4, unk_A32D6, unk_A331E, unk_A3322, unk_A332C, unk_A338C, jpt_A33EC, jpt_A34EC
global sub_A35EC, sub_A3610, sub_A365C, EmuTrapExit, loc_A369A, loc_A3706, loc_A370C, loc_A3732
global loc_A3735, loc_A373E, loc_A3747, loc_A3750, loc_A3759, loc_A3761, loc_A3769, loc_A379C
global loc_A37B3, sub_A37B4, loc_A37CE, loc_A37E2, sub_A37F0, loc_A3804, loc_A381B, sub_A3822
global loc_A3839, loc_A3874, sub_A3890, loc_A38DD, sub_A38DE, sub_A38E4, sub_A38EA, sub_A38F0
global sub_A38F6, sub_A38FE, sub_A3904, sub_A390A, sub_A3910, sub_A3918, sub_A3920, sub_A3928
global sub_A3930, sub_A393A, sub_A3944, sub_A394C, sub_A3954, sub_A395D, sub_A3966, sub_A396F
global sub_A3978, sub_A3983, sub_A398E, sub_A3997, sub_A39A0, loc_A39D6, sub_A39D8, sub_A39DD
global sub_A39FC, sub_A3A1B, sub_A3A37, sub_A3A53, sub_A3A72, sub_A3A91, sub_A3AB0, sub_A3ACF
global sub_A3B09, sub_A3B1A, sub_A3B2B, sub_A3B49, loc_A3B68, loc_A3B7A, loc_A3B84, sub_A3B89
global sub_A3B9D, sub_A3BAB, sub_A3BCA, sub_A3BE9, sub_A3C05, sub_A3C21, sub_A3C40, sub_A3C5F
global sub_A3C7E, sub_A3C9D, sub_A3CD7, sub_A3D13, sub_A3D37, sub_A3D5A, sub_A3D7D, sub_A3D9D
global sub_A3DBD, sub_A3DE0, sub_A3E03, sub_A3E26, sub_A3E49, sub_A3E90, sub_A3ECE, sub_A3EE3
global sub_A3F01, sub_A3F16, loc_A3F44, sub_A3F5D, loc_A3F6F, sub_A3F88, sub_A3F96, sub_A3FB7
global sub_A3FD8, sub_A3FF6, sub_A4014, sub_A4035, sub_A4056, sub_A4077, sub_A4098, sub_A40D4
global loc_A4107, sub_A411C, loc_A4143, sub_A414C, sub_A4151, sub_A418B, sub_A4190, sub_A41B4
global sub_A41B9, jpt_A41C1, loc_A41E1, sub_A41E6, sub_A41FB, sub_A4210, sub_A4222, sub_A4234
global sub_A4249, sub_A425E, sub_A4273, sub_A4288, sub_A42D0, sub_A42F8, jpt_A4300, loc_A4320
global loc_A432D, loc_A433A, loc_A436B, sub_A4379, jpt_A4381, loc_A43A1, loc_A43E4, loc_A4429
global loc_A446E, loc_A44B3, loc_A44F8, loc_A453D, sub_A4594, jpt_A459C, loc_A45BC, loc_A45C9
global loc_A4610, loc_A465C, loc_A467D, sub_A469E, jpt_A46A6, loc_A46C6, loc_A46F0, loc_A4737
global loc_A4744, loc_A479C, loc_A47A9, sub_A47B6, jpt_A47BE, loc_A47DE, sub_A483F, jpt_A4847
global loc_A4867, loc_A4873, sub_A4899, sub_A48AE, sub_A48C3, sub_A48D8, sub_A48ED, sub_A4902
global sub_A4917, sub_A4936, sub_A4962, sub_A4974, sub_A4986, sub_A49B2, sub_A49FD, sub_A4A48
global jpt_A4A50, loc_A4A70, sub_A4AD1, sub_A4B1C, sub_A4B67, sub_A4BB2, sub_A4BFD, jpt_A4C05
global loc_A4C25, loc_A4C6E, loc_A4CD3, loc_A4CFD, loc_A4D15, loc_A4D45, loc_A4D52, loc_A4D54
global loc_A4D76, loc_A4D7A, loc_A4D86, EmuSub, EmuAdd, loc_A4DAB, AddExtRaw, AddMantissas
global loc_A4E1D, loc_A4E1E, loc_A4E21, loc_A4E32, loc_A4E6D, loc_A4E81, loc_A4E96, loc_A4EB7
global loc_A4EBB, loc_A4EC9, loc_A4EEB, loc_A4EFA, loc_A4F10, loc_A4F1A, loc_A4F36, loc_A4F4F
global loc_A4F51, loc_A4F53, loc_A4F5D, EmuCompare, loc_A4F82, loc_A4F98, loc_A4FBD, loc_A4FC8
global loc_A4FD0, loc_A4FD5, loc_A4FDD, EmuDiv, DivideMantissas, loc_A5062, loc_A5077, loc_A5078
global loc_A5086, loc_A5089, loc_A50BA, loc_A50C4, loc_A50C9, loc_A50D3, loc_A50F6, loc_A5107
global loc_A5119, loc_A513A, loc_A5142, loc_A5154, loc_A5169, loc_A5189, loc_A51A0, loc_A51B2
global loc_A51BD, loc_A51C3, loc_A51CE, EmuMul, MultiplyMantissas, loc_A5210, loc_A5213, loc_A522A
global loc_A525A, loc_A526B, loc_A52A2, loc_A52B5, loc_A52CE, loc_A52D9, loc_A52DC, loc_A52E7
global loc_A52F1, sub_A52FE, loc_A5317, loc_A5324, loc_A5331, loc_A534E, loc_A5350, StoreM32Int
global Emu387LdToInt, loc_A535B, loc_A5394, loc_A53A1, loc_A53B2, loc_A53B5, loc_A53BD, LoadM32Int
global loc_A53D2, Emu387IntToLd, loc_A53DB, loc_A53F6, loc_A53FA, LoadM64Real, loc_A542A, loc_A5438
global loc_A544B, loc_A5453, loc_A545F, loc_A546C, loc_A5478, StoreM32Real, loc_A54A9, loc_A54B7
global loc_A54DA, loc_A54E5, loc_A54F8, loc_A5503, StoreM64Real, loc_A5523, loc_A5534, loc_A5559
global loc_A5563, loc_A556A, loc_A558C, loc_A559E, loc_A55A2, loc_A55A4, loc_A55CA, sub_A55CE
global loc_A55EF, loc_A55FD, loc_A5607, unk_A5613, ExtToInt, loc_A56A8, loc_A56B3, loc_A56BE
global loc_A56CC, loc_A5703, loc_A5705, loc_A570D, loc_A5720, loc_A5722, loc_A576A, loc_A5772
global loc_A5776, loc_A5782, loc_A5785, loc_A57AA, loc_A57BA, unk_A57C6, EmuRemainder, loc_A5849
global loc_A585C, loc_A585E, loc_A5886, loc_A58B6, loc_A58B8, loc_A58D2, RemainderStep, loc_A5918
global loc_A594E, loc_A5969, loc_A59DC, loc_A5A0A, loc_A5A2A, loc_A5A33, EmuRoundInt, loc_A5A4E
global loc_A5A6E, RoundMantissa, loc_A5AB3, loc_A5ABF, loc_A5AC1, loc_A5AC6, loc_A5ADB, loc_A5AE7
global loc_A5AF2, loc_A5AFC, loc_A5AFE, loc_A5B02, loc_A5B12, loc_A5B19, sub_A5B1A, loc_A5B38
global loc_A5B6A, loc_A5B6C, loc_A5B8C, loc_A5B92, loc_A5B94, loc_A5BAB, unk_A5BC2, unk_A5BE0
global AddOne, EmuLog2, Log2Core, loc_A5C76, loc_A5CB5, loc_A5CD1, loc_A5CDD, loc_A5E26
global unk_A5E36, unk_A5E90, unk_A5EEA, SinCosCore, loc_A5F1E, loc_A5F6D, loc_A5F99, loc_A5FC3
global loc_A5FCC, loc_A5FD9, loc_A5FF3, loc_A6031, loc_A603C, loc_A605A, loc_A606F, loc_A6078
global loc_A6085, loc_A60A8, loc_A60B4, loc_A60BC, loc_A60DD, loc_A60E2, EmuSin, EmuCos
global sub_A610A, sub_A6118, EmuAtan, loc_A6162, loc_A6183, loc_A6192, loc_A61A3, loc_A61A9
global loc_A61AF, loc_A61BB, loc_A61BF, loc_A61CA, loc_A61CC, loc_A62BB, loc_A62EE, loc_A62F3
global EmuExp2, loc_A6333, loc_A6346, loc_A634F, loc_A635A, loc_A6377, loc_A638D, loc_A63A3
global loc_A63B5, loc_A63C0, loc_A63C9, loc_A63D2, loc_A63DA, sub_A63E0, PolyEval, loc_A6417
global PolyEvalOdd, __hook387, loc_A6500, loc_A650C, loc_A6558, loc_A655A, __unhook387, loc_A6593
global loc_A65B7, nullsub_3, __init_80x87, loc_A65D8
unk_A3274:
        db 00h,00h,00h,00h
unk_A3278:
        db 00h,00h,00h,00h
unk_A327C:
        db 00h,00h
unk_A327E:
        db 0Ah,00h
unk_A3280:
        db 046h,00h
unk_A3282:
        db 00h,00h,00h,00h,00h,00h,014h,00h,00h,00h,00h,08h,01h,00h,00h,00h
        db 01Eh,00h,0Ah,00h,00h,010h,02h,00h,00h,00h,028h,00h,014h,00h,00h,018h
        db 03h,00h,00h,00h,032h,00h,01Eh,00h,00h,020h,04h,00h,00h,00h,03Ch,00h
        db 028h,00h,00h,028h,05h,00h,00h,00h,046h,00h,032h,00h,00h,030h,06h,00h
        db 00h,00h,00h,00h,03Ch,00h,00h,038h,07h,00h,00h,00h
unk_A32CE:
        db 0FCh,0FFh
unk_A32D0:
        db 01h,00h,00h,00h
unk_A32D4:
        db 02h,00h
unk_A32D6:
        db 03h,00h,0F3h,0FFh,04h,00h,00h,00h,08h,00h,0Ch,00h,0CFh,0FFh,010h,00h
        db 00h,00h,020h,00h,030h,00h,03Fh,0FFh,040h,00h,00h,00h,080h,00h,0C0h,00h
        db 0FFh,0FCh,00h,01h,00h,00h,00h,02h,00h,03h,0FFh,0F3h,00h,04h,00h,00h
        db 00h,08h,00h,0Ch,0FFh,0CFh,00h,010h,00h,00h,00h,020h,00h,030h,0FFh,03Fh
        db 00h,040h,00h,00h,00h,080h,00h,0C0h
unk_A331E:
        db 01h,040h,00h,045h
unk_A3322:
        db 00h,02h,040h,042h,01h,03h,041h,043h,087h,0DBh
unk_A332C:
        dd sub_A38DE
        dd sub_A38E4
        dd sub_A38EA
        dd sub_A38F0
        dd sub_A39A0
        dd sub_A38FE
        dd sub_A3904
        dd sub_A390A
        dd sub_A3910
        dd sub_A3918
        dd sub_A3920
        dd sub_A3928
        dd sub_A39A0
        dd sub_A393A
        dd sub_A3944
        dd sub_A394C
        dd sub_A3954
        dd sub_A395D
        dd sub_A3966
        dd sub_A396F
        dd sub_A39A0
        dd sub_A3983
        dd sub_A398E
        dd sub_A3997
unk_A338C:
        dd sub_A38DE
        dd sub_A38E4
        dd sub_A38EA
        dd sub_A38F0
        dd sub_A38F6
        dd sub_A38FE
        dd sub_A3904
        dd sub_A390A
        dd sub_A3910
        dd sub_A3918
        dd sub_A3920
        dd sub_A3928
        dd sub_A3930
        dd sub_A393A
        dd sub_A3944
        dd sub_A394C
        dd sub_A3954
        dd sub_A395D
        dd sub_A3966
        dd sub_A396F
        dd sub_A3978
        dd sub_A3983
        dd sub_A398E
        dd sub_A3997
jpt_A33EC:
        dd sub_A39DD
        dd sub_A3ACF
        dd sub_A3BAB
        dd sub_A3C9D
        dd sub_A3D37
        dd sub_A3E90
        dd sub_A3F96
        dd sub_A4098
        dd sub_A39FC
        dd sub_A39D8
        dd sub_A3BCA
        dd sub_A39D8
        dd sub_A3D5A
        dd sub_A39D8
        dd sub_A3FB7
        dd sub_A39D8
        dd sub_A3A1B
        dd sub_A3B09
        dd sub_A3BE9
        dd sub_A3CD7
        dd sub_A3D7D
        dd sub_A3ECE
        dd sub_A3FD8
        dd sub_A40D4
        dd sub_A3A37
        dd sub_A3B1A
        dd sub_A3C05
        dd sub_A3D13
        dd sub_A3D9D
        dd sub_A3F01
        dd sub_A3FF6
        dd sub_A411C
        dd sub_A3A53
        dd sub_A3B2B
        dd sub_A3C21
        dd sub_A39D8
        dd sub_A3DBD
        dd sub_A3F16
        dd sub_A4014
        dd sub_A414C
        dd sub_A3A72
        dd sub_A3B49
        dd sub_A3C40
        dd sub_A3E49
        dd sub_A3DE0
        dd sub_A39D8
        dd sub_A4035
        dd sub_A4151
        dd sub_A3A91
        dd sub_A3B89
        dd sub_A3C5F
        dd sub_A39D8
        dd sub_A3E03
        dd sub_A3F5D
        dd sub_A4056
        dd sub_A418B
        dd sub_A3AB0
        dd sub_A3B9D
        dd sub_A3C7E
        dd sub_A3EE3
        dd sub_A3E26
        dd sub_A3F88
        dd sub_A4077
        dd sub_A4190
jpt_A34EC:
        dd sub_A41E6
        dd sub_A4288
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A4899
        dd sub_A4917
        dd sub_A49B2
        dd sub_A4917
        dd sub_A41FB
        dd sub_A42D0
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A48AE
        dd sub_A42D0
        dd sub_A49FD
        dd sub_A42D0
        dd sub_A4210
        dd sub_A41B9
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A4210
        dd sub_A4936
        dd sub_A41B4
        dd sub_A4936
        dd sub_A4222
        dd sub_A4986
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A4222
        dd sub_A4986
        dd sub_A4A48
        dd sub_A4986
        dd sub_A4234
        dd sub_A42F8
        dd sub_A41B4
        dd sub_A483F
        dd sub_A48C3
        dd sub_A4962
        dd sub_A4AD1
        dd sub_A4BFD
        dd sub_A4249
        dd sub_A4379
        dd sub_A47B6
        dd sub_A41B4
        dd sub_A48D8
        dd sub_A4974
        dd sub_A4B1C
        dd sub_A41B4
        dd sub_A425E
        dd sub_A4594
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A48ED
        dd sub_A41B4
        dd sub_A4B67
        dd sub_A41B4
        dd sub_A4273
        dd sub_A469E
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A4902
        dd sub_A41B4
        dd sub_A4BB2
        dd sub_A41B4
sub_A35EC:
        sti
        pusha
        LD mov, ebp, esp
        push dword [byte ebp+040h]
        push dword [byte ebp+044h]
        mov cx, word [byte ebp+03Ch]
        mov word [byte ebp-06h], cx
        mov ecx, dword [byte ebp+038h]
        mov dword [byte ebp+0Ch], ecx
        call EmuTrapExit
        pop ds
        pop es
        popa
        iret
        db 087h,0DBh,090h
sub_A3610:
        sti
        mov eax, dword [byte esp+0Ch]
        push dword [byte ss:eax+014h]
        push dword [byte ss:eax+010h]
        push eax
        push eax
        push eax
        push dword [ss:eax]
        push ecx
        push edx
        push ebx
        push dword [byte ss:eax+01Ch]
        LD mov, eax, ebp
        push eax
        push esi
        push edi
        push es
        push ds
        mov word [byte esp+02h], ss
        call EmuTrapExit
        pop ds
        pop es
        pop edi
        pop esi
        pop eax
        LD mov, ebp, eax
        pop eax
        pop ebx
        pop edx
        pop ecx
        pop eax
        xchg eax, dword [esp]
        pop dword [ss:eax]
        add esp, byte 8
        pop dword [byte ss:eax+010h]
        add esp, byte 4
        mov eax, dword [ss:eax]
        iret
        db 087h,0DBh
sub_A365C:
        sti
        sub esp, byte 0Ch
        push eax
        LD mov, eax, esp
        add eax, byte 1Ch
        push ecx
        push edx
        push ebx
        push eax
        push ebp
        push esi
        push edi
        push es
        push ds
        mov word [byte esp+02h], ss
        call EmuTrapExit
        pop ds
        pop es
        popa
        add esp, byte 0Ch
        iret
        db 090h
EmuTrapExit:
        LD mov, ebp, esp
        mov esi, dword [byte ebp+038h]
        mov ds, word [byte ebp+03Ch]
        mov cx, word [byte ebp+04h]
        mov dx, word [byte ebp+06h]
        mov al, byte [esi]
        cmp al, 9Bh
        jbe near loc_A370C
loc_A369A:
        LD mov, bl, al
        and bl, 0F8h
        cmp bl, 0D8h
        jne near loc_A37B3
        mov ah, byte [byte esi+01h]
        add esi, byte 2
        and al, 7
        cmp ah, 0C0h
        jae near loc_A3769
        LD mov, bl, ah
        LD mov, bh, ah
        shr bh, 3
        and ebx, 1807h
        LD or, bl, bh
        mov bh, 0
        call dword [nosplit cs:ebx*4+unk_A332C]
        mov es, cx
        mov dword [byte ebp+038h], esi
        LD mov, esi, ebx
        LD mov, bl, ah
        and ebx, byte 38h
        LD or, bl, al
        call __GETDS
        lea ebp, [unk_D657C]
        mov edi, dword [byte ds:ebp+04h]
        and edi, 3800h
        shr edi, 0Bh
        lea edi, [edi+edi*4]
        LD add, edi, edi
        jmp dword [nosplit cs:ebx*4+jpt_A33EC]
loc_A3706:
        mov al, byte [esi]
        cmp al, 9Bh
        ja short loc_A369A
loc_A370C:
        je short loc_A3732
        cmp al, 26h
        je short loc_A3750
        cmp al, 2Eh
        je short loc_A3735
        cmp al, 36h
        je short loc_A3747
        cmp al, 3Eh
        je short loc_A373E
        cmp al, 64h
        je short loc_A3759
        cmp al, 65h
        je short loc_A3761
        cmp al, 66h
        je short loc_A3732
        cmp al, 67h
        jne near loc_A369A
loc_A3732:
        inc esi
        jmp short loc_A3706
loc_A3735:
        mov cx, word [byte ebp+03Ch]
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A373E:
        mov cx, word [byte ebp+04h]
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A3747:
        mov cx, word [byte ebp+06h]
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A3750:
        mov cx, word [byte ebp+08h]
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A3759:
        mov cx, fs
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A3761:
        mov cx, gs
        LD mov, edx, ecx
        inc esi
        jmp short loc_A3706
loc_A3769:
        mov dword [byte ebp+038h], esi
        call __GETDS
        lea ebp, [unk_D657C]
        LD mov, dl, ah
        and edx, byte 38h
        LD or, dl, al
        mov edi, dword [byte ds:ebp+04h]
        and edi, 3800h
        shr edi, 0Bh
        LD mov, bl, ah
        and ebx, byte 7
        LD mov, esi, ebx
        cmp ax, 0F801h
        jne short loc_A379C
        mov si, 1
loc_A379C:
        LD add, esi, edi
        and esi, byte 7
        lea edi, [edi+edi*4]
        LD add, edi, edi
        lea esi, [esi+esi*4]
        LD add, esi, esi
        jmp dword [nosplit cs:edx*4+jpt_A34EC]
loc_A37B3:
        ret
sub_A37B4:
        lea ebx, [byte edi+ebp+01Ch]
        mov edx, 0FFFFFF00h
        mov eax, dword [byte ebx+04h]
        shl eax, 19h
        jae short loc_A37E2
        jne short loc_A37CE
        cmp dword [ebx], byte 0
        jne short loc_A37CE
        LD add, edx, edx
loc_A37CE:
        add dword [byte ebx+04h], 100h
        jae short loc_A37E2
        mov dword [byte ebx+04h], 80000000h
        inc word [byte ebx+08h]
loc_A37E2:
        and dword [byte ebx+04h], edx
        mov dword [ebx], 0
        jmp near EmuTrapExit
sub_A37F0:
        lea ebx, [byte edi+ebp+01Ch]
        mov edx, 0FFFFF800h
        mov eax, dword [ebx]
        shl eax, 16h
        jae short loc_A381B
        jne short loc_A3804
        LD add, edx, edx
loc_A3804:
        add dword [ebx], 800h
        adc dword [byte ebx+04h], byte 0
        jae short loc_A381B
        mov dword [byte ebx+04h], 80000000h
        inc word [byte ebx+08h]
loc_A381B:
        and dword [ebx], edx
        jmp near EmuTrapExit
sub_A3822:
        inc eax
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A331E]
        mov word [byte ds:ebp+04h], dx
loc_A3839:
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
loc_A3874:
        inc eax
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A331E]
        mov word [byte ds:ebp+04h], dx
        jmp near EmuTrapExit
sub_A3890:
        or byte [byte ds:ebp+04h], al
        test byte [byte ds:ebp+00h], al
        jne short loc_A38DD
        push esi
        push edi
        push ecx
        push es
        push ds
        sub esp, byte 6Ch
        mov cx, ss
        mov es, cx
        LD mov, esi, ebp
        LD mov, edi, esp
        mov ecx, 1Bh
        cld
        rep movsd
        movzx eax, ah
        call dword [dword_D4D11]
        mov cx, ds
        mov es, cx
        mov cx, ss
        mov ds, cx
        LD mov, edi, ebp
        LD mov, esi, esp
        mov ecx, 1Bh
        cld
        rep movsd
        add esp, byte 6Ch
        pop ds
        pop es
        pop ecx
        pop edi
        pop esi
loc_A38DD:
        ret
sub_A38DE:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+028h]
        ret
sub_A38E4:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+024h]
        ret
sub_A38EA:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+020h]
        ret
sub_A38F0:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+01Ch]
        ret
sub_A38F6:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
sub_A38FE:
        mov ebx, dword [esi]
        add esi, byte 4
        ret
sub_A3904:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+010h]
        ret
sub_A390A:
        LD xor, ebx, ebx
        add ebx, dword [byte ebp+0Ch]
        ret
sub_A3910:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+028h]
        ret
sub_A3918:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+024h]
        ret
sub_A3920:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+020h]
        ret
sub_A3928:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+01Ch]
        ret
sub_A3930:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
sub_A393A:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+014h]
        LD mov, ecx, edx
        ret
sub_A3944:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+010h]
        ret
sub_A394C:
        movsx ebx, byte [esi]
        inc esi
        add ebx, dword [byte ebp+0Ch]
        ret
sub_A3954:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+028h]
        ret
sub_A395D:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+024h]
        ret
sub_A3966:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+020h]
        ret
sub_A396F:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+01Ch]
        ret
sub_A3978:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+018h]
        LD mov, ecx, edx
        ret
sub_A3983:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+014h]
        LD mov, ecx, edx
        ret
sub_A398E:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+010h]
        ret
sub_A3997:
        mov ebx, dword [esi]
        add esi, byte 4
        add ebx, dword [byte ebp+0Ch]
        ret
sub_A39A0:
        mov bl, byte [esi]
        inc esi
        push ebx
        and bl, 7
        LD mov, bh, ah
        shr bh, 3
        and bh, 18h
        LD or, bl, bh
        mov bh, 0
        call dword [nosplit cs:ebx*4+unk_A338C]
        pop edx
        push ecx
        LD mov, ecx, edx
        and dl, 38h
        cmp dl, 20h
        je short loc_A39D6
        shr edx, 1
        neg edx
        mov edx, dword [byte ebp+edx+028h]
        shr cl, 6
        shl edx, cl
        LD add, ebx, edx
loc_A39D6:
        pop ecx
        ret
sub_A39D8:
        jmp near EmuTrapExit
sub_A39DD:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A39FC:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A3A1B:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A3A37:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A3A53:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3A72:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3A91:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3AB0:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call sub_A55CE
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3ACF:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call sub_A55CE
        jmp near EmuTrapExit
sub_A3B09:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Real
        mov dword [es:esi], eax
        jmp near EmuTrapExit
sub_A3B1A:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Real
        mov dword [es:esi], eax
        jmp near loc_A3839
sub_A3B2B:
        mov ecx, 7
        push ds
        push es
        mov ax, es
        mov dx, ds
        mov es, dx
        mov ds, ax
        LD mov, edi, ebp
        rep movsd
        pop es
        pop ds
        jmp near EmuTrapExit
sub_A3B49:
        mov ax, word [es:esi]
        mov word [byte ds:ebp+00h], ax
        and ax, 300h
        cmp ax, 300h
        jne short loc_A3B68
        lea edx, [EmuTrapExit]
        mov dword [byte ds:ebp+076h], edx
        jmp short loc_A3B84
loc_A3B68:
        cmp ax, 200h
        jne short loc_A3B7A
        lea edx, [sub_A37F0]
        mov dword [byte ds:ebp+076h], edx
        jmp short loc_A3B84
loc_A3B7A:
        lea edx, [sub_A37B4]
        mov dword [byte ds:ebp+076h], edx
loc_A3B84:
        jmp near EmuTrapExit
sub_A3B89:
        mov ecx, 7
        LD mov, ebx, edi
        LD mov, edi, esi
        LD mov, esi, ebp
        rep movsd
        LD mov, edi, ebx
        jmp near EmuTrapExit
sub_A3B9D:
        mov ax, word [byte ds:ebp+00h]
        mov word [es:esi], ax
        jmp near EmuTrapExit
sub_A3BAB:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A3BCA:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A3BE9:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A3C05:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A3C21:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3C40:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3C5F:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3C7E:
        mov eax, dword [es:esi]
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3C9D:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call LoadM32Int
        jmp near EmuTrapExit
sub_A3CD7:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        mov dword [es:esi], eax
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        jmp near EmuTrapExit
sub_A3D13:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        mov dword [es:esi], eax
        jmp near loc_A3839
sub_A3D37:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A3D5A:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A3D7D:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A3D9D:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A3DBD:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3DE0:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A3E03:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3E26:
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte ebp+06Ch]
        call LoadM64Real
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A3E49:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        mov dword [byte edi+ebp+01Ch], eax
        mov eax, dword [byte es:esi+04h]
        mov dword [byte edi+ebp+020h], eax
        mov ax, word [byte es:esi+08h]
        mov word [byte edi+ebp+024h], ax
        jmp near EmuTrapExit
sub_A3E90:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        mov edx, dword [byte es:esi+04h]
        lea ebx, [byte edi+ebp+01Ch]
        call LoadM64Real
        jmp near EmuTrapExit
sub_A3ECE:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM64Real
        mov dword [es:esi], eax
        mov dword [byte es:esi+04h], edx
        jmp near EmuTrapExit
sub_A3EE3:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [es:esi], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte es:esi+04h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte es:esi+08h], ax
        jmp near loc_A3839
sub_A3F01:
        lea eax, [byte edi+ebp+01Ch]
        call StoreM64Real
        mov dword [es:esi], eax
        mov dword [byte es:esi+04h], edx
        jmp near loc_A3839
sub_A3F16:
        mov ecx, 7
        push ds
        push es
        mov ax, es
        mov dx, ds
        mov es, dx
        mov ds, ax
        LD mov, edi, ebp
        rep movsd
        mov ebx, dword [byte es:ebp+04h]
        and ebx, 3800h
        shr ebx, 0Bh
        lea ebx, [ebx+ebx*4]
        LD add, ebx, ebx
        mov ecx, 8
loc_A3F44:
        lea edi, [byte ebp+ebx+01Ch]
        movsd
        movsd
        movsw
        movzx ebx, word [dword cs:ebx+unk_A327E]
        loop loc_A3F44
        pop es
        pop ds
        jmp near EmuTrapExit
sub_A3F5D:
        mov ecx, 7
        LD mov, ebx, edi
        LD mov, edi, esi
        LD mov, esi, ebp
        rep movsd
        mov ecx, 8
loc_A3F6F:
        lea esi, [byte ebx+ebp+01Ch]
        movsd
        movsd
        movsw
        movzx ebx, word [dword cs:ebx+unk_A327E]
        loop loc_A3F6F
        LD mov, edi, ebx
        jmp near loc_A4873
sub_A3F88:
        mov ax, word [byte ds:ebp+04h]
        mov word [es:esi], ax
        jmp near EmuTrapExit
sub_A3F96:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A3FB7:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A3FD8:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A3FF6:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A4014:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A4035:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A4056:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4077:
        mov ax, word [es:esi]
        cwde
        lea edx, [byte ebp+06Ch]
        call LoadM32Int
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4098:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov ax, word [es:esi]
        cwde
        lea edx, [byte edi+ebp+01Ch]
        call LoadM32Int
        jmp near EmuTrapExit
sub_A40D4:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short loc_A4107
        mov ax, 8000h
loc_A4107:
        mov word [es:esi], ax
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        jmp near EmuTrapExit
sub_A411C:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call StoreM32Int
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short loc_A4143
        mov ax, 8000h
loc_A4143:
        mov word [es:esi], ax
        jmp near loc_A3839
sub_A414C:
        jmp near EmuTrapExit
sub_A4151:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [es:esi]
        lea edx, [byte edi+ebp+01Ch]
        call Emu387IntToLd
        jmp near EmuTrapExit
sub_A418B:
        jmp near loc_A3839
sub_A4190:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        lea eax, [byte edi+ebp+01Ch]
        call Emu387LdToInt
        mov dword [es:esi], eax
        jmp near loc_A3839
sub_A41B4:
        jmp near EmuTrapExit
sub_A41B9:
        jmp dword [nosplit cs:ebx*4+jpt_A41C1]
jpt_A41C1:
        dd loc_A41E1
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
loc_A41E1:
        jmp near EmuTrapExit
sub_A41E6:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A41FB:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A4210:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A4222:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A4234:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A4249:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A425E:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4273:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte edi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4288:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov eax, dword [byte esi+ebp+01Ch]
        mov dword [byte edi+ebp+01Ch], eax
        mov eax, dword [byte esi+ebp+020h]
        mov dword [byte edi+ebp+020h], eax
        mov ax, word [byte esi+ebp+024h]
        mov word [byte edi+ebp+024h], ax
        jmp near EmuTrapExit
sub_A42D0:
        lea ebx, [byte edi+ebp+01Ch]
        lea esi, [byte esi+ebp+01Ch]
        mov eax, dword [esi]
        xchg eax, dword [ebx]
        mov dword [esi], eax
        mov eax, dword [byte esi+04h]
        xchg eax, dword [byte ebx+04h]
        mov dword [byte esi+04h], eax
        mov ax, word [byte esi+08h]
        xchg ax, word [byte ebx+08h]
        mov word [byte esi+08h], ax
        jmp near EmuTrapExit
sub_A42F8:
        jmp dword [nosplit cs:ebx*4+jpt_A4300]
jpt_A4300:
        dd loc_A4320
        dd loc_A432D
        dd sub_A41B4
        dd sub_A41B4
        dd loc_A433A
        dd loc_A436B
        dd sub_A41B4
        dd sub_A41B4
loc_A4320:
        lea eax, [byte edi+ebp+01Ch]
        xor byte [byte eax+09h], 80h
        jmp near EmuTrapExit
loc_A432D:
        lea eax, [byte edi+ebp+01Ch]
        and byte [byte eax+09h], 7Fh
        jmp near EmuTrapExit
loc_A433A:
        mov eax, dword [cs:unk_A3274]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [cs:unk_A3278]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [cs:unk_A327C]
        mov word [byte ds:ebp+074h], ax
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte ebp+06Ch]
        call EmuCompare
        jmp near loc_A3874
loc_A436B:
        lea eax, [byte edi+ebp+01Ch]
        call sub_A5B1A
        jmp near EmuTrapExit
sub_A4379:
        jmp dword [nosplit cs:ebx*4+jpt_A4381]
jpt_A4381:
        dd loc_A43A1
        dd loc_A43E4
        dd loc_A4429
        dd loc_A446E
        dd loc_A44B3
        dd loc_A44F8
        dd loc_A453D
        dd sub_A41B4
loc_A43A1:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], 80000000h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
loc_A43E4:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0CD1B8AFEh
        mov dword [byte esi+04h], 0D49A784Bh
        mov word [byte esi+08h], 4000h
        jmp near EmuTrapExit
loc_A4429:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 5C17F0BCh
        mov dword [byte esi+04h], 0B8AA3B29h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
loc_A446E:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 2168C235h
        mov dword [byte esi+04h], 0C900DAA2h
        mov word [byte esi+08h], 4000h
        jmp near EmuTrapExit
loc_A44B3:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0FBCFF799h
        mov dword [byte esi+04h], 9A209A84h
        mov word [byte esi+08h], 3FFDh
        jmp near EmuTrapExit
loc_A44F8:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        mov dword [esi], 0D1CF79ACh
        mov dword [byte esi+04h], 0B17217F7h
        mov word [byte esi+08h], 3FFEh
        jmp near EmuTrapExit
loc_A453D:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], eax
        mov word [byte esi+08h], ax
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D0]
        or word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
sub_A4594:
        jmp dword [nosplit cs:ebx*4+jpt_A459C]
jpt_A459C:
        dd loc_A45BC
        dd loc_A45C9
        dd loc_A4610
        dd loc_A4C25
        dd loc_A4C6E
        dd loc_A4CD3
        dd loc_A465C
        dd loc_A467D
loc_A45BC:
        lea eax, [byte edi+ebp+01Ch]
        call EmuAtan
        jmp dword [byte ds:ebp+076h]
loc_A45C9:
        lea eax, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea edx, [byte edi+ebp+01Ch]
        call EmuLog2
        jmp dword [byte ds:ebp+076h]
loc_A4610:
        lea eax, [byte edi+ebp+01Ch]
        call sub_A610A
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea esi, [byte edi+ebp+01Ch]
        LD sub, eax, eax
        mov dword [esi], eax
        mov dword [byte esi+04h], 80000000h
        mov word [byte esi+08h], 3FFFh
        jmp near EmuTrapExit
loc_A465C:
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
loc_A467D:
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp near EmuTrapExit
sub_A469E:
        jmp dword [nosplit cs:ebx*4+jpt_A46A6]
jpt_A46A6:
        dd loc_A46C6
        dd loc_A46F0
        dd loc_A4737
        dd loc_A4744
        dd loc_A4CFD
        dd loc_A4D15
        dd loc_A479C
        dd loc_A47A9
loc_A46C6:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuRoundInt
        and eax, byte 7
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A3322]
        mov word [byte ds:ebp+04h], dx
        jmp dword [byte ds:ebp+076h]
loc_A46F0:
        lea eax, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea edx, [byte edi+ebp+01Ch]
        call AddOne
        jmp dword [byte ds:ebp+076h]
loc_A4737:
        lea eax, [byte edi+ebp+01Ch]
        call EmuExp2
        jmp dword [byte ds:ebp+076h]
loc_A4744:
        lea ebx, [byte edi+ebp+01Ch]
        push dword [ebx]
        push dword [byte ebx+04h]
        push dword [byte ebx+06h]
        lea eax, [byte edi+ebp+01Ch]
        call EmuSin
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea ebx, [byte edi+ebp+01Ch]
        pop dword [byte ebx+06h]
        pop dword [byte ebx+04h]
        pop dword [ebx]
        lea eax, [byte edi+ebp+01Ch]
        call EmuCos
        jmp near EmuTrapExit
loc_A479C:
        lea eax, [byte edi+ebp+01Ch]
        call EmuSin
        jmp dword [byte ds:ebp+076h]
loc_A47A9:
        lea eax, [byte edi+ebp+01Ch]
        call EmuCos
        jmp dword [byte ds:ebp+076h]
sub_A47B6:
        jmp dword [nosplit cs:ebx*4+jpt_A47BE]
jpt_A47BE:
        dd sub_A41B4
        dd loc_A47DE
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
loc_A47DE:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte ds:ebp+074h], ax
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A483F:
        jmp dword [nosplit cs:ebx*4+jpt_A4847]
jpt_A4847:
        dd sub_A41B4
        dd sub_A41B4
        dd loc_A4867
        dd loc_A4873
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
loc_A4867:
        and word [byte ds:ebp+04h], 7F00h
        jmp near EmuTrapExit
loc_A4873:
        mov word [byte ds:ebp+00h], 33Fh
        mov word [byte ds:ebp+04h], 0
        mov word [byte ds:ebp+08h], 0FFFFh
        lea edx, [EmuTrapExit]
        mov dword [byte ds:ebp+076h], edx
        LD sub, edi, edi
        jmp near EmuTrapExit
sub_A4899:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuAdd
        jmp dword [byte ds:ebp+076h]
sub_A48AE:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuMul
        jmp dword [byte ds:ebp+076h]
sub_A48C3:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A48D8:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        jmp dword [byte ds:ebp+076h]
sub_A48ED:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4902:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        jmp dword [byte ds:ebp+076h]
sub_A4917:
        mov bx, word [dword cs:esi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:esi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
sub_A4936:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte esi+ebp+01Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte esi+ebp+020h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte esi+ebp+024h], ax
        mov bx, word [dword cs:esi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        jmp near EmuTrapExit
sub_A4962:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near loc_A3874
sub_A4974:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A4986:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte esi+ebp+01Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte esi+ebp+020h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte esi+ebp+024h], ax
        mov bx, word [dword cs:esi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        jmp near loc_A3839
sub_A49B2:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuAdd
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A49FD:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuMul
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A4A48:
        jmp dword [nosplit cs:ebx*4+jpt_A4A50]
jpt_A4A50:
        dd sub_A41B4
        dd loc_A4A70
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
loc_A4A70:
        mov eax, dword [byte edi+ebp+01Ch]
        mov dword [byte ds:ebp+06Ch], eax
        mov eax, dword [byte edi+ebp+020h]
        mov dword [byte ds:ebp+070h], eax
        mov ax, word [byte edi+ebp+024h]
        mov word [byte ds:ebp+074h], ax
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte ebp+06Ch]
        lea edx, [byte edi+ebp+01Ch]
        call EmuCompare
        jmp near sub_A3822
sub_A4AD1:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A4B1C:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuSub
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A4B67:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A4BB2:
        lea eax, [byte esi+ebp+01Ch]
        lea edx, [byte edi+ebp+01Ch]
        lea ebx, [byte esi+ebp+01Ch]
        call EmuDiv
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        jmp dword [byte ds:ebp+076h]
sub_A4BFD:
        jmp dword [nosplit cs:ebx*4+jpt_A4C05]
jpt_A4C05:
        dd loc_A4D86
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
        dd sub_A41B4
loc_A4C25:
        lea edx, [byte edi+ebp+01Ch]
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        mov bx, word [dword cs:edi+unk_A32D6]
        or word [byte ds:ebp+08h], bx
        movzx edi, word [dword cs:edi+unk_A327E]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        lea eax, [byte edi+ebp+01Ch]
        LD mov, ebx, eax
        call EmuRemainder
        jmp dword [byte ds:ebp+076h]
loc_A4C6E:
        lea esi, [byte edi+ebp+01Ch]
        movzx edi, word [dword cs:edi+unk_A3280]
        mov bx, word [dword cs:edi+unk_A3282]
        and word [byte ds:ebp+04h], 0C7FFh
        or word [byte ds:ebp+04h], bx
        mov bx, word [dword cs:edi+unk_A32CE]
        and word [byte ds:ebp+08h], bx
        lea ebx, [byte edi+ebp+01Ch]
        mov eax, dword [esi]
        mov dword [ebx], eax
        mov eax, dword [byte esi+04h]
        mov dword [byte ebx+04h], eax
        mov ax, word [byte esi+08h]
        LD mov, dx, ax
        and dx, 8000h
        or dx, 3FFFh
        mov word [byte ebx+08h], dx
        and ax, 7FFFh
        sub ax, 3FFFh
        cwde
        LD mov, edx, esi
        call StoreM32Int
        jmp near EmuTrapExit
loc_A4CD3:
        lea eax, [byte edi+ebp+01Ch]
        lea edx, [byte esi+ebp+01Ch]
        call EmuRoundInt
        and eax, byte 7
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        or dh, byte [dword cs:eax+unk_A3322]
        mov word [byte ds:ebp+04h], dx
        jmp dword [byte ds:ebp+076h]
loc_A4CFD:
        lea eax, [byte edi+ebp+01Ch]
        mov dx, word [byte ds:ebp+00h]
        and dx, 0C00h
        call ExtToInt
        jmp near EmuTrapExit
loc_A4D15:
        LD mov, esi, edi
        movzx edi, word [dword cs:edi+unk_A327E]
        lea eax, [byte edi+ebp+01Ch]
        mov cx, word [byte eax+08h]
        call StoreM32Int
        LD mov, edi, esi
        lea ebx, [byte edi+ebp+01Ch]
        LD mov, edx, eax
        cwde
        LD cmp, eax, edx
        je short loc_A4D54
        LD or, ch, ch
        jns short loc_A4D45
        LD sub, dx, dx
        LD sub, cx, cx
        jmp short loc_A4D52
loc_A4D45:
        mov dx, 7FFFh
        mov cx, word [byte ebx+08h]
        and cx, 8000h
loc_A4D52:
        jmp short loc_A4D7A
loc_A4D54:
        mov dx, word [byte ebx+08h]
        LD mov, cx, dx
        and cx, 8000h
        and dx, 7FFFh
        LD add, dx, ax
        jns short loc_A4D7A
        LD or, ah, ah
        jns short loc_A4D76
        LD sub, dx, dx
        LD sub, cx, cx
        jmp short loc_A4D7A
loc_A4D76:
        mov dx, 7FFFh
loc_A4D7A:
        LD or, dx, cx
        mov word [byte ebx+08h], dx
        jmp near EmuTrapExit
loc_A4D86:
        mov ax, word [byte ds:ebp+04h]
        LD mov, ebp, esp
        mov word [byte ebp+028h], ax
        jmp near EmuTrapExit
EmuSub:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        xor si, 8000h
        jmp short loc_A4DAB
EmuAdd:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
loc_A4DAB:
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call AddMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
AddExtRaw:
        push esi
        push ecx
        push ebx
        mov si, word [byte esp+018h]
        mov ecx, dword [byte esp+014h]
        mov ebx, dword [byte esp+010h]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call AddMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret 0Ch
AddMantissas:
        LD or, eax, eax
        jne short loc_A4E21
        LD or, edx, edx
        jne short loc_A4E21
        LD add, si, si
        jne short loc_A4E1E
        shr esi, 10h
        LD mov, eax, ebx
        LD mov, edx, ecx
        LD add, esi, esi
        LD or, bx, si
        LD or, ebx, edx
        je short loc_A4E1D
        shr esi, 1
loc_A4E1D:
        ret
loc_A4E1E:
        rcr si, 1
loc_A4E21:
        LD or, ecx, ecx
        jne short loc_A4E32
        LD or, ebx, ebx
        jne short loc_A4E32
        test esi, 7FFF0000h
        jne short loc_A4E32
        ret
loc_A4E32:
        push ebp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        LD mov, ebp, ecx
        rol edi, 10h
        rol ecx, 10h
        LD add, cx, di
        rol edi, 10h
        rol ecx, 10h
        LD sub, cx, di
        je short loc_A4E81
        jae short loc_A4E6D
        LD mov, ebp, edi
        neg cx
        xchg ebx, eax
        db 087h,0D6h                            ; insn: xchg edx,esi
loc_A4E6D:
        cmp cx, byte 40h
        jbe short loc_A4E81
        LD add, ebp, ebp
        rcr bp, 1
        LD mov, eax, ebx
        LD mov, edx, esi
        LD mov, esi, ebp
        pop edi
        pop ebp
        ret
loc_A4E81:
        mov ch, 0
        LD or, ecx, ecx
        jns short loc_A4E96
        mov ch, 0FFh
        neg esi
        neg ebx
        sbb esi, byte 0
        xor ebp, 80000000h
loc_A4E96:
        LD sub, edi, edi
        cmp cl, 0
        je short loc_A4EC9
        push ebx
        LD sub, ebx, ebx
        cmp cl, 20h
        jb short loc_A4EBB
        LD or, eax, eax
        setne bl
        LD mov, edi, ebx
        LD sub, ebx, ebx
        cmp cl, 40h
        jne short loc_A4EB7
        LD or, edi, edx
        LD sub, edx, edx
loc_A4EB7:
        LD mov, eax, edx
        LD sub, edx, edx
loc_A4EBB:
        shrd ebx, eax, cl
        LD or, edi, ebx
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        pop ebx
loc_A4EC9:
        LD add, eax, ebx
        LD adc, edx, esi
        adc ch, 0
        jns short loc_A4EFA
        cmp cl, 40h
        jne short loc_A4EEB
        test edi, 7FFFFFFFh
        setne bl
        shr ebx, 1
        adc eax, byte 0
        adc edx, byte 0
        adc ch, 0
loc_A4EEB:
        neg edx
        neg eax
        sbb edx, byte 0
        mov ch, 0
        xor ebp, 80000000h
loc_A4EFA:
        LD mov, ebx, eax
        LD or, bl, ch
        LD or, ebx, edx
        je short loc_A4F51
        LD or, bp, bp
        je short loc_A4F53
        cmp ch, 0
        jne short loc_A4F1A
        rol edi, 1
        ror edi, 1
loc_A4F10:
        dec bp
        je short loc_A4F53
        LD adc, eax, eax
        LD adc, edx, edx
        jae short loc_A4F10
loc_A4F1A:
        inc bp
        cmp bp, 7FFFh
        je near loc_A4F5D
        stc
        rcr edx, 1
        rcr eax, 1
        jae short loc_A4F4F
        LD add, edi, edi
        jne short loc_A4F36
        ror eax, 1
        rol eax, 1
loc_A4F36:
        adc eax, byte 0
        adc edx, byte 0
        jae short loc_A4F4F
        rcr edx, 1
        rcr eax, 1
        inc bp
        cmp bp, 7FFFh
        je near loc_A4F5D
loc_A4F4F:
        jmp short loc_A4F53
loc_A4F51:
        LD mov, ebp, ebx
loc_A4F53:
        LD add, ebp, ebp
        rcr bp, 1
        LD mov, esi, ebp
        pop edi
        pop ebp
        ret
loc_A4F5D:
        mov bp, 7FFFh
        LD sub, eax, eax
        mov edx, 80000000h
        jmp short loc_A4F53
EmuCompare:
        push edi
        push esi
        mov si, word [byte eax+08h]
        or si, 8000h
        inc si
        jne short loc_A4F82
        mov esi, dword [byte eax+04h]
        LD add, esi, esi
        or esi, dword [eax]
        jne short loc_A4FD5
loc_A4F82:
        mov si, word [byte edx+08h]
        or si, 8000h
        inc si
        jne short loc_A4F98
        mov esi, dword [byte edx+04h]
        LD add, esi, esi
        or esi, dword [edx]
        jne short loc_A4FD5
loc_A4F98:
        mov esi, dword [byte eax+06h]
        mov edi, dword [byte edx+06h]
        LD xor, edi, esi
        mov edi, 0
        js short loc_A4FDD
        mov si, word [byte eax+08h]
        cmp si, word [byte edx+08h]
        jne short loc_A4FBD
        mov edi, dword [byte eax+04h]
        cmp edi, dword [byte edx+04h]
        jne short loc_A4FBD
        mov edi, dword [eax]
        cmp edi, dword [edx]
loc_A4FBD:
        mov edi, 0
        je short loc_A4FD0
        rcr eax, 1
        LD xor, esi, eax
loc_A4FC8:
        LD add, esi, esi
        sbb edi, byte 0
        LD add, edi, edi
        inc edi
loc_A4FD0:
        LD mov, eax, edi
        pop esi
        pop edi
        ret
loc_A4FD5:
        mov eax, 2
        pop esi
        pop edi
        ret
loc_A4FDD:
        or edi, dword [eax]
        or edi, dword [edx]
        or edi, dword [byte eax+04h]
        or edi, dword [byte edx+04h]
        mov ax, word [byte eax+08h]
        shl eax, 10h
        mov ax, word [byte edx+08h]
        and eax, 7FFF7FFFh
        LD or, eax, edi
        mov edi, 0
        jne short loc_A4FC8
        pop esi
        pop edi
        ret
EmuDiv:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call DivideMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
DivideMantissas:
        LD or, ecx, ecx
        jne short loc_A5078
        LD or, ebx, ebx
        jne short loc_A5078
        test esi, 7FFF0000h
        jne short loc_A5078
        LD or, eax, eax
        jne short loc_A5062
        LD or, edx, edx
        jne short loc_A5062
        LD mov, eax, esi
        LD add, ax, ax
        jne short loc_A5062
        mov al, 1
        mov ah, 81h
        call sub_A3890
        mov edx, 0C0000000h
        LD sub, eax, eax
        mov si, 0FFFFh
        jmp short loc_A5077
loc_A5062:
        mov al, 4
        mov ah, 83h
        call sub_A3890
        mov edx, 80000000h
        LD sub, eax, eax
        or si, 7FFFh
loc_A5077:
        ret
loc_A5078:
        LD or, eax, eax
        jne short loc_A5089
        LD or, edx, edx
        jne short loc_A5089
        LD add, si, si
        jne short loc_A5086
        ret
loc_A5086:
        rcr si, 1
loc_A5089:
        push ebp
        LD mov, ebp, esp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        rol edi, 10h
        rol ecx, 10h
        LD add, di, cx
        rol edi, 10h
        rol ecx, 10h
        LD or, di, di
        jne short loc_A50C4
loc_A50BA:
        LD add, eax, eax
        LD adc, edx, edx
        dec di
        LD or, edx, edx
        jns short loc_A50BA
loc_A50C4:
        LD or, cx, cx
        jne short loc_A50D3
loc_A50C9:
        LD add, ebx, ebx
        LD adc, esi, esi
        dec cx
        LD or, esi, esi
        jns short loc_A50C9
loc_A50D3:
        LD sub, di, cx
        add di, 3FFFh
        js short loc_A50F6
        cmp di, 7FFFh
        jb short loc_A50F6
        LD mov, edi, ecx
        mov di, 7FFFh
        mov edx, 80000000h
        LD sub, eax, eax
        jmp near loc_A51CE
loc_A50F6:
        cmp di, byte 0FFC0h
        jge short loc_A5107
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, edi, edi
        jmp near loc_A51CE
loc_A5107:
        push edi
        push esi
        push ebx
        LD mov, ecx, esi
        LD mov, edi, edx
        LD mov, esi, eax
        LD sub, eax, eax
        LD cmp, ecx, edi
        ja short loc_A5119
        LD sub, edx, ecx
        inc eax
loc_A5119:
        push eax
        LD mov, eax, esi
        div ecx
        push eax
        xchg ebx, eax
        mul ebx
        xchg ecx, eax
        db 087h,0DAh                            ; insn: xchg ebx,edx
        mul edx
        LD add, eax, ebx
        adc edx, byte 0
        mov ebx, dword [byte ebp-010h]
        test byte [byte ebp-014h], 1
        je short loc_A513A
        LD add, eax, ebx
        adc edx, dword [byte ebp-0Ch]
loc_A513A:
        neg ecx
        LD sbb, esi, eax
        LD sbb, edi, edx
        je short loc_A5154
loc_A5142:
        sub dword [byte ebp-018h], byte 1
        sbb dword [byte ebp-014h], byte 0
        LD add, ecx, ebx
        adc esi, dword [byte ebp-0Ch]
        adc edi, byte 0
        jne short loc_A5142
loc_A5154:
        LD mov, edi, esi
        LD mov, esi, ecx
        mov ecx, dword [byte ebp-0Ch]
        LD cmp, ecx, edi
        ja short loc_A5169
        LD sub, edi, ecx
        add dword [byte ebp-018h], byte 1
        adc dword [byte ebp-014h], byte 0
loc_A5169:
        LD mov, edx, edi
        LD mov, eax, esi
        div ecx
        push eax
        LD or, eax, eax
        je short loc_A51A0
        xchg ebx, eax
        mul ebx
        xchg ecx, eax
        db 087h,0DAh                            ; insn: xchg ebx,edx
        mul edx
        LD add, eax, ebx
        adc edx, byte 0
        neg ecx
        LD sbb, esi, eax
        LD sbb, edi, edx
        je short loc_A51A0
loc_A5189:
        sub dword [byte ebp-01Ch], byte 1
        sbb dword [byte ebp-018h], byte 0
        sbb dword [byte ebp-014h], byte 0
        add ecx, dword [byte ebp-010h]
        adc esi, dword [byte ebp-0Ch]
        adc edi, byte 0
        jne short loc_A5189
loc_A51A0:
        pop eax
        pop edx
        pop ebx
        add esp, byte 8
        pop edi
        dec di
        shr ebx, 1
        jae short loc_A51B2
        rcr edx, 1
        rcr eax, 1
        inc edi
loc_A51B2:
        LD or, di, di
        jg short loc_A51CE
        jne short loc_A51BD
        mov cl, 1
        jmp short loc_A51C3
loc_A51BD:
        neg di
        LD mov, cx, di
loc_A51C3:
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        LD sub, di, di
loc_A51CE:
        LD add, edi, edi
        rcr di, 1
        LD mov, esi, edi
        pop edi
        pop ebp
        ret
EmuMul:
        push esi
        push ecx
        push ebx
        mov si, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        shl esi, 10h
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call MultiplyMantissas
        pop ebx
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], si
        pop ecx
        pop esi
        ret
MultiplyMantissas:
        LD or, eax, eax
        jne short loc_A5213
        LD or, edx, edx
        jne short loc_A5213
        LD add, si, si
        jne short loc_A5210
        ret
loc_A5210:
        rcr si, 1
loc_A5213:
        LD or, ecx, ecx
        jne short loc_A522A
        LD or, ebx, ebx
        jne short loc_A522A
        test esi, 7FFF0000h
        jne short loc_A522A
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, esi, esi
        ret
loc_A522A:
        push ebp
        push edi
        db 087h,0CEh                            ; insn: xchg ecx,esi
        LD mov, edi, ecx
        rol edi, 10h
        sar edi, 10h
        sar ecx, 10h
        and edi, 80007FFFh
        and ecx, 80007FFFh
        LD add, ecx, edi
        sub cx, 3FFEh
        jb short loc_A525A
        cmp cx, 7FFFh
        jb short loc_A525A
        jmp near loc_A52F1
loc_A525A:
        cmp cx, byte 0FFC0h
        jge short loc_A526B
        LD sub, eax, eax
        LD sub, edx, edx
        LD sub, ecx, ecx
        jmp short loc_A52E7
        db 090h,090h,090h
loc_A526B:
        push ecx
        LD sub, ebp, ebp
        push esi
        push edx
        push eax
        mul ebx
        xchg esi, eax
        LD mov, ecx, edx
        pop edx
        mul edx
        LD mov, edi, edx
        LD add, ecx, eax
        LD adc, edi, ebp
        LD adc, ebp, ebp
        pop eax
        xchg ebx, eax
        mul ebx
        LD add, ecx, eax
        LD adc, edi, edx
        adc ebp, byte 0
        LD mov, eax, ebx
        pop edx
        mul edx
        LD add, eax, edi
        LD adc, edx, ebp
        LD mov, ebx, ecx
        pop ecx
        js short loc_A52A2
        LD add, ebx, ebx
        LD adc, eax, eax
        LD adc, edx, edx
        dec cx
loc_A52A2:
        LD add, ebx, ebx
        jae short loc_A52CE
        jne short loc_A52B5
        LD or, esi, esi
        setne bl
        shr ebx, 1
        jb short loc_A52B5
        LD mov, esi, eax
        shr esi, 1
loc_A52B5:
        adc eax, byte 0
        adc edx, byte 0
        jae short loc_A52CE
        rcr edx, 1
        rcr eax, 1
        inc cx
        cmp cx, 7FFFh
        je near loc_A52F1
loc_A52CE:
        LD or, cx, cx
        jg short loc_A52E7
        jne short loc_A52D9
        mov cl, 1
        jmp short loc_A52DC
loc_A52D9:
        neg cx
loc_A52DC:
        LD sub, ebx, ebx
        shrd eax, edx, cl
        shrd edx, ebx, cl
        LD sub, cx, cx
loc_A52E7:
        LD add, ecx, ecx
        rcr cx, 1
        LD mov, esi, ecx
        pop edi
        pop ebp
        ret
loc_A52F1:
        mov cx, 7FFFh
        mov edx, 80000000h
        LD sub, eax, eax
        jmp short loc_A52E7
sub_A52FE:
        push ebx
        mov bl, 0A0h
        jmp short loc_A535B
        push ebx
        mov bh, byte [byte eax+09h]
        push ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        jne short loc_A5317
        LD sub, eax, eax
        jmp short loc_A5350
loc_A5317:
        sub cx, 3FFEh
        jg short loc_A5324
        LD add, bh, bh
        LD sbb, eax, eax
        jmp short loc_A5350
loc_A5324:
        cmp cx, byte 1Fh
        jle short loc_A5331
        mov eax, 80000000h
        jmp short loc_A5350
loc_A5331:
        LD mov, ch, bh
        mov ebx, dword [eax]
        mov eax, dword [byte eax+04h]
        push edx
        LD sub, edx, edx
        shld edx, eax, cl
        shl eax, cl
        LD or, ebx, eax
        LD mov, eax, edx
        pop edx
        LD add, ch, ch
        jae short loc_A5350
        LD or, ebx, ebx
        je short loc_A534E
        inc eax
loc_A534E:
        neg eax
loc_A5350:
        pop ecx
        pop ebx
        ret
StoreM32Int:
        push ebx
        mov bl, 1Fh
        jmp short loc_A535B
Emu387LdToInt:
        push ebx
        mov bl, 20h
loc_A535B:
        mov bh, byte [byte eax+09h]
        shr bh, 1
        LD or, bh, bl
        push ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        sub cx, 3FFEh
        jl short loc_A53BD
        cmp cx, byte 20h
        jg short loc_A53B5
        and bl, 3Fh
        LD cmp, cl, bl
        jg short loc_A53B5
        LD mov, ch, bh
        mov ebx, dword [eax]
        mov eax, dword [byte eax+04h]
        LD add, ebx, ebx
        rcr ch, 1
        cmp cl, 20h
        jne short loc_A5394
        LD add, ch, ch
        jmp short loc_A53A1
loc_A5394:
        LD sub, ebx, ebx
        shld ebx, eax, cl
        shl eax, cl
        LD add, ch, ch
        LD add, eax, eax
        LD mov, eax, ebx
loc_A53A1:
        mov cl, 0FFh
        rcr cl, 1
        LD and, ch, cl
        LD add, ch, ch
        adc eax, byte 0
        LD add, ch, ch
        jae short loc_A53B2
        neg eax
loc_A53B2:
        pop ecx
        pop ebx
        ret
loc_A53B5:
        mov eax, 80000000h
        pop ecx
        pop ebx
        ret
loc_A53BD:
        LD sub, eax, eax
        pop ecx
        pop ebx
        ret
LoadM32Int:
        push ebx
        LD mov, ebx, edx
        LD or, eax, eax
        jns short loc_A53D2
        neg eax
        mov edx, 0BFFFh
        jmp short loc_A53DB
loc_A53D2:
        pop ebx
Emu387IntToLd:
        push ebx
        LD mov, ebx, edx
        mov edx, 3FFFh
loc_A53DB:
        push ecx
        LD or, eax, eax
        je short loc_A53F6
        bsr ecx, eax
        LD mov, ch, cl
        mov cl, 1Fh
        LD sub, cl, ch
        shl eax, cl
        LD mov, cl, ch
        movzx ecx, ch
        LD add, ecx, edx
        LD mov, edx, eax
        jmp short loc_A53FA
loc_A53F6:
        LD sub, edx, edx
        LD sub, ecx, ecx
loc_A53FA:
        LD sub, eax, eax
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        mov word [byte ebx+08h], cx
        pop ecx
        pop ebx
        ret
LoadM64Real:
        push ecx
        LD mov, ecx, edx
        shld edx, eax, 0Bh
        shl eax, 0Bh
        sar ecx, 14h
        and cx, 7FFh
        je short loc_A5453
        cmp cx, 7FFh
        je short loc_A542A
        add cx, 3C00h
        jmp short loc_A544B
loc_A542A:
        mov cx, 7FFFh
        test edx, 7FFFFFFFh
        jne short loc_A5438
        LD or, eax, eax
loc_A5438:
        je short loc_A544B
        push eax
        mov al, 1
        mov ah, 81h
        call sub_A3890
        pop eax
        or edx, 40000000h
loc_A544B:
        or edx, 80000000h
        jmp short loc_A5478
loc_A5453:
        LD or, edx, edx
        jne short loc_A545F
        LD or, eax, eax
        jne short loc_A545F
        LD sub, ecx, ecx
        jmp short loc_A5478
loc_A545F:
        mov cx, 3C01h
        LD or, edx, edx
        jne short loc_A546C
        xchg edx, eax
        sub cx, byte 20h
loc_A546C:
        LD or, edx, edx
        js short loc_A5478
        LD add, eax, eax
        LD adc, edx, edx
        dec cx
        jmp short loc_A546C
loc_A5478:
        mov dword [ebx], eax
        mov dword [byte ebx+04h], edx
        LD add, ecx, ecx
        rcr cx, 1
        mov word [byte ebx+08h], cx
        pop ecx
        ret
StoreM32Real:
        push edx
        push ecx
        push ebx
        LD mov, ebx, eax
        mov edx, 0FFFFFF00h
        mov eax, dword [byte ebx+04h]
        LD mov, ecx, eax
        shl ecx, 19h
        mov cx, word [byte ebx+08h]
        jae short loc_A54B7
        jne short loc_A54A9
        cmp dword [ebx], byte 0
        jne short loc_A54A9
        LD add, edx, edx
loc_A54A9:
        add eax, 100h
        jae short loc_A54B7
        mov eax, 80000000h
        inc cx
loc_A54B7:
        LD and, eax, edx
        LD mov, ebx, ecx
        and cx, 7FFFh
        je short loc_A5503
        cmp cx, 7FFFh
        jne short loc_A54DA
        LD add, eax, eax
        shr eax, 8
        or eax, 0FF000000h
        LD add, bx, bx
        rcr eax, 1
        jmp short loc_A5503
loc_A54DA:
        add cx, 0C080h
        jns short loc_A54E5
        LD sub, eax, eax
        jmp short loc_A5503
loc_A54E5:
        cmp cx, 0FFh
        jl short loc_A54F8
        mov eax, 0FF000000h
        LD add, bx, bx
        rcr eax, 1
        jmp short loc_A5503
loc_A54F8:
        LD add, eax, eax
        shrd eax, ecx, 8
        LD add, bx, bx
        rcr eax, 1
loc_A5503:
        pop ebx
        pop ecx
        pop edx
        ret
StoreM64Real:
        push ecx
        push ebx
        push esi
        mov cx, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        mov esi, 0FFFFF800h
        LD mov, ebx, eax
        shl ebx, 16h
        jae short loc_A5534
        jne short loc_A5523
        LD add, esi, esi
loc_A5523:
        add eax, 800h
        adc edx, byte 0
        jae short loc_A5534
        mov edx, 80000000h
        inc cx
loc_A5534:
        LD and, eax, esi
        LD mov, ebx, ecx
        and cx, 7FFFh
        add cx, 0C400h
        cmp cx, 7FFh
        jae short loc_A556A
        LD or, cx, cx
        jne short loc_A5559
        shrd eax, edx, 0Ch
        LD add, edx, edx
        shr edx, 0Ch
        jmp short loc_A5563
loc_A5559:
        shrd eax, edx, 0Bh
        LD add, edx, edx
        shrd edx, ecx, 0Bh
loc_A5563:
        LD add, bx, bx
        rcr edx, 1
        jmp short loc_A55CA
loc_A556A:
        cmp cx, 0C400h
        jb short loc_A55A4
        cmp cx, byte 0FFCCh
        jl short loc_A559E
        sub cx, byte 0Ch
        neg cx
        cmp cl, 20h
        jb short loc_A558C
        sub cl, 20h
        LD mov, esi, eax
        LD mov, eax, edx
        LD sub, edx, edx
loc_A558C:
        shrd esi, eax, cl
        shrd eax, edx, cl
        shr edx, cl
        LD add, esi, esi
        adc eax, byte 0
        adc edx, byte 0
        jmp short loc_A55A2
loc_A559E:
        LD sub, eax, eax
        LD sub, edx, edx
loc_A55A2:
        jmp short loc_A55CA
loc_A55A4:
        shrd eax, edx, 0Bh
        LD add, edx, edx
        shr edx, 0Bh
        LD add, bx, bx
        rcr edx, 1
        or edx, 7FF00000h
        cmp cx, 43FFh
        je short loc_A55CA
        push eax
        mov al, 8
        mov ah, 84h
        call sub_A3890
        pop eax
loc_A55CA:
        pop esi
        pop ebx
        pop ecx
        ret
sub_A55CE:
        push ecx
        push ebx
        LD mov, ebx, edx
        LD sub, edx, edx
        LD mov, ecx, eax
        sar ecx, 17h
        and cx, 0FFh
        je short loc_A5607
        shl eax, 8
        cmp cl, 0FFh
        je short loc_A55EF
        add cx, 3F80h
        jmp short loc_A55FD
loc_A55EF:
        mov ch, 0FFh
        and eax, 7FFFFFFFh
        je short loc_A55FD
        or eax, 40000000h
loc_A55FD:
        LD add, ecx, ecx
        rcr cx, 1
        or eax, 80000000h
loc_A5607:
        mov dword [ebx], edx
        mov dword [byte ebx+04h], eax
        mov word [byte ebx+08h], cx
        pop ebx
        pop ecx
        ret
unk_A5613:
        db 0FFh,0FFh,0FFh,07Fh,0FFh,0FFh,0FFh,03Fh,0FFh,0FFh,0FFh,01Fh,0FFh,0FFh,0FFh,0Fh
        db 0FFh,0FFh,0FFh,07h,0FFh,0FFh,0FFh,03h,0FFh,0FFh,0FFh,01h,0FFh,0FFh,0FFh,00h
        db 0FFh,0FFh,07Fh,00h,0FFh,0FFh,03Fh,00h,0FFh,0FFh,01Fh,00h,0FFh,0FFh,0Fh,00h
        db 0FFh,0FFh,07h,00h,0FFh,0FFh,03h,00h,0FFh,0FFh,01h,00h,0FFh,0FFh,00h,00h
        db 0FFh,07Fh,00h,00h,0FFh,03Fh,00h,00h,0FFh,01Fh,00h,00h,0FFh,0Fh,00h,00h
        db 0FFh,07h,00h,00h,0FFh,03h,00h,00h,0FFh,01h,00h,00h,0FFh,00h,00h,00h
        db 07Fh,00h,00h,00h,03Fh,00h,00h,00h,01Fh,00h,00h,00h,0Fh,00h,00h,00h
        db 07h,00h,00h,00h,03h,00h,00h,00h,01h,00h,00h,00h,00h,00h,00h,00h
ExtToInt:
        push edi
        LD mov, edi, eax
        LD sub, ebx, ebx
        mov bx, word [byte edi+08h]
        cmp dx, 400h
        je short loc_A56A8
        cmp dx, 800h
loc_A56A8:
        jne short loc_A56B3
        LD or, bh, bh
        jns short loc_A56B3
        xor dx, 0C00h
loc_A56B3:
        cmp dx, 0C00h
        jne short loc_A56BE
        mov dx, 400h
loc_A56BE:
        and bx, 7FFFh
        sub bx, 403Fh
        jl short loc_A56CC
        pop edi
        ret
loc_A56CC:
        mov ecx, dword [edi]
        add bx, byte 20h
        jl short loc_A5722
        mov eax, dword [nosplit cs:ebx*4+unk_A5613]
        LD and, ecx, eax
        xor dword [edi], ecx
        inc eax
        cmp dx, 400h
        je short loc_A5720
        cmp dx, byte 0
        jne short loc_A570D
        LD add, ecx, ecx
        LD cmp, eax, ecx
        ja near loc_A5720
        jne short loc_A570D
        rol eax, 1
        jae short loc_A5703
        test dword [byte edi+04h], eax
        jmp short loc_A5705
loc_A5703:
        test dword [edi], eax
loc_A5705:
        je near loc_A5720
        ror eax, 1
loc_A570D:
        LD or, ecx, ecx
        je short loc_A5720
        add dword [edi], eax
        adc dword [byte edi+04h], byte 0
        jae short loc_A5720
        rcr dword [byte edi+04h], 1
        inc word [byte edi+08h]
loc_A5720:
        pop edi
        ret
loc_A5722:
        push esi
        mov dword [edi], 0
        mov esi, dword [byte edi+04h]
        add bx, byte 20h
        jl short loc_A5785
        mov eax, dword [nosplit cs:ebx*4+unk_A5613]
        LD and, esi, eax
        xor dword [byte edi+04h], esi
        inc eax
        cmp dx, 400h
        je short loc_A5782
        cmp dx, byte 0
        jne short loc_A5772
        rol ecx, 1
        LD adc, esi, esi
        LD cmp, eax, esi
        ja near loc_A5782
        jne short loc_A5772
        LD or, ecx, ecx
        jne near loc_A5776
        LD add, eax, eax
        jb short loc_A576A
        test dword [byte edi+04h], eax
loc_A576A:
        je near loc_A5782
        shr eax, 1
loc_A5772:
        LD or, ecx, esi
        je short loc_A5782
loc_A5776:
        add dword [byte edi+04h], eax
        jae short loc_A5782
        rcr dword [byte edi+04h], 1
        inc word [byte edi+08h]
loc_A5782:
        pop esi
        pop edi
        ret
loc_A5785:
        cmp dx, 400h
        je short loc_A57BA
        cmp dx, byte 0
        jne short loc_A57AA
        inc bx
        jne near loc_A57BA
        cmp esi, 80000000h
        jne short loc_A57AA
        LD or, ecx, ecx
        je near loc_A57BA
loc_A57AA:
        mov dword [byte edi+04h], 80000000h
        or word [byte edi+08h], 3FFFh
        pop esi
        pop edi
        ret
loc_A57BA:
        LD sub, eax, eax
        mov dword [byte edi+04h], eax
        mov word [byte edi+08h], ax
        pop esi
        pop edi
        ret
unk_A57C6:
        db 04Eh,018h,0E6h,0C0h,0E4h,0C7h,0D1h,0B5h,0FAh,03Fh,029h,0Bh,01h,08h,08h,09Bh
        db 0C6h,084h,0FBh,0BFh,01Ah,026h,0C5h,06Ch,02Eh,02h,046h,09Dh,0FBh,03Fh,02Ah,098h
        db 06Bh,0Ah,09Dh,0B9h,02Bh,0BAh,0FBh,0BFh,071h,01h,02Bh,095h,027h,027h,08Eh,0E3h
        db 0FBh,03Fh,0FCh,068h,09Ch,0DDh,072h,024h,049h,092h,0FCh,0BFh,0C1h,0ADh,0EBh,094h
        db 0CCh,0CCh,0CCh,0CCh,0FCh,03Fh,0F2h,081h,097h,0AAh,0AAh,0AAh,0AAh,0AAh,0FDh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
EmuRemainder:
        push edi
        push esi
        push ecx
        LD mov, edi, eax
        mov cx, word [byte edi+08h]
        shl cx, 1
        jne short loc_A585E
        test byte [byte edx+09h], 80h
        je short loc_A5849
        mov word [byte ebx+08h], 4000h
        mov dword [byte ebx+04h], 0C90FDAA2h
        mov dword [ebx], 2168C235h
        jmp short loc_A585C
loc_A5849:
        mov word [byte ebx+08h], 0
        mov dword [byte ebx+04h], 0
        mov dword [ebx], 0
loc_A585C:
        jmp short loc_A58D2
loc_A585E:
        mov cx, word [byte edx+08h]
        shl cx, 1
        jne short loc_A5886
        mov ax, word [byte edi+08h]
        and ax, 8000h
        or ax, 3FFFh
        mov word [byte ebx+08h], ax
        mov dword [byte ebx+04h], 0C90FDAA2h
        mov dword [ebx], 2168C235h
        jmp short loc_A58D2
loc_A5886:
        mov ch, byte [byte edi+09h]
        call EmuDiv
        LD mov, eax, ebx
        call RemainderStep
        mov dl, byte [byte ebx+09h]
        LD or, ch, ch
        js short loc_A58B8
        LD or, dl, dl
        jns short loc_A58B6
        LD mov, eax, ebx
        push dword 4000h
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
loc_A58B6:
        jmp short loc_A58D2
loc_A58B8:
        LD or, dl, dl
        jle short loc_A58D2
        LD mov, eax, ebx
        push dword 0C000h
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
loc_A58D2:
        pop ecx
        pop esi
        pop edi
        ret
RemainderStep:
        push edi
        push esi
        push ecx
        LD mov, edi, eax
        mov ch, 0
        mov cl, byte [byte edi+09h]
        and byte [byte edi+09h], 7Fh
        cmp word [byte edi+08h], 3FFFh
        jne short loc_A5918
        cmp dword [byte edi+04h], 80000000h
        jne short loc_A5918
        cmp dword [edi], byte 0
        jne short loc_A5918
        mov dword [edi], 2168C235h
        mov dword [byte edi+04h], 0C90FDAA2h
        mov ax, 3FFEh
        and cl, 80h
        LD or, ah, cl
        mov word [byte edi+08h], ax
        pop ecx
        pop esi
        pop edi
        ret
loc_A5918:
        push edx
        push ebx
        cmp word [byte edi+08h], 3FFFh
        jl short loc_A594E
        push ecx
        mov si, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl esi, 10h
        mov si, 3FFFh
        mov edx, 80000000h
        mov eax, 0
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        mov ch, 2
loc_A594E:
        mov ax, word [byte edi+08h]
        cmp ax, 3FFDh
        jne short loc_A5969
        mov eax, dword [byte edi+04h]
        cmp eax, 8930A2F4h
        jne short loc_A5969
        mov eax, dword [edi]
        cmp eax, 0F66AB09Bh
loc_A5969:
        jbe short loc_A59DC
        push ecx
        mov ebx, 0C265539Eh
        mov ecx, 0DDB3D742h
        mov esi, 3FFF0000h
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        call AddMantissas
        push eax
        push edx
        push esi
        mov ebx, 0C265539Eh
        mov ecx, 0DDB3D742h
        mov esi, 3FFF0000h
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        call MultiplyMantissas
        LD sub, ebx, ebx
        mov ecx, 80000000h
        rol esi, 10h
        mov si, 0BFFFh
        rol esi, 10h
        call AddMantissas
        pop ebx
        shl ebx, 10h
        LD mov, bx, si
        LD mov, esi, ebx
        pop ecx
        pop ebx
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        or ch, 1
loc_A59DC:
        LD mov, eax, edi
        lea edx, [unk_A57C6]
        mov ebx, 8
        call PolyEvalOdd
        shr ch, 1
        jae short loc_A5A0A
        LD mov, eax, edi
        push dword 3FFEh
        push dword 860A91C1h
        push dword 6B9B2C23h
        LD mov, ebx, edi
        call AddExtRaw
loc_A5A0A:
        shr ch, 1
        jae short loc_A5A2A
        push dword 0BFFFh
        push dword 0C90FDAA2h
        push dword 2168C235h
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
loc_A5A2A:
        cmp cl, 0
        jns short loc_A5A33
        xor byte [byte edi+09h], 80h
loc_A5A33:
        pop ebx
        pop edx
        pop ecx
        pop esi
        pop edi
        ret
EmuRoundInt:
        cmp word [byte eax+08h], byte 0
        jne short loc_A5A4E
        cmp dword [byte eax+04h], byte 0
        jne short loc_A5A4E
        cmp dword [eax], byte 0
        jne short loc_A5A4E
        LD sub, eax, eax
        ret
loc_A5A4E:
        cmp word [byte edx+08h], byte 0
        jne short loc_A5A6E
        cmp dword [byte edx+04h], byte 0
        jne short loc_A5A6E
        cmp dword [edx], byte 0
        jne short loc_A5A6E
        LD sub, edx, edx
        mov dword [eax], edx
        mov dword [byte eax+04h], edx
        mov word [byte eax+08h], dx
        LD sub, eax, eax
        ret
loc_A5A6E:
        push ebp
        push esi
        push edi
        push edx
        push ecx
        push ebx
        push eax
        mov si, word [byte eax+08h]
        mov di, word [byte edx+08h]
        mov ecx, dword [byte edx+04h]
        mov ebx, dword [edx]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call RoundMantissa
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        LD mov, eax, edi
        pop ebx
        pop ecx
        pop edx
        pop edi
        pop esi
        pop ebp
        ret
RoundMantissa:
        push esi
        push edi
        and esi, 7FFFh
        and edi, 7FFFh
        LD sub, esi, edi
        jl short loc_A5AFE
        LD sub, edi, edi
loc_A5AB3:
        LD cmp, ecx, edx
        jne short loc_A5ABF
        LD cmp, ebx, eax
        je near loc_A5AC1
loc_A5ABF:
        jae short loc_A5AC6
loc_A5AC1:
        LD sub, eax, ebx
        LD sbb, edx, ecx
        stc
loc_A5AC6:
        LD adc, edi, edi
        dec esi
        jl near loc_A5ADB
        LD add, eax, eax
        LD adc, edx, edx
        jb short loc_A5AC1
        LD or, edx, edx
        js short loc_A5AB3
        jmp short loc_A5AC6
loc_A5ADB:
        LD sub, esi, esi
        LD or, eax, eax
        jne short loc_A5AE7
        LD or, edx, edx
        jne short loc_A5AE7
        jmp short loc_A5AFC
loc_A5AE7:
        LD or, edx, edx
        js short loc_A5AF2
        LD adc, eax, eax
        LD adc, edx, edx
        dec esi
        jmp short loc_A5AE7
loc_A5AF2:
        pop ecx
        push ecx
        and ecx, 7FFFh
        LD add, esi, ecx
loc_A5AFC:
        jmp short loc_A5B02
loc_A5AFE:
        LD add, esi, edi
        LD sub, edi, edi
loc_A5B02:
        pop ecx
        pop ebx
        and ebx, 8000h
        LD or, esi, ebx
        LD or, edx, edx
        jne short loc_A5B12
        LD sub, esi, esi
loc_A5B12:
        LD xor, bx, cx
        jns short loc_A5B19
        neg edi
loc_A5B19:
        ret
sub_A5B1A:
        push ebx
        push edx
        LD mov, ebx, eax
        mov ax, word [dword cs:edi+unk_A32D6]
        LD mov, edx, eax
        and ax, word [byte ds:ebp+08h]
        LD cmp, ax, dx
        jne short loc_A5B38
        mov al, 41h
        mov dh, 0
        jmp short loc_A5BAB
loc_A5B38:
        not edx
        and word [byte ds:ebp+08h], dx
        mov ax, word [byte ebx+08h]
        LD mov, edx, eax
        and dh, 80h
        rol dh, 1
        shl dh, 1
        and ax, 7FFFh
        jne short loc_A5B6C
        mov eax, dword [byte ebx+04h]
        or eax, dword [ebx]
        mov al, 44h
        jne short loc_A5B6A
        mov ax, word [dword cs:edi+unk_A32D0]
        or word [byte ds:ebp+08h], ax
        mov al, 40h
loc_A5B6A:
        jmp short loc_A5BAB
loc_A5B6C:
        cmp ax, 7FFFh
        jne short loc_A5B94
        mov ax, word [dword cs:edi+unk_A32D4]
        or word [byte ds:ebp+08h], ax
        cmp dword [ebx], byte 0
        jne short loc_A5B8C
        mov eax, dword [byte ebx+04h]
        cmp eax, 80000000h
loc_A5B8C:
        mov al, 1
        jne short loc_A5B92
        mov al, 5
loc_A5B92:
        jmp short loc_A5BAB
loc_A5B94:
        test byte [byte ebx+07h], 80h
        mov al, 4
        jne short loc_A5BAB
        mov ax, word [dword cs:edi+unk_A32D4]
        or word [byte ds:ebp+08h], ax
        mov al, 44h
loc_A5BAB:
        LD or, al, dh
        mov dx, word [byte ds:ebp+04h]
        and dx, 0B8FFh
        LD or, dh, al
        mov word [byte ds:ebp+04h], dx
        pop edx
        pop ebx
        ret
        db 090h
unk_A5BC2:
        db 0E9h,046h,0E9h,0B5h,09Ah,0ADh,020h,0CAh,0FEh,0BFh,09h,065h,07Fh,0B5h,00h,051h
        db 012h,083h,03h,040h,028h,0D2h,0ACh,09Dh,095h,0F8h,03Fh,080h,05h,0C0h
unk_A5BE0:
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh,0BBh,076h,070h,03Eh,05Bh,02h
        db 0ACh,08Eh,04h,0C0h,060h,0EFh,033h,0A9h,0D0h,01Fh,04h,09Ch,07h,040h,096h,0BBh
        db 083h,06Ch,0E0h,0F4h,05Fh,0C0h,08h,0C0h
AddOne:
        push ebx
        push edx
        push eax
        push dword 3FFFh
        push dword 80000000h
        push byte 0
        LD mov, ebx, eax
        call AddExtRaw
        pop eax
        pop edx
        pop ebx
EmuLog2:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        push eax
        call Log2Core
        pop eax
        LD mov, ebx, edx
        push edx
        call EmuMul
        pop edi
        mov si, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl esi, 10h
        mov si, 3FFFh
        mov edx, 0B8AA3B29h
        mov eax, 5C17F0BDh
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
Log2Core:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        LD sub, ecx, ecx
        mov cx, word [byte eax+08h]
        LD or, cx, cx
        js short loc_A5C76
        jmp short loc_A5C76
loc_A5C76:
        LD mov, edi, eax
        mov edx, 3FFEh
        sub ecx, 3FFEh
        push ecx
        mov word [byte edi+08h], dx
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov esi, 0BFFE3FFEh
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        cmp word [byte edi+08h], 3FFEh
        jne short loc_A5CB5
        cmp dword [byte edi+04h], 0B504F333h
        jne short loc_A5CB5
        cmp dword [edi], 0F9DE6484h
loc_A5CB5:
        jbe short loc_A5CD1
        and esi, 0FFFFh
        or esi, 0BFFE0000h
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        jmp short loc_A5CDD
loc_A5CD1:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        dec dword [esp]
loc_A5CDD:
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        dec si
        and esi, 0FFFFh
        or esi, 3FFE0000h
        mov ecx, 80000000h
        LD sub, ebx, ebx
        call AddMantissas
        shl esi, 10h
        LD mov, ecx, edx
        LD mov, ebx, eax
        pop eax
        LD mov, si, ax
        pop edx
        pop eax
        call DivideMantissas
        push eax
        push edx
        push esi
        LD mov, ecx, esi
        shl esi, 10h
        LD mov, si, cx
        LD mov, ecx, edx
        LD mov, ebx, eax
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        mov ebx, 3
        lea ecx, [unk_A5BE0]
        call PolyEval
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        lea ecx, [unk_A5BC2]
        mov ebx, 2
        call PolyEval
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call DivideMantissas
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        rol esi, 10h
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        rol esi, 10h
        mov si, word [esp]
        rol esi, 10h
        mov ecx, dword [byte esp+04h]
        mov ebx, dword [byte esp+08h]
        call MultiplyMantissas
        rol esi, 10h
        pop ecx
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
        pop ecx
        LD or, ecx, ecx
        je short loc_A5E26
        push eax
        push edx
        push esi
        LD mov, edx, edi
        LD mov, eax, ecx
        call LoadM32Int
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        and esi, 0FFFFh
        or esi, 0BFF20000h
        mov ecx, 0DE8082E3h
        mov ebx, 865435Ch
        call MultiplyMantissas
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
        push eax
        push edx
        push esi
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        and esi, 0FFFFh
        or esi, 3FFE0000h
        mov ecx, 0B1800000h
        LD sub, ebx, ebx
        call MultiplyMantissas
        pop ecx
        rol esi, 10h
        LD mov, si, cx
        rol esi, 10h
        pop ecx
        pop ebx
        call AddMantissas
loc_A5E26:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
        db 090h
unk_A5E36:
        db 059h,053h,06Ah,085h,081h,03Bh,096h,0CAh,0CEh,03Fh,08Fh,0F8h,0C0h,09Dh,039h,09Fh
        db 03Fh,0D7h,0D6h,0BFh,0E5h,04Bh,068h,043h,09Dh,030h,092h,0B0h,0DEh,03Fh,07Fh,01Ch
        db 027h,0AAh,03Fh,02Bh,032h,0D7h,0E5h,0BFh,07Dh,09Ch,039h,0B6h,02Ah,01Dh,0EFh,0B8h
        db 0ECh,03Fh,0Ch,0D0h,00h,0Dh,0D0h,00h,0Dh,0D0h,0F2h,0BFh,088h,088h,088h,088h
        db 088h,088h,088h,088h,0F8h,03Fh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0AAh,0FCh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
unk_A5E90:
        db 08Fh,0F8h,0C0h,09Dh,039h,09Fh,03Fh,0D7h,0D2h,03Fh,05h,0E9h,0E4h,03h,046h,0A5h
        db 0CBh,0C9h,0DAh,0BFh,0AAh,0BDh,0C4h,0C6h,07Fh,0C7h,076h,08Fh,0E2h,03Fh,097h,0E3h
        db 0FAh,0C4h,0BBh,07Dh,0F2h,093h,0E9h,0BFh,0Dh,0D0h,00h,0Dh,0D0h,00h,0Dh,0D0h
        db 0EFh,03Fh,0Bh,0B6h,060h,0Bh,0B6h,060h,0Bh,0B6h,0F5h,0BFh,0AAh,0AAh,0AAh,0AAh
        db 0AAh,0AAh,0AAh,0AAh,0FAh,03Fh,00h,00h,00h,00h,00h,00h,00h,080h,0FEh,0BFh
        db 00h,00h,00h,00h,00h,00h,00h,080h,0FFh,03Fh
unk_A5EEA:
        db 00h,00h,01h,00h,02h,00h,03h,00h,04h,00h,04h,00h,05h,00h,05h,00h
        db 06h,00h
SinCosCore:
        push ebp
        push edi
        push edx
        push ecx
        push ebx
        LD mov, ebp, esp
        sub esp, byte 0Ch
        LD mov, edi, eax
        LD sub, ecx, ecx
        mov cx, word [byte eax+08h]
        and cx, 7FFFh
        sub cx, 3FFEh
        cmp cx, byte 20h
        jl short loc_A5F1E
loc_A5F1E:
        push ecx
        push esi
        push edi
        mov si, word [byte eax+08h]
        mov di, 3FFEh
        mov ecx, 0C90FDAA2h
        mov ebx, 2168C235h
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call RoundMantissa
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        LD mov, eax, edi
        LD mov, edi, ecx
        pop esi
        test byte [byte edi+09h], 80h
        je short loc_A5F6D
        push eax
        LD mov, ebx, edi
        LD mov, eax, edi
        push dword 3FFEh
        push dword 0C90FDAA2h
        push dword 2168C235h
        call AddExtRaw
        pop eax
        dec eax
loc_A5F6D:
        LD mov, ebx, esi
        LD mov, ah, bl
        and bl, 2
        LD add, al, bl
        and al, 7
        push eax
        test al, 1
        je short loc_A5F99
        push dword 0BFFEh
        push dword 0C90FDAA2h
        push dword 2168C235h
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
loc_A5F99:
        LD sub, ecx, ecx
        mov cx, word [byte edi+08h]
        sub cx, 3FFEh
        cmp cx, byte 0FFE0h
        jge short loc_A5FC3
        mov dword [byte ebp-0Ch], 0
        mov dword [byte ebp-08h], 80000000h
        mov word [byte ebp-04h], 3FFFh
        jmp near loc_A605A
loc_A5FC3:
        LD or, cx, cx
        js short loc_A5FCC
        mov cx, 0
loc_A5FCC:
        neg cx
        cmp cx, byte 8
        jle short loc_A5FD9
        mov cx, 8
loc_A5FD9:
        mov cx, word [nosplit cs:ecx*2+unk_A5EEA]
        push ecx
        mov eax, dword [byte ebp-014h]
        inc al
        and al, 2
        jne short loc_A5FF3
        cmp ah, 1
        je short loc_A5FF3
        jmp short loc_A6031
loc_A5FF3:
        push eax
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        mov ecx, dword [byte ebp-018h]
        mov ebx, 8
        LD sub, ebx, ecx
        lea ecx, [ecx+ecx*4]
        lea ecx, [nosplit ecx*2+unk_A5E90]
        call PolyEval
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-08h], edx
        mov word [byte ebp-04h], si
        pop eax
loc_A6031:
        cmp al, 0
        je short loc_A603C
        cmp ah, 1
        je short loc_A603C
        jmp short loc_A605A
loc_A603C:
        LD mov, eax, edi
        mov ecx, dword [byte ebp-018h]
        mov ebx, 8
        LD sub, ebx, ecx
        lea ecx, [ecx+ecx*4]
        LD add, ecx, ecx
        lea edx, [unk_A5E36]
        LD add, edx, ecx
        call PolyEvalOdd
loc_A605A:
        mov eax, dword [byte ebp-014h]
        inc al
        and al, 2
        je short loc_A606F
        mov eax, dword [byte ebp-0Ch]
        mov edx, dword [byte ebp-08h]
        mov si, word [byte ebp-04h]
        jmp short loc_A6078
loc_A606F:
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
loc_A6078:
        mov ecx, dword [byte ebp-014h]
        test cl, 4
        je short loc_A6085
        xor si, 8000h
loc_A6085:
        cmp ch, 1
        jne short loc_A60E2
        rol esi, 10h
        add cl, 2
        LD mov, bl, cl
        inc bl
        and bl, 2
        je short loc_A60A8
        and cl, 4
        mov ebx, dword [byte ebp-0Ch]
        mov ecx, dword [byte ebp-08h]
        mov si, word [byte ebp-04h]
        jmp short loc_A60B4
loc_A60A8:
        and cl, 4
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
loc_A60B4:
        je short loc_A60BC
        xor esi, 8000h
loc_A60BC:
        rol esi, 10h
        LD or, ebx, ebx
        jne short loc_A60DD
        LD or, ecx, ecx
        jne short loc_A60DD
        test esi, 7FFF0000h
        jne short loc_A60DD
        LD sub, eax, eax
        mov edx, 80000000h
        or si, 7FFFh
        jmp short loc_A60E2
loc_A60DD:
        call DivideMantissas
loc_A60E2:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        LD mov, esp, ebp
        pop ebx
        pop ecx
        pop edx
        pop edi
        pop ebp
        ret
EmuSin:
        push esi
        LD sub, esi, esi
        call SinCosCore
        pop esi
        ret
EmuCos:
        push esi
        mov esi, 2
        call SinCosCore
        pop esi
        ret
sub_A610A:
        push esi
        mov esi, 1
        call SinCosCore
        pop esi
        ret
        db 090h
sub_A6118:
        adc eax, 67CC487Bh
        ret
        db 0AAh,085h,0FFh,03Fh,0E7h,0D6h,08Bh,0EAh,0E3h,0C1h,095h,08Bh,0FFh,03Fh,06Fh,0A9h
        db 0B8h,08Dh,051h,0F0h,037h,098h,0FFh,03Fh,084h,064h,0DEh,0F9h,033h,0F3h,04h,0B5h
        db 0FFh,03Fh
EmuAtan:
        push ebp
        push edi
        push esi
        push edx
        push ecx
        push ebx
        LD mov, edi, eax
        LD sub, esi, esi
        mov cx, word [byte edi+08h]
        and byte [byte edi+09h], 7Fh
        cmp word [byte edi+08h], byte 0
        jne short loc_A6162
        cmp dword [byte edi+04h], byte 0
        jne short loc_A6162
        cmp dword [edi], byte 0
loc_A6162:
        je short loc_A61CA
        LD or, cx, cx
        jns short loc_A6183
        dec esi
        push dword 0BFFFh
        push dword 80000000h
        push byte 0
        LD mov, eax, edi
        LD mov, ebx, edi
        call AddExtRaw
        xor byte [byte ebx+09h], 80h
loc_A6183:
        mov bx, word [byte edi+08h]
        add bx, byte 4
        LD sub, ecx, ecx
        mov edx, dword [byte edi+04h]
        mov eax, dword [edi]
loc_A6192:
        cmp bx, 3FFFh
        jb short loc_A61A3
        LD add, eax, eax
        LD adc, edx, edx
        LD adc, ecx, ecx
        dec bx
        jmp short loc_A6192
loc_A61A3:
        LD or, edx, edx
        jne short loc_A61A9
        LD or, eax, eax
loc_A61A9:
        jne short loc_A61AF
        LD sub, ebx, ebx
        jmp short loc_A61BF
loc_A61AF:
        LD or, edx, edx
        js short loc_A61BB
        LD add, eax, eax
        LD adc, edx, edx
        dec bx
        jmp short loc_A61AF
loc_A61BB:
        sub bx, byte 4
loc_A61BF:
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], bx
        jmp short loc_A61CC
loc_A61CA:
        LD sub, ecx, ecx
loc_A61CC:
        push esi
        push ecx
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        push eax
        push edx
        push esi
        mov ecx, 0A6829A79h
        mov ebx, 1BF21F8Ch
        and esi, 0FFFFh
        or esi, 40030000h
        call AddMantissas
        LD mov, ebp, esp
        xchg eax, dword [byte ebp+08h]
        xchg edx, dword [byte ebp+04h]
        xchg esi, dword [byte ebp+00h]
        mov ecx, 0EC96F0D6h
        mov ebx, 9D7BFDBh
        and esi, 0FFFFh
        or esi, 3FFA0000h
        call MultiplyMantissas
        mov ecx, 0E6D5051Ah
        mov ebx, 0E536E187h
        and esi, 0FFFFh
        or esi, 40010000h
        call AddMantissas
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        rol esi, 10h
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        push eax
        push edx
        push esi
        xor esi, 8000h
        rol esi, 10h
        mov si, word [byte ebp+00h]
        rol esi, 10h
        mov ebx, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+04h]
        call AddMantissas
        xchg eax, dword [byte ebp-04h]
        xchg edx, dword [byte ebp-08h]
        xchg esi, dword [byte ebp-0Ch]
        rol esi, 10h
        mov si, word [byte ebp+00h]
        rol esi, 10h
        mov ebx, dword [byte ebp+08h]
        mov ecx, dword [byte ebp+04h]
        call AddMantissas
        rol esi, 10h
        mov si, word [byte ebp-0Ch]
        rol esi, 10h
        pop ecx
        pop ecx
        pop ebx
        call DivideMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        add esp, byte 0Ch
        pop ecx
        lea esi, [sub_A6118]
loc_A62BB:
        LD or, ecx, ecx
        je short loc_A62F3
        shr ecx, 1
        jae short loc_A62EE
        push ecx
        push esi
        mov ax, word [byte edi+08h]
        mov ecx, dword [byte edi+04h]
        mov ebx, dword [edi]
        shl eax, 10h
        mov ax, word [byte cs:esi+08h]
        mov edx, dword [byte cs:esi+04h]
        mov esi, dword [cs:esi]
        xchg esi, eax
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop esi
        pop ecx
loc_A62EE:
        lea esi, [byte esi+0Ah]
        jmp short loc_A62BB
loc_A62F3:
        pop esi
        add word [byte edi+08h], si
        LD mov, eax, edi
        push dword 0BFFFh
        push dword 80000000h
        push byte 0
        LD mov, ebx, edi
        call AddExtRaw
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        pop ebp
        ret
EmuExp2:
        push edi
        push esi
        push edx
        push ecx
        push ebx
        mov cx, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov ebx, dword [eax]
        LD or, ebx, ebx
        jne short loc_A635A
        LD or, edx, edx
        jne short loc_A634F
        LD add, cx, cx
        je near loc_A63DA
loc_A6333:
        mov word [byte eax+08h], 0FFFFh
        mov dword [byte eax+04h], 0
        mov dword [eax], 0
loc_A6346:
        or byte [byte eax+07h], 0C0h
        jmp near loc_A63DA
loc_A634F:
        cmp cx, 7FFFh
        je near loc_A63DA
loc_A635A:
        LD mov, edx, ecx
        and dh, 7Fh
        cmp dx, 7FFFh
        je short loc_A6346
        LD add, cx, cx
        jb short loc_A6346
        shr cx, 1
        je short loc_A6377
        mov edx, dword [byte eax+04h]
        LD add, edx, edx
        jae short loc_A6333
loc_A6377:
        mov edx, dword [byte eax+04h]
        LD sub, edi, edi
        push eax
        sub cx, 3FFFh
        sar cx, 1
        jb short loc_A638D
        shr edx, 1
        rcr ebx, 1
        rcr edi, 1
loc_A638D:
        add cx, 3FFFh
        mov word [byte eax+08h], cx
        LD mov, ecx, edx
        LD mov, eax, ebx
        LD mov, esi, edx
        stc
        rcr esi, 1
        inc edx
        je short loc_A63C0
        dec edx
loc_A63A3:
        div esi
        dec esi
        LD cmp, esi, eax
        jbe short loc_A63B5
        inc esi
        LD add, esi, eax
        rcr esi, 1
        LD mov, edx, ecx
        LD mov, eax, ebx
        jmp short loc_A63A3
loc_A63B5:
        inc esi
        LD mov, ecx, eax
        LD mov, eax, edi
        div esi
        LD add, esi, ecx
        jmp short loc_A63C9
loc_A63C0:
        LD cmp, eax, esi
        je short loc_A63D2
        xchg edx, eax
        LD mov, eax, edi
        div esi
loc_A63C9:
        LD sub, edx, edx
        stc
        rcr esi, 1
        rcr eax, 1
        LD adc, eax, edx
loc_A63D2:
        LD adc, edx, esi
        pop esi
        mov dword [esi], eax
        mov dword [byte esi+04h], edx
loc_A63DA:
        pop ebx
        pop ecx
        pop edx
        pop esi
        pop edi
        ret
sub_A63E0:
        push esi
        push ecx
        push eax
        LD mov, ecx, edx
        mov si, word [byte eax+08h]
        mov edx, dword [byte eax+04h]
        mov eax, dword [eax]
        call PolyEval
        pop ecx
        mov dword [ecx], eax
        mov dword [byte ecx+04h], edx
        mov word [byte ecx+08h], si
        pop ecx
        pop esi
        ret
PolyEval:
        push ebp
        push edi
        push ecx
        push ebx
        push esi
        push edx
        push eax
        LD mov, ebp, esp
        LD mov, edi, ecx
        mov eax, dword [cs:edi]
        mov edx, dword [byte cs:edi+04h]
        mov si, word [byte cs:edi+08h]
loc_A6417:
        rol esi, 10h
        mov si, word [byte ebp+08h]
        rol esi, 10h
        mov ebx, dword [byte ebp+00h]
        mov ecx, dword [byte ebp+04h]
        call MultiplyMantissas
        lea edi, [byte edi+0Ah]
        mov ebx, dword [cs:edi]
        mov ecx, dword [byte cs:edi+04h]
        rol esi, 10h
        mov si, word [byte cs:edi+08h]
        rol esi, 10h
        call AddMantissas
        dec dword [byte ebp+0Ch]
        jne short loc_A6417
        add esp, byte 10h
        pop ecx
        pop edi
        pop ebp
        ret
PolyEvalOdd:
        push edi
        push esi
        push ecx
        push ebx
        push edx
        LD mov, edi, eax
        mov eax, dword [edi]
        mov edx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        shl esi, 10h
        mov si, word [byte edi+08h]
        LD mov, ebx, eax
        LD mov, ecx, edx
        call MultiplyMantissas
        pop ecx
        pop ebx
        call PolyEval
        rol esi, 10h
        mov ebx, dword [edi]
        mov ecx, dword [byte edi+04h]
        mov si, word [byte edi+08h]
        rol esi, 10h
        call MultiplyMantissas
        mov dword [edi], eax
        mov dword [byte edi+04h], edx
        mov word [byte edi+08h], si
        pop ecx
        pop esi
        pop edi
        ret
__hook387:
        push ebx
        push ecx
        push esi
        push edi
        push es
        push ebp
        push edx
        mov ebp, eax
        mov ax, 1600h
        int 2Fh
        test al, al
        je short loc_A6500
        cmp al, 80h
        je short loc_A6500
        xor al, al
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        cmp ax, 666h
        jne short loc_A6500
        mov al, 22h
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        test ax, ax
        jne short loc_A6500
        mov dh, 1
        mov al, 1Eh
        xor ecx, ecx
        xor ebx, ebx
        mov byte [Hook387Saved], dh
        xor edx, edx
        mov ah, 0FAh
        int 2Fh
        mov eax, cs
        mov ebx, Hook387Save
        mov edx, eax
        mov ecx, ebx
        mov al, 20h
        shr ecx, 10h
        mov ah, 0FAh
        int 2Fh
        mov al, 1
        jmp short loc_A655A
loc_A6500:
        mov edx, dword [esp]
        test ebp, ebp
        jne short loc_A650C
        test dx, dx
        je short loc_A6558
loc_A650C:
        mov esi, str_RATIONALDOS4G
        mov eax, 0A00h
        push es
        int 31h
        sbb eax, eax
        pop es
        test eax, eax
        jne short loc_A6558
        mov eax, 7
        mov ebx, sub_A365C
        mov ecx, cs
        call _dos_setvect_
        mov es, word [esp]
        mov ah, byte [byte es:ebp+040h]
        mov byte [byte es:ebp+03Eh], 1
        or ah, 4
        mov byte [byte es:ebp+040h], ah
        mov eax, cr0
        or al, 4
        mov dl, 1
        mov cr0, eax
        mov ah, 30h
        int 21h
        mov byte [Hook387Flag], dl
loc_A6558:
        xor al, al
loc_A655A:
        add esp, byte 4
        pop ebp
        pop es
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
__unhook387:
        push ebx
        push ecx
        push es
        mov es, edx
        mov dl, byte [Hook387Saved]
        test dl, dl
        je short loc_A6593
        mov eax, cs
        mov edx, eax
        xor ecx, ecx
        xor ebx, ebx
        mov al, 21h
        mov ah, 0FAh
        int 2Fh
        mov al, 1Fh
        xor edx, edx
        xor ecx, ecx
        xor ebx, ebx
        mov ah, 0FAh
        int 2Fh
        mov al, 1
        pop es
        pop ecx
        pop ebx
        ret
loc_A6593:
        cmp byte [Hook387Flag], 0
        je short loc_A65B7
        mov bl, byte [byte es:eax+040h]
        mov byte [byte es:eax+03Eh], dl
        and bl, 0FBh
        mov byte [byte es:eax+040h], bl
        mov eax, cr0
        and al, 0FBh
        mov cr0, eax
        mov ah, 30h
        int 21h
loc_A65B7:
        xor al, al
        pop es
        pop ecx
        pop ebx
        ret
nullsub_3:
        ret
__init_80x87:
        push ax
        wait
        fninit
        fld1
        fldz
        fdivp
        fld st0
        fchs
        fcompp
        fnstsw ax
        mov al, 2
        sahf
        je short loc_A65D8
        mov al, 3
loc_A65D8:
        wait
        fninit
        fldcw word [esp]
        xchg ax, word [esp]
        pop ax
        ret
        db 00h,00h,00h
