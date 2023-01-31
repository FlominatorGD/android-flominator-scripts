#!/bin/bash

# make sure makelib-tmp.sh is created
touch makelib-tmp.sh

# run main script
source subroutine-scripts/makelib.sh > makelib-tmp.sh

# make sure target lib is created
touch target-lib.sh

# target libs terminal ouput and filter generates from subdirs that dont contain a *.so file
cat makelib-tmp.sh | grep -v '*'

# target libs sh ouput
cat makelib-tmp.sh | grep -v '*' > target-lib.sh

# cleanup unused temp stuff
rm -rf makelib-tmp.sh
rm -rf subroutine-scripts/tmp.txt
