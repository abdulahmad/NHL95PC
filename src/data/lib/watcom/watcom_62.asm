; Watcom runtime data.
bits 32
%include "hockey.inc"
section s_D4D0F progbits alloc noexec write align=1
extern __ClosedStreams, DefaultFpeHandler, str_EACSNDFLIBJul28
global _osmajor, _osminor, __iob_flags, SavedTextMode, SavedTextPage, SavedTextRows, VesaBankShift, SeqQueueCount
global SeqTickCount, SeqServiceBusy, FpeHandler, _fmode, PrintfSavedEbx, PrintfSavedEcx, PrintfSavedEdx, PrintfSavedEsi
global PrintfSavedEdi, PrintfSavedReturn, VesaBank, VesaWindowGranularity, SeqQueueHead, sndhandlecount, SongReleasedFlag, MidiSfxEnabled
global MidiMusicEnabled, __iob, __stdout_buf, PerrorSeparator, __iob_end, __NFiles, SavedTextColumns, MidiChannelBits
global ActiveSongCount
_osmajor:                                       ; Watcom cstart: DOS major version; used by __saved_DS,
                                                ; __set_errno_dos_, spawnve_
        db 00h
_osminor:                                       ; Watcom cstart: DOS minor version; used by __saved_DS
        db 00h
FpeHandler:                                     ; Floating point exception handler; used by CallFpeHandler,
                                                ; RaiseFpuError
        dd DefaultFpeHandler
        db 00h,00h,00h
__iob:                                          ; Stdio stream table; used by __InitFiles_, __allocfp_,
                                                ; docloseall_
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,01h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
__stdout_buf:                                   ; Stdout buffer; used by printf_
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,00h,00h,00h
        db 01h,00h,00h,00h,00h,00h,00h,00h,00h,00h
PerrorSeparator:                                ; ": " separator printed by perror; used by perror_
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h
__iob_flags:                                    ; Stdio stream flags; used by __InitFiles_
        db 00h,00h,00h,02h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,03h,00h,00h,00h,03h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,02h,00h,00h,00h,04h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h
__iob_end:                                      ; End of the stdio stream table; used by docloseall_
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
        db 00h,00h,00h,00h,00h,00h
__NFiles:                                       ; Number of stdio streams; used by __allocfp_
        db 061h
_fmode:                                         ; Default file translation mode; used by __open_flags_, sopen_
        db 00h,01h,00h,00h
        dd __ClosedStreams
        db 00h,00h,00h
PrintfSavedEbx:                                 ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
PrintfSavedEcx:                                 ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
PrintfSavedEdx:                                 ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
PrintfSavedEsi:                                 ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
PrintfSavedEdi:                                 ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
PrintfSavedReturn:                              ; used by PrintfSaveRegs, SprintfSaveRegs
        db 00h,00h,00h,00h
SavedTextMode:                                  ; used by RestoreTextMode, SaveTextMode
        db 00h
SavedTextPage:                                  ; used by RestoreTextMode, SaveTextMode
        db 00h
SavedTextColumns:                               ; used by RestoreTextMode, SaveTextMode
        db 00h,00h
SavedTextRows:                                  ; used by RestoreTextMode, SaveTextMode
        db 00h,00h,00h,00h
VesaBank:                                       ; Current VESA bank; used by VesaSetBank, initgraphics
        db 00h,00h,00h,00h
VesaWindowGranularity:                          ; VESA window granularity used by the bank switcher
        db 00h,00h,00h,00h
VesaBankShift:                                  ; used by AndPixel, OrPixel, PlotPixel ...
        db 00h,00h,00h,00h
SeqQueueHead:                                   ; Sequencer command queue head; used by SeqFlushQueue,
                                                ; SeqQueueCommand
        db 00h,00h,00h,00h
SeqQueueCount:                                  ; Commands waiting in the sequencer queue; used by
                                                ; SeqFlushQueue, SeqQueueCommand
        db 00h
SeqTickCount:                                   ; Sequencer tick counter; used by SeqUpdate
        db 00h
SeqServiceBusy:                                 ; Set while the sequencer service runs; used by SeqService
        db 00h,00h
        dd str_EACSNDFLIBJul28
sndhandlecount:                                 ; EA sound library: number of sound handles; the handle calls
                                                ; return -1 for a handle at or above it; used by
                                                ; LinkPatchTimbres, MidiNoteOff, MidiNoteOn ...
        db 00h,00h,00h,00h
MidiChannelBits:                                ; Bit for each MIDI channel; used by FindFreeMidiChannel
        db 01h,00h,02h,00h,04h,00h,08h,00h,010h,00h,020h,00h,040h,00h,080h,00h
        db 00h,01h,00h,02h,00h,04h,00h,08h,00h,010h,00h,020h,00h,040h,00h,080h
ActiveSongCount:                                ; Songs or voices in use; used by LinkPatchTimbres,
                                                ; ReleaseAllVoices, ReleaseSong ...
        db 00h,00h
SongReleasedFlag:                               ; Set when a song has been released; used by SeqUpdate,
                                                ; SongReleased
        db 00h,00h,00h,00h
MidiSfxEnabled:                                 ; MIDI sound effects on; used by DisableMidiSfx,
                                                ; EnableMidiSfx, PlayPatch ...
        db 01h,00h,00h,00h
MidiMusicEnabled:                               ; MIDI music on; used by DisableMidiMusic, EnableMidiMusic,
                                                ; SeqStepTrack
        db 01h,00h,00h,00h
