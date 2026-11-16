; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_AA210 progbits alloc exec nowrite align=1
extern str_GF1PATCH110, str_110, GusIrqLatchBits, byte_D7A3C, byte_D7AEC, GusDmaLatchBits, byte_D87D8, byte_D89E0
extern byte_F5978, byte_F5979, byte_F597A, byte_F59F8, byte_F59F9, byte_F5A00, byte_F5A01, byte_F5A04
extern byte_F5C0B, GusPlayDmaChannel, GusIrqLatch, GusRecordDmaChannel, GusMidiIrq, GusWaveIrq, GusOpenCount, dword_D7ABC
extern dword_D87DC, dword_D87E0, dword_D89D8, dword_F59FC, dword_F6016, dword_F6116, inp_, inpw_
extern outp_, outpw_, strcmp_, strncmp_, GusProbePort, GusDosRead, GusDosClose, GusDosSeek
extern GusDosOpen, GusHookIrq, GusUnhookIrq, GusDownload, GusDramDmaDone, GusCalcVoiceAddrs, GusClearIrqState, GusEnterCritical
extern GusLeaveCritical, GusWaveIrqHandler, GusMidiIrqHandler, GusDelay, GusSetBasePort, GusClearCallbacks, GusClaimVoiceCallbacks, GusClaimTimerCallbacks
extern GusRunInitTable, GusStartTimer2, GusStopTimer2, GusAllocVoice, GusReleaseVoice, GusAddVoicePriority, GusPeek, GusPoke
extern GusTestDramBank, unk_F5BF8, GusBasePort, GusIrqStatusPort, word_D8768, word_D876A, GusVoiceSelectPort, GusRegSelectPort
extern GusDataLowPort, GusDataHighPort, word_F59FA, word_F6018, word_F6118, word_F611A, word_F6128, GusDosResult
extern GusIrqFlags, GusActiveVoices
global GusReadPatchHeader, loc_AA23E, loc_AA250, loc_AA274, loc_AA29D, loc_AA2C2, loc_AA2EE, loc_AA2F7
global GusLoadPatch, loc_AA322, loc_AA337, loc_AA34B, loc_AA38B, loc_AA39E, loc_AA3C5, loc_AA3D0
global loc_AA406, loc_AA449, loc_AA45D, loc_AA496, loc_AA4AB, loc_AA553, loc_AA56A, loc_AA587
global loc_AA58A, loc_AA5B6, loc_AA5B9, loc_AA5D0, loc_AA617, loc_AA62C, loc_AA644, loc_AA654
global loc_AA671, loc_AA679, loc_AA69C, loc_AA6B6, loc_AA6CC, loc_AA6F7, loc_AA70F, loc_AA720
global loc_AA72E, loc_AA74C, GusUnloadPatch, loc_AA775, loc_AA77D, loc_AA792, loc_AA796, loc_AA7A2
global GusSetPatchFlags, GusStopDmaAndTimers, loc_AA8A6, GusUnhookIrqs, loc_AA8D1, GusHookIrqs, loc_AA906, GusOpenCard
global loc_AA93A, loc_AA961, loc_AA982, loc_AA9B5, GusStopAllVoices, loc_AA9DF, loc_AAAC4, loc_AAAD6
global loc_AAAE8, loc_AAB44, GusOpen, loc_AAB7F, loc_AABAA, loc_AABFD, loc_AAC3E, GusClose
global loc_AAC60, loc_AACA1, loc_AACA3, GusSetIrqDmaLatches, loc_AACD1, loc_AACE3, loc_AACFF, loc_AAD0E
global GusResetVoices, loc_AAE52, loc_AAE5C, loc_AAEFC, loc_AB0F7, GusMidiInit, loc_AB19C, loc_AB1BE
global loc_AB1CC, loc_AB200, loc_AB236, loc_AB23B, GusVoiceUpdateVolume, loc_AB299, loc_AB2B8, loc_AB2E4
global loc_AB2F0, loc_AB392, loc_AB3C4, loc_AB3C6, loc_AB3CD, loc_AB3DD, loc_AB407, loc_AB430
global loc_AB461, loc_AB485, loc_AB4B0, loc_AB4BC, loc_AB4BF, loc_AB4C9, loc_AB4D6, loc_AB50D
global loc_AB519, loc_AB56C, loc_AB578, loc_AB5B9, loc_AB5C4, loc_AB5F9, GusSetChannelVolume, loc_AB672
global loc_AB67C, loc_AB699, loc_AB6B0, loc_AB6B4, GusSetChannelBend, loc_AB6F3, loc_AB722, loc_AB731
global loc_AB767, loc_AB76B, GusSetMasterVolume, loc_AB7AE, loc_AB7B8, loc_AB7CF, loc_AB7EC, loc_AB7F0
global GusSetChannelModulation, loc_AB822, loc_AB845, loc_AB87A, loc_AB89E, loc_AB8A5, loc_AB8A7, loc_AB8B7
global loc_AB8BE, loc_AB8C0, loc_AB8FF, loc_AB91A, loc_AB928, loc_AB93E, loc_AB942, jpt_AB964
global GusVibratoTick, loc_AB988, loc_AB9AF, loc_AB9DC, loc_AB9E8, loc_AB9EC, loc_AB9F7, loc_ABA2F
global loc_ABA8F, loc_ABA93, GusStartVibratoTimer, GusStopVibratoTimer, GusVoiceSetVibrato, loc_ABB16, loc_ABB24, loc_ABB75
global loc_ABC2F, GusVoiceSetEnvelope, loc_ABC6B, loc_ABC74, loc_ABCAA, loc_ABCCC, loc_ABD1C, loc_ABD24
global loc_ABD29, loc_ABD33, loc_ABD48, GusScaleRatio, GusNoteFrequency, loc_ABDCC, loc_ABDDB, loc_ABE05
global loc_ABE0F, GusVoiceStopRamp, loc_ABF4D, GusVoiceStopWave, loc_ABF95, loc_AC028, loc_AC03F, GusStopNoteVoices
global loc_AC063, loc_AC07E, loc_AC086, loc_AC0B4, GusMidiNoteOn, loc_AC0F2, loc_AC109, loc_AC13E
global loc_AC163, loc_AC16D, loc_AC197, loc_AC1B1, loc_AC1B8, loc_AC1C9, loc_AC1EA, loc_AC1ED
global loc_AC1F2, loc_AC25F, loc_AC26B, loc_AC2BE, loc_AC2EA, loc_AC322, loc_AC337, loc_AC39C
global loc_AC3A9, loc_AC3C0, loc_AC3CA, loc_AC3D4, loc_AC42A, loc_AC46F, loc_AC589, loc_AC5B4
global loc_AC5DE, loc_AC5ED, loc_AC5F8, loc_AC673, loc_AC686, loc_AC691, loc_AC6AA, loc_AC6B1
global loc_AC6CA, loc_AC6CF, loc_AC6D0, loc_AC6DC, GusMidiNoteOff, loc_AC70D, loc_AC72E, loc_AC739
global loc_AC73B, loc_AC755, loc_AC75B, loc_AC766, loc_AC853, loc_AC89B, loc_AC8EB, loc_AC8FE
global loc_AC9A0, loc_AC9F2, loc_ACA4F, loc_ACADB, loc_ACB57, loc_ACB68, loc_ACBAC, loc_ACBDA
global loc_ACBE0, loc_ACC20, loc_ACC2A, GusSetSustain, loc_ACC5D, loc_ACC70, loc_ACCA5, loc_ACCA6
global loc_ACCB2, GusVoiceWaveEnd, loc_ACD45, loc_ACD4C, loc_ACD4E, GusVoiceRampEnd, loc_ACE0F, loc_ACE1A
global loc_ACE34, loc_ACEA2, loc_ACEE5, loc_ACF30, loc_ACF65, loc_ACF8A, loc_ACFC5, loc_ACFC9
global loc_AD03E, loc_AD07F, loc_AD0B2, loc_AD0B8, loc_AD0DD, loc_AD0F3, loc_AD105, loc_AD10A
global loc_AD153, GusStopPatchVoices, loc_AD181, loc_AD197, loc_AD1A2, loc_AD1B9, loc_AD1BE, loc_AD1C3
global loc_AD1CF, loc_AD1D9, loc_AD1EE, loc_AD201, loc_AD20F, loc_AD225, loc_AD22C, loc_AD231
global loc_AD23D, loc_AD241, GusForgetPatch, loc_AD27A, loc_AD286, GusSetChannelPatch, GusSetChannelPan, loc_AD2CC
global loc_AD2E6, loc_AD324, loc_AD328, loc_AD33B, GusChannelNotesOff, loc_AD35D, loc_AD36F, loc_AD373
global loc_AD388, loc_AD39A, loc_AD39E, GusPokeBlock, loc_AD3D6, loc_AD3E5, GusPeekBlock, loc_AD411
global loc_AD41E, GusSizeDram, loc_AD450, loc_AD4A1, loc_AD4B8, loc_AD4D2, GusDramAlloc, loc_AD502
global loc_AD523, loc_AD577, loc_AD5CE, loc_AD5E2, loc_AD5EA, loc_AD603, GusDramFree, loc_AD678
global loc_AD68C, loc_AD6D0, GusDramFreeTotal, loc_AD70A, loc_AD725, loc_AD73B, loc_AD740, GusDramLargestFree
global loc_AD76E, loc_AD789, loc_AD7A5, loc_AD7AA, loc_AD7C1, loc_AD7C3, GusMixAdd8, loc_AD7E5
global loc_ADC73, loc_ADC90, GusClearMixBuffer, loc_ADCAE, loc_ADEC0, loc_ADEDE, loc_ADEE0, loc_ADEE5
GusReadPatchHeader:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov esi, edx
        call GusDosOpen
        mov ecx, eax
        test eax, eax
        jge short loc_AA23E
        mov edx, eax
        mov word [GusDosResult], ax
        neg edx
        mov eax, 10h
        mov word [GusDosResult], dx
        jmp near loc_AA2F7
loc_AA23E:
        cmp eax, byte 0FFFFFFFFh
        jne short loc_AA250
        mov eax, 11h
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AA250:
        mov ebx, 81h
        call GusDosRead
        cmp ax, 81h
        je short loc_AA274
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AA274:
        mov edx, str_GF1PATCH110
        mov ebx, 8
        mov eax, esi
        call strncmp_
        test eax, eax
        je short loc_AA29D
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AA29D:
        mov edx, str_110
        lea eax, [byte esi+08h]
        call strcmp_
        test eax, eax
        jge short loc_AA2C2
        mov eax, ecx
        call GusDosClose
        mov eax, 0Fh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AA2C2:
        mov ebx, 3Fh
        lea edx, [dword esi+081h]
        mov eax, ecx
        call GusDosRead
        cmp ax, 3Fh
        je short loc_AA2EE
        mov eax, ecx
        call GusDosClose
        mov eax, 0Eh
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AA2EE:
        mov eax, ecx
        call GusDosClose
        xor eax, eax
loc_AA2F7:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusLoadPatch:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, 0BCh
        mov esi, eax
        mov dword [byte ebp-024h], ebx
        mov dword [byte ebp-018h], ecx
        mov eax, dword [byte ebp+0Ch]
        xor ebx, ebx
        cmp bx, word [byte edx+055h]
        jb short loc_AA322
        xor eax, eax
        jmp short loc_AA34B
loc_AA322:
        add eax, byte 49h
        inc ebx
        mov dword [byte eax-035h], 0
        cmp bx, word [byte edx+055h]
        jb short loc_AA322
        xor eax, eax
        jmp short loc_AA34B
loc_AA337:
        mov ecx, dword [byte ebp-024h]
        lea ebx, [nosplit eax*4+00h]
        add ebx, ecx
        inc eax
        mov dword [byte ebx+02h], 0
loc_AA34B:
        xor ebx, ebx
        mov bl, byte [dword edx+097h]
        cmp eax, ebx
        jb short loc_AA337
        mov eax, dword [byte ebp-024h]
        mov word [byte eax+01Ah], 400h
        mov eax, esi
        mov dword [byte ebp-01Ch], ebx
        call GusDosOpen
        mov esi, eax
        mov edi, eax
        test eax, eax
        jge short loc_AA38B
        mov word [GusDosResult], ax
        neg esi
        mov eax, 10h
        mov word [GusDosResult], si
        jmp near loc_AA74C
loc_AA38B:
        cmp eax, byte 0FFFFFFFFh
        jne short loc_AA39E
        mov eax, 11h
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA39E:
        mov edx, 0C0h
        xor ebx, ebx
        call GusDosSeek
        xor edx, edx
        mov dx, ax
        test edx, edx
        je short loc_AA3C5
        mov eax, esi
        call GusDosClose
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA3C5:
        mov dword [byte ebp-034h], edx
        mov dword [byte ebp-014h], edx
        jmp near loc_AA72E
loc_AA3D0:
        lea edx, [byte ebp-064h]
        mov ebx, 2Fh
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, byte 2Fh
        je short loc_AA406
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA406:
        mov esi, dword [byte ebp-014h]
        mov edx, dword [byte ebp-024h]
        add esi, esi
        mov ah, byte [byte ebp-064h]
        add esi, edx
        test ah, ah
        je short loc_AA449
        mov edx, dword [byte ebp-034h]
        dec edx
        lea eax, [nosplit edx*8+00h]
        add eax, edx
        shl eax, 3
        add eax, edx
        mov edx, dword [byte ebp-014h]
        mov ecx, dword [byte ebp-024h]
        shl edx, 2
        mov ebx, dword [byte ebp+0Ch]
        add edx, ecx
        add eax, ebx
        mov dword [byte edx+02h], eax
        mov ax, word [byte esi+010h]
        mov word [byte esi+012h], ax
        jmp near loc_AA720
loc_AA449:
        mov al, byte [byte ebp-05Eh]
        mov word [byte esi+012h], ax
        xor al, al
        mov esi, dword [byte ebp+0Ch]
        mov dword [byte ebp-010h], eax
        jmp near loc_AA70F
loc_AA45D:
        lea edx, [dword ebp-0C4h]
        mov ebx, 60h
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, byte 60h
        je short loc_AA496
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA496:
        cmp word [byte ebp-010h], byte 0
        jne short loc_AA4AB
        mov eax, dword [byte ebp-014h]
        mov edx, dword [byte ebp-024h]
        shl eax, 2
        add eax, edx
        mov dword [byte eax+02h], esi
loc_AA4AB:
        mov eax, dword [dword ebp-0B8h]
        mov dword [esi], eax
        mov eax, dword [dword ebp-0B4h]
        mov dword [byte esi+04h], eax
        mov al, byte [dword ebp-0BDh]
        mov byte [byte esi+034h], al
        mov eax, dword [dword ebp-0AEh]
        mov dword [byte esi+08h], eax
        mov eax, dword [dword ebp-0AAh]
        mov dword [byte esi+0Ch], eax
        mov eax, dword [dword ebp-0A6h]
        mov dword [byte esi+010h], eax
        mov al, byte [dword ebp-0A0h]
        mov byte [byte esi+035h], al
        mov eax, dword [dword ebp-08Ch]
        mov word [byte esi+018h], ax
        mov eax, dword [dword ebp-08Ah]
        mov word [byte esi+01Ch], ax
        mov al, byte [dword ebp-093h]
        mov byte [byte esi+042h], al
        mov al, byte [dword ebp-092h]
        mov byte [byte esi+043h], al
        mov al, byte [dword ebp-091h]
        mov byte [byte esi+044h], al
        mov al, byte [dword ebp-090h]
        mov byte [byte esi+045h], al
        mov al, byte [dword ebp-08Fh]
        mov byte [byte esi+046h], al
        mov al, byte [dword ebp-08Eh]
        mov byte [byte esi+047h], al
        mov al, byte [dword ebp-08Dh]
        mov byte [byte esi+048h], al
        mov eax, dword [dword ebp-0B0h]
        mov word [byte esi+01Ah], ax
        mov eax, dword [dword ebp-0BCh]
        mov dword [byte esi+030h], eax
        xor eax, eax
        jmp short loc_AA56A
loc_AA553:
        inc eax
        mov bl, byte [dword eax+ebp-0A0h]
        mov byte [byte esi+eax+035h], bl
        mov bl, byte [dword eax+ebp-09Ah]
        mov byte [byte esi+eax+03Bh], bl
loc_AA56A:
        cmp eax, byte 6
        jb short loc_AA553
        mov eax, dword [byte esi+030h]
        mov dl, byte [byte ebp+010h]
        mov dword [byte ebp-028h], eax
        test dl, 1
        je short loc_AA587
        test byte [byte esi+048h], 1
        je short loc_AA587
        shr eax, 1
        jmp short loc_AA58A
loc_AA587:
        mov eax, dword [byte ebp-028h]
loc_AA58A:
        call GusDramAlloc
        mov dword [byte ebp-02Ch], eax
        mov ebx, dword [byte ebp-02Ch]
        test ebx, ebx
        jne short loc_AA5B6
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 6
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA5B6:
        mov dword [byte esi+014h], ebx
loc_AA5B9:
        mov ecx, dword [byte ebp-028h]
        test ecx, ecx
        je near loc_AA6CC
        xor eax, eax
        mov ax, word [byte ebp+08h]
        cmp eax, ecx
        jbe short loc_AA5D0
        mov eax, ecx
loc_AA5D0:
        xor ecx, ecx
        mov ebx, dword [byte ebp-028h]
        mov cx, ax
        mov edx, dword [byte ebp-018h]
        sub ebx, ecx
        mov dword [byte ebp-0Ch], eax
        mov dword [byte ebp-028h], ebx
        xor ebx, ebx
        mov edx, dword [edx]
        mov bx, ax
        mov eax, edi
        call GusDosRead
        and eax, 0FFFFh
        cmp eax, ecx
        je short loc_AA617
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, 0Eh
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA617:
        test byte [byte ebp+010h], 1
        je short loc_AA654
        test byte [byte esi+048h], 1
        je short loc_AA654
        mov eax, 1
        xor edx, edx
        jmp short loc_AA644
loc_AA62C:
        mov ebx, dword [byte ebp-018h]
        mov ebx, dword [ebx]
        lea ecx, [ebx+eax]
        add ebx, edx
        mov dword [byte ebp-030h], ebx
        mov bl, byte [ecx]
        mov ecx, dword [byte ebp-030h]
        add eax, byte 2
        inc edx
        mov byte [ecx], bl
loc_AA644:
        xor ebx, ebx
        mov bx, word [byte ebp-0Ch]
        cmp eax, ebx
        jb short loc_AA62C
        shr bx, 1
        mov dword [byte ebp-0Ch], ebx
loc_AA654:
        call GusDramDmaDone
        mov edx, eax
        test eax, eax
        jne short loc_AA69C
        mov cl, byte [byte ebp+010h]
        xor al, al
        test cl, 1
        jne short loc_AA671
        test byte [byte esi+048h], 1
        je short loc_AA671
        mov al, 40h
loc_AA671:
        test byte [byte esi+048h], 2
        je short loc_AA679
        or al, 80h
loc_AA679:
        xor ecx, ecx
        mov cl, al
        xor eax, eax
        push byte 1
        mov ax, word [byte ebp-0Ch]
        mov ebx, dword [byte ebp-02Ch]
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-018h]
        mov edx, dword [byte ebp-020h]
        call GusDownload
        mov edx, eax
        test eax, eax
        je short loc_AA6B6
loc_AA69C:
        mov eax, edi
        call GusDosClose
        mov eax, dword [byte ebp-024h]
        call GusUnloadPatch
        mov eax, edx
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
loc_AA6B6:
        call GusDramDmaDone
        mov edx, eax
        test eax, eax
        jne short loc_AA69C
        mov eax, dword [byte ebp-020h]
        add dword [byte ebp-02Ch], eax
        jmp near loc_AA5B9
loc_AA6CC:
        test byte [byte ebp+010h], 1
        je short loc_AA6F7
        test byte [byte esi+048h], 1
        je short loc_AA6F7
        mov eax, dword [esi]
        shr eax, 1
        mov ebx, dword [byte esi+030h]
        mov dword [esi], eax
        shr ebx, 1
        mov edx, dword [byte esi+04h]
        mov dword [byte esi+030h], ebx
        shr edx, 1
        mov bl, byte [byte esi+048h]
        mov dword [byte esi+04h], edx
        and bl, 0FEh
        mov byte [byte esi+048h], bl
loc_AA6F7:
        mov ecx, dword [byte ebp-010h]
        inc ecx
        mov eax, esi
        mov dword [byte ebp-010h], ecx
        mov ecx, dword [byte ebp-034h]
        call GusCalcVoiceAddrs
        inc ecx
        add esi, byte 49h
        mov dword [byte ebp-034h], ecx
loc_AA70F:
        mov al, byte [byte ebp-05Eh]
        mov edx, dword [byte ebp-010h]
        xor ah, ah
        cmp ax, dx
        ja near loc_AA45D
loc_AA720:
        mov esi, dword [byte ebp-014h]
        mov eax, dword [byte ebp-034h]
        inc esi
        inc eax
        mov dword [byte ebp-014h], esi
        mov dword [byte ebp-034h], eax
loc_AA72E:
        mov eax, dword [byte ebp-014h]
        cmp eax, dword [byte ebp-01Ch]
        jb near loc_AA3D0
        mov eax, edi
        mov edx, dword [byte ebp-024h]
        call GusDosClose
        mov eax, dword [byte ebp-01Ch]
        mov word [edx], ax
        xor eax, eax
loc_AA74C:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 0Ch
        db 08Dh,040h,00h
GusUnloadPatch:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov edx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        call GusStopPatchVoices
        xor ecx, ecx
        jmp short loc_AA7A2
loc_AA775:
        mov ebx, dword [byte edx+ecx*4+02h]
        xor esi, esi
        jmp short loc_AA796
loc_AA77D:
        mov edi, dword [byte ebx+014h]
        test edi, edi
        je short loc_AA792
        mov eax, edi
        call GusDramFree
        mov dword [byte ebx+014h], 0
loc_AA792:
        inc esi
        add ebx, byte 49h
loc_AA796:
        mov eax, dword [byte edx+ecx*2+010h]
        sar eax, 10h
        cmp esi, eax
        jl short loc_AA77D
        inc ecx
loc_AA7A2:
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        cmp ecx, eax
        jl short loc_AA775
        mov eax, edx
        mov word [edx], 0
        call GusForgetPatch
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetPatchFlags:
        push ebp
        mov ebp, esp
        mov word [byte eax+01Ah], dx
        mov esp, ebp
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h
GusStopDmaAndTimers:
        push ebp
        mov ebp, esp
        push edx
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 45h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov ax, word [GusIrqStatusPort]
        call inp_
        xor eax, eax
        mov edx, 41h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        xor eax, eax
        mov edx, 49h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        xor eax, eax
        mov edx, 8Fh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
loc_AA8A6:
        xor eax, eax
        mov ax, word [GusDataHighPort]
        inc edx
        call inp_
        cmp edx, byte 20h
        jl short loc_AA8A6
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 090h
GusUnhookIrqs:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, eax
        mov eax, edx
        cmp ebx, edx
        je short loc_AA8D1
        call GusUnhookIrq
loc_AA8D1:
        mov eax, ebx
        call GusUnhookIrq
        lea esp, [byte ebp-04h]
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusHookIrqs:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov esi, eax
        mov ebx, GusWaveIrqHandler
        mov ecx, cs
        call GusHookIrq
        cmp esi, edx
        je short loc_AA906
        mov ebx, GusMidiIrqHandler
        mov eax, edx
        mov ecx, cs
        call GusHookIrq
loc_AA906:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusOpenCard:
        push ebp
        mov ebp, esp
        push esi
        sub esp, byte 4
        mov esi, eax
        mov byte [byte ebp-08h], dl
        mov bh, cl
        mov ecx, dword [byte ebp+0Ch]
        pushfw
        cli
        mov eax, esi
        call GusSetBasePort
        mov edx, eax
        test eax, eax
        je short loc_AA93A
        popfw
        mov eax, edx
        jmp near loc_AA9B5
loc_AA93A:
        call GusClearIrqState
        call GusClearCallbacks
        xor eax, eax
        mov al, byte [byte ebp-08h]
        cmp byte [dword eax+GusIrqLatchBits], 0
        jne short loc_AA961
        popfw
        mov eax, 2
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
loc_AA961:
        mov byte [GusWaveIrq], al
        xor eax, eax
        mov al, bl
        cmp byte [dword eax+GusIrqLatchBits], 0
        jne short loc_AA982
        popfw
        mov eax, 2
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
loc_AA982:
        mov byte [GusMidiIrq], bl
        mov al, byte [byte ebp+08h]
        mov byte [GusPlayDmaChannel], bh
        mov byte [GusRecordDmaChannel], al
        mov eax, ecx
        xor edx, edx
        call GusResetVoices
        mov dl, byte [GusMidiIrq]
        xor eax, eax
        mov al, byte [GusWaveIrq]
        call GusHookIrqs
        popfw
        xor eax, eax
loc_AA9B5:
        lea esp, [byte ebp-04h]
        pop esi
        pop ebp
        ret 8
        db 08Dh,040h,00h
GusStopAllVoices:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        pushfw
        cli
        call GusEnterCritical
        xor ebx, ebx
        cmp bx, word [GusActiveVoices]
        jb short loc_AA9DF
        xor ebx, ebx
        jmp near loc_AAB44
loc_AA9DF:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, bx
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        shr eax, 8
        cmp eax, byte 5
        jbe short loc_AAAC4
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 40h
        mov ax, word [GusDataHighPort]
        call outp_
loc_AAAC4:
        inc ebx
        cmp bx, word [GusActiveVoices]
        jb near loc_AA9DF
        xor ebx, ebx
        jmp short loc_AAB44
loc_AAAD6:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, bx
        call outp_
loc_AAAE8:
        xor eax, eax
        mov edx, 8Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 3
        je short loc_AAAE8
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        inc ebx
        call outp_
loc_AAB44:
        cmp bx, word [GusActiveVoices]
        jb short loc_AAAD6
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 090h
GusOpen:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov esi, eax
        mov edx, dword [GusOpenCount]
        test edx, edx
        je short loc_AAB7F
        lea ebx, [byte edx+01h]
        xor eax, eax
        mov dword [GusOpenCount], ebx
        jmp near loc_AAC3E
loc_AAB7F:
        xor edx, edx
        mov word [GusIrqFlags], dx
        pushfw
        cli
        xor eax, eax
        mov ax, word [byte esi+02h]
        call GusProbePort
        test eax, eax
        jne short loc_AABAA
        popfw
        mov eax, 0Ah
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AABAA:
        mov byte [GusIrqLatch], 3
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [byte esi+02h]
        xor ecx, ecx
        call outp_
        xor eax, eax
        xor ebx, ebx
        mov ax, word [esi]
        mov cl, byte [byte esi+07h]
        push eax
        xor eax, eax
        mov bl, byte [byte esi+05h]
        mov al, byte [byte esi+06h]
        xor edx, edx
        push eax
        xor eax, eax
        mov dl, byte [byte esi+04h]
        mov ax, word [byte esi+02h]
        call GusOpenCard
        mov edx, eax
        test eax, eax
        je short loc_AABFD
        popfw
        mov eax, edx
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AABFD:
        call GusSetIrqDmaLatches
        mov bx, word [GusIrqFlags]
        or bl, 1
        mov word [GusIrqFlags], bx
        inc dword [GusOpenCount]
        popfw
        call GusRunInitTable
        test eax, eax
        jne short loc_AAC3E
        and byte [GusIrqLatch], 0FDh
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        mov ax, word [byte esi+02h]
        call outp_
        xor eax, eax
loc_AAC3E:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusClose:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov dx, word [GusIrqFlags]
        test dl, 1
        jne short loc_AAC60
        mov eax, 5
        jmp short loc_AACA3
loc_AAC60:
        mov edx, dword [GusOpenCount]
        dec edx
        mov dword [GusOpenCount], edx
        jne short loc_AACA1
        pushfw
        cli
        call GusStopAllVoices
        call GusStopDmaAndTimers
        mov dl, byte [GusMidiIrq]
        xor eax, eax
        mov al, byte [GusWaveIrq]
        call GusUnhookIrqs
        popfw
        mov bx, word [GusIrqFlags]
        and bl, 0FEh
        mov word [GusIrqFlags], bx
loc_AACA1:
        xor eax, eax
loc_AACA3:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetIrqDmaLatches:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        xor eax, eax
        mov al, byte [GusWaveIrq]
        mov bl, byte [dword eax+GusIrqLatchBits]
        mov al, byte [GusWaveIrq]
        cmp al, byte [GusMidiIrq]
        jne short loc_AACD1
        or bl, 40h
        jmp short loc_AACE3
loc_AACD1:
        xor eax, eax
        mov al, byte [GusMidiIrq]
        mov al, byte [dword eax+GusIrqLatchBits]
        shl al, 3
        or bl, al
loc_AACE3:
        xor eax, eax
        mov al, byte [GusPlayDmaChannel]
        mov dl, byte [GusRecordDmaChannel]
        mov cl, byte [dword eax+GusDmaLatchBits]
        cmp al, dl
        jne short loc_AACFF
        or cl, 40h
        jmp short loc_AAD0E
loc_AACFF:
        xor eax, eax
        mov al, dl
        mov al, byte [dword eax+GusDmaLatchBits]
        shl al, 3
        or cl, al
loc_AAD0E:
        pushfw
        cli
        xor eax, eax
        mov edx, 5
        mov ax, word [word_D876A]
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8768]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D876A]
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        mov al, cl
        xor edx, edx
        or al, 80h
        mov dl, al
        xor eax, eax
        mov ax, word [word_D8768]
        call outp_
        mov al, byte [GusIrqLatch]
        or al, 40h
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        and ebx, 0FFh
        mov ax, word [word_D8768]
        mov edx, ebx
        call outp_
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D8768]
        mov dl, cl
        call outp_
        mov al, byte [GusIrqLatch]
        or al, 40h
        xor edx, edx
        mov dl, al
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [word_D8768]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D876A]
        call outp_
        or byte [GusIrqLatch], 8
        xor edx, edx
        mov dl, byte [GusIrqLatch]
        xor eax, eax
        mov ax, word [GusBasePort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [word_D876A]
        call outp_
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusResetVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        cmp eax, byte 0Eh
        jge short loc_AAE52
        mov ebx, 0Eh
loc_AAE52:
        cmp ebx, byte 20h
        jle short loc_AAE5C
        mov ebx, 20h
loc_AAE5C:
        mov edx, 20h
        pushfw
        cli
        mov word [GusActiveVoices], dx
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        xor eax, eax
        mov edx, 0Eh
        mov ax, word [GusRegSelectPort]
        call outp_
        mov al, byte [GusActiveVoices]
        dec al
        xor edx, edx
        or al, 0C0h
        mov dl, al
        xor eax, eax
        mov ax, word [GusDataHighPort]
        xor ecx, ecx
        call outp_
        call GusStopDmaAndTimers
        jmp near loc_AB0F7
loc_AAEFC:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusVoiceSelectPort]
        mov dx, cx
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3Fh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0FBh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 9
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 500h
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 0Bh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 6000h
        mov ax, word [GusDataLowPort]
        inc ecx
        call outpw_
loc_AB0F7:
        cmp cx, word [GusActiveVoices]
        jb near loc_AAEFC
        call GusStopDmaAndTimers
        mov word [GusActiveVoices], bx
        xor eax, eax
        mov edx, 0Eh
        mov ax, word [GusRegSelectPort]
        call outp_
        mov al, byte [GusActiveVoices]
        dec al
        xor edx, edx
        or al, 0C0h
        mov dl, al
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        call GusStopDmaAndTimers
        xor eax, eax
        mov edx, 4Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        call GusDelay
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h
GusMidiInit:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ah, 1
        xor edx, edx
        mov byte [byte_D87D8], ah
        mov byte [byte_D7AEC], ah
        mov eax, unk_F5BF8
        jmp short loc_AB1BE
loc_AB19C:
        add eax, byte 21h
        mov byte [byte eax-0Eh], 0
        mov byte [byte eax-0Dh], 0
        mov byte [byte eax-0Ch], 40h
        mov byte [byte eax-05h], 7Fh
        mov word [byte eax-010h], 0FFh
        mov byte [byte eax-07h], 1
        inc edx
        mov byte [byte eax-0Bh], 0
loc_AB1BE:
        cmp edx, byte 20h
        jl short loc_AB19C
        mov eax, byte_F59F8
        xor edx, edx
        jmp short loc_AB200
loc_AB1CC:
        mov byte [eax], 0
        mov byte [byte eax+01h], 64h
        mov word [byte eax+02h], 400h
        mov dword [byte eax+04h], 0
        mov byte [byte eax+09h], 0
        mov byte [byte eax+0Ah], 0
        mov byte [byte eax+0Bh], 0
        mov byte [byte eax+0Ch], 0
        mov byte [byte eax+0Dh], 0
        mov byte [byte eax+0Eh], 0
        inc edx
        mov byte [byte eax+08h], 10h
        add eax, byte 10h
loc_AB200:
        cmp edx, byte 20h
        jl short loc_AB1CC
        mov ebx, 7Fh
        xor edx, edx
        mov eax, GusVoiceRampEnd
        mov word [word_F611A], dx
        mov word [word_F6118], bx
        call GusClaimTimerCallbacks
        test eax, eax
        jne short loc_AB236
        mov eax, GusVoiceWaveEnd
        call GusClaimVoiceCallbacks
        test eax, eax
        je short loc_AB23B
loc_AB236:
        mov eax, 8
loc_AB23B:
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceUpdateVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov ecx, eax
        pushfw
        cli
        mov ebx, ecx
        call GusEnterCritical
        mov eax, ebx
        shl eax, 5
        add eax, ebx
        mov ebx, unk_F5BF8
        add ebx, eax
        cmp byte [byte_D7AEC], 0
        je short loc_AB299
        xor eax, eax
        mov al, byte [byte ebx+01Ch]
        movzx esi, byte [dword eax+byte_D7A3C]
        mov eax, dword [word_F6118-2]
        sar eax, 10h
        add eax, byte 40h
        imul eax, esi
        mov dl, byte [dword edx+byte_D7A3C]
        and edx, 0FFh
        jmp short loc_AB2B8
loc_AB299:
        xor eax, eax
        mov esi, dword [word_F6118-2]
        mov al, byte [byte ebx+01Ch]
        sar esi, 10h
        add eax, 80h
        add esi, byte 40h
        imul eax, esi
        add edx, 80h
loc_AB2B8:
        imul edx, eax
        mov esi, 0BE41h
        mov eax, edx
        sar edx, 1Fh
        idiv esi
        mov word [byte ebx+011h], ax
        mov eax, dword [ebx]
        cmp byte [byte eax+044h], 0
        jne short loc_AB2E4
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+byte_F5A04], 0
        je short loc_AB2F0
loc_AB2E4:
        xor edx, edx
        mov eax, ecx
        mov dl, byte [byte ebx+01Dh]
        call GusVoiceSetEnvelope
loc_AB2F0:
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        mov edx, 0Dh
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        and cl, 47h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        sar eax, 4
        movzx esi, byte [byte ebx+01Bh]
        mov ch, byte [byte ebx+016h]
        mov dword [byte ebp-01Ch], eax
        test ch, ch
        jne near loc_AB3DD
        mov al, byte [byte ebx+01Fh]
        cmp al, byte [byte ebx+020h]
        je short loc_AB3C6
        cmp esi, byte 3
        jne short loc_AB392
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je short loc_AB392
        test byte [byte ebx+013h], 2
        jne short loc_AB3C6
loc_AB392:
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebx+01Fh]
        mov al, byte [byte ebx+020h]
        mov ecx, edx
        mov edx, dword [byte ebp-01Ch]
        sub ecx, eax
        shl eax, 4
        sub edx, eax
        shl edx, 0Ah
        shl ecx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov dword [byte ebx+04h], eax
        test eax, eax
        jge short loc_AB3C4
        imul eax, byte 0FFFFFFFFh
        mov dword [byte ebx+04h], eax
        jmp short loc_AB3CD
loc_AB3C4:
        jne short loc_AB3CD
loc_AB3C6:
        mov dword [byte ebx+04h], 400h
loc_AB3CD:
        cmp dword [byte ebx+04h], 400h
        jle short loc_AB3DD
        mov dword [byte ebx+04h], 400h
loc_AB3DD:
        test esi, esi
        jne short loc_AB407
        mov eax, dword [ebx]
        mov dword [byte ebp-014h], esi
        xor edx, edx
        mov al, byte [byte eax+03Ch]
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        jmp near loc_AB4BF
loc_AB407:
        cmp esi, byte 6
        jl short loc_AB430
        mov edx, dword [ebx]
        mov dl, byte [byte edx+041h]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        jmp near loc_AB4BC
loc_AB430:
        cmp esi, byte 3
        jne short loc_AB485
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je short loc_AB485
        test byte [byte ebx+013h], 2
        je short loc_AB461
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebx+01Eh]
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov dword [byte ebp-014h], eax
        mov ecx, eax
        jmp short loc_AB4BF
loc_AB461:
        mov al, byte [byte esi+eax+03Ch]
        xor edi, edi
        and eax, 0FFh
        mov di, word [byte ebx+011h]
        imul eax, edi
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        xor eax, eax
        mov al, byte [byte ebx+01Eh]
        jmp short loc_AB4B0
loc_AB485:
        mov eax, dword [ebx]
        add eax, esi
        mov dword [byte ebp-020h], eax
        xor edi, edi
        mov edx, dword [byte ebp-020h]
        xor eax, eax
        mov di, word [byte ebx+011h]
        mov al, byte [byte edx+03Ch]
        imul eax, edi
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov edx, dword [byte ebp-020h]
        mov ecx, eax
        xor eax, eax
        mov al, byte [byte edx+03Bh]
loc_AB4B0:
        imul eax, edi
        xor edx, edx
        mov edi, 0FFh
        div edi
loc_AB4BC:
        mov dword [byte ebp-014h], eax
loc_AB4BF:
        cmp ecx, byte 5
        jae short loc_AB4C9
        mov ecx, 5
loc_AB4C9:
        cmp dword [byte ebp-014h], byte 5
        jae short loc_AB4D6
        mov dword [byte ebp-014h], 5
loc_AB4D6:
        mov edi, dword [byte ebp-014h]
        mov edx, ecx
        mov eax, dword [byte ebx+04h]
        sub edx, edi
        imul edx, eax
        add edx, 200h
        mov eax, edx
        sar edx, 1Fh
        shl edx, 0Ah
        LD sbb, eax, edx
        sar eax, 0Ah
        lea edx, [edi+eax]
        mov dword [byte ebp-018h], edx
        cmp edx, 0FBh
        jbe short loc_AB50D
        mov dword [byte ebp-018h], 0FBh
        jmp short loc_AB519
loc_AB50D:
        cmp edx, byte 5
        jae short loc_AB519
        mov dword [byte ebp-018h], 5
loc_AB519:
        mov edi, dword [byte ebp-01Ch]
        shr edi, 4
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp-01Ch], edi
        cmp eax, edi
        jae short loc_AB56C
        or byte [byte ebx+015h], 40h
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-018h]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        jmp short loc_AB5B9
loc_AB56C:
        jbe short loc_AB5C4
        cmp esi, byte 3
        jle short loc_AB578
        mov dword [byte ebp-018h], edi
        jmp short loc_AB5C4
loc_AB578:
        and byte [byte ebx+015h], 0BFh
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-018h]
loc_AB5B9:
        mov ax, word [GusDataHighPort]
        call outp_
loc_AB5C4:
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-01Ch]
        je short loc_AB5F9
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+01Fh], cl
        call outp_
        xor eax, eax
        mov edx, 43h
        mov ax, word [GusDataHighPort]
        call outp_
loc_AB5F9:
        mov al, byte [byte ebx+01Bh]
        mov dl, byte [byte ebx+015h]
        inc al
        or dl, 20h
        mov byte [byte ebx+016h], al
        mov byte [byte ebx+015h], dl
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetChannelVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov dword [byte ebp-010h], eax
        mov ebx, edx
        cmp edx, byte 1
        jae short loc_AB672
        mov ebx, 1
        jmp short loc_AB67C
loc_AB672:
        cmp edx, byte 7Fh
        jbe short loc_AB67C
        mov ebx, 7Fh
loc_AB67C:
        pushfw
        cli
        mov ecx, dword [byte ebp-010h]
        call GusEnterCritical
        shl ecx, 4
        mov esi, unk_F5BF8
        mov byte [dword ecx+byte_F59F9], bl
        xor ecx, ecx
        jmp short loc_AB6B4
loc_AB699:
        test byte [byte esi+013h], 1
        je short loc_AB6B0
        mov dl, byte [byte ebp-010h]
        cmp dl, byte [byte esi+01Dh]
        jne short loc_AB6B0
        mov eax, ecx
        mov edx, ebx
        call GusVoiceUpdateVolume
loc_AB6B0:
        inc ecx
        add esi, byte 21h
loc_AB6B4:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ecx, eax
        jb short loc_AB699
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusSetChannelBend:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 4
        mov dword [byte ebp-014h], eax
        mov edi, edx
        pushfw
        cli
        call GusEnterCritical
        mov ecx, unk_F5BF8
        xor esi, esi
        jmp near loc_AB76B
loc_AB6F3:
        test byte [byte ecx+013h], 1
        je short loc_AB767
        mov dh, byte [byte ebp-014h]
        cmp dh, byte [byte ecx+01Dh]
        jne short loc_AB767
        xor edx, edx
        mov dx, word [byte ecx+08h]
        imul edx, edi
        sar edx, 0Ah
        mov word [byte ecx+0Ah], dx
        mov edx, dword [ecx]
        cmp byte [byte edx+047h], 0
        jne short loc_AB722
        cmp byte [dword eax+byte_F5A01], 0
        je short loc_AB731
loc_AB722:
        mov edx, 1
        mov ebx, dword [byte ebp-014h]
        mov eax, esi
        call GusVoiceSetVibrato
loc_AB731:
        xor eax, eax
        mov edx, esi
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ecx+0Ah]
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
loc_AB767:
        inc esi
        add ecx, byte 21h
loc_AB76B:
        xor edx, edx
        mov dx, word [GusActiveVoices]
        mov eax, dword [byte ebp-014h]
        shl eax, 4
        cmp esi, edx
        jb near loc_AB6F3
        mov word [dword eax+word_F59FA], di
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSetMasterVolume:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        cmp eax, byte 1
        jge short loc_AB7AE
        mov eax, 1
        jmp short loc_AB7B8
loc_AB7AE:
        cmp eax, byte 7Fh
        jle short loc_AB7B8
        mov eax, 7Fh
loc_AB7B8:
        mov ecx, unk_F5BF8
        mov word [word_F6118], ax
        pushfw
        cli
        call GusEnterCritical
        xor ebx, ebx
        jmp short loc_AB7F0
loc_AB7CF:
        test byte [byte ecx+013h], 1
        je short loc_AB7EC
        xor eax, eax
        mov al, byte [byte ecx+01Dh]
        shl eax, 4
        xor edx, edx
        mov dl, byte [dword eax+byte_F59F9]
        mov eax, ebx
        call GusVoiceUpdateVolume
loc_AB7EC:
        inc ebx
        add ecx, byte 21h
loc_AB7F0:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short loc_AB7CF
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusSetChannelModulation:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov dword [byte ebp-018h], eax
        test edx, edx
        jne short loc_AB822
        mov dword [byte ebp-01Ch], edx
        jmp short loc_AB845
loc_AB822:
        mov ecx, edx
        shl ecx, 4
        sub ecx, edx
        add ecx, ecx
        mov edx, ecx
        mov eax, ecx
        sar edx, 1Fh
        shl edx, 7
        LD sbb, eax, edx
        sar eax, 7
        add eax, byte 2
        mov ebx, 0C8h
        mov dword [byte ebp-01Ch], eax
loc_AB845:
        mov esi, dword [byte ebp-018h]
        shl esi, 4
        pushfw
        cli
        add esi, byte_F59F8
        call GusEnterCritical
        xor eax, eax
        mov byte [byte esi+0Bh], 0
        mov ecx, unk_F5BF8
        mov al, byte [byte esi+09h]
        mov byte [byte esi+0Ah], bl
        mov dword [byte ebp-020h], eax
        mov al, byte [byte ebp-01Ch]
        xor edi, edi
        mov byte [byte esi+09h], al
        jmp near loc_AB942
loc_AB87A:
        test byte [byte ecx+013h], 1
        je near loc_AB93E
        mov dl, byte [byte ebp-018h]
        cmp dl, byte [byte ecx+01Dh]
        jne near loc_AB93E
        cmp dword [byte ebp-020h], byte 0
        jne short loc_AB89E
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        je short loc_AB8A5
loc_AB89E:
        mov eax, 1
        jmp short loc_AB8A7
loc_AB8A5:
        xor eax, eax
loc_AB8A7:
        mov edx, eax
        cmp dword [byte ebp-01Ch], byte 0
        jne short loc_AB8B7
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        je short loc_AB8BE
loc_AB8B7:
        mov eax, 1
        jmp short loc_AB8C0
loc_AB8BE:
        xor eax, eax
loc_AB8C0:
        test edx, edx
        setne dl
        and edx, 0FFh
        mov dword [byte ebp-014h], edx
        test eax, eax
        setne dl
        and edx, 0FFh
        xor edx, dword [byte ebp-014h]
        je short loc_AB91A
        test eax, eax
        je short loc_AB8FF
        mov dx, word [word_F611A]
        mov ebx, edx
        inc ebx
        mov word [word_F611A], bx
        test dx, dx
        jne short loc_AB8FF
        call GusStartVibratoTimer
        jmp short loc_AB91A
loc_AB8FF:
        test eax, eax
        jne short loc_AB91A
        mov dx, word [word_F611A]
        dec dx
        mov word [word_F611A], dx
        jne short loc_AB91A
        call GusStopVibratoTimer
loc_AB91A:
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        jne short loc_AB928
        cmp byte [byte esi+09h], 0
        je short loc_AB93E
loc_AB928:
        mov edx, dword [byte ebp-01Ch]
        mov ebx, dword [byte ebp-018h]
        test edx, edx
        sete al
        xor edx, edx
        mov dl, al
        mov eax, edi
        call GusVoiceSetVibrato
loc_AB93E:
        inc edi
        add ecx, byte 21h
loc_AB942:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edi, eax
        jb near loc_AB87A
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
jpt_AB964:
        dd loc_AB9F7
        dd loc_AB9DC
        dd loc_AB9E8
        dd loc_AB9EC
GusVibratoTick:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        mov ebx, unk_F5BF8
        xor esi, esi
        jmp near loc_ABA93
loc_AB988:
        test byte [byte ebx+013h], 1
        je near loc_ABA8F
        mov eax, dword [ebx]
        cmp byte [byte eax+047h], 0
        jne short loc_AB9AF
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+byte_F5A01], 0
        je near loc_ABA8F
loc_AB9AF:
        mov edx, dword [byte ebx+0Ah]
        xor eax, eax
        sar edx, 10h
        mov al, byte [byte ebx+017h]
        imul eax, edx
        xor ecx, ecx
        mov cl, byte [byte ebx+01Ah]
        xor edx, edx
        div ecx
        mov ecx, eax
        mov al, byte [byte ebx+019h]
        cmp al, 3
        ja short loc_AB9F7
        and eax, 0FFh
        jmp dword [nosplit cs:eax*4+jpt_AB964]
loc_AB9DC:
        mov eax, dword [byte ebx+0Ah]
        sar eax, 10h
        sub eax, ecx
        mov ecx, eax
        jmp short loc_AB9F7
loc_AB9E8:
        neg ecx
        jmp short loc_AB9F7
loc_AB9EC:
        mov eax, dword [byte ebx+0Ah]
        sar eax, 10h
        sub eax, ecx
        imul ecx, eax, byte 0FFFFFFFFh
loc_AB9F7:
        cmp byte [byte ebx+018h], 0
        je short loc_ABA2F
        mov eax, dword [ebx]
        mov dl, byte [byte eax+045h]
        test dl, dl
        je short loc_ABA2F
        mov al, dl
        mov dl, byte [byte ebx+018h]
        and eax, 0FFh
        movzx edi, dl
        dec dl
        sub eax, edi
        mov byte [byte ebx+018h], dl
        mov edx, ecx
        imul edx, eax
        mov eax, dword [ebx]
        xor ecx, ecx
        mov cl, byte [byte eax+045h]
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov ecx, eax
loc_ABA2F:
        xor eax, eax
        mov edx, esi
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        mov dx, word [byte ebx+0Ah]
        xor eax, eax
        add edx, ecx
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
        mov dh, byte [byte ebx+017h]
        inc dh
        mov cl, byte [byte ebx+01Ah]
        mov byte [byte ebx+017h], dh
        cmp dh, cl
        jb short loc_ABA8F
        xor edx, edx
        mov dl, byte [byte ebx+019h]
        inc edx
        mov ecx, 4
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        mov byte [byte ebx+017h], 0
        mov byte [byte ebx+019h], dl
loc_ABA8F:
        inc esi
        add ebx, byte 21h
loc_ABA93:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp esi, eax
        jb near loc_AB988
        xor eax, eax
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusStartVibratoTimer:
        push ebp
        mov ebp, esp
        push edx
        mov eax, GusVibratoTick
        mov edx, 0BBh
        call GusStartTimer2
        lea esp, [byte ebp-04h]
        pop edx
        pop ebp
        ret
        db 08Dh,040h,00h
GusStopVibratoTimer:
        push ebp
        mov ebp, esp
        call GusStopTimer2
        mov esp, ebp
        pop ebp
        ret
GusVoiceSetVibrato:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        sub esp, byte 18h
        mov ecx, eax
        mov dword [byte ebp-018h], edx
        mov eax, ebx
        mov ebx, ecx
        shl ebx, 5
        shl eax, 4
        add ebx, ecx
        add eax, byte_F59F8
        add ebx, unk_F5BF8
        movzx esi, byte [byte eax+09h]
        mov ecx, dword [ebx]
        test esi, esi
        je short loc_ABB16
        xor edx, edx
        mov dl, byte [byte eax+0Ah]
        mov al, byte [byte eax+0Bh]
        and eax, 0FFh
        jmp short loc_ABB24
loc_ABB16:
        movzx esi, byte [byte ecx+047h]
        xor eax, eax
        xor edx, edx
        mov al, byte [byte ecx+045h]
        mov dl, byte [byte ecx+046h]
loc_ABB24:
        mov dword [byte ebp-014h], eax
        imul eax, edx, dword 91Eh
        mov ecx, 64h
        add eax, 1388h
        xor edx, edx
        div ecx
        mov ecx, eax
        lea edi, [nosplit eax*4+00h]
        xor edx, edx
        mov eax, 0B0E9h
        div edi
        xor edx, edx
        mov byte [byte ebx+01Ah], al
        mov eax, 0B0E9h
        div edi
        add ecx, ecx
        lea eax, [byte ebx+01Ah]
        cmp edx, ecx
        seta dl
        and edx, 0FFh
        add byte [eax], dl
        cmp byte [byte ebx+01Ah], 0
        jne short loc_ABB75
        mov byte [byte ebx+01Ah], 1
loc_ABB75:
        mov ecx, 15h
        mov eax, esi
        xor edx, edx
        div ecx
        mov edi, 0Ch
        xor edx, edx
        mov ecx, eax
        div edi
        mov dword [byte ebp-01Ch], edx
        lea edi, [byte ecx+01h]
        mov edx, 0Ch
        mov eax, edi
        mov dword [byte ebp-010h], edx
        xor edx, edx
        div dword [byte ebp-010h]
        mov eax, 0Ch
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-010h], eax
        xor edx, edx
        mov eax, ecx
        mov ecx, dword [byte ebp-010h]
        div ecx
        mov ecx, eax
        mov eax, 0Ch
        xor edx, edx
        mov dword [byte ebp-010h], eax
        mov eax, edi
        div dword [byte ebp-010h]
        mov edx, dword [byte ebp-01Ch]
        mov edx, dword [nosplit edx*4+dword_D7ABC]
        shl edx, cl
        mov dword [byte ebp-024h], edx
        mov edx, dword [byte ebp-020h]
        mov cl, al
        mov edi, dword [nosplit edx*4+dword_D7ABC]
        mov eax, esi
        shl edi, cl
        xor edx, edx
        mov ecx, 15h
        div ecx
        mov eax, dword [byte ebp-024h]
        sub edi, eax
        mov eax, edi
        imul eax, edx
        xor edx, edx
        div ecx
        add eax, dword [byte ebp-024h]
        xor edx, edx
        mov dx, word [byte ebx+0Ah]
        imul edx, eax
        xor eax, eax
        shr edx, 0Ah
        mov ax, word [byte ebx+0Ah]
        sub edx, eax
        mov eax, edx
        shr eax, 1
        mov ecx, dword [byte ebp-018h]
        mov word [byte ebx+0Ch], ax
        test ecx, ecx
        je short loc_ABC2F
        mov byte [byte ebx+017h], 0
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+019h], 0
        mov byte [byte ebx+018h], al
loc_ABC2F:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
        db 090h
GusVoiceSetEnvelope:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 8
        mov ecx, edx
        mov ebx, unk_F5BF8
        mov edi, byte_F59F8
        mov edx, eax
        shl ecx, 4
        shl eax, 5
        add edi, ecx
        xor ecx, ecx
        add eax, edx
        mov cl, byte [byte edi+0Ch]
        add ebx, eax
        test ecx, ecx
        je short loc_ABC6B
        movzx edi, byte [byte edi+0Dh]
        jmp short loc_ABC74
loc_ABC6B:
        mov edi, dword [ebx]
        mov cl, byte [byte edi+044h]
        movzx edi, byte [byte edi+043h]
loc_ABC74:
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Eh]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov esi, 0FFh
        xor edx, edx
        div esi
        lea edx, [byte ecx+01h]
        mov ecx, edx
        shr ecx, 3
        shr edx, 4
        mov dword [byte ebp-014h], ecx
        mov ecx, eax
        sub ecx, edx
        cmp ecx, byte 5
        jae short loc_ABCAA
        lea eax, [byte edx+05h]
loc_ABCAA:
        lea ecx, [eax+edx]
        mov dword [byte ebp-018h], ecx
        mov ecx, dword [byte ebp-014h]
        mov esi, dword [byte ebp-018h]
        and ecx, byte 1
        add esi, ecx
        cmp esi, 0FBh
        jbe short loc_ABCCC
        mov eax, 0FBh
        sub eax, edx
        sub eax, ecx
loc_ABCCC:
        mov ah, al
        sub ah, dl
        mov byte [byte ebx+0Eh], ah
        mov ah, byte [byte ebp-014h]
        add al, dl
        and ah, 1
        xor edx, edx
        add al, ah
        mov dl, al
        mov byte [byte ebx+0Fh], al
        xor eax, eax
        mov al, byte [byte ebx+0Eh]
        sub edx, eax
        xor esi, esi
        shl edx, 4
        mov si, word [GusActiveVoices]
        imul edi, dword 91Eh
        shl esi, 4
        imul esi, edx
        mov eax, 4C4B40h
        add edi, 1388h
        xor edx, edx
        div edi
        xor ecx, ecx
        imul edi, eax, dword 186A0h
        jmp short loc_ABD24
loc_ABD1C:
        cmp esi, edi
        ja short loc_ABD29
        shl esi, 3
        inc ecx
loc_ABD24:
        cmp ecx, byte 3
        jbe short loc_ABD1C
loc_ABD29:
        cmp ecx, byte 3
        jbe short loc_ABD33
        mov ecx, 3
loc_ABD33:
        mov eax, edi
        shr eax, 1
        xor edx, edx
        add eax, esi
        div edi
        mov byte [byte ebx+010h], al
        cmp al, 3Fh
        jbe short loc_ABD48
        mov byte [byte ebx+010h], 3Fh
loc_ABD48:
        mov al, cl
        mov dl, byte [byte ebx+010h]
        shl al, 6
        or dl, al
        mov byte [byte ebx+010h], dl
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusScaleRatio:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        mov esi, eax
        mov ecx, edx
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        shl ebx, 9
        sar eax, 1
        xor edx, edx
        add eax, ebx
        div ecx
        mov ebx, eax
        mov eax, esi
        shl ebx, 9
        shr eax, 1
        xor edx, edx
        add eax, ebx
        div esi
        mov ebx, eax
        call GusLeaveCritical
        popfw
        mov eax, ebx
        lea esp, [byte ebp-08h]
        pop esi
        pop ecx
        pop ebp
        ret
        db 090h
GusNoteFrequency:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        xor ebx, ebx
        mov bx, word [byte eax+018h]
        mov ax, word [byte eax+01Ch]
        sub edx, ebx
        and eax, 0FFFFh
        imul edx, eax
        mov ecx, edx
        sar edx, 0Ah
        add edx, ebx
        and ecx, 3FFh
        test edx, edx
        jge short loc_ABDCC
        xor edx, edx
loc_ABDCC:
        cmp edx, 80h
        jl short loc_ABDDB
        mov eax, dword [dword_D89D8]
        jmp short loc_ABE0F
loc_ABDDB:
        mov eax, dword [nosplit edx*4+dword_D87DC]
        mov ebx, dword [nosplit edx*4+dword_D87E0]
        cmp edx, byte 5Fh
        jl short loc_ABE05
        sar eax, 5
        sub ebx, eax
        imul ebx, ecx
        sar ebx, 0Ah
        add eax, ebx
        shl eax, 5
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
loc_ABE05:
        sub ebx, eax
        imul ecx, ebx
        sar ecx, 0Ah
        add eax, ecx
loc_ABE0F:
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceStopRamp:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov edx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        mov ebx, eax
        shl ebx, 5
        add ebx, eax
        add ebx, unk_F5BF8
        mov ah, byte [byte ebx+013h]
        test ah, 1
        je near loc_ABF4D
        mov cl, ah
        and cl, 0F1h
        xor eax, eax
        mov ch, cl
        mov byte [byte ebx+013h], cl
        or ch, 0Ch
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ebx+013h], ch
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        shr eax, 8
        cmp eax, byte 5
        jbe near loc_ABF4D
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], 40h
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3Fh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
loc_ABF4D:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusVoiceStopWave:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        pushfw
        cli
        mov ecx, ebx
        call GusEnterCritical
        mov eax, ecx
        shl eax, 5
        add eax, ecx
        mov ecx, unk_F5BF8
        add ecx, eax
        test byte [byte ecx+013h], 1
        je near loc_AC03F
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusVoiceSelectPort]
        call outp_
loc_ABF95:
        xor eax, eax
        mov edx, 8Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call inp_
        test al, 3
        je short loc_ABF95
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        mov byte [byte ecx+013h], 0
        mov eax, ebx
        mov byte [byte ecx+016h], 0
        xor dl, dl
        call GusReleaseVoice
        mov byte [nosplit ebx*4+byte_F5978], dl
        mov byte [nosplit ebx*4+byte_F5979], dl
        mov eax, dword [ecx]
        cmp byte [byte eax+047h], 0
        jne short loc_AC028
        xor eax, eax
        mov al, byte [byte ecx+01Dh]
        shl eax, 4
        cmp byte [dword eax+byte_F5A01], 0
        je short loc_AC03F
loc_AC028:
        mov dx, word [word_F611A]
        dec dx
        mov word [word_F611A], dx
        jne short loc_AC03F
        call GusStopVibratoTimer
loc_AC03F:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusStopNoteVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        xor edx, edx
loc_AC063:
        lea ebx, [nosplit edx*2+00h]
        mov eax, dword [dword ebx+ecx*8+dword_F6016]
        sar eax, 10h
        cmp eax, byte 0FFFFFFFFh
        je short loc_AC07E
        call GusVoiceStopRamp
loc_AC07E:
        inc edx
        cmp edx, byte 4
        jl short loc_AC063
        xor edx, edx
loc_AC086:
        lea eax, [nosplit edx*2+00h]
        mov ebx, dword [dword eax+ecx*8+dword_F6016]
        sar ebx, 10h
        cmp ebx, byte 0FFFFFFFFh
        je short loc_AC0B4
        mov eax, ebx
        mov esi, ebx
        shl eax, 5
        test byte [dword esi+eax+byte_F5C0B], 1
        je short loc_AC0B4
        mov eax, ebx
        call GusVoiceStopWave
loc_AC0B4:
        inc edx
        cmp edx, byte 4
        jl short loc_AC086
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusMidiNoteOn:
        push ebp
        mov ebp, esp
        push esi
        push edi
        sub esp, byte 38h
        mov edi, eax
        mov dword [byte ebp-02Ch], edx
        mov dword [byte ebp-01Ch], ebx
        mov dword [byte ebp-014h], ecx
        test ecx, ecx
        jne short loc_AC0F2
        mov edx, dword [byte ebp+08h]
        mov eax, ebx
        call GusMidiNoteOff
        jmp near loc_AC6DC
loc_AC0F2:
        mov eax, dword [byte ebp+08h]
        mov edx, byte_F59F8
        shl eax, 4
        add edx, eax
        mov dword [byte ebp-010h], edx
        test edi, edi
        jne short loc_AC109
        mov edi, dword [byte edx+04h]
loc_AC109:
        test edi, edi
        je near loc_AC6DC
        pushfw
        cli
        call GusEnterCritical
        mov ebx, 0FFFFFFFFh
        mov eax, dword [byte edi-02h]
        xor ecx, ecx
        sar eax, 10h
        mov dword [byte ebp-040h], ebx
        mov dword [byte ebp-018h], ecx
        mov dword [byte ebp-020h], eax
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-020h]
        jl short loc_AC13E
        xor edx, edx
        jmp near loc_AC6D0
loc_AC13E:
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp+eax*4-040h], 0FFFFFFFFh
        mov esi, dword [byte edi+eax*4+02h]
        cmp word [byte esi+01Ch], 400h
        je short loc_AC163
        mov edx, dword [byte ebp-01Ch]
        mov eax, esi
        call GusNoteFrequency
        mov ebx, eax
        jmp short loc_AC16D
loc_AC163:
        mov ebx, dword [byte ebp-01Ch]
        mov ebx, dword [nosplit ebx*4+dword_D87DC]
loc_AC16D:
        cmp word [byte edi+01Ah], 400h
        je short loc_AC1B8
        xor ecx, ecx
        cmp ebx, 80000h
        jl short loc_AC197
        sar ebx, 4
        mov ecx, 1
        cmp ebx, 80000h
        jl short loc_AC197
        mov ecx, 2
        sar ebx, 4
loc_AC197:
        xor eax, eax
        mov ax, word [byte edi+01Ah]
        imul ebx, eax
        add ebx, 200h
        shr ebx, 0Ah
        test ecx, ecx
        je short loc_AC1B1
        shl ebx, 4
        dec ecx
loc_AC1B1:
        test ecx, ecx
        je short loc_AC1B8
        shl ebx, 4
loc_AC1B8:
        mov eax, dword [byte ebp-018h]
        mov eax, dword [byte edi+eax*2+010h]
        sar eax, 10h
        xor edx, edx
        mov dword [byte ebp-024h], eax
        jmp short loc_AC1ED
loc_AC1C9:
        mov eax, dword [byte esi+0Ch]
        lea ecx, [byte esi+049h]
        cmp ebx, eax
        jg short loc_AC1EA
        cmp ebx, dword [byte esi+08h]
        jl short loc_AC1EA
        mov eax, dword [byte ebp-024h]
        dec eax
        cmp edx, eax
        jge short loc_AC1F2
        cmp ebx, dword [byte ecx+0Ch]
        jg short loc_AC1F2
        cmp ebx, dword [byte ecx+08h]
        jl short loc_AC1F2
loc_AC1EA:
        mov esi, ecx
        inc edx
loc_AC1ED:
        cmp edx, dword [byte ebp-024h]
        jl short loc_AC1C9
loc_AC1F2:
        cmp edx, dword [byte ebp-024h]
        je near loc_AC673
        mov eax, dword [byte ebp-02Ch]
        mov edx, GusStopNoteVoices
        call GusAllocVoice
        mov edx, eax
        mov dword [byte ebp-028h], eax
        cmp eax, byte 0FFFFFFFFh
        je near loc_AC673
        mov eax, dword [byte ebp-018h]
        mov dword [byte ebp+eax*4-040h], edx
        mov al, byte [byte ebp-01Ch]
        xor ah, ah
        mov byte [nosplit edx*4+byte_F5979], al
        mov byte [nosplit edx*4+byte_F5978], ah
        mov al, byte [byte ebp+08h]
        mov byte [nosplit edx*4+byte_F597A], al
        mov eax, edx
        shl edx, 5
        mov ecx, unk_F5BF8
        add edx, eax
        add ecx, edx
        mov al, byte [byte ebp+08h]
        mov edx, dword [byte ebp-014h]
        mov byte [byte ecx+01Dh], al
        cmp edx, byte 1
        jge short loc_AC25F
        mov dword [byte ebp-014h], 1
        jmp short loc_AC26B
loc_AC25F:
        cmp edx, byte 7Fh
        jle short loc_AC26B
        mov dword [byte ebp-014h], 7Fh
loc_AC26B:
        mov al, byte [byte ebp-014h]
        mov dl, byte [byte_D7AEC]
        mov byte [byte ecx+01Ch], al
        test dl, dl
        je short loc_AC2BE
        mov edx, dword [byte ebp-014h]
        xor eax, eax
        mov al, byte [dword edx+byte_D7A3C]
        mov dword [byte ebp-030h], eax
        mov eax, dword [word_F6118-2]
        sar eax, 10h
        mov edx, dword [byte ebp-030h]
        add eax, byte 40h
        imul edx, eax
        mov eax, dword [byte ebp-010h]
        mov dword [byte ebp-0Ch], edx
        mov al, byte [byte eax+01h]
        and eax, 0FFh
        mov dword [byte ebp-030h], eax
        mov edx, dword [byte ebp-030h]
        xor eax, eax
        mov al, byte [dword edx+byte_D7A3C]
        mov edx, dword [byte ebp-0Ch]
        imul edx, eax
        jmp short loc_AC2EA
loc_AC2BE:
        mov eax, dword [word_F6118-2]
        mov edx, dword [byte ebp-014h]
        sar eax, 10h
        add edx, 80h
        add eax, byte 40h
        imul edx, eax
        mov dword [byte ebp-0Ch], edx
        mov edx, dword [byte ebp-010h]
        xor eax, eax
        mov al, byte [byte edx+01h]
        lea edx, [dword eax+080h]
        imul edx, dword [byte ebp-0Ch]
loc_AC2EA:
        mov dword [byte ebp-0Ch], 0BE41h
        mov eax, edx
        sar edx, 1Fh
        idiv dword [byte ebp-0Ch]
        mov word [byte ecx+011h], ax
        xor eax, eax
        mov dword [ecx], esi
        mov ax, word [byte esi+02Eh]
        mov edx, dword [byte esi+010h]
        call GusScaleRatio
        mov word [byte ecx+08h], ax
        mov eax, dword [byte ebp-010h]
        cmp word [byte eax+02h], 400h
        jne short loc_AC322
        mov ax, word [byte ecx+08h]
        jmp short loc_AC337
loc_AC322:
        mov ebx, dword [byte ebp-010h]
        xor eax, eax
        xor edx, edx
        mov ax, word [byte ecx+08h]
        mov dx, word [byte ebx+02h]
        imul eax, edx
        shr eax, 0Ah
loc_AC337:
        mov word [byte ecx+0Ah], ax
        xor eax, eax
        mov edx, dword [byte ebp-028h]
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 1
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ecx+0Ah]
        mov ax, word [GusDataLowPort]
        add edx, edx
        call outpw_
        xor eax, eax
        mov edx, 0Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+08h], 10h
        je short loc_AC39C
        xor edx, edx
        mov dl, byte [byte eax+08h]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        jmp short loc_AC3A9
loc_AC39C:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte esi+035h]
loc_AC3A9:
        call outp_
        mov byte [byte ecx+014h], 0
        mov byte [byte ecx+015h], 0
        test byte [byte esi+048h], 4
        je short loc_AC3C0
        or byte [byte ecx+014h], 8
loc_AC3C0:
        test byte [byte esi+048h], 1
        je short loc_AC3CA
        or byte [byte ecx+014h], 4
loc_AC3CA:
        test byte [byte esi+048h], 8
        je short loc_AC3D4
        or byte [byte ecx+014h], 10h
loc_AC3D4:
        test byte [byte esi+048h], 10h
        je short loc_AC42A
        mov edx, 0Bh
        mov bh, byte [byte ecx+014h]
        xor eax, eax
        or bh, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+014h], bh
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+02Ah]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+02Ch]
        jmp short loc_AC46F
loc_AC42A:
        xor eax, eax
        mov edx, 0Bh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+01Eh]
        call outpw_
        xor eax, eax
        mov edx, 0Ah
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+020h]
loc_AC46F:
        call outpw_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+022h]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+024h]
        call outpw_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+026h]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataLowPort]
        mov dx, word [byte esi+028h]
        call outpw_
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+01Bh], 0
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte esi+036h]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte esi+03Ch]
        mov ax, word [byte ecx+011h]
        imul eax, edx
        mov ebx, 0FFh
        xor edx, edx
        div ebx
        mov edx, eax
        cmp eax, byte 5
        jae short loc_AC589
        mov edx, 5
loc_AC589:
        mov byte [byte ecx+01Eh], 0
        xor eax, eax
        mov byte [byte ecx+020h], 0
        mov ax, word [GusDataHighPort]
        mov byte [byte ecx+01Fh], dl
        call outp_
        or byte [byte ecx+015h], 20h
        cmp byte [byte esi+047h], 0
        jne short loc_AC5B4
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+09h], 0
        je short loc_AC5DE
loc_AC5B4:
        mov eax, dword [byte ebp-028h]
        mov edx, 1
        mov ebx, dword [byte ebp+08h]
        call GusVoiceSetVibrato
        mov ax, word [word_F611A]
        mov edx, eax
        inc edx
        mov word [word_F611A], dx
        test ax, ax
        jne short loc_AC5DE
        call GusStartVibratoTimer
loc_AC5DE:
        cmp byte [byte esi+044h], 0
        jne short loc_AC5ED
        mov eax, dword [byte ebp-010h]
        cmp byte [byte eax+0Ch], 0
        je short loc_AC5F8
loc_AC5ED:
        mov eax, dword [byte ebp-028h]
        mov edx, dword [byte ebp+08h]
        call GusVoiceSetEnvelope
loc_AC5F8:
        mov edx, 0Dh
        xor eax, eax
        mov byte [byte ecx+013h], 1
        mov ax, word [GusRegSelectPort]
        mov byte [byte ecx+016h], 0
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+015h]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
loc_AC673:
        inc dword [byte ebp-018h]
        mov eax, dword [byte ebp-018h]
        cmp eax, dword [byte ebp-020h]
        jl near loc_AC13E
        xor edx, edx
        jmp short loc_AC6D0
loc_AC686:
        cmp dword [byte ebp+edx*4-040h], byte 0FFFFFFFFh
        je short loc_AC6CF
        xor ebx, ebx
        jmp short loc_AC6AA
loc_AC691:
        lea esi, [nosplit ebx*2+00h]
        mov eax, dword [byte ebp+edx*4-040h]
        mov cx, word [byte ebp+ebx*4-040h]
        inc ebx
        mov word [dword esi+eax*8+word_F6018], cx
loc_AC6AA:
        cmp ebx, dword [byte ebp-020h]
        jl short loc_AC691
        jmp short loc_AC6CA
loc_AC6B1:
        lea eax, [nosplit ebx*2+00h]
        mov ecx, dword [byte ebp+edx*4-040h]
        mov esi, 0FFFFFFFFh
        inc ebx
        mov word [dword eax+ecx*8+word_F6018], si
loc_AC6CA:
        cmp ebx, byte 4
        jl short loc_AC6B1
loc_AC6CF:
        inc edx
loc_AC6D0:
        cmp edx, dword [byte ebp-020h]
        jl short loc_AC686
        call GusLeaveCritical
        popfw
loc_AC6DC:
        lea esp, [byte ebp-08h]
        pop edi
        pop esi
        pop ebp
        ret 4
        db 08Dh,040h,00h
GusMidiNoteOff:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        push edi
        sub esp, byte 0Ch
        mov dword [byte ebp-01Ch], eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, edx
        shl eax, 4
        test byte [dword eax+byte_F59F8], 1
        je short loc_AC739
        xor ecx, ecx
loc_AC70D:
        lea ebx, [nosplit ecx*4+00h]
        mov ah, byte [byte ebp-01Ch]
        cmp ah, byte [dword ebx+byte_F5979]
        jne short loc_AC72E
        cmp dl, byte [dword ebx+byte_F597A]
        jne short loc_AC72E
        or byte [dword ebx+byte_F5978], 1
loc_AC72E:
        inc ecx
        cmp ecx, byte 20h
        jl short loc_AC70D
        jmp near loc_ACC2A
loc_AC739:
        xor esi, esi
loc_AC73B:
        lea eax, [nosplit esi*4+00h]
        mov bh, byte [byte ebp-01Ch]
        cmp bh, byte [dword eax+byte_F5979]
        jne short loc_AC755
        cmp dl, byte [dword eax+byte_F597A]
        je short loc_AC75B
loc_AC755:
        inc esi
        cmp esi, byte 20h
        jl short loc_AC73B
loc_AC75B:
        cmp esi, byte 20h
        je near loc_ACC2A
        xor edi, edi
loc_AC766:
        lea eax, [nosplit edi*2+00h]
        mov ecx, dword [dword eax+esi*8+dword_F6016]
        sar ecx, 10h
        cmp ecx, byte 0FFFFFFFFh
        je near loc_ACC20
        mov ebx, ecx
        shl ebx, 5
        mov edx, 20h
        add ebx, ecx
        mov eax, ecx
        add ebx, unk_F5BF8
        call GusAddVoicePriority
        mov al, byte [byte ebx+013h]
        test al, 1
        je near loc_ACC20
        test al, 4
        jne near loc_ACC20
        mov dl, byte [nosplit ecx*4+byte_F5978]
        xor dh, dh
        and dl, 0FEh
        mov byte [nosplit ecx*4+byte_F5979], dh
        mov byte [nosplit ecx*4+byte_F5978], dl
        mov al, byte [byte ebx+013h]
        and al, 0F9h
        mov ah, al
        mov byte [byte ebx+013h], al
        or ah, 4
        mov byte [byte ebx+013h], ah
        mov eax, dword [ebx]
        test byte [byte eax+048h], 40h
        jne near loc_AC8EB
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        mov dh, byte [byte ebx+014h]
        and dh, 0D7h
        mov al, dh
        mov byte [byte ebx+014h], dh
        or al, 20h
        mov byte [byte ebx+014h], al
        mov eax, dword [ebx]
        test byte [byte eax+048h], 10h
        je short loc_AC853
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+01Eh]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+020h]
        jmp short loc_AC89B
loc_AC853:
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+02Ah]
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov ax, word [byte eax+02Ch]
loc_AC89B:
        and eax, 0FFFFh
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov edx, dword [byte ebp-018h]
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
loc_AC8EB:
        mov eax, dword [ebx]
        mov dh, byte [byte eax+048h]
        test dh, 40h
        je short loc_AC8FE
        test dh, 80h
        je near loc_AC9F2
loc_AC8FE:
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        mov dh, byte [byte ebx+015h]
        mov byte [byte ebx+01Bh], 5
        xor eax, eax
        or dh, 60h
        mov ax, word [GusRegSelectPort]
        mov cl, dh
        mov byte [byte ebx+015h], dh
        and cl, 0E7h
        mov edx, 89h
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        sar eax, 8
        mov ch, byte [byte ebx+01Eh]
        mov word [byte ebp-014h], ax
        test ch, ch
        jne short loc_AC9A0
        xor eax, eax
        mov ax, word [byte ebx+011h]
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov ax, word [byte ebp-014h]
        mov ecx, eax
        shl ecx, 8
        sub ecx, eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-018h]
        mov byte [byte ebx+01Eh], al
loc_AC9A0:
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+01Fh], 5
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+03Bh]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 5
        jmp near loc_ACBDA
loc_AC9F2:
        test dh, 20h
        je near loc_ACC20
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        cmp byte [byte ebx+01Bh], 3
        jae short loc_ACA4F
        mov byte [byte ebx+01Bh], 3
loc_ACA4F:
        mov cl, byte [byte ebx+015h]
        mov edx, 6
        or cl, 20h
        xor eax, eax
        mov ch, cl
        mov byte [byte ebx+015h], cl
        and ch, 0E7h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], ch
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+039h]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        mov word [byte ebp-014h], ax
        shr ax, 8
        mov word [byte ebp-014h], ax
        cmp byte [byte ebx+01Eh], 0
        jne short loc_ACADB
        xor eax, eax
        mov ax, word [byte ebx+011h]
        mov dword [byte ebp-018h], eax
        xor eax, eax
        mov ax, word [byte ebp-014h]
        mov ecx, eax
        shl ecx, 8
        sub ecx, eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-018h]
        mov byte [byte ebx+01Eh], al
loc_ACADB:
        mov al, byte [byte ebp-014h]
        mov byte [byte ebx+020h], al
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Fh]
        cmp al, byte [byte ebp-014h]
        jbe near loc_ACB68
        mov dl, byte [byte ebx+015h]
        xor eax, eax
        and dl, 0BFh
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dl
        mov edx, 7
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ebp-014h]
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Fh]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        cmp eax, byte 5
        jae short loc_ACB57
        mov ecx, 5
loc_ACB57:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, cl
        mov byte [byte ebx+01Fh], cl
        jmp short loc_ACBE0
loc_ACB68:
        mov dh, byte [byte ebx+015h]
        xor eax, eax
        or dh, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dh
        mov edx, 7
        call outp_
        mov edx, dword [ebx]
        mov dl, byte [byte edx+03Fh]
        xor eax, eax
        and edx, 0FFh
        mov ax, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov ecx, eax
        cmp eax, byte 5
        jae short loc_ACBAC
        mov ecx, 5
loc_ACBAC:
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, cl
        mov byte [byte ebx+01Fh], cl
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor edx, edx
        xor eax, eax
        mov dx, word [byte ebp-014h]
loc_ACBDA:
        mov ax, word [GusDataHighPort]
loc_ACBE0:
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
loc_ACC20:
        inc edi
        cmp edi, byte 4
        jl near loc_AC766
loc_ACC2A:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetSustain:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov eax, ecx
        shl eax, 4
        test edx, edx
        je short loc_ACC5D
        or byte [dword eax+byte_F59F8], 1
        jmp short loc_ACCB2
loc_ACC5D:
        mov dh, byte [dword eax+byte_F59F8]
        and dh, 0FEh
        xor ebx, ebx
        mov byte [dword eax+byte_F59F8], dh
        jmp short loc_ACCA6
loc_ACC70:
        lea eax, [nosplit ebx*4+00h]
        cmp cl, byte [dword eax+byte_F597A]
        jne short loc_ACCA5
        test byte [dword eax+byte_F5978], 1
        je short loc_ACCA5
        cmp byte [dword eax+byte_F5979], 0
        je short loc_ACCA5
        xor edx, edx
        mov al, byte [dword eax+byte_F5979]
        mov dl, cl
        and eax, 0FFh
        call GusMidiNoteOff
loc_ACCA5:
        inc ebx
loc_ACCA6:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short loc_ACC70
loc_ACCB2:
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
GusVoiceWaveEnd:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov ecx, eax
        shl ecx, 5
        add ecx, eax
        add ecx, unk_F5BF8
        test byte [byte ecx+013h], 1
        je short loc_ACD4C
        mov dl, byte [byte ecx+014h]
        xor eax, eax
        and dl, 5Fh
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ecx+014h], dl
        mov edx, ebx
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ecx+014h]
        call outp_
        test byte [byte ecx+013h], 8
        je short loc_ACD45
        cmp byte [byte ecx+01Bh], 0
        je short loc_ACD45
        mov eax, ebx
        call GusVoiceStopRamp
        mov eax, ebx
        call GusVoiceStopWave
loc_ACD45:
        mov eax, 1
        jmp short loc_ACD4E
loc_ACD4C:
        xor eax, eax
loc_ACD4E:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusVoiceRampEnd:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 0Ch
        mov edx, eax
        mov ebx, eax
        shl ebx, 5
        add ebx, eax
        add ebx, unk_F5BF8
        test byte [byte ebx+013h], 1
        je near loc_AD153
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        and cl, 5Fh
        mov ax, word [GusVoiceSelectPort]
        mov byte [byte ebx+015h], cl
        call outp_
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        call GusDelay
        xor eax, eax
        mov edx, 3
        mov ax, word [GusDataHighPort]
        call outp_
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        sar eax, 8
        mov ch, byte [byte ebx+016h]
        mov byte [byte ebp-018h], al
        test ch, ch
        je short loc_ACE0F
        mov al, ch
        dec al
        mov byte [byte ebx+01Bh], al
        mov al, 1
        mov byte [byte ebx+016h], 0
        mov byte [byte ebp-014h], al
        jmp short loc_ACE1A
loc_ACE0F:
        mov dl, byte [byte ebx+01Bh]
        inc dl
        mov byte [byte ebp-014h], ch
        mov byte [byte ebx+01Bh], dl
loc_ACE1A:
        xor ecx, ecx
        mov cl, byte [byte ebx+01Bh]
        cmp ecx, byte 6
        jl near loc_ACF30
        cmp byte [byte ebp-014h], 0
        jne short loc_ACE34
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
loc_ACE34:
        mov cl, byte [byte ebx+013h]
        mov al, byte [byte ebx+014h]
        and cl, 0F1h
        and al, 0D7h
        mov byte [byte ebx+013h], cl
        mov ah, al
        mov byte [byte ebx+014h], al
        or ah, 20h
        mov ch, cl
        mov byte [byte ebx+014h], ah
        or ch, 0Ch
        mov eax, dword [ebx]
        mov byte [byte ebx+013h], ch
        test byte [byte eax+048h], 10h
        je short loc_ACEA2
        xor eax, eax
        mov edx, 3
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+01Eh]
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 2
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+020h]
        jmp short loc_ACEE5
loc_ACEA2:
        xor eax, eax
        mov edx, 5
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+02Ah]
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        mov edx, 4
        mov ax, word [GusRegSelectPort]
        call outp_
        mov edx, dword [ebx]
        mov dx, word [byte edx+02Ch]
loc_ACEE5:
        xor eax, eax
        and edx, 0FFFFh
        mov ax, word [GusDataLowPort]
        call outpw_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+014h]
        jmp near loc_AD105
loc_ACF30:
        cmp ecx, byte 3
        jne near loc_AD03E
        mov eax, dword [ebx]
        test byte [byte eax+048h], 20h
        je near loc_AD03E
        mov al, byte [byte ebx+013h]
        test al, 4
        jne near loc_AD03E
        mov ah, al
        or ah, 2
        mov dl, byte [byte ebp-014h]
        mov byte [byte ebx+013h], ah
        test dl, dl
        jne short loc_ACF65
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
loc_ACF65:
        mov eax, dword [ebx]
        mov al, byte [byte eax+03Eh]
        mov byte [byte ebx+01Eh], al
        mov eax, dword [ebx]
        cmp byte [byte eax+044h], 0
        jne short loc_ACF8A
        xor eax, eax
        mov al, byte [byte ebx+01Dh]
        shl eax, 4
        cmp byte [dword eax+byte_F5A04], 0
        je near loc_AD10A
loc_ACF8A:
        xor eax, eax
        mov edx, 89h
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov ax, word [GusDataLowPort]
        call inpw_
        and eax, 0FFFFh
        xor edx, edx
        sar eax, 4
        mov dl, byte [byte ebx+0Eh]
        and eax, 0FFFFh
        cmp eax, edx
        jle short loc_ACFC5
        or byte [byte ebx+015h], 40h
        jmp short loc_ACFC9
loc_ACFC5:
        and byte [byte ebx+015h], 0BFh
loc_ACFC9:
        xor eax, eax
        mov edx, 6
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+010h]
        call outp_
        xor eax, eax
        mov edx, 7
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+0Eh]
        call outp_
        xor eax, eax
        mov edx, 8
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+0Fh]
        call outp_
        or byte [byte ebx+015h], 18h
        jmp near loc_AD10A
loc_AD03E:
        mov dl, byte [byte ebx+015h]
        xor eax, eax
        or dl, 20h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], dl
        mov edx, 6
        call outp_
        mov eax, dword [ebx]
        xor edx, edx
        mov dl, byte [byte ecx+eax+036h]
        xor eax, eax
        mov ax, word [GusDataHighPort]
        call outp_
        cmp byte [byte ebp-014h], 0
        je short loc_AD07F
        mov al, byte [byte ebx+01Fh]
        xor ah, ah
        mov word [byte ebp-01Ch], ax
        jmp short loc_AD0B8
loc_AD07F:
        mov al, byte [byte ebx+01Fh]
        mov byte [byte ebx+020h], al
        mov eax, dword [ebx]
        mov al, byte [byte ecx+eax+03Ch]
        xor edx, edx
        and eax, 0FFh
        mov dx, word [byte ebx+011h]
        imul eax, edx
        mov ecx, 0FFh
        xor edx, edx
        div ecx
        mov word [byte ebp-01Ch], ax
        cmp ax, 5
        jae short loc_AD0B2
        mov word [byte ebp-01Ch], 5
loc_AD0B2:
        mov al, byte [byte ebp-01Ch]
        mov byte [byte ebx+01Fh], al
loc_AD0B8:
        mov al, byte [byte ebp-018h]
        mov esi, dword [byte ebp-01Ch]
        xor ah, ah
        cmp ax, si
        jb short loc_AD0DD
        mov edx, 7
        mov cl, byte [byte ebx+015h]
        xor eax, eax
        or cl, 40h
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], cl
        jmp short loc_AD0F3
loc_AD0DD:
        mov edx, 8
        mov ch, byte [byte ebx+015h]
        xor eax, eax
        and ch, 0BFh
        mov ax, word [GusRegSelectPort]
        mov byte [byte ebx+015h], ch
loc_AD0F3:
        call outp_
        xor edx, edx
        xor eax, eax
        mov dl, byte [byte ebp-01Ch]
        mov ax, word [GusDataHighPort]
loc_AD105:
        call outp_
loc_AD10A:
        xor eax, eax
        mov edx, 0Dh
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        call GusDelay
        xor eax, eax
        xor edx, edx
        mov ax, word [GusDataHighPort]
        mov dl, byte [byte ebx+015h]
        call outp_
        mov eax, 1
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AD153:
        xor eax, eax
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusStopPatchVoices:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 14h
        mov edx, eax
        pushfw
        cli
        mov ebx, unk_F5BF8
        call GusEnterCritical
        mov dword [byte ebp-01Ch], ebx
        xor ebx, ebx
        jmp short loc_AD1D9
loc_AD181:
        mov eax, dword [byte ebp-01Ch]
        test byte [byte eax+013h], 1
        je short loc_AD1CF
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        mov dword [byte ebp-028h], eax
        xor eax, eax
        jmp short loc_AD1BE
loc_AD197:
        mov ecx, dword [byte edx+eax*2+010h]
        mov esi, dword [byte edx+eax*4+02h]
        sar ecx, 10h
loc_AD1A2:
        mov dword [byte ebp-020h], esi
        test ecx, ecx
        je short loc_AD1B9
        mov edi, dword [byte ebp-01Ch]
        mov esi, dword [byte ebp-020h]
        cmp esi, dword [edi]
        je short loc_AD1B9
        add esi, byte 49h
        dec ecx
        jmp short loc_AD1A2
loc_AD1B9:
        test ecx, ecx
        jne short loc_AD1C3
        inc eax
loc_AD1BE:
        cmp eax, dword [byte ebp-028h]
        jl short loc_AD197
loc_AD1C3:
        cmp eax, dword [byte ebp-028h]
        je short loc_AD1CF
        mov eax, ebx
        call GusVoiceStopRamp
loc_AD1CF:
        mov esi, dword [byte ebp-01Ch]
        add esi, byte 21h
        inc ebx
        mov dword [byte ebp-01Ch], esi
loc_AD1D9:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short loc_AD181
        mov ecx, unk_F5BF8
        xor ebx, ebx
        jmp short loc_AD241
loc_AD1EE:
        test byte [byte ecx+013h], 1
        je short loc_AD23D
        mov eax, dword [byte edx-02h]
        sar eax, 10h
        mov dword [byte ebp-024h], eax
        xor eax, eax
        jmp short loc_AD22C
loc_AD201:
        mov esi, dword [byte edx+eax*2+010h]
        sar esi, 10h
        mov dword [byte ebp-018h], esi
        mov esi, dword [byte edx+eax*4+02h]
loc_AD20F:
        cmp dword [byte ebp-018h], byte 0
        je short loc_AD225
        cmp esi, dword [ecx]
        je short loc_AD225
        mov edi, dword [byte ebp-018h]
        dec edi
        add esi, byte 49h
        mov dword [byte ebp-018h], edi
        jmp short loc_AD20F
loc_AD225:
        cmp dword [byte ebp-018h], byte 0
        jne short loc_AD231
        inc eax
loc_AD22C:
        cmp eax, dword [byte ebp-024h]
        jl short loc_AD201
loc_AD231:
        cmp eax, dword [byte ebp-024h]
        je short loc_AD23D
        mov eax, ebx
        call GusVoiceStopWave
loc_AD23D:
        inc ebx
        add ecx, byte 21h
loc_AD241:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ebx, eax
        jb short loc_AD1EE
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusForgetPatch:
        push ebp
        mov ebp, esp
        push ebx
        push edx
        mov ebx, eax
        mov eax, byte_F59F8
        xor edx, edx
        cmp edx, byte 20h
        jl short loc_AD27A
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
loc_AD27A:
        cmp ebx, dword [byte eax+04h]
        jne short loc_AD286
        mov dword [byte eax+04h], 0
loc_AD286:
        inc edx
        add eax, byte 10h
        cmp edx, byte 20h
        jl short loc_AD27A
        lea esp, [byte ebp-08h]
        pop edx
        pop ebx
        pop ebp
        ret
        db 08Bh,0C0h
GusSetChannelPatch:
        push ebp
        mov ebp, esp
        shl edx, 4
        mov dword [dword edx+dword_F59FC], eax
        mov esp, ebp
        pop ebp
        ret
GusSetChannelPan:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        sub esp, byte 4
        mov ebx, eax
        mov dword [byte ebp-010h], edx
        mov eax, edx
        shl eax, 4
        cmp ebx, byte 0FFFFFFFFh
        jne short loc_AD2CC
        mov byte [dword eax+byte_F5A00], 10h
        jmp near loc_AD33B
loc_AD2CC:
        mov esi, unk_F5BF8
        sar ebx, 3
        xor ecx, ecx
        mov byte [dword eax+byte_F5A00], bl
        pushfw
        cli
        call GusEnterCritical
        jmp short loc_AD328
loc_AD2E6:
        test byte [byte esi+013h], 1
        je short loc_AD324
        mov ah, byte [byte ebp-010h]
        cmp ah, byte [byte esi+01Dh]
        jne short loc_AD324
        xor eax, eax
        mov edx, ecx
        mov ax, word [GusVoiceSelectPort]
        call outp_
        xor eax, eax
        mov edx, 0Ch
        mov ax, word [GusRegSelectPort]
        call outp_
        xor eax, eax
        mov edx, ebx
        mov ax, word [GusDataHighPort]
        call outp_
loc_AD324:
        inc ecx
        add esi, byte 21h
loc_AD328:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp ecx, eax
        jb short loc_AD2E6
        call GusLeaveCritical
        popfw
loc_AD33B:
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusChannelNotesOff:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ecx, eax
        pushfw
        cli
        call GusEnterCritical
        mov ebx, unk_F5BF8
        xor edx, edx
        jmp short loc_AD373
loc_AD35D:
        test byte [byte ebx+013h], 1
        je short loc_AD36F
        cmp cl, byte [byte ebx+01Dh]
        jne short loc_AD36F
        mov eax, edx
        call GusVoiceStopRamp
loc_AD36F:
        inc edx
        add ebx, byte 21h
loc_AD373:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edx, eax
        jb short loc_AD35D
        mov ebx, unk_F5BF8
        xor edx, edx
        jmp short loc_AD39E
loc_AD388:
        test byte [byte ebx+013h], 1
        je short loc_AD39A
        cmp cl, byte [byte ebx+01Dh]
        jne short loc_AD39A
        mov eax, edx
        call GusVoiceStopWave
loc_AD39A:
        inc edx
        add ebx, byte 21h
loc_AD39E:
        xor eax, eax
        mov ax, word [GusActiveVoices]
        cmp edx, eax
        jb short loc_AD388
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h
GusPokeBlock:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push esi
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        mov esi, edx
        xor ecx, ecx
        jmp short loc_AD3E5
loc_AD3D6:
        mov eax, ebx
        inc esi
        xor edx, edx
        inc ecx
        mov dl, byte [byte esi-01h]
        inc ebx
        call GusPoke
loc_AD3E5:
        cmp ecx, byte 0Fh
        jb short loc_AD3D6
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-0Ch]
        pop esi
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusPeekBlock:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        mov ebx, eax
        pushfw
        cli
        call GusEnterCritical
        mov ecx, edx
        xor edx, edx
        jmp short loc_AD41E
loc_AD411:
        mov eax, ebx
        call GusPeek
        inc ecx
        inc edx
        inc ebx
        mov byte [byte ecx-01h], al
loc_AD41E:
        cmp edx, byte 0Fh
        jb short loc_AD411
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-08h]
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusSizeDram:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        mov byte [byte_D89E0], 1
        xor edx, edx
        xor ebx, ebx
        mov word [word_F6128], dx
loc_AD450:
        mov edx, ebx
        shl edx, 12h
        mov eax, edx
        call GusTestDramBank
        test al, al
        je short loc_AD4A1
        mov eax, 1
        mov esi, 0FFFFFFFFh
        mov cl, bl
        mov dword [byte ebp-01Ch], esi
        mov dword [byte ebp-018h], esi
        shl eax, cl
        mov cx, word [word_F6128]
        xor esi, esi
        or ecx, eax
        mov word [byte ebp-014h], si
        mov word [word_F6128], cx
        mov ecx, 40000h
        mov eax, edx
        mov dword [byte ebp-020h], ecx
        xor cl, cl
        lea edx, [byte ebp-020h]
        mov byte [byte ebp-012h], cl
        call GusPokeBlock
loc_AD4A1:
        inc ebx
        cmp ebx, byte 4
        jl short loc_AD450
        cmp word [word_F6128], byte 0
        jne short loc_AD4B8
        mov eax, 6
        jmp short loc_AD4D2
loc_AD4B8:
        mov eax, 1Eh
        xor edx, edx
        call GusPoke
        mov eax, 1Fh
        xor edx, edx
        call GusPoke
        xor eax, eax
loc_AD4D2:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusDramAlloc:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        push edi
        sub esp, byte 24h
        mov esi, eax
        lea esi, [byte eax+01Fh]
        pushfw
        cli
        call GusEnterCritical
        xor edx, edx
        and esi, 0FFFFE0h
        mov dword [byte ebp-018h], edx
        add esi, byte 20h
loc_AD502:
        mov cl, byte [byte ebp-018h]
        xor edx, edx
        mov eax, 1
        mov dx, word [word_F6128]
        shl eax, cl
        test edx, eax
        je near loc_AD5EA
        mov ebx, dword [byte ebp-018h]
        shl ebx, 12h
loc_AD523:
        cmp ebx, byte 0FFFFFFFFh
        je near loc_AD5EA
        lea edx, [byte ebp-038h]
        mov eax, ebx
        call GusPeekBlock
        mov ah, byte [byte ebp-02Ah]
        test ah, 1
        jne near loc_AD5E2
        mov ecx, dword [byte ebp-038h]
        cmp esi, ecx
        ja near loc_AD5E2
        mov dl, ah
        or dl, 1
        mov byte [byte ebp-02Ah], dl
        mov edx, ecx
        sub edx, esi
        cmp edx, byte 40h
        jae short loc_AD577
        lea edx, [byte ebp-038h]
        mov eax, ebx
        call GusPokeBlock
        call GusLeaveCritical
        popfw
        lea eax, [byte ebx+020h]
        jmp near loc_AD603
loc_AD577:
        mov eax, dword [byte ebp-034h]
        mov dword [byte ebp-020h], ebx
        mov dword [byte ebp-028h], edx
        xor edx, edx
        mov dword [byte ebp-024h], eax
        mov word [byte ebp-01Ch], dx
        lea eax, [ebx+esi]
        xor dh, dh
        mov dword [byte ebp-034h], eax
        mov byte [byte ebp-01Ah], dh
        mov eax, ebx
        lea edx, [byte ebp-038h]
        mov dword [byte ebp-038h], esi
        call GusPokeBlock
        mov eax, dword [byte ebp-034h]
        lea edx, [byte ebp-028h]
        call GusPokeBlock
        mov esi, dword [byte ebp-024h]
        cmp esi, byte 0FFFFFFFFh
        je short loc_AD5CE
        lea edx, [byte ebp-028h]
        mov eax, esi
        call GusPeekBlock
        mov eax, dword [byte ebp-034h]
        lea edx, [byte ebp-028h]
        mov dword [byte ebp-020h], eax
        mov eax, esi
        call GusPokeBlock
loc_AD5CE:
        call GusLeaveCritical
        popfw
        lea eax, [byte ebx+020h]
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
loc_AD5E2:
        mov ebx, dword [byte ebp-034h]
        jmp near loc_AD523
loc_AD5EA:
        mov edi, dword [byte ebp-018h]
        inc edi
        mov dword [byte ebp-018h], edi
        cmp edi, byte 4
        jl near loc_AD502
        call GusLeaveCritical
        popfw
        xor eax, eax
loc_AD603:
        lea esp, [byte ebp-014h]
        pop edi
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 08Dh,040h,00h
GusDramFree:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push edi
        sub esp, byte 30h
        mov ebx, eax
        lea edx, [byte ebp-020h]
        lea ebx, [byte eax-020h]
        pushfw
        cli
        call GusEnterCritical
        mov eax, ebx
        call GusPeekBlock
        mov edx, dword [byte ebp-018h]
        cmp edx, byte 0FFFFFFFFh
        je short loc_AD68C
        mov eax, edx
        lea edx, [byte ebp-040h]
        call GusPeekBlock
        test byte [byte ebp-032h], 1
        jne short loc_AD68C
        mov eax, dword [byte ebp-020h]
        mov ecx, dword [byte ebp-040h]
        mov ebx, dword [byte ebp-018h]
        add ecx, eax
        mov eax, dword [byte ebp-01Ch]
        mov dword [byte ebp-040h], ecx
        mov dword [byte ebp-03Ch], eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_AD678
        lea edx, [byte ebp-030h]
        call GusPeekBlock
        mov eax, dword [byte ebp-03Ch]
        lea edx, [byte ebp-030h]
        mov dword [byte ebp-028h], ebx
        call GusPokeBlock
loc_AD678:
        lea edx, [byte ebp-040h]
        mov eax, ebx
        call GusPokeBlock
        lea edx, [byte ebp-020h]
        mov eax, ebx
        call GusPeekBlock
loc_AD68C:
        mov edi, dword [byte ebp-01Ch]
        cmp edi, byte 0FFFFFFFFh
        je short loc_AD6D0
        lea edx, [byte ebp-030h]
        mov eax, edi
        call GusPeekBlock
        test byte [byte ebp-022h], 1
        jne short loc_AD6D0
        mov eax, dword [byte ebp-030h]
        mov edx, dword [byte ebp-020h]
        add edx, eax
        mov eax, dword [byte ebp-02Ch]
        mov dword [byte ebp-020h], edx
        mov dword [byte ebp-01Ch], eax
        cmp eax, byte 0FFFFFFFFh
        je short loc_AD6D0
        lea edx, [byte ebp-030h]
        call GusPeekBlock
        mov eax, dword [byte ebp-01Ch]
        lea edx, [byte ebp-030h]
        mov dword [byte ebp-028h], ebx
        call GusPokeBlock
loc_AD6D0:
        mov dh, byte [byte ebp-012h]
        and dh, 0FEh
        mov eax, ebx
        mov byte [byte ebp-012h], dh
        lea edx, [byte ebp-020h]
        call GusPokeBlock
        call GusLeaveCritical
        popfw
        lea esp, [byte ebp-010h]
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 090h
GusDramFreeTotal:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        pushfw
        cli
        call GusEnterCritical
        xor esi, esi
        xor ebx, ebx
loc_AD70A:
        mov eax, 1
        xor edx, edx
        mov cl, bl
        mov dx, word [word_F6128]
        shl eax, cl
        test edx, eax
        je short loc_AD740
        mov eax, ebx
        shl eax, 12h
loc_AD725:
        cmp eax, byte 0FFFFFFFFh
        je short loc_AD740
        lea edx, [byte ebp-020h]
        call GusPeekBlock
        test byte [byte ebp-012h], 1
        jne short loc_AD73B
        add esi, dword [byte ebp-020h]
loc_AD73B:
        mov eax, dword [byte ebp-01Ch]
        jmp short loc_AD725
loc_AD740:
        inc ebx
        cmp ebx, byte 4
        jl short loc_AD70A
        call GusLeaveCritical
        popfw
        mov eax, esi
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusDramLargestFree:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        push esi
        sub esp, byte 10h
        pushfw
        cli
        call GusEnterCritical
        xor esi, esi
        xor ebx, ebx
loc_AD76E:
        mov eax, 1
        xor edx, edx
        mov cl, bl
        mov dx, word [word_F6128]
        shl eax, cl
        test edx, eax
        je short loc_AD7AA
        mov eax, ebx
        shl eax, 12h
loc_AD789:
        cmp eax, byte 0FFFFFFFFh
        je short loc_AD7AA
        lea edx, [byte ebp-020h]
        call GusPeekBlock
        test byte [byte ebp-012h], 1
        jne short loc_AD7A5
        mov edx, dword [byte ebp-020h]
        cmp esi, edx
        jae short loc_AD7A5
        mov esi, edx
loc_AD7A5:
        mov eax, dword [byte ebp-01Ch]
        jmp short loc_AD789
loc_AD7AA:
        inc ebx
        cmp ebx, byte 4
        jl short loc_AD76E
        call GusLeaveCritical
        popfw
        cmp esi, byte 20h
        jbe short loc_AD7C1
        lea eax, [byte esi-020h]
        jmp short loc_AD7C3
loc_AD7C1:
        xor eax, eax
loc_AD7C3:
        lea esp, [byte ebp-010h]
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
GusMixAdd8:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF8h
        push ebx
        mov dword [byte ebp-04h], eax
        mov dword [byte ebp-08h], edx
        mov edx, dword [byte ebp+08h]
        cmp eax, byte 40h
        jb near loc_ADC73
loc_AD7E5:
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        sub dword [byte ebp-04h], byte 40h
        cmp dword [byte ebp-04h], byte 40h
        jae near loc_AD7E5
loc_ADC73:
        cmp dword [byte ebp-04h], byte 0
        je short loc_ADC90
        movzx eax, byte [esi]
        mov ax, word [ebx+eax*2]
        add word [edx], ax
        add ecx, dword [byte ebp-08h]
        LD adc, esi, edi
        add edx, byte 2
        dec dword [byte ebp-04h]
        jmp short loc_ADC73
loc_ADC90:
        mov edx, dword [byte ebp-08h]
        pop ebx
        leave
        ret
GusClearMixBuffer:
        cmp ecx, 100h
        jb near loc_ADEC0
        LD xor, eax, eax
        LD mov, edi, ebx
        mov edx, 8
        add ebx, byte 4
loc_ADCAE:
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        mov dword [edi], eax
        mov dword [ebx], eax
        LD add, edi, edx
        LD add, ebx, edx
        sub ecx, 100h
        cmp ecx, 100h
        jae near loc_ADCAE
loc_ADEC0:
        LD or, ecx, ecx
        je short loc_ADEE5
        cld
        test ecx, 3
        je short loc_ADEE0
        test ecx, 1
        je short loc_ADEDE
        stosb
        test ecx, 2
        je short loc_ADEE0
loc_ADEDE:
        stosw
loc_ADEE0:
        shr ecx, 2
        rep stosd
loc_ADEE5:
        LD mov, ebx, edi
        ret
