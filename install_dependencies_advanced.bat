@echo off
setlocal enabledelayedexpansion

echo ========================================
echo  OptiScaler Advanced Dependency Installer
echo ========================================
echo.
echo This script will download and install all required dependencies
echo for building OptiScaler on Windows, with fallback methods.
echo.

REM Check if we're in the right directory
if not exist "OptiScaler.sln" (
    echo ERROR: Please run this script from the OptiScaler root directory!
    echo.
    pause
    exit /b 1
)

REM Create external directory if it doesn't exist
if not exist "external" mkdir external

echo Checking current dependency status...
echo.

REM Function to download and extract a dependency
:downloadDependency
set "depName=%~1"
set "depUrl=%~2"
set "depPath=%~3"
set "depFile=%~4"
set "depExtractPath=%~5"

if exist "%depPath%\%depFile%" (
    echo [OK] %depName% already exists
    goto :eof
)

echo [DOWNLOADING] %depName%...
echo URL: %depUrl%

REM Try to download using PowerShell
powershell -Command "& {try { Invoke-WebRequest -Uri '%depUrl%' -OutFile '%depName%.zip' -UseBasicParsing; Write-Host 'Download successful' } catch { Write-Host 'Download failed: ' + $_.Exception.Message; exit 1 }}"

if %errorlevel% neq 0 (
    echo ERROR: Failed to download %depName%!
    echo Please download manually from: %depUrl%
    echo.
    goto :eof
)

REM Extract the downloaded file
echo Extracting %depName%...
powershell -Command "& {try { Expand-Archive -Path '%depName%.zip' -DestinationPath 'temp_extract' -Force; Write-Host 'Extraction successful' } catch { Write-Host 'Extraction failed: ' + $_.Exception.Message; exit 1 }}"

if %errorlevel% neq 0 (
    echo ERROR: Failed to extract %depName%!
    del "%depName%.zip" 2>nul
    goto :eof
)

REM Move to correct location
if exist "%depExtractPath%" (
    if exist "%depPath%" rmdir /s /q "%depPath%"
    move "%depExtractPath%" "%depPath%"
) else (
    echo WARNING: Expected extraction path not found for %depName%
)

REM Clean up
del "%depName%.zip" 2>nul
if exist "temp_extract" rmdir /s /q "temp_extract"

echo [OK] %depName% installed successfully
echo.
goto :eof

REM Try git submodules first
echo Attempting to use git submodules...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    if not exist "external\spdlog\.git" (
        echo Initializing git submodules...
        git submodule init
        git submodule update --init --recursive
        if %errorlevel% equ 0 (
            echo Git submodules initialized successfully!
            goto :checkDependencies
        )
    ) else (
        echo Updating existing git submodules...
        git submodule update --recursive
        if %errorlevel% equ 0 (
            echo Git submodules updated successfully!
            goto :checkDependencies
        )
    )
)

echo Git submodules failed or unavailable, using direct downloads...
echo.

REM Download dependencies directly
call :downloadDependency "spdlog" "https://github.com/gabime/spdlog/archive/refs/heads/v1.13.0.zip" "external\spdlog" "spdlog.h" "spdlog-1.13.0"
call :downloadDependency "simpleini" "https://github.com/brofield/simpleini/archive/refs/heads/master.zip" "external\simpleini" "SimpleIni.h" "simpleini-master"
call :downloadDependency "unordered_dense" "https://github.com/martinus/unordered_dense/archive/refs/heads/master.zip" "external\unordered_dense" "unordered_dense.hpp" "unordered_dense-master"
call :downloadDependency "vulkan" "https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/heads/main.zip" "external\vulkan" "vulkan.h" "Vulkan-Headers-main"
call :downloadDependency "FidelityFX-SDK" "https://github.com/GPUOpen-LibrariesAndSDKs/FidelityFX-SDK/archive/refs/heads/main.zip" "external\FidelityFX-SDK" "FidelityFX.h" "FidelityFX-SDK-main"
call :downloadDependency "magic_enum" "https://github.com/Neargye/magic_enum/archive/refs/heads/master.zip" "external\magic_enum" "magic_enum.hpp" "magic_enum-master"
call :downloadDependency "xess" "https://github.com/intel/xess/archive/refs/heads/main.zip" "external\xess" "xess.h" "xess-main"

:checkDependencies
echo.
echo Checking dependency status...
echo.

set missingDeps=0

if not exist "external\spdlog\include\spdlog\spdlog.h" (
    if exist "external\spdlog\spdlog\spdlog.h" (
        echo [FIXING] spdlog structure...
        if not exist "external\spdlog\include" mkdir "external\spdlog\include"
        move "external\spdlog\spdlog" "external\spdlog\include\"
    ) else (
        echo [MISSING] spdlog headers
        set missingDeps=1
    )
) else (
    echo [OK] spdlog
)

if not exist "external\simpleini\simpleini\SimpleIni.h" (
    if exist "external\simpleini\SimpleIni.h" (
        echo [FIXING] simpleini structure...
        if not exist "external\simpleini\simpleini" mkdir "external\simpleini\simpleini"
        move "external\simpleini\SimpleIni.h" "external\simpleini\simpleini\"
    ) else (
        echo [MISSING] simpleini headers
        set missingDeps=1
    )
) else (
    echo [OK] simpleini
)

if not exist "external\unordered_dense\include\ankerl\unordered_dense.hpp" (
    if exist "external\unordered_dense\include\unordered_dense.hpp" (
        echo [FIXING] unordered_dense structure...
        if not exist "external\unordered_dense\include\ankerl" mkdir "external\unordered_dense\include\ankerl"
        move "external\unordered_dense\include\unordered_dense.hpp" "external\unordered_dense\include\ankerl\"
    ) else (
        echo [MISSING] unordered_dense headers
        set missingDeps=1
    )
) else (
    echo [OK] unordered_dense
)

if not exist "external\vulkan\include\vulkan\vulkan.h" (
    if exist "external\vulkan\include\vulkan.h" (
        echo [FIXING] Vulkan structure...
        if not exist "external\vulkan\include\vulkan" mkdir "external\vulkan\include\vulkan"
        move "external\vulkan\include\vulkan.h" "external\vulkan\include\vulkan\"
    ) else (
        echo [MISSING] Vulkan headers
        set missingDeps=1
    )
) else (
    echo [OK] Vulkan headers
)

if not exist "external\FidelityFX-SDK\FidelityFX\include\FidelityFX.h" (
    if exist "external\FidelityFX-SDK\FidelityFX\FidelityFX.h" (
        echo [FIXING] FidelityFX structure...
        if not exist "external\FidelityFX-SDK\FidelityFX\include" mkdir "external\FidelityFX-SDK\FidelityFX\include"
        move "external\FidelityFX-SDK\FidelityFX\FidelityFX.h" "external\FidelityFX-SDK\FidelityFX\include\"
    ) else (
        echo [MISSING] FidelityFX SDK
        set missingDeps=1
    )
) else (
    echo [OK] FidelityFX SDK
)

if not exist "external\magic_enum\include\magic_enum.hpp" (
    if exist "external\magic_enum\include\magic_enum\magic_enum.hpp" (
        echo [OK] magic_enum
    ) else (
        echo [MISSING] magic_enum
        set missingDeps=1
    )
) else (
    echo [OK] magic_enum
)

if not exist "external\xess\inc\xess\xess.h" (
    if exist "external\xess\xess\xess.h" (
        echo [FIXING] XeSS structure...
        if not exist "external\xess\inc" mkdir "external\xess\inc"
        move "external\xess\xess" "external\xess\inc\"
    ) else (
        echo [MISSING] Intel XeSS SDK
        set missingDeps=1
    )
) else (
    echo [OK] Intel XeSS SDK
)

echo.

REM Check for Visual Studio build tools
echo Checking for Visual Studio build tools...
where cl >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Visual Studio build tools not found in PATH
    echo You may need to run this from a Visual Studio Developer Command Prompt
    echo or install Visual Studio Build Tools
    echo.
    set missingDeps=1
) else (
    echo [OK] Visual Studio build tools found
)

echo.

if %missingDeps% equ 0 (
    echo ========================================
    echo    All dependencies are ready!
    echo ========================================
    echo.
    echo You can now build OptiScaler using:
    echo   - Visual Studio 2022 (open OptiScaler.sln)
    echo   - MSBuild from command line
    echo   - Visual Studio Build Tools
    echo.
    echo Note: Some dependencies like NVIDIA DLSS SDK may need
    echo manual installation if you plan to use DLSS features.
    echo.
) else (
    echo ========================================
    echo    Some dependencies are missing!
    echo ========================================
    echo.
    echo Please check the missing dependencies above.
    echo You may need to:
    echo   1. Run this script again
    echo   2. Install Visual Studio Build Tools
    echo   3. Manually download missing SDKs
    echo.
)

echo Press any key to exit...
pause >nul