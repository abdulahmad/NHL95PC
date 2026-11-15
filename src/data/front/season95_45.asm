; The Play-Off mode menu: settings, controllers, the next game, and the highlights.
bits 32
%include "hockey.inc"
section s_CF90F progbits alloc noexec write align=1
extern MenuPlayoffSettings, MenuP1ControlsPlayoff, MenuP2ControlsPlayoff, MenuPlayNextGame, MenuReturnToSportsCentral, unk_C67B1, str_Dashes2, str_Player1Controls2
extern str_Player2Controls2, str_PlayOffSettings2, str_File2, str_Settings4, str_Statistics5, str_PlayNextGame, str_ReturnToSportsCentral2, str_StatisticsType8
global off_CF983, playoffmenubar, unk_CF96F, unk_CF9AF, unk_CFA2F
playoffmenubar:
db 00h,00h,00h,00h,00h,00h,00h,00h,020h,00h,00h,00h,012h,00h,00h,00h
dd str_File2
db 00h,00h,00h,00h
dd unk_CF96F
db 02h,00h,00h,00h,021h,00h,00h,00h,00h,00h,00h,00h,05Eh,00h,00h,00h
db 012h,00h,00h,00h
dd str_Settings4
db 00h,00h,00h,00h
dd unk_CF9AF
db 04h,00h,00h,00h,05Fh,00h,00h,00h,00h,00h,00h,00h,0A4h,00h,00h,00h
db 012h,00h,00h,00h
dd str_Statistics5
db 00h,00h,00h,00h
dd unk_CFA2F
db 05h,00h,00h,00h
unk_CF96F:
db 00h,00h,00h,00h,00h,00h,00h,00h,0A9h,00h,00h,00h,011h,00h,00h,00h
dd str_PlayNextGame
off_CF983:
dd MenuPlayNextGame
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 0A9h,00h,00h,00h,024h,00h,00h,00h
dd str_ReturnToSportsCentral2
dd MenuReturnToSportsCentral
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CF9AF:
db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
dd str_Player1Controls2
dd MenuP1ControlsPlayoff
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,012h,00h,00h,00h
db 08Ch,00h,00h,00h,023h,00h,00h,00h
dd str_Player2Controls2
dd MenuP2ControlsPlayoff
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,024h,00h,00h,00h
db 08Ch,00h,00h,00h,035h,00h,00h,00h
dd str_Dashes2
db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
db 036h,00h,00h,00h,08Ch,00h,00h,00h,048h,00h,00h,00h
dd str_PlayOffSettings2
dd MenuPlayoffSettings
db 00h,00h,00h,00h,00h,00h,00h,00h
unk_CFA2F:
db 00h,00h,00h,00h,00h,00h,00h,00h,08Ch,00h,00h,00h,011h,00h,00h,00h
dd str_StatisticsType8
db 00h,00h,00h,00h
dd unk_C67B1
