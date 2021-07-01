#
# Copyright (C) 2021 Starlight5234
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#!/bin/sh

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        * )
            CSV_FILE=${1}
            ;;
    esac
    shift
done

if [ -z "${CSV_FILE}" ]; then
    echo "No input given"
    exit
fi

NoOfLines=$(wc -l $CSV_FILE | awk '{ print $1 }')

TMP_CONTENT=$(cat $CSV_FILE | sed "$(( ${NoOfLines}-2)),$ d" | sed '1,4d' | sed 's/",.*//g' | sed 's/"//g')
echo -e "$TMP_CONTENT" > Attendance.txt

python3 AttendanceMarker.py

rm -f Attendance.txt
