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
#!/bin/bash

cd src

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

echo -e "Cleaning up."
rm -rf ../out
mkdir -p ../out/tmp

# Used for cleanup of CSV generated from extension
NoOfLines=$(wc -l ../$CSV_FILE | awk '{ print $1 }')

# Cleanup the CSV File
CLEAN_CSV_CONTENT=$(cat ../$CSV_FILE | sed "$(( ${NoOfLines}-2)),$ d" | sed '1,4d')
echo -e "$CLEAN_CSV_CONTENT" > CSV_Cleanup.txt

# Prints the first column into a file ready for Attendance
NAME_OF_STUDENTS=$(cat CSV_Cleanup.txt | sed 's/",.*//g' | sed 's/"//g')
echo -e "$NAME_OF_STUDENTS" > Attendance.txt

read -p "Generate list of Absent students?[y/n] :" Absenties
if [[ $Absenties == 'y' || $Absenties == 'Y' ]]; then
    python3 AttendanceMarker.py > ../out/Absenties.txt
fi

echo
read -p "Generate last seen of students in gmeet?[y/n] :" Last_present

if [[ $Last_present == 'y' || $Last_present == 'Y' ]]; then
    echo -e "Generating LastSeen.txt"
    echo -e "$(cat ../Inputs/HEADER.txt)\n" >> AttendanceTime.txt
    while read p; do 
        if grep -Fxq "$p" ../Inputs/Teachers.txt ;then
        	continue
        fi
        FIRST_Seen=$(grep "$p" CSV_Cleanup.txt | awk '{ print $7 }' | sed 's/"//g' | sed 's/,//g')
        LAST_Seen=$(grep "$p" CSV_Cleanup.txt | awk '{ print $8 }' | sed 's/"//g' | sed 's/,//g')
        DIFF=$(( $(date -d "$LAST_Seen" "+%s") - $(date -d "$FIRST_Seen" "+%s") ))
        TIME_IN_MEET=$(echo "scale=2 ; (($DIFF/3600))*60" | bc )
        grep "$p" CSV_Cleanup.txt | awk '{ print $1 " " $2 " : " $9 " mins"}' | sed 's/"//g' | sed 's/,//g' >> AttendanceTime.txt
    done < Attendance.txt
fi

read -p "Display output?[y/n] :" Output
echo
if [[ $Output == 'y' || $Output == 'Y' ]]; then
    clear
    echo 
    cat ../out/Absenties.txt
    echo -e "\nName of student and time in GMeet:\n"
    cat AttendanceTime.txt | sed '1,17d'
fi

# Move all files to output directory
mv Attendance.txt ../out/tmp
mv AttendanceTime.txt ../out/
mv CSV_Cleanup.txt ../out/tmp

cd ..