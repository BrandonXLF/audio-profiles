@echo Clearing deploy directory
@rmdir deploy /s /q

@echo Creating deploy directory
@mkdir deploy
@mkdir "deploy\Audio Profiles"

@if not exist ".\build\release\Audio Profiles.exe" (
	@echo ERROR: Could not find release exe. Create a release build in build\release.
	exit
)

@echo Copying release EXE
@copy /y ".\build\release\Audio Profiles.exe" ".\deploy\Audio Profiles\Audio Profiles.exe"

@echo Locating windeployqt
@set /p windeployqt=<windeployqt

@if not exist "%windeployqt%" (
	@echo ERROR: Please put the path to your windeployqt in the windeployqt file.
	exit
)

@echo Running windeployqt
@cd "deploy\Audio Profiles"
@%windeployqt% "Audio Profiles.exe" --qmldir ..\..\qml --release --no-translations --no-virtualkeyboard --no-3dcore --no-sql --no-xml --no-opengl-sw --no-qmltooling --no-3dquick --no-3dquickrenderer --no-3drenderer --no-system-d3d-compiler --no-3dinput --no-3danimation

@echo Removing unneeded files
@rmdir QtQuick\Controls\Imagine /s /q
@rmdir QtQuick\Controls\Fusion /s /q
@rmdir QtQuick\Controls\Material /s /q
@rmdir tls /s /q
@del Qt6VirtualKeyboard.dll
@rmdir QtQuick\VirtualKeyboard /s /q
@del Qt6Pdf.dll
@del Qt6PdfQuick.dll
@del Qt6QuickDialogs2QuickImpl.dll
@move .\imageformats\qsvg.dll .\TEMP_qsvg.dll
@rmdir imageformats /s /q
@mkdir imageformats
@move .\TEMP_qsvg.dll .\imageformats\qsvg.dll

@echo Running NSIS
@cd ../..
@makensis install.nsis