# MiSTer filter files

These files are used by the "MiSTer filters" menus of the SDL2 port (see the top README). They come unchanged from the MiSTer FPGA project:

* `Filters/` and `Gamma/`: [Filters_MiSTer](https://github.com/MiSTer-devel/Filters_MiSTer) (the adaptive scanline filters are by Soltan_G42 and Tonurics; the other filters and gamma curves are by the contributors named in each file's header)
* `Shadow_Masks/`: [ShadowMasks_MiSTer](https://github.com/MiSTer-devel/ShadowMasks_MiSTer) (the author of each mask is named in its header, for example TrashUncle for the JVC masks)
* `Presets/`: [Presets_MiSTer](https://github.com/MiSTer-devel/Presets_MiSTer)

The MiSTer project ([MiSTer-devel](https://github.com/MiSTer-devel)) is GPL-3.0 licensed, and these repositories state no separate licence. Please see them for the full lists of contributors and for newer versions. Only the `.txt` and `.ini` data files are included here (not the scripts of those repositories).

The build copies this folder next to the program (`build/win/mister`), where the port reads it. To use other files, for example from a MiSTer SD card, put them in that folder with the same layout (`Filters`, `Gamma`, `Shadow_Masks`, `Presets`).
