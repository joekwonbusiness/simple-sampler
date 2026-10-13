# Simple Sampler

Simple Sampler 0.1 is a focused Windows x64 audio-to-MIDI VST3 based on
[NeuralNote](https://github.com/DamRsn/NeuralNote) v2.1.0. Despite the product name, this first version is an
audio-to-MIDI utility rather than a sample slicer: it records or imports audio, transcribes it locally with
MuScriptor, previews the result in a piano roll, and lets you drag or save MIDI.

The implementation intentionally keeps NeuralNote's transcription, playback, piano-roll, session-state, and MIDI
export internals. The first-pass changes are product identity, Windows build/release automation, storage names, and
documentation. See [UPSTREAM.md](UPSTREAM.md) for exact source provenance.

## Features

- Record audio from the host or import WAV, AIFF, FLAC, MP3, or Ogg Vorbis.
- Transcribe one or several instruments with the upstream MuScriptor engine.
- Preview incoming notes in the piano roll while transcription is running.
- Pause/resume transcription and keep resumable state with the DAW session.
- Audition the original audio and the built-in multi-instrument synth.
- Drag MIDI directly to an Ableton MIDI track or save a `.mid` file.
- Run locally on the CPU, or use Vulkan GPU acceleration when built with the Vulkan SDK.

## Download the GitHub Actions artifact

1. Open **Actions** in this repository and select **Build Windows x64 VST3**.
2. Open a successful run and download **Simple-Sampler-Windows-x64-VST3**.
3. Extract the artifact. It contains `Simple Sampler.vst3` plus the applicable license notices.

The workflow builds on `windows-latest` with pinned LLVM/Vulkan/ccache setup, verifies the VST3 metadata and x64 PE
header, and uploads the complete bundle. It does not publish or bundle model weights.

## Install in Ableton Live 12

1. Close Ableton Live.
2. Copy the complete `Simple Sampler.vst3` directory to:

   ```text
   C:\Program Files\Common Files\VST3\Simple Sampler.vst3
   ```

3. Start Ableton Live 12 and open **Settings/Preferences > Plug-Ins**.
4. Enable **Use VST3 Plug-In System Folders**. Hold `Alt` while clicking **Rescan** if a normal rescan does not find
   it.
5. In the browser, find **Plug-Ins > VST3 > Simple Sampler** and place it on an audio track.

To use it, play or record audio through that track (or drop an audio file onto the plugin), select instruments, and
click **Transcribe**. Drag **MIDI** from the plugin onto a separate MIDI track when the result is ready.

On first use, choose and download a MuScriptor model. Models are stored under
`%APPDATA%\Simple Sampler\models`; downloads range from roughly 210 MB to 2.7 GB. See
[MODEL_LICENSE.md](MODEL_LICENSE.md) before downloading or using them.

## Build on Windows x64

Prerequisites:

- Git with submodule support
- CMake 3.24 or newer
- Python 3
- Ninja
- LLVM/clang-cl and lld
- Visual Studio 2022 Build Tools with the x64 C++ workload and a Windows SDK
- Internet access on first configure (for pinned ggml and verified soundfont sources)
- Optional: Vulkan SDK for GPU transcription

Clone with submodules, then run one command from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1
```

The script automatically uses Vulkan when `VULKAN_SDK` points to an installed SDK; otherwise it produces a valid
CPU-only VST3. Force CPU-only mode with `-CpuOnly`. Build the standalone application too with `-WithStandalone`.
The VST3 is written to:

```text
build\SimpleSampler_artefacts\Release\VST3\Simple Sampler.vst3
```

ASIO is disabled by the local helper because distributing an ASIO-enabled standalone build requires accepting
Steinberg's separate ASIO license. Pass `-EnableAsio` only if that requirement has been handled. VST3 operation in
Ableton does not depend on the standalone application's ASIO support.

Some inherited CMake switches retain their `NEURALNOTE_` prefix to minimize source divergence. The CI workflow uses
the upstream-style `configure_and_build.py` path, explicitly disables ASIO, and requires Vulkan, so a missing SDK
fails CI rather than silently producing a CPU-only artifact.

## Models and licensing

The plugin code is derived from Apache-2.0-licensed NeuralNote. Full third-party notices are retained in
[`Installers/license.txt`](Installers/license.txt), and the upstream copyright remains in [LICENSE](LICENSE) and
[NOTICE](NOTICE).

MuScriptor model weights are separate downloads and are **not open source**. The published weights are licensed
under CC BY-NC 4.0, which restricts them to noncommercial use. They are not stored in this repository or included in
the build artifact. Do not treat the Apache-2.0 code license as permission to distribute or use those weights
commercially. JUCE and all other dependencies remain subject to their own terms.

## Scope and verification

Version 0.1 deliberately does not add a custom spectrogram, sample slicer, or new ML model.

The imported upstream source was built unchanged on Windows x64 before rebranding. The rebranded Release VST3,
metadata, unit tests, and artifact layout are verified during implementation and/or CI as described in the repository
history. Ableton Live 12 host loading, GPU transcription on physical hardware, model download, and end-to-end
transcription require external software/data and are not claimed as tested unless a verification record explicitly
says so.

## Upstream

Simple Sampler is based on NeuralNote by Damien Ronssin and contributors. NeuralNote v2 credits Damien Ronssin;
NeuralNote v1 credits Damien Ronssin, Tibor Vass, Perrine Morel, and the contributors listed in the imported upstream
history. Please report Simple Sampler issues in this repository; report engine-specific issues to
[muscriptor.cpp](https://github.com/DamRsn/muscriptor.cpp).
