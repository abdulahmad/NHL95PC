extern void *malloc(unsigned);
extern void *memset(void *, int, unsigned);
extern char *buf_C6410;
extern int flag_C6414;
void init_buf(void)
{
    if (buf_C6410 == 0) buf_C6410 = malloc(0xE74);
    flag_C6414 = 1;
    memset(buf_C6410, 0x20, 0xE10);
}
