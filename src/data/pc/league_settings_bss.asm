; BSS of pc/league_settings (src/pc/league_settings).
bits 32
%include "hockey.inc"
section s_ED35C nobits alloc noexec write align=1
global leaguesetimg, setbits
leaguesetimg:                                   ; selects setting5 vs setting3 image; used by
                                                ; DrawLeagueSetDlgSel, PlayCrowdSample, SetLeagueSetImage
        resb 4
setbits:                                        ; settings dialog checkbox bits; used by ControlsDlgLoop,
                                                ; DrawControlsOpts, DrawCtlBoxes ...
        resb 1
        resb 3
