@echo off
echo ============================================================
echo  IT Operations Dashboard - Webserver
echo ============================================================
echo.
echo  Open je browser op: http://localhost:8080
echo  Stop de server met Ctrl+C in dit venster.
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0Start-Dashboard.ps1.txt" -OutputBase "D:\output" -Port 8080
