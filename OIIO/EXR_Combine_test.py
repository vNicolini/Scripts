import os
import subprocess
import time
import shutil  # Import the shutil module for file/directory operations
import re

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
    subdirectory_content = os.listdir(subdir_path)
    
    # Append full paths to the list
    file_paths.extend([os.path.join(subdir_path, item) for item in subdirectory_content])

# Initialize the dictionary
frame_number_dict = {}

# Define a regular expression pattern to capture parts of the filename
pattern = re.compile(r'(?P<type>\w+)\.(?P<frame>\d+)\.\w+')

# Iterate through the file paths
for file_path in file_paths:
    # Extract the filename from the path
    filename = os.path.basename(file_path)
    
    # Use the regular expression to match parts of the filename
    match = pattern.match(filename)
    
    # Check if the match is successful
    if match:
        # Extract the frame and type from the match
        frame = match.group('frame')
        file_type = match.group('type')
        
        # Check if the frame number key exists in the dictionary, create it if not
        if frame not in frame_number_dict:
            frame_number_dict[frame] = {'beauty': [], 'crypto': {}}
        
        # Check if the type is "beauty" or "crypto"
        if file_type == "beauty":
            # Append the file path to the "beauty" sub-dictionary
            frame_number_dict[frame]['beauty'].append(file_path)
        elif "crypto" in file_type:
            # Create a sub-dictionary for each crypto type if it doesn't exist
            crypto_type = file_type.split('_')[-1]
            frame_number_dict[frame]['crypto'].setdefault(crypto_type, []).append(file_path)
        else:
            # Append the file path to the corresponding frame number key (other types)
            frame_number_dict[frame].setdefault('other', []).append(file_path)
    else:
        print(f"Skipping file {file_path} due to filename structure mismatch.")

# Print the resulting dictionary
# print(frame_number_dict)

# Measure the total time taken for the entire process
total_start_time = time.time()

# Iterate through the frame_number_dict to construct and execute individual oiiotool commands
for frame_number, file_dict in frame_number_dict.items():
    # Iterate through the file_dict for each frame
    frame_command = []
    
    # Append beauty files
    beauty_files = file_dict.get('beauty', [])
    if beauty_files:
        frame_command.append(' '.join(beauty_files) + ' --metamerge')
    
    # Append crypto files
    crypto_files = file_dict.get('crypto', {})
    crypto_commands = []
    for crypto_type, crypto_type_files in crypto_files.items():
        # Each crypto command has the specified structure
        crypto_commands.append(f'{crypto_type_files[0]} --chappend --metamerge')
    if crypto_commands:
        frame_command.extend(crypto_commands)
    
    # Append other files
    other_files = file_dict.get('other', [])
    if other_files:
        frame_command.append(' '.join(['-i'] + other_files))
    
    # Construct the output file name following the desired structure
    if len(beauty_files) >= 1:
        first_file_name = os.path.splitext(os.path.basename(beauty_files[0]))[0]
        prefix = first_file_name.split('.')[-2] if len(first_file_name.split('.')) >= 3 else ""
        output_filename = f"{prefix}.beauty_combined.{frame_number}.exr" if prefix else f"beauty_combined.{frame_number}.exr"
    else:
        output_filename = f"beauty_combined.{frame_number}.exr"
    
    # Construct the complete oiiotool command for the frame with the output file name
    frame_oiiotool_command = f'oiiotool {" ".join(frame_command)} --siappendall -o ../{output_filename}'
    
    # Print the current frame being processed
    print(f"Processing frame {frame_number}...")
    
    # Measure the time taken to process each frame
    start_time = time.time()
    
    # Print and execute the individual oiiotool command
    #print(f"Running command: {frame_oiiotool_command}")
    subprocess.run(frame_oiiotool_command, shell=True)
    
    # Measure the time taken for the frame
    end_time = time.time()
    elapsed_time = end_time - start_time
    print(f"Time taken for frame {frame_number}: {elapsed_time:.2f} seconds")

# Measure the total time taken for the entire process
total_end_time = time.time()
total_elapsed_time = total_end_time - total_start_time
print(f"Total time taken: {total_elapsed_time:.2f} seconds")