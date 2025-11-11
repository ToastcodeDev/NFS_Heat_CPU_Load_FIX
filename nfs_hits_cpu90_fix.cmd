@echo off
title Fix 90%% load for NEED FOR SPEED HEAT by Octanium, Toastcode
setlocal enabledelayedexpansion

set "UserCFGFileCDDir=%~dp0"
set "UserCFGFileName=user.cfg"
set "UserCFGFile=%UserCFGFileCDDir%%UserCFGFileName%"

rem ======== Using PowerShell Method =========
for /f %%a in ('powershell -command "(Get-CimInstance Win32_Processor).NumberOfCores"') do set "CPU_Cores=%%a"
for /f %%a in ('powershell -command "(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors"') do set "CPU_Threads=%%a"

if "%CPU_Cores%"=="" goto oops_a
if "%CPU_Threads%"=="" goto oops_a

echo.
echo    Fix 90%% CPU load!
echo    For game NEED FOR SPEED HEAT
echo    by Octanium and Toastcode
echo.    
echo  ==== Your CPU ====
echo   CPU cores  : %CPU_Cores%
echo   CPU threads: %CPU_Threads%
echo  ==================
echo.

rem ======== Crear user.cfg =========
if exist "%UserCFGFile%" (
    if exist "%UserCFGFileCDDir%%UserCFGFileName%.bak" (
        del "%UserCFGFile%" /q /f
    ) else (
        rename "%UserCFGFileCDDir%%UserCFGFileName%" "%UserCFGFileName%.bak"
    )   
)

(
echo Thread.ProcessorCount %CPU_Cores%
echo Thread.MaxProcessorCount %CPU_Cores%
echo Thread.MinFreeProcessorCount 0
echo Thread.JobThreadPriority 0
echo GstRender.Thread.MaxProcessorCount %CPU_Threads%
) > "%UserCFGFile%"

if exist "%UserCFGFile%" (
    echo.
    echo  =============================
    echo   File user.cfg created!
    echo  =============================
) else (
    echo.
    echo  =============================
    echo   File user.cfg NOT created!
    echo  =============================
)
pause
exit

:oops_a
cls
echo.
echo  =============================================
echo    Oooops something went wrong :( (code: a)
echo  =============================================
echo.
pause
exit
