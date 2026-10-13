# Simple Sampler — Codex implementation instructions

## Goal
Produce a working Windows x64 VST3 for Ableton Live 12 in one Codex implementation pass, starting from the upstream open-source NeuralNote project: https://github.com/DamRsn/NeuralNote .

## Non-negotiable first-pass scope
- Preserve NeuralNote's existing audio-to-MIDI transcription, piano-roll preview, and drag/export MIDI functionality.
- Rebrand the plugin as **Simple Sampler** (product name, plugin display name, generated artifact names where practical).
- Make Windows x64 VST3 the priority; do not replace JUCE with Max for Live or rewrite the DSP.
- Ensure the repository contains the actual upstream source and required submodules/dependencies, not merely a link or empty scaffold.
- Preserve all required upstream copyright, attribution, and license notices. Audit model-weight licenses; do not claim commercial distribution rights to noncommercial weights.
- Include a Windows GitHub Actions workflow that configures, builds, and uploads the VST3 as an artifact.
- Document installation into Ableton Live 12, expected paths, and how to use the plugin.
- Do not spend this pass implementing a custom spectrogram, sample slicer, or new ML models.

## Execution sequence
1. Inspect this repository, and the latest upstream NeuralNote README, license, build configuration, and submodule instructions.
2. If this repo is empty or just a scaffold, import NeuralNote source into this repository with provenance. Do not overwrite user changes without inspection. Preserve upstream Git history when feasible; otherwise document the source revision and import method.
3. Get upstream building unchanged first, then make minimal rebranding edits.
4. Resolve build dependencies and Windows CI failures. Verify the generated .vst3 artifact and exact location.
5. Add README with Windows build prerequisites, one-command build instructions where possible, install instructions, feature list, limitations, and upstream credits.
6. Record what was actually tested; never report Ableton-host verification unless tested inside Ableton.

## Acceptance criteria
- Repository includes complete buildable plugin source.
- GitHub Actions Windows build succeeds and publishes an installable VST3 artifact.
- Plugin presents as Simple Sampler in a VST3 host.
- Existing transcription and MIDI drag/export features are preserved.
- No unlicensed or noncommercial model weights are silently redistributed for commercial use.
- No placeholder UI or fake functionality.

## Product scope
Version 0.1 is a focused audio-to-MIDI utility, not a noteGRABBER clone. Build reliability and a usable Ableton workflow outrank extra features.
