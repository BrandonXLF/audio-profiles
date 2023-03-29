@echo Clearing deploy directory
@rmdir deploy /s /q

@echo Creating deploy directory
@mkdir deploy
@mkdir "deploy\Audio Profiles"

@if not exist ".\build\release\Audio Profiles.exe" (
	@echo ERROR: Could not find release exe. Create a release build in build\release.
	pause
	exit
)

@echo Copying release EXE
@copy /y ".\build\release\Audio Profiles.exe" ".\deploy\Audio Profiles\Audio Profiles.exe"

@echo Locating windeployqt
@set /p windeployqt=<windeployqt

@if not exist "%windeployqt%" (
	@echo ERROR: Could not find windeployqt.exe. Make sure the file "windeployqt" contains a valid path to your windeployqt.exe.
	pause
	exit
)

@echo Running windeployqt
@cd "deploy\Audio Profiles"
@%windeployqt% "Audio Profiles.exe" --qmldir ..\..\qml --release --no-translations --no-virtualkeyboard --no-3dcore --no-sql --no-xml^
 --no-opengl-sw --no-3dquick --no-3dquickrender --no-3drender --no-system-d3d-compiler --no-3dinput --no-3danimation --no-pdf --no-pdfquick^
 --no-quickdialogs2quickimpl --no-statemachine --no-quick3dutils --no-3dlogic --no-3dquickscene2d -no-quicktimeline --no-statemachineqml^
 --no-quickdialogs2 --no-quickdialogs2utils

@echo Removing unneeded files
@del Qt63DAnimation.dll
@rmdir qml\QtQuick\VirtualKeyboard /s /q
@rmdir qml\QtQuick\Pdf /s /q
@rmdir qml\QtQuick\Controls\Imagine /s /q
@rmdir qml\QtQuick\Controls\Fusion /s /q
@rmdir qml\QtQuick\Controls\Material /s /q
@rmdir tls /s /q
@move .\imageformats\qsvg.dll .\TEMP_qsvg.dll
@rmdir imageformats /s /q
@mkdir imageformats
@move .\TEMP_qsvg.dll .\imageformats\qsvg.dll
@rmdir qmltooling /s /q

@echo Running NSIS
@cd ../..
@makensis install.nsis