/* League schedule: names and the bevelled box. DrawBevelBox follows FitPlayerName as in the EXE: compiled
   alone it gets other stack slots for its corner sums (it matched only after other files in the same
   DOSBox run); after FitPlayerName in one file it matches with a fresh compile. */
#include "nhl95.h"

/* FitPlayerName: dst = "first last" fitted to maxw pixels: "F. last" when too wide, then cut from the end
 just last when there is no first name. */
void FitPlayerName(char *dst, char *first, char *last, int maxw)
{
    if (first) {
        strcpy(dst, first);
        strcat(dst, (char *)&str_space);
        strcat(dst, last);
        if (fputchar(dst) > maxw) {
            dst[0] = first[0];
            dst[1] = '.';
            dst[2] = ' ';
            dst[3] = 0;
            strcat(dst, last);
        }
    } else {
        strcpy(dst, last);
    }
    while (fputchar(dst) > maxw) dst[strlen(dst) - 1] = 0;
}

/* DrawBevelBox: fill the box x1, y1 - x2, y2 in the box fill colour (FillRect), light top left
 edges and shaded bottom right edges (FillRectColor lines); with studs, put a 2 x 2 light shade checker pixel
 pattern (PlotPixel) 2 pixels in from each corner. */
void DrawBevelBox(int x1, int y1, int x2, int y2, int studs)
{
    FillRect(x1, y1, x2 - x1 + 1, y2 - y1 + 1, boxfillcolor);
    FillRectColor(x1, y1, x2, y1, boxlitecolor);
    FillRectColor(x1, y1, x1, y2, boxlitecolor);
    FillRectColor(x2, y1, x2, y2, boxshadecolor);
    FillRectColor(x1, y2, x2, y2, boxshadecolor);
    if (studs) {
        PlotPixel(x1 + 2, y1 + 2, boxlitecolor);
        PlotPixel(x1 + 3, y1 + 3, boxlitecolor);
        PlotPixel(x1 + 3, y1 + 2, boxshadecolor);
        PlotPixel(x1 + 2, y1 + 3, boxshadecolor);
        PlotPixel(x1 + 2, y2 - 2, boxshadecolor);
        PlotPixel(x1 + 3, y2 - 3, boxshadecolor);
        PlotPixel(x1 + 3, y2 - 2, boxlitecolor);
        PlotPixel(x1 + 2, y2 - 3, boxlitecolor);
        PlotPixel(x2 - 3, y1 + 2, boxlitecolor);
        PlotPixel(x2 - 2, y1 + 3, boxlitecolor);
        PlotPixel(x2 - 2, y1 + 2, boxshadecolor);
        PlotPixel(x2 - 3, y1 + 3, boxshadecolor);
        PlotPixel(x2 - 3, y2 - 2, boxshadecolor);
        PlotPixel(x2 - 2, y2 - 3, boxshadecolor);
        PlotPixel(x2 - 2, y2 - 2, boxlitecolor);
        PlotPixel(x2 - 3, y2 - 3, boxlitecolor);
    }
}
