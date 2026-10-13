# Upstream provenance

Simple Sampler was imported from the upstream NeuralNote repository with history preserved.

| Item | Revision |
| --- | --- |
| Upstream repository | `https://github.com/DamRsn/NeuralNote.git` |
| Upstream release/branch | NeuralNote v2.1.0, `main` |
| Upstream commit | `7734729a2d54cecfb4e5a6ea5d981689bfecb6be` |
| Import merge commit | `359e582c4bc246141f768499842f1aa8d93a6f1d` |
| JUCE submodule | `91ad83ae34a81e0833b1a2b0866f54846370ae53` |
| muscriptor.cpp submodule | `c8adc019677ed3479fa3c22c1a117d662382f347` |
| Import date | 2026-10-13 |

The repository's original scaffold and upstream were joined with an unrelated-history merge. This keeps both parent
histories reachable instead of copying a source archive without provenance. Required submodules are declared in
`.gitmodules` and must be initialized recursively.

Internal `NeuralNote` class names, state-tree identifiers, source-directory names, and inherited CMake option names
remain where changing them would add compatibility risk without improving the host-visible rebrand. Simple Sampler
changes product/bundle metadata, visible product strings, writable data locations, generated artifacts, the icon,
Windows packaging, CI, and documentation. Transcription, piano-roll, playback, and MIDI drag/export algorithms were
not rewritten.

The imported `docs/`, macOS packaging files, and historical assets are upstream material retained for provenance and
license completeness. Version 0.1 support and CI are intentionally focused on Windows x64 VST3.
