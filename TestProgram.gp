_START:                         //ADDRESS  0x0000
MOV R0, i;      //0x42000030    //ADDRESS  0x0000
MOV R1, 2;      //0x414002      //ADDRESS  0x0004
ADD R0, R1;     //0x4810        //ADDRESS  0x0007
INC R0;         //0x58          //ADDRESS  0x0009
PUSH R0;        //0x10          //ADDRESS  0x000A
MOV R0, [0x1];  //0x44000001    //ADDRESS  0x000B
POP R2;         //0x16          //ADDRESS  0x000F
PUSH R0;        //0x10          //ADDRESS  0x0010
CALL TESTFCT;   //0x740017      //ADDRESS  0x0011
JMP START;      //0x700000      //ADDRESS  0x0014
_TESTFCT:                       //ADDRESS  0x0017
POP R2;         //0x16          //ADDRESS  0x0017
POP R3;         //0x17          //ADDRESS  0x0018
POP R0;         //0x14          //ADDRESS  0x0019
MOV R0, 10;     //0x41000A      //ADDRESS  0x001A
PUSH R0;        //0x10          //ADDRESS  0x001D
PUSH R3;        //0x13          //ADDRESS  0x001E
PUSH R2;        //0x12          //ADDRESS  0x001F
MOV R3, 2;      //0x41C002      //ADDRESS  0x0020
MOV R1, 6;      //0x414006      //ADDRESS  0x0023 
MOV RP0,R1      //0x4760        //ADDRESS  0x0026
MOV R1, 9;      //0x414009      //ADDRESS  0x0028 
MOV RP1,R1      //0x4740        //ADDRESS  0x002b
OUTPUTL 254, RP;//0x1CFE        //ADDRESS  0x002d
RET;            //0x75          //ADDRESS  0x002f
///DATA                         //ADDRESS  0x0030
i byte;         //0x08          //ADDRESS  0x0030
j byte;         //0x05          //ADDRESS  0x0031
///STACK                        //ADDRESS  0x0031



//RESULT:

    