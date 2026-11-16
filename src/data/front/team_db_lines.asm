; The away goalie, the scratches, and the path of the game summary.
bits 32
%include "hockey.inc"
section s_D9A38 nobits alloc noexec write align=1
global awgoalieidx, awscratch, gsummarypath, photoptrs, awlinetab
photoptrs:                                      ; 46Eh picture pointers, 50 per photo bank (IndexPhotoBank);
                                                ; used by DrawFrameSprite, IndexPhotoBank
        resb 4536
awlinetab:                                      ; visitor line table (tmlines of awtmstruct), as hmlinetab;
                                                ; used by BuildDefaultLines, CanFillLineSlot, DeskVisitorLines
                                                ; ...
        resb 36
awgoalieidx:                                    ; roster slots of the two visiting goalies; used by
                                                ; SetupGoalieMenu
        resb 1
        resb 3
awscratch:                                      ; 8 scratched visiting roster slots (64h = none); used by
                                                ; LoadGameTeams
        resb 8
gsummarypath:                                   ; path of the league gsummary.db (MakeGSummaryPath,
                                                ; InitGameSummary); used by AppendGSumRecord, InitGameSummary,
                                                ; MakeGSummaryPath ...
        resb 32
