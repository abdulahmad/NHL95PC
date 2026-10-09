extern unsigned char bb[100]; extern short ss[100]; extern int ii[100];
int f1(int a, int b) { return bb[a] + bb[b] * 3 + ss[a] * 10 + (ii[b] >> 3); }
int f2(int n) { int s = 0, i; for (i = 0; i < n; i++) s += bb[i] * ii[i] + ss[i]; return s; }
unsigned f3(unsigned x) { return (x * 5 + 7) / 3 + (x << 4) - x % 7; }
void f4(char *d, const char *s, int n) { while (n--) *d++ = *s++ ^ 0x55; }
int f5(short a) { switch (a) { case 1: return 4; case 2: return 9; case 3: return 2; case 4: return 7; case 5: return 11; default: return 0; } }
