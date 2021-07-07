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

Class_List = list(open("../Inputs/Classlist.txt", "r"))
Attendance_Today = list(open("Attendance.txt", "r"))
Teacher_list = list(open("../Inputs/Teachers.txt", "r"))
HEADER = open("../Inputs/HEADER.txt", "r")


print(HEADER.read())
print("Name of absent students: ")
i=1

for x in Class_List:

    if x in Teacher_list:
        continue

    if x not in Attendance_Today:
        print(f"{i}. {x.strip()}")
        i = i+1