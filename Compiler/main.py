import sys

if len(sys.argv) > 1:
    first_arg = sys.argv[1]  # sys.argv[0] is the script name
else:
    print("No file provided.")
    exit(0)
with open(first_arg, "r") as file:
    lines = [line for line in file if line.strip()]
vars = []
labels = []
labels_to_modify = []
var_data_index = -1
var_code_index = -1
for index, _ in enumerate(lines, start=0):
    if _.strip().lower().startswith("///data"):
        var_data_index = index
    if _.strip().lower().startswith("///code"):
        var_code_index = index
if(var_code_index == -1 or var_data_index == -1):
    print("No code or data found!")
    exit(0)

address = 0;
code = []
for i in range(var_code_index+1, var_data_index):
    if(lines[i].startswith('_') and lines[i].endswith(':')):
        labels.append((lines[i][1:-1], address))
        continue
    tokens = lines[i].split(' ')
    if(tokens[0].lower() == 'mov'):
    if(tokens[0].lower() == 'add'):
    if(tokens[0].lower() == 'inc'):
    if(tokens[0].lower() == 'dec'):
    if(tokens[0].lower() == 'push'):
    if(tokens[0].lower() == 'pop'):
    if(tokens[0].lower() == 'jmp'):
    if(tokens[0].lower() == 'call'):
    if(tokens[0].lower() == 'jmpa'):
    if(tokens[0].lower() == 'jmpb'):
    if(tokens[0].lower() == 'jmpe'):
