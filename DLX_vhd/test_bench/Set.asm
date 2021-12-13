
addi r1, r0, 1;---r1<=1
addi r2, r0, 4;---r2<=4
nop
nop
nop
sge r18, r1, r2 ;---r18<=1
sgei r19, r1, 0 ;---r19<=1
snei r20, r1, 4 ;---r20<=1
sle r21, r1, r2 ;---r21<=1
slei r22, r2, 9 ;---r22<=1
addi r1, r0, 38; ---r1<=38
addi r2, r0, 37; ---r1<=37
nop
nop
nop
sub r1, r1, r2; ---r1<=1
xori r19, r0, 0xF0F0;---r19<=FFFFF0F0

