///CODE
_START:         
MOV R0 i     
MOV R1 2     
ADD R0 R1     
INC R0         
PUSH R0        
MOV R0 [0x1]  
POP R2         
PUSH R0        
CALL TESTFCT   
JMP START      
_TESTFCT:       
POP R2         
POP R3         
POP R0         
MOV R0 10     
PUSH R0        
PUSH R3        
PUSH R2        
MOV R3 2      
MOV R1 6       
MOV RP0 R1      
MOV R1 9       
MOV RP1 R1      
OUTPUTL 254 RP
RET            
///DATA         
i byte 5      
j bytearray 10 {0 1 2 3 4 5 6 7 8 9}