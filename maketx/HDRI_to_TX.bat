@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\Arnold\Arnold-7.2.5.1-windows\bin\maketx.exe" -v -u --envlatl --threads 4 --format exr -d float --checknan --nchannels 3 --constant-color-detect --opaque-detect --colorconfig %OCIO% --colorconvert "Utility - Linear - sRGB"  "ACES - ACEScg" --unpremult --oiio  %%i)
pause