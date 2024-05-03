import os
import subprocess
import time
import shutil  # Import the shutil module for file/directory operations

# Get the current directory
current_directory = os.getcwd()

# List all subdirectories in the current directory
subdirectories = [d for d in os.listdir(current_directory) if os.path.isdir(os.path.join(current_directory, d))]

# Create a list to store full paths of files
file_paths = []

# Collect the full paths of files in each subdirectory
for subdir in subdirectories:
    subdir_path = os.path.join(current_directory, subdir)
    
    # List the content of the subdirectory
    #subdirectory_content = os.listdir(subdir_path)
    #subdirectory_content = [item for item in os.listdir(subdir_path) if 'deep' not in os.path.join(subdir_path, item)]
    subdirectory_content = [item for item in os.listdir(subdir_path) if 'deep' not in os.path.join(subdir_path, item)]

    
    # Append full paths to the list
    file_paths.extend([os.path.join(subdir_path, item) for item in subdirectory_content])

# Create a dictionary based on the second-to-last part of each filename
frame_number_dict = {}

for file_path in file_paths:
    # Extract the parts of the filename
    parts = os.path.splitext(os.path.basename(file_path))
    
    # Extract the second-to-last part (without the dot)
    second_last_part = parts[0].split('.')[-1]
    
    # Check if the frame number key exists in the dictionary, create it if not
    if second_last_part not in frame_number_dict:
        frame_number_dict[second_last_part] = []
    
    # Add the file path to the corresponding frame number key
    frame_number_dict[second_last_part].append(file_path)

# Measure the total time taken for the entire process
total_start_time = time.time()

# Create the "combined" directory if it does not exist
combined_directory = os.path.join(current_directory, "combined")
os.makedirs(combined_directory, exist_ok=True)

# Process each frame number with a single oiiotool command
for frame_number, file_paths in frame_number_dict.items():
    print(f"\nProcessing frame {frame_number}...")
    
    # Construct the output file name following the desired structure
    if len(file_paths) >= 1:
        first_file_name = os.path.splitext(os.path.basename(file_paths[0]))[0]
        prefix = first_file_name.split('.')[-2] if len(first_file_name.split('.')) >= 3 else ""
        output_filename = f"{prefix}.beauty_combined.{frame_number}.exr" if prefix else f"beauty_combined.{frame_number}.exr"
    else:
        output_filename = f"beauty_combined.{frame_number}.exr"
    
    # Construct the full path for the output file in the "combined" directory
    output_filepath = os.path.join(combined_directory, output_filename)
    
    print(f"Output filename: {output_filepath}")
    
    # Print the number of files being combined for the current frame
    print(f"Number of files combined for frame {frame_number}: {len(file_paths)}")
    
    # Measure the time taken to process each frame
    start_time = time.time()
    
    # Construct the oiiotool command
    # print(f"Running command: {command}")
    command = f"oiiotool {' '.join(file_paths)} --metamerge --siappendall -o {output_filepath}"
    
    # Run the oiiotool command
    subprocess.run(command, shell=True)
    
    # Calculate and print the time taken for each frame
    elapsed_time = time.time() - start_time
    print(f"Time taken: {elapsed_time:.2f} seconds")

# Calculate and print the total time taken for the entire process
total_elapsed_time = time.time() - total_start_time
print(f"\nTotal time taken for the entire process: {total_elapsed_time:.2f} seconds")
print("\nProcessing complete.")
