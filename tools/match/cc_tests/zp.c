struct s { char c; int i; short h; };
extern struct s gs;
int zp_i(void) { return gs.i; }
int zp_h(void) { return gs.h; }
int zp_sz(void) { return sizeof(struct s); }
char g1; int g2; char g3; short g4;
int glob(void) { return g2 + g4 + g1 + g3; }
