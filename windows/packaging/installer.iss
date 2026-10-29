; GrammarGuard installer. Built by tool/release.sh with Inno Setup:
;   ISCC /DAppVersion=1.2.3 /DSourceDir=build\windows\x64\runner\Release windows\packaging\installer.iss
; Installs per user (no administrator prompt), like most desktop tools.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

[Setup]
AppId={{6F1C2B5E-7A41-4C8E-9D0A-3B5E8C1F2A94}
AppName=GrammarGuard
AppVersion={#AppVersion}
AppPublisher=Gabber235
AppPublisherURL=https://github.com/gabber235/GrammarGuard
AppSupportURL=https://github.com/gabber235/GrammarGuard/issues
AppUpdatesURL=https://github.com/gabber235/GrammarGuard/releases
DefaultDirName={localappdata}\Programs\GrammarGuard
DefaultGroupName=GrammarGuard
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\..\dist
OutputBaseFilename=GrammarGuard-windows-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\GrammarGuard.exe
LicenseFile=..\..\LICENSE
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=yes

[Tasks]
Name: "startup"; Description: "Start GrammarGuard when I sign in"; GroupDescription: "Startup:"
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\GrammarGuard"; Filename: "{app}\GrammarGuard.exe"
Name: "{autodesktop}\GrammarGuard"; Filename: "{app}\GrammarGuard.exe"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "GrammarGuard"; ValueData: """{app}\GrammarGuard.exe"" --background"; Flags: uninsdeletevalue; Tasks: startup

[Run]
Filename: "{app}\GrammarGuard.exe"; Description: "{cm:LaunchProgram,GrammarGuard}"; Flags: nowait postinstall skipifsilent
