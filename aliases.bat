@echo off

:: Linux aliases
DOSKEY ls=dir
DOSKEY cat=type $*
DOSKEY ip=ipconfig
DOSKEY rm=rmdir /S $*$Tdel $*
DOSKEY mkdir=mkdir $1$Tcd $1
DOSKEY touch=copy nul $* > nul
DOSKEY clear=cls


:: Software aliases


DOSKEY djv="G:\pipeline\DCCs\DJV2\bin\djv.exe" $*
DOSKEY rv="G:\pipeline\DCCs\OpenRV\bin\rv.exe" $*


DOSKEY resolve="C:\Program Files\Blackmagic Design\DaVinci Resolve\Resolve.exe" $*
DOSKEY premiere="C:\Program Files\Adobe\Adobe Premiere Pro 2024\Adobe Premiere Pro.exe" $*


DOSKEY houdini="G:\pipeline\DCCs\Side Effects Software\Houdini 20.0.590\bin\houdini.exe" $*

DOSKEY maya="G:\pipeline\Utilities\DCC_Wrappers\Maya\2024\maya24.bat" $*
DOSKEY ktoa="G:\pipeline\Utilities\DCC_Wrappers\Katana\7.0\KtoA.bat" $*
DOSKEY ktorm="G:\pipeline\Utilities\DCC_Wrappers\Katana\7.0\KtoPRMan.bat" $*
DOSKEY katana="G:\pipeline\Utilities\DCC_Wrappers\Katana\7.0\katana.bat" $*
DOSKEY gaffer="G:\pipeline\Utilities\DCC_Wrappers\Gaffer\1.4\gaffer.bat" $*
rem DOSKEY gafferbeta="G:\pipeline\Utilities\DCC_Wrappers\Gaffer\1.4\gaffer_1.4b6.bat" $*
DOSKEY nuke="G:\pipeline\Utilities\DCC_Wrappers\Nuke\15.0\Nuke.bat" $*
DOSKEY guerilla="G:\pipeline\Utilities\DCC_Wrappers\Guerilla\guerilla.bat" $*


