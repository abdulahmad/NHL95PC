; The Gravis Ultrasound SDK.
bits 32
%include "hockey.inc"
section s_ADEE9 progbits alloc exec nowrite align=1
extern byte_D7B18, byte_D7B58, byte_D7B5C, byte_D7D70, byte_D7DB0, byte_D7DB4, byte_D7FC8, byte_D8008
extern byte_D800C, byte_D8220, byte_D8260, byte_D8264, byte_D849C, byte_D84A0, dword_D6B00, dword_D7ABC
extern dword_D7AF0, dword_D7AF4, dword_D7AF8, GusStreamBusyLeft, dword_D7B00, dword_D7B04, GusStreamBusyRight, dword_D7B0C
extern dword_D7B1C, dword_D7B30, dword_D7B34, dword_D7B38, dword_D7B44, dword_D7B48, dword_D7B4C, dword_D7B50
extern dword_D7B60, dword_D7D64, dword_D7D74, dword_D7D88, dword_D7D8C, dword_D7D90, dword_D7D9C, dword_D7DA0
extern dword_D7DA4, dword_D7DA8, dword_D7DB8, dword_D7FBC, dword_D7FCC, dword_D7FE0, dword_D7FE4, dword_D7FE8
extern dword_D7FF4, dword_D7FF8, dword_D7FFC, dword_D8000, dword_D8010, dword_D8214, dword_D8224, dword_D8238
extern dword_D823C, dword_D8240, dword_D824C, dword_D8250, dword_D8254, dword_D8258, dword_D8268, dword_D847C
extern dword_D8480, dword_D8484, dword_D8488, dword_D848C, dword_D8490, dword_D8494, dword_D8498, dword_D84A8
extern dword_D84AC, dword_D84B0, dword_D84B4, dword_D84B8, dword_D84C0, dword_D84C4, dword_D84CC, dword_D84D0
extern dword_D8510, dword_D8550, dword_D8590, dword_D85D0, dword_D8610, dword_F612C, getenv_, inp_
extern nullsub_4, off_D846C, outp_, strtoul_, sub_AB658, sub_AB6D0, sub_AB80C, sub_ACC3C
extern sub_AD2A8, sub_AD344, sub_AD7CC, sub_ADC96, GusDownload, sub_B14E4, sub_B1CBC, sub_B1F1C
extern word_D7414, word_D7B64, word_D7DBC, word_D8014, word_D826C, word_D84BC, word_D84BE, word_D84C2
extern word_D84C6, GusVoiceSelectPort, GusRegSelectPort, GusDataLowPort, GusDataHighPort, GusDramPort
global sub_ADEE9, loc_ADF15, loc_ADF2A, loc_ADF49, loc_ADF5E, loc_ADFE7, loc_ADFFB, loc_AE002
global loc_AE02F, loc_AE061, loc_AE096, loc_AE0A5, loc_AE0C1, loc_AE0D6, loc_AE0E2, loc_AE11D
global loc_AE14C, loc_AE162, loc_AE1A1, loc_AE1AD, loc_AE1B7, loc_AE22F, loc_AE243, loc_AE24A
global loc_AE277, loc_AE2A9, loc_AE2DE, loc_AE2ED, loc_AE309, loc_AE31E, loc_AE32A, loc_AE365
global loc_AE394, loc_AE3AA, loc_AE3E9, loc_AE3F5, loc_AE3FF, loc_AE477, loc_AE48B, loc_AE492
global loc_AE4BF, loc_AE4F1, loc_AE526, loc_AE535, loc_AE551, loc_AE566, loc_AE572, loc_AE5AD
global loc_AE5DC, loc_AE5F2, loc_AE631, loc_AE63D, loc_AE647, loc_AE6BF, loc_AE6D3, loc_AE6DA
global loc_AE707, loc_AE739, loc_AE76E, loc_AE77D, loc_AE799, loc_AE7AE, loc_AE7BA, loc_AE7F5
global loc_AE824, loc_AE83A, loc_AE879, loc_AE885, loc_AE88F, loc_AE8DD, loc_AE8E3, loc_AE8FE
global sub_AE903, loc_AE96B, loc_AE9E2, loc_AE9E8, GusServiceStream, loc_AEA05, loc_AEA22, GusStartStream
global loc_AEA32, loc_AEA68, loc_AEB45, sub_AEDBC, loc_AEE52, sub_AEE54, loc_AEE86, loc_AEEDD
global loc_AEEF5, loc_AEF08, sub_AEF0E, loc_AEF26, loc_AEF2E, sub_AEF33, loc_AEF77, loc_AEF89
global loc_AEF9F, sub_AEFA2, loc_AEFC6, sub_AEFC9, loc_AEFE7, sub_AEFEA, loc_AF039, loc_AF054
global sub_AF058, loc_AF073, sub_AF076, loc_AF0C8, loc_AF0CF, loc_AF0D2, sub_AF0D5, loc_AF10F
global sub_AF112, loc_AF16A, loc_AF178, loc_AF186, loc_AF194, GusStreamBusy, sub_AF1A4, loc_AF1BE
global GusGetEnvConfig, loc_AF214, loc_AF23B, loc_AF262, loc_AF289, loc_AF2C8, loc_AF2CA, GusProbePort
global loc_AF335, loc_AF337, sub_AF340, loc_AF37E, loc_AF412, loc_AF417, sub_AF428, loc_AF47E
global loc_AF48C, loc_AF4A8, loc_AF4B9, loc_AF4E0, loc_AF4F1, loc_AF509, loc_AF523, loc_AF549
global loc_AF558, loc_AF583, loc_AF5AB, loc_AF5D3, loc_AF601, loc_AF610, loc_AF63E, loc_AF657
global loc_AF665, loc_AF673, loc_AF6C4, loc_AF6CB
sub_ADEE9:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFF0h
        push esi
        push edi
        push ebx
        LD or, eax, eax
        jne short loc_ADF2A
        mov eax, dword [dword_D7AF4]
        mov dword [dword_D8494], eax
        cmp dword [dword_D8498], byte 0
        je short loc_ADF15
        mov dword [dword_D7AF8], 2
        jmp short loc_ADF5E
loc_ADF15:
        cmp dword [dword_D7AF8], byte 0
        je near loc_AE8FE
        dec dword [dword_D7AF8]
        jmp short loc_ADF5E
loc_ADF2A:
        mov eax, dword [dword_D7B00]
        mov dword [dword_D8494], eax
        cmp dword [dword_D8498], byte 0
        je short loc_ADF49
        mov dword [dword_D7B04], 2
        jmp short loc_ADF5E
loc_ADF49:
        cmp dword [dword_D7B04], byte 0
        je near loc_AE8FE
        dec dword [dword_D7AF8]
        jmp short loc_ADF5E
loc_ADF5E:
        mov ebx, dword [dword_D8494]
        mov ecx, dword [dword_D8484]
        call sub_ADC96
        cmp byte [dword_D7B0C], 0
        je near loc_AE1B7
        cmp byte [byte_D7B18], 0
        jne near loc_AE0A5
        mov edx, dword [dword_D7B4C]
        mov eax, dword [dword_D7B50]
        mov ecx, dword [dword_D8490]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [dword_D7B48]
        adc edx, dword [dword_D7B44]
        cmp edx, dword [dword_D7B34]
        jae short loc_ADFFB
        mov eax, dword [dword_D7B44]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [dword_D7B48]
        mov edi, dword [dword_D7B4C]
        mov edx, dword [dword_D7B50]
        mov ebx, word_D7B64
        mov eax, dword [dword_D8484]
        push dword [dword_D8494]
        call sub_AD7CC
        add esp, byte 4
loc_ADFE7:
        mov dword [dword_D7B48], ecx
        sub esi, dword [byte ebp-010h]
        add dword [dword_D7B44], esi
        jmp near loc_AE1B7
loc_ADFFB:
        mov dword [byte ebp-04h], 0
loc_AE002:
        mov eax, dword [dword_D7B44]
        mov ebx, dword [dword_D7B34]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [dword_D7B48]
        mov edi, dword [dword_D7B4C]
        mov edx, dword [dword_D7B50]
loc_AE02F:
        movzx eax, byte [esi]
        mov ebx, word_D7B64
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [dword_D8494]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short loc_AE061
        mov eax, dword [dword_D8484]
        cmp eax, dword [byte ebp-04h]
        jne short loc_AE02F
        jmp short loc_ADFE7
loc_AE061:
        cmp dword [dword_D7B0C], byte 1
        jne short loc_AE096
        cmp dword [dword_D7B1C], byte 0
        je short loc_AE096
        mov eax, dword [dword_D7B30]
        mov dword [dword_D7B48], ecx
        mov dword [dword_D7B44], eax
        mov eax, dword [dword_D8484]
        cmp dword [byte ebp-04h], eax
        jne near loc_AE002
        jmp near loc_AE1B7
loc_AE096:
        mov dword [dword_D7B0C], 0
        jmp near loc_AE1B7
loc_AE0A5:
        mov esi, dword [dword_D7B44]
        mov ecx, dword [dword_D7B34]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D7B60]
        jbe short loc_AE0C1
        mov ecx, dword [dword_D7B60]
loc_AE0C1:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D7B58]
        mov edi, dword [dword_D8494]
loc_AE0D6:
        mov eax, dword [dword_D7B38]
        cmp eax, 10000h
        je short loc_AE11D
loc_AE0E2:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D7B64]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D7B64]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE0E2
        jmp short loc_AE14C
loc_AE11D:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D7B64]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D7B64]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE11D
loc_AE14C:
        cmp esi, dword [dword_D7B34]
        je short loc_AE162
        mov byte [byte_D7B58], dl
        mov dword [dword_D7B44], esi
        jmp short loc_AE1B7
loc_AE162:
        cmp dword [dword_D7B0C], byte 1
        jne short loc_AE1AD
        cmp dword [dword_D7B1C], byte 0
        je short loc_AE1AD
        mov dl, byte [byte_D7B5C]
        mov byte [byte_D7B58], dl
        mov eax, dword [dword_D7B44]
        add eax, dword [dword_D7B60]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_AE1A1
        mov esi, dword [dword_D7B30]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near loc_AE0D6
loc_AE1A1:
        mov eax, dword [dword_D7B30]
        mov dword [dword_D7B44], eax
        jmp short loc_AE1B7
loc_AE1AD:
        mov dword [dword_D7B0C], 0
loc_AE1B7:
        cmp byte [dword_D7D64], 0
        je near loc_AE3FF
        cmp byte [byte_D7D70], 0
        jne near loc_AE2ED
        mov edx, dword [dword_D7DA4]
        mov eax, dword [dword_D7DA8]
        mov ecx, dword [dword_D8490]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [dword_D7DA0]
        adc edx, dword [dword_D7D9C]
        cmp edx, dword [dword_D7D8C]
        jae short loc_AE243
        mov eax, dword [dword_D7D9C]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [dword_D7DA0]
        mov edi, dword [dword_D7DA4]
        mov edx, dword [dword_D7DA8]
        mov ebx, word_D7DBC
        mov eax, dword [dword_D8484]
        push dword [dword_D8494]
        call sub_AD7CC
        add esp, byte 4
loc_AE22F:
        mov dword [dword_D7DA0], ecx
        sub esi, dword [byte ebp-010h]
        add dword [dword_D7D9C], esi
        jmp near loc_AE3FF
loc_AE243:
        mov dword [byte ebp-04h], 0
loc_AE24A:
        mov eax, dword [dword_D7D9C]
        mov ebx, dword [dword_D7D8C]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [dword_D7DA0]
        mov edi, dword [dword_D7DA4]
        mov edx, dword [dword_D7DA8]
loc_AE277:
        movzx eax, byte [esi]
        mov ebx, word_D7DBC
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [dword_D8494]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short loc_AE2A9
        mov eax, dword [dword_D8484]
        cmp eax, dword [byte ebp-04h]
        jne short loc_AE277
        jmp short loc_AE22F
loc_AE2A9:
        cmp dword [dword_D7D64], byte 1
        jne short loc_AE2DE
        cmp dword [dword_D7D74], byte 0
        je short loc_AE2DE
        mov eax, dword [dword_D7D88]
        mov dword [dword_D7DA0], ecx
        mov dword [dword_D7D9C], eax
        mov eax, dword [dword_D8484]
        cmp dword [byte ebp-04h], eax
        jne near loc_AE24A
        jmp near loc_AE3FF
loc_AE2DE:
        mov dword [dword_D7D64], 0
        jmp near loc_AE3FF
loc_AE2ED:
        mov esi, dword [dword_D7D9C]
        mov ecx, dword [dword_D7D8C]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D7DB8]
        jbe short loc_AE309
        mov ecx, dword [dword_D7DB8]
loc_AE309:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D7DB0]
        mov edi, dword [dword_D8494]
loc_AE31E:
        mov eax, dword [dword_D7D90]
        cmp eax, 10000h
        je short loc_AE365
loc_AE32A:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D7DBC]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D7DBC]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE32A
        jmp short loc_AE394
loc_AE365:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D7DBC]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D7DBC]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE365
loc_AE394:
        cmp esi, dword [dword_D7D8C]
        je short loc_AE3AA
        mov byte [byte_D7DB0], dl
        mov dword [dword_D7D9C], esi
        jmp short loc_AE3FF
loc_AE3AA:
        cmp dword [dword_D7D64], byte 1
        jne short loc_AE3F5
        cmp dword [dword_D7D74], byte 0
        je short loc_AE3F5
        mov dl, byte [byte_D7DB4]
        mov byte [byte_D7DB0], dl
        mov eax, dword [dword_D7D9C]
        add eax, dword [dword_D7DB8]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_AE3E9
        mov esi, dword [dword_D7D88]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near loc_AE31E
loc_AE3E9:
        mov eax, dword [dword_D7D88]
        mov dword [dword_D7D9C], eax
        jmp short loc_AE3FF
loc_AE3F5:
        mov dword [dword_D7D64], 0
loc_AE3FF:
        cmp byte [dword_D7FBC], 0
        je near loc_AE647
        cmp byte [byte_D7FC8], 0
        jne near loc_AE535
        mov edx, dword [dword_D7FFC]
        mov eax, dword [dword_D8000]
        mov ecx, dword [dword_D8490]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [dword_D7FF8]
        adc edx, dword [dword_D7FF4]
        cmp edx, dword [dword_D7FE4]
        jae short loc_AE48B
        mov eax, dword [dword_D7FF4]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [dword_D7FF8]
        mov edi, dword [dword_D7FFC]
        mov edx, dword [dword_D8000]
        mov ebx, word_D8014
        mov eax, dword [dword_D8484]
        push dword [dword_D8494]
        call sub_AD7CC
        add esp, byte 4
loc_AE477:
        mov dword [dword_D7FF8], ecx
        sub esi, dword [byte ebp-010h]
        add dword [dword_D7FF4], esi
        jmp near loc_AE647
loc_AE48B:
        mov dword [byte ebp-04h], 0
loc_AE492:
        mov eax, dword [dword_D7FF4]
        mov ebx, dword [dword_D7FE4]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [dword_D7FF8]
        mov edi, dword [dword_D7FFC]
        mov edx, dword [dword_D8000]
loc_AE4BF:
        movzx eax, byte [esi]
        mov ebx, word_D8014
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [dword_D8494]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short loc_AE4F1
        mov eax, dword [dword_D8484]
        cmp eax, dword [byte ebp-04h]
        jne short loc_AE4BF
        jmp short loc_AE477
loc_AE4F1:
        cmp dword [dword_D7FBC], byte 1
        jne short loc_AE526
        cmp dword [dword_D7FCC], byte 0
        je short loc_AE526
        mov eax, dword [dword_D7FE0]
        mov dword [dword_D7FF8], ecx
        mov dword [dword_D7FF4], eax
        mov eax, dword [dword_D8484]
        cmp dword [byte ebp-04h], eax
        jne near loc_AE492
        jmp near loc_AE647
loc_AE526:
        mov dword [dword_D7FBC], 0
        jmp near loc_AE647
loc_AE535:
        mov esi, dword [dword_D7FF4]
        mov ecx, dword [dword_D7FE4]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D8010]
        jbe short loc_AE551
        mov ecx, dword [dword_D8010]
loc_AE551:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D8008]
        mov edi, dword [dword_D8494]
loc_AE566:
        mov eax, dword [dword_D7FE8]
        cmp eax, 10000h
        je short loc_AE5AD
loc_AE572:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D8014]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D8014]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE572
        jmp short loc_AE5DC
loc_AE5AD:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D8014]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D8014]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE5AD
loc_AE5DC:
        cmp esi, dword [dword_D7FE4]
        je short loc_AE5F2
        mov byte [byte_D8008], dl
        mov dword [dword_D7FF4], esi
        jmp short loc_AE647
loc_AE5F2:
        cmp dword [dword_D7FBC], byte 1
        jne short loc_AE63D
        cmp dword [dword_D7FCC], byte 0
        je short loc_AE63D
        mov dl, byte [byte_D800C]
        mov byte [byte_D8008], dl
        mov eax, dword [dword_D7FF4]
        add eax, dword [dword_D8010]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_AE631
        mov esi, dword [dword_D7FE0]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near loc_AE566
loc_AE631:
        mov eax, dword [dword_D7FE0]
        mov dword [dword_D7FF4], eax
        jmp short loc_AE647
loc_AE63D:
        mov dword [dword_D7FBC], 0
loc_AE647:
        cmp byte [dword_D8214], 0
        je near loc_AE88F
        cmp byte [byte_D8220], 0
        jne near loc_AE77D
        mov edx, dword [dword_D8254]
        mov eax, dword [dword_D8258]
        mov ecx, dword [dword_D8490]
        shld edx, eax, cl
        shl eax, cl
        add eax, dword [dword_D8250]
        adc edx, dword [dword_D824C]
        cmp edx, dword [dword_D823C]
        jae short loc_AE6D3
        mov eax, dword [dword_D824C]
        LD mov, esi, eax
        mov dword [byte ebp-010h], esi
        mov ecx, dword [dword_D8250]
        mov edi, dword [dword_D8254]
        mov edx, dword [dword_D8258]
        mov ebx, word_D826C
        mov eax, dword [dword_D8484]
        push dword [dword_D8494]
        call sub_AD7CC
        add esp, byte 4
loc_AE6BF:
        mov dword [dword_D8250], ecx
        sub esi, dword [byte ebp-010h]
        add dword [dword_D824C], esi
        jmp near loc_AE88F
loc_AE6D3:
        mov dword [byte ebp-04h], 0
loc_AE6DA:
        mov eax, dword [dword_D824C]
        mov ebx, dword [dword_D823C]
        LD sub, ebx, eax
        mov dword [byte ebp-08h], ebx
        LD mov, esi, eax
        mov dword [byte ebp-010h], eax
        add eax, dword [byte ebp-08h]
        mov dword [byte ebp-0Ch], eax
        mov ecx, dword [dword_D8250]
        mov edi, dword [dword_D8254]
        mov edx, dword [dword_D8258]
loc_AE707:
        movzx eax, byte [esi]
        mov ebx, word_D826C
        mov ax, word [ebx+eax*2]
        mov ebx, dword [byte ebp-04h]
        shl ebx, 1
        add ebx, dword [dword_D8494]
        add word [ebx], ax
        inc dword [byte ebp-04h]
        LD add, ecx, edx
        LD adc, esi, edi
        cmp esi, dword [byte ebp-0Ch]
        jae short loc_AE739
        mov eax, dword [dword_D8484]
        cmp eax, dword [byte ebp-04h]
        jne short loc_AE707
        jmp short loc_AE6BF
loc_AE739:
        cmp dword [dword_D8214], byte 1
        jne short loc_AE76E
        cmp dword [dword_D8224], byte 0
        je short loc_AE76E
        mov eax, dword [dword_D8238]
        mov dword [dword_D8250], ecx
        mov dword [dword_D824C], eax
        mov eax, dword [dword_D8484]
        cmp dword [byte ebp-04h], eax
        jne near loc_AE6DA
        jmp near loc_AE88F
loc_AE76E:
        mov dword [dword_D8214], 0
        jmp near loc_AE88F
loc_AE77D:
        mov esi, dword [dword_D824C]
        mov ecx, dword [dword_D823C]
        LD sub, ecx, esi
        cmp ecx, dword [dword_D8268]
        jbe short loc_AE799
        mov ecx, dword [dword_D8268]
loc_AE799:
        LD add, ecx, esi
        mov dword [byte ebp-04h], ecx
        LD xor, ecx, ecx
        LD xor, edx, edx
        mov dl, byte [byte_D8260]
        mov edi, dword [dword_D8494]
loc_AE7AE:
        mov eax, dword [dword_D8240]
        cmp eax, 10000h
        je short loc_AE7F5
loc_AE7BA:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D826C]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D826C]
        add word [edi+ecx*2], ax
        inc ecx
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE7BA
        jmp short loc_AE824
loc_AE7F5:
        movzx ebx, byte [esi]
        mov bx, word [nosplit ebx*2+word_D7414]
        LD add, dl, bl
        mov ax, word [nosplit edx*2+word_D826C]
        add word [edi+ecx*2], ax
        inc ecx
        LD add, dl, bh
        mov ax, word [nosplit edx*2+word_D826C]
        add word [edi+ecx*2], ax
        inc ecx
        inc esi
        cmp esi, dword [byte ebp-04h]
        jb short loc_AE7F5
loc_AE824:
        cmp esi, dword [dword_D823C]
        je short loc_AE83A
        mov byte [byte_D8260], dl
        mov dword [dword_D824C], esi
        jmp short loc_AE88F
loc_AE83A:
        cmp dword [dword_D8214], byte 1
        jne short loc_AE885
        cmp dword [dword_D8224], byte 0
        je short loc_AE885
        mov dl, byte [byte_D8264]
        mov byte [byte_D8260], dl
        mov eax, dword [dword_D824C]
        add eax, dword [dword_D8268]
        LD sub, eax, esi
        LD or, eax, eax
        je short loc_AE879
        mov esi, dword [dword_D8238]
        LD add, eax, esi
        mov dword [byte ebp-04h], eax
        jmp near loc_AE7AE
loc_AE879:
        mov eax, dword [dword_D8238]
        mov dword [dword_D824C], eax
        jmp short loc_AE88F
loc_AE885:
        mov dword [dword_D8214], 0
loc_AE88F:
        mov ebx, dword [dword_D8494]
        mov ecx, dword [dword_D8484]
        call nullsub_4
        mov eax, dword [dword_D8494]
        mov dword [dword_D84A8], eax
        mov dword [dword_D84AC], eax
        cmp eax, dword [dword_D7AF4]
        jne short loc_AE8DD
        LD mov, esi, eax
        movzx edx, byte [esi]
        mov eax, dword [dword_D84B8]
        call sub_B1F1C
        movzx edx, byte [byte esi+01h]
        mov eax, dword [dword_D84B8]
        inc eax
        call sub_B1F1C
        mov ebx, dword [dword_D84B0]
        jmp short loc_AE8E3
loc_AE8DD:
        mov ebx, dword [dword_D84B4]
loc_AE8E3:
        mov eax, 1
        push eax
        mov eax, dword_D84A8
        mov edx, dword [dword_D8480]
        mov ecx, 41h
        call GusDownload
loc_AE8FE:
        pop ebx
        pop edi
        pop esi
        leave
        ret
sub_AE903:
        cmp dword [dword_D7AF0], byte 0
        je near loc_AE9E8
        cmp eax, dword [byte_D849C]
        je short loc_AE96B
        cmp eax, dword [byte_D84A0]
        jne near loc_AE9E8
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D84A0]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [GusStreamBusyLeft], 1
        jmp short loc_AE9E2
loc_AE96B:
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D84A0]
        out dx, al
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BC]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BE]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 24h
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [GusStreamBusyRight], 1
loc_AE9E2:
        mov eax, 1
        ret
loc_AE9E8:
        LD xor, eax, eax
        ret
GusServiceStream:
        cmp dword [GusStreamBusyLeft], byte 0
        je short loc_AEA05
        LD xor, eax, eax
        call sub_ADEE9
        mov dword [GusStreamBusyLeft], 0
loc_AEA05:
        cmp dword [GusStreamBusyRight], byte 0
        je short loc_AEA22
        mov eax, 1
        call sub_ADEE9
        mov dword [GusStreamBusyRight], 0
loc_AEA22:
        ret
GusStartStream:
        push ebp
        LD mov, ebp, esp
        push ebx
        push esi
        push edi
        pushf
        cli
        mov ecx, 4
        LD xor, esi, esi
loc_AEA32:
        mov ebx, dword [nosplit esi*4+off_D846C]
        mov dword [byte ebx+04h], 0FFh
        inc esi
        loop loc_AEA32
        mov eax, dword [byte ebp+010h]
        mov dword [dword_D847C], eax
        shr eax, 1
        mov dword [dword_D8480], eax
        shr eax, 1
        mov dword [dword_D8484], eax
        mov eax, 1
        mov dword [dword_D8490], 0
loc_AEA68:
        shl eax, 1
        inc dword [dword_D8490]
        cmp eax, dword [dword_D8484]
        jb short loc_AEA68
        mov eax, dword [dword_D8490]
        inc eax
        mov dword [dword_D848C], eax
        inc eax
        mov dword [dword_D8488], eax
        mov eax, dword [byte ebp+08h]
        mov dword [dword_D7AF4], eax
        add eax, dword [dword_D8480]
        mov dword [dword_D7B00], eax
        push es
        push ds
        pop es
        mov edi, dword [byte ebp+08h]
        mov ecx, dword [dword_D8484]
        cld
        rep stosd
        pop es
        mov eax, dword [byte ebp+0Ch]
        mov dword [dword_D84B0], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [word_D84BC], eax
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [dword_D8480]
        mov dword [dword_D84B4], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [dword_D84C0], eax
        mov eax, dword [byte ebp+0Ch]
        add eax, dword [dword_D847C]
        mov dword [dword_D84B8], eax
        push ebx
        LD mov, ebx, eax
        and ebx, 0FFFC000h
        and eax, 3FFFh
        shr eax, 1
        LD or, eax, ebx
        shl eax, 9
        pop ebx
        mov dword [dword_D84C4], eax
        mov dword [dword_D8498], 0
        mov dword [dword_D7AF8], 1
        mov dword [dword_D7B04], 1
        mov esi, dword [dword_D84B0]
loc_AEB45:
        LD xor, edx, edx
        LD mov, eax, esi
        call sub_B1F1C
        inc esi
        cmp esi, dword [dword_D84B8]
        jbe short loc_AEB45
        LD xor, edx, edx
        LD mov, eax, esi
        call sub_B1F1C
        mov eax, sub_AE903
        call sub_B14E4
        LD xor, eax, eax
        LD xor, edx, edx
        call sub_B1CBC
        mov dword [byte_D849C], eax
        LD xor, eax, eax
        LD xor, edx, edx
        call sub_B1CBC
        mov dword [byte_D84A0], eax
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D849C]
        out dx, al
        mov al, 1
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 400h
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 3
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BC]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 2
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BE]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BC]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BE]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 5
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [dword_D84C4]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 4
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84C6]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 2Ch
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        mov al, 9
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 0FFFFh
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov dx, word [GusRegSelectPort]
        mov al, 0Ch
        out dx, al
        mov dx, word [GusDataHighPort]
        mov al, 7
        out dx, al
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D84A0]
        out dx, al
        mov al, 1
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 400h
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 9
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, 0
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 3
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BC]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 2
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BE]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 5
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [dword_D84C0]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 4
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84C2]
        mov dx, word [GusDataLowPort]
        out dx, ax
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D84A0]
        out dx, al
        mov al, 0Bh
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BC]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0Ah
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov ax, word [word_D84BE]
        mov dx, word [GusDataLowPort]
        out dx, ax
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 24h
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dword [dword_D8498], 0Fh
        mov dword [dword_D7AF0], 1
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
sub_AEDBC:
        pushf
        cli
        cmp dword [dword_D7AF0], byte 0
        je near loc_AEE52
        mov dword [dword_D8498], 0
        pushf
        cli
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D84A0]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        popf
        mov dx, word [GusVoiceSelectPort]
        mov al, byte [byte_D849C]
        out dx, al
        mov al, 0
        mov dx, word [GusRegSelectPort]
        out dx, al
        mov al, 3
        mov dx, word [GusDataHighPort]
        out dx, al
        push ax
        push dx
        mov dx, word [GusDramPort]
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        in al, dx
        pop dx
        pop ax
        out dx, al
        mov dword [dword_D7AF0], 0
loc_AEE52:
        popf
        ret
sub_AEE54:
        push ebp
        LD mov, ebp, esp
        push ebx
        push esi
        push edi
        pushf
        cli
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae near loc_AEF08
        mov esi, dword [nosplit esi*4+off_D846C]
        mov eax, dword [byte ebp+01Ch]
        cmp eax, byte 0
        jne short loc_AEE86
        push dword [byte ebp+08h]
        call sub_AEFA2
        pop eax
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
loc_AEE86:
        push dword [byte ebp+01Ch]
        push dword [byte ebp+08h]
        call sub_AF076
        add sp, byte 8
        push dword [byte ebp+020h]
        push dword [byte ebp+08h]
        call sub_AEFEA
        add sp, byte 8
        push dword [byte ebp+018h]
        push dword [byte ebp+014h]
        push dword [byte ebp+010h]
        push dword [byte ebp+0Ch]
        push dword [byte ebp+08h]
        call sub_AF0D5
        add sp, byte 14h
        LD xor, eax, eax
        mov byte [byte esi+04Ch], al
        mov byte [byte esi+050h], al
        mov eax, dword [byte ebp+024h]
        mov byte [byte esi+0Ch], al
        LD or, eax, eax
        je short loc_AEEF5
        cmp dword [byte ebp+014h], byte 0
        je short loc_AEEF5
        mov edi, dword [byte ebp+0Ch]
        LD xor, edx, edx
        LD xor, ecx, ecx
        LD xor, eax, eax
loc_AEEDD:
        mov al, byte [edi]
        mov bx, word [nosplit eax*2+word_D7414]
        inc edi
        LD add, dl, bl
        LD add, dl, bh
        inc ecx
        cmp ecx, dword [byte ebp+014h]
        jb short loc_AEEDD
        mov byte [byte esi+050h], dl
loc_AEEF5:
        push byte 7Fh
        push dword 0FFh
        push dword [byte ebp+08h]
        call sub_AEF33
        add sp, byte 0Ch
loc_AEF08:
        popf
        pop edi
        pop esi
        pop ebx
        leave
        ret
sub_AEF0E:
        push ebp
        LD mov, ebp, esp
        push ecx
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AEF26
        mov esi, dword [nosplit esi*4+off_D846C]
        cmp dword [esi], byte 0
        jne short loc_AEF2E
loc_AEF26:
        mov eax, 1
        pop ecx
        leave
        ret
loc_AEF2E:
        LD xor, eax, eax
        pop ecx
        leave
        ret
sub_AEF33:
        push ebp
        LD mov, ebp, esp
        push esi
        mov eax, dword [byte ebp+010h]
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AEF9F
        mov esi, dword [nosplit esi*4+off_D846C]
        LD xor, ebx, ebx
        mov bl, byte [byte ebp+0Ch]
        mov dword [byte esi+08h], ebx
        cmp bl, 0FFh
        je short loc_AEF77
        mov eax, dword [nosplit ebx*4+dword_D6B00]
        mul dword [byte esi+02Ch]
        and eax, 0FFFF0000h
        and edx, 0FFFFh
        mov dword [byte esi+040h], edx
        mov dword [byte esi+044h], eax
        mov dword [byte esi+030h], edx
        mov dword [byte esi+034h], eax
loc_AEF77:
        mov eax, dword [byte esi+018h]
        mov dword [byte esi+024h], eax
        mov eax, dword [byte esi+01Ch]
        cmp dword [byte esi+010h], byte 0
        jne short loc_AEF89
        mov eax, dword [byte esi+020h]
loc_AEF89:
        mov dword [byte esi+028h], eax
        mov eax, dword [byte esi+014h]
        mov dword [byte esi+038h], eax
        mov dword [byte esi+03Ch], 0
        mov dword [esi], 1
loc_AEF9F:
        pop esi
        leave
        ret
sub_AEFA2:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AEFC6
        cmp esi, byte 1
        jle short loc_AEFC6
        mov esi, dword [nosplit esi*4+off_D846C]
        mov eax, dword [byte esi+01Ch]
        mov dword [byte esi+028h], eax
        mov dword [esi], 0
loc_AEFC6:
        pop esi
        leave
        ret
sub_AEFC9:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AEFE7
        cmp esi, byte 1
        jle short loc_AEFE7
        mov esi, dword [nosplit esi*4+off_D846C]
        mov dword [esi], 0
loc_AEFE7:
        pop esi
        leave
        ret
sub_AEFEA:
        push ebp
        LD mov, ebp, esp
        push esi
        push edi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF054
        mov esi, dword [nosplit esi*4+off_D846C]
        mov al, byte [byte ebp+0Ch]
        cmp al, byte [byte esi+04h]
        je short loc_AF054
        mov byte [byte esi+04h], al
        shl al, 1
        and eax, 0FFh
        lea edi, [byte esi+058h]
        LD mov, esi, eax
        LD xor, eax, eax
        LD xor, ebx, ebx
        sub ebx, dword [byte ebp+0Ch]
        shl ebx, 8
        LD mov, edx, eax
        shr edx, 1
        mov word [edi], dx
        LD mov, edx, ebx
        shr edx, 1
        mov word [dword edi+0100h], dx
        add edi, byte 2
        mov ecx, 7Fh
loc_AF039:
        LD add, eax, esi
        LD mov, edx, eax
        shr edx, 1
        mov word [edi], dx
        LD add, ebx, esi
        LD mov, edx, ebx
        shr edx, 1
        mov word [dword edi+0100h], dx
        add edi, byte 2
        loop loc_AF039
loc_AF054:
        pop edi
        pop esi
        leave
        ret
sub_AF058:
        push ebp
        LD mov, ebp, esp
        push esi
        movzx esi, word [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF073
        mov esi, dword [nosplit esi*4+off_D846C]
        movsx eax, word [byte ebp+0Ch]
        mov dword [byte esi+048h], eax
loc_AF073:
        pop esi
        leave
        ret
sub_AF076:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF0D2
        mov esi, dword [nosplit esi*4+off_D846C]
        mov ecx, 5622h
        LD xor, edx, edx
        mov eax, dword [byte ebp+0Ch]
        div ecx
        mov dword [byte esi+040h], eax
        mov dword [byte esi+030h], eax
        LD mov, ebx, eax
        LD xor, eax, eax
        div ecx
        mov dword [byte esi+044h], eax
        mov dword [byte esi+034h], eax
        and eax, 0FFFF0000h
        LD or, eax, ebx
        ror eax, 10h
        mov dword [byte esi+02Ch], eax
        mov eax, dword [byte esi+02Ch]
        cmp eax, 10000h
        je short loc_AF0C8
        mov eax, dword [dword_D8484]
        shr eax, 2
        jmp short loc_AF0CF
loc_AF0C8:
        mov eax, dword [dword_D8484]
        shr eax, 1
loc_AF0CF:
        mov dword [byte esi+054h], eax
loc_AF0D2:
        pop esi
        leave
        ret
sub_AF0D5:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF10F
        mov esi, dword [nosplit esi*4+off_D846C]
        LD xor, eax, eax
        mov byte [byte esi+0Ch], al
        mov eax, dword [byte ebp+0Ch]
        mov dword [byte esi+014h], eax
        mov ebx, dword [byte ebp+010h]
        LD add, ebx, eax
        mov dword [byte esi+020h], ebx
        mov ebx, dword [byte ebp+014h]
        LD add, ebx, eax
        mov dword [byte esi+018h], ebx
        add ebx, dword [byte ebp+018h]
        mov dword [byte esi+01Ch], ebx
        mov eax, dword [byte ebp+018h]
        mov dword [byte esi+010h], eax
loc_AF10F:
        pop esi
        leave
        ret
sub_AF112:
        push ebp
        LD mov, ebp, esp
        add esp, byte 0FFFFFFFCh
        push esi
        push edi
        mov eax, dword [byte ebp+0Ch]
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF194
        mov esi, dword [nosplit esi*4+off_D846C]
        mov ebx, dword [byte esi+08h]
        mov byte [byte ebp-01h], bl
        mov edi, dword [byte esi+034h]
        or edi, dword [byte esi+030h]
        ror edi, 10h
        add edi, dword [byte ebp+010h]
        cmp dword [byte ebp+014h], byte 0
        je short loc_AF186
        LD xor, ebx, ebx
        mov bl, byte [byte ebp-01h]
        add bl, byte [byte ebp+018h]
        mov eax, dword [nosplit ebx*4+dword_D6B00]
        mul dword [byte esi+02Ch]
        shl edx, 10h
        shr eax, 10h
        LD or, eax, edx
        LD sub, eax, edi
        mov edx, dword [byte ebp+014h]
        cmp edx, byte 0
        jg short loc_AF16A
        jl short loc_AF178
loc_AF16A:
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD add, edi, eax
        jmp short loc_AF186
loc_AF178:
        neg edx
        mul edx
        shr eax, 0Eh
        shl edx, 12h
        LD or, eax, edx
        LD sub, edi, eax
loc_AF186:
        LD mov, ecx, edi
        shl edi, 10h
        mov dword [byte esi+044h], edi
        shr ecx, 10h
        mov dword [byte esi+040h], ecx
loc_AF194:
        pop edi
        pop esi
        leave
        ret
GusStreamBusy:
        mov eax, dword [GusStreamBusyLeft]
        or eax, dword [GusStreamBusyRight]
        ret
sub_AF1A4:
        push ebp
        LD mov, ebp, esp
        push esi
        mov esi, dword [byte ebp+08h]
        cmp esi, byte 4
        jae short loc_AF1BE
        mov esi, dword [nosplit esi*4+off_D846C]
        movzx eax, byte [byte esi+04h]
        pop esi
        leave
        ret
loc_AF1BE:
        LD xor, eax, eax
        pop esi
        leave
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusGetEnvConfig:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ecx, eax
        mov eax, dword [dword_D84CC]
        call getenv_
        mov edx, eax
        mov dword [dword_F612C], eax
        test eax, eax
        je near loc_AF2CA
        mov edx, dword_F612C
        mov ebx, 10h
        call strtoul_
        mov word [byte ecx+02h], ax
        mov eax, dword [dword_F612C]
        cmp byte [eax], 2Ch
        jne short loc_AF214
        inc eax
        mov dword [dword_F612C], eax
loc_AF214:
        mov edx, dword_F612C
        mov ebx, 0Ah
        mov eax, dword [dword_F612C]
        call strtoul_
        mov byte [byte ecx+07h], al
        mov eax, dword [dword_F612C]
        cmp byte [eax], 2Ch
        jne short loc_AF23B
        inc eax
        mov dword [dword_F612C], eax
loc_AF23B:
        mov edx, dword_F612C
        mov ebx, 0Ah
        mov eax, dword [dword_F612C]
        call strtoul_
        mov byte [byte ecx+06h], al
        mov eax, dword [dword_F612C]
        cmp byte [eax], 2Ch
        jne short loc_AF262
        inc eax
        mov dword [dword_F612C], eax
loc_AF262:
        mov edx, dword_F612C
        mov ebx, 0Ah
        mov eax, dword [dword_F612C]
        call strtoul_
        mov byte [byte ecx+04h], al
        mov eax, dword [dword_F612C]
        cmp byte [eax], 2Ch
        jne short loc_AF289
        inc eax
        mov dword [dword_F612C], eax
loc_AF289:
        mov edx, dword_F612C
        mov ebx, 0Ah
        mov eax, dword [dword_F612C]
        call strtoul_
        mov dx, word [byte ecx+02h]
        mov byte [byte ecx+05h], al
        test dx, dx
        je short loc_AF2C8
        cmp byte [byte ecx+06h], 0
        je short loc_AF2C8
        cmp byte [byte ecx+07h], 0
        je short loc_AF2C8
        cmp byte [byte ecx+04h], 0
        je short loc_AF2C8
        cmp byte [byte ecx+05h], 0
        je short loc_AF2C8
        mov eax, 1
        jmp short loc_AF2CA
loc_AF2C8:
        xor eax, eax
loc_AF2CA:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
GusProbePort:
        push ebp
        mov ebp, esp
        push ebx
        push ecx
        push edx
        mov ebx, eax
        mov ecx, eax
        add ebx, byte 8
        add ecx, byte 0Ah
        and ebx, 0FFFFh
        mov edx, 0AAh
        mov eax, ebx
        call outp_
        and ecx, 0FFFFh
        mov eax, ecx
        call inp_
        cmp eax, 0AAh
        jne short loc_AF335
        mov edx, 55h
        mov eax, ebx
        call outp_
        mov eax, ecx
        call inp_
        cmp eax, byte 55h
        jne short loc_AF335
        mov eax, 1
        jmp short loc_AF337
loc_AF335:
        xor eax, eax
loc_AF337:
        lea esp, [byte ebp-0Ch]
        pop edx
        pop ecx
        pop ebx
        pop ebp
        ret
        db 00h
sub_AF340:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        sub esp, byte 10h
        mov esi, eax
        xor ah, ah
        mov byte [byte ebp-010h], ah
        lea eax, [nosplit esi*4+00h]
        mov ecx, dword [dword eax+dword_D84D0]
        test ecx, ecx
        je near loc_AF412
        shl ebx, 7
        add edx, ebx
        sub edx, 2000h
        imul edx, ecx
        test edx, edx
        jge short loc_AF37E
        mov bl, 1
        neg edx
        mov byte [byte ebp-010h], bl
loc_AF37E:
        mov ecx, 2000h
        mov ebx, edx
        mov eax, edx
        sar edx, 1Fh
        idiv ecx
        sar ebx, 0Dh
        mov ecx, 0Ch
        mov dword [byte ebp-018h], edx
        mov eax, ebx
        xor edx, edx
        div ecx
        mov eax, 0Ch
        mov edi, edx
        lea ecx, [byte ebx+01h]
        mov dword [byte ebp-014h], eax
        xor edx, edx
        mov eax, ecx
        div dword [byte ebp-014h]
        mov dword [byte ebp-01Ch], edx
        mov dword [byte ebp-014h], 0Ch
        mov eax, ebx
        mov ebx, dword [byte ebp-014h]
        xor edx, edx
        div ebx
        mov ebx, eax
        mov eax, 0Ch
        xor edx, edx
        mov dword [byte ebp-014h], eax
        mov eax, ecx
        div dword [byte ebp-014h]
        mov cl, bl
        mov ebx, dword [nosplit edi*4+dword_D7ABC]
        mov edx, dword [byte ebp-01Ch]
        shl ebx, cl
        mov cl, al
        mov eax, dword [nosplit edx*4+dword_D7ABC]
        shl eax, cl
        mov edi, dword [byte ebp-018h]
        sub eax, ebx
        imul eax, edi
        shr eax, 0Dh
        mov cl, byte [byte ebp-010h]
        add ebx, eax
        test cl, cl
        je short loc_AF417
        mov eax, 100000h
        mov edx, eax
        sar edx, 1Fh
        idiv ebx
        mov ebx, eax
        jmp short loc_AF417
loc_AF412:
        mov ebx, 400h
loc_AF417:
        mov eax, esi
        mov edx, ebx
        call sub_AB6D0
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
sub_AF428:
        push ebp
        mov ebp, esp
        push ecx
        push esi
        push edi
        mov ecx, eax
        mov eax, ebx
        cmp edx, byte 2Bh
        jb near loc_AF4B9
        jbe near loc_AF6CB
        lea ebx, [nosplit ecx*4+00h]
        cmp edx, byte 64h
        jb short loc_AF48C
        jbe near loc_AF657
        cmp edx, byte 78h
        jb short loc_AF47E
        jbe near loc_AF6C4
        cmp edx, byte 79h
        jbe near loc_AF673
        cmp edx, byte 7Bh
        jb near loc_AF6CB
        cmp edx, byte 7Fh
        jbe near loc_AF6C4
        jmp near loc_AF6CB
loc_AF47E:
        cmp edx, byte 65h
        je near loc_AF665
        jmp near loc_AF6CB
loc_AF48C:
        cmp edx, byte 60h
        jb short loc_AF4A8
        jbe near loc_AF583
        cmp edx, byte 61h
        je near loc_AF5AB
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF4A8:
        cmp edx, byte 40h
        je near loc_AF63E
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF4B9:
        cmp edx, byte 0Ah
        jb short loc_AF4F1
        jbe near loc_AF601
        cmp edx, byte 26h
        jb short loc_AF4E0
        jbe near loc_AF558
        cmp edx, byte 27h
        je near loc_AF6CB
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF4E0:
        cmp edx, byte 0Bh
        je near loc_AF610
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF4F1:
        cmp edx, byte 6
        jb short loc_AF509
        jbe short loc_AF523
        cmp edx, byte 7
        je near loc_AF5D3
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF509:
        cmp edx, byte 1
        jne near loc_AF6CB
        mov edx, ebx
        mov eax, ecx
        call sub_AB80C
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF523:
        cmp dword [nosplit ecx*4+dword_D8550], byte 0
        jne near loc_AF6CB
        cmp dword [nosplit ecx*4+dword_D8590], byte 0
        jne near loc_AF6CB
        cmp eax, byte 18h
        jle short loc_AF549
        mov eax, 18h
loc_AF549:
        mov dword [nosplit ecx*4+dword_D84D0], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF558:
        cmp dword [nosplit ecx*4+dword_D8550], byte 0
        jne near loc_AF6CB
        cmp dword [nosplit ecx*4+dword_D8590], byte 0
        jne near loc_AF6CB
        mov dword [nosplit ecx*4+dword_D8510], ebx
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF583:
        cmp dword [dword ebx+dword_D8550], byte 0
        jne near loc_AF6CB
        cmp dword [dword ebx+dword_D8590], byte 0
        jne near loc_AF6CB
        add dword [dword ebx+dword_D8510], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF5AB:
        cmp dword [dword ebx+dword_D8550], byte 0
        jne near loc_AF6CB
        cmp dword [dword ebx+dword_D8590], byte 0
        jne near loc_AF6CB
        sub dword [dword ebx+dword_D8510], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF5D3:
        mov edx, dword [nosplit ecx*4+dword_D8610]
        imul edx, ebx
        mov dword [nosplit ecx*4+dword_D85D0], ebx
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov eax, ecx
        call sub_AB658
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF601:
        mov edx, ecx
        call sub_AD2A8
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF610:
        mov edx, dword [nosplit ecx*4+dword_D85D0]
        imul edx, ebx
        mov dword [nosplit ecx*4+dword_D8610], ebx
        mov ebx, 7Fh
        mov eax, edx
        sar edx, 1Fh
        idiv ebx
        mov edx, eax
        mov eax, ecx
        call sub_AB658
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF63E:
        cmp eax, byte 18h
        setge al
        xor edx, edx
        mov dl, al
        mov eax, ecx
        call sub_ACC3C
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF657:
        mov dword [dword ebx+dword_D8590], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF665:
        mov dword [dword ebx+dword_D8550], eax
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF673:
        mov eax, ecx
        xor edx, edx
        call sub_ACC3C
        mov eax, ecx
        xor edx, edx
        mov esi, 64h
        call sub_AB80C
        mov edx, 400h
        mov eax, ecx
        mov edi, 7Fh
        call sub_AB6D0
        mov eax, ecx
        mov edx, esi
        mov dword [dword ebx+dword_D85D0], esi
        mov dword [dword ebx+dword_D8610], edi
        call sub_AB658
        mov edx, 0FFFFFFFFh
        mov eax, ecx
        call sub_AD2A8
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
loc_AF6C4:
        mov eax, ecx
        call sub_AD344
loc_AF6CB:
        lea esp, [byte ebp-0Ch]
        pop edi
        pop esi
        pop ecx
        pop ebp
        ret
