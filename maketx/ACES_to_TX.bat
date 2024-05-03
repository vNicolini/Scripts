@ECHO OFF
@for %%i in (%*) do ("G:\pipeline\renderers\Arnold\Arnold-7.2.5.1-windows\bin\maketx.exe" -v -u --threads 4 --format exr -d half --fixnan box3 -constant-color-detect --monochrome-detect --opaque-detect --colorconfig %OCIO% --unpremult --oiio  %%i)
pause