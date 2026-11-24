; Initialised data of pc/file_locations (src/pc/file_locations).
bits 32
%include "hockey.inc"
section s_D2C68 progbits alloc noexec write align=1
global cddrivestr, cddriveptr
cddrivestr:                                     ; 'a:' drive string, letter patched from nhl.cfg; used by
                                                ; InitFileLocations
        db 061h,03Ah,00h
cddriveptr:                                     ; pointer to cddrivestr, MakePath prefix for CD files; used by
                                                ; AddHumanTeam, AwardsCeremony, CalGoalieStatsScreen ...
        dd cddrivestr
        db 00h,01h,00h,00h,00h
