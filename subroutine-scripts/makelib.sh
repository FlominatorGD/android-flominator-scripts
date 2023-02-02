#!/bin/bash

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

# unused realpath
# SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# unused realpath checks
# echo $SCRIPT_DIR;

# loop to find every .so file
for d in $(find * -type d)
do
 (cd "$d" && for i in *.so; do touch temp.txt && echo "make $i" | rev | cut -c4- | rev; done > tmp.txt)
#Find all *.so files, accessible in $d:

# unused check subdirs
#echo $d
cat $d/tmp.txt

done

# Cleanup subdirs
for d in $(find * -type d)
do
 (cd "$d" && for i in *.so; do rm -rf tmp.txt; done)
# unused check subdirs
#echo $d

# unused test to check if dirs are cleaned up
# cat $d/test-make-lib.sh > testfile.txt

done
