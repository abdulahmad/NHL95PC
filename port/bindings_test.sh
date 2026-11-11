#!/bin/sh
# Custom-key gate and the Hold chord (port/bindings.c).
cd "$(dirname "$0")/.." || exit 1
mkdir -p build
# bindings.c includes SDL only for the ini load; the test does not call that, so a stand-in header is enough
mkdir -p build/sdl-stub
printf '%s\n' '#define SDL_BUTTON_LEFT 1' '#define SDL_BUTTON_MIDDLE 2' '#define SDL_BUTTON_RIGHT 3' \
    'char *SDL_GetBasePath(void);' 'void SDL_free(void *);' > build/sdl-stub/SDL.h
gcc -O1 -g -Wall -Wextra -Iport -Ibuild/sdl-stub -ffunction-sections -fdata-sections \
    -o build/bindings_test port/bindings_test.c port/bindings.c -Wl,--gc-sections || exit 1
build/bindings_test
