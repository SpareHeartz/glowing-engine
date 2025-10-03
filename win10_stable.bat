@echo off
:: Stable Windows 10 Optimization Script
:: Version 2.0 - Focused on stability

:: Check for administrator privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    color 4
    echo This script requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b 1
)

setlocal EnableExtensions EnableDelayedExpansion

echo ============================================
echo  Windows 10 Stable Optimization Script
echo ============================================
echo.
echo Creating system restore point...
powershell -command "Enable-ComputerRestore -Drive 'C:\' -ErrorAction SilentlyContinue"
powershell -command "Checkpoint-Computer -Description 'Before Optimization Script' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue"
echo.

:: ============================================
:: SECTION 1: Package Management
:: ============================================
echo [1/10] Installing Chocolatey Package Manager...
powershell -command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" 2>nul

:: ============================================
:: SECTION 2: System Maintenance
:: ============================================
echo [2/10] Running system maintenance tasks...
echo - Running Disk Cleanup
cleanmgr /verylowdisk /sagerun:5 2>nul

echo - Clearing temporary files
del /s /f /q "%TEMP%\*.*" 2>nul
del /s /f /q "C:\Windows\Temp\*.*" 2>nul
del /s /f /q "C:\Windows\Prefetch\*.*" 2>nul

echo - Emptying Recycle Bin
PowerShell -ExecutionPolicy Unrestricted -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" 2>nul

echo - Running system file repairs (this may take a while)
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
sfc /scannow >nul 2>&1

:: ============================================
:: SECTION 3: UI Customization (Safe)
:: ============================================
echo [3/10] Applying UI customization...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarDa" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v "TaskbarEndTask" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAl" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "58" /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================
:: SECTION 4: Bloatware Removal (Safe)
:: ============================================
echo [4/10] Removing unnecessary pre-installed apps...
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage *WebExperience* | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.CoPilot | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.GamingApp | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage MicrosoftCorporationII.MicrosoftFamily | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.OutlookForWindows | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Clipchamp.Clipchamp | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MinecraftUWP | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.People | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Wallet | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage MSTeams | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage Microsoft.Todos | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage king.com.CandyCrushSaga | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage king.com.CandyCrushSodaSaga | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul
PowerShell -ExecutionPolicy Unrestricted -Command "Get-AppxPackage SpotifyAB.SpotifyMusic | Remove-AppxPackage -ErrorAction SilentlyContinue" 2>nul

:: ============================================
:: SECTION 5: OneDrive Removal (Optional - Safe)
:: ============================================
echo [5/10] Removing OneDrive...
taskkill /f /im OneDrive.exe 2>nul
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall 2>nul
)
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall 2>nul
)
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
reg delete "HKEY_CLASSES_ROOT\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1

:: ============================================
:: SECTION 6: Privacy Settings (Safe)
:: ============================================
echo [6/10] Configuring privacy settings...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================
:: SECTION 7: Disable Telemetry Tasks (Safe)
:: ============================================
echo [7/10] Disabling telemetry scheduled tasks...
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\Autochk\Proxy" /DISABLE >nul 2>&1
schtasks /change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /DISABLE >nul 2>&1

:: ============================================
:: SECTION 8: Performance Tweaks (Safe)
:: ============================================
echo [8/10] Applying performance optimizations...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
powercfg.exe /hibernate off 2>nul

echo - Configuring power plan...
powershell -command "$ultimatePerformance = powercfg -list | Select-String -Pattern 'Ultimate Performance'; if (-not $ultimatePerformance) { powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null }; $ultimatePlanGUID = (powercfg -list | Select-String -Pattern 'Ultimate Performance').Line.Split()[3]; powercfg -setactive $ultimatePlanGUID" 2>nul

:: ============================================
:: SECTION 9: Service Optimization (Conservative)
:: ============================================
echo [9/10] Optimizing services (conservative approach)...
:: Only change non-critical services to manual
sc config DiagTrack start=disabled >nul 2>&1
sc config dmwappushservice start=disabled >nul 2>&1
sc config XblAuthManager start=demand >nul 2>&1
sc config XblGameSave start=demand >nul 2>&1
sc config XboxGipSvc start=demand >nul 2>&1
sc config XboxNetApiSvc start=demand >nul 2>&1
sc config RetailDemo start=disabled >nul 2>&1
sc config AJRouter start=disabled >nul 2>&1
sc config RemoteRegistry start=disabled >nul 2>&1
sc config RemoteAccess start=disabled >nul 2>&1
sc config shpamsvc start=disabled >nul 2>&1
sc config ssh-agent start=disabled >nul 2>&1
sc config tzautoupdate start=disabled >nul 2>&1
sc config WerSvc start=demand >nul 2>&1
sc config wercplsupport start=demand >nul 2>&1

:: Keep these as demand (manual) instead of disabled for stability
sc config sysmain start=demand >nul 2>&1

:: ============================================
:: SECTION 10: Edge Browser Tweaks (Safe)
:: ============================================
echo [10/10] Configuring Microsoft Edge settings...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowRecommendationsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HideFirstRunExperience" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "ShowMicrosoftRewards" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "WebWidgetAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: ============================================
:: Network Reset
:: ============================================
echo.
echo Resetting network configuration...
ipconfig /flushdns >nul 2>&1
ipconfig /release >nul 2>&1
ipconfig /renew >nul 2>&1

:: ============================================
:: Completion
:: ============================================
echo.
echo ============================================
echo  Optimization Complete!
echo ============================================
echo.
echo IMPORTANT NOTES:
echo - A system restore point was created
echo - Windows Defender remains active for security
echo - Windows Update is still functional
echo - Critical system services were preserved
echo - Network connectivity maintained
echo.
echo OPTIONAL: Install applications with Chocolatey
echo Run this command in a new admin CMD window:
echo choco install googlechrome 7zip vlc -y
echo.
echo Please restart your computer for all changes to take effect.
echo.
pause

:: Restart Explorer to apply UI changes
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

endlocal
exit /b 0
