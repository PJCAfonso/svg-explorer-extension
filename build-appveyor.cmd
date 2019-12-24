REM
REM Copy this script to https://ci.appveyor.com/project/maphew/svg-explorer-extension/settings/build
REM
set VC_DIR=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
set INNOSETUP_DIR=C:\Program Files (x86)\Inno Setup 5
set JOM=C:\Qt\Tools\QtCreator\bin\jom.exe
set QMAKESPEC=win32-msvc
set PATH=%INNOSETUP_DIR%;%VC_DIR%;%PATH%
set PATH_BAK=%PATH%

cd SVGThumbnailExtension
mkdir license
copy C:\Qt\Licenses\LICENSE license\Qt.txt
copy ..\LICENSE.md license.txt
cd ..

echo ####################################################
echo Building 64bit installer
echo ####################################################

set QT_DIR=C:\Qt\5.13.2\msvc2017_64
set PATH=%QT_DIR%\bin;%PATH_BAK%
set BUILD_DIR=SVGThumbnailExtension-build-x64_Release

call vcvars64.bat || exit /B 1

mkdir %BUILD_DIR%
cd %BUILD_DIR%
qmake.exe ..\SVGThumbnailExtension\SVGThumbnailExtension.pro "CONFIG+=release"
%JOM%

cd ..\SVGThumbnailExtension
set ARCH=x64
mkdir %ARCH%\release\plugins\platforms
mkdir %ARCH%\release\plugins\styles
FOR %%G IN (Qt5Core,Qt5Gui,Qt5Svg,Qt5Widgets,Qt5WinExtras) DO copy %QT_DIR%\bin\%%G.dll %ARCH%\release
copy %QT_DIR%\plugins\platforms\qwindows.dll %ARCH%\release\plugins\platforms
copy %QT_DIR%\plugins\styles\qwindowsvistastyle.dll %ARCH%\release\plugins\styles
ISCC SVGThumbnailExtension_x64.iss
cd ..

echo ####################################################
echo Building 32bit installer
echo ####################################################

set QT_DIR=C:\Qt\5.13.2\msvc2017
set PATH=%QT_DIR%\bin;%PATH_BAK%
set BUILD_DIR=SVGThumbnailExtension-build-x86_Release

call vcvars32.bat || exit /B 1

mkdir %BUILD_DIR%
cd %BUILD_DIR%
qmake.exe ..\SVGThumbnailExtension\SVGThumbnailExtension.pro "CONFIG+=release"
%JOM%

cd ..\SVGThumbnailExtension
set ARCH=x86
mkdir %ARCH%\release\plugins\platforms
mkdir %ARCH%\release\plugins\styles
FOR %%G IN (Qt5Core,Qt5Gui,Qt5Svg,Qt5Widgets,Qt5WinExtras) DO copy %QT_DIR%\bin\%%G.dll %ARCH%\release
copy %QT_DIR%\plugins\platforms\qwindows.dll %ARCH%\release\plugins\platforms
copy %QT_DIR%\plugins\styles\qwindowsvistastyle.dll %ARCH%\release\plugins\styles
ISCC SVGThumbnailExtension.iss
cd ..