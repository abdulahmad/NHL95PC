extern char *strcpy(char *, const char *);
extern char *strcat(char *, const char *);
void build_path(char *dst, char *dir, char *name, char *ext)
{
    if (dir && *dir) { strcpy(dst, dir); strcat(dst, "\\"); }
    else *dst = 0;
    if (name) strcat(dst, name);
    if (ext) strcat(dst, ext);
}
