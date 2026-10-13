# Package Simple Sampler for Windows

The supported v0.1 deliverable is the Windows x64 VST3 bundle. The GitHub Actions workflow in
`.github/workflows/build_windows.yml` builds it with Vulkan enabled, validates its metadata and PE architecture, and
uploads `Simple-Sampler-Windows-x64-VST3` as an installable artifact.

For a local build, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-windows.ps1 -WithStandalone
```

The complete bundles appear under `build/SimpleSampler_artefacts/Release/`.

An optional Inno Setup definition is kept at `Installers/Windows/simple-sampler.iss`. After building the VST3 and
standalone targets and installing Inno Setup 6, run `.github/scripts/package_windows.py` to produce
`Installers/Windows/Output/SimpleSamplerInstaller.exe`. The GitHub Actions artifact uses direct VST3 installation and
does not depend on this unsigned installer.

The inherited macOS packaging source is retained for upstream provenance, but Simple Sampler v0.1 does not publish or
claim a validated macOS package.
