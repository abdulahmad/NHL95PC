; Initialised data of front/desk_main (src/front/desk_main).
bits 32
%include "hockey.inc"
section s_C7218 progbits alloc noexec write align=1
global desksongalt, keepdesksong, songdata, str_InsufficientDiskSpace, str_ToSaveTheSettings, str_1KbytesFree, setdiskmsg, scrpitch
desksongalt:                                    ; alternates the desk song between maindesk and tonights; used
                                                ; by MainDeskLoop
        db 01h
keepdesksong:                                   ; set by easn_stats so returning to the desk keeps the song
                                                ; playing; used by EasnGoalieStatsScreen_m,
                                                ; EasnSkaterStatsScreen_m, EasnStandingsMenu_m ...
        db 00h,00h,00h,00h
songdata:                                       ; pointer to the loaded song (0 = none); freed and cleared
                                                ; after a fade in arena_logos; played with musichandle; used
                                                ; by AwardsCeremony, CalendarScreen, CoachCutScene ...
        db 00h,00h,00h,00h
str_InsufficientDiskSpace:                      ; string 'Insufficient disk space available'
        db 049h,06Eh,073h,075h,066h,066h,069h,063h,069h,065h,06Eh,074h,020h,064h,069h,073h
        db 06Bh,020h,073h,070h,061h,063h,065h,020h,061h,076h,061h,069h,06Ch,061h,062h,06Ch
        db 065h,00h
str_ToSaveTheSettings:                          ; string 'to save the settings, you require'
        db 074h,06Fh,020h,073h,061h,076h,065h,020h,074h,068h,065h,020h,073h,065h,074h,074h
        db 069h,06Eh,067h,073h,02Ch,020h,079h,06Fh,075h,020h,072h,065h,071h,075h,069h,072h
        db 065h,00h
str_1KbytesFree:                                ; string '1 Kbytes of free disk space.'
        db 031h,020h,04Bh,062h,079h,074h,065h,073h,020h,06Fh,066h,020h,066h,072h,065h,065h
        db 020h,064h,069h,073h,06Bh,020h,073h,070h,061h,063h,065h,02Eh,00h
setdiskmsg:                                     ; 3 MessageBox lines: not enough disk space for game.set; used
                                                ; by WriteModeState
        dd str_InsufficientDiskSpace
        dd str_ToSaveTheSettings
        dd str_1KbytesFree
        db 00h,00h
scrpitch:                                       ; planar VGA bytes per row (50h): every vga* routine
                                                ; multiplies y by it; used by FreeGameMemory, LoadGameGfx,
                                                ; MainDeskLoop ...
        db 050h,00h,00h,00h,00h,00h,00h,00h
