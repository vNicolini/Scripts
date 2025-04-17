# Define the application name
$application_name = "maketx"

# Check if the application exists and is accessible in the PATH
if (-not (Get-Command -Name $application_name -ErrorAction SilentlyContinue)) {
    Write-Host "$application_name not found. Make sure '$application_name' is installed and accessible in your PATH."
    exit 1
}

# Define the source and target colorspaces
$source_colorspace = "lin_srgb"
$target_colorspace = "ACEScg"

# Define the maketx command with the specified options and colorspaces.
$maketx_command = "maketx -v -u --threads 4 --format exr --checknan --constant-color-detect --opaque-detect --colorconvert '$source_colorspace' '$target_colorspace' --unpremult --oiio"

# Loop through each argument passed to the script
foreach ($arg in $args) {
    if (Test-Path -Path $arg -PathType Container) {
        # It's a directory, loop through all files in the directory (non-recursive)
        Get-ChildItem -Path $arg -File | ForEach-Object {
            $input_file = $_.Name
            $base_name = [System.IO.Path]::GetFileNameWithoutExtension($input_file)
            $new_name = "$base_name`_$source_colorspace`_$target_colorspace.tx"
            $output_file = Join-Path -Path $arg -ChildPath $new_name

            # Running maketx command to generate the .exr.tx file
            $command = "$maketx_command $_ -o '$output_file'"
            Write-Host $command
            Invoke-Expression -Command $command
        }
    } else {
        # It's a file, process it directly
        $input_file = [System.IO.Path]::GetFileNameWithoutExtension($arg)
        $base_name = [System.IO.Path]::GetFileNameWithoutExtension($arg)
        $new_name = "$base_name`_$source_colorspace`_$target_colorspace.tx"
        $output_file = Join-Path -Path (Split-Path $arg) -ChildPath $new_name

        # Running maketx command to generate the .exr.tx file
        $command = "$maketx_command $arg -o '$output_file'"
        Write-Host $command
        Invoke-Expression -Command $command
    }
}