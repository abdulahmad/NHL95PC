; Hardware access for the Sound Blaster.
bits 32
%include "hockey.inc"
section s_A6BE1 progbits alloc exec nowrite align=1
extern __set_errno_, CharClassTable, SbStreamChannels
extern SbDmaRunning, SbMixPaused, SbSignTable, NotePitchTable
extern SbMixSrcPos, SbMixStep, SbMixSrcEnd, SbMixCount, SbMixReadPos, SbDmaHalfSize
extern SbDmaBuffer, SbStreamTable, SbCardClose, SbCardOpen, SbDmaCount, tolower_, SbMixBuffer
extern MixVolumeTable
global StrToLong, strtol_, strtoul_, DigitValue, SbStreamCheck, SbMixRateDiv, SbMixerOpen, SbMixerClose
global SbStreamStopAll, SbStreamPlayNote, SbStreamRelease, SbStreamStop, SbStreamSetVolume, SbStreamSetBend, SbStreamSetRate, SbStreamSetSample
global SbStreamStart, SbStreamIdle, SbStreamGetVolume, SbStreamApplyBend, SbMixAdd8Vol, SbMixAdd8, SbMixChannels, SbDmaHalfReady
global SbDmaStart, SbDmaStop, SbMixPause, SbConvertMix, unk_A9C80, unk_A9C81, unk_A9C83, unk_A9C85
global unk_A9C86, unk_A9C88, unk_A9C89, unk_A9C8A, unk_A9C8E, unk_A9C8F, unk_A9C90, unk_A9C91
global unk_A9C92, unk_A9C96, unk_A9C98
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
        je short .1
        mov dword [edx], eax
.1:
        mov edx, ebp
.2:
        mov al, byte [edx]
        inc al
        and eax, 0FFh
        test byte [dword eax+CharClassTable], 2
        je short .3
        inc edx
        jmp short .2
.3:
        mov al, byte [edx]
        mov byte [byte esp+0Ch], al
        cmp al, 2Bh
        je short .4
        cmp al, 2Dh
        jne short .5
.4:
        inc edx
.5:
        test esi, esi
        jne short .9
        cmp byte [edx], 30h
        jne short .7
        mov al, byte [byte edx+01h]
        cmp al, 78h
        je short .6
        cmp al, 58h
        jne short .7
.6:
        mov esi, 10h
        jmp short .9
.7:
        cmp byte [edx], 30h
        jne short .8
        mov esi, 8
        jmp short .9
.8:
        mov esi, 0Ah
.9:
        cmp esi, byte 2
        jl short .10
        cmp esi, byte 24h
        jle short .11
.10:
        mov eax, 0Dh
        call __set_errno_
        xor eax, eax
        jmp near .25
.11:
        cmp esi, byte 10h
        jne short .13
        cmp byte [edx], 30h
        jne short .13
        mov cl, byte [byte edx+01h]
        cmp cl, 78h
        je short .12
        cmp cl, 58h
        jne short .13
.12:
        add edx, byte 2
.13:
        mov dword [esp], edx
        xor al, al
        xor ebx, ebx
        mov byte [byte esp+08h], al
.14:
        xor eax, eax
        mov al, byte [edx]
        call DigitValue
        cmp eax, esi
        jge short .16
        mov ecx, ebx
        imul ebx, esi
        add ebx, eax
        cmp ebx, ecx
        jae short .15
        mov byte [byte esp+08h], 1
.15:
        inc edx
        jmp short .14
.16:
        cmp edx, dword [esp]
        jne short .17
        mov edx, ebp
.17:
        test edi, edi
        je short .18
        mov dword [edi], edx
.18:
        cmp dword [byte esp+04h], byte 1
        jne short .20
        cmp ebx, 80000000h
        jb short .20
        jne short .19
        cmp byte [byte esp+0Ch], 2Dh
        je short .20
.19:
        mov byte [byte esp+08h], 1
.20:
        cmp byte [byte esp+08h], 0
        je short .23
        mov eax, 0Eh
        mov edi, dword [byte esp+04h]
        call __set_errno_
        test edi, edi
        jne short .21
        mov eax, 0FFFFFFFFh
        jmp short .25
.21:
        cmp byte [byte esp+0Ch], 2Dh
        jne short .22
        mov eax, 80000000h
        jmp short .25
.22:
        mov eax, 7FFFFFFFh
        jmp short .25
.23:
        cmp byte [byte esp+0Ch], 2Dh
        jne short .24
        neg ebx
.24:
        mov eax, ebx
.25:
        add esp, byte 10h
        pop ebp
        pop edi
        pop esi
        ret
strtol_:
        push ecx
        xor ecx, ecx
        call StrToLong
        pop ecx
        ret
strtoul_:
        push ecx
        mov ecx, 1
        jmp short strtol_+03h
DigitValue:
        push edx
        mov dl, al
        cmp al, 30h
        jb short .1
        cmp al, 39h
        ja short .1
        xor eax, eax
        mov al, dl
        sub eax, byte 30h
        pop edx
        ret
.1:
        xor eax, eax
        mov al, dl
        call tolower_
        mov dl, al
        cmp al, 61h
        jb short .2
        cmp al, 69h
        ja short .2
        and eax, 0FFh
        sub eax, byte 57h
        pop edx
        ret
.2:
        cmp dl, 6Ah
        jb short .4
        cmp dl, 72h
        ja short .4
.3:
        xor eax, eax
        mov al, dl
        sub eax, byte 57h
        pop edx
        ret
.4:
        cmp dl, 73h
        jb short .5
        cmp dl, 7Ah
        jbe short .3
.5:
        mov eax, 25h
        pop edx
        ret
        db 00h,00h,00h
SbStreamCheck:
        cmp esi, byte 4
        jb short .1
        stc
        ret
.1:
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
.1:
        mov ebx, dword [nosplit esi*4+SbStreamTable]
        mov byte [byte ebx+01h], al
        inc esi
        loop .1
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        movzx eax, word [byte ebp+08h]
        movzx edx, word [byte ebp+0Ah]
        call SbDmaStart
        add esp, byte 0Ch
        cmp eax, byte 0FFFFFFFFh
        je short .2
        mov eax, 44h
        pop esi
        leave
        ret
.2:
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
.1:
        mov ebx, dword [nosplit esi*4+SbStreamTable]
        mov byte [ebx], al
        inc esi
        loop .1
        pop esi
        ret
SbStreamPlayNote:
        push ebp
        LD mov, ebp, esp
        push esi
        mov eax, dword [byte ebp+010h]
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short .3
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov bl, byte [byte ebp+0Ch]
        mov byte [byte esi+02h], bl
        cmp bl, 0FFh
        je short .1
        mov eax, dword [nosplit ebx*4+NotePitchTable]
        mul dword [byte esi+020h]
        and eax, 0FFFF0000h
        and edx, 0FFFFh
        mov dword [byte esi+034h], edx
        mov dword [byte esi+038h], eax
        mov dword [byte esi+024h], edx
        mov dword [byte esi+028h], eax
.1:
        mov eax, dword [byte esi+0Ch]
        mov dword [byte esi+018h], eax
        mov eax, dword [byte esi+010h]
        cmp dword [byte esi+04h], byte 0
        jne short .2
        mov eax, dword [byte esi+014h]
.2:
        mov dword [byte esi+01Ch], eax
        mov eax, dword [byte esi+08h]
        mov dword [byte esi+02Ch], eax
        LD xor, eax, eax
        mov dword [byte esi+030h], eax
        mov al, 1
        mov byte [esi], al
.3:
        pop esi
        leave
        ret
SbStreamRelease:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short .1
        cmp esi, byte 1
        jle short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov eax, dword [byte esi+010h]
        mov dword [byte esi+01Ch], eax
        mov al, 0
        mov byte [esi], al
.1:
        pop esi
        leave
        ret
SbStreamStop:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short .1
        cmp esi, byte 1
        jle short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov al, 0
        mov byte [esi], al
.1:
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
        jb short .2
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov al, byte [byte ebp+0Ch]
        cmp al, byte [byte esi+01h]
        je short .2
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
.1:
        LD add, eax, esi
        mov byte [edi], ah
        LD add, ebx, esi
        mov byte [dword edi+080h], bh
        inc edi
        loop .1
.2:
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
        jb short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
        movsx eax, word [byte ebp+0Ch]
        mov word [byte esi+03Ch], ax
.1:
        pop esi
        leave
        ret
SbStreamSetRate:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short .4
        mov esi, dword [nosplit esi*4+SbStreamTable]
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
        je short .1
        ja short .2
        mov eax, 40h
        jmp short .3
.1:
        mov eax, 80h
        jmp short .3
.2:
        mov eax, 100h
.3:
        mov dword [byte esi+040h], eax
.4:
        pop esi
        leave
        ret
SbStreamSetSample:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        call SbStreamCheck
        jb short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
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
.1:
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
        jb near .4
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov eax, dword [byte ebp+01Ch]
        cmp eax, byte 0
        jne short .1
        push dword [byte ebp+08h]
        call SbStreamRelease
        pop eax
        popf
        pop edi
        pop esi
        leave
        ret
.1:
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
        je short .3
        cmp dword [byte ebp+014h], byte 0
        je short .3
        mov edi, dword [byte ebp+0Ch]
        LD xor, edx, edx
        LD xor, ecx, ecx
        LD xor, eax, eax
.2:
        mov al, byte [edi]
        mov bx, word [nosplit eax*2+MixVolumeTable]
        inc edi
        LD add, dl, bl
        LD add, dl, bh
        inc ecx
        cmp ecx, dword [byte ebp+014h]
        jb short .2
        mov byte [byte esi+03Fh], dl
.3:
        push byte 7Fh
        push dword 0FFh
        push dword [byte ebp+08h]
        call SbStreamPlayNote
        add esp, byte 0Ch
.4:
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
        jb short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov al, byte [esi]
        cmp al, 0
        jne short .2
.1:
        mov eax, 1
        pop esi
        leave
        ret
.2:
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
        jb short .1
        mov esi, dword [nosplit esi*4+SbStreamTable]
        movzx eax, byte [byte esi+01h]
        pop esi
        leave
        ret
.1:
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
        jb short .4
        mov esi, dword [nosplit esi*4+SbStreamTable]
        mov edi, dword [byte esi+028h]
        or edi, dword [byte esi+024h]
        ror edi, 10h
        add edi, dword [byte ebp+010h]
        cmp dword [byte ebp+014h], byte 0
        je short .3
        LD xor, ebx, ebx
        mov bl, byte [byte esi+02h]
        add bl, byte [byte ebp+018h]
        mov eax, dword [nosplit ebx*4+NotePitchTable]
        mul dword [byte esi+020h]
        shl edx, 10h
        shr eax, 10h
        LD or, eax, edx
        LD sub, eax, edi
        mov edx, dword [byte ebp+014h]
        cmp edx, byte 0
        jg short .1
        jl short .2
.1:
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD add, edi, eax
        jmp short .3
.2:
        neg edx
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD sub, edi, eax
.3:
        LD mov, ecx, edi
        shl edi, 10h
        mov dword [byte esi+038h], edi
        shr ecx, 10h
        mov dword [byte esi+034h], ecx
.4:
        pop edi
        pop esi
        leave
        ret
SbMixAdd8Vol:
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+02h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+04h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+06h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+08h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+010h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+012h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+014h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+016h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+018h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+020h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+022h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+024h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+026h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+028h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+02Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+02Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+02Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+030h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+032h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+034h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+036h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+038h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+03Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+03Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+03Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+040h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+042h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+044h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+046h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+048h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+04Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+04Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+04Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+050h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+052h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+054h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+056h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+058h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+05Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+05Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+05Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+060h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+062h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+064h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+066h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+068h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+06Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+06Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+06Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+070h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+072h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+074h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+076h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+078h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+07Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+07Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+07Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+080h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+082h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+084h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+086h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+088h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+08Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+08Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+08Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+090h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+092h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+094h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+096h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+098h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+09Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+09Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+09Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0A0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0A2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0A4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0A6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0A8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0AAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0ACh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0AEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0B0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0B2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0B4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0B6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0B8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0BAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0BCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0BEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0C0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0C2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0C4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0C6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0C8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0CAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0CCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0CEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0D0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0D2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0D4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0D6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0D8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0DAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0DCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0DEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0E0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0E2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0E4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0E6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0E8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0EAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0ECh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0EEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0F0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0F2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0F4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0F6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0F8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0FAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0FCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0FEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0100h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0102h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0104h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0106h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0108h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+010Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+010Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+010Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0110h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0112h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0114h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0116h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0118h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+011Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+011Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+011Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0120h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0122h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0124h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0126h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0128h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+012Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+012Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+012Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0130h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0132h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0134h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0136h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0138h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+013Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+013Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+013Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0140h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0142h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0144h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0146h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0148h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+014Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+014Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+014Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0150h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0152h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0154h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0156h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0158h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+015Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+015Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+015Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0160h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0162h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0164h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0166h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0168h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+016Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+016Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+016Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0170h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0172h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0174h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0176h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0178h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+017Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+017Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+017Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0180h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0182h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0184h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0186h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0188h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+018Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+018Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+018Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0190h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0192h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0194h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0196h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+0198h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+019Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+019Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+019Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01A0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01A2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01A4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01A6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01A8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01AAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01ACh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01AEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01B0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01B2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01B4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01B6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01B8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01BAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01BCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01BEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01C0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01C2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01C4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01C6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01C8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01CAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01CCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01CEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01D0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01D2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01D4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01D6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01D8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01DAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01DCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01DEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01E0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01E2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01E4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01E6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01E8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01EAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01ECh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01EEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01F0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01F2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01F4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01F6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01F8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01FAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01FCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        xlatb
        cbw
        add word [SbMixBuffer+01FEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        ret
SbMixAdd8:
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+02h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+04h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+06h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+08h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+010h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+012h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+014h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+016h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+018h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+020h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+022h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+024h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+026h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+028h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+02Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+02Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+02Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+030h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+032h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+034h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+036h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+038h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+03Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+03Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+03Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+040h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+042h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+044h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+046h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+048h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+04Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+04Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+04Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+050h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+052h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+054h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+056h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+058h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+05Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+05Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+05Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+060h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+062h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+064h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+066h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+068h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+06Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+06Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+06Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+070h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+072h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+074h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+076h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+078h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+07Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+07Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+07Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+080h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+082h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+084h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+086h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+088h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+08Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+08Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+08Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+090h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+092h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+094h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+096h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+098h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+09Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+09Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+09Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0A0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0A2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0A4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0A6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0A8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0AAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0ACh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0AEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0B0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0B2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0B4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0B6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0B8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0BAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0BCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0BEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0C0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0C2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0C4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0C6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0C8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0CAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0CCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0CEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0D0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0D2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0D4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0D6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0D8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0DAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0DCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0DEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0E0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0E2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0E4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0E6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0E8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0EAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0ECh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0EEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0F0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0F2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0F4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0F6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0F8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0FAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0FCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0FEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0100h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0102h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0104h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0106h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0108h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+010Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+010Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+010Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0110h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0112h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0114h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0116h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0118h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+011Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+011Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+011Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0120h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0122h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0124h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0126h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0128h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+012Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+012Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+012Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0130h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0132h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0134h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0136h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0138h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+013Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+013Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+013Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0140h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0142h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0144h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0146h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0148h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+014Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+014Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+014Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0150h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0152h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0154h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0156h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0158h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+015Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+015Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+015Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0160h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0162h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0164h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0166h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0168h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+016Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+016Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+016Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0170h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0172h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0174h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0176h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0178h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+017Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+017Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+017Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0180h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0182h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0184h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0186h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0188h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+018Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+018Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+018Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0190h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0192h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0194h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0196h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+0198h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+019Ah], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+019Ch], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+019Eh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01A0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01A2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01A4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01A6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01A8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01AAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01ACh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01AEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01B0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01B2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01B4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01B6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01B8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01BAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01BCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01BEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01C0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01C2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01C4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01C6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01C8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01CAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01CCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01CEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01D0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01D2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01D4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01D6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01D8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01DAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01DCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01DEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01E0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01E2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01E4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01E6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01E8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01EAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01ECh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01EEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01F0h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01F2h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01F4h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01F6h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01F8h], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01FAh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01FCh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        mov al, byte [esi]
        cbw
        add word [SbMixBuffer+01FEh], ax
        LD add, ecx, edx
        LD adc, esi, edi
        ret
SbMixChannels:
        push esi
        push edi
        mov ecx, 80h
        LD xor, eax, eax
        mov edi, SbMixBuffer
.1:
        mov dword [edi], eax
        add edi, byte 4
        loop .1
        cmp byte [SbStreamChannels], 0
        je near .19
        cmp byte [SbStreamChannels+03h], 0
        jne near .9
        mov edx, dword [SbStreamChannels+034h]
        mov eax, dword [SbStreamChannels+038h]
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
        add eax, dword [SbStreamChannels+030h]
        adc edx, dword [SbStreamChannels+02Ch]
        cmp edx, dword [SbStreamChannels+01Ch]
        jae short .4
        mov eax, dword [SbStreamChannels+02Ch]
        LD mov, esi, eax
        mov dword [SbMixSrcPos], esi
        mov ecx, dword [SbStreamChannels+030h]
        mov edi, dword [SbStreamChannels+034h]
        mov edx, dword [SbStreamChannels+038h]
        cmp byte [SbStreamChannels+01h], 7Fh
        jb short .2
        call SbMixAdd8
        jmp short .3
.2:
        mov ebx, SbStreamChannels+044h
        call SbMixAdd8Vol
.3:
        mov dword [SbStreamChannels+030h], ecx
        sub esi, dword [SbMixSrcPos]
        add dword [SbStreamChannels+02Ch], esi
        jmp near .19
.4:
        LD xor, eax, eax
        mov dword [SbMixCount], eax
.5:
        mov eax, dword [SbStreamChannels+02Ch]
        mov ebx, dword [SbStreamChannels+01Ch]
        LD sub, ebx, eax
        mov dword [SbMixStep], ebx
        LD mov, esi, eax
        mov dword [SbMixSrcPos], eax
        add eax, dword [SbMixStep]
        mov dword [SbMixSrcEnd], eax
        mov ecx, dword [SbStreamChannels+030h]
        mov edi, dword [SbStreamChannels+034h]
        mov edx, dword [SbStreamChannels+038h]
        LD xor, eax, eax
.6:
        mov al, byte [esi]
        mov ebx, SbStreamChannels+044h
        xlatb
        cbw
        mov ebx, dword [SbMixCount]
        add word [nosplit ebx*2+SbMixBuffer], ax
        inc dword [SbMixCount]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [SbMixSrcEnd]
        jae short .7
        cmp dword [SbMixCount], 100h
        jne short .6
        jmp near .3
.7:
        mov al, byte [SbStreamChannels]
        cmp al, 1
        jne short .8
        mov eax, dword [SbStreamChannels+04h]
        LD or, eax, eax
        je short .8
        mov eax, dword [SbStreamChannels+018h]
        mov dword [SbStreamChannels+030h], ecx
        mov dword [SbStreamChannels+02Ch], eax
        cmp dword [SbMixCount], 100h
        jne near .5
        jmp near .19
.8:
        mov al, 0
        mov byte [SbStreamChannels], al
        jmp near .19
.9:
        mov esi, dword [SbStreamChannels+02Ch]
        mov ecx, dword [SbStreamChannels+01Ch]
        LD sub, ecx, esi
        cmp ecx, dword [SbStreamChannels+040h]
        jbe short .10
        mov ecx, dword [SbStreamChannels+040h]
.10:
        LD add, ecx, esi
        mov dword [SbMixCount], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [SbStreamChannels+03Eh]
.11:
        mov eax, dword [SbStreamChannels+020h]
        cmp eax, 10000h
        je short .13
        ja near .14
.12:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+044h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+044h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .12
        jmp short .15
.13:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+044h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+044h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .13
        jmp short .15
.14:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+044h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .14
.15:
        cmp esi, dword [SbStreamChannels+01Ch]
        je short .16
        mov byte [SbStreamChannels+03Eh], dl
        mov dword [SbStreamChannels+02Ch], esi
        jmp short .19
.16:
        mov al, byte [SbStreamChannels]
        cmp al, 1
        jne short .18
        mov eax, dword [SbStreamChannels+04h]
        LD or, eax, eax
        je short .18
        mov dl, byte [SbStreamChannels+03Fh]
        mov byte [SbStreamChannels+03Eh], dl
        mov eax, dword [SbStreamChannels+02Ch]
        add eax, dword [SbStreamChannels+040h]
        LD sub, eax, esi
        LD or, eax, eax
        je short .17
        mov esi, dword [SbStreamChannels+018h]
        LD add, eax, esi
        mov dword [SbMixCount], eax
        jmp near .11
.17:
        mov eax, dword [SbStreamChannels+018h]
        mov dword [SbStreamChannels+02Ch], eax
        jmp short .19
.18:
        mov al, 0
        mov byte [SbStreamChannels], al
.19:
        cmp byte [SbStreamChannels+0144h], 0
        je near .37
        cmp byte [SbStreamChannels+0147h], 0
        jne near .27
        mov edx, dword [SbStreamChannels+0178h]
        mov eax, dword [SbStreamChannels+017Ch]
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
        add eax, dword [SbStreamChannels+0174h]
        adc edx, dword [SbStreamChannels+0170h]
        cmp edx, dword [SbStreamChannels+0160h]
        jae short .22
        mov eax, dword [SbStreamChannels+0170h]
        LD mov, esi, eax
        mov dword [SbMixSrcPos], esi
        mov ecx, dword [SbStreamChannels+0174h]
        mov edi, dword [SbStreamChannels+0178h]
        mov edx, dword [SbStreamChannels+017Ch]
        cmp byte [SbStreamChannels+0145h], 7Fh
        jb short .20
        call SbMixAdd8
        jmp short .21
.20:
        mov ebx, SbStreamChannels+0188h
        call SbMixAdd8Vol
.21:
        mov dword [SbStreamChannels+0174h], ecx
        sub esi, dword [SbMixSrcPos]
        add dword [SbStreamChannels+0170h], esi
        jmp near .37
.22:
        LD xor, eax, eax
        mov dword [SbMixCount], eax
.23:
        mov eax, dword [SbStreamChannels+0170h]
        mov ebx, dword [SbStreamChannels+0160h]
        LD sub, ebx, eax
        mov dword [SbMixStep], ebx
        LD mov, esi, eax
        mov dword [SbMixSrcPos], eax
        add eax, dword [SbMixStep]
        mov dword [SbMixSrcEnd], eax
        mov ecx, dword [SbStreamChannels+0174h]
        mov edi, dword [SbStreamChannels+0178h]
        mov edx, dword [SbStreamChannels+017Ch]
        LD xor, eax, eax
.24:
        mov al, byte [esi]
        mov ebx, SbStreamChannels+0188h
        xlatb
        cbw
        mov ebx, dword [SbMixCount]
        add word [nosplit ebx*2+SbMixBuffer], ax
        inc dword [SbMixCount]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [SbMixSrcEnd]
        jae short .25
        cmp dword [SbMixCount], 100h
        jne short .24
        jmp near .21
.25:
        mov al, byte [SbStreamChannels+0144h]
        cmp al, 1
        jne short .26
        mov eax, dword [SbStreamChannels+0148h]
        LD or, eax, eax
        je short .26
        mov eax, dword [SbStreamChannels+015Ch]
        mov dword [SbStreamChannels+0174h], ecx
        mov dword [SbStreamChannels+0170h], eax
        cmp dword [SbMixCount], 100h
        jne near .23
        jmp near .37
.26:
        mov al, 0
        mov byte [SbStreamChannels+0144h], al
        jmp near .37
.27:
        mov esi, dword [SbStreamChannels+0170h]
        mov ecx, dword [SbStreamChannels+0160h]
        LD sub, ecx, esi
        cmp ecx, dword [SbStreamChannels+0184h]
        jbe short .28
        mov ecx, dword [SbStreamChannels+0184h]
.28:
        LD add, ecx, esi
        mov dword [SbMixCount], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [SbStreamChannels+0182h]
.29:
        mov eax, dword [SbStreamChannels+0164h]
        cmp eax, 10000h
        je short .31
        ja near .32
.30:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0188h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+0188h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .30
        jmp short .33
.31:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0188h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+0188h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .31
        jmp short .33
.32:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0188h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .32
.33:
        cmp esi, dword [SbStreamChannels+0160h]
        je short .34
        mov byte [SbStreamChannels+0182h], dl
        mov dword [SbStreamChannels+0170h], esi
        jmp short .37
.34:
        mov al, byte [SbStreamChannels+0144h]
        cmp al, 1
        jne short .36
        mov eax, dword [SbStreamChannels+0148h]
        LD or, eax, eax
        je short .36
        mov dl, byte [SbStreamChannels+0183h]
        mov byte [SbStreamChannels+0182h], dl
        mov eax, dword [SbStreamChannels+0170h]
        add eax, dword [SbStreamChannels+0184h]
        LD sub, eax, esi
        LD or, eax, eax
        je short .35
        mov esi, dword [SbStreamChannels+015Ch]
        LD add, eax, esi
        mov dword [SbMixCount], eax
        jmp near .29
.35:
        mov eax, dword [SbStreamChannels+015Ch]
        mov dword [SbStreamChannels+0170h], eax
        jmp short .37
.36:
        mov al, 0
        mov byte [SbStreamChannels+0144h], al
.37:
        cmp byte [SbStreamChannels+0288h], 0
        je near .55
        cmp byte [SbStreamChannels+028Bh], 0
        jne near .45
        mov edx, dword [SbStreamChannels+02BCh]
        mov eax, dword [SbStreamChannels+02C0h]
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
        add eax, dword [SbStreamChannels+02B8h]
        adc edx, dword [SbStreamChannels+02B4h]
        cmp edx, dword [SbStreamChannels+02A4h]
        jae short .40
        mov eax, dword [SbStreamChannels+02B4h]
        LD mov, esi, eax
        mov dword [SbMixSrcPos], esi
        mov ecx, dword [SbStreamChannels+02B8h]
        mov edi, dword [SbStreamChannels+02BCh]
        mov edx, dword [SbStreamChannels+02C0h]
        cmp byte [SbStreamChannels+0289h], 7Fh
        jb short .38
        call SbMixAdd8
        jmp short .39
.38:
        mov ebx, SbStreamChannels+02CCh
        call SbMixAdd8Vol
.39:
        mov dword [SbStreamChannels+02B8h], ecx
        sub esi, dword [SbMixSrcPos]
        add dword [SbStreamChannels+02B4h], esi
        jmp near .55
.40:
        LD xor, eax, eax
        mov dword [SbMixCount], eax
.41:
        mov eax, dword [SbStreamChannels+02B4h]
        mov ebx, dword [SbStreamChannels+02A4h]
        LD sub, ebx, eax
        mov dword [SbMixStep], ebx
        LD mov, esi, eax
        mov dword [SbMixSrcPos], eax
        add eax, dword [SbMixStep]
        mov dword [SbMixSrcEnd], eax
        mov ecx, dword [SbStreamChannels+02B8h]
        mov edi, dword [SbStreamChannels+02BCh]
        mov edx, dword [SbStreamChannels+02C0h]
        LD xor, eax, eax
.42:
        mov al, byte [esi]
        mov ebx, SbStreamChannels+02CCh
        xlatb
        cbw
        mov ebx, dword [SbMixCount]
        add word [nosplit ebx*2+SbMixBuffer], ax
        inc dword [SbMixCount]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [SbMixSrcEnd]
        jae short .43
        cmp dword [SbMixCount], 100h
        jne short .42
        jmp near .39
.43:
        mov al, byte [SbStreamChannels+0288h]
        cmp al, 1
        jne short .44
        mov eax, dword [SbStreamChannels+028Ch]
        LD or, eax, eax
        je short .44
        mov eax, dword [SbStreamChannels+02A0h]
        mov dword [SbStreamChannels+02B8h], ecx
        mov dword [SbStreamChannels+02B4h], eax
        cmp dword [SbMixCount], 100h
        jne near .41
        jmp near .55
.44:
        mov al, 0
        mov byte [SbStreamChannels+0288h], al
        jmp near .55
.45:
        mov esi, dword [SbStreamChannels+02B4h]
        mov ecx, dword [SbStreamChannels+02A4h]
        LD sub, ecx, esi
        cmp ecx, dword [SbStreamChannels+02C8h]
        jbe short .46
        mov ecx, dword [SbStreamChannels+02C8h]
.46:
        LD add, ecx, esi
        mov dword [SbMixCount], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [SbStreamChannels+02C6h]
.47:
        mov eax, dword [SbStreamChannels+02A8h]
        cmp eax, 10000h
        je short .49
        ja near .50
.48:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+02CCh]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+02CCh]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .48
        jmp short .51
.49:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+02CCh]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+02CCh]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .49
        jmp short .51
.50:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+02CCh]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .50
.51:
        cmp esi, dword [SbStreamChannels+02A4h]
        je short .52
        mov byte [SbStreamChannels+02C6h], dl
        mov dword [SbStreamChannels+02B4h], esi
        jmp short .55
.52:
        mov al, byte [SbStreamChannels+0288h]
        cmp al, 1
        jne short .54
        mov eax, dword [SbStreamChannels+028Ch]
        LD or, eax, eax
        je short .54
        mov dl, byte [SbStreamChannels+02C7h]
        mov byte [SbStreamChannels+02C6h], dl
        mov eax, dword [SbStreamChannels+02B4h]
        add eax, dword [SbStreamChannels+02C8h]
        LD sub, eax, esi
        LD or, eax, eax
        je short .53
        mov esi, dword [SbStreamChannels+02A0h]
        LD add, eax, esi
        mov dword [SbMixCount], eax
        jmp near .47
.53:
        mov eax, dword [SbStreamChannels+02A0h]
        mov dword [SbStreamChannels+02B4h], eax
        jmp short .55
.54:
        mov al, 0
        mov byte [SbStreamChannels+0288h], al
.55:
        cmp byte [SbStreamChannels+03CCh], 0
        je near .73
        cmp byte [SbStreamChannels+03CFh], 0
        jne near .63
        mov edx, dword [SbStreamChannels+0400h]
        mov eax, dword [SbStreamChannels+0404h]
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
        add eax, dword [SbStreamChannels+03FCh]
        adc edx, dword [SbStreamChannels+03F8h]
        cmp edx, dword [SbStreamChannels+03E8h]
        jae short .58
        mov eax, dword [SbStreamChannels+03F8h]
        LD mov, esi, eax
        mov dword [SbMixSrcPos], esi
        mov ecx, dword [SbStreamChannels+03FCh]
        mov edi, dword [SbStreamChannels+0400h]
        mov edx, dword [SbStreamChannels+0404h]
        cmp byte [SbStreamChannels+03CDh], 7Fh
        jb short .56
        call SbMixAdd8
        jmp short .57
.56:
        mov ebx, SbStreamChannels+0410h
        call SbMixAdd8Vol
.57:
        mov dword [SbStreamChannels+03FCh], ecx
        sub esi, dword [SbMixSrcPos]
        add dword [SbStreamChannels+03F8h], esi
        jmp near .73
.58:
        LD xor, eax, eax
        mov dword [SbMixCount], eax
.59:
        mov eax, dword [SbStreamChannels+03F8h]
        mov ebx, dword [SbStreamChannels+03E8h]
        LD sub, ebx, eax
        mov dword [SbMixStep], ebx
        LD mov, esi, eax
        mov dword [SbMixSrcPos], eax
        add eax, dword [SbMixStep]
        mov dword [SbMixSrcEnd], eax
        mov ecx, dword [SbStreamChannels+03FCh]
        mov edi, dword [SbStreamChannels+0400h]
        mov edx, dword [SbStreamChannels+0404h]
        LD xor, eax, eax
.60:
        mov al, byte [esi]
        mov ebx, SbStreamChannels+0410h
        xlatb
        cbw
        mov ebx, dword [SbMixCount]
        add word [nosplit ebx*2+SbMixBuffer], ax
        inc dword [SbMixCount]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [SbMixSrcEnd]
        jae short .61
        cmp dword [SbMixCount], 100h
        jne short .60
        jmp near .57
.61:
        mov al, byte [SbStreamChannels+03CCh]
        cmp al, 1
        jne short .62
        mov eax, dword [SbStreamChannels+03D0h]
        LD or, eax, eax
        je short .62
        mov eax, dword [SbStreamChannels+03E4h]
        mov dword [SbStreamChannels+03FCh], ecx
        mov dword [SbStreamChannels+03F8h], eax
        cmp dword [SbMixCount], 100h
        jne near .59
        jmp near .73
.62:
        mov al, 0
        mov byte [SbStreamChannels+03CCh], al
        jmp near .73
.63:
        mov esi, dword [SbStreamChannels+03F8h]
        mov ecx, dword [SbStreamChannels+03E8h]
        LD sub, ecx, esi
        cmp ecx, dword [SbStreamChannels+040Ch]
        jbe short .64
        mov ecx, dword [SbStreamChannels+040Ch]
.64:
        LD add, ecx, esi
        mov dword [SbMixCount], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [SbStreamChannels+040Ah]
.65:
        mov eax, dword [SbStreamChannels+03ECh]
        cmp eax, 10000h
        je short .67
        ja near .68
.66:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0410h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+0410h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .66
        jmp short .69
.67:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0410h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        movsx ax, byte [dword edx+SbStreamChannels+0410h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .67
        jmp short .69
.68:
        LD xor, ebx, ebx
        mov bl, byte [esi]
        mov bx, word [nosplit ebx*2+MixVolumeTable]
        LD add, dl, bl
        movsx ax, byte [dword edx+SbStreamChannels+0410h]
        add word [nosplit ecx*2+SbMixBuffer], ax
        inc ecx
        LD add, dl, bh
        inc esi
        cmp esi, dword [SbMixCount]
        jb short .68
.69:
        cmp esi, dword [SbStreamChannels+03E8h]
        je short .70
        mov byte [SbStreamChannels+040Ah], dl
        mov dword [SbStreamChannels+03F8h], esi
        jmp short .73
.70:
        mov al, byte [SbStreamChannels+03CCh]
        cmp al, 1
        jne short .72
        mov eax, dword [SbStreamChannels+03D0h]
        LD or, eax, eax
        je short .72
        mov dl, byte [SbStreamChannels+040Bh]
        mov byte [SbStreamChannels+040Ah], dl
        mov eax, dword [SbStreamChannels+03F8h]
        add eax, dword [SbStreamChannels+040Ch]
        LD sub, eax, esi
        LD or, eax, eax
        je short .71
        mov esi, dword [SbStreamChannels+03E4h]
        LD add, eax, esi
        mov dword [SbMixCount], eax
        jmp near .65
.71:
        mov eax, dword [SbStreamChannels+03E4h]
        mov dword [SbStreamChannels+03F8h], eax
        jmp short .73
.72:
        mov al, 0
        mov byte [SbStreamChannels+03CCh], al
.73:
        mov ecx, 100h
        mov esi, SbMixBuffer
        call SbConvertMix
        pop edi
        pop esi
        ret
        db 00h,00h,00h
SbDmaHalfReady:
        call SbDmaCount
        cmp eax, dword [SbDmaHalfSize]
        jge short .1
        LD xor, eax, eax
        jmp short .2
.1:
        mov eax, dword [SbDmaHalfSize]
.2:
        mov ebx, dword [SbMixReadPos]
        LD cmp, eax, ebx
        je short .3
        mov eax, 1
        ret
.3:
        mov eax, 0
        ret
SbDmaStart:
        push ebp
        LD mov, ebp, esp
        mov ebx, dword [byte ebp+010h]
        shr ebx, 1
        mov dword [SbDmaHalfSize], ebx
        mov ebx, dword [byte ebp+0Ch]
        mov dword [SbDmaBuffer], ebx
        push dword [byte ebp+010h]
        push ebx
        push dword [byte ebp+08h]
        push edx
        push eax
        call SbCardOpen
        add esp, byte 14h
        cmp eax, byte 0FFFFFFFFh
        je short .1
        mov al, 1
        mov byte [SbDmaRunning], al
        LD xor, eax, eax
        leave
        ret
.1:
        LD xor, eax, eax
        mov byte [SbDmaRunning], al
        call SbCardClose
        mov eax, 0FFFFFFFFh
        leave
        ret
SbDmaStop:
        push esi
        pushfw
        cmp byte [SbDmaRunning], 0
        je short .1
        LD xor, eax, eax
        mov byte [SbDmaRunning], al
        call SbCardClose
.1:
        popfw
        pop esi
        ret
SbMixPause:
        mov eax, 1
        mov byte [SbMixPaused], al
        ret
        LD xor, eax, eax
        mov byte [SbMixPaused], al
        ret
SbConvertMix:
        push esi
        push edi
        cld
        mov ecx, dword [SbDmaHalfSize]
        mov eax, dword [SbMixReadPos]
        mov edi, dword [SbDmaBuffer]
        LD add, edi, eax
.1:
        movsx ebx, word [esi]
        mov al, byte [dword ebx+SbSignTable]
        mov byte [edi], al
        add esi, byte 2
        inc edi
        loop .1
        mov eax, dword [SbDmaHalfSize]
        xor dword [SbMixReadPos], eax
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
