#!/bin/bash

# Function to check if the project directory path contains spaces
checkProjectDirectory() {
    PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
    if echo "${PROJECT_DIR}" | grep " "; then
        printf "\nProject Directory Path Contains Empty Space,\nPlace The Script In A Proper UNIX-Formatted Folder\n\n"
        sleep 1s && exit 1
    fi
}

OUTDIR="${PROJECT_DIR}out"

VENDORPATH="vendor/${DEVICEMANUFACTURE}/${DEVICECODENAME}"
LOCAL_PATH_PRINT="${VENDORPATH}"

generate_dir_paths() {
    local PROPRIETARY_BLOBS="proprietary-blobs.txt"
    local OUTPUT_FILE="temp/dir_paths.txt"

    # Check if proprietary-blobs.txt file exists
    if [[ -f $PROPRIETARY_BLOBS ]]; then
        # Create an array to store the directory paths
        declare -a dir_paths

        # Read each line in the proprietary-blobs.txt file
        while IFS= read -r filepath || [[ -n $filepath ]]; do
            # Extract the directory path from the file path
            dir_path=$(dirname "$filepath")

            # Add the directory path to the array
            dir_paths+=("$dir_path")
        done < "$PROPRIETARY_BLOBS"

        # Remove duplicate directory paths from the array
        unique_dir_paths=($(echo "${dir_paths[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

        # Check if the first line in the array contains a dot
        if [[ "${unique_dir_paths[0]}" == *"."* ]]; then
            unset unique_dir_paths[0]  # Remove the first line
        fi

        # Write the unique directory paths to the output file
        printf "%s\n" "${unique_dir_paths[@]}" > "$OUTPUT_FILE"
        echo "Directory paths have been generated and written to $OUTPUT_FILE"
    else
        echo "File 'proprietary-blobs.txt' does not exist."
    fi
}

create_out_dirs() {
    local DIR_PATHS="temp/dir_paths.txt"
    local OUTPUT_DIR="out"

    # Check if dir_paths.txt file exists
    if [[ -f $DIR_PATHS ]]; then
        # Read each line in the dir_paths.txt file
        while IFS= read -r dir_path || [[ -n $dir_path ]]; do
            # Create the directory path within the output directory
            mkdir -p "${OUTPUT_DIR}/proprietary/vendor/${dir_path}"
            echo "Created directory: ${OUTPUT_DIR}/${dir_path}"
        done < "$DIR_PATHS"
    else
        echo "File 'dir_paths.txt' does not exist."
    fi
}

copy_files() {
    local PROPRIETARY_BLOBS="proprietary-blobs.txt"
    local INPUT_FOLDER="vendor"
    local OUTPUT_DIR="${OUTDIR}/proprietary/vendor"
    local DIR_PATHS="out/dir_paths.txt"

    # Check if proprietary-blobs.txt file exists
    if [[ -f $PROPRIETARY_BLOBS ]]; then
        # Read each line in the proprietary-blobs.txt file
        while IFS= read -r filepath || [[ -n $filepath ]]; do
            # Trim leading and trailing whitespace from the file path
            filepath="$(echo -e "${filepath}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

            # Check if the file exists in the input folder
            if [[ -f "${INPUT_FOLDER}/${filepath}" ]]; then
                # mkdir -p "out/proprietary/vendor/${filepath}"
                # Copy the file to the output directory
                cp -r "${INPUT_FOLDER}/${filepath}" "${OUTPUT_DIR}/${filepath}"
                echo "File ${filepath} has been copied."
            else
                echo "File ${filepath} does not exist in the input folder."
            fi
        done < "$PROPRIETARY_BLOBS"
    else
        echo "File 'proprietary-blobs.txt' does not exist."
    fi
}

add_copyright_header_to_files() {
    local YEAR=$(date +"%Y")

    # Check if the output directory exists
    if [[ ! -d "$OUTDIR" ]]; then
        echo "Directory '$OUTDIR' does not exist."
        return 1
    fi

    # Find and iterate over all .mk files in the output directory
    find "$OUTDIR" -type f -name "*.mk" | while read -r FILE; do
        # Check if the file exists
        if [[ -f "$FILE" ]]; then
            # Generate the copyright header
            local COPYRIGHT_HEADER="\
#\n\
# Copyright (C) $YEAR The Android Open Source Project\n\
#\n\
# Licensed under the Apache License, Version 2.0 (the \"License\");\n\
# you may not use this file except in compliance with the License.\n\
# You may obtain a copy of the License at\n\
#\n\
#      http://www.apache.org/licenses/LICENSE-2.0\n\
#\n\
# Unless required by applicable law or agreed to in writing, software\n\
# distributed under the License is distributed on an \"AS IS\" BASIS,\n\
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n\
# See the License for the specific language governing permissions and\n\
# limitations under the License.\n\
#\n\n"

            # Prepend the copyright header to the file
            sed -i "1s|^|${COPYRIGHT_HEADER}|" "$FILE"

            echo "Added copyright header to: $FILE"
        fi
    done
}

add_local_path() {
    # Check if the output directory exists
    if [[ ! -d "$OUTDIR" ]]; then
        echo "Directory '$OUTDIR' does not exist."
        return 1
    fi

    # Find and iterate over all .mk files in the output directory
    find "$OUTDIR" -type f -name "*.mk" | while read -r FILE; do
        # Check if the file exists
        if [[ -f "$FILE" ]]; then
            # Add LOCAL_PATH=vendor/${DEVICEMANUFACTURE}/${DEVICECODENAME} to each .mk file
            sed -i "1s|^|LOCAL_PATH := vendor/${DEVICEMANUFACTURE}/${DEVICECODENAME}\n \n|" "$FILE"
            echo "Added LOCAL_PATH to: $FILE"
        fi
    done
}

generate_vendor_mk() {
    local PROPRIETARY_BLOBS="proprietary-blobs.txt"
    local OUTPUT_FILE="${OUTDIR}/${DEVICECODENAME}-vendor.mk"
    local VENDORPATH="vendor/${DEVICEMANUFACTURE}/${DEVICECODENAME}/proprietary/vendor"

    # Check if the proprietary-blobs.txt file exists
    if [[ -f $PROPRIETARY_BLOBS ]]; then
        # Create the ${DEVICECODENAME}-vendor.mk file
        echo "PRODUCT_COPY_FILES += \\" > "$OUTPUT_FILE"

        # Read each line in the proprietary-blobs.txt file
        while IFS= read -r filepath || [[ -n $filepath ]]; do
            # Add each line as a PRODUCT_COPY_FILES entry in the ${DEVICECODENAME}-vendor.mk file
            echo "    $VENDORPATH/$filepath:\$(TARGET_COPY_OUT_VENDOR)/$filepath \\" >> "$OUTPUT_FILE"
        done < "$PROPRIETARY_BLOBS"

        echo "" >> "$OUTPUT_FILE"
        echo "Generated $OUTPUT_FILE with PRODUCT_COPY_FILES entries."

    else
        echo "File 'proprietary-blobs.txt' does not exist."
    fi
}

prepare_working_space(){

SCRPTDIR="${PROJECT_DIR}"
#    INPUTLISTFILE=""
INPUTFOLDER="vendor"
TEMPDIR="${PROJECT_DIR}/temp"
#    DEVICECODENAME=""

mkdir -p "${TEMPDIR}"
mkdir -p "${TEMPDIR}/a"
mkdir -p "${TEMPDIR}/b"
mkdir -p "${TEMPDIR}/c"
mkdir -p "${OUTDIR}"
cp "${INPUTLISTFILE}" "${TEMPDIR}/proprietary-blobs.txt"

}
    
# Function to process files
generate_boardconfig_mk() {
    local OUTPUT_FILE="${OUTDIR}/BoardConfigVendor.mk"

    # Create the BoardConfigVendor.mk file
    touch "$OUTPUT_FILE"
    echo "# autogenerated BoardConfigVendor.mk by android-flominator-scripts. "> $OUTPUT_FILE

    echo "Generated $OUTPUT_FILE."
}

generate_android_mk() {
    local OUTPUT_FILE="${OUTDIR}/Android.mk"

    # Create the Android.mk file
    touch "$OUTPUT_FILE"
    echo "# autogenerated Android.mk by android-flominator-scripts. "> $OUTPUT_FILE

    echo "Generated $OUTPUT_FILE."
}

# Function to display script usage
display_usage() {
    printf "Usage: $0 [-l <input_list_file>] [-i <input_folder>] [-c <device_codename>]\n"
    printf "Options:\n"
    printf "  -l, --list <input_list_file>     Specify the input list file (default: proprietary-blobs.txt)\n"
    printf "  -i, --input <input_folder>       Specify the input folder name (default: vendor)\n"
    printf "  -c, --code <device_codename>     Specify the device codename\n"
    printf "  -m, --code <device_manufacture>     Specify the device manufacture\n"
    printf "\nExample usage:\n"
    printf " ./generate-vendor.sh -l proprietary-blobs.txt -i vendor -c a3y17lte -m samsung \n"
}

# Main execution

checkProjectDirectory

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -l|--list) INPUTLISTFILE="$2"; shift ;;
        -i|--input) INPUTFOLDER="$2"; shift ;;
        -c|--code) DEVICECODENAME="$2"; shift ;;
        -m|--manufacture) DEVICEMANUFACTURE="$2"; shift;;
        -h|--help) display_usage; exit 0 ;;
        *) printf "Unknown parameter passed: %s\n" "$1"; display_usage; exit 1 ;;
    esac
    shift
done

# Set default values if arguments are not provided
INPUTLISTFILE="${INPUTLISTFILE:-proprietary-blobs.txt}"
INPUTFOLDER="${INPUTFOLDER:-vendor}"

# Update paths
INPUTLISTFILE="${PROJECT_DIR}/${INPUTLISTFILE}"

# prepare
prepare_working_space

# Main
checkProjectDirectory
generate_dir_paths
create_out_dirs
copy_files
generate_android_mk
generate_boardconfig_mk
generate_vendor_mk
add_local_path
add_copyright_header_to_files

rm -r temp
