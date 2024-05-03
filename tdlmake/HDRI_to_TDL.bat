@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\3Delight\bin\tdlmake.exe" -envlatl -float -ocioinputspace "Utility - Linear - sRGB" -progress %%i %%i.tdl)
pause