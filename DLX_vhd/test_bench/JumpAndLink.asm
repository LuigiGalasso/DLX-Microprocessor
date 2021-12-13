addi r25, r25,1 ; r25 <= 1
nop
nop
nop
sne r20, r25, r20 ; just to try 
myloop:
add r1, r1, r25   ; r1 <= 1, 17 , 145
nop
nop
nop
add r1, r25, r1   ; r1 <= 2, 18 , 146
nop
nop
nop
add r1, r1, r1    ; r1 <= 4, 36 , 292
nop
nop
nop
add r1, r1, r1    ; r1 <= 8, 72 , 584
nop
nop
nop
add r1, r1, r1    ; r1 <= 16,144, 1168
nop
xor r20, r20, r25 ; toggle lsb of r20.
nop
nop
nop
and r20, r20, r25 ; 

jal myloop   	  ; PC = PC + 4 - 11*4 = -40 (28 hexadecimal) = go to the beginning of the program. 
