import os
import subprocess
import shutil
import time

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

# Process each frame number with a single oiiotool command
for frame_number, files in frame_files.items():
    if not files:
        print(f"No files found for frame {frame_number}")
        continue

    # Construct the output file name following the desired structure
    if len(parts) >= 4:
        prefix = parts[-4]
        output_filename = f"{prefix}.beauty_combined.{frame_number}.exr"
    else:
        prefix = ""
        output_filename = f"beauty_combined.{frame_number}.exr"

    print(f"Processing Frame {frame_number}...")  # Print the current frame number being processed

    # Measure the time taken to process each frame
    start_time = time.time()

    # Run a single oiiotool command for the current frame_number
    command = f"oiiotool {' '.join(files)} --siappendall -o {output_filename}"
    subprocess.run(command, shell=True)

    # Calculate and print the time taken
    elapsed_time = time.time() - start_time
    print(f"Frame {frame_number} processed in {elapsed_time:.2f} seconds")

    # Create the "AOV" subfolder for the current frame_number
    output_folder = os.path.join("AOV", frame_number)
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Move the processed files to the "AOV" subfolder
    for file in files:
        source_path = os.path.join(os.getcwd(), file)
        destination_path = os.path.join(os.getcwd(), output_folder, file)
        shutil.move(source_path, destination_path)

print("Processing and moving completed.")
