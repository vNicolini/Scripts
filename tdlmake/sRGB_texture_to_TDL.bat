@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\3Delight\bin\tdlmake.exe" -float -ocioinputspace "Utility - sRGB - Texture" -progress %%i %%i.tdl)
pause