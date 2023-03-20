#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
if echo "${PROJECT_DIR}" | grep " "; then
	printf "\nProject Directory Path Contains Empty Space,\nPlace The Script In A Proper UNIX-Formatted Folder\n\n"
	sleep 1s && exit 1
fi

read -p 'Android device Name: ' uservar

SCRPTDIR="${PROJECT_DIR}"
INPUTLISTDIR="${PROJECT_DIR}"/input
TEMPDIR="${PROJECT_DIR}"/temp
OUTTDIR="${PROJECT_DIR}"/out

rm -rf "${TEMPDIR}"
rm -rf "${PROJECT_DIR}"/out
mkdir -p "${TEMPDIR}"
mkdir -p "${TEMPDIR}"/a
mkdir -p "${TEMPDIR}"/b
mkdir -p "${TEMPDIR}"/c
mkdir -p "${PROJECT_DIR}"/out

cp "${INPUTLISTDIR}"/proprietary-blobs.txt "${TEMPDIR}"/proprietary-blobs.txt

cat ${SCRPTDIR}/temp/proprietary-blobs.txt | while read line || [[ -n $line ]];
do
   i=$((i+1))
   filename=$(basename -- "$line")
   fullname="$line"
   printf '$(LOCAL_PATH)/proprietary/vendor/' > "${TEMPDIR}"/a/2.txt
   printf "$fullname"  >  "${TEMPDIR}"/a/3.txt
   printf ':$(TARGET_COPY_OUT_VENDOR)/' > "${TEMPDIR}"/a/4.txt
   printf "$fullname" > "${TEMPDIR}"/a/6.txt
   printf ' \' > "${TEMPDIR}"/a/7.txt
   printf "\n" > "${TEMPDIR}"/a/8.txt
   
   
cat "${TEMPDIR}"/a/*.txt > "${TEMPDIR}"/b/$filename.txt | sort
done;
echo '# Copyright (C) 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
' > "${TEMPDIR}"/c/1.txt
echo 'LOCAL_PATH := $(call my-dir)

' > "${TEMPDIR}"/c/2.txt
echo 'PRODUCT_COPY_FILES += \' > "${TEMPDIR}"/c/3.txt
cat "${TEMPDIR}"/b/*.txt > "${TEMPDIR}"/c/4.txt
cat "${TEMPDIR}"/c/*.txt > "${OUTTDIR}"/$uservar-vendor.mk

# Common Android.mk
echo '# Copyright (C) 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)
' > ${OUTTDIR}/Android.mk

# DUMMY BoardConfigVendor.mk
echo '# Copyright (C) 2023 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

' > ${OUTTDIR}/BoardConfigVendor.mk
rm -rf "${TEMPDIR}"

echo 'generated vendor makefiles from input/proprietary-blobs.txt'
echo 'product in out/'
