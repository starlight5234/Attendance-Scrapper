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

import os

Attendance_Today = list(open("Attendance.txt", "r"))
Teacher_list = list(open("../Inputs/Teachers.txt", "r"))

for x in Attendance_Today:
    if x not in Teacher_list:
        print(f"{x.strip()}")

os.remove("Attendance.txt")