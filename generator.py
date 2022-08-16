import datetime, platform, re, os

Date = datetime.datetime.now()

Subject = input("Subject: ")
# Subject = "DBMS"

# browser = input("Enter Browser [ff for firefox, or leave blank for gc]: ")
# Different browsers have different extensions for scrapping
browser = "ff"

# Roll number of the last student
max_roll = int(input("Enter the maximum roll number in class: "))

if max_roll == 0:
    print("There can't be 0 people in a class!")
    exit()

discard = list(map(int,input("Enter the roll numbers to discard(not in class anymore): ").strip().split()))
# discard = [26, 80] # No longer in class

# Clean the CSV
def clean_win(genloc):
    lines = []
    if os.path.exists(f'{genloc}\\out\\temp\\cleaner.txt'):
        os.remove(f'{genloc}\\out\\temp\\clean.txt')
        os.remove(f'{genloc}\\out\\temp\\cleaner.txt')

    cleanf = open(f'{genloc}\\out\\temp\\clean.txt', "w")
    with open(f'{genloc}\\atd.csv', 'r+') as fp:
        lines = fp.readlines()
        fp.seek(0)
        if(browser == "ff"):
            cleanf.writelines(lines[4:-4])
            cleanf.close()
        else:
            cleanf.writelines(lines[1:])
            cleanf.close()
        
        cleanf = open(f'{genloc}\\out\\temp\\clean.txt', "r")
        cleanerf = open(f'{genloc}\\out\\temp\\cleaner.txt', "w")
        for line in cleanf.readlines():
            line = re.sub('",.*', "", line)
            line = re.sub('"', "", line)
            if ("Others" in line) or (line.strip() in teacher_list):
                continue
            cleanerf.write(line)

def clean_lin():
    pass

if platform.system() == "Windows":
    genloc = "G:\\College\\projects\\Attendance-Scrapper"
    HF = open(f'{genloc}\\input\\HEADER.txt', "r")
    teacher_list = list(open(f'{genloc}\\input\\Teachers.txt', "r"))
    clean_win(genloc)
    Attendance_Today = list(open(f'{genloc}\\out\\temp\\cleaner.txt', "r"))
    f = open(f'{genloc}\\out\\{Subject}-{Date.strftime("%d-%m-%Y")}.txt', "w")
    if not os.path.exists(f'{genloc}\\out'):
        os.mkdir(f'{genloc}\\out')

else:
    HF = open('./input/HEADER.txt', "r")
    teacher_list = list(open(f'./input/Teachers.txt', "r"))
    clean_lin()
    Attendance_Today = list(open('./out/temp/cleaner.txt', "r"))
    f = open(f'./out/{Subject}-{Date.strftime("%d-%m-%Y")}.txt', "w")

head = (HF.read())

# Count Entries
i = 0
for x in Attendance_Today:
    i=i+1

# Print & Write some basic info
f.write(f'{head}\n')
f.write(f'Date: {Date.strftime("%a %d %b %Y")} \n')
f.write(f'Present for {Subject}: {i} out of {max_roll - len(discard)}\n\n')

print(head)
print(f'Date: {Date.strftime("%a %d %b %Y")}')
print(f"Present for {Subject}: {i} out of {max_roll - len(discard)}")

# Print students that are present
num_list = []
present_list = []
for x in Attendance_Today:
    number = (x.rpartition('_')[0]).strip()
    num_list.append(number)
    name = (x.rpartition('_')[2]).strip().title()
    f_name = (f'{number} {name}').strip()
    present_list.append(f_name)

num_list = [num.lstrip('0') for num in num_list]
new_list = []

for element in num_list:
    if element == "":
        continue
    new_list.append(int(element))

j=0

print(f'Absent Roll numbers: ')
f.write(f'Absent Roll numbers: ')
for x in range(1, (max_roll + 1)):
    if (x in discard):
        continue
    if x not in new_list:
        print(x, end=" ")
        f.write(f'{x} ')
        j = j+1

print(f'\nTotal absent: {j}\n')
f.write(f'\nTotal absent: {j}\n')

f.write(f'\nPresentie list: \n')
for x in present_list:
    f.write(x + "\n")
    #print(f_name)