; x86enc.inc - encodings NASM cannot be told to pick (used by tools/asm_proto.py output)
;
; LD op, dst, src   reg,reg ALU/mov in the "load" form (opcode with d=1: 02/03, 0A/0B, ... 8A/8B).
;                   NASM always emits the "store" form (00/01, ... 88/89) for reg,reg; MASM-family assemblers
;                   (wasm, JWasm, TASM) always emit the load form. Watcom wcc386 code uses the store form,
;                   the hand-written asm modules (blitters, emulator, sound drivers) mostly the load form.

%assign N_eax 0
%assign W_eax 32
%assign N_ecx 1
%assign W_ecx 32
%assign N_edx 2
%assign W_edx 32
%assign N_ebx 3
%assign W_ebx 32
%assign N_esp 4
%assign W_esp 32
%assign N_ebp 5
%assign W_ebp 32
%assign N_esi 6
%assign W_esi 32
%assign N_edi 7
%assign W_edi 32
%assign N_ax 0
%assign W_ax 16
%assign N_cx 1
%assign W_cx 16
%assign N_dx 2
%assign W_dx 16
%assign N_bx 3
%assign W_bx 16
%assign N_sp 4
%assign W_sp 16
%assign N_bp 5
%assign W_bp 16
%assign N_si 6
%assign W_si 16
%assign N_di 7
%assign W_di 16
%assign N_al 0
%assign W_al 8
%assign N_cl 1
%assign W_cl 8
%assign N_dl 2
%assign W_dl 8
%assign N_bl 3
%assign W_bl 8
%assign N_ah 4
%assign W_ah 8
%assign N_ch 5
%assign W_ch 8
%assign N_dh 6
%assign W_dh 8
%assign N_bh 7
%assign W_bh 8
%assign OP_add 002h
%assign OP_or 00Ah
%assign OP_adc 012h
%assign OP_sbb 01Ah
%assign OP_and 022h
%assign OP_sub 02Ah
%assign OP_xor 032h
%assign OP_cmp 03Ah
%assign OP_mov 08Ah
%macro LD 3
 %if W_%2 == 16
  db 66h
 %endif
 %if W_%2 == 8
  db OP_%1, 0C0h | (N_%2 << 3) | N_%3
 %else
  db OP_%1 + 1, 0C0h | (N_%2 << 3) | N_%3
 %endif
%endmacro
