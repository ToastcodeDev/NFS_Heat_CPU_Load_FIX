@echo off
setlocal EnableExtensions EnableDelayedExpansion
title L90 CPU Fixer
cd /d "%~dp0"

set "CONFIG_FILE=%~dp0properties.cfg"

if not exist "%CONFIG_FILE%" (
    (
        echo LANGUAGE=EN
        echo VERSION=1.0
        echo DEBUG=0
    ) > "%CONFIG_FILE%"
)

set "LANG=EN"
set "DEBUG=0"

for /f "usebackq tokens=1,* delims==" %%A in ("%CONFIG_FILE%") do (
    if /i "%%A"=="LANGUAGE" set "LANG=%%B"
    if /i "%%A"=="DEBUG" set "DEBUG=%%B"
)

set "LANG=!LANG: =!"
set "DEBUG=!DEBUG: =!"

if not "!DEBUG!"=="1" set "DEBUG=0"

:MENU
call :SET_TEXTS

cls
echo =============================
echo L90Fixer - NFS Unbound / Others
echo =============================
echo.
echo [1] !TXT_RUN_FIX!
echo [2] !TXT_CHANGE_LANG!
echo [4] !TXT_EXIT!
echo.
set /p "MENU_OPT=!TXT_SELECT! ^> "

if "!MENU_OPT!"=="1" goto RUN_FIX
if "!MENU_OPT!"=="2" goto CHANGE_LANGUAGE
if "!MENU_OPT!"=="3" goto TOGGLE_DEBUG
if "!MENU_OPT!"=="4" goto EXIT_SCRIPT
goto MENU

:CHANGE_LANGUAGE
cls
echo =============================
echo   Change Language / Cambiar Idioma
echo =============================
echo.
echo [1] English (EN)
echo [2] Spanish (ES)
echo.
echo !TXT_CURRENT_LANG!: !LANG!
echo.
set /p "OPT=!TXT_CHOOSE_LANG!"

if "!OPT!"=="2" (
    set "LANG=ES"
) else if "!OPT!"=="1" (
    set "LANG=EN"
) else (
    goto CHANGE_LANGUAGE
)

(
    echo LANGUAGE=!LANG!
    echo VERSION=1.0
    echo DEBUG=!DEBUG!
) > "%CONFIG_FILE%"

cls
if /i "!LANG!"=="ES" (
    echo Idioma cambiado exitosamente a: Espanol
) else (
    echo Language successfully changed to: English
)
timeout /t 2 >nul
goto MENU

:TOGGLE_DEBUG
cls
echo =============================
echo   !TXT_DEBUG_MODE!
echo =============================
echo.

if "!DEBUG!"=="1" (
    set "DEBUG=0"
    if /i "!LANG!"=="ES" (
        echo Modo DEBUG desactivado
        echo.
        echo El programa funcionara normalmente.
    ) else (
        echo DEBUG mode disabled
        echo.
        echo The program will run normally.
    )
) else (
    set "DEBUG=1"
    if /i "!LANG!"=="ES" (
        echo Modo DEBUG activado
        echo.
        echo Veras informacion detallada durante la ejecucion.
    ) else (
        echo DEBUG mode enabled
        echo.
        echo You will see detailed information during execution.
    )
)

(
    echo LANGUAGE=!LANG!
    echo VERSION=1.0
    echo DEBUG=!DEBUG!
) > "%CONFIG_FILE%"

timeout /t 2 >nul
goto MENU

:DEBUG_PANEL
cls
echo ========================================
echo   DEBUG PANEL / PANEL DE DEPURACION
echo ========================================
echo.
echo [1] !TXT_DEBUG_TEST_CPU!
echo [2] !TXT_DEBUG_MANUAL_INPUT!
echo [3] !TXT_DEBUG_VIEW_CONFIG!
echo [4] !TXT_DEBUG_SHOW_VARS!
echo [5] !TXT_DEBUG_CONTINUE!
echo [6] !TXT_DEBUG_ABORT!
echo.
set /p "DEBUG_OPT=DEBUG ^> "

if "!DEBUG_OPT!"=="1" goto DEBUG_TEST_CPU
if "!DEBUG_OPT!"=="2" goto CPU_FAIL
if "!DEBUG_OPT!"=="3" goto DEBUG_VIEW_CONFIG
if "!DEBUG_OPT!"=="4" goto DEBUG_SHOW_VARS
if "!DEBUG_OPT!"=="5" goto DEBUG_CONTINUE
if "!DEBUG_OPT!"=="6" goto MENU
goto DEBUG_PANEL

:DEBUG_TEST_CPU
cls
echo ========================================
echo   CPU Detection Test
echo ========================================
echo.
echo CPU_CORES detected: !CPU_CORES!
echo CPU_THREADS detected: !CPU_THREADS!
echo.
echo Press any key to return to DEBUG panel...
pause >nul
goto DEBUG_PANEL

:DEBUG_VIEW_CONFIG
cls
echo ========================================
echo   Configuration File
echo ========================================
echo.
echo File: %CONFIG_FILE%
echo.
type "%CONFIG_FILE%"
echo.
echo ========================================
echo Press any key to return to DEBUG panel...
pause >nul
goto DEBUG_PANEL

:DEBUG_SHOW_VARS
cls
echo ========================================
echo   Current Variables
echo ========================================
echo.
echo LANG=!LANG!
echo DEBUG=!DEBUG!
echo CPU_CORES=!CPU_CORES!
echo CPU_THREADS=!CPU_THREADS!
echo GAME_PATH=!GAME_PATH!
echo CONFIG_FILE=%CONFIG_FILE%
echo CFG_FILE=!CFG_FILE!
echo.
echo ========================================
echo Press any key to return to DEBUG panel...
pause >nul
goto DEBUG_PANEL

:DEBUG_CONTINUE
exit /b

:RUN_FIX
if "!DEBUG!"=="1" (
    cls
    echo ========================================
    echo   DEBUG MODE ACTIVE
    echo ========================================
    echo.
    echo Starting CPU Fix process...
    echo Press any key to continue...
    pause >nul
)

cls
echo !TXT_GET_CPU!
timeout /t 1 >nul

set "CPU_CORES="
set "CPU_THREADS="

for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "try { (Get-CimInstance Win32_Processor | Select-Object -First 1).NumberOfCores } catch { exit 1 }" 2^>nul`) do (
    set "CPU_CORES=%%A"
)

for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "try { (Get-CimInstance Win32_Processor | Select-Object -First 1).NumberOfLogicalProcessors } catch { exit 1 }" 2^>nul`) do (
    set "CPU_THREADS=%%A"
)

if not defined CPU_CORES (
    for /f "tokens=2 delims==" %%A in ('wmic cpu get NumberOfCores /value 2^>nul ^| find "="') do (
        set "CPU_CORES=%%A"
    )
)

if not defined CPU_THREADS (
    for /f "tokens=2 delims==" %%A in ('wmic cpu get NumberOfLogicalProcessors /value 2^>nul ^| find "="') do (
        set "CPU_THREADS=%%A"
    )
)

set "CPU_CORES=!CPU_CORES: =!"
set "CPU_THREADS=!CPU_THREADS: =!"

if not defined CPU_CORES goto CPU_FAIL
if not defined CPU_THREADS goto CPU_FAIL

if "!DEBUG!"=="1" (
    call :DEBUG_PANEL
)

cls
echo =============================
echo   !TXT_CPU!
echo =============================
echo !TXT_CORES!  : !CPU_CORES!
echo !TXT_THREADS!: !CPU_THREADS!
echo =============================
echo.
echo !TXT_CONT!
timeout /t 2 >nul

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] About to open folder selector...
    pause
)

cls
echo !TXT_OPEN_EXPLORER!
echo.

set "GAME_PATH="

for /f "usebackq delims=" %%A in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Select game folder'; if($f.ShowDialog() -eq 'OK'){ $f.SelectedPath }"`) do (
    set "GAME_PATH=%%A"
)

if not defined GAME_PATH (
    echo.
    echo !TXT_CANCEL!
    timeout /t 2 >nul
    goto MENU
)

set "CFG_FILE=!GAME_PATH!\user.cfg"

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] Config file path: !CFG_FILE!
    pause
)

if exist "!CFG_FILE!" (
    copy "!CFG_FILE!" "!CFG_FILE!.bak" >nul 2>&1
)

(
    echo Thread.ProcessorCount !CPU_CORES!
    echo Thread.MaxProcessorCount !CPU_CORES!
    echo Thread.MinFreeProcessorCount 0
    echo Thread.JobThreadPriority 0
    echo GstRender.Thread.MaxProcessorCount !CPU_THREADS!
) > "!CFG_FILE!"

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] user.cfg content:
    echo ========================================
    type "!CFG_FILE!"
    echo ========================================
    pause
)

cls
if exist "!CFG_FILE!" (
    echo =============================
    echo   !TXT_SUCCESS!
    echo =============================
    echo.
    echo !TXT_CREATED!
    echo.
    echo !TXT_PATH!: !CFG_FILE!
    echo.
    if exist "!CFG_FILE!.bak" (
        echo !TXT_BACKUP!: !CFG_FILE!.bak
    )
) else (
    echo =============================
    echo   !TXT_ERROR!
    echo =============================
    echo.
    echo !TXT_FAILED!
)
echo.
pause
goto MENU

:CPU_FAIL
cls
echo =============================
echo   !TXT_CPU_ERROR!
echo =============================
echo.
echo !TXT_MANUAL_INPUT!
echo.
echo !TXT_EXAMPLE!:
echo   AMD Ryzen 5 5600X
echo   !TXT_CORES!: 6
echo   !TXT_THREADS!: 12
echo.
echo =============================
echo.

:INPUT_CORES
set "CPU_CORES="
set /p "CPU_CORES=!TXT_ENTER_CORES! ^> "

if not defined CPU_CORES goto INPUT_CORES

set "IS_VALID=0"
for /f "delims=0123456789" %%i in ("!CPU_CORES!") do set "IS_VALID=1"

if "!IS_VALID!"=="1" (
    echo !TXT_INVALID_NUMBER!
    echo.
    goto INPUT_CORES
)

if !CPU_CORES! LEQ 0 (
    echo !TXT_INVALID_NUMBER!
    echo.
    goto INPUT_CORES
)

:INPUT_THREADS
set "CPU_THREADS="
set /p "CPU_THREADS=!TXT_ENTER_THREADS! ^> "

if not defined CPU_THREADS goto INPUT_THREADS

set "IS_VALID=0"
for /f "delims=0123456789" %%i in ("!CPU_THREADS!") do set "IS_VALID=1"

if "!IS_VALID!"=="1" (
    echo !TXT_INVALID_NUMBER!
    echo.
    goto INPUT_THREADS
)

if !CPU_THREADS! LEQ 0 (
    echo !TXT_INVALID_NUMBER!
    echo.
    goto INPUT_THREADS
)

if !CPU_THREADS! LSS !CPU_CORES! (
    echo.
    echo !TXT_THREADS_ERROR!
    echo.
    pause
    goto INPUT_THREADS
)

echo.
echo !TXT_MANUAL_CONFIRM!
echo !TXT_CORES!: !CPU_CORES!
echo !TXT_THREADS!: !CPU_THREADS!
echo.
pause

cls
echo =============================
echo   !TXT_CPU!
echo =============================
echo !TXT_CORES!  : !CPU_CORES!
echo !TXT_THREADS!: !CPU_THREADS!
echo =============================
echo.
echo !TXT_CONT!
timeout /t 2 >nul

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] About to open folder selector...
    pause
)

cls
echo !TXT_OPEN_EXPLORER!
echo.

set "GAME_PATH="

for /f "usebackq delims=" %%A in (`powershell -NoProfile -STA -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Select game folder'; if($f.ShowDialog() -eq 'OK'){ $f.SelectedPath }"`) do (
    set "GAME_PATH=%%A"
)

if not defined GAME_PATH (
    echo.
    echo !TXT_CANCEL!
    timeout /t 2 >nul
    goto MENU
)

set "CFG_FILE=!GAME_PATH!\user.cfg"

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] Config file path: !CFG_FILE!
    pause
)

if exist "!CFG_FILE!" (
    copy "!CFG_FILE!" "!CFG_FILE!.bak" >nul 2>&1
)

(
    echo Thread.ProcessorCount !CPU_CORES!
    echo Thread.MaxProcessorCount !CPU_CORES!
    echo Thread.MinFreeProcessorCount 0
    echo Thread.JobThreadPriority 0
    echo GstRender.Thread.MaxProcessorCount !CPU_THREADS!
) > "!CFG_FILE!"

if "!DEBUG!"=="1" (
    echo.
    echo [DEBUG] user.cfg content:
    echo ========================================
    type "!CFG_FILE!"
    echo ========================================
    pause
)

cls
if exist "!CFG_FILE!" (
    echo =============================
    echo   !TXT_SUCCESS!
    echo =============================
    echo.
    echo !TXT_CREATED!
    echo.
    echo !TXT_PATH!: !CFG_FILE!
    echo.
    if exist "!CFG_FILE!.bak" (
        echo !TXT_BACKUP!: !CFG_FILE!.bak
    )
) else (
    echo =============================
    echo   !TXT_ERROR!
    echo =============================
    echo.
    echo !TXT_FAILED!
)
echo.
pause
goto MENU

:EXIT_SCRIPT
cls
if /i "!LANG!"=="ES" (
    echo Gracias por usar L90 CPU Fix!
) else (
    echo Thank you for using L90 CPU Fix!
)
timeout /t 2 >nul
endlocal
exit /b

:SET_TEXTS
if /i "!LANG!"=="ES" (
    set "TXT_RUN_FIX=Ejecutar Fix de CPU"
    set "TXT_CHANGE_LANG=Cambiar idioma"
    set "TXT_TOGGLE_DEBUG=Modo DEBUG"
    set "TXT_EXIT=Salir"
    set "TXT_SELECT=Selecciona una opcion"
    set "TXT_CURRENT_LANG=Idioma actual"
    set "TXT_DEBUG_MODE=Modo DEBUG"
    set "TXT_ENABLED=ACTIVADO"
    set "TXT_DISABLED=DESACTIVADO"
    set "TXT_DEBUG_TEST_CPU=Probar deteccion de CPU"
    set "TXT_DEBUG_MANUAL_INPUT=Forzar entrada manual"
    set "TXT_DEBUG_VIEW_CONFIG=Ver configuracion"
    set "TXT_DEBUG_SHOW_VARS=Mostrar variables"
    set "TXT_DEBUG_CONTINUE=Continuar"
    set "TXT_DEBUG_ABORT=Volver al menu"
    set "TXT_GET_CPU=Detectando CPU..."
    set "TXT_CPU=CPU detectada"
    set "TXT_CORES=Nucleos"
    set "TXT_THREADS=Hilos"
    set "TXT_CONT=Continuando..."
    set "TXT_OPEN_EXPLORER=Selecciona la carpeta del juego..."
    set "TXT_CREATED=Archivo creado exitosamente"
    set "TXT_FAILED=No se pudo crear el archivo"
    set "TXT_CANCEL=Operacion cancelada"
    set "TXT_PATH=Ubicacion"
    set "TXT_BACKUP=Respaldo creado en"
    set "TXT_SUCCESS=Exito"
    set "TXT_ERROR=Error"
    set "TXT_CPU_ERROR=No se pudo detectar la CPU"
    set "TXT_MANUAL_INPUT=Ingresa los valores manualmente:"
    set "TXT_EXAMPLE=Ejemplo"
    set "TXT_ENTER_CORES=Numero de nucleos"
    set "TXT_ENTER_THREADS=Numero de hilos"
    set "TXT_INVALID_NUMBER=Error: Ingresa un numero valido (mayor a 0)"
    set "TXT_THREADS_ERROR=Error: Los hilos deben ser mayor o igual a los nucleos"
    set "TXT_MANUAL_CONFIRM=Valores confirmados:"
    set "TXT_CHOOSE_LANG=Elige idioma ^> "
) else (
    set "TXT_RUN_FIX=Run CPU Fix"
    set "TXT_CHANGE_LANG=Change language"
    set "TXT_TOGGLE_DEBUG=DEBUG Mode"
    set "TXT_EXIT=Exit"
    set "TXT_SELECT=Select an option"
    set "TXT_CURRENT_LANG=Current language"
    set "TXT_DEBUG_MODE=DEBUG Mode"
    set "TXT_ENABLED=ENABLED"
    set "TXT_DISABLED=DISABLED"
    set "TXT_DEBUG_TEST_CPU=Test CPU detection"
    set "TXT_DEBUG_MANUAL_INPUT=Force manual input"
    set "TXT_DEBUG_VIEW_CONFIG=View configuration"
    set "TXT_DEBUG_SHOW_VARS=Show variables"
    set "TXT_DEBUG_CONTINUE=Continue"
    set "TXT_DEBUG_ABORT=Return to menu"
    set "TXT_GET_CPU=Detecting CPU..."
    set "TXT_CPU=CPU detected"
    set "TXT_CORES=Cores"
    set "TXT_THREADS=Threads"
    set "TXT_CONT=Continuing..."
    set "TXT_OPEN_EXPLORER=Select game folder..."
    set "TXT_CREATED=File created successfully"
    set "TXT_FAILED=Failed to create file"
    set "TXT_CANCEL=Operation cancelled"
    set "TXT_PATH=Location"
    set "TXT_BACKUP=Backup created at"
    set "TXT_SUCCESS=Success"
    set "TXT_ERROR=Error"
    set "TXT_CPU_ERROR=Could not detect CPU"
    set "TXT_MANUAL_INPUT=Enter values manually:"
    set "TXT_EXAMPLE=Example"
    set "TXT_ENTER_CORES=Number of cores"
    set "TXT_ENTER_THREADS=Number of threads"
    set "TXT_INVALID_NUMBER=Error: Enter a valid number (greater than 0)"
    set "TXT_THREADS_ERROR=Error: Threads must be greater than or equal to cores"
    set "TXT_MANUAL_CONFIRM=Values confirmed:"
    set "TXT_CHOOSE_LANG=Choose language ^> "
)
exit /b