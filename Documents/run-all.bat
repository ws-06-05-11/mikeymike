@echo off
echo ============================================================
echo  Script runner - Output naar D:\output\Source1 t/m Source4
echo ============================================================
echo.

echo [1/4] Get-RegistryValue...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-RegistryValue.ps1.txt" -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
echo.

echo [2/4] Get-OrchestratorRunbooks...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-OrchestratorRunbooks.ps1.txt" -OrchestratorServer "orch01.bedrijf.local"
echo.

echo [3/4] Get-IisApplicationVersion...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-IisApplicationVersion.ps1.txt"
echo.

echo [4/4] Get-SccmBuildReport...
powershell -ExecutionPolicy Bypass -File "%~dp0Get-SccmBuildReport.ps1.txt" -SiteServer "sccm01.bedrijf.local"
echo.

echo ============================================================
echo  Klaar. Controleer D:\output\Source1 t/m Source4 voor output.
echo ============================================================
pause
