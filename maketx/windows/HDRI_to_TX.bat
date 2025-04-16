@ECHO OFF

rem If you don't set your OCIO variable either in your resolved environment or at the system level you can set it up here
rem set "OCIO=C:\Users\valentin.nicolini\Desktop\PERSO\Pipe\OCIO\ACES\1.3\cg-config-v2.1.0_aces-v1.3_ocio-v2.1.ocio"

rem Enable delayed variable expansion
setlocal enabledelayedexpansion

rem Get the path to maketx.exe from an environment variable
if "%MAKETX_PATH%"=="" (
    echo Error: MAKETX_PATH environment variable is not set.
    pause
    exit /b 1
)

rem Loop through each argument passed to the batch script
for %%i in (%*) do (
    rem Check if the argument is a directory
    if exist "%%i\" (
        rem Loop through all files in the directory (non-recursive)
        for %%j in ("%%i\*") do (
            rem Check if it's a valid file (ignoring folders)
            if not "%%~fj"=="" (
                rem Running maketx command to generate the .exr.tx file
                "%MAKETX_PATH%" -v -u --envlatl --threads 4 --format exr -d float --checknan --nchannels 3 --constant-color-detect --opaque-detect --colorconvert "Linear Rec.709 (sRGB)" ACEScg --unpremult --oiio  %%j
                
                rem Extracting the filename without extension
                set "input_file=%%~nj"
                
                rem Extracting the file extension
                set "file_ext=%%~xj"
                
                rem Construct the base name (filename without extension)
                set "base_name=!input_file!"
                
                rem Construct the new name by appending "_raw" to the base name, then appending the extension
                set "new_name=!base_name!_Linear Rec.709 (sRGB)_ACEScg!file_ext!.tx"
                
                rem Construct the output file path (directory + new name)
                set "output_file=%%i\!new_name!"
                
                rem Display variables for debugging
                echo Input dir: %%i
                echo Input file: %%~nj
                echo File extension: !file_ext!
                echo Base name: !base_name!
                echo New name: !new_name!
                echo Output file: !output_file!

                
                rem Check if the file exists and rename it
                if exist "!output_file!" (
                    rem Rename the file to the desired output name
                    echo Running command: "ren "!output_file!" "!base_name!_ACEScg.tx""
                    ren "!output_file!" "!base_name!_ACEScg.tx"
                ) else (
                    echo File not found: !output_file!!
                )
            )
        )
    ) else (
        rem If it's a file, process it directly
        rem Running maketx command to generate the .exr.tx file
        "%MAKETX_PATH%" -v -u --envlatl --threads 4 --format exr -d float --checknan --nchannels 3 --constant-color-detect --opaque-detect --colorconvert "Linear Rec.709 (sRGB)" ACEScg --unpremult --oiio  %%i

        rem Extracting the filename without extension
        set "input_file=%%~ni"
        
        rem Extracting the file extension
        set "file_ext=%%~xi"
        
        rem Construct the base name (filename without extension)
        set "base_name=!input_file!"
        
        rem Construct the new name by appending "_raw" to the base name, then appending the extension
        set "new_name=!base_name!_Linear Rec.709 (sRGB)_ACEScg!file_ext!.tx"
        
        rem Construct the output file path (directory + new name)
        set "output_file=%%~dpi!new_name!"
        
        rem Display variables for debugging
        echo Input file: %%~ni
        echo File extension: !file_ext!
        echo Base name: !base_name!
        echo New name: !new_name!
        echo Output file: !output_file!
        
        rem Check if the file exists and rename it
        if exist "!output_file!" (
            rem Rename the file to the desired output name
            ren "!output_file!" "!base_name!_ACEScg.tx"
        ) else (
            echo File not found: !output_file!
        )
    )
)

rem End delayed variable expansion
endlocal

pause
