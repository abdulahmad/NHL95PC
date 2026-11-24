; BSS of front/league_game (src/front/league_game).
bits 32
%include "hockey.inc"
section s_DDD34 nobits alloc noexec write align=1
global lgoppteam, lgplayteam, lgopphuman, lgschedrec, lgschedrec_b1, lgschedrec_b2, lgschedrec_b3, lgschedrec_b4
global lgschedrec_b5, lggameidx, lggamecount, lgoppgamecount, savleague1, savleague2
lgoppteam:                                      ; Opponent of the league team being played; saved with the
                                                ; league game reference; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 4
lgplayteam:                                     ; human team chosen in PlayLeagueGame ("Select a team to
                                                ; play."); used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 4
lgopphuman:                                     ; Non-zero when the league opponent has its own human team
                                                ; file; saved with the league game reference; used by
                                                ; LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 4
lgschedrec:                                     ; PlayLeagueGame: the schedule record of the league game being
                                                ; played; used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 1
lgschedrec_b1:                                  ; lgschedrec+1; used by PlayLeagueGame
        resb 1
lgschedrec_b2:                                  ; lgschedrec+2; used by PlayLeagueGame
        resb 1
lgschedrec_b3:                                  ; lgschedrec+3; used by PlayLeagueGame
        resb 1
lgschedrec_b4:                                  ; lgschedrec+4: a finished game keeps the first score here;
                                                ; used by PlayLeagueGame
        resb 1
lgschedrec_b5:                                  ; lgschedrec+5: the second score; used by PlayLeagueGame
        resb 1
lggameidx:                                      ; schedule game picked in CalendarScreen (-1 none); used by
                                                ; LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 2
lggamecount:                                    ; Number of league games played (from the league file);
                                                ; compared with lggameidx; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 2
lgoppgamecount:                                 ; Number of league games played in the opponent's file; used
                                                ; by LoadLeagueGameRef, PlayLeagueGame, SaveLeagueGameRef
        resb 2
savleague1:                                     ; saved-game league path (0Dh): SaveLeagueGameRef writes it
                                                ; and opens its PINFO.DB; used by LoadLeagueGameRef,
                                                ; PlayLeagueGame, SaveLeagueGameRef
        resb 13
savleague2:                                     ; second saved-game league path (0Dh), used when lgopphuman is
                                                ; set; used by LoadLeagueGameRef, PlayLeagueGame,
                                                ; SaveLeagueGameRef
        resb 15
