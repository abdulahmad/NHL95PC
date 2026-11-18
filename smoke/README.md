# Smoke test hashes

The frame hashes the smoke run (`tools/smoke/run.sh` in Overbar, see the smoke-test plan) expects. They are the hash of the picture for each
screen that does not depend on timing; no pictures are stored. Recorded 2026-11-18 on a Windows build of this port's `main`.

    EXPECT=smoke/hashes-boot.txt sh port/overbar/tools/smoke/run.sh <port> <exe> <copy of the game folder> 60 boot

They depend on the game data copy and on how Overbar draws the picture (`NHL<port>_NOGL=1`, overlay closed). A mismatch after an Overbar look change is a
warning (record again with `RECORD=`, two or three runs); a mismatch after a disassembly change means the game's output changed.
