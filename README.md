# Attendance Marker

### Tells the name of missing students from a class list

- Written in Combination of Bash & Python
- Bash is for cleaning up the csv file generated that records the attendance, install [this extension](https://github.com/al-caughey/Google-Meet-Attendance) to generate the csv file and write it to a text file
- Python compares the Classlist with cleaned up list
- Can add teacher names to it as well

### Usage:

- Paste the CSV in the folder where this repository is contained and rename it to Attendance.csv
- Execute the following command

``/bin/sh src/AttendanceMarker.sh Attendance.csv``