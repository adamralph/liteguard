@echo Off
cd %~dp0
setlocal EnableDelayedExpansion

set NUGET_VERSION=4.3.0
set CSI_VERSION=2.4.0

set NUGET_URI=https://dist.nuget.org/win-x86-commandline/v%NUGET_VERSION%/NuGet.exe
set PACKAGES_CONFIG=packages.config
set PACKAGES_DIR=packages\
set CSI_EXE=%PACKAGES_DIR%\Microsoft.Net.Compilers.%CSI_VERSION%\tools\csi.exe
set SCRIPT=%~n0.csx
set NUGET_EXE_DIR=.nuget\v%NUGET_VERSION%\
set NUGET_EXE=%NUGET_EXE_DIR%NuGet.exe
set NUGET_CACHE_DIR=%LOCALAPPDATA%\%NUGET_EXE_DIR%
set NUGET_CACHE=%NUGET_CACHE_DIR%NuGet.exe

if not exist %NUGET_EXE% (
  if not exist %NUGET_CACHE% (
    if not exist %NUGET_CACHE_DIR% mkdir %NUGET_CACHE_DIR% || exit /b %ERRORLEVEL%
    echo %~nx0: Downloading '%NUGET_URI%' to '%NUGET_CACHE%'...
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Invoke-WebRequest '%NUGET_URI%' -OutFile '%NUGET_CACHE%'" || exit /b %ERRORLEVEL%
  )

  echo %~nx0: Copying '%NUGET_CACHE%' to '%NUGET_EXE_DIR%'...
  xcopy %NUGET_CACHE% %NUGET_EXE_DIR% /q || exit /b %ERRORLEVEL%
)

echo %~nx0: Restoring NuGet packages for '%SCRIPT%'...
%NUGET_EXE% restore %PACKAGES_CONFIG% -PackagesDirectory %PACKAGES_DIR% || exit /b %ERRORLEVEL%

echo %~nx0: Running '%SCRIPT%'...
%CSI_EXE% %SCRIPT% %*
