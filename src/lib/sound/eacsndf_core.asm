; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_96A60 progbits alloc exec nowrite align=1
extern __GETDS, _os_handle_3, SndHandleType, sndhandlecount, SndTimerHandle, SndDriverTable, MemDescPtr, MviRewind
extern bcopy, DosReadFile, SndHandleTable
global MviGetWidth, MviGetFrameRate, MviAtEnd, MviSeekFrame, MviDecodeKeyFrame, MviDecodeDeltaFrame, MviNextFrame, SndOpenDriver
global SndDriverHandle, SndHandleDetect, SndHandleOpen, SndHandleInit, SndHandleClose, SndHandleService, SndDriverCall, SndHandleSetTrack
global SndHandleMidi, SndHandlePlayDigi, NullDriverOpen, NullDriverInit, NullDriverReturn, NullDriverQuery, NullDriverSetTrack, NullDriverMidi
global NullDriverPlayDigi
;-----------------------------------------------------------------------------
; MviGetWidth                                     96A60  95 PC, low confidence
; Returns a movie's width; the code after it returns the height and the frame
; count
;-----------------------------------------------------------------------------
MviGetWidth:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+0Ch]
        ret
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+010h]
        ret
        mov eax, dword [byte esp+04h]
        mov eax, dword [eax]
        ret
        db 090h
;-----------------------------------------------------------------------------
; MviGetFrameRate                                     96A78  95 PC, low confidence
; Returns a movie's current picture
;-----------------------------------------------------------------------------
MviGetFrameRate:
        mov eax, dword [byte esp+04h]
        mov eax, dword [byte eax+08h]
        ret
;-----------------------------------------------------------------------------
; MviAtEnd                                     96A80  95 PC, medium confidence
; Returns 1 when a movie is past its last frame
;-----------------------------------------------------------------------------
MviAtEnd:
        mov edx, dword [byte esp+04h]
        mov eax, dword [byte edx+04h]
        cmp eax, dword [edx]
        setg al
        and eax, 0FFh
        ret
        db 08Bh,0C0h
;-----------------------------------------------------------------------------
; MviSeekFrame                                    96A94  95 PC, low confidence
; Moves a movie to a frame, rewinding when it has to
;-----------------------------------------------------------------------------
MviSeekFrame:
        push esi
        push edi
        mov edi, dword [byte esp+010h]
        mov esi, dword [byte esp+0Ch]
        test edi, edi
        jge short .1
        xor edi, edi
.1:
        push esi
        call MviRewind
        add esp, byte 4
        cmp edi, dword [byte esi+04h]
        jle short .3
.2:
        push esi
        call MviNextFrame
        add esp, byte 4
        cmp edi, dword [byte esi+04h]
        jg short .2
.3:
        pop edi
        pop esi
        ret
        db 090h
;-----------------------------------------------------------------------------
; MviDecodeKeyFrame                               96AC4  95 PC, low confidence
; Decodes a movie key frame
;-----------------------------------------------------------------------------
MviDecodeKeyFrame:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        mov dword [byte esp+0Ch], eax
        mov esi, edx
        mov ecx, dword [byte eax+0Ch]
        mov eax, dword [byte eax+034h]
        mov edx, dword [byte eax+02Ch]
        mov dword [byte esp+08h], edx
        mov edx, dword [byte esp+0Ch]
        mov edx, dword [byte edx+038h]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+010h], edx
        mov edx, dword [byte esp+0Ch]
        mov edx, dword [byte edx+03Ch]
        mov edx, dword [byte edx+02Ch]
        mov dword [byte esp+014h], edx
        mov eax, dword [byte eax+028h]
        mov dword [byte esp+018h], eax
        xor edx, edx
        mov dword [byte esp+01Ch], edx
        mov eax, dword [byte esp+0Ch]
        cmp dword [byte eax+010h], byte 0
        jle near .8
.1:
        xor ebp, ebp
        mov dword [byte esp+028h], ebp
        test ecx, ecx
        jle near .7
        mov eax, dword [byte esp+01Ch]
        shl eax, 2
        mov edx, dword [byte esp+018h]
        add edx, eax
        mov dword [byte esp+020h], edx
        mov edi, dword [byte esp+08h]
.2:
        mov ah, byte [esi]
        cmp ah, 0FFh
        jne short .3
        cmp ah, byte [ebx]
        jne short .3
        mov eax, dword [byte esp+020h]
        mov eax, dword [eax]
        add eax, edi
        inc esi
        inc ebx
        mov edx, dword [ebx]
        mov dword [eax], edx
        add eax, ecx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [eax], edx
        add eax, ecx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [eax], edx
        add ebx, byte 4
        mov edx, dword [ebx]
        mov dword [ecx+eax], edx
        add ebx, byte 4
        jmp near .6
.3:
        mov dh, byte [esi]
        cmp dh, 0FFh
        jne short .4
        mov al, byte [ebx]
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        xor edx, edx
        mov dl, byte [ebx]
        sar edx, 4
        and edx, byte 0Fh
        sub edx, byte 7
        mov dword [byte esp+024h], edx
        mov edx, dword [byte esp+014h]
        mov dword [esp], edx
        inc ebx
        jmp short .5
.4:
        mov al, dh
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        xor edx, edx
        mov dl, byte [esi]
        sar edx, 4
        and edx, byte 0Fh
        sub edx, byte 7
        mov dword [byte esp+024h], edx
        mov edx, dword [byte esp+010h]
        mov dword [esp], edx
.5:
        inc esi
        mov edx, dword [byte esp+020h]
        mov edx, dword [edx]
        add edx, edi
        mov ebp, dword [byte esp+01Ch]
        add ebp, dword [byte esp+024h]
        shl ebp, 2
        mov dword [byte esp+04h], ebp
        mov ebp, dword [byte esp+018h]
        add ebp, dword [byte esp+04h]
        mov dword [byte esp+04h], ebp
        mov ebp, dword [esp]
        add ebp, dword [byte esp+028h]
        add ebp, eax
        mov eax, ebp
        mov ebp, dword [byte esp+04h]
        add eax, dword [byte ebp+00h]
        mov ebp, dword [eax]
        mov dword [edx], ebp
        add edx, ecx
        add eax, ecx
        mov ebp, dword [eax]
        mov dword [edx], ebp
        add edx, ecx
        add eax, ecx
        mov ebp, dword [eax]
        mov dword [edx], ebp
        mov eax, dword [ecx+eax]
        mov dword [ecx+edx], eax
.6:
        add edi, byte 4
        mov eax, dword [byte esp+028h]
        add eax, byte 4
        mov dword [byte esp+028h], eax
        cmp ecx, eax
        jg near .2
.7:
        mov ebp, dword [byte esp+01Ch]
        add ebp, byte 4
        mov dword [byte esp+01Ch], ebp
        mov edx, dword [byte esp+0Ch]
        cmp ebp, dword [byte edx+010h]
        jl near .1
.8:
        add esp, byte 2Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
;-----------------------------------------------------------------------------
; MviDecodeDeltaFrame                             96C4C  95 PC, low confidence
; Decodes a movie delta frame
;-----------------------------------------------------------------------------
MviDecodeDeltaFrame:
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 50h
        mov dword [byte esp+010h], edx
        mov edi, ebx
        mov edx, dword [byte eax+0Ch]
        mov ebx, dword [byte eax+010h]
        mov dword [byte esp+04Ch], ebx
        mov ebx, dword [byte eax+020h]
        mov dword [byte esp+030h], ebx
        mov ebx, dword [byte eax+034h]
        mov ebx, dword [byte ebx+02Ch]
        add ebx, byte 10h
        mov dword [byte esp+0Ch], ebx
        mov ebx, dword [byte eax+038h]
        mov ebx, dword [byte ebx+02Ch]
        add ebx, byte 10h
        mov dword [byte esp+01Ch], ebx
        mov eax, dword [byte eax+03Ch]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        mov dword [byte esp+018h], eax
        xor ebx, ebx
        mov dword [byte esp+020h], ebx
        cmp dword [byte esp+04Ch], byte 0
        jle near .17
.1:
        xor eax, eax
        mov dword [esp], eax
        test edx, edx
        jle near .16
        mov eax, dword [byte esp+020h]
        mov esi, dword [byte esp+030h]
        add eax, esi
        mov dword [byte esp+02Ch], eax
.2:
        mov eax, dword [byte esp+010h]
        mov bl, byte [eax]
        cmp bl, 0FFh
        jne short .6
        cmp bl, byte [edi]
        jne short .6
        mov eax, dword [byte esp+020h]
        mov dword [byte esp+034h], eax
        inc dword [byte esp+010h]
        inc edi
        cmp eax, dword [byte esp+02Ch]
        jge near .15
        mov esi, dword [esp]
        add esi, dword [byte esp+030h]
        mov dword [byte esp+028h], edx
        mov ebp, eax
        imul ebp, edx
.3:
        mov eax, dword [esp]
        cmp esi, eax
        jle short .5
        lea ebx, [eax+ebp]
        add ebx, dword [byte esp+0Ch]
.4:
        mov ecx, edi
        inc edi
        mov cl, byte [ecx]
        mov byte [ebx], cl
        inc ebx
        inc eax
        cmp eax, esi
        jl short .4
.5:
        add ebp, dword [byte esp+028h]
        mov ebx, dword [byte esp+034h]
        inc ebx
        mov dword [byte esp+034h], ebx
        cmp ebx, dword [byte esp+02Ch]
        jge near .15
        jmp short .3
.6:
        mov eax, dword [byte esp+010h]
        mov cl, byte [eax]
        cmp cl, 0FFh
        jne short .7
        mov al, byte [edi]
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        mov dword [byte esp+040h], eax
        xor eax, eax
        mov al, byte [edi]
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+018h]
        mov dword [byte esp+03Ch], eax
        inc edi
        jmp short .8
.7:
        mov al, cl
        and al, 0Fh
        and eax, 0FFh
        sub eax, byte 7
        mov dword [byte esp+040h], eax
        xor eax, eax
        mov ebx, dword [byte esp+010h]
        mov al, byte [ebx]
        sar eax, 4
        and eax, byte 0Fh
        sub eax, byte 7
        mov dword [byte esp+04h], eax
        mov eax, dword [byte esp+01Ch]
        mov dword [byte esp+03Ch], eax
.8:
        inc dword [byte esp+010h]
        mov eax, dword [byte esp+030h]
        test eax, eax
        jle near .15
        mov ebx, dword [byte esp+020h]
        mov dword [byte esp+038h], ebx
        add eax, ebx
        mov dword [byte esp+024h], eax
.9:
        mov esi, dword [byte esp+030h]
        test esi, esi
        jle near .14
        mov ebx, dword [byte esp+038h]
        mov ecx, dword [esp]
        mov eax, ecx
        add ecx, esi
        mov dword [byte esp+044h], ecx
.10:
        mov dword [byte esp+08h], eax
        mov dword [byte esp+048h], ebx
        mov ebp, dword [byte esp+04Ch]
        cmp ebx, ebp
        jge short .13
        cmp eax, edx
        jge short .13
        mov ecx, dword [byte esp+040h]
        add ecx, eax
        mov esi, dword [byte esp+04h]
        add esi, ebx
        test esi, esi
        jl short .11
        cmp esi, ebp
        jge short .11
        test ecx, ecx
        jl short .11
        cmp ecx, edx
        jl short .12
.11:
        mov esi, dword [byte esp+0Ch]
        add esi, dword [byte esp+08h]
        mov ecx, dword [byte esp+048h]
        imul ecx, edx
        mov byte [ecx+esi], 0
        jmp short .13
.12:
        mov ebp, dword [byte esp+03Ch]
        add ebp, ecx
        mov ecx, esi
        imul ecx, edx
        add ecx, ebp
        mov esi, dword [byte esp+0Ch]
        add esi, eax
        mov dword [byte esp+014h], esi
        mov esi, ebx
        imul esi, edx
        add esi, dword [byte esp+014h]
        mov cl, byte [ecx]
        mov byte [esi], cl
.13:
        inc eax
        cmp eax, dword [byte esp+044h]
        jl short .10
.14:
        mov esi, dword [byte esp+038h]
        inc esi
        mov dword [byte esp+038h], esi
        cmp esi, dword [byte esp+024h]
        jl near .9
.15:
        mov eax, dword [byte esp+030h]
        mov ebx, dword [esp]
        add ebx, eax
        mov dword [esp], ebx
        cmp edx, ebx
        jg near .2
.16:
        mov eax, dword [byte esp+030h]
        mov esi, dword [byte esp+020h]
        add esi, eax
        mov dword [byte esp+020h], esi
        cmp esi, dword [byte esp+04Ch]
        jl near .1
.17:
        add esp, byte 50h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 090h
;-----------------------------------------------------------------------------
; MviNextFrame                                    96E7C  95 PC, low confidence
; Reads and decodes a movie's next frame
;-----------------------------------------------------------------------------
MviNextFrame:
        push esi
        push edi
        push ebp
        sub esp, byte 18h
        mov ebp, dword [byte esp+028h]
        mov edi, ebp
        mov eax, dword [byte ebp+020h]
        mov dword [byte esp+010h], eax
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte esp+04h], eax
        mov eax, dword [byte ebp+010h]
        mov dword [byte esp+08h], eax
        mov edx, dword [byte esp+04h]
        mov ebx, dword [byte esp+010h]
        add edx, ebx
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov esi, eax
        mov edx, dword [byte esp+08h]
        add edx, ebx
        dec edx
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        imul esi, eax
        mov dword [byte esp+0Ch], esi
        mov ecx, dword [byte ebp+030h]
        push ecx
        call MemDescPtr
        add esp, byte 4
        add eax, dword [byte ebp+02Ch]
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        mov edx, dword [byte esp+0Ch]
        add edx, eax
        mov dword [byte esp+014h], edx
        push ebp
        call MviAtEnd
        add esp, byte 4
        test eax, eax
        je short .1
        mov eax, dword [byte ebp+034h]
        jmp near .9
.1:
        mov edx, dword [byte ebp+03Ch]
        mov eax, dword [byte ebp+038h]
        mov dword [byte ebp+03Ch], eax
        mov eax, dword [byte ebp+034h]
        mov dword [byte ebp+038h], eax
        mov dword [byte ebp+034h], edx
        cmp dword [byte ebp+024h], byte 0
        je short .2
        mov edx, dword [byte ebp+030h]
        push edx
        call MemDescPtr
        add esp, byte 4
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        push byte 2
        push eax
        mov ebx, dword [byte ebp+024h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
.2:
        cmp byte [esi], 0
        jne short .4
        cmp byte [byte esi+01h], 0
        jne short .4
        mov eax, dword [byte esp+04h]
        imul eax, dword [byte esp+08h]
        add esi, byte 2
        lea ebp, [byte eax+02h]
        mov ecx, dword [byte edi+024h]
        test ecx, ecx
        je short .3
        push eax
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        push eax
        push ecx
        call DosReadFile
        add esp, byte 0Ch
        jmp near .8
.3:
        push eax
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        push eax
        push esi
        call bcopy
        add esp, byte 0Ch
        jmp near .8
.4:
        mov ecx, dword [byte edi+024h]
        test ecx, ecx
        jne short .5
        add esi, byte 2
        xor eax, eax
        mov al, byte [byte esi+01h]
        shl eax, 8
        xor edx, edx
        mov dl, byte [esi]
        add edx, eax
        xor eax, eax
        mov al, byte [byte esi+02h]
        shl eax, 10h
        add edx, eax
        xor eax, eax
        mov al, byte [byte esi+03h]
        shl eax, 18h
        lea ebp, [edx+eax]
        add esi, byte 4
        add dword [byte esp+014h], byte 6
        jmp short .6
.5:
        push byte 4
        lea eax, [byte esp+04h]
        push eax
        push ecx
        call DosReadFile
        add esp, byte 0Ch
        xor eax, eax
        mov al, byte [byte esp+01h]
        shl eax, 8
        xor edx, edx
        mov dl, byte [esp]
        add edx, eax
        xor eax, eax
        mov al, byte [byte esp+02h]
        shl eax, 10h
        lea ebp, [edx+eax]
        xor eax, eax
        mov al, byte [byte esp+03h]
        shl eax, 18h
        add ebp, eax
        mov eax, dword [byte edi+030h]
        push eax
        call MemDescPtr
        add esp, byte 4
        push eax
        call _os_handle_3
        add esp, byte 4
        mov esi, eax
        push ebp
        push eax
        mov ebx, dword [byte edi+024h]
        push ebx
        call DosReadFile
        add esp, byte 0Ch
        mov eax, esi
        mov ecx, dword [byte esp+0Ch]
        add eax, ecx
        mov dword [byte esp+014h], eax
.6:
        add ebp, byte 6
        cmp dword [byte esp+010h], byte 4
        jne short .7
        mov ebx, dword [byte esp+014h]
        mov edx, esi
        mov eax, edi
        call MviDecodeKeyFrame
        inc dword [byte edi+04h]
        add dword [byte edi+02Ch], ebp
        mov eax, dword [byte edi+034h]
        mov eax, dword [byte eax+02Ch]
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
.7:
        mov ebx, dword [byte esp+014h]
        mov edx, esi
        mov eax, edi
        call MviDecodeDeltaFrame
.8:
        inc dword [byte edi+04h]
        add dword [byte edi+02Ch], ebp
        mov eax, dword [byte edi+034h]
.9:
        mov eax, dword [byte eax+02Ch]
        add esp, byte 18h
        pop ebp
        pop edi
        pop esi
        ret
;-----------------------------------------------------------------------------
; SndOpenDriver                                97079  95 PC, medium confidence
; Opens sound driver 0-6 (detect, open, init) and returns its handle, or the
; handle it already has
;-----------------------------------------------------------------------------
SndOpenDriver:
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 4
        mov ebx, eax
        test eax, eax
        jl short .1
        cmp eax, byte 6
        jle short .2
.1:
        mov eax, 0FFFFFFFFh
        jmp near .9
.2:
        xor eax, eax
        jmp short .4
.3:
        imul edx, eax, byte 2Ch
        cmp ebx, dword [dword edx+SndHandleTable+028h]
        je near .9
        inc eax
.4:
        mov edx, dword [sndhandlecount]
        cmp eax, edx
        jl short .3
        test edx, edx
        jne short .7
        xor eax, eax
        mov edi, 0FFFFFFFFh
        jmp short .6
.5:
        imul edx, eax, byte 2Ch
        mov dword [dword edx+SndDriverTable+028h], edi
        inc eax
.6:
        cmp eax, byte 7
        jb short .5
.7:
        mov eax, dword [sndhandlecount]
        mov dword [esp], eax
        imul esi, ebx, byte 2Ch
        mov dword [dword esi+SndDriverTable+028h], eax
        imul ebp, eax, byte 2Ch
        mov ecx, 0Bh
        lea edi, [dword ebp+SndHandleTable]
        lea esi, [dword esi+SndDriverTable]
        rep movsd
        mov dword [dword ebp+SndHandleTable+028h], ebx
        xor ebx, ebx
        mov bl, byte [esp]
        mov eax, ebx
        call SndHandleDetect
        mov ecx, eax
        mov edx, eax
        mov eax, ebx
        call SndHandleOpen
        cwde
        test eax, eax
        je near .1
        mov edx, ecx
        mov eax, ebx
        call SndHandleInit
        mov al, byte [dword ebp+SndHandleTable+024h]
        mov edx, dword [esp]
        mov byte [dword edx+SndHandleType], al
        mov edx, 7
        mov eax, ebx
        call SndDriverCall
        test eax, eax
        jle short .8
        cmp eax, byte 64h
        jge short .8
        mov eax, dword [esp]
        mov dword [SndTimerHandle], eax
.8:
        mov eax, dword [esp]
        inc dword [sndhandlecount]
.9:
        add esp, byte 4
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndDriverHandle                              97166  95 PC, medium confidence
; Returns the open handle of a sound driver, or -1
;-----------------------------------------------------------------------------
SndDriverHandle:
        cmp dword [sndhandlecount], byte 0
        jg short .1
        mov eax, 0FFFFFFFFh
        ret
.1:
        imul eax, byte 2Ch
        mov eax, dword [dword eax+SndDriverTable+028h]
        ret
;-----------------------------------------------------------------------------
; SndHandleDetect                              9717F  95 PC, medium confidence
; Calls the detect entry of an open driver handle
;-----------------------------------------------------------------------------
SndHandleDetect:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable]
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndHandleOpen                                97194  95 PC, medium confidence
; Calls the open entry of an open driver handle with the detected port
;-----------------------------------------------------------------------------
SndHandleOpen:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+04h]
        add esp, byte 4
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndHandleInit                                971AB  95 PC, medium confidence
; Calls the init entry of an open driver handle
;-----------------------------------------------------------------------------
SndHandleInit:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+08h]
        jmp short SndHandleOpen+011h
;-----------------------------------------------------------------------------
; SndHandleClose                               971BE  95 PC, medium confidence
; Calls the close entry of an open driver handle
;-----------------------------------------------------------------------------
SndHandleClose:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short .1
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable+0Ch]
.1:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndHandleService                             971DB  95 PC, medium confidence
; Calls the timer service entry of an open driver handle
;-----------------------------------------------------------------------------
SndHandleService:
        push ebx
        push ecx
        push edx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short .1
        imul eax, byte 2Ch
        call dword [dword eax+SndHandleTable+010h]
.1:
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SndDriverCall                                971F8  95 PC, medium confidence
; EACSNDF core entry the handle calls jump to (handle in al, command word in
; edx)
;-----------------------------------------------------------------------------
SndDriverCall:
        push ebx
        push ecx
        and eax, 0FFh
        imul eax, byte 2Ch
        push edx
        call dword [dword eax+SndHandleTable+014h]
        jmp short SndHandleOpen+011h
;-----------------------------------------------------------------------------
; SndHandleSetTrack                               9720B  95 PC, low confidence
; Calls the track setup entry of an open driver handle (channel and track
; data)
;-----------------------------------------------------------------------------
SndHandleSetTrack:
        push ecx
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short .1
        imul eax, byte 2Ch
        push ebx
        xor ebx, ebx
        mov bx, dx
        push ebx
        call dword [dword eax+SndHandleTable+018h]
        add esp, byte 8
.1:
        pop ecx
        ret
;-----------------------------------------------------------------------------
; SndHandleMidi                                   9722E  95 PC, low confidence
; Sends a MIDI message to an open driver handle, raising note on and note off
; two octaves
;-----------------------------------------------------------------------------
SndHandleMidi:
        push ecx
        xor ecx, ecx
        mov cl, al
        cmp ecx, dword [sndhandlecount]
        jge short .3
        mov ah, byte [ebx]
        and ah, 0F0h
        cmp ah, 80h
        je short .1
        cmp ah, 90h
        jne short .2
.1:
        add byte [byte ebx+01h], 18h
.2:
        and eax, 0FFh
        imul eax, byte 2Ch
        push ebx
        xor ebx, ebx
        mov bx, dx
        push ebx
        call dword [dword eax+SndHandleTable+01Ch]
        add esp, byte 8
.3:
        pop ecx
        ret
;-----------------------------------------------------------------------------
; SndHandlePlayDigi                               97268  95 PC, low confidence
; Calls the digital playback entry of an open driver handle
;-----------------------------------------------------------------------------
SndHandlePlayDigi:
        push esi
        push edi
        push ebp
        and eax, 0FFh
        cmp eax, dword [sndhandlecount]
        jge short .1
        imul eax, byte 2Ch
        mov edi, dword [byte esp+024h]
        push edi
        mov ebp, dword [byte esp+024h]
        push ebp
        mov esi, dword [byte esp+024h]
        push esi
        mov edi, dword [byte esp+024h]
        push edi
        mov ebp, dword [byte esp+024h]
        push ebp
        mov esi, dword [byte esp+024h]
        push esi
        push ecx
        push ebx
        push edx
        call dword [dword eax+SndHandleTable+020h]
        add esp, byte 24h
.1:
        pop ebp
        pop edi
        pop esi
        ret 18h
;-----------------------------------------------------------------------------
; NullDriverOpen                               972AB  95 PC, medium confidence
; Null sound driver detect and open entries: return 1
;-----------------------------------------------------------------------------
NullDriverOpen:
        push ds
        call __GETDS
        mov eax, 1
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverInit                               972B8  95 PC, medium confidence
; Null sound driver init entry: does nothing
;-----------------------------------------------------------------------------
NullDriverInit:
        push ds
        call __GETDS
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverReturn                             972C0  95 PC, medium confidence
; Null sound driver close and service entries: do nothing
;-----------------------------------------------------------------------------
NullDriverReturn:
        push ds
        call __GETDS
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverQuery                              972C8  95 PC, medium confidence
; Null sound driver query entry: returns -1
;-----------------------------------------------------------------------------
NullDriverQuery:
        push ds
        call __GETDS
        mov eax, 0FFFFFFFFh
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverSetTrack                           972D5  95 PC, medium confidence
; Null sound driver track setup entry: does nothing
;-----------------------------------------------------------------------------
NullDriverSetTrack:
        push ds
        call __GETDS
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverMidi                               972DD  95 PC, medium confidence
; Null sound driver MIDI entry: does nothing
;-----------------------------------------------------------------------------
NullDriverMidi:
        push ds
        call __GETDS
        pop ds
        ret
;-----------------------------------------------------------------------------
; NullDriverPlayDigi                           972E5  95 PC, medium confidence
; Null sound driver digital playback entry: does nothing
;-----------------------------------------------------------------------------
NullDriverPlayDigi:
        push ds
        call __GETDS
        pop ds
        ret
        db 00h,00h,00h
