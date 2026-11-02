# Session log (archived from HANDOFF.md)

Moved verbatim from HANDOFF.md sections 3 and 4 (before Unsure).
Current handoff: [HANDOFF.md](../HANDOFF.md). Progress: [C_PROGRESS.md](../C_PROGRESS.md).

## 3. Current state (updated 2026-10-14, head: see `git log -1`)

**C matching resumed** (2026-10-14). LoadPlayoffModeTree matches (`-od`). Its unused 64 bytes, the path and the schedule record are one 104-byte buffer, so parameter `a` stays at ebp-30h and the return temporary at ebp-2Ch. Two or three separate arrays swap those slots. Name the auto globals a newly matched function uses, from that function's Genesis routine (95G, then 94G, then 93G). This function's globals were already named.

`make fullcheck` on this tree: CBUILD=1 and CBUILD=0 both MATCH. 611 of 1,084 compiled-C game functions match, 204 drafts. This session matched ScratchPlayer (status 2, tail MenuShowPlayerStats_status) and DressPlayer (status 3, then MenuShowPlayerStats_ret) and ShowPlayerStatsItem (goalie sets deskexit 4, otherwise 5, then jumps to DeskSetExit_ret1). This session matched check4bench, CheckTeamLines, CheckRosterComplete, CheckGameRosterComplete, ErrorScreenWait and QueuePenaltyType. The early-outs are one test, `if ((clock running and joystick) or pflags2 bit 4) return 0`, so the joystick test jumps to the shared `xor eax, eax`. PlacePlayersAtStart is a draft (535 vs 534): the assignment number is `lea edx, [eax+16h]` where the original adds 16h in eax; the map negate is `cwde` instead of a reload; the mirror negates regd1 in ecx; the loop count is in si (cookie 14h). Do not retry an `int` sum for that add, or `n += 0x16`. PassLaneChk is a draft (344 vs 346): the side copy is `mov esi, edi` (original `mov edx, edi`), and the direction wrap is `inc esi` instead of `lea eax, [esi+1]`. Do not retry declaring limit first, or oy before side. TreeSeriesWinner is a draft (379 vs 379, `-od`): the instructions match and the win counters are in the right slots; the series pointer, same and round are reversed, and the return sits at ebp-10h. Do not retry reversing the locals or one block for every local. checkob is a draft (424 vs 424): the far-side player test is `cmp ecx, esi` / `jg` where the original is `cmp esi, ecx` / `jl`. Do not retry putting the limit on the left of `<`. GetLowestPen is a draft in that file (166 vs 166), after SkillForAnim so each exit is a near jump to checkob's pops. The trail step is `sub eax, ecx` / `cwde` / `add ebx, eax` where the original has no cwde, and the power-play return is `lea eax, [ebx+ecx]` where the original is `mov eax, ebx` / `add eax, ecx`. Do not retry a named int for the step, an unsigned-short store, or writing the step as `pen - prev`. ReturnGoalies matches in that file: the goalie nibble is stored and reloaded through `[esp-2]`, and the exit jumps to checkob_ret5a. LoadClipSlot matches in ShutdownSpeech.c (marked in the announcer segment): the two 26h-byte slots are swapped through a SpeechSlot local, and the exit jumps to ShutdownSpeech_ret6. burst matches in checkob.c (202 vs 202): with line changes on it subtracts CCh from tmpde[pnum] (not below 0), adds dirtab[facedir*2] and dirtab_y[facedir*2] times energy>>7 to Xvel and Yvel, locks pflags bit 5, starts SPA 621h, and jumps to checkob_ret5. The clamp is passed through burst_bx (`mov ebx, edx`, parm edx, value ebx) so the team pointer reloads into ecx. A parm [ebx] aux computes the clamp in ebx and drops that move (200 vs 202). Do not retry computing the clamp straight into ebx. StarCompare is a draft (619 vs 653): the remainder of *a / 25 is stored at esp+4 and the second point total takes ebp, where the original keeps that player index in ebp and the total at esp+8. The frame is 0Ch, not 10h. Do not retry a register local, an inner block, or a one-element array for that total. SaveLeagueGameRef is a draft (483 vs 520): the frame and the handle slot match, and each FileWriteAt result is tested in eax. The original copies that result to edx first. Do not retry register, declaration order, or goto labels for that copy. QueuePenaltyType matched: each preload is a bottom-tested loop, and the bank limit is an unsigned subtract. SelectFloppyDrive is a draft (551 vs 551): file is in edi, name lands in ebp and the found flag in esi (original: name in esi, flag in ebp), and drive+1 is a copy to eax plus inc where the original stores floppyok through edx and uses lea eax,[edx+1]. Do not retry declaration order, register, or a char* flag for that swap. LoadRockMusic is a draft (577 vs 573): the cue loops and the tune banks match, the zero cue is xor ebp instead of xor esi (cookie 3Ch), and team*3 reloads the stack slot instead of copying it through edx. CrowdNoiseUpdate matches: the voice-8 level and the crowdlevel diff share one local so the level stays in ecx, and the loud-branch shift is written back through the dead parameter (`n = (v - 0x390) >> 2; v = n + 0x28`) so it is `lea eax,[ecx-390h] / sar eax,2 / lea ecx,[eax+28h]`. A fresh local is coalesced into the in-place `sub/sar/add`. UpdateTeamDbs matches: the path, the league name, the handle and the mouse slots are one 44h-byte local. cdiff prints the `mov [mergestatemsg+8], str_HasNotBeenMerged` store as `!` because that instruction has two absolute fixups; both targets are the original ones. CanFillLineSlot is a draft (688 vs 669): side*444h is computed in eax and added to hmroster, where the original keeps that stride in ebx and indexes [ebx+eax+hmroster]. Do not retry a separate base local or hmroster + stride; both spill. CountSeriesWins is a draft (904 vs 872, -od): the argument homes, the index at ebp-10h and the 3Ch frame match, but the schedule pointer is at ebp-0Ch and the game pointer at ebp-8 (original ebp-8 and ebp-4). Do not drop the game-byte pointer; the frame shrinks to 38h. UpdatePlayoffSeries matches: the team record, 26 win counts, an 8-byte game and the six indexes are one 370h-byte local, and `if (!err && cond)` at the top of the loop that already tests `!err` is the flag-only `jne`. UpdateHudPanel matches: the saved hundredths stay in eax for TickPanelClock, and 500 stays in ebx across both energy-bar divisions. CheckLeagueDiskSync is a draft (598 vs 590): team*30 reloads the stack slot, but dir is in ebp and the error in edi (original edi and ebp), so the league id is copied to edx and the team byte is read into al. Do not retry declaration order, a separate file pointer, or dropping volatile on the team index. PostPenaltyEvent is a draft (688 vs 683): the prologue matches (cookie 2Ch, len moved to edx). The queue index is esi where the original uses ecx, and the wording tail recomputes who==0, widens the jersey with mov al/and eax instead of movzx edi, and uses setb instead of setl. A withtime local brought the frame pointer back. Do not retry that local, an early return, or a duplicated PaPenalty. assrefpenshot is a draft (737 vs 740): the prologue matches and the pfna clear is mov dh, dl. The hidden puck reloads its zero into ax (original dx), so the five stores address through edx, and the countdown is add al, 8 (original mov ah, ch; add ah, 8). Do not retry a function-level int, an unnamed reload, or a second pflags shape. DrawPanelClock matches in UpdateHudPanel.c: the zero-minute and minutes arms test the clock globals directly, and the exit jumps into UpdateHudPanel's pops. TrackScrollBars is a draft (344 vs 344 beside TrackButtons): the prologue matches, and the item index multiplies after h-4 is stored. Do not retry a pointer local or dropping the volatile slot. ModeSetViewLoop is a draft (418 vs 418 beside MenuModeSettings): the slots, the sprite size and the 17-byte header match. The button test copies the result through edx (`mov edx, eax; test dl, 6`); the original stores eax and tests al. Do not retry a named h/w or the other multiply order. RebuildLeagueDbs matches in UpdateTeamDbs.c: the team index is the mouse-x slot, `for` puts the test after the leading jump, and the exit jumps to UpdateTeamDbs_ret. DrawFileDlgTabs matches in LoadFileDlgShapes.c: a negative tab is the open/delete/done page, and tabs 0, 1 and 2 share the tab-sprite call. The exit jumps to LoadFileDlgShapes_x. ScanSavedGames is a draft (568 vs 568 beside LoadFileDlgShapes): the three scans match except four byte registers (exhibition terminator ah vs bl, playoff name dl vs bh, its terminator dl vs ch, league terminator dh vs bl). Do not retry a second char or a named zero. DeleteSavedGame is a draft (623 vs 624 beside LoadFileDlgShapes): the pack loop, both result zeros, the count decrement and the empty-list switch match. strcpy's cursor and the strcat extension index are eax where the original uses edx, and `mov eax,[fdlgtab]` is one byte shorter than `mov edx,[fdlgtab]`. Do not retry naming that index or an inner block for it. ResetGameVars is a draft (654 vs 657 beside IndexPhotoBank): the clears through word_CBEC2 match, and xor esi, esi before the penshot dwords matches. mov ecx, edx sits between ovlstep and ovlseq, the shot dwords skip xor eax, eax, and CwdExciteLvl is stored from si. Do not retry an address-taken copy, moving textline5 ahead of the banner stores, or n2 = neg. MenuNewLeague matches in MenuAddTeam.c: the two byte updates on lgstate+5Ah keep both stores in bl/bh, and testing ctlavailmask directly loads cl. The exit jumps to MenuAddTeam_ret2. cdiff prints the three menuact stores as ! because each has two absolute fixups. LoadTeamRoster is a draft (926 vs 1041): the frame is sub esp,0F4h (cookie 134h) and team*186 is add esi,esi where the original shifts the *744 byte offset with shl eax,3. Do not retry explicit shift statements for that index. MenuShowPlayerStats matches: the roster row is side * 0x2F4 (the shift chain; side * 0x2DC is imul), and `*(volatile int *)sel >= 0` is `cmp dword [esi], 0`. CheckMasterPassword matches (fullcheck36): the name, mouse slots and the three palette bytes are one 20h-byte local, and the merge retry is a bottom-tested loop. PlayHilight is a draft (559 vs 559): songdata is ecx and the zero is esi, where the original uses esi and edi, so the s1font load and the four jctime loads are each one register along. Do not retry naming that pointer or folding songdata = z = 0. DrawCreatePlayer matches: one MakePath with a ternary hoists ecx and ebx, and the position switch falls through to strcat with `default: goto shown` so there is no leading zero of pos. RunMessageBox matches: the pointer-sprite size is a local computed before sub_8CCA8, so the flags push follows the multiply. TradeShowStats matches: the embpal3 path is the GameTeamStatsScreen shape (ext and name, then the CD-drive test), and cdiff flags the statsredrawcb store because that instruction has two absolute fixups. LockerRoomScreen matches: the return constant goes through a second local, so 2 is `mov eax, 2` and the loop result is `mov eax, esi`. SimScheduleDay matches: the same-day test falls through (`<=` is `jg` to the later day), and the teams pointer is copied before the stop flag is cleared. CompLine is a draft (482 vs 485): other is in esi and the line is in ecx, diff stays in ax, the flag byte is in al, and the saved line and best energy slots are swapped. Do not retry a stack struct for those slots (it pushes ebp). RosterPanelClick is a draft (507 vs 507): the free-agent toggle folds falistsel into edi (`add edi, eax` / `mov al, [edi]`) where the original is `mov dl, [edi+eax]`. Do not retry a named pointer or a split byte local. checkwallcoll is a draft (470 vs 481): the radius loads match, and the x test negates the limit in ecx instead of reloading x. Do not retry non-volatile limits or declaring ylim first. BuildTradeRoster is a draft (473 vs 473): the fill loop keeps the index in ebx and stores it through al. Do not retry a separate byte local, storing the index directly, or an aux reload of that byte. DrawLineGroupBars is a draft (472 vs 472): color and color2, and the two saved bar widths, sit in swapped stack slots. Do not retry an if/else for the group tests or a struct of those slots. DbLineEditor matches: the path is a 20h-byte local at the bottom of the frame, and the CD-drive test is the second MakePath argument. CheckDatabases is a draft (463 vs 469): the skater id is a scaled load and defense/skaters sit in ebp/edi swapped. Do not retry a line pointer or folding the index shift into that load. ShowDBError returns the error screen's result; its bytes are unchanged. InitGameSummary matches: the skater copy is `(t * 25 << 4) + (i << 4)` and the goalie copy indexes the byte row as shorts. SetupControllers matches. FindLeagueFloppy matches: the probe frame is one 98h-byte local, and file is copied before name so file stays in ebp. DrawPanel3D, EasnStandingsScreen, BlitTileMap and checkcoll are drafts (register pairs, or the tile-index register).  OpenPlayerDBs matches: four register arguments and three stack arguments, and the find buffer plus the path are one 4Ch-byte local so the mode stays in the pushed eax. POPickConfTeams and LoadShapeByTag are drafts (register pairs). BlockShotDive matches: the puckvz pointer is stored through dir so it reuses ebx, and the doubled face word stays in si. SeriesLength is a draft (116 vs 116): the shared return sits after the best-of-5 case instead of falling out of best-of-1. Do not retry that placement. noturn0 matches: dir is widened into eax before playeracc sign-extends it from ax. AskExportToFloppy matches: the mode bit 1 test writes the record offset as `i * 15 + i * 15`, so it stays in edx and both team buffers are addressed from there. CalSkaterStatsScreen and CalGoalieStatsScreen match in that file: each jumps to CalTeamStatsScreen_common. CalTeamStatsScreen matches: after the menu it sets dword_DDD2C to -1, reloads the calendar shapes, and returns 0. The zero that clears the redraw hook stays in its own local, and the return is a separate xor eax. EasnTeamStatsScreen matches: the desk page fills the palette buffer before the fade, keeps the desk song, and fades Pal7 in from the shape with no copy. Its opening `push dword 334h` was a `db` with no address; it is the same bytes, and the address comment is what puts the function in the count. GameSkaterStatsScreen matches on its own: the 1 that sets dword_DC738 and statspalvalid stays in one local, and the 0 that clears statspal is the same local pushed into the fade-back. GameGoalieStatsScreen matches in the same file as GameTeamStatsScreen: it jumps to GameTeamStatsScreen_common. cdiff flags the `mov [statsredrawcb], LeadersScreen` store because that instruction has two absolute fixups. GameTeamStatsScreen matches, including the shared menu tail. cdiff flags the `mov [statsredrawcb], TeamStatsScreen` store the same way. DrawLeagueSetDlgSel matches: MakePath is written in both branches so the CD-drive load is not shared. SetupGame matches: StartPreGame is called with a second 0 in edx, and PlacePlayersAtStart runs when line changes are on or the intro was not skipped. MenuSaveDbs matches. cdiff reports the two `mov [msglines], str` stores as different because each instruction has two absolute fixups and cdiff masks only one; the fixups are the same symbols as the EXE. ShellSortBytes matches: save base in a local so the frame is sub esp,14h plus push edx, and swap the left record first. OpenSelectedDb matches: the 13-byte empty directory is copied with inlined movsd/movsb, destination argument last, so edi is set before esi. MenuP2ControlsInGame already compiled to the original bytes and is now marked. sfx matches: `sounddev == 8 || sounddev == 4` keeps sounddev in ecx; a switch on those two values compiled as a range and left it in eax. checkagr matches: widen `n` into an `int` before `n/2 + n`, so the half stays in eax. CmpPoints matches: the games word is read `volatile`, so the compare stays `cmp si, [q]` instead of a copy in cx. DrawTradeRow matches: the cursor row offset (`tradecursor[side] * 0x16`) is computed before `side * 0x268`, so the `* 0x16` stays in eax (`add eax, eax`) and the side stride follows in ecx. ChkPullGoalieLate matches: `if (diff <= 0) return 0` falls through into `xor eax, ecx` and `jg` reaches the rest. a2touchpuck matches (the icing tail was the missing `edi` save). The byte after `iflags` is `icingPlayer`. BlitClipRect and QueueGoalieNote stay drafts. ChooseLeagueController is a draft (669 vs 669): the body matches, and the two jctime calls load list into ecx and names into esi where the original uses edi and ebp. Do not retry an inner block for y, a local team pointer, or an aux body for those frees. DrawHudPanel is a draft (691 vs 686): home stays in ebp and away is stored, where the original pushes eax and keeps away in ebp. Do not retry volatile home, a local copy of away, or taking home's address. RunDemoGame is a draft (673 vs 673): the setup and the restore copy match, but 0x10 and the later 1 stay in esi where the original uses ebp, and the fixed-pair index is cwde. Do not retry declaring that constant first or using the team local as the pair index. DecayCrowdLevel is a draft (705 vs 704): the prologue and the crowdlevel decay match. The slot pointer is esi and each spawned id is sign-extended into ebx. Do not retry an unsigned slot byte or dropping the address-of on the index. assintroline is a draft (682 vs 687): the wait loop and the flag setup match. The distance sum stays in edx; the original copies dx into ecx and dy into eax so the sum stays in eax, and the abs loads edx because eax still holds that sum. Do not retry a folded abs, dy*dy first, or nesting dist outside dx/dy. GameLineEditor matches: the saved dialog colours, the path and the three spilled arguments are one 48h-byte local, and 0C1h and 0C0h stay in edi and ebp across the box-colour saves. CoachCutScene matches: the palette, the path and the clip name are one 330h-byte local, and rand() % 32h stays in edx across sprintf so the fileoncd index is [edx+fileoncd+1E7h]. JoystickCalScreen is a draft (711 vs 713): the side-art call is still two calls, and sub_8E83C is stored without mov esi, eax before add esp, 8. A bank register merged that call but skipped the puck store at esp+344h (698). Do not retry an abort-first if, a side-string ternary, or a bank register used for every sub_B30B4. UpdateSeasonSchedule is a draft (672 vs 672): the opens, the database loads and the 0/1 playoff test match, but ext is in ebp and err in esi. Do not retry a copy of ext or making err a pointer. DrawRosterList matches: the name buffer and the three stride slots are one 60h-byte frame, and the scroll thumb reloads dword_D0C10 through a volatile int so the multiply stays `imul eax, [dword_D0C10]` and the divide is unsigned. POSeedRound2 is a draft (736 vs 720): the scan, both date fills and __STOSD match. Each SeriesWinner result is copied `mov edx, eax` before the home byte, so the compare is swapped. Do not retry named score bytes, one int for the remainder and the home byte, or storing that byte in the filter counter. RunEditRosters matches: the text state and the five saved colours are one 54h-byte local, the pointer header is a 17-byte struct copy, and `sub_8D2F0(songdata)` keeps the pointer in esi. DrawTradeScreen is a draft (736 vs 735): cookie 0x60, art in ebp, and the jersey colours move through al/ah. teams stays on the stack because the half-index takes edi, the cols index is doubled with `add eax,eax`, and the roster base stays in ebp. Do not retry a named teams pointer or `button = art` once the roster loop is in the function; both spill art and the cookie grows to 0x64. UpdateCoachModes is a draft (818 vs 818): the duplicated line count is `mov bh, 3` where the original is `mov cl, 3`. Do not retry a named unsigned char, a chained store, an int or short for that 3, or naming the period-2 decrement (it stores in place and drops two bytes). SetupGoalieMenu is a draft (797 vs 813): cookie 0x38 matches. The roster index is `mov al` / `and eax, 0ffh` where the original is `xor edx, edx` / `mov dl`, and the tens-digit store is sunk to the join. Do not retry a named int for that add; it pushes edi and the cookie grows to 0x3c.

* **Done:** segment map ([EXE_SEGMAP95PC.md](EXE_SEGMAP95PC.md)); byte-exact NASM build of the whole EXE from
  `src/`; naming pass over every game segment (93G/94G names or behaviour names, see SEGMENT_AGENT.md queue).
* **In progress: C matching.** Numbers are in [C_PROGRESS.md](C_PROGRESS.md) (generated by
  `tools/c_progress.py`): 611 of 1,084 compiled-C game functions match, 204 drafts do not match yet. The 109
  `__CHK` functions in library segments (cmv_player, cdstream, zonemgr, snd_gus, clib_spawn_system) are not
  counted; libraries stay asm. 13 game functions are hand-written asm (status `asm`, `tools/find_handasm.py`).
* Small helpers across front-end and engine segments are the fast path (28, 51, 33, 39, 15, 43, 17, 27, 5 (splice tooling), then 4 (Hex-Rays trial), then 1 (engine physics, puckbody), then 30 and 33 (breadth pass, 8-minute cap), then 18 (engine assignments), then 6 (multi-block tails) matched per session): one C
  file per function, Watcom CRT calls declared in `protos.h` (`_nfree`, `_dos_close`, `_dos_creat`, `strcpy`,
  `memcpy`, `strlen`, `rand`; cobj maps `name_` to the asm label), stack-argument library calls declared
  `__cdecl` (MouseSetPos, sub_8E8B8, sub_B3989, sub_8E9C0, jctime, ...). The database buffer pointers (teamsdb, keydb, ...) are typed
  `unsigned char *` in vars.h; vars.h also has small record types found this way (SpeechSlot, Button, Rect4) and `samplereq`, `statsgoaliebuf`, `rostergstat`, `falist` as
  pointers. GameOpts has `optbits12` (bits 12-14, the league option of LeagueOptsToBits).
  Empty hooks, return-constant callbacks and result setters match first try; generate them in bulk.
* Multi-block C files work: functions that jump into another function's epilogue share one C file
  (`calcpuckcross.c`, `changeplayer.c`, `EvadePlayers.c`); see C_MATCHING "Multi-block files".
* Splice tooling (cc.py / cdiff.py, 2026-10-09): a switch jump table Watcom emits in front of the function is dropped
  from the fragment and its references go to the asm's data label before the block (LeagueOptsToBits); padding plus
  the next function's jump table after a ret is no longer counted in the block (CmpSavePct, StrLenToDot,
  DbDialogHitTest); labels Func_xxx and labels the previous instruction falls into (entry points like
  sndcb_addesp8_x) stay inside the block. Blocks ending in `jmp Other_epilogue` still need a multi-block file.
* Hex-Rays reference (PRIVATE, optional): `tools/hexrays_index.py get NAME|ADDR` prints IDA's decompilation of one
  function with IDA's sub_/dword_/byte_ names replaced by our labels (needs build/obj). The input is never
  committed: in IDA with HOCKEY.EXE loaded, File > Produce file > Create C file (Ctrl+F5) writes HOCKEY.EXE.c; pass
  it with --c or HEXRAYS_C (here: /workspace/nhl95pc/HOCKEY.EXE.c). Never paste chunks of it into the repo. Trial
  (2026-10-09): it gives the structure, field offsets and branch order quickly, but drops __cdecl library call
  arguments (sub_B30B4 etc.: read them from our asm) and does not help with register allocation, which was the
  blocker for 5 of 9 functions tried (BuildTeamRosterList, ShowLoadingScreen, UpdateOtherScores, MoveToFreeAgents,
  CmpTeamStandings's shared tail). Throughput that session: 4 matched / 1.6 KB in ~45 min (~5 functions, ~2.2 KB
  per hour) vs 27 / 9.6 KB in ~45 min (~36 per hour, ~12.8 KB per hour) for the earlier 290-440 B batch without
  it - that batch had easier families and smaller functions; most of the new drafts are one register away.
  Use it as a reader for big switch/loop functions (FinishPlayoffs: the switch fall-through chain and the int
  result were clear from it), not a generator.
  Functions IDA never made (CmpTeamPK/PP, LoadShapeByTag) have no draft.
* File-merge pass (2026-10-09 evening): PlaceSpeechSlot (into ShutdownSpeech.c with ReadBE24), MenuOpenDatabase and
  DeleteSelectedDb (into LoadDbDialogShapes.c) matched; InitScrollBar + DrawScrollBar draft moved into DrawButton.c.
  New drafts in merged files: LoadSpeechSlot (n edx vs ebx), ScanDbFiles (++dblistcur[0] sunk below stores).
  Blocked merges: ReadSpeechSample / CompactSpeechSlot need OpenSpeechBank (no C yet) for OpenSpeechBank_ret;
  CompactSpeechMem jumps to FreeClip_ret in another asm file; panel drawing (006 -> DrawPanelLine in 005) is
  cross-file too (cc.py cannot splice across asm files); controls dialogs: ControlsDlgInGame continues at
  ControlsDlgInGame_side after ClearCtlBlink and ControlsDlg_ret sits inside that tail, so ControlsDlgExh/League
  need ControlsDlgInGame + ClearCtlBlink + ReassignCtlPlayer written first. Object cache: warm make ~9 s, cold
  fullcheck ~2m05s.
* Breadth pass (2026-10-09, 16:06-16:44): 30 matched in ~38 min (~47/hour, vs ~1/hour the session before) by
  taking 50-330 B functions across all segments and drafting at the first register-only diff (12 new drafts, each
  with a one-line note in c_functions.csv). Matched: CPgoalie, cleargamevars, SetSeriesTeams, UpdatePowerPlayFlags,
  CheckBump, SetScreenTitle, QueueTimeClips/RequestTimeClips, MusicChanReset, SpeechBusy, IsSampleRequested,
  OpenAnnouncerBank, ShutdownSpeech, ReadBE24, PlayCrowdSample, resetplstuff, AddPenalty, lcfound, GetLeagueId,
  PanelAddPenalty, RunDeferredCalls, GetMemStats, PrintOutlinedText, MakeTeamDbFmt, LoadScheduleDB,
  IndexPhotoBank, LoadPhotoBankF + LoadPlayerPhotos and DrawSelBoxOn + DrawSelBoxOff (two-block files).
  c_candidates.py still lists some already matched functions (forcepldata inside forceteams.c): check the csv.
* Breadth pass 2 (2026-10-09, 16:44-17:28): 33 matched in ~45 min (~44/hour), 8 new drafts (+1 old draft matched). Matched: PaGoal,
  PaPlayoffTonight, PaPenalty, PrintTextCopy, SaveScheduleDB (in LoadScheduleDB.c), FreeRinkGfx, FindTradeSlot,
  deflect, FreeClip, FileReadAt + FileWriteAt, ReadGSumHeader + ReadGSumTail + WriteGSumHeader (3-block file),
  FindRosterSlot, DitherRect, FormatHilightDesc, forcepldata, PostInjuryEvent, QueueDeferredCall, DrawBevelRect,
  DrawGadgetButton, ReadTeamNames, TakePlayerFromBox, SetScreenSize, DrawShootsField + DrawGloveField, TrackButtons,
  DrawButton, DeskPenaltySummary, DeskScoringSummary, UpdateOtherScores (old draft). Learnings:
  - cc.py now splices short (rel8) branches into another block of a multi-block file (`db (label)-($+1)`); before,
    "short branch ... leaves the block" refused shared tails reached by `jmp short` (SaveScheduleDB, FileWriteAt).
  - cc.py mark stops the block at a `db` line (hand-encoded instruction such as deflect's `sub eax,1000h`): move the
    `%endif ; C` below the function's ret by hand, then fullcheck. The C compiles to the same long-form sub, so the
    GetHot / GetHotStick notes about the db encoding are not a blocker.
  - Local declaration order changes Watcom's register choice: TakePlayerFromBox and the old draft UpdateOtherScores
    matched only by reordering locals. /tmp-style brute force (try every order of 2-5 locals of a draft, cdiff --func)
    found UpdateOtherScores; run it over the remaining register-only drafts (it is slow, ~3 s per try; use a copy of
    the repo so it does not collide with fullcheck).
  - Run fullcheck after deleting stale build/c outputs when a C file's function set changes (a stale .inc failed once).
* Breadth pass 3 (2026-10-09, 17:27-18:10): 20 matched in ~43 min (~28/hour; each fullcheck+push costs ~2 min of
  that), 7 new drafts. Matched: PaTonightIntro, ViewPlayoffHilights, WriteCurModeState, DeskReturnConfirm,
  OutputCurrentData, clearteams, PickGoalie, PuckCheckColl, AppendGSumRecord, SayPenaltyShot, SayPlayerNumber,
  SayGoal, LoadCrestsPalette, ReadGameSettings, LoadScoreboardGfx, WriteLeagueInfo, POSimSeriesTo, MergeUpdateDbs,
  plus old drafts SayPlayoffResult and SayPlayoffTonight. New drafts (one-line notes in c_functions.csv):
  SetCoachMode, checkplcoll, DrawPanelScore, ShowGoalieBanner, CopyFile, FormatPlayerName, DrawTeamGridName. Learnings:
  - Local char arrays: the first declared gets the highest stack address. The announcer Say* family matched by
    trying every declaration order of the arrays (/tmp/permarr.py idea: permute the `char x[N];` lines, cdiff
    --func; 6 arrays = 720 tries, ~15 min in the background). SayPenalty still differs after that (register).
  - Pass-through register arguments: a wrapper that hands its unseen register args on (WriteCurModeState ->
    WriteModeState) matches with void prototypes; when the callee gets a real C prototype, give the wrapper the
    same parameters (PaPenaltyShot / PaGoal now pass theirs on) and both still match.
  - Chained stores land in reverse order: `rgb[2] = rgb[1] = rgb[0] = v` stores [0] first (MergeUpdateDbs);
    `a = b = 1` stores b first (DeskReturnConfirm).
  - Loops with two steps: `for (...; i++, g += 6)` vs `g += 6, i++` picks the order of the inc / add.
  - Declaration-order brute force over the remaining drafts (2-5 scalar locals) found nothing new this session.
* Breadth pass 4 (2026-10-09, 18:10-18:40 by the box clock): 15 matched, 11 new drafts. Matched: PostGoalEvent,
  StatsSelLeague, AskMasterPassword, AskTeamPassword, SaveGridCellBg, LeagueSetHitTest, CopyLeagueFiles,
  PaPlayoffResult, DrawGadgetByType, AddDirtyRect, GameDressPlayer, checkint, MenuMergeUpdateDbs, FileDlgHitTest,
  DrawDbDialogButtons. New drafts (notes in c_functions.csv): HighlightGridCell, DrawSpriteNumber, TradeDone,
  ClockTick, ReadLeagueInfo, LocateTeamDbCopy, DrawBevelBox, PickNearestPlayer, checkgoalp, DrawLineJerseys,
  a2touchpuck (only an extra push/pop edi left). Learnings:
  - Rect tables (leaguesetrects, fdlgrects): index them through a local `struct { int x1, y1, x2, y2; }` cast; plain
    `tab[i * 4 + 2]` makes Watcom hoist the base into a register and does not match.
  - Range checks in a switch: list every case value (0Ch-0Fh); Watcom builds the same compare tree as the EXE.
  - `cond ? a : b` vs `!cond ? b : a` flips the branch order of the select (DrawGadgetByType).
  - Watcom `char` is unsigned: a byte loop counter compared with jl needs `signed char` (checkint).
  - Old-style `extern void f();` in asmfuncs.h makes calls register-convention: library stack calls (sub_913B4,
    sub_92CD0, vecdist) need a `__cdecl` prototype in protos.h first.
  - A callee returning a 16-bit value tested with `test ax, ax` needs a `(short)` cast at the call (a2offsides).
  - Spill slots of byte locals do not follow declaration order (DrawLineJerseys): do not brute-force those.
  - Skip blocks whose `X_x` / `X_ret` label is jumped to from another function (TradeHitTest_ret,
    BuildFreeAgentList_ret, OpenPlayerDBs_x, LoadShapeByTag_x, DrawEditCursor_x, MenuRebuildDbs_x, assshoot_ret,
    FadePalStep_ret): grep the label before starting.
* Tail-family pass (2026-10-09, 19:49-20:20 by the box clock, 2 fullchecks): 15 matched, 6 new drafts. Matched:
  MenuExhibitionSettings; MenuAddTeam, MenuRemoveTeam, MenuRebuildDbs, MenuUpdateTeamDbs, MenuTradePlayers,
  MenuImportDbs, MenuExportDbs (025 is one source file: MenuAddTeam.c now holds MenuAddTeam..MenuExportDbs incl. the
  old MenuMergeUpdateDbs / MenuMergeLeagueFiles / MenuNextLeagueGame / MenuLeagueHilights files, MenuLeagueSettings
  is the draft in it); DrawPanelLine, LoadGameGfx, CheckGameDiskSpace, LoadNhlCfg; StatsSel9394Playoffs,
  StatsSelLeaguePlayoffs, StatsSelPlayoffMode (StatsSel9394Playoffs.c, with StatsSelLeague moved in). New drafts:
  SimPlayoffRound1.c (Round1/2/3/Final + stubs for the Seed* functions between them; registers), LeagueSettingsDlg.c
  (5 functions all matching but Watcom merges the shared exit the other way round), FadePalStep.c (+Slow; param
  spill), CmpRosterSkaters (address operand order; needs its asmfuncs.h extern removed and an int prototype),
  DrawEditCursor (final call registers). Learnings:
  - Watcom runtime helpers __STOSD / __STOSB (block fill, eax = dest, edx = value, ecx = count) match with a local
    `void __STOSD(void *p, int v, int n); #pragma aux __STOSD "__STOSD" parm [eax] [edx] [ecx];` in the .c file.
  - Whole-segment families: a `jmp X_common` from several later functions means one original source file spanning
    them; merging already-matched neighbour files into one C file (unmark, git rm, mark the first with --end and the
    rest with --func) kept the old ones matching and matched the new ones first try.
  - Finding self-contained candidates fast: a function with no jump to another function's label (grep its body for
    `j.. Label` not starting with its own name) is the cheap kind; c_candidates' "ret" marker just means others jump
    INTO it, which is fine once the function is marked (cc keeps every label of the block).
  - cverify prints DIFF for an immediate-address fixup it shows as `!` (statspal = unk_DC340) though fullcheck
    passes; check the `!` lines before treating it as a real diff.
  - Header edits do not cost anything until the next build: edit asmfuncs.h / protos.h freely with cdiff, but only
    run fullcheck once per push (it rebuilds everything, ~15-20 min after a header change).
* Session 2026-10-09 (box clock 20:27-20:39, which lags: 5 fullchecks alone took ~11 min; ~30-35 min real): tooling (object cache, below) then 11 matched, 2 new drafts. Matched:
  LoadCalendarShapes, ReloadGameGfx (in LoadGameGfx.c), DrawExhSetChecks (MenuExhibitionSettings.c, ExhOptsToBits
  moved in), DeskTeamScratches + Desk{Home,Away}Goalie{1,2,None} (all in DeskScoringSummary.c, first try),
  MenuModeSettings. Drafts: DrawScrollBar (must go into DrawButton.c; x / y register swap), CalStandingsScreen
  (GameStandingsScreen's blocker). Fast family finder: for each candidate list the owners of the labels it jumps to;
  owners that are already matched C files in the same asm file are the cheap wins (add the function to that file).
  Remaining such pairs need big merges (061 speech: ReadBE24/ShutdownSpeech; 053 db dialogs; 006 DrawPanelLine is
  in another asm file than TickPanelPenalties / DrawEnergyBar / DrawPanelPenalties).
* `make fullcheck` (2026-10-09 evening): C objects are cached in ~/.cache/nhl95pc-cc (NHL95_CC_CACHE), keyed by sha1
  of the compiler, flags, the .c and every header it includes (tools/cc.py compile_c; NHL95_NOCACHE=1 bypasses).
  Measured: cold (after a header edit, all ~430 objects recompiled, make -j8 already parallel) 2m05; warm (only the
  changed .c files recompile) 9 s. Every C file includes nhl95.h, so a header edit is still a full cold rebuild:
  batch them. Do not compile, cdiff or edit headers while fullcheck runs (it wipes build/obj and build/c). The
  earlier "15-20 min" waits were plain serial `make` or cdiffs racing a running fullcheck, not fullcheck itself.
* asmfuncs.h cleanup: `extern void F();` entries for functions a C file defines with an int return are removed and
  replaced by real prototypes in protos.h (6 left after this session: the LeagueSettingsDlg family, CmpRosterSkaters).

## 4. Next

burst matched in checkob.c (see Current state). Next same-file tail is chk4lc (54AF9, cookie 18h, jumps to checkob_ret5, calls GetLowestPen). It is untouched. TickPanelPenalties and DrawEnergyBar jump to DrawPanelLine_x from segment 006 (DrawPanelLine is matched in 005). SpeechTimerTick jumps to ShutdownSpeech_ret5 from segment 060. Skip the known non-closed entries: menu short-jmp wrappers, SprSort, SayClip, getlinee, Readjoy2, assfaceoff, chkprogress, StartPreGame/ThreeStarsLoop. FreeRockMusic is a draft in LoadRockMusic.c (133 vs 134): the loops match, and the exit jumps to that draft's extra pop ebp. Do not retry until LoadRockMusic stops pushing ebp. Readjoy2 in Readjoy1.c rewrites the shared tail onto edx (cookie 8, short jmp) and breaks the matched Readjoy1. Do not retry an identical tail. LineEdDone is a draft in that file (280 vs 280): the jersey pointer is lea ebx where the original is lea ecx, and the scratch status byte is dl where the original is bl. Do not retry a named row or n++ inside the subscript. ScratchPlayer matched in that file: the 0x28 jersey scan stays inside the loop and the exit is MenuShowPlayerStats_status. DressPlayer matched in MenuShowPlayerStats.c: a 32-byte status buffer is the whole frame (`sub esp, 20h`), and the exit jumps to MenuShowPlayerStats_ret. ShowPlayerStatsItem matched: `(statsplayer[2] != 0x47) + 4` is `setne` / `and eax, 0FFh` / `add eax, 4`, and the return is a tail jump to DeskSetExit_ret1. This continuation capped UpdateCoachModes (818 vs 818, `mov bh, 3` vs `mov cl, 3`) and SetupGoalieMenu (797 vs 813) without a new match. This session (2026-10-13): check4bench and CheckTeamLines matched. PlacePlayersAtStart is a capped draft (535 vs 534, see Current state). RosterPanelClick is a capped draft (507 vs 507): the free-agent byte toggle folds the pointer into the index. PassLaneChk, TreeSeriesWinner and checkob are capped drafts. CompLine is a capped draft (482 vs 485, see Current state). CheckRosterComplete matched. CheckGameRosterComplete matched: an unsigned char team and an 80h buffer home the three arguments with mov inside sub esp, 94h. StarCompare is a capped draft (619 vs 653, see Current state). ErrorScreenWait matched: the mouse x and y are loaded into esi and edi before the stack copies. SaveLeagueGameRef is a capped draft (483 vs 520, see Current state). QueuePenaltyType matched. SelectFloppyDrive is a capped draft (551 vs 551, see Current state). LoadRockMusic is a capped draft (577 vs 573, see Current state). CrowdNoiseUpdate and UpdateTeamDbs matched. CanFillLineSlot is a capped draft (688 vs 669, see Current state). CountSeriesWins is a capped draft (904 vs 872, -od, see Current state). UpdatePlayoffSeries and UpdateHudPanel matched (fullcheck21). CheckLeagueDiskSync is a capped draft (598 vs 590, see Current state). PostPenaltyEvent is a capped draft (688 vs 683, see Current state). assrefpenshot is a capped draft (737 vs 740, see Current state). DrawPanelClock matched in UpdateHudPanel.c (shared exit). TrackScrollBars is a capped draft (344 vs 344, see Current state). ModeSetViewLoop is a capped draft (418 vs 418 beside MenuModeSettings, see Current state). RebuildLeagueDbs matched in UpdateTeamDbs.c. DrawFileDlgTabs matched in LoadFileDlgShapes.c. ScanSavedGames is a capped draft (568 vs 568, see Current state). DeleteSavedGame is a capped draft (623 vs 624 beside LoadFileDlgShapes, see Current state). ResetGameVars is a capped draft (654 vs 657 beside IndexPhotoBank, see Current state). MenuNewLeague matched in MenuAddTeam.c. LoadTeamRoster is a capped draft (926 vs 1041, see Current state). MenuShowPlayerStats matched (fullcheck35). CheckMasterPassword matched (fullcheck36). PlayHilight is a capped draft (559 vs 559, register chain). DrawCreatePlayer matched (fullcheck38): the CD-drive test is a ternary MakePath argument, and the position switch jumps past strcat on the default. RunMessageBox matched (fullcheck39): the sprite size is assigned to a local before sub_8CCA8. TradeShowStats matched (fullcheck40): cdiff flags the statsredrawcb store (two absolute fixups; both symbols are the original ones). LockerRoomScreen matched (fullcheck41): exhibition returns 2 through a second local. SimScheduleDay matched (fullcheck42). Next untouched closed function is ChooseLeagueController (669 bytes, src/cseg01/front/season_setup.asm). The smaller untouched functions fall into another routine or jump to a tail in another file. BlockShotDive, LoadPlayoffModeTree, a2touchpuck, ChkPullGoalieLate, DrawTradeRow, checkagr and CmpPoints are matched. SeriesLength is capped (epilogue placement). Next: the drafts and the unattempted functions already listed below. BlitClipRect (`src/c/front/lines/BlitClipRect.c`) is one register pair from matching: x is saved in esi and y in edi, and the original saves x in edi and y in esi. Five shapes were tried. Do not repeat those. QueueGoalieNote's tail still keeps 1 in esi (`mov dword [deferpending], 1` / `mov eax, 1` in the original). `-od` spills the whole frame, a ternary pushes edi, and `side - side + 1` folds back to the esi form. Do not repeat those. ChkDelayedOffside is one compare from matching (`je` to the shared `xor eax, eax` versus `jne` / `xor eax, edx`). Inverting that `if` sent every return to one exit (208 vs 192). Do not repeat that invert. SetCoachMode's away compare is still `movsx ebx, ax` against the original `cwde`; scoping the home `di` did not change it. FadeOutPalCycle still decrements `bl` in place (`mov bh, bl; dec bh` is the original). As each function matches, name the auto globals it uses (`byte_` / `word_` / `dword_`) from the same stores in its Genesis routine, with `tools/rename_symbol.py`. `icingPlayer` is the byte after `iflags`.

**Variable names (matched C only, 2026-10-12).** Source order is NHL95Genesis, then NHL94Genesis, then NHLPA93Genesis, then a name from what the PC routine does. Match a variable or a data list on the body: the same stores in a shared routine, or the same numbers even when a 68k `dc.b` list is a PC array. A 95PC routine keeps its name when the body already matches that Genesis routine. Do not sweep auto labels the matched C never reads. A table whose numbers differ (the lane table behind `word_CCA6E`, the faceoff offsets at `word_CBE8C`) stays unnamed.

Renames so far: `assfaceoffpl`, `shotdiradj`, `seed`. Team abbreviation labels use the spelling in 95PC's own team data (OTT, TB, ANA, and the rest of that table). The two New York teams keep the long names NYIslanders and NYRangers. `TeamList` is the city table, and its first string is Boston.

Variables brought over from the same instructions in `dopass` and `doshot`: the word at C90A0 is `shotplayer` (the shooter), the word at C90A2 is `lastplayer` (the carrier), and the word at C90A6 is `passspeed` (passacc*2+$A0, then the shot scale). Those three had been shifted by one slot. `apl` is the faceoff slot list (`puckfaceoff2`'s `.apl`, 24 bytes; the last two zeros still carry the unused label `dword_CBEBE`, because folding that label into `apl+22` is not valid C). `shotsetz` is the z word of each `shotsets` entry. It stays its own label: `doshot` indexes it with `nosplit`, and a folded `shotsets+2` is not a legal `nosplit` operand.

From matched C, the same way: `ltack` is the word before `lastsfx` (the check-sound toggle in `newcheck`). `pucktemp1`, `pucknopuck` and `puckasslist` are those fields of `puckstruct` (`assfaceoffpl` compares `pucktemp1` with 10h; the penalty path stores 1C20h; `ScatterPass` clears `pucknopuck`). `fofdata2` is the faceoff frame/flags table `assfaceoffpl` writes (the other side at +4). `HotList` / `HotList_y` are the hot-spot byte pair `GetHot` reads. `hmtmpde` / `awtmpde` are the team energy words, `hmtmpbox` / `awtmpbox` the penalty-box lists, `hmtmglstats` / `awtmglstats` the goalie-stats pointers. `scpflags2` is `SortCords+pflags2`. `doortemp1` and `doorpflags` are those fields of the penalty-box door (`sortobj15`). The door's byte at +46h (`byte_DFFE2`) has no field name. BlockShotDive keeps its name. `CanBlock` (`replay95.asm`) is the test. `check4check` and `check4check2` (`logic95.asm`) play `SPAblock` and lock the animation. `chkblock`, called from `holdplayer` (`control95.asm`), may replace `SPAhook` with `SPAblock`. Those play one animation in place. The dive (four SPA tables and the velocity add) has no matching body, so the locals are named from what they hold: `oldvel` is the velocity being damped, `slideface` is the word at player+4Ah, `newspd` is the signed table component, `slide2` is that facing doubled, and `absspd` / `absvel` are the absolutes compared in each damping test. `blockspd` and `blockspd_y` (were `word_CCC30` and `word_CCC32`) are the X and Y columns of those slide speeds: 0, ±0BB8h, ±1092h. The short index is the facing doubled, and the Y column keeps its own label because it is indexed with `nosplit`. The four block animations are `SPAblockslide`, `SPAblockslide2`, `SPAblockhigh`, and `SPAblocklow`, from `SPAblock`. Player+4Ah stays an offset: on the other struct `$4A` is `radiusx`, and on PC that word is also the countdown in `assgoalietopuck`.

These labels stay, because the PC body is a different thing from the Genesis routine of a similar name: `PenaltyList` (PC penalty-name strings; Genesis `Penaltylist` is a message-offset table), `hmtmstruct` (paired with `awtmstruct`; 95G has one home pointer, `tmstruct`), `ReplayPrevFrame` and `ReplayStep` (PC record-pointer helpers; 68k `suba4` / `adda4` are different), `CheckAndReleasePlayer` (not `releasepl`), `off_C5441` (nosplit label on CGY), `main_`. The 95G season, trade, and create-player screens are a different UI from the PC database editor, so those PC routines keep their behaviour names. Shared `rts` tails and 68k-only features (goalie save, replay mode, the team-screen drawers) have no matching PC body.

Numbered locals (`.0`, `.1`, and the rest) stay numbered. Branches whose meaning is already clear use `.loop`, `.next`, `.done`, `.d0`, and the same kind of name. Genesis locals do not line up with the PC branch order, and the remaining numbered labels are short jumps.

Every asm file starts with a short plain-English header (engine, season, front end, data, Watcom and EA libraries). Comments no longer carry origin tags (`93G`, `94G`, `95G`), `;IDA:` notes, "PC only", "PC-new", Genesis ROM addresses, or "aligned N/M accesses" counts. Instruction lines still end with the required `; <address>` suffix.

A few comments still say `PC:` where that describes behaviour (the referee's own animations, a check that exists on PC). `puckvy high byte (d1)` keeps the register after the 68k citation was removed. Some multi-line C comments were collapsed onto one line. "New in 95" was left off the file headers; the season, trade, and create-player introductions already say what those screens do.

* Last session (+34): OpenSpeechBank.c now holds ReadSpeechSample/MoveSampleMem/CompactSpeechSlot (matched;
  OpenSpeechBank itself a draft: header-word stack slots); DrawDbList matched in LoadDbDialogShapes.c (DrawDbDialog
  draft: ybar add order); ControlsDlg group drafted in MenuP1ControlsInGame.c (ControlsDlgInGame is SPLIT in the
  EXE, its tail comes after ReassignCtlPlayer/ClearCtlBlink; cc.py cannot splice a split function yet), MenuSaveDbsAs
  draft. Tail-call wrappers are the fast path: `return F(x);` as the last statement compiles to `jmp F`, and a
  wrapper right before F falls through. Put each wrapper run in the file of the function before/after it and mark
  with `--end` (SayNhlIntro.c 10 wrappers, Pa* in PaTonightIntro.c, MenuRegSeasonStats/MenuPlayoffStats share a
  backward tail in CmpRosterGoalies.c, FileOpenRead/Write/RW). Remaining tiny ones blocked: DeskSetExit2/3 (forward
  jump into the next function's tail; drafts in DeskSetExit2.c), StubRet4b (__CHK 10h with no locals), ReadKeyRec /
  ReadSeasonRec / ReadDbRec / WriteSeasonRec (jump into another's `_x` label across C files), EnsureSampleRoom /
  CompactSpeechMem (tail in the announcer asm file), LoadBothRosterLists (falls into draft LoadRosterList).
  List unmatched __CHK functions by size with the snippet in this session's log (labels not in C_PROGRESS.md).
* Wrapper sweep 2 (+41; Season/Career/AttDbPtr(2) in KeyDbPtr.c the same way; MenuCallbackTrue2 = identical function: Watcom turns it into a jump into MenuCallbackTrue by itself): WriteSeasonRec.c (10 league/db record wrappers), ReadKeyRec.c (Read/WriteKeyRec,
  ReadSeasonRec; CopyFile draft: one argument shuffle), ReadTeamRec.c (ReadTeamRec returns FileReadAt's eax with
  no return statement: W107, the only way the registers match), SelectScreenBM.c, CalLeftJoystick.c, DoGameFrame,
  sub_7E03F, SndLoadFile2, TextPrintf/TextPrintf2, PrintFmt1/PrintFmt2, PaPenaltyShot, CmpInt, ApplyShapePalette,
  IntermissionStart (`if (x) { F(); return; }` gives `je near F`). The thin-wrapper queue is now empty except the
  blocked ones below.
* A function called through `...` (varargs prototype) saves no registers in the caller: JoystickCalScreen is
  `int JoystickCalScreen(int a, ...)`; sprintf calls keep edx etc. live across them.
* FORWARD jumps into a later function's code (blocker family): DeskSetExit2 -> DeskSetExit3's tail is now
  MATCHED by defining DeskSetExit3 first in the C file and marking each function with `--func` (cc.py places the
  blocks in address order and rewrites the jump; short jumps into a marked block's label work). Watcom merges an
  identical tail into code it generated earlier in the file AND into later code, so the holder depends on source order.
  SOLVED for the desk items: DeskGoToReplay.c now holds the whole run DeskGoToReplay..DeskAwayGoalieNone
  (DeskPenaltySummary.c and DeskScoringSummary.c merged in, one `--end` block to the segment end): with every
  function of the run in one file in address order, Watcom itself emits the forward jumps into DeskItem_ret2.
  Rule: when functions jump forward into a later function's tail, put the whole contiguous run in one file.
  ControlsDlgInGame -> ControlsDlgInGame_side (the code after ClearCtlBlink that also holds ControlsDlg_ret*, used
  by ClearCtlBlink, DrawControlsDlg and others: probably ControlsDlgInGame defined after them in the source);
  LoadRosterList (body continues after EditTeamLines); ThreeStarsLoop -> PreGameIntro_end; SetFullPalette ->
  HandleHotKey_ret; POHiliteSlot -> POCreateSchedule_x.
* cc.py now supports a file across a segment split: `cc.py mark File.c --func F --seg NEXT_STEM` marks F in another
  asm file (block lookup searches all asm files; the Makefile makes each object depend on the .inc files its own asm
  includes). `c_paths` also finds an unmarked label in another asm, so `cdiff --func` works before the mark.
  DeskSetExit3b / ShowPlayerStatsItem (palette_fx, jumping into DeskSetExit3 in output_files) still miss when
  compiled next to DeskSetExit3: their jumps are short, while the EXE has near jumps. LoadClipSlot is the first
  marked block that uses it (announcer segment, tail in ShutdownSpeech).
* Still open: OpenSpeechBank, DrawDbDialog/DbDialogLoop, ControlsDlg split, cross-asm-file tails.

Use the prompt in [PROMPT.md](PROMPT.md) for each session, with the rules in SEGMENT_AGENT.md.

**Picking the next function:**
0. Keep the breadth pass going (it gave ~47/hour): `python3 tools/c_candidates.py 100 330` across all segments,
   8-minute cap, draft at the first register-only diff. Not tried yet: MakeStatsTitle, POHiliteSlot, MoveSampleMem (far pointers),
   POSeedFinal, OpenSelectedDb, the SimPlayoff / LeagueSettingsDlg / FadePalStep drafts (logic done),
   CompactSpeechSlot (-> OpenSpeechBank_ret: one 061 file), ThreeStarsLoop (jumps into PreGameIntro: skip),
   MakeStatsTitle (needs LoadShapeByTag 1FDFE in the same file; no Hex-Rays function there),
   DrawCtlBoxOn/Off (jump forward into ControlsDlg_ret: one file DrawCtlBoxOn..ControlsDlgInGame),
   SeriesWinner (-> POCreateSchedule_x), SetFullPalette (-> HandleHotKey_ret), FreeDeskBuffers (-> StatsSel_x),
   checkob, Stop4Pen's neighbours in 045 (checkfornewpen draft), check4bench (52BB6, 600 B, `xor eax,edx` zero return),
   asscentero (ass_popx shared tail), assintroline, asspenalty (ass_popx),  checkfornewpen, POPickConfTeams, InitGameSummary, DrawLineGroupBars, FadePalette (memset becomes
   __STOSB there), DeskGameStats / DeskTeamScratches / DeskVisitorLines / DeskHomeLines (end in DeskSummary_common / DeskItem_ret2 of DeskScoringSummary.c; tried DeskGameStats there: Watcom emits a
   short jmp to the shared tail where the EXE has a near one (+3 bytes), so these stay asm unless that is solved), Many 150-250 B ones end in `jmp Other_ret`
   (TickPanelPenalties / DrawEnergyBar -> DrawPanelLine_x, LoadSpeechSlot -> ReadBE24_ret, DressPlayer,
   FreeLeagueDbsMem): they need the owner's file. Brute-force local order on register-only drafts (see above); DrawCtlBoxOn/Off need ControlsDlg's file (they end in jmp ControlsDlg_ret).
1. Throughput first: `python3 tools/c_candidates.py 300 800` with Hex-Rays drafts for structure; families with one
   shape (Load*Shapes matched first try). Then 400-470 (barely started: DrawGameLineJerseys is a close draft,
   see its note; ModeSetViewLoop / LeagueSetViewLoop end in jmp ModeSettings_epilogue, so they need ModeSettings in
   the same multi-block file). Re-run try.sh on all drafts after any tool change (290-400 is mostly done; its leftovers are shared
   tails, ebp-frame debug code like TreeSeriesWinner / LoadLeagueTree, and the drafts below). Families first: the
   *OptsToBits, Cmp* (statsgoaliebuf / rostergstat records), Load*Pals / LoadLeagueDbsMem / Say* templates all
   matched first try. Candidates: DrawLineJerseys / DrawGameLineJerseys, MoveToFreeAgents, DrawPanel3D, BlitTileMap,
   SayPenalty-style announcer drafts (stack slot order), CmpRosterSkaters (CmpPoints shape, rosterpstat 28h records).
   The <= 150 byte leftovers are the hard ones: ebp frames
   (ShowPlayoffTree, OpenStatsSchedule, MoveTreeHighlight; default flags do not produce them), shared tails, or
   code-segment initializer data (OpenSelectedDb copies unk13_722FE, which sits after InputDialog).
   Skip blocks that contain a second global label
   (another function jumps into them, e.g. ReadKeyRec_x, sndcb_addesp8_x) or data after the ret; skip
   `ret N` callbacks and printf-style stack calls for now.
2. Skip rows with status `asm` in `tools/c_functions.csv`; skip functions without the `push dword N / call __CHK`
   prologue.
3. Small leaf functions first. A function that jumps into another's epilogue goes into that function's C file
   (in engine_core: `calcpuckcross.c`; still to add there: updateanim (5CAEF, ~180 lines, needs the byte field
   at 46h named), SetPlList, clockcont_0, Goal, updateplayers; `changeplayer.c` holds changeplayer (draft) and
   is where setplayer (5B2C5) and DrawRinkOverlays (both jump to `changeplayer_ret5`) go, in address order).
4. At most ~10 minutes per stubborn function, no brute-forcing declaration orders: leave the draft (unmarked), put the reason in the notes column of
   `tools/c_functions.csv`, move on.

**Last session (engine physics, 2026-10-09):** puckbody matched (~1.7 functions / hour; most time went into
two register-pressure drafts). New fields: Player Zvel (10h); Team tmfowon, tmfowonoz, tmpsplayer, tmast1, tmast2
(12h/14h/30h/33h/35h, evidence in struct_fieldmap.csv). Learnings: a local reused for two values that the asm keeps in
one register (puckbody: frame, then the old Xvel, both dx) is one C variable; `p->pflags |= 0x20` after an
explicit test gives the `mov dl,[x] / test / mov dh,dl / or dh` pair, a `flags` local does not. Drafts puckglue and
wallcollb share an unsolved crowdlevel clamp shape (asm keeps the old level in ax/dx and the raised one in bx/cx; C
merges them) - solve it once and both may follow. easn_stats (Game/Cal/Easn*StatsScreen) is one shared-tail family
(GameTeamStatsScreen_common, CalTeamStatsScreen_common): needs a multi-block file.

**Gotchas from the latest batch:** most small unattempted functions left end in a jump into a NEIGHBOUR's
epilogue (`jmp X_ret` / `X_x` / `X_common`): put them in one C file with that neighbour in address order and
Watcom reproduces the cross-jump by itself (PrintMenuText/Grey/Alt; DrawMenuDropdown + DrawMenuBox, marked as one
block with `--end`; EncryptPassword appended to AskTeamPassword.c with AskMasterPassword moved in: `cc.py unmark`
the old file, `git rm` it, `mark --func` each). cverify reports DIFF for the FIRST function of a --func multi-block
file even when the build is identical (DrawSelBoxOn shows the same) - trust `make fullcheck`. Editing a shared
header (protos.h / asmfuncs.h) recompiles all C: ~17 min in DOSBox, so batch header edits. The local-pointer retry
over all drafts found no further fixes (scan: cdiff lines with `add reg, SortCords/hmtmstruct`; the 8 hits are other
issues).

**Gotchas from the last batch:** an element of a global struct array (SortCords[n], puckstruct) read through a
`Player *o = &SortCords[n]` local gives the EXE's `add eax,SortCords / [eax+44h]`; indexing the array directly folds
the base into the displacement (fixed Stop4Pen and assscore - retry other drafts with that diff). A value the EXE
keeps in one register across unrelated uses is one C variable (asspenshooter: y, the turn and the pass direction all
in ecx). A `x ? a : b` whose EXE tests the flag with `jne` wants the condition negated (`!(f & 40h) ? b : a`). A
branch the EXE jumps over to the end (`je .17` to the temp1 == 100 block) is `if (!c) { body } else { tail }`.

**Gotchas from the batch before last:** a top-tested loop (`cmp` at the top, `jmp` back at the bottom) is
`for (;;) { if (!cond) break; ... }`; a plain for/while rotates the test (InitFileLocations). Watcom's stack slot
order is not plain declaration order: read which slot each local got from the diff and move one declaration at a time
(ImportDbs took 3 tries; stop there if it does not converge). Address-immediate-only diffs (`mov [g], offset`) are
fixups: check the rest and mark by hand with `cc.py mark` (DeskExitGame, ImportDbs). A 68k-style re-read of a value
just stored needs the chained form `a = b = 0` (SetupPenaltyShot puck reset).

**Gotchas from the batch before:** a global typed as a pointer in vars.h loads into a register then `add eax,edx` (int gives `add eax,[mem]`; fixed CmpGoals); a pointer-typed global is the fix for that pattern. Dropping a short local can fix CSE registers (ShotMode). `((int (*)[3])tbl)[i][g]` gives a shared i*12 index (ChkGoalies). A `b = x; x = b & 0xF` byte copy gives a bl/bh pair; write `x &= 0xF` instead (CtlSwapScoreFix).

**Known stuck drafts and hypotheses** (full notes in `tools/c_functions.csv`):

| function | file | off by | hypothesis |
|---|---|---|---|
| LeagueOptsToBits, CmpSavePct | own files | block layout | code matches; jump table before the label / data after the ret (needs splice support) |
| PostGameDesk | PostGameDesk.c | 2 copies | asm copies results to edx (mov edx,eax) before testing |
| SayPlayoffResult, SayPlayoffTonight | own files | stack slots | only the 16-byte buffers' slots differ |
| PickOtherGames, SelectSavedFile, SelectMatchingPlayers | own files | 1-2 registers | see csv notes |
| SplitPlayerName, DrawTeamGrid, LoadJerseyColours, SetupPenaltyShot, SayPenalty | own files | registers / frame | see csv notes |
| ChkGoalies | ChkGoalies.c | 1 register | other-team pointer in edx (C) vs esi |
| assepen | assepen.c | multiply | shift-multiply by 11 vs imul; try the `byte &=` form that fixed CtlSwapScoreFix |
| CtlSwapScoreFix | CtlSwapScoreFix.c | 1 register | puck-team byte in ch (asm) vs bl |
| SetRosterTeamMenus | SetRosterTeamMenus.c | ebx save | asm recomputes d*7 per loop, C hoists it into ebx |
| periodicevents / asscenterd / assbenchside | own files | 1 register | al/bl; ax/edx; di/ax |
| EvadePlayers | EvadePlayers.c | one stack dword | needs a spill for the vtoa args while ebp is busy; try a different temp structure |
| skateto | EvadePlayers.c | 1 register | pucky pointer / Xvel\|Yvel in eax vs edx; maybe expression order |
| calcpuckcross | calcpuckcross.c | 2 bytes | x/side registers swapped, 16-bit `mov bx,dx`; maybe x is computed into a short temp |
| GetHot | calcpuckcross.c | 1 register | original negates through a fresh esi; maybe a second local for the flipped x |
| StartPer | calcpuckcross.c | 3 bytes | original keeps cont1team/cont2team in si/bx and reuses ebx/ecx for -1/0 |
| GiveControl | GiveControl.c | 3 bytes | regd1 reloaded into cx on one path, si on the other |
| ResetClock | ResetClock.c | 2 bytes | zero kept in edx; maybe other prototypes (randomd0/GetPeriodTime types) in the original file |
| TryAddPlayerToList | TryAddPlayerToList.c | registers | &tmpdst[pl] in edx instead of eax |
| updatecrowdf | updatecrowdf.c | 2 bytes | randomd0 result widened with `movsx edx,ax` instead of cwde |
| DateKey, SimAddPair, TextGridPut, POSetSeriesTeams, TryBlockShot | own files | registers only | see csv notes; one parameter / temp in a different register |
| PaPenaltyShot, RandLfsrByte, CheckAndReleasePlayer | own files | registers / byte ops | see csv notes |
| asspenshooter | asspenshooter.c | 1 register | puckc pointer in edx (EXE) vs eax; all else matches |
| PenShotAssign | PenShotAssign.c | loop register | loop index in esi (C) vs ecx; logic complete |
| GameStandingsScreen, PruneGameLines, DrawPhotoWithPal, MenuSoundSettings, SteerToTarget, checkfornewpen, assgoalietopuck, ass_pc_slot20, BuildLeagueList | own files | registers | see file header notes |
| StopDigiSample, FreeDigiSample | own files | 1 register | original passes digihandle through edx/ebx; maybe sub_8F80E's prototype |
| SndLoadFile | SndLoadFile.c | block end | C is right; the asm block ends at sndcb_addesp8_x (shared tail) |
| StrLenToDot | StrLenToDot.c | size | original block runs past the ret; check the label end |
| CountSelected, StrEqNoCase, FindFreeSpeechSlot, FindLoadedSpeechSlot, PenaltyLenClip, GrowToButton, chkatop | own files | registers only | see csv notes |
| ClearPanelPenalties, joyq_pop, AnyInputPressed | own files | registers only | asm saves more regs / keeps the result in esi; see csv notes |
| getlchoice, FreeUnrequestedSamples, DrawRosterTitle, AskDatabaseChoice, puckIChk, SetShotMode, WaitLeagueFloppy | own files | registers only | see csv notes |
| SetGameSides, CupSeriesWinner | own files | registers only | see csv notes |
| InitMenuRemap | InitMenuRemap.c | call target | asm calls __STOSB for a 15h-byte clear; plain memset calls memset_ |
| DbDialogHitTest | DbDialogHitTest.c | block end | jump table data sits after the ret |
| QueueGoalieNote, faceoffinput, FadeOutPalCycle | own files | registers / tail | see csv notes (1 in esi kept; al vs cl; bl/bh) |
| RunGameFrames, QuickShotChk, sfx, ChkTwoLinePass, SetTeamGoalie, OneTimerChk | own files | registers only | asm keeps a value in an extra saved register (sounddev in ecx, facedir in bx/si, lasttouch in si); see csv notes |
| LoadCupFinalSeries | LoadCupFinalSeries.c | 3 bytes | `db += 2` on the stack local compiles to `add [esp],2`; asm does load/add/store |
| CmpShootPct | CmpShootPct.c | addressing | CmpGoals, CmpAssists, CmpPlusMinus and CmpPoints match. CmpShootPct is the one still open in that family |
| changeplayer | changeplayer.c | registers only | same 370 bytes; cont spilled at [esp+8] not [esp+4], counter in ecx not edx; local declaration order has no effect (all 120 tried) |
| puckglue, wallcollb | own files | registers | crowdlevel clamp temps merged by C; puckglue also loads puckc before the regd0 byte; see csv notes |

Player fields named this session (src/inc/structs.inc + tools/struct_fieldmap.csv, evidence in both): nopuck (3Eh),
passlane (53h, PC-new) and the 94G rating block aioff, aidef, shotspd, shotacc, passacc, rostnum, spodds,
stickhand, aggress, checking, handed (59h-65h) at 94G equals offset - 11h, the same shift as weight..endurance;
63h is still unnamed. They unblocked SkillForAnim and ScatterPass.
Player fields Zpos (08h), attrlo (54h, low byte of the 94G attribute word; `ATTRWORD(p)` in consts.h),
radiusx / radiusy (66h / 68h) were added for defaultsprites2 (matched). Not started for lack of struct fields:
clearteams needs Team fields at 2Eh, DEh, E2h, F2h.

