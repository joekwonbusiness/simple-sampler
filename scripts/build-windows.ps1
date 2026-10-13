# Modified from NeuralNote's documented Windows build for Simple Sampler, 2026.
[CmdletBinding()]
param(
    [string]$BuildDirectory = "build",
    [switch]$CpuOnly,
    [switch]$WithStandalone,
    [switch]$EnableAsio
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

function Resolve-BuildTool {
    param([string]$Name, [string[]]$Candidates)

    foreach ($candidate in $Candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) {
            return $candidate
        }
    }

    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    throw "Required build tool '$Name' was not found. See README.md for prerequisites."
}

$cmake = Resolve-BuildTool "cmake.exe" @("C:\Program Files\CMake\bin\cmake.exe")
$ninja = Resolve-BuildTool "ninja.exe" @(
    "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe",
    (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\Ninja-build.Ninja_Microsoft.Winget.Source_8wekyb3d8bbwe\ninja.exe")
)
$python = Resolve-BuildTool "python.exe" @(
    (Join-Path $env:LOCALAPPDATA "Programs\Python\Python313\python.exe"),
    "C:\Windows\py.exe"
)
$clang = Resolve-BuildTool "clang-cl.exe" @("C:\Program Files\LLVM\bin\clang-cl.exe")
$llvmRc = Resolve-BuildTool "llvm-rc.exe" @("C:\Program Files\LLVM\bin\llvm-rc.exe")
$lld = Resolve-BuildTool "lld-link.exe" @("C:\Program Files\LLVM\bin\lld-link.exe")
$llvmLib = Resolve-BuildTool "llvm-lib.exe" @("C:\Program Files\LLVM\bin\llvm-lib.exe")

$vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path -LiteralPath $vswhere)) {
    throw "Visual Studio 2022 Build Tools were not found."
}

$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
$vcvars = Join-Path $vs "VC\Auxiliary\Build\vcvars64.bat"
$developerEnvironment = & $env:ComSpec /d /s /c ('"' + $vcvars + '" >nul && set')
if ($LASTEXITCODE -ne 0) {
    throw "vcvars64.bat failed with exit code $LASTEXITCODE"
}

foreach ($line in $developerEnvironment) {
    $parts = $line -split "=", 2
    if ($parts.Count -eq 2) {
        Set-Item -Path "Env:$($parts[0])" -Value $parts[1]
    }
}

$env:PATH = @(
    (Split-Path $python),
    (Split-Path $cmake),
    (Split-Path $ninja),
    (Split-Path $clang),
    $env:PATH
) -join [IO.Path]::PathSeparator
$env:CC = $clang
$env:CXX = $clang
$env:RC = $llvmRc

Push-Location $root
try {
    & git submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) {
        throw "git submodule update failed with exit code $LASTEXITCODE"
    }

    $buildPath = if ([IO.Path]::IsPathRooted($BuildDirectory)) {
        $BuildDirectory
    } else {
        Join-Path $root $BuildDirectory
    }

    $vulkanEnabled = -not $CpuOnly -and $env:VULKAN_SDK -and
        (Test-Path -LiteralPath (Join-Path $env:VULKAN_SDK "Bin\glslc.exe"))
    if (-not $vulkanEnabled -and -not $CpuOnly) {
        Write-Warning "Vulkan SDK was not found; building the CPU-only transcription backend."
    }

    $configure = @(
        "-S", $root,
        "-B", $buildPath,
        "-G", "Ninja",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_MAKE_PROGRAM=$ninja",
        "-DCMAKE_LINKER=$lld",
        "-DCMAKE_AR=$llvmLib",
        "-DLTO=ON",
        "-DNEURALNOTE_SYMBOLS=ON",
        "-DNEURALNOTE_ASIO=$($EnableAsio.IsPresent.ToString().ToUpperInvariant())",
        "-DBUILD_UNIT_TESTS=ON",
        "-DMUSCRIPTOR_BUILD_TESTS=OFF",
        "-DMUSCRIPTOR_VULKAN=$($vulkanEnabled.ToString().ToUpperInvariant())"
    )

    & $cmake @configure
    if ($LASTEXITCODE -ne 0) {
        throw "CMake configure failed with exit code $LASTEXITCODE"
    }

    $targets = @("SimpleSampler_VST3", "UnitTests")
    if ($WithStandalone) {
        $targets += "SimpleSampler_Standalone"
    }

    & $cmake --build $buildPath --target @targets --parallel
    if ($LASTEXITCODE -ne 0) {
        throw "Build failed with exit code $LASTEXITCODE"
    }

    $unitTests = Join-Path $buildPath "Tests\UnitTests_artefacts\Release\UnitTests.exe"
    & $unitTests
    if ($LASTEXITCODE -ne 0) {
        throw "Unit tests failed with exit code $LASTEXITCODE"
    }

    $artifact = Join-Path $buildPath "SimpleSampler_artefacts\Release\VST3\Simple Sampler.vst3"
    if (-not (Test-Path -LiteralPath $artifact)) {
        throw "Build completed without the expected VST3 bundle: $artifact"
    }

    Write-Host "Built: $artifact"
} finally {
    Pop-Location
}
