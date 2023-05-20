; Install scrcpy_light_launcher
; for NSIS installer 
;--------------------------------

; only to be able to use IF for the uninstaller of previous versions
!include LogicLib.nsh

; The name of the installer
Name "Scrcpy light launcher"

; The file to write
OutFile "scrcpy_light_launcher_INSTALLER.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\scrcpy_light_launcher

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\scrcpy_light_launcher" "Install_Dir"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

;---- Uninstall previous version ----
; The "" makes the section hidden.
Section "" SecUninstallPrevious
    Call UninstallPrevious
SectionEnd


; The stuff to install
Section "Scrcpy light launcher (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "bin\" *.*
  
  ; Write the installation path into the registry
  WriteRegStr HKLM Software\scrcpy_light_launcher "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\scrcpy_light_launcher" "DisplayName" "scrcpy_light_launcher"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\scrcpy_light_launcher" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\scrcpy_light_launcher" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\scrcpy_light_launcher" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\scrcpy_light_launcher"
  CreateShortcut "$SMPROGRAMS\scrcpy_light_launcher\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$SMPROGRAMS\scrcpy_light_launcher\scrcpy_light_launcher.lnk" "$INSTDIR\scrcpy_light_launcher.exe"
  
  ; desktop
  
  CreateShortcut "$DESKTOP\scrcpy_light_launcher.lnk" "$INSTDIR\scrcpy_light_launcher.exe"

SectionEnd

; helper to uninstall previous versions
Function UninstallPrevious

    ; Check for uninstaller.
    ReadRegStr $R0 HKLM Software\scrcpy_light_launcher "Install_Dir"

    ${If} $R0 == "" 
		DetailPrint "No previous installation detected." 	
        Goto Done
    ${EndIf}

	DetailPrint "Removing previous installation."    

    ; Run the uninstaller silently.
    ExecWait '"$R0\Uninstall.exe /S"'

    Done:

FunctionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\scrcpy_light_launcher"
  DeleteRegKey HKLM "Software\scrcpy_light_launcher"

  ; Remove files and uninstaller
  Delete $INSTDIR\*.*
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\scrcpy_light_launcher\*.lnk"
  Delete "$DESKTOP\scrcpy_light_launcher.lnk"

  ; Remove directories
  RMDir "$SMPROGRAMS\scrcpy_light_launcher"
  RMDir "$INSTDIR"

SectionEnd


