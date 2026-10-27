/* The OpenGL presentation path: the game's frame as a texture, drawn by a fragment shader that scales it with a cubic (Catmull-Rom)
 * filter. For the 320x200 screens the shader first takes the image as if it had been enlarged 3x with nearest-neighbour (so every
 * pixel stays a crisp block) and filters that, which is "sharp" scaling to any window size; the 640x480 screens are filtered directly.
 * NHL95_FILTER=nearest|linear|cubic (default cubic) picks the filter. OpenGL 2.0 is enough (compatibility profile). If anything here
 * fails, video.c falls back to SDL's renderer. */
#include "host.h"
#include <SDL.h>
#include <SDL_opengl.h>
#include <SDL_opengl_glext.h>

static PFNGLCREATESHADERPROC p_glCreateShader;
static PFNGLSHADERSOURCEPROC p_glShaderSource;
static PFNGLCOMPILESHADERPROC p_glCompileShader;
static PFNGLGETSHADERIVPROC p_glGetShaderiv;
static PFNGLGETSHADERINFOLOGPROC p_glGetShaderInfoLog;
static PFNGLCREATEPROGRAMPROC p_glCreateProgram;
static PFNGLATTACHSHADERPROC p_glAttachShader;
static PFNGLLINKPROGRAMPROC p_glLinkProgram;
static PFNGLGETPROGRAMIVPROC p_glGetProgramiv;
static PFNGLUSEPROGRAMPROC p_glUseProgram;
static PFNGLGETUNIFORMLOCATIONPROC p_glGetUniformLocation;
static PFNGLUNIFORM1IPROC p_glUniform1i;
static PFNGLUNIFORM1FPROC p_glUniform1f;
static PFNGLUNIFORM2FPROC p_glUniform2f;

static SDL_GLContext ctx;
static GLuint prog, tex;
static GLint u_tex, u_size, u_pre, u_mode;
static int tex_w, tex_h, filter_mode = 2;

static const char *vs_src =
    "#version 110\n"
    "varying vec2 uv;\n"
    "void main() { gl_Position = gl_Vertex; uv = gl_MultiTexCoord0.xy; }\n";

/* weights of the four taps i-1, i, i+1, i+2 for a position f (0..1) between taps i and i+1 */
static const char *fs_src =
    "#version 110\n"
    "uniform sampler2D tex;\n"
    "uniform vec2 srcsize;\n"
    "uniform float pre;\n"
    "uniform int mode;\n"
    "varying vec2 uv;\n"
    "vec4 fetch(vec2 v) {\n"
    "  vec2 s = clamp(floor(v / pre), vec2(0.0), srcsize - 1.0);\n"
    "  return texture2D(tex, (s + 0.5) / srcsize);\n"
    "}\n"
    "vec4 weights(float f) {\n"
    "  if (mode == 0) return vec4(0.0, f < 0.5 ? 1.0 : 0.0, f < 0.5 ? 0.0 : 1.0, 0.0);\n"
    "  if (mode == 1) return vec4(0.0, 1.0 - f, f, 0.0);\n"
    "  float f2 = f * f, f3 = f2 * f;\n"
    "  return vec4(-0.5 * f3 + f2 - 0.5 * f, 1.5 * f3 - 2.5 * f2 + 1.0, -1.5 * f3 + 2.0 * f2 + 0.5 * f, 0.5 * f3 - 0.5 * f2);\n"
    "}\n"
    "vec4 row(vec2 i, float y, vec4 wx) {\n"
    "  return fetch(i + vec2(-1.0, y)) * wx.x + fetch(i + vec2(0.0, y)) * wx.y + fetch(i + vec2(1.0, y)) * wx.z + fetch(i + vec2(2.0, y)) * wx.w;\n"
    "}\n"
    "void main() {\n"
    "  vec2 p = uv * srcsize * pre - 0.5;\n"
    "  vec2 i = floor(p);\n"
    "  vec2 f = p - i;\n"
    "  vec4 wx = weights(f.x), wy = weights(f.y);\n"
    "  vec4 c = row(i, -1.0, wx) * wy.x + row(i, 0.0, wx) * wy.y + row(i, 1.0, wx) * wy.z + row(i, 2.0, wx) * wy.w;\n"
    "  gl_FragColor = vec4(clamp(c.rgb, 0.0, 1.0), 1.0);\n"
    "}\n";

#define LOAD(name) do { p_##name = (void *)SDL_GL_GetProcAddress(#name); if (!p_##name) return 0; } while (0)

static GLuint compile(GLenum type, const char *src)
{
    GLuint s = p_glCreateShader(type);
    GLint ok = 0;
    p_glShaderSource(s, 1, &src, 0);
    p_glCompileShader(s);
    p_glGetShaderiv(s, GL_COMPILE_STATUS, &ok);
    if (!ok) {
        char log[512] = "";
        p_glGetShaderInfoLog(s, sizeof log, 0, log);
        fprintf(stderr, "OpenGL shader: %s\n", log);
        return 0;
    }
    return s;
}

/* a context for the window (created with SDL_WINDOW_OPENGL), the shader and the texture; 0 if something is missing */
int vgl_init(SDL_Window *win)
{
    GLuint vs, fs;
    GLint ok = 0;
    const char *f = getenv("NHL95_FILTER");
    ctx = SDL_GL_CreateContext(win);
    if (!ctx) return 0;
    LOAD(glCreateShader); LOAD(glShaderSource); LOAD(glCompileShader); LOAD(glGetShaderiv); LOAD(glGetShaderInfoLog);
    LOAD(glCreateProgram); LOAD(glAttachShader); LOAD(glLinkProgram); LOAD(glGetProgramiv); LOAD(glUseProgram);
    LOAD(glGetUniformLocation); LOAD(glUniform1i); LOAD(glUniform1f); LOAD(glUniform2f);
    vs = compile(GL_VERTEX_SHADER, vs_src);
    fs = compile(GL_FRAGMENT_SHADER, fs_src);
    if (!vs || !fs) return 0;
    prog = p_glCreateProgram();
    p_glAttachShader(prog, vs);
    p_glAttachShader(prog, fs);
    p_glLinkProgram(prog);
    p_glGetProgramiv(prog, GL_LINK_STATUS, &ok);
    if (!ok) return 0;
    u_tex = p_glGetUniformLocation(prog, "tex");
    u_size = p_glGetUniformLocation(prog, "srcsize");
    u_pre = p_glGetUniformLocation(prog, "pre");
    u_mode = p_glGetUniformLocation(prog, "mode");
    glGenTextures(1, &tex);
    SDL_GL_SetSwapInterval(1);
    if (f && !strcmp(f, "nearest")) filter_mode = 0;
    else if (f && !strcmp(f, "linear")) filter_mode = 1;
    return 1;
}


/* ---- the on-screen display: two lines of text in the top left corner, drawn over the picture at the window's own resolution ----
 * A 5x7 font of just the characters the lines use. */
static const struct { char c; unsigned char r[7]; } font[] = {
    { '0', { 0x0E, 0x11, 0x13, 0x15, 0x19, 0x11, 0x0E } }, { '1', { 0x04, 0x0C, 0x04, 0x04, 0x04, 0x04, 0x0E } },
    { '2', { 0x0E, 0x11, 0x01, 0x02, 0x04, 0x08, 0x1F } }, { '3', { 0x1E, 0x01, 0x01, 0x0E, 0x01, 0x01, 0x1E } },
    { '4', { 0x02, 0x06, 0x0A, 0x12, 0x1F, 0x02, 0x02 } }, { '5', { 0x1F, 0x10, 0x1E, 0x01, 0x01, 0x11, 0x0E } },
    { '6', { 0x06, 0x08, 0x10, 0x1E, 0x11, 0x11, 0x0E } }, { '7', { 0x1F, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08 } },
    { '8', { 0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E } }, { '9', { 0x0E, 0x11, 0x11, 0x0F, 0x01, 0x02, 0x0C } },
    { 'C', { 0x0E, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0E } }, { 'E', { 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x1F } },
    { 'F', { 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x10 } }, { 'H', { 0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11 } },
    { 'N', { 0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x11 } }, { 'O', { 0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E } },
    { 'R', { 0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11 } },
    { 'P', { 0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10, 0x10 } }, { 'S', { 0x0F, 0x10, 0x10, 0x0E, 0x01, 0x01, 0x1E } },
    { 'V', { 0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04 } }, { 'W', { 0x11, 0x11, 0x11, 0x15, 0x15, 0x15, 0x0A } },
    { 'Y', { 0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x04 } }, { 'Z', { 0x1F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1F } },
};

static GLuint osd_tex;
static int osd_w, osd_h, osd_fresh;
static uint32_t osd_pix[96 * 18];

/* the text of the display (NULL: none) */
void vgl_osd_set(const char *l1, const char *l2)
{
    const char *line[2] = { l1, l2 };
    int i, k, x, y;
    if (!l1) { osd_w = 0; return; }
    osd_w = 96; osd_h = 2 * 8 + 2;
    for (i = 0; i < osd_w * osd_h; i++) osd_pix[i] = 0xC0000000u;
    for (i = 0; i < 2; i++)
        for (k = 0; line[i][k] && k < 15; k++) {
            unsigned j;
            for (j = 0; j < sizeof font / sizeof font[0]; j++) {
                if (font[j].c != line[i][k]) continue;
                for (y = 0; y < 7; y++)
                    for (x = 0; x < 5; x++)
                        if (font[j].r[y] >> (4 - x) & 1) osd_pix[(1 + i * 8 + y) * osd_w + 1 + k * 6 + x] = 0xFFFFFF40u;
            }
        }
    osd_fresh = 1;
}

static void osd_draw(int dw, int dh)
{
    int s = dh / 270 < 2 ? 2 : dh / 270;
    float x1 = -1.0f + 2.0f * osd_w * s / dw, y1 = 1.0f - 2.0f * osd_h * s / dh;
    if (!osd_w) return;
    if (!osd_tex) glGenTextures(1, &osd_tex);
    glBindTexture(GL_TEXTURE_2D, osd_tex);
    if (osd_fresh) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, osd_w, osd_h, 0, 0x80E1 /* GL_BGRA */, GL_UNSIGNED_BYTE, osd_pix);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        osd_fresh = 0;
    }
    glViewport(0, 0, dw, dh);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glColor4f(1, 1, 1, 1);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 1); glVertex2f(-1, y1);
    glTexCoord2f(1, 1); glVertex2f(x1, y1);
    glTexCoord2f(1, 0); glVertex2f(x1, 1);
    glTexCoord2f(0, 0); glVertex2f(-1, 1);
    glEnd();
    glDisable(GL_BLEND);
}

/* draw the frame (w x h ARGB pixels) into the part of the window given in drawable pixels */
void vgl_draw(SDL_Window *win, const uint32_t *argb, int w, int h, int vx, int vy, int vw, int vh)
{
    int dw, dh;
    SDL_GL_GetDrawableSize(win, &dw, &dh);
    glViewport(0, 0, dw, dh);
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(vx, vy, vw, vh);
    glBindTexture(GL_TEXTURE_2D, tex);
    if (w != tex_w || h != tex_h) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, w, h, 0, 0x80E1 /* GL_BGRA */, GL_UNSIGNED_BYTE, 0);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, 0x812F /* GL_CLAMP_TO_EDGE */);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, 0x812F);
        tex_w = w; tex_h = h;
    }
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, w, h, 0x80E1, GL_UNSIGNED_BYTE, argb);
    p_glUseProgram(prog);
    p_glUniform1i(u_tex, 0);
    p_glUniform2f(u_size, (float)w, (float)h);
    p_glUniform1f(u_pre, w == 320 ? 3.0f : 1.0f);
    p_glUniform1i(u_mode, filter_mode);
    glEnable(GL_TEXTURE_2D);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 1); glVertex2f(-1, -1);
    glTexCoord2f(1, 1); glVertex2f(1, -1);
    glTexCoord2f(1, 0); glVertex2f(1, 1);
    glTexCoord2f(0, 0); glVertex2f(-1, 1);
    glEnd();
    p_glUseProgram(0);
    osd_draw(dw, dh);
    {                                           /* NHL95_SHOT=file.ppm and NHL95_SHOT_AT=seconds: save what the window shows (a test aid) */
        const char *path = getenv("NHL95_SHOT"), *at = getenv("NHL95_SHOT_AT");
        static int done;
        if (path && !done && SDL_GetTicks() > (Uint32)(at ? atoi(at) : 5) * 1000u) {
            uint8_t *buf = malloc((size_t)dw * dh * 3);
            FILE *f = fopen(path, "wb");
            int y;
            done = 1;
            glReadBuffer(GL_BACK);
            glPixelStorei(GL_PACK_ALIGNMENT, 1);
            glReadPixels(0, 0, dw, dh, GL_RGB, GL_UNSIGNED_BYTE, buf);
            if (f) {
                fprintf(f, "P6\n%d %d\n255\n", dw, dh);
                for (y = dh - 1; y >= 0; y--) fwrite(buf + (size_t)y * dw * 3, 3, dw, f);
                fclose(f);
            }
            free(buf);
        }
    }
    SDL_GL_SwapWindow(win);
}

void vgl_set_vsync(int on) { SDL_GL_SetSwapInterval(on ? 1 : 0); }

void vgl_quit(void)
{
    if (ctx) SDL_GL_DeleteContext(ctx);
    ctx = 0;
}
