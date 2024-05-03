@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\Prman\RenderManProServer-26.0\bin\txmake.exe" -verbose -t:4 -mode periodic -ocioconfig %OCIO% -ocioconvert "Utility - Linear - sRGB"  "ACES - ACEScg" -format pixar %%i %%i.tex)
pause