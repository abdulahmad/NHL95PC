; Keyboard handlers run on the way out of the program.
bits 32
%include "hockey.inc"
section s_981AD progbits alloc exec nowrite align=1
extern str_EXITTODOSY, str_PAUSEPRESSANYKEY, bailout_vec, BackBufferWidth, joycalactive, joycalposthook, joycalprehook, mousepollfn
extern off_D306C, off_D3070, off_D3074, SetDrawBitmap, TextSetColors, TextSaveState, TextRestoreState, TextSetFont
extern WriteConsoleMessage, FillRect, DrawArtOpaque, FreeBitmap, GrabBlock, sub_93000, ReturnFalse, FindNearestColor
extern PrintStringCentered, ResetClipRect, KbdGetKey, SaveDrawState, RestoreDrawState, DebugLineCount, SetScreenTarget, CreateBitmap
extern SetBitmapClip, DefaultFont
global sub_981AD, sub_981B0, sub_981D4, ShowPromptBox, loc_983B1, loc_983BB, loc_983DB, loc_983F1
global AskExitToDos, loc_984CF, ShowMessageBox, sub_9862C, DosGetVector, DosSetVector, sub_9867E
sub_981AD:
        sti
        ret
        db 00h
sub_981B0:
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        call SetScreenTarget
        push ebp
        push edi
        mov edx, dword [byte esi+02Ch]
        push edx
        call GrabBlock
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
sub_981D4:
        push ecx
        push esi
        push edi
        push ebp
        mov esi, eax
        mov edi, edx
        mov ebp, ebx
        call SetScreenTarget
        push ebp
        push edi
        mov edx, dword [byte esi+02Ch]
        push edx
        call DrawArtOpaque
        add esp, byte 0Ch
        pop ebp
        pop edi
        pop esi
        pop ecx
        ret
        db 08Bh,0C0h
ShowPromptBox:
        push esi
        push edi
        push ebp
        sub esp, 0C0h
        mov dword [dword esp+0A4h], eax
        mov dword [dword esp+0B4h], edx
        mov dword [dword esp+0B8h], ebx
        mov dword [dword esp+0B0h], ecx
        mov ebp, dword [dword esp+0D4h]
        mov dword [joycalactive], 1
        call dword [joycalprehook]
        push byte 0FFFFFFFFh
        call ReturnFalse
        add esp, byte 4
        mov dword [dword esp+0A8h], eax
        push byte 0
        call ReturnFalse
        add esp, byte 4
        push byte 0
        mov ebx, dword [dword esp+0D4h]
        push ebx
        mov ecx, dword [dword esp+0B8h]
        push ecx
        call CreateBitmap
        mov esi, eax
        add esp, byte 0Ch
        mov dword [dword esp+0ACh], eax
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        lea eax, [byte esp+060h]
        push eax
        call TextSaveState
        add esp, byte 4
        push DefaultFont
        call TextSetFont
        add esp, byte 4
        mov edi, dword [dword esp+0B8h]
        add edi, dword [dword esp+0D0h]
        push edi
        mov edx, dword [dword esp+0BCh]
        push edx
        mov eax, dword [dword esp+0BCh]
        mov ebx, dword [dword esp+0B8h]
        add eax, ebx
        mov dword [dword esp+0A8h], eax
        push eax
        mov eax, dword [dword esp+0C0h]
        push eax
        push BackBufferWidth
        call SetBitmapClip
        add esp, byte 14h
        call dword [off_D3070]
        push esi
        call SetDrawBitmap
        add esp, byte 4
        mov ebx, dword [dword esp+0B8h]
        mov edx, dword [dword esp+0B4h]
        mov eax, esi
        call sub_981B0
        call SetScreenTarget
        push byte 0
        call FindNearestColor
        add esp, byte 4
        push eax
        mov edx, dword [dword esp+0D4h]
        push edx
        mov ebx, dword [dword esp+0B8h]
        push ebx
        mov ecx, dword [dword esp+0C4h]
        push ecx
        mov esi, dword [dword esp+0C4h]
        push esi
        call FillRect
        add esp, byte 14h
        push dword 0A80000h
        call FindNearestColor
        add esp, byte 4
        push eax
        sub edi, byte 4
        push edi
        mov eax, dword [dword esp+0A8h]
        sub eax, byte 5
        push eax
        mov eax, dword [dword esp+0C4h]
        add eax, byte 4
        push eax
        lea eax, [byte esi+04h]
        push eax
        call sub_93000
        add esp, byte 14h
        push byte 0
        push dword 0FCFCFCh
        call FindNearestColor
        add esp, byte 4
        push eax
        call TextSetColors
        add esp, byte 8
        mov eax, dword [dword esp+0B8h]
        add eax, byte 9
        push eax
        mov edi, dword [dword esp+0A8h]
        push edi
        call PrintStringCentered
        add esp, byte 8
        call dword [off_D3074]
        push BackBufferWidth
        call ResetClipRect
        add esp, byte 4
loc_983B1:
        call dword [mousepollfn]
        test eax, ebp
        jne short loc_983B1
loc_983BB:
        call KbdGetKey
        mov esi, eax
        mov dword [dword esp+0BCh], eax
        call dword [mousepollfn]
        mov edi, eax
        and edi, ebp
        test esi, esi
        jne short loc_983DB
        test edi, edi
        je short loc_983BB
loc_983DB:
        and edi, byte 1
        mov eax, dword [dword esp+0BCh]
        or al, 20h
        cmp eax, byte 79h
        jne short loc_983F1
        mov edi, 1
loc_983F1:
        mov eax, dword [dword esp+0B8h]
        add eax, dword [dword esp+0D0h]
        push eax
        mov eax, dword [dword esp+0BCh]
        push eax
        mov eax, dword [dword esp+0BCh]
        add eax, dword [dword esp+0B8h]
        push eax
        mov ebx, dword [dword esp+0C0h]
        push ebx
        push BackBufferWidth
        call SetBitmapClip
        add esp, byte 14h
        call dword [off_D306C]
        mov ebx, dword [dword esp+0B8h]
        mov edx, dword [dword esp+0B4h]
        mov eax, dword [dword esp+0ACh]
        call sub_981D4
        call dword [off_D3074]
        lea eax, [byte esp+060h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        mov ecx, dword [dword esp+0ACh]
        push ecx
        call FreeBitmap
        add esp, byte 4
        mov esi, dword [dword esp+0A8h]
        push esi
        call ReturnFalse
        add esp, byte 4
        call dword [joycalposthook]
        xor ebp, ebp
        mov dword [joycalactive], ebp
        mov eax, edi
        add esp, 0C0h
        pop ebp
        pop edi
        pop esi
        ret 8
        db 08Bh,0C0h
AskExitToDos:
        push byte 7
        push byte 18h
        mov ecx, 0A0h
        mov ebx, 58h
        mov edx, 50h
        mov eax, str_EXITTODOSY
        call ShowPromptBox
        test eax, eax
        je short loc_984CF
        call dword [bailout_vec]
loc_984CF:
        ret
ShowMessageBox:
        push esi
        push edi
        sub esp, 0A0h
        mov dword [joycalactive], 1
        push byte 0FFFFFFFFh
        call ReturnFalse
        mov edi, eax
        add esp, byte 4
        push byte 0
        call ReturnFalse
        add esp, byte 4
        push byte 0
        push byte 0Ah
        push dword 140h
        call CreateBitmap
        mov esi, eax
        add esp, byte 0Ch
        mov eax, esp
        push eax
        call SaveDrawState
        add esp, byte 4
        lea eax, [byte esp+060h]
        push eax
        call TextSaveState
        add esp, byte 4
        push DefaultFont
        call TextSetFont
        add esp, byte 4
        push esi
        call SetDrawBitmap
        add esp, byte 4
        push dword 0C8h
        push dword 0BEh
        push dword 140h
        push byte 0
        push BackBufferWidth
        call SetBitmapClip
        add esp, byte 14h
        call dword [off_D3070]
        mov ebx, 0BEh
        xor edx, edx
        mov eax, esi
        call sub_981B0
        call SetScreenTarget
        push byte 0
        call FindNearestColor
        add esp, byte 4
        push eax
        push byte 0Ah
        push dword 140h
        push dword 0BEh
        push byte 0
        call FillRect
        add esp, byte 14h
        push byte 0
        push dword 0FCFCFCh
        call FindNearestColor
        add esp, byte 4
        push eax
        call TextSetColors
        add esp, byte 8
        push dword 0BFh
        mov ebx, dword [dword esp+0B0h]
        push ebx
        call PrintStringCentered
        add esp, byte 8
        call dword [off_D3074]
        mov ecx, dword [dword esp+0B0h]
        push ecx
        call DebugLineCount
        add esp, byte 4
        call dword [off_D306C]
        mov ebx, 0BEh
        xor edx, edx
        mov eax, esi
        call sub_981D4
        call dword [off_D3074]
        lea eax, [byte esp+060h]
        push eax
        call TextRestoreState
        add esp, byte 4
        mov eax, esp
        push eax
        call RestoreDrawState
        add esp, byte 4
        push esi
        call FreeBitmap
        add esp, byte 4
        push edi
        call ReturnFalse
        add esp, byte 4
        xor esi, esi
        mov dword [joycalactive], esi
        add esp, 0A0h
        pop edi
        pop esi
        ret
        db 08Dh,040h,00h
sub_9862C:
        push byte 1
        push byte 18h
        mov ecx, 120h
        mov ebx, 58h
        mov edx, 10h
        mov eax, str_PAUSEPRESSANYKEY
        call ShowPromptBox
        ret
        db 00h,00h
DosGetVector:
        push ebx
        push es
        push ds
        push esi
        push edi
        push ebp
        LD mov, al, bl
        mov ah, 35h
        int 21h
        pop ebp
        pop edi
        pop esi
        pop ds
        LD mov, eax, ebx
        mov dx, es
        pop es
        pop ebx
        ret
DosSetVector:
        push es
        push ds
        push esi
        push edi
        push ebp
        push eax
        push edx
        mov ds, dx
        LD mov, edx, eax
        LD mov, al, bl
        mov ah, 25h
        int 21h
        pop edx
        pop eax
        pop ebp
        pop edi
        pop esi
        pop ds
        pop es
        ret
sub_9867E:
        jmp near WriteConsoleMessage
