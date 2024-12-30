#!/bin/bash

# Define the path to the maketx executable
MAKETX='/home/vni/pipeline/addons/Arnold/SDK/7.3.6.0/bin/maketx'

# Loop through each argument passed to the script
for input in "$@"; do
    # Check if the argument is a directory
    if [ -d "$input" ]; then
        # Loop through all files in the directory (non-recursive)
        for file in "$input"/*; do
            # Check if it's a valid file (ignoring directories)
            if [ -f "$file" ]; then
                # Running maketx command to generate the .exr.tx file
                "$MAKETX" -v -u --threads 4 --format exr --checknan --constant-color-detect --opaque-detect --colorconfig "$OCIO" --colorconvert "sRGB Encoded Rec.709 (sRGB)" ACEScg --unpremult --oiio "$file"

                # Extracting the filename without extension
                input_file=$(basename "$file")
                file_ext="${input_file##*.}"
                base_name="${input_file%.*}"

                # Construct the new name by appending "_sRGB Encoded Rec.709 (sRGB)_ACEScg" to the base name, then appending the extension
                new_name="${base_name}_sRGB Encoded Rec.709 (sRGB)_ACEScg.${file_ext}.tx"

                # Construct the output file path (directory + new name)
                output_file="$input/$new_name"

                # Check if the file exists and rename it
                if [ -f "$output_file" ]; then
                    # Rename the file to the desired output name
                    mv "$output_file" "$input/${base_name}_ACEScg.tx"
                else
                    echo "File not found: $output_file"
                fi
            fi
        done
    else
        # If it's a file, process it directly
        # Running maketx command to generate the .exr.tx file
        "$MAKETX" -v -u --threads 4 --format exr --checknan --constant-color-detect --opaque-detect --colorconfig "$OCIO" --colorconvert "sRGB Encoded Rec.709 (sRGB)" ACEScg --unpremult --oiio "$input"

        # Extracting the filename without extension
        input_file=$(basename "$input")
        file_ext="${input_file##*.}"
        base_name="${input_file%.*}"

        # Construct the new name by appending "_sRGB Encoded Rec.709 (sRGB)_ACEScg" to the base name, then appending the extension
        new_name="${base_name}_sRGB Encoded Rec.709 (sRGB)_ACEScg.${file_ext}.tx"

        # Construct the output file path (directory + new name)
        output_file="$(dirname "$input")/$new_name"

        # Check if the file exists and rename it
        if [ -f "$output_file" ]; then
            # Rename the file to the desired output name
            mv "$output_file" "$(dirname "$input")/${base_name}_ACEScg.tx"
        else
            echo "File not found: $output_file"
        fi
    fi
done
