#!/bin/bash

# unused realpath
# SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

FLOMINATOR_ROOT="${MY_DIR}"


# Cleanup subdirs if exists
for d in $(find * -type d)

do

(cd "$d" && for i in *; do rm -rf dump-lib; done)

done

# Cleanup subdirs if exists

for d in $(find * -type d)

do

(cd "$d" && for i in *; do rm -rf linked-lib; done)

done

for d in $(find * -type d)

do

(cd "$d" && for i in *; do rm -rf flominator; done)

done

# unused realpath checks
# echo $SCRIPT_DIR;

# loop to find every .so file
for d in $(find * -type d)
do
 (cd "$d" && for i in *; do mkdir -p dump-lib && touch dump-lib/$i.txt && rabin2 -g $i > dump-lib/$i.txt && rm -rf $i.txt; done)
#Find all *.so files, accessible in $d:

# unused check subdirs
#echo $d
#cat $d/$i.txt

done
# (cd "$d" && for i in *.so; do rm -rf tmp.txt; done)
# unused check subdirs
#echo $d

# unused test to check if dirs are cleaned up
# cat $d/test-make-lib.sh > testfile.txt

#done
