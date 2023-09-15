# android-flominator-scripts
Collection of personal noob scripts.

git clone https://github.com/FlominatorGD/android-flominator-scripts.git -b flominator flominator

Current scripts:

a script that turns every .so file in subdirs of a ROM DUMP
into a shellscript formart, that can test buildability of them as PRODUCT_PACKADGES

# perpare instructions

 dir:
$cd flominator

  recrusive script permission:
$chmod +x *

# usage instuctions makelib-init.sh

$./makelib-init.sh

# usage instuctions generate-vendor.sh

How to gen qick gen a proprietary-blobs.txt list FOR THIS SCRIPT from a existing vendor dir with vendor files:

$find vendor -type f -printf '%P\n' | sort > proprietary-blobs.txt

put a proprietary-blobs.txt in $input/ folder.

$./generate-vendor.sh -h for usage instructions

