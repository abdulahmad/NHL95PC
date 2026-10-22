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

/* DrawBevelBox: fill the box x1, y1 - x2, y2 in the box fill colour (sub_90D20), light top left
 edges and shaded bottom right edges (sub_B4FAC lines); with studs, put a 2 x 2 light shade checker pixel
 pattern (sub_B5DB0) 2 pixels in from each corner. */
void DrawBevelBox(int x1, int y1, int x2, int y2, int studs)
{
    sub_90D20(x1, y1, x2 - x1 + 1, y2 - y1 + 1, boxfillcolor);
    sub_B4FAC(x1, y1, x2, y1, boxlitecolor);
    sub_B4FAC(x1, y1, x1, y2, boxlitecolor);
    sub_B4FAC(x2, y1, x2, y2, boxshadecolor);
    sub_B4FAC(x1, y2, x2, y2, boxshadecolor);
    if (studs) {
        sub_B5DB0(x1 + 2, y1 + 2, boxlitecolor);
        sub_B5DB0(x1 + 3, y1 + 3, boxlitecolor);
        sub_B5DB0(x1 + 3, y1 + 2, boxshadecolor);
        sub_B5DB0(x1 + 2, y1 + 3, boxshadecolor);
        sub_B5DB0(x1 + 2, y2 - 2, boxshadecolor);
        sub_B5DB0(x1 + 3, y2 - 3, boxshadecolor);
        sub_B5DB0(x1 + 3, y2 - 2, boxlitecolor);
        sub_B5DB0(x1 + 2, y2 - 3, boxlitecolor);
        sub_B5DB0(x2 - 3, y1 + 2, boxlitecolor);
        sub_B5DB0(x2 - 2, y1 + 3, boxlitecolor);
        sub_B5DB0(x2 - 2, y1 + 2, boxshadecolor);
        sub_B5DB0(x2 - 3, y1 + 3, boxshadecolor);
        sub_B5DB0(x2 - 3, y2 - 2, boxshadecolor);
        sub_B5DB0(x2 - 2, y2 - 3, boxshadecolor);
        sub_B5DB0(x2 - 2, y2 - 2, boxlitecolor);
        sub_B5DB0(x2 - 3, y2 - 3, boxlitecolor);
    }
}
