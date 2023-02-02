#!/bin/bash

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

FLOMINATOR_ROOT="${MY_DIR}"


# run main script
source "$FLOMINATOR_ROOT/subroutine-scripts/rabin2dump.sh"


