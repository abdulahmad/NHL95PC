#!/bin/bash
# PortMaster launcher for NHL 95 PC on Overbar (SDL_Renderer / KMSDRM).
# This is a PortMaster zip. Comments and example paths are Knulli-optimized;
# $directory / $controlfolder come from control.txt (do not hard-code Knulli).
# User copies the DOS install + CD files. Never ships HOCKEY.EXE or the CD.
# Layout-only until nhl95pc.aarch64 exists: the desktop trap host is i386
# (gcc -m32) and cannot be renamed .aarch64.

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

# Knulli: $directory is userdata/roms → /userdata/roms/ports/nhl95pc
# muOS / ROCKNIX: same pattern, their own $directory.
GAMEDIR="/$directory/ports/nhl95pc"
CONFDIR="$GAMEDIR/conf"
BIN="nhl95pc.${DEVICE_ARCH}"

mkdir -p "$CONFDIR" "$GAMEDIR/gamedata" "$GAMEDIR/cd"
cd "$GAMEDIR" || exit 1

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

export XDG_DATA_HOME="$CONFDIR"
export XDG_CONFIG_HOME="$CONFDIR"
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export OVERBAR_HANDHELD=1
export PORTMASTER=1
export NHL95_NOGL=1
export NHL95_ROOT="$GAMEDIR/gamedata"
export NHL95_CD="$GAMEDIR/cd"
export NHL95_INI="$CONFDIR/hockey95.ini"
export BLASTER="${BLASTER:-A220 I7 D1 T3}"
# NHL95_NOJOY stays unset. Overlay Online page stays listed (no hide).

if [ ! -f "$GAMEDIR/gamedata/HOCKEY.EXE" ] && [ ! -f "$GAMEDIR/gamedata/hockey.exe" ]; then
  pm_message "Copy your NHL 95 install into gamedata/ (HOCKEY.EXE, NHL.CFG) and the CD files into cd/."
  pm_finish
  exit 1
fi

if [ ! -f "$GAMEDIR/gamedata/NHL.CFG" ] && [ ! -f "$GAMEDIR/gamedata/nhl.cfg" ]; then
  pm_message "gamedata/NHL.CFG is missing. Copy it from your NHL 95 install."
  pm_finish
  exit 1
fi

EXE="$GAMEDIR/gamedata/HOCKEY.EXE"
[ -f "$EXE" ] || EXE="$GAMEDIR/gamedata/hockey.exe"
EXESZ=$(wc -c < "$EXE" | tr -d ' ')
if [ "$EXESZ" != "1179067" ]; then
  echo "warning: HOCKEY.EXE is $EXESZ bytes; retail NHL 95 PC is 1179067 (SHA-1 3961e0eba6b0338fad1613bb534efafd9406ed4a)"
fi

if [ ! -f "$GAMEDIR/cd/ALLFILES.TXT" ] && [ ! -f "$GAMEDIR/cd/allfiles.txt" ] \
   && [ ! -f "$GAMEDIR/gamedata/ALLFILES.TXT" ] && [ ! -f "$GAMEDIR/gamedata/allfiles.txt" ]; then
  echo "warning: no ALLFILES.TXT in cd/ or gamedata/. Copy the CD files into cd/ (not the ISO)."
fi

if [ ! -x "$GAMEDIR/$BIN" ]; then
  pm_message "Missing $BIN. This zip is the PortMaster layout only. The desktop trap host is i386 and cannot run here; the aarch64 native binary is a later build."
  pm_finish
  exit 1
fi

# Desk glove: gptk pad-as-mouse (d-pad / H left stick, A click, B right-click).
# Select (Back) is unbound so Overbar overlay opens (Online stays listed).
# Select+Start quits to EmulationStation (PortMaster).
$GPTOKEYB "$BIN" -c "$GAMEDIR/nhl95pc.gptk" &
pm_platform_helper "$GAMEDIR/$BIN"
./"$BIN"
pm_finish
