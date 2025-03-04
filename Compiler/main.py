import sys

if len(sys.argv) > 1:
    first_arg = sys.argv[1]  # sys.argv[0] is the script name
else:
    print("No file provided.")
    exit(0)
with open(first_arg, "r") as file:
    lines = [line.rstrip() for line in file if line.strip()]
vars = []
vars_address = []
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
    tokens = [t.lower() for t in tokens]
    if(tokens[0] == 'mov'):
        if(tokens[1][0] == 'r' and tokens[1][1] != 'p'): #MOV RX, X
            if(tokens[2][0] == 'r' and tokens[2][1] != 'p'): #MOV RX, RY 
                code.append('40')
                code.append(format((int(tokens[2][1])*16)+(int(tokens[1][1])*64),"02x"))
                address = address + 2
            elif(tokens[2].isnumeric()): #MOV RX, C
                code.append('41')
                code.append(format((int(tokens[1][1])*64), "02x"))
                code.append(format(int(tokens[2]),"02x"))
                address = address + 3
            elif(tokens[2] == 'rp'): #MOV RX, RP
                code.append('43')
                code.append(format((int(tokens[1][1])*64+int(tokens[2][2])*16), "02x"))
                address = address + 2
            elif(tokens[2][0]=='[' and tokens[2][-1]==']'): #MOV RX, [C]
                code.append('42')
                code.append(format(int(tokens[1][1])*64, "02x"))
                code.append(format(int(tokens[2][1:-1], (10 if tokens[2][1:3]!='0x' else 16)), "04x"))
                address = address + 4
            else:
                code.append('42') #MOV RX, V
                code.append(format(int(tokens[1][1])*64, "02x"))
                code.append(format(0, "04x"))
                vars.append((tokens[2],address+2))
                address = address + 4
        elif(tokens[1][0]=='[' and tokens[1][-1]==']'): #MOV [X], RX
            if(tokens[1] == '[rp0]' or tokens[1] == '[rp1]'): #MOV [RP], RX
                code.append('45')
                code.append(format((int(tokens[2][1])*64 + 32, "02x")))
                address = address + 2
            else: #MOV [C], RX
                tokens[1] = tokens[1][1:-1]
                code.append('42')
                code.append(format((int(tokens[2][1])*64, "02x")))
                code.append(format(int(tokens[1],(10 if tokens[1][0:2]!='0x' else 16)), "04x"))
                address = address + 4
        elif((tokens[1] == 'rp0' or tokens[1] == 'rp1') and tokens[2][0]=='r' and tokens[2][1].isnumeric()): #MOV RPX, RY
            code.append('43')
            code.append(format((int(tokens[2][1])*64+int(tokens[1][2])*16) + 16, "02x"))
            address = address + 2
        elif(tokens[1] == 'rp' and tokens[2] == 'sp'): #MOV RP SP
            code.append('44')
            code.append('80')
            address = address + 2
        elif(tokens[1] == 'sp' and tokens[2] == 'rp'): # MOV SP, RP
            code.append('44')
            code.append('00')
            address = address + 2
        elif(tokens[2][0] == 'r' and tokens[2][1].isnumeric()):
            code.append('42') #MOV V, RX
            code.append(format((int(tokens[2][1])*64, "02x")))
            code.append(format(0, "04x"))
            vars.append((tokens[1],address+2))
            address = address + 4
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
    if(tokens[0] == 'add' or tokens[0] == 'sub'): 
        if(tokens[1] == 'rp'): #ADD/SUB RP, C
            if(tokens[2] == 'r0' or tokens[2] == 'r1' or tokens[2] == 'r2' or tokens[2] == 'r3'):
                if(tokens[0] == 'add'):
                    code.append('4a')
                else:
                    code.append('52')
                code.append((format(int(tokens[2][1])*64, "02x")))
                address = address + 2
            else:
                if(tokens[0] == 'add'):
                    code.append('4b')
                else:
                    code.append('53')
                code.append(format(int(tokens[2]),"04x"))
                address = address + 3
        elif(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            if(tokens[2] == 'r0' or tokens[2] == 'r1' or tokens[2] == 'r2' or tokens[2] == 'r3'):
                if(tokens[0] == 'add'):
                    code.append('48')
                else:
                    code.append('50')
                code.append(format((int(tokens[2][1])*16)+(int(tokens[1][1])*64),"02x"))
                address = address + 2
            elif(tokens[2].isnumeric()):
                if(tokens[0] == 'add'):
                    code.append('49')
                else:
                    code.append('51')
                code.append(format((int(tokens[1][1])*64),"02x"))
                code.append(format(int(tokens[2]),"02x"))
                address = address + 2
            else:
                print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
                exit(0)
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
    if(tokens[0] == 'inc' or tokens[0] == 'dec'):
        if(tokens[1]=='rp'):
            if(tokens[0] == 'inc'):
                code.append('59')
            else:
                code.append('61')
        elif(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            if(tokens[0] == 'inc'):
                code.append('5')
                code.append(format(8+2*int(tokens[1][1]),"01x"))
            else:
                code.append('6')
                code.append(format(2*int(tokens[1][1]),"01x"))
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
        address = address + 1
    if(tokens[0] == 'cmp'):
        if(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            if(tokens[2] == 'r0' or tokens[2] == 'r1' or tokens[2] == 'r2' or tokens[2] == 'r3'):
                code.append('68')
                code.append(format((int(tokens[2][1])*16)+(int(tokens[1][1])*64),"02x"))
                address = address + 2
            else:
                print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
                exit(0)
        elif(tokens[1] == 'rp' and tokens[2] == 'sp'):
            code.append('69')
            address = address + 1
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
    if(tokens[0] == 'jmp' or 
       tokens[0] == 'jmpa' or 
       tokens[0] == 'jmpb' or 
       tokens[0] == 'jmpe' or 
       tokens[0] == 'call' or 
       tokens[0] == 'jmpc' or 
       tokens[0] == 'jmpz' or 
       tokens[0] == 'ret' ):
        code.append('7')
        address = address + 1
        if(tokens[0] == 'jmp'):
            code.append('0')
        if(tokens[0] == 'jmpa'):
            code.append('1')
        if(tokens[0] == 'jmpe'):
            code.append('2')
        if(tokens[0] == 'jmpb'):
            code.append('3')
        if(tokens[0] == 'call'):
            code.append('4')
        if(tokens[0] == 'ret'):
            code.append('5')
        if(tokens[0] == 'jmpc'):
            code.append('6')
        if(tokens[0] == 'jmpz'):
            code.append('7')
        if(tokens[0] != 'ret'):
            if(tokens[1].isnumeric()):
                code.append(format(int(tokens[1]),"04x"))
            else:
                code.append(format(0,"04x"))
                labels_to_modify.append((tokens[1], address))
            address = address + 2
    if(tokens[0] == 'push'):
        if(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            code.append('1')
            code.append(format(int(tokens[1][1]),"01x"))
            address = address + 1
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
    if(tokens[0] == 'pop'):
        if(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            code.append('1')
            code.append(format(int(tokens[1][1]) + 4,"01x"))
            address = address + 1
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
    if(tokens[0] == 'outputl'):
        address = address + 2
        if(tokens[1] == 'r0' or tokens[1] == 'r1' or tokens[1] == 'r2' or tokens[1] == 'r3'):
            code.append('1d')
            code.append(format((int(tokens[1][1])*64), "02x"))
        elif(tokens[1].isnumeric()):
            if(tokens[2] == 'rp'):
                code.append('1c')
                code.append(format(int(tokens[1]),"02x"))
            elif(tokens[2].isnumeric()):
                code.append('1e')
                code.append(format(int(tokens[1]),"02x"))
                code.append(format(int(tokens[2]),"04x"))
                address = address + 2
            else:
                print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
                exit(0) 
        else:
            print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
            exit(0)
        print('ok')

for i in range(var_data_index+1, len(lines)):
    tokens = lines[i].split(' ')
    tokens = [t.lower() for t in tokens]
    if(len(tokens)<3):
        print('ERROR at line: ' + str(index) + ' data: ' + ' '.join(tokens))
        exit(0)
    vars_address.append((tokens[0],address))
    if(tokens[1] == 'byte'):
        code.append(format(int(tokens[2], (10 if tokens[2][0:2]!='0x' else 16)),"02x"))
        address = address + 1
    if(tokens[1] == 'word'):
        code.append(format(int(tokens[2], (10 if tokens[2][0:2]!='0x' else 16)),"04x"))
        address = address + 2
    if(tokens[1] == 'bytearray' and tokens[2].isnumeric()):
        address = address + int(tokens[2])
        if(len(tokens)>=4):
            if(' '.join(tokens[3:])[0] == '{' and ' '.join(tokens[3:])[-1] == '}'):
                for nr in ' '.join(tokens[3:])[1:-1].split(" "):
                    code.append(format(int(nr,(10 if nr[0:2]!='0x' else 16)),"02x"))
            else:
                print('ERROR at line: ' + str(i) + ' data: ' + ' '.join(tokens))
                exit(0)
code = ''.join(code)
code = [code[i:i+2] for i in range(0, len(code), 2)]

for _ in labels_to_modify:
    addr = 0
    for l in labels:
        if(l[0].lower() == _[0].lower()):
            addr = l[1]
            code[_[1]] = format(addr, "04x")[0] + format(addr, "04x")[1]
            code[_[1]+1] = format(addr, "04x")[2] + format(addr, "04x")[3]
            break

for _ in vars:
    addr = 0
    for l in vars_address:
        if(l[0].lower() == _[0].lower()):
            addr = l[1]
            code[_[1]] = format(addr, "04x")[0] + format(addr, "04x")[1]
            code[_[1]+1] = format(addr, "04x")[2] + format(addr, "04x")[3]
            break
size = len(code)
code.insert(0, format(size,"04x")[0:2])
code.insert(0, format(size,"04x")[2:])

rom_sticks = code = [code[i:i+256] for i in range(0, len(code), 256)]

print(rom_sticks)
f = open("RomData.vh", "w")
d = ''
for index, _ in enumerate(rom_sticks, start=0):
    d = ''
    d = d + "localparam logic [7:0] ROM_STICK_" + str(index) + "[255:0] = '{\n"
    for index2, i in enumerate(_, start=0):
        d = d + str(index2) + ":8'h" + i + ', '
        if(index2 % 10 == 9):
            d = d+'\n'
    if(len(_) != 256):
        d = d + "default:8'h00"
    else:
        d = d[0:-1]
    d = d + "\n};"
    f.write(d)
    f.write('\n')
