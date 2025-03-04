///CODE
_START:                         //ADDRESS 0x0000
MOV RP [j]    //0x460026        //ADDRESS 0x0000
MOV R3 8     //0x41c008        //ADDRESS 0x0003
_LOOP_1:                        //ADDRESS 0x0006
MOV R0 [RP]   //0x4500          //ADDRESS 0x0006
INC RP        //0x59            //ADDRESS 0x0008
MOV R1 RP0    //0x4340          //ADDRESS 0x0009
MOV R2 RP1    //0x43A0          //ADDRESS 0x000b
MOV RP0 R0    //0x4310          //ADDRESS 0x000d
MOV R0 R3     //0x4030          //ADDRESS 0x000f
ADD R0 8      //0x490008        //ADDRESS 0x0011
DEC R0        //0x60            //ADDRESS 0x0014
MOV RP1 R0    //0x4330          //ADDRESS 0x0015
OUTPUT 254 RP //0x1CFE          //ADDRESS 0x0017
MOV RP0 R1    //0x4350          //ADDRESS 0x0018
MOV RP1 R2    //0x43A0          //ADDRESS 0x001b
DEC R3        //0x66            //ADDRESS 0x001d
JMPZ DONE     //0x770023        //ADDRESS 0x001e
JMP LOOP_1    //0x700006        //ADDRESS 0x0021
_DONE:                          //ADDRESS 0x0024
JMP DONE      //0x700022        //ADDRESS 0x0024
///DATA         
j bytearray 8 {0 1 2 3 4 5 6 7} //0x0027
