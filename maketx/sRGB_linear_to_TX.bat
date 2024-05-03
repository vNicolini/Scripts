@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\Arnold\Arnold-7.2.5.1-windows\bin\maketx.exe" -v -u --threads 4 --format exr --checknan --constant-color-detect --opaque-detect --colorconfig %OCIO% --colorconvert "Utility - Linear - sRGB"  "ACES - ACEScg" --unpremult --oiio  %%i)
pause