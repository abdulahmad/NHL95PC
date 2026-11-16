; The rink picture. Load the home arena's tiles and scroll them.
bits 32
%include "hockey.inc"
section s_3377C progbits alloc exec nowrite align=1
extern __CHK, bgscrollx, bgscrolly, cddriveptr, currink, FadePalStep, FatalError, editx
extern fileoncd, FreeMemBlock, GetInputEvent, GetTicks, MakePath, ptrupdatefn, rinkarenas, rinkbm
extern rinkfileidx, rinkhtiles, rinkscrollx, rinkscrolly, rinktilebm, rinkwtiles, scrollx, scrolly
extern SetDrawBitmap, str_CRESTS3, str_ErrorLoadingFile, str_extBIN, str_InvalidFileSize, str_Map, str_Pal16, str_Rink2
extern str_Til, str_TILES, SetZoneFlags, SetHiddenWindow, SelectHiddenWindow, SetBackgroundWindow, EraseZones, SetZoneScreen
extern SetZoneOrigin, AllocMemBlock, MemPtrSize, LoadBank, OpenArtArchiveErr, SetPalette, DrawShape, GetFileSize
extern LoadFileToBlockShared, FindShape, CreateBitmap, deskbankname
global LoadRink, BlitTileMap, SetRinkScroll, WaitClickTimeout, LoadCrestsPalette
;-----------------------------------------------------------------------------
; LoadRink                                                        3377C  95 PC
; (team): builds the home arena's rink bitmap (4Ah x 30h tiles) from rink.til
; / TILES and the arena's .map overlays (rinkarenas), skips if currink
; already matches, then resets the game display
;-----------------------------------------------------------------------------
; C: src/front/rink_tiles/LoadRink.c
%ifdef CBUILD
%include "c/front/rink_tiles/LoadRink.inc"
%else
LoadRink:
        push dword 48h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 20h
        mov edi, eax
        mov edx, dword [rinkbm]
        test edx, edx
        je short .1
        push edx
        call MemPtrSize
        add esp, byte 4
        cmp eax, 37840h
        je short .1
        mov ecx, dword [rinkbm]
        push ecx
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [rinkbm], esi
.1:
        mov ebp, dword [rinktilebm]
        test ebp, ebp
        je short .2
        push ebp
        call MemPtrSize
        add esp, byte 4
        cmp eax, 37840h
        je short .2
        mov edx, dword [rinktilebm]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [rinktilebm], ebx
.2:
        mov ecx, dword [rinktilebm]
        test ecx, ecx
        jne short .3
        push ecx
        push dword 250h
        push dword 180h
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [rinktilebm], eax
        mov dword [currink], 0FFFFFFFFh
.3:
        cmp edi, dword [currink]
        je near .13
        xor ecx, ecx
        mov ebx, str_Rink2
        cmp byte [fileoncd+015Bh], 1
        jne short .4
        mov edx, dword [cddriveptr]
        jmp short .5
.4:
        xor edx, edx
.5:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call LoadBank
        mov esi, eax
        add esp, byte 8
        mov word [rinkhtiles], 4Ah
        mov word [rinkwtiles], 30h
        mov eax, dword [rinktilebm]
        push eax
        call SetDrawBitmap
        add esp, byte 4
        push str_Rink2
        push esi
        call FindShape
        add esp, byte 8
        push eax
        call DrawShape
        add esp, byte 4
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ecx, str_Til
        mov esi, edi
        shl esi, 2
        sub esi, edi
        shl esi, 2
        mov ebx, rinkarenas
        add ebx, esi
        mov eax, dword [nosplit edi*4+rinkfileidx]
        cmp byte [dword eax+fileoncd+01h], 1
        jne short .6
        mov edx, dword [cddriveptr]
        jmp short .7
.6:
        xor edx, edx
.7:
        mov eax, esp
        call MakePath
        mov eax, esp
        push eax
        call GetFileSize
        add esp, byte 4
        mov word [byte esp+01Ch], ax
        movsx esi, ax
        mov ebx, 40h
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .8
        push esi
        lea eax, [byte esp+04h]
        push eax
        push str_InvalidFileSize
        call FatalError
        add esp, byte 0Ch
.8:
        push byte 0
        mov eax, dword [byte esp+01Eh]
        sar eax, 10h
        push eax
        push str_TILES
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+010h], eax
        push eax
        lea eax, [byte esp+04h]
        push eax
        call LoadFileToBlockShared
        add esp, byte 8
        test eax, eax
        jne short .9
        mov eax, esp
        push eax
        push str_ErrorLoadingFile
        call FatalError
        add esp, byte 8
.9:
        mov ecx, str_Map
        mov esi, edi
        shl esi, 2
        sub esi, edi
        shl esi, 2
        mov ebx, rinkarenas
        add ebx, esi
        mov eax, dword [nosplit edi*4+rinkfileidx]
        cmp byte [dword eax+fileoncd], 1
        jne short .10
        mov edx, dword [cddriveptr]
        jmp short .11
.10:
        xor edx, edx
.11:
        mov eax, esp
        call MakePath
        push byte 0
        lea eax, [byte esp+04h]
        push eax
        call OpenArtArchiveErr
        mov ebp, eax
        add esp, byte 8
        mov dword [byte esp+014h], eax
        mov edx, dword [byte esp+01Ah]
        sar edx, 10h
        mov eax, edx
        sar edx, 1Fh
        shl edx, 6
        LD sbb, eax, edx
        sar eax, 6
        mov edx, eax
        push byte 0
        mov esi, edi
        shl esi, 2
        sub esi, edi
        shl esi, 2
        mov eax, dword [dword esi+rinkarenas+2]
        sar eax, 10h
        push eax
        mov ecx, dword [dword esi+rinkarenas+4]
        sar ecx, 10h
        movsx eax, dx
        mov dword [byte esp+020h], eax
        mov ebx, eax
        mov edx, dword [byte esp+018h]
        mov eax, ebp
        call BlitTileMap
        cmp word [dword esi+rinkarenas+8], byte 0
        jle short .12
        push dword 6000h
        mov eax, dword [dword esi+rinkarenas+6]
        sar eax, 10h
        push eax
        mov ecx, dword [dword esi+rinkarenas+8]
        sar ecx, 10h
        mov ebx, dword [byte esp+020h]
        mov edx, dword [byte esp+018h]
        mov eax, ebp
        call BlitTileMap
.12:
        mov edx, dword [byte esp+014h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        mov ebx, dword [byte esp+010h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        mov dword [currink], edi
.13:
        mov dx, word [rinkwtiles]
        shl edx, 3
        mov eax, dword [rinktilebm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+04h], dx
        mov dx, word [rinkhtiles]
        shl edx, 3
        mov eax, dword [rinktilebm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+06h], dx
        mov esi, dword [rinktilebm]
        mov eax, dword [byte esi+02Ch]
        mov byte [eax], 0
        mov edx, dword [byte esi+02Ch]
        and dword [edx], 0FFh
        mov edx, dword [rinktilebm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Eh], 0
        mov ax, word [byte edx+0Eh]
        mov edx, dword [rinktilebm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Ch], ax
        mov edx, dword [rinktilebm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Ah], ax
        mov edx, eax
        mov eax, dword [rinktilebm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+08h], dx
        mov esi, dword [rinkbm]
        test esi, esi
        jne short .14
        push esi
        push dword 250h
        push dword 180h
        call CreateBitmap
        add esp, byte 0Ch
        mov dword [rinkbm], eax
.14:
        mov dx, word [rinkwtiles]
        shl edx, 3
        mov eax, dword [rinkbm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+04h], dx
        mov dx, word [rinkhtiles]
        shl edx, 3
        mov eax, dword [rinkbm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+06h], dx
        mov esi, dword [rinkbm]
        mov eax, dword [byte esi+02Ch]
        mov byte [eax], 0
        mov edx, dword [byte esi+02Ch]
        and dword [edx], 0FFh
        mov edx, dword [rinkbm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Eh], 0
        mov ax, word [byte edx+0Eh]
        mov edx, dword [rinkbm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Ch], ax
        mov edx, dword [rinkbm]
        mov edx, dword [byte edx+02Ch]
        mov word [byte edx+0Ah], ax
        mov edx, eax
        mov eax, dword [rinkbm]
        mov eax, dword [byte eax+02Ch]
        mov word [byte eax+08h], dx
        mov esi, dword [rinkhtiles-2]
        sar esi, 10h
        shl esi, 2
        sub esi, byte 3Ch
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        shl edx, 3
        LD sbb, eax, edx
        sar eax, 3
        mov word [bgscrolly], ax
        mov ebx, 8
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov word [scrolly], dx
        mov esi, dword [rinkwtiles-2]
        sar esi, 10h
        shl esi, 2
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        sub eax, byte 14h
        mov word [bgscrollx], ax
        mov eax, esi
        mov edx, esi
        sar edx, 1Fh
        idiv ebx
        mov word [scrollx], dx
        mov eax, 180h
        call SetZoneFlags
        xor edx, edx
        xor eax, eax
        call SetZoneOrigin
        mov ecx, 250h
        mov ebx, 180h
        xor edx, edx
        xor eax, eax
        call SetZoneScreen
        mov eax, dword [rinkbm]
        call SetHiddenWindow
        mov eax, dword [rinktilebm]
        call SetBackgroundWindow
        mov eax, 1
        call SetZoneFlags
        call SelectHiddenWindow
        call EraseZones
        add esp, byte 20h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; BlitTileMap                                                     33C08  95 PC
; Draws a .map block of 8x8 tiles (bit 4000h v-flip, 2000h h-flip, colour FFh
; transparent) into rinktilebm
;-----------------------------------------------------------------------------
BlitTileMap:
        push dword 2Ch
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        push eax
        push edx
        push ecx
        mov ax, word [byte eax+02h]
        mov word [byte esp+018h], ax
        mov eax, dword [byte esp+08h]
        mov ax, word [eax]
        mov word [byte esp+014h], ax
        xor edx, edx
        mov dword [byte esp+0Ch], edx
        add dword [byte esp+08h], byte 6
        jmp near .20
.1:
        xor esi, esi
        mov dword [byte esp+010h], esi
        jmp near .19
.2:
        imul eax, dword [byte esp+0Ch]
        add eax, eax
        add eax, dword [byte esp+08h]
        lea ebx, [edi+edi]
        movsx eax, word [ebx+eax]
        mov ebp, eax
        and ebp, 4000h
        mov esi, dword [byte esp+02Eh]
        sar esi, 10h
        xor ebp, esi
        mov edx, eax
        and edx, 2000h
        xor esi, edx
        and eax, 3FFh
        shl eax, 6
        mov edx, dword [byte esp+04h]
        add edx, eax
        cmp word [byte esp+030h], byte 0
        je short .3
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        mov edi, dword [byte esp+0Ch]
        add eax, edi
        add edi, edi
        sub eax, edi
        mov edi, eax
        mov eax, dword [rinkwtiles-2]
        sar eax, 10h
        imul edi, eax
        shl edi, 6
        mov eax, dword [byte esp+02Ah]
        sar eax, 10h
        add eax, dword [byte esp+010h]
        sub eax, ebx
        shl eax, 3
        add edi, eax
        mov eax, dword [rinktilebm]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        add eax, edi
        jmp short .4
.3:
        mov eax, dword [byte esp-02h]
        sar eax, 10h
        mov ebx, dword [byte esp+0Ch]
        add ebx, eax
        mov eax, dword [rinkwtiles-2]
        sar eax, 10h
        imul ebx, eax
        shl ebx, 6
        mov eax, dword [byte esp+02Ah]
        sar eax, 10h
        add eax, edi
        shl eax, 3
        add ebx, eax
        mov eax, dword [rinktilebm]
        mov eax, dword [byte eax+02Ch]
        add eax, byte 10h
        add eax, ebx
.4:
        test ebp, ebp
        je short .5
        mov edi, dword [rinkwtiles-2]
        sar edi, 10h
        mov ebx, edi
        shl ebx, 3
        sub ebx, edi
        shl ebx, 3
        add eax, ebx
        test esi, esi
        je short .7
        jmp short .6
.5:
        test esi, esi
        je short .7
.6:
        add eax, byte 7
.7:
        xor edi, edi
.8:
        xor ebx, ebx
.9:
        mov cl, byte [edx]
        cmp cl, 0FFh
        je short .10
        mov byte [eax], cl
.10:
        inc edx
        test esi, esi
        je short .11
        dec eax
        jmp short .12
.11:
        inc eax
.12:
        inc ebx
        cmp ebx, byte 8
        jl short BlitTileMap.9
        test ebp, ebp
        je short .15
        test esi, esi
        je short .14
        mov ebx, dword [rinkwtiles-2]
        sar ebx, 10h
        shl ebx, 3
        sub eax, ebx
.13:
        add eax, byte 8
        jmp short .18
.14:
        mov ebx, dword [rinkwtiles-2]
        sar ebx, 10h
        shl ebx, 3
        sub eax, ebx
        jmp short .17
.15:
        test esi, esi
        je short .16
        mov ebx, dword [rinkwtiles-2]
        sar ebx, 10h
        shl ebx, 3
        add eax, ebx
        jmp short BlitTileMap.13
.16:
        mov ebx, dword [rinkwtiles-2]
        sar ebx, 10h
        shl ebx, 3
        add eax, ebx
.17:
        sub eax, byte 8
.18:
        inc edi
        cmp edi, byte 8
        jl short BlitTileMap.8
        inc dword [byte esp+010h]
.19:
        mov eax, dword [byte esp+012h]
        sar eax, 10h
        mov edi, dword [byte esp+010h]
        cmp eax, edi
        jg near BlitTileMap.2
        inc dword [byte esp+0Ch]
.20:
        mov eax, dword [byte esp+016h]
        sar eax, 10h
        cmp eax, dword [byte esp+0Ch]
        jg near BlitTileMap.1
        add esp, byte 1Ch
        pop ebp
        pop edi
        pop esi
        ret 8
;-----------------------------------------------------------------------------
; SetRinkScroll                                                   33DD3  95 PC
; (x, y): sets bgscrollx / bgscrolly (tiles) and scrollx / scrolly (pixels)
; when the position changed
;-----------------------------------------------------------------------------
; C: src/front/rink_tiles/SetRinkScroll.c
%ifdef CBUILD
%include "c/front/rink_tiles/SetRinkScroll.inc"
%else
SetRinkScroll:
        push dword 10h
        call __CHK
        push ebx
        push ecx
        push esi
        mov ebx, eax
        mov ecx, edx
        xor edx, edx
        mov esi, eax
        neg esi
        cmp esi, dword [rinkscrollx]
        je short .1
        mov edx, eax
        sar edx, 3
        mov word [bgscrollx], dx
        mov esi, 8
        mov edx, eax
        sar edx, 1Fh
        idiv esi
        mov word [scrollx], dx
        mov edx, 1
.1:
        mov esi, ecx
        neg esi
        cmp esi, dword [rinkscrolly]
        je short .2
        mov edx, ecx
        sar edx, 3
        mov word [bgscrolly], dx
        mov esi, 8
        mov eax, ecx
        mov edx, ecx
        sar edx, 1Fh
        idiv esi
        mov word [scrolly], dx
        mov edx, 1
.2:
        test edx, edx
        je short .x
        neg ebx
        mov dword [rinkscrollx], ebx
        neg ecx
        mov dword [rinkscrolly], ecx
        mov eax, 3
        call SetZoneFlags
.x:
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; WaitClickTimeout                             33E6A  95 PC, medium confidence
; (ticks): waits for a mouse click or the timeout; returns the click count
; (second click within 14h ticks, 3 for button bit 4)
;-----------------------------------------------------------------------------
; C: src/front/rink_tiles/WaitClickTimeout.c
%ifdef CBUILD
%include "c/front/rink_tiles/WaitClickTimeout.inc"
%else
WaitClickTimeout:
        push dword 30h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        push edi
        push ebp
        sub esp, byte 10h
        push eax
        call GetTicks
        mov dword [byte esp+0Ch], eax
        xor edi, edi
        xor esi, esi
.1:
        call GetInputEvent
        test eax, eax
        je short .5
        lea ebx, [byte esp+04h]
        lea edx, [byte esp+08h]
        call dword [ptrupdatefn]
        mov dword [byte esp+010h], eax
        test al, 2
        je short .4
        test esi, esi
        jne short .2
        call GetTicks
        mov ebp, eax
        jmp short .3
.2:
        mov edi, 0FFFFFFFFh
.3:
        inc esi
.4:
        test byte [byte esp+010h], 4
        je short .5
        mov esi, 3
        mov edi, 0FFFFFFFFh
.5:
        call GetTicks
        mov edx, eax
        test esi, esi
        je short .6
        sub eax, ebp
        cmp eax, byte 14h
        jle short .6
        mov edi, 0FFFFFFFFh
.6:
        test edi, edi
        jne short .7
        mov ebx, dword [byte esp+0Ch]
        mov eax, edx
        sub eax, ebx
        cmp eax, dword [esp]
        jl short WaitClickTimeout.1
.7:
        mov eax, esi
        add esp, byte 14h
        pop ebp
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadCrestsPalette                            33F02  95 PC, medium confidence
; Unused: builds a palette from CRESTS3.BIN colours 160-255 and the !pal
; block, then sets it
;-----------------------------------------------------------------------------
; C: src/front/rink_tiles/LoadCrestsPalette.c
%ifdef CBUILD
%include "c/front/rink_tiles/LoadCrestsPalette.inc"
%else
LoadCrestsPalette:
        push dword 330h
        call __CHK
        push ebx
        push ecx
        push edx
        push esi
        sub esp, 310h
        mov eax, esp
        push eax
        push dword 100h
        push byte 0
        call SetPalette
        add esp, byte 0Ch
        mov ebx, 10h
        mov edx, esp
        mov eax, 1
        call FadePalStep
        mov ecx, str_extBIN
        mov ebx, str_CRESTS3
        cmp byte [fileoncd+055h], 1
        jne short .1
        mov edx, dword [cddriveptr]
        jmp short .2
.1:
        xor edx, edx
.2:
        lea eax, [dword esp+0300h]
        call MakePath
        push byte 0
        lea eax, [dword esp+0304h]
        push eax
        call OpenArtArchiveErr
        add esp, byte 8
        mov esi, eax
        mov eax, 1E0h
.3:
        mov dl, byte [dword esi+eax-01E0h]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 300h
        jl short LoadCrestsPalette.3
        push esi
        call FreeMemBlock
        add esp, byte 4
        push byte 0
        push deskbankname
        call LoadBank
        add esp, byte 8
        mov esi, eax
        push str_Pal16
        push eax
        call FindShape
        add esp, byte 8
        lea ebx, [byte eax+010h]
        xor eax, eax
.4:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 180h
        jl short LoadCrestsPalette.4
        mov eax, 2F1h
.5:
        mov dl, byte [ebx+eax]
        mov byte [esp+eax], dl
        inc eax
        cmp eax, 2FDh
        jl short LoadCrestsPalette.5
        push esi
        call FreeMemBlock
        add esp, byte 4
        mov ebx, 10h
        mov edx, esp
        xor eax, eax
        call FadePalStep
        add esp, 310h
        pop esi
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
