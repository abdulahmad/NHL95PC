; Small helpers written by hand: the random number generator, the angle helper,
; the MVI movie player, and the VGA copy routines.
bits 32
%include "hockey.inc"
section s_8BEDB progbits alloc exec nowrite align=1
extern __CHK, AnyInputPressed, bgscrollx, bgscrolly8, ClearInputQueue, GetTicks, musichandle, musicon
extern musicslot, ReadBE32, rinkbm, saved_ss, screenbm, scrollx, scrolly, scrpitch
extern seed, SetDrawBitmap, SetTickDeadline, songdata, sub_1AC25, sub_1ACF1, sub_1AD16, sub_1B002
extern sub_1B092, sub_1B0BB, sub_1B0C9, sub_1B0D7, sub_1B0E5, sub_1B0F3, sub_1B18B, sub_1B1C2
extern sub_1B2A7, sub_1B8AC, sub_1B92E, sub_8FB8E, SndQuery, sub_8FCDF, FillRect, DrawArtOpaque
extern VgaSetPalette, sub_B4BA8, TickDeadlinePassed, vgapage, vtoa_dt, WaitClickTimeout
global PlayMVI, stub_8C1B7, SelectScreenBM, SelectScreenBM_set, SelectRinkBM, stub_8C1F7, stub_8C202, stub_8C20D
global stub_8C218, stub_8C223, randomd0, vgacopy_bg, vtoa, SaveSS
;-----------------------------------------------------------------------------
; PlayMVI                                                         8BEDB  95 PC
; PlayMVI(eax=path, edx=x, ebx=y) -> eax key. (CD movie player).
; Opens the file through the cdstream reader, then per chunk:
; 'MVIh' header: sets up the decoder (cmv_player) and the frame delay
; 'MVIf' frame: decodes and waits for the frame time (GetTicks ticks)
; 'MVIe' end: stops. A key press (AnyInputPressed) aborts.
; Afterwards waits for the music fade and restarts the song if music is on.
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/PlayMVI.c
%ifdef CBUILD
%include "c/engine/asm_helpers/PlayMVI.inc"
%else
PlayMVI:
        push dword 58h
        call __CHK
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 30h
        mov esi, eax
        mov dword [byte esp+018h], edx
        mov dword [byte esp+014h], ebx
        call ClearInputQueue
        call sub_B4BA8
        push byte 20h
        push dword 2000h
        push dword 493E0h
        call sub_1B0F3
        add esp, byte 0Ch
        mov dword [byte esp+020h], eax
        push esi
        push eax
        call sub_1B1C2
        add esp, byte 8
        call sub_1AC25
        mov edi, eax
        push dword 96h
        call SetTickDeadline
        add esp, byte 4
.prime:
        call TickDeadlinePassed
        test eax, eax
        jne short .1
        call sub_1B2A7
        jmp short PlayMVI.prime
.1:
        mov dword [byte esp+0Ch], 0Ah
        xor ebp, ebp
        mov dword [byte esp+010h], ebp
        call GetTicks
        xor esi, esi
        mov dword [byte esp+01Ch], ebp
        mov dword [byte esp+02Ch], ebp
        call GetTicks
        mov dword [byte esp+024h], eax
        mov dword [byte esp+028h], ebp
        call sub_1B2A7
.chunk:
        mov ebx, dword [byte esp+020h]
        push ebx
        call sub_1B8AC
        mov edx, eax
        add esp, byte 4
        mov dword [byte esp+04h], eax
        cmp eax, byte 0FFFFFFFFh
        jne short .2
        mov esi, eax
        jmp near .8
.2:
        test eax, eax
        je near .7
        call ReadBE32
        mov dword [byte esp+08h], eax
        cmp eax, 4D564966h
        jb short .3
        jbe short .frame
        cmp eax, 4D564968h
        je near .header
        jmp near .other
.3:
        cmp eax, 4D564965h
        je near .end
        jmp near .other
.frame:
        cmp ebp, byte 1
        jle near .next
        mov eax, dword [byte esp+0Ch]
        add dword [byte esp+02Ch], eax
        mov eax, edi
        call sub_1B002
        mov dword [esp], eax
        call GetTicks
        sub eax, dword [byte esp+024h]
        cmp eax, dword [byte esp+02Ch]
        jge short .4
        mov ebx, dword [byte esp+014h]
        push ebx
        mov ecx, dword [byte esp+01Ch]
        push ecx
        mov eax, dword [byte esp+08h]
        push eax
        call DrawArtOpaque
        add esp, byte 0Ch
.4:
        cmp dword [byte esp+028h], byte 0
        jne short .6
        cmp ebp, dword [byte esp+010h]
        jne short .6
        cmp byte [musicon], 0
        je short .5
        mov ecx, dword [songdata]
        test ecx, ecx
        je short .5
        mov edx, dword [musichandle]
        mov eax, ecx
        mov ecx, 7Fh
        mov ebx, 3
        call sub_8FB8E
.5:
        call GetTicks
        mov dword [byte esp+024h], eax
.6:
        dec ebp
        jmp near .next
.header:
        mov eax, edi
        call sub_1AD16
        mov eax, edi
        call sub_1B092
        mov ebp, eax
        mov dword [byte esp+010h], eax
        push byte 0
        push dword 0B0h
        push dword 0E4h
        mov ecx, dword [byte esp+020h]
        push ecx
        mov eax, dword [byte esp+028h]
        push eax
        call FillRect
        add esp, byte 14h
        mov eax, edi
        call sub_1B0E5
        push eax
        mov eax, edi
        call sub_1B0D7
        push eax
        mov eax, edi
        call sub_1B0C9
        push eax
        call VgaSetPalette
        add esp, byte 0Ch
        mov eax, edi
        call sub_1B0BB
        mov ebx, eax
        mov eax, 64h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov dword [byte esp+0Ch], eax
        jmp short .next
.end:
        inc dword [byte esp+028h]
        jmp short .next
.other:
        mov dword [byte esp+01Ch], 1
.next:
        mov ebx, dword [byte esp+04h]
        push ebx
        mov ecx, dword [byte esp+024h]
        push ecx
        call sub_1B92E
        add esp, byte 8
        call sub_1B2A7
        cmp dword [byte esp+08h], 4D564966h
        jne short .8
        call GetTicks
        sub eax, dword [byte esp+024h]
        mov ebx, dword [byte esp+02Ch]
        cmp eax, ebx
        jge short .8
        mov edx, ebx
        sub edx, eax
        push edx
        call SetTickDeadline
        add esp, byte 4
.wait:
        call TickDeadlinePassed
        test eax, eax
        jne short .8
        test esi, esi
        jne short .8
        call AnyInputPressed
        mov esi, eax
        jmp short PlayMVI.wait
.7:
        call sub_1B2A7
.8:
        test esi, esi
        jne short .9
        call AnyInputPressed
        mov esi, eax
.9:
        test esi, esi
        jne short .done
        cmp dword [byte esp+01Ch], byte 0
        jne short .done
        cmp dword [byte esp+028h], byte 3
        jne near PlayMVI.chunk
.done:
        mov eax, edi
        call sub_1ACF1
        mov edx, dword [byte esp+020h]
        push edx
        call sub_1B18B
        add esp, byte 4
        cmp byte [musicon], 0
        je short .x
        cmp dword [songdata], byte 0
        je short .x
.fade:
        test esi, esi
        jne short .10
        mov eax, dword [musicslot-3]
        sar eax, 18h
        mov edx, 3
        call SndQuery
        test eax, eax
        jne short .10
        mov eax, 0Ah
        call WaitClickTimeout
        mov esi, eax
        jmp short PlayMVI.fade
.10:
        mov eax, dword [musichandle]
        mov ebx, 50h
        mov edx, 3
        call sub_8FCDF
.x:
        mov eax, esi
        add esp, byte 30h
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C1B7                                   8C1B7  95 PC, medium confidence
; stub_8C1B7..stub_8C223: empty functions (__CHK; ret). Only stub_8C218
; has a caller (line_editor_rosters, 6 stack args): removed routines.
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C1B7.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C1B7.inc"
%else
stub_8C1B7:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; SelectScreenBM                               8C1C2  95 PC, medium confidence
; SelectScreenBM SelectRinkBM: SetDrawBitmap(*screenbm *rinkbm),
; i.e. make that 48-byte bitmap descriptor the current draw target.
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/SelectScreenBM.c
%ifdef CBUILD
%include "c/engine/asm_helpers/SelectScreenBM.inc"
%else
SelectScreenBM:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [screenbm]
SelectScreenBM_set:
        push edx
        call SetDrawBitmap
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
;-----------------------------------------------------------------------------
; SelectRinkBM                                 8C1E2  95 PC, medium confidence
; SetDrawBitmap(*rinkbm): makes the rink tile buffer bitmap current; called
; by file_utils/gadgets_replay
;-----------------------------------------------------------------------------
SelectRinkBM:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        mov edx, dword [rinkbm]
        jmp short SelectScreenBM_set
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C1F7                                   8C1F7  95 PC, medium confidence
; Empty function, no callers
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C1F7.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C1F7.inc"
%else
stub_8C1F7:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C202                                   8C202  95 PC, medium confidence
; Empty function, no callers
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C202.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C202.inc"
%else
stub_8C202:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C20D                                   8C20D  95 PC, medium confidence
; Empty function, no callers
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C20D.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C20D.inc"
%else
stub_8C20D:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C218                                   8C218  95 PC, medium confidence
; Empty function; line_editor_rosters calls it with 6 stack args (vgapage==0,
; ...) and pops them: a removed routine
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C218.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C218.inc"
%else
stub_8C218:
        push dword 4
        call __CHK
        ret
%endif ; C
;-----------------------------------------------------------------------------
; stub_8C223                                   8C223  95 PC, medium confidence
; Empty function, no callers
;-----------------------------------------------------------------------------
; C: src/engine/asm_helpers/stub_8C223.c
%ifdef CBUILD
%include "c/engine/asm_helpers/stub_8C223.inc"
%else
stub_8C223:
        push dword 4
        call __CHK
        ret
%endif ; C
        db 00h,00h
;-----------------------------------------------------------------------------
; randomd0                                             8C230  94G middle94.asm
; 32-bit LCG. seed = seed*BB40E62Dh + 1.
; returns ((seed>>8)&FFFFh * ax) >> 16, a value in 0..ax-1. The high word is seed+2.
;-----------------------------------------------------------------------------
randomd0:
        push ebp
        LD mov, ebp, esp
        push ebx
        push ecx
        push edx
        push ax
        mov ax, word [seed+2]
        mov dx, 0E62Dh
        mul dx
        LD mov, bx, ax
        mov ax, word [seed]
        LD mov, cx, ax
        mov dx, 0BB40h
        mul dx
        LD add, bx, ax
        LD mov, ax, cx
        mov dx, 0E62Dh
        mul dx
        LD add, dx, bx
        add ax, byte 1
        adc dx, byte 0
        mov word [seed], ax
        mov word [seed+2], dx
        LD mov, al, ah
        LD mov, ah, dl
        pop dx
        mul dx
        LD mov, ax, dx
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; vgacopy_bg                                   8C290  95 PC, medium confidence
; vgacopy_bg.. vgacopy_pages (8C290-8C8E7): 16-bit-frame planar VGA
; routines (args at [ebp+6..], o16 registers, ports 3C4h/3CEh/3D4h/3DAh/3C0h,
; write mode 1 latched copies). None has a caller or a fixup: dead code
; from an earlier real-mode build. The labels other than vgacopy_bg were
; added here (no reference in the EXE).
;-----------------------------------------------------------------------------
vgacopy_bg:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov bx, word [byte ebp+0Ah]
        mov cx, word [byte ebp+08h]
        mov ax, word [scrpitch]
        mul bx
        mov di, word [byte ebp+06h]
        LD add, di, ax
        LD add, di, cx
        mov ax, 60h
        mov dx, word [bgscrolly8]
        shl dx, 3
        LD add, bx, dx
        cmp bx, 0B0h
        jb short .1
        sub bx, 0B0h
.1:
        mul bx
        mov si, 86A0h
        LD add, si, ax
        LD add, si, cx
        mov dx, word [bgscrollx]
        LD add, si, dx
        LD add, si, dx
        mov ax, word [byte ebp+0Ch]
        mov bx, word [scrpitch]
        LD sub, bx, ax
        mov dx, 60h
        LD sub, dx, ax
        cld
        mov cx, 0A000h
        mov ds, cx
        mov es, cx
        cmp ax, byte 52h
        jb short .loop
        nop
.loop:
        LD mov, cx, ax
        rep movsb
        LD add, di, bx
        LD add, si, dx
        cmp si, 0C8A0h
        jb short .2
        sub si, 4200h
.2:
        dec word [byte ebp+0Eh]
        jne short vgacopy_bg.loop
        mov dx, 3C5h
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgacopy_rect                                                    8C36F  95 PC
; Hand-written VGA blit: copies a rectangle between video memory areas in
; write mode 1 (latched copy, all planes at once).
;-----------------------------------------------------------------------------
vgacopy_rect:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov bx, word [scrpitch]
        sub bx, word [byte ebp+0Ah]
        mov ax, 0A000h
        mov ds, ax
        mov es, ax
        mov si, word [byte ebp+06h]
        mov di, word [byte ebp+08h]
        mov ax, word [byte ebp+0Ch]
        cld
        mov dx, word [byte ebp+0Ah]
.loop:
        LD mov, cx, dx
        rep movsb
        LD add, di, bx
        dec ax
        jne short vgacopy_rect.loop
        mov dx, 3C5h
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
vgacopy_rect_src:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov bx, word [scrpitch]
        sub bx, word [byte ebp+0Ah]
        mov ax, 0A000h
        mov ds, ax
        mov es, ax
        mov si, word [byte ebp+06h]
        mov di, word [byte ebp+08h]
        mov ax, word [byte ebp+0Ch]
        cld
        mov dx, word [byte ebp+0Ah]
.loop:
        LD mov, cx, dx
        rep movsb
        LD add, si, bx
        dec ax
        jne short vgacopy_rect_src.loop
        mov dx, 3C5h
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgadraw_tile                                                    8C463  95 PC
; Hand-written VGA blit: draws one tile into video memory, latched copy (flag
; 800h clear) or plane by plane.
;-----------------------------------------------------------------------------
vgadraw_tile:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov bx, 60h
        mov ax, 0A000h
        mov ds, ax
        mov es, ax
        mov si, word [byte ebp+06h]
        mov di, word [byte ebp+08h]
        mov dx, word [byte ebp+0Ah]
        test dx, 800h
        je short .latched
        jmp short .planar
.latched:
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov cx, 8
        mov ax, word [byte ebp+0Ah]
        test ax, 1000h
        je short .1
        shl bx, 3
        LD add, di, bx
        shr bx, 3
        LD sub, di, bx
        neg bx
.1:
        sub bx, byte 2
        cld
.loop:
        movsb
        movsb
        LD add, di, bx
        loop vgadraw_tile.loop
        jmp near .x
.planar:
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        and al, 0FCh
        out dx, al
        mov dx, 3CEh
        mov al, 4
        out dx, al
        inc dx
        in al, dx
        and al, 0FCh
        out dx, al
        mov dx, 3C4h
        mov al, 2
        out dx, al
        inc dx
        in al, dx
        and al, 0F0h
        add al, 8
        out dx, al
        mov ah, 8
        mov cx, word [byte ebp+0Ah]
        test cx, 1000h
        je short .2
        shl bx, 3
        LD add, di, bx
        shr bx, 3
        LD sub, di, bx
        neg bx
.2:
        push si
        push di
        mov cx, 4
.plane:
        pop di
        pop si
        push si
        push di
        push cx
        mov cx, 8
.row:
        mov al, byte [esi]
        db 067h,026h,088h,045h,01h              ; insn: mov [es:di+1],al
        mov al, byte [byte esi+01h]
        db 067h,026h,088h,05h                   ; insn: mov [es:di],al
        LD add, di, bx
        add si, byte 2
        loop vgadraw_tile.row
        mov dx, 3C4h
        mov al, 2
        out dx, al
        inc dx
        in al, dx
        and al, 0F0h
        shr ah, 1
        LD add, al, ah
        out dx, al
        mov dx, 3CEh
        mov al, 4
        out dx, al
        inc dx
        in al, dx
        inc al
        out dx, al
        pop cx
        loop vgadraw_tile.plane
        in al, dx
        dec al
        out dx, al
        pop di
        pop si
.x:
        pop si
        pop di
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgaflip                                                         8C58C  95 PC
; Hand-written VGA page flip: toggles vgapage and points the display start at
; the other page (0B00h or 4400h).
;-----------------------------------------------------------------------------
vgaflip:
        push bp
        LD mov, bp, sp
        push di
        push ax
        push bx
        push cx
        push dx
        mov bx, word [vgapage]
        and bx, byte 1
        xor bx, byte 1
        mov word [vgapage], bx
        cmp bx, byte 1
        je short .1
        mov di, 0B00h
        jmp short .2
.1:
        mov di, 4400h
.2:
        mov ax, word [scrpitch]
        mul word [scrolly]
        mov bx, word [scrollx]
        LD mov, cx, bx
        shr bx, 1
        shr bx, 1
        LD add, bx, ax
        LD add, bx, di
        and cx, byte 3
        shl cx, 1
        mov dx, 3DAh
.vbl:
        in al, dx
        test al, 8
        jne short vgaflip.vbl
        test al, 1
        je short vgaflip.vbl
        mov dx, 3D4h
        mov al, 0Ch
        LD mov, ah, bh
        out dx, ax
        inc ax
        LD mov, ah, bl
        out dx, ax
        mov dx, 3DAh
.3:
        in al, dx
        test al, 8
        jne short vgaflip.3
.4:
        in al, dx
        test al, 8
        je short vgaflip.4
        mov dx, 3C0h
        mov al, 33h
        out dx, al
        LD mov, ax, cx
        out dx, al
        mov dx, 3DAh
.5:
        in al, dx
        test al, 8
        jne short vgaflip.5
        pop dx
        pop cx
        pop bx
        pop ax
        pop di
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgaload_planes                                                  8C637  95 PC
; Hand-written VGA upload: writes planar image data into video memory one
; plane at a time (write mode 0).
;-----------------------------------------------------------------------------
vgaload_planes:
        push bp
        LD mov, bp, sp
        push ds
        push si
        push di
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        mov ah, 1
        and al, 0F0h
        mov si, word [byte ebp+08h]
        mov bx, word [esi]
        shr bx, 2
        push ds
        mov si, word [byte ebp+06h]
        lds si, [esi]
        mov cx, 0A000h
        mov es, cx
        mov cx, 4
.1:
        LD add, al, ah
        out dx, al
        LD sub, al, ah
        shl ah, 1
        push cx
        LD mov, cx, bx
        mov di, 0DA78h
        cld
        rep movsb
        pop cx
        loop vgaload_planes.1
        pop ds
        push ds
        mov si, word [byte ebp+08h]
        mov bx, word [byte esi+02h]
        shr bx, 2
        mov si, word [byte ebp+06h]
        lds si, [byte esi+04h]
        mov cx, 4
        mov ah, 1
.2:
        push di
        push cx
        LD add, al, ah
        out dx, al
        LD sub, al, ah
        shl ah, 1
        LD mov, cx, bx
        rep movsb
        pop cx
        pop di
        loop vgaload_planes.2
        pop ds
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        pop ax
        out dx, al
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        pop ax
        out dx, al
        pop di
        pop si
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgacopy_bgfull                                                  8C6F0  95 PC
; Hand-written VGA blit: copies the whole background page in write mode 1
; (latched copy).
;-----------------------------------------------------------------------------
vgacopy_bgfull:
        push bp
        LD mov, bp, sp
        push ds
        push si
        push di
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add al, 0Fh
        out dx, al
        mov ax, word [bgscrolly8]
        mov dx, 300h
        mul dx
        LD mov, si, ax
        add si, 86A0h
        mov dx, word [bgscrollx]
        LD add, si, dx
        LD add, si, dx
        mov di, word [byte ebp+06h]
        mov ax, 0B0h
        mov bx, 52h
        mov dx, 0Eh
        mov cx, 0A000h
        mov ds, cx
        mov es, cx
.loop:
        LD mov, cx, bx
        rep movsb
        LD add, si, dx
        cmp si, 0C8A0h
        jb short .1
        sub si, 4200h
.1:
        dec ax
        jne short vgacopy_bgfull.loop
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        pop ax
        out dx, al
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        pop ax
        out dx, al
        pop di
        pop si
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgacopy_A40                                                     8C798  95 PC
; Hand-written VGA blit: latched copy of a fixed-size block (A40h bytes) in
; write mode 1.
;-----------------------------------------------------------------------------
vgacopy_A40:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov ax, 0A000h
        mov ds, ax
        mov es, ax
        mov si, word [byte ebp+06h]
        mov di, word [byte ebp+08h]
        mov cx, 0A40h
        cld
        rep movsb
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgacopy_n                                                       8C7F5  95 PC
; Hand-written VGA blit: latched copy of n bytes in write mode 1.
;-----------------------------------------------------------------------------
vgacopy_n:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov ax, 0A000h
        mov ds, ax
        mov es, ax
        mov si, word [byte ebp+06h]
        mov di, word [byte ebp+08h]
        mov cx, word [byte ebp+0Ah]
        cld
        rep movsb
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
;-----------------------------------------------------------------------------
; vgacopy_pages                                                   8C852  95 PC
; Hand-written VGA blit: latched copy from one video page to the other in
; write mode 1.
;-----------------------------------------------------------------------------
vgacopy_pages:
        push bp
        LD mov, bp, sp
        push ds
        push di
        push si
        mov dx, 3CEh
        mov ax, 5
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0FCh
        inc al
        out dx, al
        mov dx, 3C4h
        mov ax, 2
        out dx, al
        inc dx
        in al, dx
        push ax
        and al, 0F0h
        add ax, byte 0Fh
        out dx, al
        mov bx, word [byte ebp+0Ch]
        mov cx, word [byte ebp+0Ah]
        mov ax, word [scrpitch]
        mul bx
        LD mov, di, ax
        LD add, di, cx
        LD mov, si, di
        add di, word [byte ebp+08h]
        add si, word [byte ebp+06h]
        mov ax, word [byte ebp+0Eh]
        mov bx, word [scrpitch]
        LD sub, bx, ax
        cld
        mov cx, 0A000h
        mov ds, cx
        mov es, cx
.loop:
        LD mov, cx, ax
        rep movsb
        LD add, di, bx
        LD add, si, bx
        dec word [byte ebp+010h]
        jne short vgacopy_pages.loop
        mov dx, 3C5h
        pop ax
        out dx, al
        pop ax
        mov dx, 3CFh
        out dx, al
        pop si
        pop di
        pop ds
        pop bp
        ret
        db 00h,00h
;-----------------------------------------------------------------------------
; vtoa                                                  8C8E8  94G logic94.asm
; : (x,y) vector -> direction 0-7 via vtoa_dt.
; .dir/.0-.3 follow the x sign -> bit0, y sign -> bit1,
; |x| vs |y| (and 2x) comparisons -> bits 2/3, then the table lookup.
;-----------------------------------------------------------------------------
vtoa:
        push ebp
        LD mov, ebp, esp
        push ebx
        push ecx
        push edx
        LD mov, cx, ax
        LD or, ax, dx
        jne short .dir
        mov ax, 8
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
.dir:
        mov ebx, 0
        cmp cx, byte 0
        jge short .0
        neg cx
        or ebx, byte 1
.0:
        LD or, dx, dx
        jge short .1
        neg dx
        or ebx, byte 2
.1:
        LD mov, ax, dx
        shl dx, 1
        LD cmp, dx, cx
        jb short .2
        or ebx, byte 4
.2:
        shl cx, 1
        LD cmp, cx, ax
        jb short .3
        or ebx, byte 8
.3:
        mov al, byte [dword ebx+vtoa_dt]
        cbw
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h
;-----------------------------------------------------------------------------
; SaveSS                                       8C944  95 PC, medium confidence
; saved_ss = SS.
;-----------------------------------------------------------------------------
SaveSS:
        o16 mov word [saved_ss], ss
        ret
