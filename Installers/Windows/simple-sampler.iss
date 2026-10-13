; Modified from NeuralNote for the Simple Sampler distribution, 2026.
#ifndef ReleaseDir
#define ReleaseDir "build/SimpleSampler_artefacts/Release"
#endif

[Setup]
; Identifies this product across versions; must never change.
AppId={{A4E8C906-78DD-4B67-A9A5-6E48374881EC}
AppName=Simple Sampler
AppVersion=0.1.0
OutputBaseFilename=SimpleSamplerInstaller
DefaultDirName={commonpf}\Simple Sampler
DisableProgramGroupPage=yes
InfoBeforeFile=..\readme.txt
LicenseFile=..\license.txt
AppPublisher=Simple Sampler
AppPublisherURL=https://github.com/joekwonbusiness/simple-sampler
AppSupportURL=https://github.com/joekwonbusiness/simple-sampler/issues
AppUpdatesURL=https://github.com/joekwonbusiness/simple-sampler/releases
AlwaysShowComponentsList=yes
Compression=lzma
SolidCompression=yes
DisableDirPage=yes
UninstallDisplayIcon={app}\Simple Sampler.exe
AppCopyright=Simple Sampler contributors; based on NeuralNote, Copyright 2026 Damien Ronssin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Types]
Name: "custom"; Description: "Custom Installation"; Flags: iscustom

[Components]
Name: "mainapp"; Description: "Simple Sampler Standalone"; Types: custom; Flags: disablenouninstallwarning
Name: "plugin"; Description: "Simple Sampler VST3"; Types: custom; Flags: disablenouninstallwarning

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Components: mainapp; Flags: unchecked

[Files]
Source: "..\..\{#ReleaseDir}\Standalone\Simple Sampler.exe"; DestDir: "{app}"; Components:mainapp; Flags: ignoreversion recursesubdirs;
Source: "..\..\{#ReleaseDir}\VST3\Simple Sampler.vst3\*"; DestDir: "{commoncf}\VST3\Simple Sampler.vst3"; Components:plugin; Flags: ignoreversion recursesubdirs;

[Icons]
Name: "{autoprograms}\Simple Sampler"; Filename: "{app}\Simple Sampler.exe"; Components: mainapp
Name: "{autodesktop}\Simple Sampler"; Filename: "{app}\Simple Sampler.exe"; Tasks: desktopicon

[Code]
// Models, recordings and settings live in the user's profile, not in {app}. Only the profile
// of the user running the uninstaller is cleaned, and a silent uninstall keeps the data.
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  DataDir: String;
begin
  if CurUninstallStep <> usPostUninstall then
    Exit;

  DelTree(AddBackslash(GetTempDir) + 'simple-sampler', True, True, True);

  DataDir := ExpandConstant('{userappdata}\Simple Sampler');
  if DirExists(DataDir) and not UninstallSilent then
    if MsgBox('Also delete Simple Sampler''s downloaded models, recordings and settings?' + #13#10#13#10 + DataDir,
              mbConfirmation, MB_YESNO) = IDYES then
      DelTree(DataDir, True, True, True);
end;
