; Frame lists for the on-ice animation player.
bits 32
%include "hockey.inc"
section s_CBED0 progbits alloc noexec write align=1
extern str_Fanom, str_Goal, str_Clap2, str_Uflag, str_Cflag, str_Siren2, str_Ruff, str_Hook3
extern str_Saved2, str_Cross, str_Guilt
global ovlartnames, OvlScriptGoal, OvlScriptClap, OvlScriptFanom, OvlScriptUflag, OvlScriptCflag, OvlScriptSiren, OvlScriptRuff
global OvlScriptHook, OvlScriptSaved, OvlScriptCross, OvlScriptGuilt
ovlartnames:                                    ; LoadTeamPPV: name of the PPV art bank of each overlay
                                                ; sequence; used by Gameloop, LoadTeamPPV, PlayGame
        dd str_Fanom
        dd str_Goal
        dd str_Clap2
        dd str_Uflag
        dd str_Cflag
        dd str_Siren2
        dd str_Ruff
        dd str_Hook3
        dd str_Saved2
        dd str_Cross
        dd str_Guilt
OvlScriptGoal:                                  ; Overlay animation script for the goal overlay
        db 07h,00h,02h,01h,03h,01h,03h,01h
OvlScriptClap:                                  ; Overlay animation script for the clapping overlay
        db 013h,00h,00h,01h,02h,03h,00h,01h,02h,03h,00h,01h,02h,03h,00h,01h
        db 02h,03h,00h,00h
OvlScriptFanom:                                 ; Overlay animation script for the fan overlay
        db 01Eh,00h,01h,02h,02h,02h,02h,03h,04h,03h,04h,03h,02h,02h,02h,02h
        db 03h,04h,03h,04h,03h,02h,02h,02h,02h,02h,02h,05h,06h,07h,08h
OvlScriptUflag:                                 ; Overlay animation script for the uflag overlay
        db 028h,00h,00h,01h,01h,02h,02h,03h,03h,00h,00h,01h,01h,02h,02h,03h
        db 03h,00h,00h,01h,01h,02h,02h,03h,03h,00h,00h,01h,01h,02h,02h,03h
        db 03h,00h,00h,01h,01h,02h,02h,03h,03h
OvlScriptCflag:                                 ; Overlay animation script for the cflag overlay
        db 024h,00h,00h,01h,01h,02h,02h,00h,00h,01h,01h,02h,02h,00h,00h,01h
        db 01h,02h,02h,00h,00h,01h,01h,02h,02h,00h,00h,01h,01h,02h,02h,00h
        db 00h,01h,01h,02h,02h
OvlScriptSiren:                                 ; Overlay animation script for the siren overlay
        db 010h,00h,01h,02h,03h,00h,01h,02h,03h,00h,01h,02h,03h,00h,01h,02h
        db 03h
OvlScriptRuff:                                  ; Overlay animation script for the roughing overlay
        db 012h,00h,00h,01h,02h,03h,04h,00h,01h,02h,03h,04h,00h,01h,02h,03h
        db 04h,00h,00h
OvlScriptHook:                                  ; Overlay animation script for the hooking overlay
        db 019h,00h,00h,00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
        db 0Dh,0Eh,0Dh,0Eh,0Dh,0Eh,0Dh,0Eh,0Eh,0Eh
OvlScriptSaved:                                 ; Overlay animation script for the save overlay
        db 027h,00h,00h,00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
        db 0Dh,0Eh,0Fh,010h,011h,012h,013h,014h,015h,016h,016h,016h,017h,018h,019h,017h
        db 018h,019h,017h,018h,019h,019h,019h,019h
OvlScriptCross:                                 ; Overlay animation script for the cross-checking overlay
        db 0Eh,09h,09h,09h,00h,01h,02h,03h,04h,05h,06h,07h,08h,08h,08h
OvlScriptGuilt:                                 ; Overlay animation script for the guilty player overlay
        db 022h,00h,00h,00h,01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
        db 0Dh,0Eh,0Fh,010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01Ah,01Bh,01Ch
        db 01Dh,01Dh,01Dh
