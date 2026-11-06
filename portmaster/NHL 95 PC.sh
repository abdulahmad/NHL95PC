#!/bin/bash
# PortMaster launcher for NHL '95 PC on Overbar (SDL_Renderer / KMSDRM).
# User-supplied install + CD files. Never ships HOCKEY.EXE or the CD.

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source "$controlfolder/control.txt"
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/nhl95pc"
CONFDIR="$GAMEDIR/conf"
BIN="nhl95pc.${DEVICE_ARCH}"

mkdir -p "$CONFDIR" "$GAMEDIR/gamedata" "$GAMEDIR/cd"
cd "$GAMEDIR" || exit 1

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

export XDG_DATA_HOME="$CONFDIR"
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export OVERBAR_HANDHELD=1
export PORTMASTER=1
export NHL95_NOGL=1
export NHL95_ROOT="$GAMEDIR/gamedata"
export NHL95_CD="$GAMEDIR/cd"

if [ ! -f "$GAMEDIR/gamedata/HOCKEY.EXE" ] && [ ! -f "$GAMEDIR/gamedata/hockey.exe" ]; then
  pm_message "Copy your NHL 95 install into gamedata/ and the CD files into cd/."
  pm_finish
  exit 1
fi

if [ ! -x "$GAMEDIR/$BIN" ]; then
  pm_message "Missing $BIN. This zip is the PortMaster layout; the aarch64 native binary is a later build."
  pm_finish
  exit 1
fi

# Desk: d-pad as mouse, A click. Select+Start quits. In-play joystick is a later native HAL.
$GPTOKEYB "$BIN" -c "$GAMEDIR/nhl95pc.gptk" &
pm_platform_helper "$GAMEDIR/$BIN"
./"$BIN"
pm_finish
