import os
import subprocess
import shutil

# List all files in the current directory
files = os.listdir()

# Dictionary to store files for each frame number
frame_files = {}

# Iterate through the list of files
for file in files:
    # Split the file name by dots to extract components
    parts = file.split('.')
    if len(parts) >= 3:
        # Extract the frame number
        frame_number = parts[-2]
        # Add the file to the dictionary for the corresponding frame number
        if frame_number not in frame_files:
            frame_files[frame_number] = []

        # Check if the file matches the expected pattern
        if parts[-1] == "exr":
            frame_files[frame_number].append(file)

            # Determine the prefix based on the presence of parts[-4]
            prefix = parts[-4] if len(parts) >= 4 and parts[-4] else "beauty_combined"

            # Construct the output file name following the desired structure
            if len(parts) >= 4 and parts[-4]:
                output_filename = f"{prefix}.beauty_combined.{frame_number}.exr"
            else:
                output_filename = f"beauty_combined.{frame_number}.exr"

            print(f"Processing Frame {frame_number}...")  # Print the current frame number being processed

            # Run the oiiotool command for the current frame_number
            command = f"oiiotool {' '.join(frame_files[frame_number])} --siappendall -o {output_filename}"
            subprocess.run(command, shell=True)

# Create the "AOV" folder if it doesn't exist
output_folder = "AOV"
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# Move the processed files (not the outputs) to the "AOV" folder
for frame_number, files in frame_files.items():
    for file in files:
        source_path = os.path.join(os.getcwd(), file)
        destination_path = os.path.join(os.getcwd(), output_folder, file)
        shutil.move(source_path, destination_path)

print("Processing and moving completed.")