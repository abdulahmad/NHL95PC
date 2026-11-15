/* File utils: per-frame redraw of the top panel, and the clock digits that share its exit. */
#define DrawPanelClock DrawPanelClock_decl
#include "nhl95.h"
#undef DrawPanelClock

#define PUTDIGIT ((void (__cdecl *)(int spr, int x, int y))sub_B4CD8)

/* UpdateHudPanel: on the screen bitmap, tick the panel clock and both penalty lists (unless the
 clock was already stopped, or a replay is up), refresh both teams' line energies, and draw the
 clock, the two energy bars (energy / 500) and either the line-change bars or the penalty list.
 A side whose line box is on, whose bars were forced, or that is in replay draws the line bars
 and clears the "penalties showing" flag. A side with a negative penalty slot forces the bars
 once. Otherwise the panel shape is drawn the first time and the penalty list follows. */
void UpdateHudPanel(void)
{
    int n;

    SelectScreenBM();
    if (hudclockmin < 0) return;
    n = hudhundstep;
    panelhund = n;
    hudhundstep = 0;
    if (TickPanelClock(n) && (gmode & 0x10) == 0) {
        TickPanelPenalties((struct PenSlot *)hudpenhome, panelhund);
        TickPanelPenalties((struct PenSlot *)hudpenaway, panelhund);
    }
    GetLineEnergies(0, hmlineenergies);
    GetLineEnergies(1, awlineenergies);
    DrawPanelClockDigits();
    DrawEnergyBar(hmlineenergies[hudhomeline] / 500, 0x2B);
    DrawEnergyBar(awlineenergies[hudawayline] / 500, 0xFC);
    if (lcboxon[0] || hmpanellines || (gmode & 0x10)) {
        DrawLineGroupBars(&hmlinetimer, (int *)hmlineind, hudhomeline, hmlineenergies, 0x4A);
        hmpanelpens = 0;
    } else if (hudpenhome[0] < 0) {
        hmpanellines = 1;
        DrawLineGroupBars(&hmlinetimer, (int *)hmlineind, hudhomeline, hmlineenergies, 0x4A);
        hmpanelpens = 0;
    } else {
        if (!hmpanelpens) {
            sub_B4CF2(hmpanelspr);
            hmpanelpens = 1;
        }
        DrawPanelPenalties((struct PenSlot *)hudpenhome, 0x48);
        hmlinetimer = 0;
    }
    if (lcboxon[1] || awpanellines || (gmode & 0x10)) {
        DrawLineGroupBars(&awlinetimer, (int *)awlineind, hudawayline, awlineenergies, 0xC1);
        awpanelpens = 0;
    } else if (hudpenaway[0] < 0) {
        awpanellines = 1;
        DrawLineGroupBars(&awlinetimer, (int *)awlineind, hudawayline, awlineenergies, 0xC1);
        awpanelpens = 0;
    } else {
        if (!awpanelpens) {
            sub_B4CF2(awpanelspr);
            awpanelpens = 1;
        }
        DrawPanelPenalties((struct PenSlot *)hudpenaway, 0xBF);
        awlinetimer = 0;
    }
}

/* DrawPanelClock: draw the clock on the screen bitmap. With no minutes left, the colon is the
 tens of seconds and the hundredths follow; otherwise the minutes and seconds are two digits each.
 A value under 10 uses the colon sprite as a blank tens digit. The three fields are saved afterwards. */
void DrawPanelClock(void)
{
    if (hudclockmin == 0) {
        PUTDIGIT(clockcolon, 0xAA, 3);
        if (hudclocksec < 10)
            PUTDIGIT(clockcolon, 0x8C, 3);
        else
            PUTDIGIT(clockdigits[hudclocksec / 10], 0x8C, 3);
        PUTDIGIT(clockdigits[hudclocksec % 10], 0x95, 3);
        PUTDIGIT(clockdigits[hudclockhund / 10], 0xA1, 3);
    } else {
        if (hudclockmin < 10)
            PUTDIGIT(clockcolon, 0x8C, 3);
        else
            PUTDIGIT(clockdigits[hudclockmin / 10], 0x8C, 3);
        PUTDIGIT(clockdigits[hudclockmin % 10], 0x95, 3);
        PUTDIGIT(clockdigits[hudclocksec / 10], 0xA1, 3);
        PUTDIGIT(clockdigits[hudclocksec % 10], 0xAA, 3);
    }
    panelprevmin = hudclockmin;
    panelprevsec = hudclocksec;
    panelprevhund = hudclockhund;
}

/* DrawPanelClockDigits (1540A, PC only; segment 006, the same source file: it ends in UpdateHudPanel_x): redraw
   only the clock digits that changed since the last frame (previous minutes, seconds, hundredths in panelprevmin,
   C5714, C5718), with DrawPanelClock's layout: with no minutes left the colon slot (when the minutes just ran
   out), the tens and units of the seconds and the tens of the hundredths; otherwise the minutes and the seconds
   as two digits each. A value under 10 uses the colon sprite as a blank tens digit. No arguments, no result. */
void DrawPanelClockDigits(void)
{
    if (hudclockmin == 0) {
        if (hudclockmin != panelprevmin) PUTDIGIT(clockcolon, 0xAA, 3);
        if (panelprevsec != hudclocksec) {
            if (panelprevsec / 10 != hudclocksec / 10) {
                if (hudclocksec < 10)
                    PUTDIGIT(clockcolon, 0x8C, 3);
                else
                    PUTDIGIT(clockdigits[hudclocksec / 10], 0x8C, 3);
            }
            if (panelprevsec % 10 != hudclocksec % 10) PUTDIGIT(clockdigits[hudclocksec % 10], 0x95, 3);
        }
        if (panelprevhund / 10 != hudclockhund / 10) PUTDIGIT(clockdigits[hudclockhund / 10], 0xA1, 3);
    } else {
        if (panelprevmin != hudclockmin) {
            if (panelprevmin / 10 != hudclockmin / 10) {
                if (hudclockmin < 10)
                    PUTDIGIT(clockcolon, 0x8C, 3);
                else
                    PUTDIGIT(clockdigits[hudclockmin / 10], 0x8C, 3);
            }
            if (panelprevmin % 10 != hudclockmin % 10) PUTDIGIT(clockdigits[hudclockmin % 10], 0x95, 3);
        }
        if (panelprevsec != hudclocksec) {
            if (panelprevsec / 10 != hudclocksec / 10) PUTDIGIT(clockdigits[hudclocksec / 10], 0xA1, 3);
            if (panelprevsec % 10 != hudclocksec % 10) PUTDIGIT(clockdigits[hudclocksec % 10], 0xAA, 3);
        }
    }
}
