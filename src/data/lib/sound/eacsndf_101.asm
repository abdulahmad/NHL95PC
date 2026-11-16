; The EACSNDF sound library.
bits 32
%include "hockey.inc"
section s_F23BC nobits alloc noexec write align=1
global MidiChannelUsed, MusicBankHeader, MusicBankPatchNum, MusicBankTimbreCount, MusicBankTimbreNums, SndHandleType, __HeapFlags, __nheap_clean
global MusicPatchFile, MusicTimbreFiles, MusicTimbreSizes, AtexitRoutines, AtexitTable, SpeechBankCount, __ClosedStreams, delaycount
global _doserrno, ErrnoVar
MidiChannelUsed:                                ; One byte per MIDI channel: set while the channel is taken;
                                                ; used by FindFreeMidiChannel, SndClearTables
        resb 16
MusicBankHeader:                                ; Music bank header read from the bank file (type byte first);
                                                ; used by FreeMusicBank, LoadMusicBank
        resb 1
MusicBankPatchNum:                              ; Patch file number from the music bank header; used by
                                                ; LoadMusicBank
        resb 2
MusicBankTimbreCount:                           ; Timbre file count from the music bank header; used by
                                                ; FreeMusicBank, LoadMusicBank
        resb 17
MusicBankTimbreNums:                            ; Timbre file numbers from the music bank header; used by
                                                ; LoadMusicBank
        resb 10
MusicPatchFile:                                 ; Loaded patch file of the music bank; used by FreeMusicBank,
                                                ; LoadMusicBank
        resb 4
MusicTimbreFiles:                               ; Loaded timbre files of the music bank; used by
                                                ; FreeMusicBank, LoadMusicBank
        resb 40
MusicTimbreSizes:                               ; Size of each loaded timbre file; used by FreeMusicBank,
                                                ; LoadMusicBank
        resb 38
AtexitRoutines:                                 ; Exit routine table walked by _Full_at_exit_rtn_; used by
                                                ; _Full_at_exit_rtn_
        resb 2
SndHandleType:                                  ; driver type per open sound handle (1 music, 3 MIDI port, 4
                                                ; digital, 5 speaker); used by LinkPatchTimbres, SndOpenDriver
        resb 2
AtexitTable:                                    ; used by atexit_
        resb 128
SpeechBankCount:                                ; used by _Full_at_exit_rtn_, atexit_
        resb 4
__HeapFlags:                                    ; Heap manager flags; used by __HeapManager_expand_
        resb 1
__nheap_clean:                                  ; Near heap clean flag; used by _nfree_, _nmalloc_
        resb 3
__ClosedStreams:                                ; List of closed stdio streams; used by __InitFiles_,
                                                ; __allocfp_, __flushall_ ...
        resb 4
delaycount:                                     ; Watcom delay(): loops per millisecond counted by
                                                ; __delay_init_, used by __delay_
        resb 4
_doserrno:                                      ; DOS error number; used by __get_doserrno_ptr_
        resb 4
ErrnoVar:                                       ; C library errno; used by ErrnoPtr
        resb 4
