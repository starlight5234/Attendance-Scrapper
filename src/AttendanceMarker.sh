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

[ ! -d "out/tmp" ] && mkdir out/tmp -p

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        * )
            CSV_FILE=${1}
            ;;
    esac
    shift
done

if [ ! -s "${CSV_FILE}" ]; then
    echo "Attendance.csv is missing"
    exit
fi

cd src

read -p "Enter Division of Class to take attendance of: " DIV
DIV=${DIV^^}

if [ ! -z ${DIV}  ]; then
    CLASS_LIST_FILE_NAME="Classlist-${DIV^^}.txt"
    echo "${DIV}" > ../out/tmp/Division.txt
else
    CLASS_LIST_FILE_NAME="Classlist.txt"
    echo " " > ../out/tmp/Division.txt
fi

# Used for cleanup of CSV generated from extension
NoOfLines=$(wc -l ../$CSV_FILE | awk '{ print $1 }')

# Cleanup the CSV File
CLEAN_CSV_CONTENT=$(cat ../$CSV_FILE | sed "$(( ${NoOfLines}-2)),$ d" | sed '1,4d')
echo -e "$CLEAN_CSV_CONTENT" > CSV_Cleanup.txt

# Prints the first column into a file ready for Attendance
NAME_OF_STUDENTS=$(cat CSV_Cleanup.txt | sed 's/",.*//g' | sed 's/"//g')
echo -e "$NAME_OF_STUDENTS" > Attendance.txt
python3 Cleanup.py > Attendance_Cleaned.txt

[ ! -s ../Inputs/${CLASS_LIST_FILE_NAME} ] && CLASS_LIST_MISSING="1"

if [[ $CLASS_LIST_MISSING == "1" ]]; then
    echo "!! Warning: There was no classlist of Division ${DIV} found !!"
    echo "If this was your first day of running this program then it is fine you can ignore the warning"
    echo "If this was not your first day contact then you might have deleted your Students Class list"
    echo "However there was a classlist generated based on your today's class."
    rm -f CSV_Cleanup.txt
    read -p "Would you like to set that as your default Class list(Leave empty to respond with no)? " CLASS_LIST_COPY

    if [ ! -z ${CLASS_LIST_COPY}  ]; then
        cp Attendance_Cleaned.txt ../Inputs/${CLASS_LIST_FILE_NAME}
        chmod 400 ../Inputs/${CLASS_LIST_FILE_NAME}
        echo "The list generated from today's attendance is set as your default classlist and locked from editing."
    fi

    rm -f Attendance_Cleaned.txt
    echo "Exiting.."
    exit
fi

echo "Cleaning up."

echo "Generating list of Absent students of Div $(cat ../out/tmp/Division.txt)"
python3 AttendanceMarker.py > ../out/Absenties.txt

echo "Generating Attendance time of students"
echo -e "$(cat ../Inputs/HEADER.txt)\n" >> AttendanceTime.txt
while read p; do 
    if grep -Fxq "$p" ../Inputs/Teachers.txt ;then
    	continue
    fi
    
    TIME_IN_MEET=$(grep "$p" CSV_Cleanup.txt | awk '{ print $9 }' | sed 's/"//g' | sed 's/,//g')
    if [ ! -z $TIME_IN_MEET ];then
        grep "$p" CSV_Cleanup.txt | awk -F, '{ print $1 " : " $7 " mins"}' | sed 's/"//g' | sed 's/,//g' >> AttendanceTime.txt
    else
        echo "$(grep "$p" CSV_Cleanup.txt | awk -F, '{ print $1 }' | sed 's/"//g' | sed 's/,//g') : 0 mins" >> AttendanceTime.txt
    fi
done < Attendance_Cleaned.txt

mv AttendanceTime.txt ../out/

# Move all files to output directory
mv Attendance_Cleaned.txt ../out/tmp/Attendance.txt
mv CSV_Cleanup.txt ../out/tmp

cd ..

echo
cat out/Absenties.txt