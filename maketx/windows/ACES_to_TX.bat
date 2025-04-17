@ECHO OFF

rem If you don't set your OCIO variable either in your resolved environment or at the system level you can set it up here
rem set "OCIO=C:\Users\valentin.nicolini\Desktop\PERSO\Pipe\OCIO\ACES\1.3\cg-config-v2.1.0_aces-v1.3_ocio-v2.1.ocio"

rem Enable delayed variable expansion
setlocal enabledelayedexpansion

rem Define the application name 
set "application_name=maketx"

rem Check if the application exists and is accessible in the PATH
where /q "%application_name%"
if %errorlevel% equ 0 (
    echo Application found: %application_name%
    goto :run_conversion
) else (
    echo "%Application_name%" not found. Make sure "%application_name%" is installed and accessible in your PATH.

    exit /b 1
)

:run_conversion
rem Define the source and target colorspaces
set "source_colorspace=ACEScg"

rem Define the maketx command with the specified options and colorspaces.
set "maketx_command=maketx -v -u --threads 4 --format exr --fixnan box3 -constant-color-detect --monochrome-detect --opaque-detect --colorconfig %OCIO% --unpremult --oiio"

rem Loop through each argument passed to the batch script
for %%i in (%*) do (
    rem Check if the argument is a directory
    if exist "%%i\" (
        rem Loop through all files in the directory (non-recursive)
        for %%j in ("%%i\*") do (
            rem Check if it's a valid file (ignoring folders)
            if not "%%~fj"=="" (

                rem Extracting the filename without extension
                set "input_file=%%~nj"                
                rem Construct the base name (filename without extension)
                set "base_name=!input_file!"                
                rem Construct the new name by appending !source_colorspace! to the base name, then appending the extension
                set "new_name=!base_name!_!source_colorspace!.tx"                
                rem Construct the output file path (directory + new name)
                set "output_file=%%i\!new_name!"

                rem Running maketx command to generate the .exr.tx file
                !maketx_command! %%j -o "!output_file!"
                               
                rem Display variables for debugging
                @REM echo Input dir: %%i
                @REM echo Input file: %%~nj
                @REM echo File extension: !file_ext!
                @REM echo Base name: !base_name!
                @REM echo New name: !new_name!
                @REM echo Output file: !output_file!

            )
        )
    ) else (
        rem If it's a file, process it directly

        rem Extracting the filename without extension
        set "input_file=%%~ni"
        rem Construct the base name (filename without extension)
        set "base_name=!input_file!"        
        rem Construct the new name by appending !source_colorspace! to the base name, then appending the extension
        set "new_name=!base_name!_!source_colorspace!.tx"
        rem Construct the output file path (directory + new name)
        set "output_file=%%~dpi!new_name!"

        rem Running maketx command to generate the .exr.tx file
        !maketx_command! %%i -o "!output_file!"
      
        rem Display variables for debugging
        @REM echo Input file: %%~ni
        @REM echo File extension: !file_ext!
        @REM echo Base name: !base_name!
        @REM echo New name: !new_name!
        @REM echo Output file: !output_file!

    )
)

rem End delayed variable expansion
endlocal

pause