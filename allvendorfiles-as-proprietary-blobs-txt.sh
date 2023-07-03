#!/bin/bash

# all vendor files
create_all_files_vendor() {
  input_folder="$1"
  output_file="proprietary-blobs.txt"
  show_filenames="$2"
  remove_extensions="$3"

  if [[ "$show_filenames" == "true" ]]; then
    if [[ "$remove_extensions" == "true" ]]; then
      find "$input_folder" -type f -iname "*" -exec basename {} \; | sed -E 's/\.[^.]+$//' > "$output_file"
    else
      find "$input_folder" -type f -iname "*" -exec basename {} \; > "$output_file"
    fi
  else
    if [[ "$remove_extensions" == "true" ]]; then
      find "$input_folder" -type f -iname "*" | sed -E 's|.*/([^/]+)\.[^.]+$|\1|' > "$output_file"
    else
      find "$input_folder" -type f -iname "*" > "$output_file"
    fi
  fi

  if [[ -s "$output_file" ]]; then
    echo "The 'proprietary-blobs.txt' has been created from the folder: $input_folder!"
  else
    echo "No files found in the folder: $input_folder."
    rm "$output_file" # Remove the empty file
  fi
}

cut_before_vendor_string() {
    local input_file="proprietary-blobs.txt"
    local output_file="proprietary-blobsi.txt"

    # Check if input file exists
    if [[ -f $input_file ]]; then
        # Using sed to cut out everything before 'vendor/' and writing the result to output file
        sed 's/.*vendor\///' "$input_file" > "$output_file"
    else
        echo "Input file '$input_file' does not exist."
    fi
    rm -r proprietary-blobs.txt
    cat proprietary-blobsi.txt > proprietary-blobs.txt
    rm -r proprietary-blobsi.txt
}

# Function to display script usage
display_usage() {
  echo "Usage: $0 <input_folder> [show_filenames] [remove_extensions]"
  echo "  input_folder: The folder to search for files"
  echo "  show_filenames (optional): Set to 'true' to display only file names (default: false)"
  echo "  remove_extensions (optional): Set to 'true' to remove file extensions from file names (default: false)"
  echo ""
  echo "Example usage:"
  echo "  $0 vendor true true  # Show only file names without file extensions"
  echo "  $0 vendor           # Show full file paths (default behavior)"
}

# Check if the input folder argument is provided
if [[ $# -lt 1 || $# -gt 3 || "$1" == "--help" ]]; then
  display_usage
  exit 1
fi

input_folder="$1"
if [[ ! -d "$input_folder" ]]; then
  echo "The input folder does not exist: $input_folder"
  exit 1
fi

# with full path
create_all_files_vendor "$input_folder" "$2" "$3"

# cut full path
cut_before_vendor_string
