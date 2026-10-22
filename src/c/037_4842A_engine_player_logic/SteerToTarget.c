/* Engine player logic: steer to a target. */
#include "nhl95.h"

#define STEERCNT(p) (((signed char *)(p))[0x29])  /* steering countdown: high byte of temp2 */
#define STEERDIR(p) (((signed char *)(p))[0x28])  /* steering direction: low byte of temp2 */

/* SteerToTarget: every 12 frames (countdown in byte +29h) aim p at the point regd0.w regd1.w
 (made relative to p's position plus the high byte of its velocity): direction 9 (there) when within 12 both ways,
 else vtoa; kept in byte +28h. When there (direction > 7) and standing still, turn one step towards the point
 temp3 temp4 (facedir). Then move in that direction (byte +28h, MoveInDir). */
void SteerToTarget(Player *p)
{
    if (--STEERCNT(p) < 0) {
        STEERCNT(p) += 12;
        regd0.w = regd0.w - (p->Xvel >> 8) - (p->Xpos >> 16);
        regd1.w = regd1.w - (p->Yvel >> 8) - (p->Ypos >> 16);
        if (ABS(regd0.w) <= 12 && ABS(regd1.w) <= 12) regd0.w = 9;
        else regd0.w = vtoa(regd0.w, regd1.w);
        STEERDIR(p) = regd0.w;
        if (regd0.w > 7 && (p->Xvel | p->Yvel) == 0) {
            regd0.w = p->temp3 - HIWORD(p->Xpos);
            regd1.w = p->temp4 - HIWORD(p->Ypos);
            regd0.w = p->facedir - vtoa(regd0.w, regd1.w);
            if (regd0.w) p->facedir = (p->facedir + ((regd0.w & 4) >> 1) - 1) & 7;
        }
    }
    MoveInDir(p, STEERDIR(p));
}
