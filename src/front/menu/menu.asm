; Mouse menus. Running a menu, picking a team or a player, and the comparisons that sort the stat lists.
bits 32
%include "hockey.inc"
section s_1D6E8 progbits alloc exec nowrite align=1
extern __CHK, __STOSB, ClearInputQueue, DeskSetExit3b, DrawMenuDropdown, DrawMenuItemNorm, DrawMenuItemSel, FileClose
extern FileOpenRead, FileReadAt, FreeMemBlock, GetInputEvent, memcmp_, memcpy_, MenuHitTest, menuremap
extern menuremap2, mi_9394Playoffs, mi_9394Season, mi_LeaguePlayoffs, mi_LeagueSeason, mi_PlayoffMode, mousepollfn, MouseSetPos
extern MoveTreeHighlight, PlayerFromMouseY, playofftree, PlayoffTreeHitTest, PlayoffTreeScreen, pointerspr, printfbuf, ptrupdatefn
extern ShowPlayerStatsItem, sprintf_, statscategory, statsgoaliebuf, statsgoalieorder, statsgoalieplr, statsnumgoalies, statsnumskaters
extern statspal, statspalvalid, statsplayer, statsplayerbuf, statsplayoffs, statsskaterbuf, statsskaterorder, statsskaterplr
extern statsteambuf, statsteamorder, statsteamsel, str_9394PlayOffs, str_9394Season, str_LgPlayoffsTitle, str_LgSeasonTitle, str_menubuff
extern str_PointerMenu, str_POTitle, str_sfh, str_shape, strcat_, strlen_, strncpy_, StrPrefixDiffers
extern AllocMemBlock, PutBlock, XorBar, DrawArt, GrabBlock, PrintString, SetViewRect, SetColorRemap
extern TeamFromMouse
global RunMenu, RunMenu_ret4, RunTeamPickMenu, RunPlayerPickMenu, InitMenuRemap, TextPrintf, TextPrintf2, CmpPoints
global CmpGAA, LoadShapeByTag, LoadShapeByTag_x, MakeStatsTitle
;-----------------------------------------------------------------------------
; RunMenu                                      1D6E8  95 PC, medium confidence
; Mouse-driven menu loop: saves "Pointer" bg, tracks mouse, hit-tests menu
; items (32-byte items, +14h action fn), calls action; eax=menu list,
; edx=count, ebx/ecx/stack=colors
;-----------------------------------------------------------------------------
RunMenu:
        push dword 0B4h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 8Ch
        push ebx
        push ecx
        xor ebx, ebx
        mov dword [dword esp+090h], ebx
        mov dword [byte esp+038h], eax
        mov dword [byte esp+058h], edx
        mov dword [byte esp+044h], ebx
        mov dword [byte esp+040h], ebx
        mov dword [byte esp+03Ch], ebx
        mov dword [byte esp+054h], ebx
        mov dword [byte esp+050h], ebx
        mov dword [byte esp+04Ch], ebx
        mov dword [byte esp+048h], ebx
        mov dword [byte esp+034h], ebx
        mov dword [byte esp+030h], ebx
        mov dword [byte esp+02Ch], ebx
        mov dword [byte esp+028h], ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+08h], ebx
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov ebx, dword [byte eax+04h]
        sar ebx, 10h
        inc ebx
        lea eax, [byte edx+01h]
        imul eax, ebx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_PointerMenu
        call AllocMemBlock
        mov ebx, eax
        add esp, byte 0Ch
        mov dword [dword esp+084h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+04h]
        inc eax
        mov word [byte ebx+04h], ax
        mov eax, dword [pointerspr]
        mov ax, word [byte eax+06h]
        inc eax
        mov word [byte ebx+06h], ax
        mov edx, dword [byte esp+038h]
        mov edx, dword [edx]
        mov eax, dword [byte esp+038h]
        mov ecx, dword [byte eax+08h]
        add edx, ecx
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+088h], eax
        mov dword [byte esp+074h], eax
        mov edx, dword [byte esp+038h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte esp+038h]
        mov esi, dword [byte eax+0Ch]
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+08Ch], eax
        mov dword [byte esp+070h], eax
        mov edi, eax
        push eax
        mov ebp, dword [dword esp+08Ch]
        push ebp
        push ebx
        call GrabBlock
        add esp, byte 0Ch
        mov eax, edi
        push eax
        push ebp
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        mov ecx, edi
        push ecx
        push ebp
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
.1:
        xor ecx, ecx
.2:
        call GetInputEvent
        test eax, eax
        je short .3
        lea ebx, [byte esp+070h]
        lea edx, [byte esp+074h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short RunMenu.2
.3:
        test cl, 2
        jne near .6
        mov eax, dword [byte esp+074h]
        cmp eax, dword [dword esp+088h]
        jne short .4
        mov eax, dword [byte esp+070h]
        cmp eax, dword [dword esp+08Ch]
        je short RunMenu.1
.4:
        mov ecx, dword [dword esp+08Ch]
        push ecx
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+070h]
        push ebp
        mov eax, dword [byte esp+078h]
        push eax
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+070h]
        push ebx
        mov ecx, dword [byte esp+078h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
.5:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+074h]
        mov dword [dword esp+088h], eax
        mov eax, dword [byte esp+070h]
        mov dword [dword esp+08Ch], eax
        jmp near RunMenu.1
.6:
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+064h]
        push eax
        mov ecx, dword [dword esp+0A0h]
        lea ebx, [byte esp+048h]
        mov edx, dword [dword esp+080h]
        mov eax, dword [dword esp+084h]
        call MenuHitTest
        test eax, eax
        je near .23
        mov edx, dword [byte esp+06Ch]
        shl edx, 2
        mov ebx, dword [byte esp+068h]
        shl ebx, 5
        mov eax, dword [byte esp+edx+038h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .11
        mov eax, dword [byte esp+068h]
        cmp eax, dword [byte esp+edx+028h]
        jne near .10
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .9
.7:
        mov ebp, esi
        shl ebp, 2
        mov ebx, dword [byte esp+ebp+048h]
        test ebx, ebx
        je short .8
        mov ecx, dword [byte esp+esi*8+0Ch]
        push ecx
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [byte esp+esi*8+0Ch], ebx
        mov dword [byte esp+esi*8+08h], ebx
        mov ecx, dword [byte esp+ebp+048h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
.8:
        dec esi
.9:
        test esi, esi
        jge short RunMenu.7
        xor edi, edi
        mov dword [dword esp+090h], edi
        mov eax, dword [byte esp+06Ch]
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+eax*4+038h]
        call dword [byte edx+eax+014h]
        mov dword [byte esp+044h], edi
        mov dword [byte esp+040h], edi
        mov dword [byte esp+03Ch], edi
        mov dword [byte esp+054h], edi
        mov dword [byte esp+050h], edi
        mov dword [byte esp+04Ch], edi
        mov dword [byte esp+048h], edi
        mov dword [byte esp+034h], edi
        mov dword [byte esp+030h], edi
        mov dword [byte esp+02Ch], edi
        mov dword [byte esp+064h], edi
        mov dword [byte esp+060h], edi
        mov dword [byte esp+05Ch], edi
        cmp eax, byte 1
        je near .28
        mov eax, dword [dword esp+08Ch]
        push eax
        mov edx, dword [dword esp+08Ch]
        push edx
        call MouseSetPos
        add esp, byte 8
        mov eax, dword [dword esp+088h]
        mov dword [byte esp+074h], eax
        mov eax, dword [dword esp+08Ch]
        mov dword [byte esp+070h], eax
        call ClearInputQueue
        jmp near .22
.10:
        mov ecx, dword [dword esp+08Ch]
        push ecx
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+0A4h]
        push ebp
        mov eax, dword [byte esp+04h]
        push eax
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+030h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+040h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+028h], eax
        push ebp
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+edx*8+014h]
        mov eax, dword [byte esp+edx*8+010h]
        mov esi, dword [byte esp+edx*4+030h]
        shl esi, 5
        mov edx, dword [byte esp+edx*4+040h]
        add esi, edx
        mov ecx, dword [byte esp+0Ch]
        mov edx, eax
        mov eax, esi
        jmp near .21
.11:
        cmp dword [byte eax+018h], byte 0
        je near .20
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+090h]
        cmp eax, dword [byte esp+06Ch]
        je short .15
        mov esi, eax
        jmp short .14
.12:
        mov edi, esi
        shl edi, 2
        xor ebp, ebp
        mov dword [byte esp+edi+028h], ebp
        mov eax, dword [byte esp+edi+048h]
        test eax, eax
        je short .13
        mov ebp, esi
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        mov ebx, dword [byte esp+esi*8+0Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+0Ch], eax
        mov dword [byte esp+esi*8+08h], eax
        mov edx, dword [byte esp+edi+048h]
        push edx
        call FreeMemBlock
        add esp, byte 4
        xor ebx, ebx
        mov dword [byte esp+edi+048h], ebx
        mov dword [byte esp+edi+038h], ebx
        xor ebp, esi
        mov dword [byte esp+edi+058h], ebp
.13:
        dec esi
.14:
        mov ecx, dword [byte esp+06Ch]
        cmp esi, ecx
        jg short RunMenu.12
        mov dword [dword esp+090h], ecx
.15:
        mov eax, dword [dword esp+0A4h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        mov esi, dword [dword esp+098h]
        mov ebx, dword [byte esp+esi*8+014h]
        mov edx, dword [byte esp+esi*8+010h]
        mov ecx, dword [byte esp+esi*4+030h]
        shl ecx, 5
        mov eax, dword [byte esp+esi*4+040h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+esi*4+028h], eax
        mov ebx, dword [dword esp+0A4h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+esi*8+014h]
        mov edx, dword [byte esp+esi*8+010h]
        shl eax, 5
        mov ecx, dword [byte esp+esi*4+040h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemNorm
        mov eax, dword [byte esp+06Ch]
        mov ebx, dword [byte esp+068h]
        shl ebx, 5
        mov ecx, dword [byte esp+eax*4+038h]
        inc esi
        mov dword [dword esp+090h], esi
        mov ecx, dword [byte ecx+ebx+018h]
        mov dword [byte esp+esi*4+038h], ecx
        mov eax, dword [byte esp+eax*4+038h]
        add eax, ebx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte esp+esi*4+058h], ebx
        cmp esi, byte 1
        je short .16
        mov edx, dword [byte eax+08h]
        jmp short .17
.16:
        mov edx, dword [eax]
.17:
        mov eax, dword [dword esp+090h]
        mov ebp, dword [esp+eax*8]
        add edx, ebp
        mov dword [byte esp+eax*8+08h], edx
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+06Ch]
        shl eax, 2
        cmp dword [dword esp+090h], byte 1
        je short .18
        mov eax, dword [byte esp+eax+038h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .19
.18:
        mov eax, dword [byte esp+eax+038h]
        mov eax, dword [byte edx+eax+0Ch]
.19:
        mov edx, dword [dword esp+090h]
        shl edx, 3
        mov dword [dword esp+080h], edx
        mov ecx, dword [byte esp+edx+04h]
        add eax, ecx
        mov dword [byte esp+edx+0Ch], eax
        mov ebp, dword [dword esp+090h]
        mov edx, dword [byte esp+ebp*4+058h]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+038h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [byte esp+07Ch], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte esp+078h], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_menubuff
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+048h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [byte esp+07Ch]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [byte esp+078h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+080h]
        mov ebx, dword [byte esp+eax+0Ch]
        push ebx
        mov ecx, dword [byte esp+eax+0Ch]
        push ecx
        mov esi, dword [byte esp+ebp*4+050h]
        push esi
        call GrabBlock
        add esp, byte 0Ch
        mov edi, dword [dword esp+0A4h]
        push edi
        mov eax, dword [byte esp+04h]
        push eax
        mov edx, dword [byte esp+0Ch]
        push edx
        mov ecx, dword [dword esp+08Ch]
        mov ecx, dword [byte esp+ecx+018h]
        mov ebx, dword [dword esp+08Ch]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [byte esp+ebp*4+064h]
        mov eax, dword [byte esp+ebp*4+044h]
        call DrawMenuDropdown
        xor ebx, ebx
        mov dword [byte esp+ebp*4+028h], ebx
        push edi
        mov esi, dword [byte esp+04h]
        push esi
        mov ebx, dword [dword esp+088h]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [dword esp+088h]
        mov edx, dword [byte esp+edx+010h]
        mov eax, dword [byte esp+ebp*4+040h]
        mov ecx, dword [byte esp+0Ch]
        jmp near .21
.20:
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0A4h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+030h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+040h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+028h], eax
        mov ebx, dword [dword esp+0A4h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+edx*8+014h]
        mov esi, dword [byte esp+edx*8+010h]
        shl eax, 5
        mov edx, dword [byte esp+edx*4+040h]
        add eax, edx
        mov ecx, dword [byte esp+0Ch]
        mov edx, esi
.21:
        call DrawMenuItemNorm
.22:
        mov esi, dword [dword esp+08Ch]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        jmp near .27
.23:
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        mov eax, dword [dword esp+08Ch]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .26
.24:
        mov ebp, esi
        shl ebp, 2
        mov edx, dword [byte esp+ebp+048h]
        test edx, edx
        je short .25
        mov ebx, dword [byte esp+esi*8+0Ch]
        push ebx
        mov ecx, dword [byte esp+esi*8+0Ch]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [byte esp+esi*8+0Ch], edx
        mov dword [byte esp+esi*8+08h], edx
        mov ebx, dword [byte esp+ebp+048h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
.25:
        dec esi
.26:
        test esi, esi
        jge short RunMenu.24
        xor edi, edi
        mov dword [dword esp+090h], edi
        mov dword [byte esp+044h], edi
        mov dword [byte esp+040h], edi
        mov dword [byte esp+03Ch], edi
        mov dword [byte esp+054h], edi
        mov dword [byte esp+050h], edi
        mov dword [byte esp+04Ch], edi
        mov dword [byte esp+048h], edi
        mov dword [byte esp+034h], edi
        mov dword [byte esp+030h], edi
        mov dword [byte esp+02Ch], edi
        mov dword [byte esp+064h], edi
        mov dword [byte esp+060h], edi
        mov dword [byte esp+05Ch], edi
        mov edi, dword [dword esp+08Ch]
        push edi
        mov ebp, dword [dword esp+08Ch]
        push ebp
        mov eax, dword [dword esp+08Ch]
        push eax
.27:
        call GrabBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+08Ch]
        push eax
        mov edx, dword [dword esp+08Ch]
        push edx
        mov ebx, dword [dword esp+08Ch]
        push ebx
        call PutBlock
        add esp, byte 0Ch
        mov ecx, dword [byte esp+070h]
        push ecx
        mov esi, dword [byte esp+078h]
        push esi
        mov edi, dword [dword esp+08Ch]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+070h]
        push ebp
        mov eax, dword [byte esp+078h]
        push eax
        mov edx, dword [pointerspr]
        push edx
        jmp near RunMenu.5
.28:
        mov ebx, dword [dword esp+084h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        add esp, 94h
RunMenu_ret4:
        pop ebp
        pop edi
        pop esi
        ret 4
;-----------------------------------------------------------------------------
; RunTeamPickMenu                              1DF03  95 PC, medium confidence
; RunMenu variant with a 26-team picker (statsteamorder / playofftree), sets
; statscategory + statsteamsel; used by EASN team stats screens
;-----------------------------------------------------------------------------
RunTeamPickMenu:
        push dword 0C4h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 98h
        push ebx
        push ecx
        xor ebx, ebx
        mov dword [byte esp+074h], ebx
        mov dword [byte esp+070h], ebx
        mov dword [dword esp+098h], ebx
        mov dword [byte esp+058h], eax
        mov dword [byte esp+028h], edx
        mov dword [byte esp+064h], ebx
        mov dword [byte esp+060h], ebx
        mov dword [byte esp+05Ch], ebx
        mov dword [byte esp+054h], ebx
        mov dword [byte esp+050h], ebx
        mov dword [byte esp+04Ch], ebx
        mov dword [byte esp+048h], ebx
        mov dword [byte esp+044h], ebx
        mov dword [byte esp+040h], ebx
        mov dword [byte esp+03Ch], ebx
        mov dword [byte esp+038h], ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+08h], ebx
        mov eax, dword [pointerspr]
        mov edx, dword [byte eax+02h]
        sar edx, 10h
        mov eax, dword [byte eax+04h]
        sar eax, 10h
        inc eax
        inc edx
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_PointerMenu
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+08Ch], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte esp+058h]
        mov edx, dword [edx]
        mov eax, dword [byte esp+058h]
        mov esi, dword [byte eax+08h]
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+090h], eax
        mov dword [byte esp+07Ch], eax
        mov edx, dword [byte esp+058h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte esp+058h]
        mov edi, dword [byte eax+0Ch]
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+094h], eax
        mov dword [byte esp+078h], eax
        cmp dword [statsplayoffs], byte 0
        jne near .9
        xor esi, esi
        mov edx, dword [statsteamsel]
.1:
        cmp edx, dword [nosplit esi*4+statsteamorder]
        jne short .2
        mov dword [byte esp+070h], esi
.2:
        inc esi
        cmp esi, byte 1Ah
        jl short RunTeamPickMenu.1
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        mov dl, byte [byte edx+eax*2+0Dh]
        and edx, 0FFh
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .3
        mov esi, 14Ah
        jmp short .4
.3:
        mov esi, 0A5h
.4:
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        cmp byte [byte edx+eax*2+0Dh], 2
        jae short .5
        xor ebx, ebx
        jmp short .6
.5:
        mov ebx, 140h
.6:
        mov ecx, dword [byte esp+070h]
        cmp ecx, byte 0Ch
        jge short .7
        mov ecx, 6
        mov eax, dword [byte esp+070h]
        mov edx, eax
        jmp short .8
.7:
        lea edx, [byte ecx-0Ch]
        mov ecx, 7
        mov eax, edx
.8:
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        push dword 80h
        push byte 0Dh
        push dword 140h
        push esi
        push ebx
        call XorBar
        add esp, byte 14h
        jmp short .10
.9:
        mov eax, dword [statsteamsel]
        mov dword [byte esp+070h], eax
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        je short .10
        xor edx, edx
        lea eax, [byte esp+070h]
        call MoveTreeHighlight
.10:
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        call GrabBlock
        add esp, byte 0Ch
        push esi
        push edi
        mov ebx, dword [pointerspr]
        push ebx
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        push esi
        push edi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
        jmp near .19
.11:
        mov edi, esi
        shl edi, 2
        mov ebp, dword [byte esp+edi+048h]
        test ebp, ebp
        je short .12
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push ebp
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov ebp, dword [byte esp+edi+048h]
        push ebp
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        mov dword [byte esp+edi+048h], eax
        mov dword [byte esp+edi+058h], eax
        mov dword [byte esp+edi+028h], eax
.12:
        dec esi
.13:
        test esi, esi
        jge short RunTeamPickMenu.11
        xor edi, edi
        mov dword [dword esp+098h], edi
.14:
        call PlayoffTreeScreen
        mov eax, dword [byte esp+070h]
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        je short .15
        xor edx, edx
        lea eax, [byte esp+070h]
        call MoveTreeHighlight
.15:
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        call GrabBlock
        add esp, byte 0Ch
.16:
        mov eax, dword [byte esp+07Ch]
        cmp eax, dword [dword esp+090h]
        jne short .17
        mov eax, dword [byte esp+078h]
        cmp eax, dword [dword esp+094h]
        jne short .17
        cmp word [dword esp+09Ch], byte 0
        je short .19
.17:
        mov ecx, dword [dword esp+094h]
        push ecx
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+078h]
        push ebp
        mov eax, dword [dword esp+080h]
        push eax
        push edi
.18:
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+078h]
        push ebx
        mov ecx, dword [dword esp+080h]
        push ecx
        mov esi, dword [pointerspr]
        push esi
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+07Ch]
        mov dword [dword esp+090h], eax
        mov eax, dword [byte esp+078h]
        mov dword [dword esp+094h], eax
.19:
        xor ecx, ecx
.20:
        call GetInputEvent
        test eax, eax
        je short .21
        lea ebx, [byte esp+078h]
        lea edx, [byte esp+07Ch]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short RunTeamPickMenu.20
.21:
        test cl, 2
        jne short .22
        xor edx, edx
        mov dword [dword esp+09Ch], edx
        cmp dword [statsplayoffs], byte 1
        jne near RunTeamPickMenu.16
        mov edx, dword [dword esp+094h]
        push edx
        mov ecx, dword [dword esp+094h]
        mov ebx, dword [dword esp+090h]
        lea edx, [byte esp+074h]
        mov eax, dword [dword esp+080h]
        call PlayoffTreeHitTest
        mov dword [dword esp+09Ch], eax
        test ax, ax
        je near RunTeamPickMenu.16
        mov ebx, dword [dword esp+098h]
        test ebx, ebx
        je near RunTeamPickMenu.14
        mov esi, ebx
        jmp near RunTeamPickMenu.13
.22:
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+034h]
        push eax
        mov ecx, dword [dword esp+0A8h]
        lea ebx, [byte esp+068h]
        mov edx, dword [dword esp+088h]
        mov eax, dword [dword esp+08Ch]
        call MenuHitTest
        test eax, eax
        je near .60
        mov edx, dword [byte esp+06Ch]
        shl edx, 2
        mov ebx, dword [byte esp+068h]
        shl ebx, 5
        mov eax, dword [byte esp+edx+058h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .50
        mov eax, dword [byte esp+068h]
        cmp eax, dword [byte esp+edx+038h]
        jne near .48
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .25
.23:
        mov ebp, esi
        shl ebp, 2
        mov eax, dword [byte esp+ebp+048h]
        test eax, eax
        je short .24
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        mov ebx, dword [byte esp+esi*8+0Ch]
        push ebx
        push eax
        call PutBlock
        add esp, byte 0Ch
        xor eax, eax
        mov dword [byte esp+esi*8+0Ch], eax
        mov dword [byte esp+esi*8+08h], eax
        mov edx, dword [byte esp+ebp+048h]
        push edx
        call FreeMemBlock
        add esp, byte 4
.24:
        dec esi
.25:
        test esi, esi
        jge short RunTeamPickMenu.23
        xor esi, esi
        mov dword [dword esp+098h], esi
        mov eax, dword [byte esp+070h]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .26
        mov eax, dword [dword eax+statsteamorder]
        mov dword [byte esp+074h], eax
        mov dword [statscategory], eax
        jmp short .27
.26:
        mov eax, dword [dword eax+playofftree]
        mov dword [statscategory], eax
        mov eax, dword [byte esp+070h]
.27:
        mov dword [statsteamsel], eax
        cmp dword [statsplayoffs], byte 0
        jne near .34
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        mov dl, byte [byte edx+eax*2+0Dh]
        and edx, 0FFh
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .28
        mov esi, 14Ah
        jmp short .29
.28:
        mov esi, 0A5h
.29:
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        cmp byte [byte edx+eax*2+0Dh], 2
        jae short .30
        xor ebx, ebx
        jmp short .31
.30:
        mov ebx, 140h
.31:
        mov ecx, dword [byte esp+070h]
        cmp ecx, byte 0Ch
        jge short .32
        mov ecx, 6
        mov eax, dword [byte esp+070h]
        mov edx, eax
        jmp short .33
.32:
        lea edx, [byte ecx-0Ch]
        mov ecx, 7
        mov eax, edx
.33:
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        push dword 80h
        push byte 0Dh
        push dword 140h
        push esi
        push ebx
        call XorBar
        add esp, byte 14h
        jmp short .35
.34:
        mov eax, dword [statsteamsel]
        mov dword [byte esp+070h], eax
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        je short .35
        xor edx, edx
        lea eax, [byte esp+070h]
        call MoveTreeHighlight
.35:
        mov eax, dword [byte esp+06Ch]
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+eax*4+058h]
        call dword [byte edx+eax+014h]
        xor esi, esi
        mov dword [byte esp+064h], esi
        mov dword [byte esp+060h], esi
        mov dword [byte esp+05Ch], esi
        mov dword [byte esp+050h], esi
        mov dword [byte esp+04Ch], esi
        mov dword [byte esp+048h], esi
        mov dword [byte esp+044h], esi
        mov dword [byte esp+040h], esi
        mov dword [byte esp+03Ch], esi
        mov dword [byte esp+034h], esi
        mov dword [byte esp+030h], esi
        mov dword [byte esp+02Ch], esi
        cmp eax, byte 1
        jne short .37
        mov ebp, dword [dword esp+08Ch]
        push ebp
.36:
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .86
.37:
        mov esi, dword [statsplayoffs]
        test esi, esi
        jne near .46
        mov eax, dword [byte esp+074h]
.38:
        cmp eax, dword [nosplit esi*4+statsteamorder]
        jne short .39
        mov dword [byte esp+070h], esi
.39:
        inc esi
        cmp esi, byte 1Ah
        jl short RunTeamPickMenu.38
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        mov dl, byte [byte edx+eax*2+0Dh]
        and edx, 0FFh
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .40
        mov esi, 14Ah
        jmp short .41
.40:
        mov esi, 0A5h
.41:
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add edx, eax
        add edx, edx
        mov eax, dword [statsteambuf]
        cmp byte [byte edx+eax+0Dh], 2
        jae short .42
        xor ebx, ebx
        jmp short .43
.42:
        mov ebx, 140h
.43:
        mov ecx, dword [byte esp+070h]
        cmp ecx, byte 0Ch
        jge short .44
        mov ecx, 6
        mov eax, dword [byte esp+070h]
        mov edx, eax
        jmp short .45
.44:
        lea edx, [byte ecx-0Ch]
        mov ecx, 7
        mov eax, edx
.45:
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        push dword 80h
        push byte 0Dh
        push dword 140h
        push esi
        push ebx
        call XorBar
        add esp, byte 14h
        jmp short .47
.46:
        mov eax, dword [statsteamsel]
        mov dword [byte esp+070h], eax
        cmp dword [nosplit eax*4+playofftree], byte 1Ah
        je short .47
        xor edx, edx
        lea eax, [byte esp+070h]
        call MoveTreeHighlight
.47:
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        call MouseSetPos
        add esp, byte 8
        mov dword [byte esp+07Ch], edi
        mov dword [byte esp+078h], esi
        call ClearInputQueue
        jmp near .85
.48:
        mov ecx, dword [dword esp+094h]
        push ecx
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+0B0h]
        push ebp
        mov eax, dword [byte esp+04h]
        push eax
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+040h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+060h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+038h], eax
        push ebp
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+edx*8+014h]
        mov eax, dword [byte esp+edx*8+010h]
        mov esi, dword [byte esp+edx*4+040h]
        shl esi, 5
        mov edx, dword [byte esp+edx*4+060h]
        add esi, edx
        mov ecx, dword [byte esp+0Ch]
        mov edx, eax
        mov eax, esi
.49:
        call DrawMenuItemNorm
        jmp near .85
.50:
        cmp dword [byte eax+018h], byte 0
        je near .59
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+098h]
        cmp eax, dword [byte esp+06Ch]
        je short .54
        mov esi, eax
        jmp short .53
.51:
        mov edi, esi
        shl edi, 2
        xor eax, eax
        mov dword [byte esp+edi+038h], eax
        mov edx, dword [byte esp+edi+048h]
        test edx, edx
        je short .52
        mov ebp, esi
        mov ebx, dword [byte esp+esi*8+0Ch]
        push ebx
        mov ecx, dword [byte esp+esi*8+0Ch]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [byte esp+esi*8+0Ch], edx
        mov dword [byte esp+esi*8+08h], edx
        mov ebx, dword [byte esp+edi+048h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [byte esp+edi+048h], ecx
        xor ebp, esi
        mov dword [byte esp+edi+058h], ebp
        mov dword [byte esp+edi+028h], ecx
.52:
        dec esi
.53:
        mov ebp, dword [byte esp+06Ch]
        cmp esi, ebp
        jg short RunTeamPickMenu.51
        mov dword [dword esp+098h], ebp
.54:
        mov edx, dword [dword esp+0B0h]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        mov edi, dword [dword esp+0A0h]
        mov ebx, dword [byte esp+edi*8+014h]
        mov edx, dword [byte esp+edi*8+010h]
        mov eax, dword [byte esp+edi*4+040h]
        shl eax, 5
        mov ecx, dword [byte esp+edi*4+060h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edi*4+038h], eax
        mov ecx, dword [dword esp+0B0h]
        push ecx
        mov ebp, dword [byte esp+04h]
        push ebp
        mov ebx, dword [byte esp+edi*8+014h]
        mov edx, dword [byte esp+edi*8+010h]
        shl eax, 5
        mov ecx, dword [byte esp+edi*4+060h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemNorm
        mov eax, dword [byte esp+06Ch]
        mov ecx, dword [byte esp+068h]
        shl ecx, 5
        mov ebx, dword [byte esp+eax*4+058h]
        lea edx, [byte edi+01h]
        mov dword [dword esp+098h], edx
        mov ebx, dword [byte ecx+ebx+018h]
        mov dword [byte esp+edx*4+058h], ebx
        mov eax, dword [byte esp+eax*4+058h]
        add eax, ecx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte esp+edx*4+028h], ebx
        cmp edx, byte 1
        je short .55
        mov edx, dword [byte eax+08h]
        jmp short .56
.55:
        mov edx, dword [eax]
.56:
        mov eax, dword [dword esp+098h]
        mov ecx, dword [esp+eax*8]
        add edx, ecx
        mov dword [byte esp+eax*8+08h], edx
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+06Ch]
        shl eax, 2
        cmp dword [dword esp+098h], byte 1
        je short .57
        mov eax, dword [byte esp+eax+058h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .58
.57:
        mov eax, dword [byte esp+eax+058h]
        mov eax, dword [byte edx+eax+0Ch]
.58:
        mov edx, dword [dword esp+098h]
        shl edx, 3
        mov dword [dword esp+088h], edx
        mov edi, dword [byte esp+edx+04h]
        add eax, edi
        mov dword [byte esp+edx+0Ch], eax
        mov ebp, dword [dword esp+098h]
        mov edx, dword [byte esp+ebp*4+028h]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+058h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+084h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [dword esp+080h], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_menubuff
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+048h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [dword esp+084h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [dword esp+080h]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+088h]
        mov edx, dword [byte esp+eax+0Ch]
        push edx
        mov ebx, dword [byte esp+eax+0Ch]
        push ebx
        mov ecx, dword [byte esp+ebp*4+050h]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0B0h]
        push esi
        mov edi, dword [byte esp+04h]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov ecx, dword [dword esp+094h]
        mov ecx, dword [byte esp+ecx+018h]
        mov ebx, dword [dword esp+094h]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [byte esp+ebp*4+034h]
        mov eax, dword [byte esp+ebp*4+064h]
        call DrawMenuDropdown
        xor edx, edx
        mov dword [byte esp+ebp*4+038h], edx
        push esi
        push edi
        mov ebx, dword [dword esp+090h]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [dword esp+090h]
        mov edx, dword [byte esp+edx+010h]
        mov eax, dword [byte esp+ebp*4+060h]
        mov ecx, dword [byte esp+0Ch]
        jmp near RunTeamPickMenu.49
.59:
        mov esi, dword [dword esp+094h]
        push esi
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+0B0h]
        push eax
        mov edx, dword [byte esp+04h]
        push edx
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+040h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+060h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+038h], eax
        mov ebx, dword [dword esp+0B0h]
        push ebx
        mov ecx, dword [byte esp+04h]
        push ecx
        mov ebx, dword [byte esp+edx*8+014h]
        mov esi, dword [byte esp+edx*8+010h]
        mov ecx, eax
        shl ecx, 5
        mov eax, dword [byte esp+edx*4+060h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        mov edx, esi
        jmp near RunTeamPickMenu.49
.60:
        mov edi, dword [dword esp+094h]
        push edi
        mov ebp, dword [dword esp+094h]
        push ebp
        mov eax, dword [dword esp+094h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [byte esp+074h]
        mov edx, dword [byte esp+078h]
        mov eax, dword [byte esp+07Ch]
        call TeamFromMouse
        test eax, eax
        je near .81
        mov edx, dword [byte esp+070h]
        shl edx, 2
        mov eax, dword [byte esp+070h]
        mov esi, dword [byte esp+074h]
        cmp eax, esi
        je near .74
        cmp dword [statsplayoffs], byte 0
        jne near .73
        mov edx, dword [dword edx+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        mov dl, byte [byte edx+eax*2+0Dh]
        and edx, 0FFh
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .61
        mov esi, 14Ah
        jmp short .62
.61:
        mov esi, 0A5h
.62:
        mov edx, dword [byte esp+070h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add edx, eax
        add edx, edx
        mov eax, dword [statsteambuf]
        cmp byte [byte edx+eax+0Dh], 2
        jae short .63
        xor ebx, ebx
        jmp short .64
.63:
        mov ebx, 140h
.64:
        mov edi, dword [byte esp+070h]
        cmp edi, byte 0Ch
        jge short .65
        mov ecx, 6
        mov eax, edi
        mov edx, edi
        jmp short .66
.65:
        lea edx, [byte edi-0Ch]
        mov ecx, 7
        mov eax, edx
.66:
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        push dword 80h
        push byte 0Dh
        push dword 140h
        push esi
        push ebx
        call XorBar
        add esp, byte 14h
        mov eax, dword [byte esp+074h]
        mov dword [byte esp+070h], eax
        mov edx, dword [nosplit eax*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        mov dl, byte [byte edx+eax*2+0Dh]
        and edx, 0FFh
        mov ebx, 2
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        test edx, edx
        je short .67
        mov esi, 14Ah
        jmp short .68
.67:
        mov esi, 0A5h
.68:
        mov edx, dword [byte esp+074h]
        mov edx, dword [nosplit edx*4+statsteamorder]
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        mov edx, dword [statsteambuf]
        cmp byte [byte edx+eax*2+0Dh], 2
        jae short .69
        xor ebx, ebx
        jmp short .70
.69:
        mov ebx, 140h
.70:
        mov ebp, dword [byte esp+074h]
        cmp ebp, byte 0Ch
        jge short .71
        mov ecx, 6
        mov eax, ebp
        mov edx, ebp
        jmp short .72
.71:
        lea edx, [byte ebp-0Ch]
        mov ecx, 7
        mov eax, edx
.72:
        sar edx, 1Fh
        idiv ecx
        mov eax, edx
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add esi, eax
        push dword 80h
        push byte 0Dh
        push dword 140h
        push esi
        push ebx
        call XorBar
        add esp, byte 14h
        jmp near .85
.73:
        cmp dword [nosplit esi*4+playofftree], byte 1Ah
        je near .85
        cmp dword [dword edx+playofftree], byte 1Ah
        je near .85
        lea edx, [byte esp+074h]
        lea eax, [byte esp+070h]
        call MoveTreeHighlight
        jmp near .85
.74:
        cmp dword [statsplayoffs], byte 0
        je short .75
        cmp dword [dword edx+playofftree], byte 1Ah
        je near .85
.75:
        mov esi, 3
        jmp short .78
.76:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+048h]
        test edi, edi
        je short .77
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov edi, dword [byte esp+ebp+048h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.77:
        dec esi
.78:
        test esi, esi
        jge short RunTeamPickMenu.76
        mov eax, dword [byte esp+070h]
        shl eax, 2
        cmp dword [statsplayoffs], byte 0
        jne short .79
        mov eax, dword [dword eax+statsteamorder]
        mov dword [byte esp+074h], eax
        mov dword [statscategory], eax
        jmp short .80
.79:
        mov eax, dword [dword eax+playofftree]
        mov dword [statscategory], eax
        mov eax, dword [byte esp+070h]
.80:
        mov dword [statsteamsel], eax
        call DeskSetExit3b
        xor edi, edi
        mov dword [byte esp+064h], edi
        mov dword [byte esp+060h], edi
        mov dword [byte esp+05Ch], edi
        mov dword [byte esp+054h], edi
        mov dword [byte esp+050h], edi
        mov dword [byte esp+04Ch], edi
        mov dword [byte esp+048h], edi
        mov dword [byte esp+044h], edi
        mov dword [byte esp+040h], edi
        mov dword [byte esp+03Ch], edi
        mov dword [byte esp+034h], edi
        mov dword [byte esp+030h], edi
        mov dword [byte esp+02Ch], edi
        mov esi, dword [dword esp+08Ch]
        push esi
        jmp near RunTeamPickMenu.36
.81:
        push edi
        push ebp
        mov ecx, dword [dword esp+094h]
        push ecx
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .84
.82:
        mov ebp, esi
        shl ebp, 2
        mov ebx, dword [byte esp+ebp+048h]
        test ebx, ebx
        je short .83
        mov ecx, dword [byte esp+esi*8+0Ch]
        push ecx
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        push ebx
        call PutBlock
        add esp, byte 0Ch
        xor ebx, ebx
        mov dword [byte esp+esi*8+0Ch], ebx
        mov dword [byte esp+esi*8+08h], ebx
        mov ecx, dword [byte esp+ebp+048h]
        push ecx
        call FreeMemBlock
        add esp, byte 4
.83:
        dec esi
.84:
        test esi, esi
        jge short RunTeamPickMenu.82
        xor ecx, ecx
        mov dword [dword esp+098h], ecx
        mov dword [byte esp+064h], ecx
        mov dword [byte esp+060h], ecx
        mov dword [byte esp+05Ch], ecx
        mov dword [byte esp+050h], ecx
        mov dword [byte esp+04Ch], ecx
        mov dword [byte esp+048h], ecx
        mov dword [byte esp+044h], ecx
        mov dword [byte esp+040h], ecx
        mov dword [byte esp+03Ch], ecx
        mov dword [byte esp+034h], ecx
        mov dword [byte esp+030h], ecx
        mov dword [byte esp+02Ch], ecx
.85:
        mov ebp, dword [byte esp+078h]
        push ebp
        mov eax, dword [dword esp+080h]
        push eax
        mov edx, dword [dword esp+094h]
        push edx
        jmp near RunTeamPickMenu.18
.86:
        add esp, 0A0h
        jmp near RunMenu_ret4
;-----------------------------------------------------------------------------
; RunPlayerPickMenu                            1ED96  95 PC, medium confidence
; RunMenu variant with a skater + goalie picker; copies picked record to
; statsplayer, calls ShowPlayerStatsItem
;-----------------------------------------------------------------------------
RunPlayerPickMenu:
        push dword 0C0h
        call __CHK
        push esi
        push edi
        push ebp
        sub esp, 94h
        push ebx
        push ecx
        xor ebx, ebx
        mov dword [byte esp+070h], ebx
        mov dword [dword esp+094h], ebx
        mov dword [dword esp+098h], ebx
        mov dword [byte esp+028h], eax
        mov dword [byte esp+038h], edx
        mov dword [byte esp+034h], ebx
        mov dword [byte esp+030h], ebx
        mov dword [byte esp+02Ch], ebx
        mov dword [byte esp+054h], ebx
        mov dword [byte esp+050h], ebx
        mov dword [byte esp+04Ch], ebx
        mov dword [byte esp+048h], ebx
        mov dword [byte esp+064h], ebx
        mov dword [byte esp+060h], ebx
        mov dword [byte esp+05Ch], ebx
        mov dword [byte esp+058h], ebx
        mov dword [byte esp+0Ch], ebx
        mov dword [byte esp+08h], ebx
        mov eax, dword [pointerspr]
        mov ebx, dword [byte eax+02h]
        sar ebx, 10h
        mov edx, dword [byte eax+04h]
        sar edx, 10h
        inc edx
        lea eax, [byte ebx+01h]
        imul eax, edx
        add eax, byte 11h
        push byte 20h
        push eax
        push str_PointerMenu
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [dword esp+088h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+04h]
        inc edx
        mov word [byte eax+04h], dx
        mov edx, dword [pointerspr]
        mov dx, word [byte edx+06h]
        inc edx
        mov word [byte eax+06h], dx
        mov edx, dword [byte esp+028h]
        mov edx, dword [edx]
        mov eax, dword [byte esp+028h]
        mov esi, dword [byte eax+08h]
        add edx, esi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+08Ch], eax
        mov dword [byte esp+078h], eax
        mov edx, dword [byte esp+028h]
        mov edx, dword [byte edx+04h]
        mov eax, dword [byte esp+028h]
        mov edi, dword [byte eax+0Ch]
        add edx, edi
        mov eax, edx
        sar edx, 1Fh
        LD sub, eax, edx
        sar eax, 1
        mov dword [dword esp+090h], eax
        mov dword [byte esp+074h], eax
        mov ah, byte [statsplayer+2]
        cmp ah, 47h
        je short .1
        cmp ah, 67h
        jne near .5
.1:
        xor esi, esi
        jmp short .4
.2:
        mov edx, dword [nosplit esi*4+statsgoalieorder]
        mov edx, dword [nosplit edx*4+statsgoalieplr]
        mov ebx, edx
        shl ebx, 2
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 2
        mov edx, dword [statsplayerbuf]
        add edx, ebx
        add edx, byte 3
        mov eax, statsplayer+3
        call StrPrefixDiffers
        test eax, eax
        jne short .3
        mov eax, dword [statsplayerbuf]
        add eax, ebx
        lea edx, [byte eax+013h]
        mov eax, statsplayer+13h
        call StrPrefixDiffers
        test eax, eax
        jne short .3
        mov eax, dword [statsnumskaters]
        add eax, esi
        mov dword [dword esp+094h], eax
        jmp near .9
.3:
        inc esi
.4:
        cmp esi, dword [statsnumgoalies]
        jl short RunPlayerPickMenu.2
        jmp near .9
.5:
        test ah, ah
        je short .9
        xor esi, esi
        jmp short .8
.6:
        mov edx, dword [nosplit esi*4+statsskaterorder]
        mov edx, dword [nosplit edx*4+statsskaterplr]
        mov ebx, edx
        shl ebx, 2
        sub ebx, edx
        shl ebx, 2
        add ebx, edx
        shl ebx, 2
        mov edx, dword [statsplayerbuf]
        add edx, ebx
        add edx, byte 3
        mov eax, statsplayer+3
        call StrPrefixDiffers
        test eax, eax
        jne short .7
        mov eax, dword [statsplayerbuf]
        add eax, ebx
        lea edx, [byte eax+013h]
        mov eax, statsplayer+13h
        call StrPrefixDiffers
        test eax, eax
        jne short .7
        mov dword [dword esp+094h], esi
        jmp short .9
.7:
        inc esi
.8:
        cmp esi, dword [statsnumskaters]
        jl short RunPlayerPickMenu.6
.9:
        mov eax, dword [dword esp+094h]
        mov edx, dword [statsnumskaters]
        cmp eax, edx
        jge short .10
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 43h
        jmp short .11
.10:
        sub eax, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, 1A8h
.11:
        push dword 80h
        push byte 0Dh
        push dword 280h
        push eax
        push byte 0
        call XorBar
        add esp, byte 14h
        mov ecx, dword [dword esp+090h]
        push ecx
        mov esi, dword [dword esp+090h]
        push esi
        mov edi, dword [dword esp+090h]
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+090h]
        push ebp
        push esi
        mov edx, dword [pointerspr]
        push edx
        call DrawArt
        add esp, byte 0Ch
        push dword 1E0h
        push dword 280h
        push byte 0
        push byte 0
        call SetViewRect
        add esp, byte 10h
        push ebp
        push esi
        call MouseSetPos
        add esp, byte 8
        call dword [mousepollfn]
        call ClearInputQueue
.12:
        xor ecx, ecx
.13:
        call GetInputEvent
        test eax, eax
        je short .14
        lea ebx, [byte esp+074h]
        lea edx, [byte esp+078h]
        call dword [ptrupdatefn]
        mov ecx, eax
        test al, 2
        je short RunPlayerPickMenu.13
.14:
        test cl, 2
        jne near .17
        mov eax, dword [byte esp+078h]
        cmp eax, dword [dword esp+08Ch]
        jne short .15
        mov eax, dword [byte esp+074h]
        cmp eax, dword [dword esp+090h]
        je short RunPlayerPickMenu.12
.15:
        mov ecx, dword [dword esp+090h]
        push ecx
        mov esi, dword [dword esp+090h]
        push esi
        mov edi, dword [dword esp+090h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [byte esp+074h]
        push ebp
        mov eax, dword [byte esp+07Ch]
        push eax
        push edi
        call GrabBlock
        add esp, byte 0Ch
        mov ebx, dword [byte esp+074h]
        push ebx
        mov ecx, dword [byte esp+07Ch]
        push ecx
        mov esi, dword [pointerspr]
        push esi
.16:
        call DrawArt
        add esp, byte 0Ch
        mov eax, dword [byte esp+078h]
        mov dword [dword esp+08Ch], eax
        mov eax, dword [byte esp+074h]
        mov dword [dword esp+090h], eax
        jmp near RunPlayerPickMenu.12
.17:
        lea eax, [byte esp+068h]
        push eax
        lea eax, [byte esp+070h]
        push eax
        lea eax, [byte esp+010h]
        push eax
        lea eax, [byte esp+044h]
        push eax
        mov ecx, dword [dword esp+0A8h]
        lea ebx, [byte esp+038h]
        mov edx, dword [dword esp+084h]
        mov eax, dword [dword esp+088h]
        call MenuHitTest
        test eax, eax
        je near .50
        mov edx, dword [byte esp+06Ch]
        shl edx, 2
        mov ebx, dword [byte esp+068h]
        shl ebx, 5
        mov eax, dword [byte esp+edx+028h]
        add eax, ebx
        cmp dword [byte eax+014h], byte 0
        je near .40
        mov eax, dword [byte esp+068h]
        cmp eax, dword [byte esp+edx+058h]
        jne near .37
        mov esi, dword [dword esp+090h]
        push esi
        mov edi, dword [dword esp+090h]
        push edi
        mov ebp, dword [dword esp+090h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .20
.18:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+048h]
        test edi, edi
        je short .19
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov edi, dword [byte esp+ebp+048h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.19:
        dec esi
.20:
        test esi, esi
        jge short RunPlayerPickMenu.18
        xor esi, esi
        mov dword [dword esp+098h], esi
        mov eax, dword [byte esp+070h]
        mov edi, dword [statsnumskaters]
        cmp eax, edi
        jge short .21
        mov eax, dword [nosplit eax*4+statsskaterorder]
        mov eax, dword [nosplit eax*4+statsskaterplr]
        jmp short .22
.21:
        sub eax, edi
        mov eax, dword [nosplit eax*4+statsgoalieorder]
        mov eax, dword [nosplit eax*4+statsgoalieplr]
.22:
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov esi, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        mov edi, statsplayer
        rep movsd
        mov eax, dword [dword esp+094h]
        mov edx, dword [statsnumskaters]
        cmp eax, edx
        jge short .23
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 43h
        jmp short .24
.23:
        sub eax, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, 1A8h
.24:
        push dword 80h
        push byte 0Dh
        push dword 280h
        push eax
        push byte 0
        call XorBar
        add esp, byte 14h
        mov eax, dword [byte esp+06Ch]
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+eax*4+028h]
        call dword [byte edx+eax+014h]
        xor ecx, ecx
        mov dword [byte esp+034h], ecx
        mov dword [byte esp+030h], ecx
        mov dword [byte esp+02Ch], ecx
        mov dword [byte esp+054h], ecx
        mov dword [byte esp+050h], ecx
        mov dword [byte esp+04Ch], ecx
        mov dword [byte esp+048h], ecx
        mov dword [byte esp+064h], ecx
        mov dword [byte esp+060h], ecx
        mov dword [byte esp+05Ch], ecx
        mov dword [byte esp+044h], ecx
        mov dword [byte esp+040h], ecx
        mov dword [byte esp+03Ch], ecx
        cmp eax, byte 1
        jne short .26
        mov esi, dword [dword esp+088h]
        push esi
.25:
        call FreeMemBlock
        add esp, byte 4
        xor eax, eax
        jmp near .69
.26:
        mov bl, byte [statsplayer+2]
        cmp bl, 47h
        jne near .30
        xor esi, esi
        jmp short .29
.27:
        mov edi, dword [nosplit esi*4+statsgoalieorder]
        mov edi, dword [nosplit edi*4+statsgoalieplr]
        mov ebx, edi
        shl ebx, 2
        sub ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 2
        mov eax, dword [statsplayerbuf]
        add eax, ebx
        lea edx, [byte eax+03h]
        mov eax, statsplayer+3
        call StrPrefixDiffers
        test eax, eax
        jne short .28
        mov edx, dword [statsplayerbuf]
        add edx, ebx
        add edx, byte 13h
        mov eax, statsplayer+13h
        call StrPrefixDiffers
        test eax, eax
        jne short .28
        mov eax, dword [statsnumskaters]
        add eax, esi
        mov dword [dword esp+094h], eax
        jmp near .34
.28:
        inc esi
.29:
        cmp esi, dword [statsnumgoalies]
        jl short RunPlayerPickMenu.27
        jmp near .34
.30:
        test bl, bl
        je short .34
        xor esi, esi
        jmp short .33
.31:
        mov edi, dword [nosplit esi*4+statsskaterorder]
        mov edi, dword [nosplit edi*4+statsskaterplr]
        mov ebx, edi
        shl ebx, 2
        sub ebx, edi
        shl ebx, 2
        add ebx, edi
        shl ebx, 2
        mov eax, dword [statsplayerbuf]
        add eax, ebx
        lea edx, [byte eax+03h]
        mov eax, statsplayer+3
        call StrPrefixDiffers
        test eax, eax
        jne short .32
        mov edx, dword [statsplayerbuf]
        add edx, ebx
        add edx, byte 13h
        mov eax, statsplayer+13h
        call StrPrefixDiffers
        test eax, eax
        jne short .32
        mov dword [dword esp+094h], esi
        jmp short .34
.32:
        inc esi
.33:
        cmp esi, dword [statsnumskaters]
        jl short RunPlayerPickMenu.31
.34:
        mov eax, dword [dword esp+094h]
        mov edx, dword [statsnumskaters]
        cmp eax, edx
        jge short .35
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 43h
        jmp short .36
.35:
        sub eax, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, 1A8h
.36:
        push dword 80h
        push byte 0Dh
        push dword 280h
        push eax
        push byte 0
        call XorBar
        add esp, byte 14h
        mov ecx, dword [dword esp+090h]
        push ecx
        mov esi, dword [dword esp+090h]
        push esi
        call MouseSetPos
        add esp, byte 8
        mov dword [byte esp+078h], esi
        mov eax, dword [dword esp+090h]
        mov dword [byte esp+074h], eax
        call ClearInputQueue
        jmp near .68
.37:
        mov ecx, dword [dword esp+090h]
        push ecx
        mov esi, dword [dword esp+090h]
        push esi
        mov edi, dword [dword esp+090h]
        push edi
        call PutBlock
        add esp, byte 0Ch
        mov ebp, dword [dword esp+0ACh]
        push ebp
        mov eax, dword [byte esp+04h]
        push eax
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+060h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+030h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+058h], eax
        push ebp
        mov ecx, dword [byte esp+04h]
        push ecx
.38:
        mov ebx, dword [byte esp+edx*8+014h]
        mov eax, dword [byte esp+edx*8+010h]
        mov esi, dword [byte esp+edx*4+060h]
        shl esi, 5
        mov edx, dword [byte esp+edx*4+030h]
        add esi, edx
        mov ecx, dword [byte esp+0Ch]
        mov edx, eax
        mov eax, esi
.39:
        call DrawMenuItemNorm
        jmp near .68
.40:
        cmp dword [byte eax+018h], byte 0
        je near .49
        mov edi, dword [dword esp+090h]
        push edi
        mov ebp, dword [dword esp+090h]
        push ebp
        mov eax, dword [dword esp+090h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov eax, dword [dword esp+098h]
        cmp eax, dword [byte esp+06Ch]
        je short .44
        mov esi, eax
        jmp short .43
.41:
        mov edi, esi
        shl edi, 2
        xor eax, eax
        mov dword [byte esp+edi+058h], eax
        mov edx, dword [byte esp+edi+048h]
        test edx, edx
        je short .42
        mov ebp, esi
        mov ebx, dword [byte esp+esi*8+0Ch]
        push ebx
        mov ecx, dword [byte esp+esi*8+0Ch]
        push ecx
        push edx
        call PutBlock
        add esp, byte 0Ch
        xor edx, edx
        mov dword [byte esp+esi*8+0Ch], edx
        mov dword [byte esp+esi*8+08h], edx
        mov ebx, dword [byte esp+edi+048h]
        push ebx
        call FreeMemBlock
        add esp, byte 4
        xor ecx, ecx
        mov dword [byte esp+edi+048h], ecx
        xor ebp, esi
        mov dword [byte esp+edi+028h], ebp
        mov dword [byte esp+edi+038h], ecx
.42:
        dec esi
.43:
        mov ebp, dword [byte esp+06Ch]
        cmp esi, ebp
        jg short RunPlayerPickMenu.41
        mov dword [dword esp+098h], ebp
.44:
        mov edx, dword [dword esp+0ACh]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        mov esi, dword [dword esp+0A0h]
        mov ebx, dword [byte esp+esi*8+014h]
        mov edx, dword [byte esp+esi*8+010h]
        mov eax, dword [byte esp+esi*4+060h]
        shl eax, 5
        mov ecx, dword [byte esp+esi*4+030h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+esi*4+058h], eax
        mov ecx, dword [dword esp+0ACh]
        push ecx
        mov ebp, dword [byte esp+04h]
        push ebp
        mov ebx, dword [byte esp+esi*8+014h]
        mov edx, dword [byte esp+esi*8+010h]
        mov ecx, eax
        shl ecx, 5
        mov eax, dword [byte esp+esi*4+030h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemNorm
        mov eax, dword [byte esp+06Ch]
        mov ebx, dword [byte esp+068h]
        shl ebx, 5
        mov ecx, dword [byte esp+eax*4+028h]
        lea edx, [byte esi+01h]
        mov dword [dword esp+098h], edx
        mov ecx, dword [byte ecx+ebx+018h]
        mov dword [byte esp+edx*4+028h], ecx
        mov eax, dword [byte esp+eax*4+028h]
        add eax, ebx
        mov ebx, dword [byte eax+01Ch]
        mov dword [byte esp+edx*4+038h], ebx
        cmp edx, byte 1
        je short .45
        mov edx, dword [byte eax+08h]
        jmp short .46
.45:
        mov edx, dword [eax]
.46:
        mov eax, dword [dword esp+098h]
        mov ecx, dword [esp+eax*8]
        add edx, ecx
        mov dword [byte esp+eax*8+08h], edx
        mov edx, dword [byte esp+068h]
        shl edx, 5
        mov eax, dword [byte esp+06Ch]
        shl eax, 2
        cmp dword [dword esp+098h], byte 1
        je short .47
        mov eax, dword [byte esp+eax+028h]
        mov eax, dword [byte edx+eax+04h]
        jmp short .48
.47:
        mov eax, dword [byte esp+eax+028h]
        mov eax, dword [byte edx+eax+0Ch]
.48:
        mov edx, dword [dword esp+098h]
        shl edx, 3
        mov dword [dword esp+084h], edx
        mov edi, dword [byte esp+edx+04h]
        add eax, edi
        mov dword [byte esp+edx+0Ch], eax
        mov ebp, dword [dword esp+098h]
        mov edx, dword [byte esp+ebp*4+038h]
        shl edx, 5
        mov eax, dword [byte esp+ebp*4+028h]
        mov ebx, dword [byte edx+eax-018h]
        sub ebx, dword [eax]
        inc ebx
        mov dword [dword esp+080h], ebx
        mov edx, dword [byte edx+eax-014h]
        sub edx, dword [byte eax+04h]
        inc edx
        mov dword [byte esp+07Ch], edx
        push byte 20h
        mov eax, ebx
        imul eax, edx
        add eax, byte 11h
        push eax
        push str_menubuff
        call AllocMemBlock
        add esp, byte 0Ch
        mov dword [byte esp+ebp*4+048h], eax
        mov esi, dword [pointerspr]
        mov edi, eax
        movsd
        movsd
        movsd
        movsd
        movsb
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [dword esp+080h]
        mov word [byte eax+04h], dx
        mov eax, dword [byte esp+ebp*4+048h]
        mov edx, dword [byte esp+07Ch]
        mov word [byte eax+06h], dx
        mov eax, dword [dword esp+084h]
        mov edx, dword [byte esp+eax+0Ch]
        push edx
        mov ebx, dword [byte esp+eax+0Ch]
        push ebx
        mov ecx, dword [byte esp+ebp*4+050h]
        push ecx
        call GrabBlock
        add esp, byte 0Ch
        mov esi, dword [dword esp+0ACh]
        push esi
        mov edi, dword [byte esp+04h]
        push edi
        mov eax, dword [byte esp+0Ch]
        push eax
        mov ecx, dword [dword esp+090h]
        mov ecx, dword [byte esp+ecx+018h]
        mov ebx, dword [dword esp+090h]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [byte esp+ebp*4+044h]
        mov eax, dword [byte esp+ebp*4+034h]
        call DrawMenuDropdown
        xor edx, edx
        mov dword [byte esp+ebp*4+058h], edx
        push esi
        push edi
        mov ebx, dword [dword esp+08Ch]
        mov ebx, dword [byte esp+ebx+014h]
        mov edx, dword [dword esp+08Ch]
        mov edx, dword [byte esp+edx+010h]
        mov eax, dword [byte esp+ebp*4+030h]
        mov ecx, dword [byte esp+0Ch]
        jmp near RunPlayerPickMenu.39
.49:
        mov edi, dword [dword esp+090h]
        push edi
        mov ebp, dword [dword esp+090h]
        push ebp
        mov eax, dword [dword esp+090h]
        push eax
        call PutBlock
        add esp, byte 0Ch
        mov edx, dword [dword esp+0ACh]
        push edx
        mov ebx, dword [byte esp+04h]
        push ebx
        mov eax, dword [byte esp+074h]
        mov ebx, dword [byte esp+eax*8+014h]
        mov edx, dword [byte esp+eax*8+010h]
        mov ecx, dword [byte esp+eax*4+060h]
        shl ecx, 5
        mov eax, dword [byte esp+eax*4+030h]
        add eax, ecx
        mov ecx, dword [byte esp+0Ch]
        call DrawMenuItemSel
        mov edx, dword [byte esp+06Ch]
        mov eax, dword [byte esp+068h]
        mov dword [byte esp+edx*4+058h], eax
        mov ecx, dword [dword esp+0ACh]
        push ecx
        mov esi, dword [byte esp+04h]
        push esi
        jmp near RunPlayerPickMenu.38
.50:
        mov esi, dword [dword esp+090h]
        push esi
        mov edi, dword [dword esp+090h]
        push edi
        mov ebp, dword [dword esp+090h]
        push ebp
        call PutBlock
        add esp, byte 0Ch
        lea ebx, [byte esp+070h]
        mov edx, dword [byte esp+074h]
        mov eax, dword [byte esp+078h]
        call PlayerFromMouseY
        test eax, eax
        je near .64
        mov esi, 3
        jmp short .53
.51:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+048h]
        test edi, edi
        je short .52
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov edi, dword [byte esp+ebp+048h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.52:
        dec esi
.53:
        test esi, esi
        jge short RunPlayerPickMenu.51
        xor ebp, ebp
        mov dword [dword esp+098h], ebp
        mov dword [byte esp+034h], ebp
        mov dword [byte esp+030h], ebp
        mov dword [byte esp+02Ch], ebp
        mov dword [byte esp+054h], ebp
        mov dword [byte esp+050h], ebp
        mov dword [byte esp+04Ch], ebp
        mov dword [byte esp+048h], ebp
        mov dword [byte esp+064h], ebp
        mov dword [byte esp+060h], ebp
        mov dword [byte esp+05Ch], ebp
        mov dword [byte esp+044h], ebp
        mov dword [byte esp+040h], ebp
        mov dword [byte esp+03Ch], ebp
        mov eax, dword [dword esp+094h]
        cmp eax, dword [byte esp+070h]
        je near .58
        mov edx, dword [statsnumskaters]
        cmp eax, edx
        jge short .54
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 43h
        jmp short .55
.54:
        sub eax, edx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, 1A8h
.55:
        push dword 80h
        push byte 0Dh
        push dword 280h
        push eax
        push byte 0
        call XorBar
        add esp, byte 14h
        mov eax, dword [byte esp+070h]
        mov dword [dword esp+094h], eax
        mov ecx, dword [statsnumskaters]
        cmp eax, ecx
        jge short .56
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, byte 43h
        jmp near .57
.56:
        sub eax, ecx
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        add eax, 1A8h
.57:
        push dword 80h
        push byte 0Dh
        push dword 280h
        push eax
        push byte 0
        call XorBar
        add esp, byte 14h
        jmp near .68
.58:
        mov esi, 3
        jmp short .61
.59:
        mov ebp, esi
        shl ebp, 2
        mov ecx, dword [byte esp+ebp+048h]
        test ecx, ecx
        je short .60
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push ecx
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov edi, dword [byte esp+ebp+048h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.60:
        dec esi
.61:
        test esi, esi
        jge short RunPlayerPickMenu.59
        mov eax, dword [byte esp+070h]
        mov ebp, dword [statsnumskaters]
        cmp eax, ebp
        jge short .62
        mov eax, dword [nosplit eax*4+statsskaterorder]
        mov eax, dword [nosplit eax*4+statsskaterplr]
        jmp short .63
.62:
        mov esi, eax
        sub esi, ebp
        mov eax, dword [nosplit esi*4+statsgoalieorder]
        mov eax, dword [nosplit eax*4+statsgoalieplr]
.63:
        mov edx, eax
        shl eax, 2
        sub eax, edx
        shl eax, 2
        add eax, edx
        shl eax, 2
        mov esi, dword [statsplayerbuf]
        add esi, eax
        mov ecx, 0Dh
        mov edi, statsplayer
        rep movsd
        xor edx, edx
        mov dword [statspalvalid], edx
        mov dword [statspal], edx
        call ShowPlayerStatsItem
        mov dword [byte esp+034h], edx
        mov dword [byte esp+030h], edx
        mov dword [byte esp+02Ch], edx
        mov dword [byte esp+054h], edx
        mov dword [byte esp+050h], edx
        mov dword [byte esp+04Ch], edx
        mov dword [byte esp+048h], edx
        mov dword [byte esp+064h], edx
        mov dword [byte esp+060h], edx
        mov dword [byte esp+05Ch], edx
        mov dword [byte esp+044h], edx
        mov dword [byte esp+040h], edx
        mov dword [byte esp+03Ch], edx
        mov ebx, dword [dword esp+088h]
        push ebx
        jmp near RunPlayerPickMenu.25
.64:
        push esi
        push edi
        push ebp
        call PutBlock
        add esp, byte 0Ch
        mov esi, 3
        jmp short .67
.65:
        mov ebp, esi
        shl ebp, 2
        mov edi, dword [byte esp+ebp+048h]
        test edi, edi
        je short .66
        mov eax, dword [byte esp+esi*8+0Ch]
        push eax
        mov edx, dword [byte esp+esi*8+0Ch]
        push edx
        push edi
        call PutBlock
        add esp, byte 0Ch
        xor ecx, ecx
        mov dword [byte esp+esi*8+0Ch], ecx
        mov dword [byte esp+esi*8+08h], ecx
        mov edi, dword [byte esp+ebp+048h]
        push edi
        call FreeMemBlock
        add esp, byte 4
.66:
        dec esi
.67:
        test esi, esi
        jge short RunPlayerPickMenu.65
        xor edi, edi
        mov dword [dword esp+098h], edi
        mov dword [byte esp+034h], edi
        mov dword [byte esp+030h], edi
        mov dword [byte esp+02Ch], edi
        mov dword [byte esp+054h], edi
        mov dword [byte esp+050h], edi
        mov dword [byte esp+04Ch], edi
        mov dword [byte esp+048h], edi
        mov dword [byte esp+064h], edi
        mov dword [byte esp+060h], edi
        mov dword [byte esp+05Ch], edi
        mov dword [byte esp+044h], edi
        mov dword [byte esp+040h], edi
        mov dword [byte esp+03Ch], edi
.68:
        mov edi, dword [byte esp+074h]
        push edi
        mov ebp, dword [byte esp+07Ch]
        push ebp
        mov eax, dword [dword esp+090h]
        push eax
        call GrabBlock
        add esp, byte 0Ch
        mov edx, dword [byte esp+074h]
        push edx
        mov ebx, dword [byte esp+07Ch]
        push ebx
        mov ecx, dword [pointerspr]
        push ecx
        jmp near RunPlayerPickMenu.16
.69:
        add esp, 9Ch
        jmp near RunMenu_ret4
;-----------------------------------------------------------------------------
; InitMenuRemap                                1FAA7  95 PC, medium confidence
; Mode 0: menuremap 0..14h = 0, 15h..3Fh shifted down by 15h, rest identity;
; else menuremap / menuremap2 0..7Fh identity; installs menuremap via
; SetColorRemap
;-----------------------------------------------------------------------------
; C: src/front/menu/InitMenuRemap.c
%ifdef CBUILD
%include "c/front/menu/InitMenuRemap.inc"
%else
InitMenuRemap:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push edx
        test eax, eax
        jne short .3
        mov ecx, 15h
        xor edx, edx
        mov eax, menuremap
        call __STOSB
        mov ebx, 15h
.1:
        mov al, bl
        sub al, 15h
        mov byte [dword ebx+menuremap], al
        inc ebx
        cmp ebx, byte 40h
        jl short InitMenuRemap.1
        mov ebx, 40h
.2:
        mov byte [dword ebx+menuremap], bl
        inc ebx
        cmp ebx, 100h
        jl short InitMenuRemap.2
        jmp short .5
.3:
        xor ebx, ebx
.4:
        mov byte [dword ebx+menuremap], bl
        mov byte [dword ebx+menuremap2], bl
        inc ebx
        cmp ebx, 80h
        jl short InitMenuRemap.4
.5:
        push menuremap
        call SetColorRemap
        add esp, byte 4
        pop edx
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; TextPrintf                                                      1FB1C  95 PC
; Sprintf into printfbuf then PrintString text draw; no refs
;-----------------------------------------------------------------------------
; C: src/front/menu/TextPrintf.c
%ifdef CBUILD
%include "c/front/menu/TextPrintf.inc"
%else
TextPrintf:
        push dword 14h
        call __CHK
        push esi
        mov esi, eax
        push ecx
        push ebx
        push printfbuf
        call sprintf_
        add esp, byte 0Ch
        push edx
        push esi
        push printfbuf
        call PrintString
        add esp, byte 0Ch
        pop esi
        ret
;-----------------------------------------------------------------------------
; TextPrintf2                                                     1FB49  95 PC
; As TextPrintf with one more format arg; no refs
;-----------------------------------------------------------------------------
TextPrintf2:
        push dword 1Ch
        call __CHK
        push esi
        push edi
        mov esi, eax
        mov edi, dword [byte esp+0Ch]
        push edi
        push ecx
        push ebx
        push printfbuf
        call sprintf_
        add esp, byte 10h
        push edx
        push esi
        push printfbuf
        call PrintString
        add esp, byte 0Ch
        pop edi
        pop esi
        ret 4
%endif ; C
;-----------------------------------------------------------------------------
; CmpPoints                                                       1FB7F  95 PC
; Leadersortfns[0] (Point Leaders); also the default skater roster sort
;-----------------------------------------------------------------------------
; C: src/front/menu/CmpPoints.c
%ifdef CBUILD
%include "c/front/menu/CmpPoints.inc"
%else
CmpPoints:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, eax
        mov eax, dword [statsskaterbuf]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 2
        sub eax, ebx
        shl eax, 4
        sub eax, ebx
        mov ebx, dword [statsskaterbuf]
        add eax, ebx
        add eax, byte 12h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 4
        sub edx, ebx
        mov ebx, dword [statsskaterbuf]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 2
        sub edx, ebx
        shl edx, 4
        sub edx, ebx
        mov ebx, dword [statsskaterbuf]
        add ebx, edx
        add ebx, byte 12h
.4:
        mov edx, ebx
        cmp word [ebx], byte 0
        sete bl
        mov ecx, ebx
        and ecx, 0FFh
        mov si, word [eax]
        test si, si
        sete bl
        and ebx, 0FFh
        xor ebx, ecx
        je short .7
        mov dx, word [edx]
.5:
        and edx, 0FFFFh
        mov eax, esi
.6:
        and eax, 0FFFFh
        jmp short .11
.7:
        mov bx, word [byte edx+06h]
        mov di, word [byte eax+06h]
        cmp bx, di
        je short .8
        mov edx, ebx
        and edx, 0FFFFh
        mov eax, edi
        jmp short CmpPoints.6
.8:
        cmp si, word [edx]
        je short .9
        xor ebx, ebx
        mov bx, si
        xor eax, eax
        mov ax, word [edx]
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.9:
        mov bx, word [byte edx+02h]
        mov si, word [byte eax+02h]
        cmp bx, si
        je short .10
        mov edx, ebx
        jmp short CmpPoints.5
.10:
        mov edx, dword [byte edx+0Eh]
        sar edx, 10h
        mov eax, dword [byte eax+0Eh]
        sar eax, 10h
.11:
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; CmpGAA                                                          1FC8F  95 PC
; Leadersortfns[8] (Goals Against Average Leaders); also the default goalie
; roster sort
;-----------------------------------------------------------------------------
; C: src/front/menu/CmpGAA.c
%ifdef CBUILD
%include "c/front/menu/CmpGAA.inc"
%else
CmpGAA:
        push dword 14h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        cmp dword [statsplayoffs], byte 0
        jne short .1
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        jmp short .2
.1:
        mov ebx, dword [eax]
        mov eax, ebx
        shl eax, 3
        sub eax, ebx
        shl eax, 2
        sub eax, ebx
        add eax, eax
        mov ebx, dword [statsgoaliebuf]
        add eax, ebx
        add eax, byte 16h
.2:
        cmp dword [statsplayoffs], byte 0
        jne short .3
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        jmp short .4
.3:
        mov ebx, dword [edx]
        mov edx, ebx
        shl edx, 3
        sub edx, ebx
        shl edx, 2
        sub edx, ebx
        add edx, edx
        mov ebx, dword [statsgoaliebuf]
        add ebx, edx
        add ebx, byte 16h
.4:
        mov edx, ebx
        cmp word [byte ebx+0Ch], byte 0
        sete bl
        mov ecx, ebx
        and ecx, 0FFh
        mov si, word [byte eax+0Ch]
        test si, si
        sete bl
        and ebx, 0FFh
        xor ebx, ecx
        je short .5
        mov dx, word [byte edx+0Ch]
        jmp short .9
.5:
        mov bx, word [byte edx+010h]
        mov di, word [byte eax+010h]
        cmp bx, di
        je short .7
        xor ebx, ebx
        mov bx, di
        xor eax, eax
        mov ax, word [byte edx+010h]
.6:
        sub ebx, eax
        mov eax, ebx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.7:
        mov bx, word [byte edx+0Ch]
        cmp bx, si
        je short .10
.8:
        mov edx, ebx
.9:
        and edx, 0FFFFh
        mov eax, esi
        jmp near .14
.10:
        mov bx, word [edx]
        mov si, word [eax]
        cmp bx, si
        jne short CmpGAA.8
        mov bx, word [byte edx+0Eh]
        mov di, word [byte eax+0Eh]
        cmp bx, di
        je short .11
        mov eax, edi
        and eax, 0FFFFh
        mov edx, ebx
        and edx, 0FFFFh
        sub eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
.11:
        mov bx, word [byte edx+02h]
        mov cx, word [byte eax+02h]
        cmp bx, cx
        je short .12
        mov edx, ebx
        and edx, 0FFFFh
        mov eax, ecx
        jmp short .14
.12:
        mov bx, word [byte edx+04h]
        mov si, word [byte eax+04h]
        cmp bx, si
        je short .13
        xor ebx, ebx
        mov bx, si
        xor eax, eax
        mov ax, word [byte edx+04h]
        jmp near CmpGAA.6
.13:
        mov dx, word [byte edx+014h]
        and edx, 0FFFFh
        mov ax, word [byte eax+014h]
.14:
        and eax, 0FFFFh
        sub edx, eax
        mov eax, edx
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; LoadShapeByTag                               1FDFE  95 PC, medium confidence
; Opens file, reads tag directory ("sfh"), finds 4-char tag, allocs "shape"
; and reads it; no refs
;-----------------------------------------------------------------------------
; C: src/front/menu/LoadShapeByTag.c
%ifdef CBUILD
%include "c/front/menu/LoadShapeByTag.inc"
%else
LoadShapeByTag:
        push dword 54h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        sub esp, byte 2Ch
        push edx
        mov dword [byte esp+01Ch], 0FFFFFFFFh
        xor ebp, ebp
        mov dword [byte esp+028h], ebp
        lea edx, [byte esp+01Ch]
        call FileOpenRead
        mov dword [byte esp+02Ch], eax
        test eax, eax
        jne short .1
        mov ecx, 2
        mov ebx, 4
        lea edx, [byte esp+020h]
        mov eax, dword [byte esp+01Ch]
        call FileReadAt
        mov dword [byte esp+02Ch], eax
        xor edx, edx
        mov word [byte esp+022h], dx
.1:
        cmp dword [byte esp+02Ch], byte 0
        jne short .2
        mov esi, dword [byte esp+020h]
        shl esi, 3
        push byte 20h
        push esi
        push str_sfh
        call AllocMemBlock
        add esp, byte 0Ch
        mov ebp, eax
        mov ecx, esi
        mov ebx, 6
        mov edx, eax
        mov eax, dword [byte esp+01Ch]
        call FileReadAt
        mov dword [byte esp+02Ch], eax
.2:
        mov esi, dword [byte esp+02Ch]
        test esi, esi
        jne near .6
        mov dword [byte esp+024h], esi
        jmp short .5
.3:
        mov ecx, esi
        shl ecx, 2
        lea edx, [ecx+ebp]
        mov ebx, 4
        lea eax, [byte esp+018h]
        call memcpy_
        mov ebx, 4
        mov edx, dword [esp]
        lea eax, [byte esp+018h]
        call memcmp_
        test eax, eax
        jne short .4
        mov dword [byte esp+024h], 0FFFFFFFFh
        mov eax, dword [byte esp+020h]
        shl eax, 2
        add eax, ebp
        mov edi, dword [byte esp+020h]
        shl edi, 3
        add edi, byte 6
        add edi, dword [ecx+eax]
        mov ecx, 11h
        mov ebx, edi
        lea edx, [byte esp+04h]
        mov eax, dword [byte esp+01Ch]
        call FileReadAt
        mov dword [byte esp+02Ch], eax
.4:
        inc esi
.5:
        cmp esi, dword [byte esp+020h]
        jge short .6
        cmp dword [byte esp+024h], byte 0
        je short LoadShapeByTag.3
.6:
        test ebp, ebp
        je short .7
        push ebp
        call FreeMemBlock
        add esp, byte 4
.7:
        cmp dword [byte esp+02Ch], byte 0
        jne short .8
        cmp dword [byte esp+024h], byte 0
        je short .8
        mov edx, dword [byte esp+06h]
        sar edx, 10h
        mov eax, dword [byte esp+08h]
        sar eax, 10h
        imul eax, edx
        lea ebp, [byte eax+011h]
        push byte 20h
        push ebp
        push str_shape
        call AllocMemBlock
        mov esi, eax
        add esp, byte 0Ch
        mov dword [byte esp+028h], eax
        mov ecx, ebp
        mov ebx, edi
        mov edx, eax
        mov eax, dword [byte esp+01Ch]
        call FileReadAt
        test eax, eax
        jge short .8
        push esi
        call FreeMemBlock
        add esp, byte 4
        xor esi, esi
        mov dword [byte esp+028h], esi
.8:
        lea eax, [byte esp+01Ch]
        call FileClose
        mov eax, dword [byte esp+028h]
        add esp, byte 30h
LoadShapeByTag_x:
        pop ebp
        pop edi
        pop esi
        pop ecx
        pop ebx
        ret
%endif ; C
;-----------------------------------------------------------------------------
; MakeStatsTitle                                                  1FF86  95 PC
; Dest = selected stats source label ('93-'94 Season / league / playoffs) +
; suffix
;-----------------------------------------------------------------------------
; C: src/front/menu/LoadShapeByTag.c (MakeStatsTitle)
%ifdef CBUILD
%include "c/front/menu/LoadShapeByTag.MakeStatsTitle.inc"
%else
MakeStatsTitle:
        push dword 18h
        call __CHK
        push ebx
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov ebp, edx
        cmp byte [mi_9394Season], 1
        jne short .2
        mov ecx, str_9394Season
.1:
        xor ebx, ebx
        jmp short .7
.2:
        cmp byte [mi_9394Playoffs], 1
        jne short .3
        mov ecx, str_9394PlayOffs
        jmp short .6
.3:
        cmp byte [mi_LeagueSeason], 1
        jne short .4
        mov ecx, str_LgSeasonTitle
        jmp short MakeStatsTitle.1
.4:
        cmp byte [mi_LeaguePlayoffs], 1
        jne short .5
        mov ecx, str_LgPlayoffsTitle
        jmp short .6
.5:
        cmp byte [mi_PlayoffMode], 1
        jne short .7
        mov ecx, str_POTitle
.6:
        mov ebx, 1
.7:
        mov eax, ecx
        call strlen_
        mov edi, eax
        sub edi, ebx
        mov ebx, edi
        mov edx, ecx
        mov eax, esi
        call strncpy_
        mov byte [edi+esi], 0
        mov edx, ebp
        mov eax, esi
        call strcat_
        jmp near LoadShapeByTag_x
%endif ; C
