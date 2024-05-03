@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\Prman\RenderManProServer-26.0\bin\txmake.exe" -verbose -t:4 -envlatl -ocioconfig %OCIO% -ocioconvert "Utility - Linear - sRGB"  "ACES - ACEScg" -float -format pixar %%i %%i.tex)
pause