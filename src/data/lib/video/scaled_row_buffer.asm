; Tables for the EA libraries: the mouse, the clip rectangle, and the file and video state.
bits 32
%include "hockey.inc"
section s_F6138 nobits alloc noexec write align=1
global ScaledRowBuffer
ScaledRowBuffer:                                ; Row buffer for the mapped-triangle rasteriser; used by
                                                ; DrawShapeQuad, RasterMappedTriangle
        resb 6208
