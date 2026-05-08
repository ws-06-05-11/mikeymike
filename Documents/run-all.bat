@echo off
setlocal enabledelayedexpansion
echo ============================================================
echo  IT Operations Script Runner
echo ============================================================
echo.

REM === CONFIGURATIE - pas aan voor jouw omgeving ===
set "ORCH_SERVER=orch01.bedrijf.local"
set "SCCM_SERVER=sccm01.bedrijf.local"
set "REG_PATH=HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
set "OUTPUT_BASE=D:\output"
set "SERVERS_FILE=%~dp0servers.txt"

REM === servers.txt controleren ===
if not exist "%SERVERS_FILE%" (
    echo FOUT: servers.txt niet gevonden in %~dp0
    echo Maak servers.txt aan met een servernaam per regel.
    pause
    exit /b 1
)
echo Servers inladen uit: %SERVERS_FILE%
echo.

echo [1/5] Get-RegistryValue ^(servers uit servers.txt^)...
powershell -ExecutionPolicy Bypass -Command "$servers = (Get-Content -Path '%SERVERS_FILE%').Where({$_.Trim() -ne '' -and $_ -notmatch '^#'}); Write-Host ('  Servers: ' + ($servers -join ', ')); & '%~dp0Get-RegistryValue.ps1.txt' -ComputerName $servers -Path '%REG_PATH%'"
echo.

echo [2/5] Get-OrchestratorRunbooks ^(%ORCH_SERVER%^)...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-OrchestratorRunbooks.ps1.txt" -OrchestratorServer "%ORCH_SERVER%"
echo.

echo [3/5] Get-IisApplicationVersion ^(servers uit servers.txt^)...
powershell -ExecutionPolicy Bypass -Command "$servers = (Get-Content -Path '%SERVERS_FILE%').Where({$_.Trim() -ne '' -and $_ -notmatch '^#'}); Write-Host ('  Servers: ' + ($servers -join ', ')); & '%~dp0Get-IisApplicationVersion.ps1.txt' -ComputerName $servers"
echo.

echo [4/5] Get-SccmBuildReport ^(%SCCM_SERVER%^)...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-SccmBuildReport.ps1.txt" -SiteServer "%SCCM_SERVER%"
echo.

echo [5/5] Dashboard genereren...
powershell -ExecutionPolicy Bypass -File "%~dp0Generate-Dashboard.ps1.txt" -OutputBase "%OUTPUT_BASE%"
echo.

echo ============================================================
echo  Klaar! Dashboard: %OUTPUT_BASE%\dashboard.html
echo ============================================================
pause
