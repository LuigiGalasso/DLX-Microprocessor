addi r1, r0, 42
addi r2, r0, 0xAAAAAAAA
nop
nop
nop
or r3, r1, r2
addi r1, r0, 2
nop
nop
nop
sll r4, r3, r1
slli r5, r3, 2
nop
nop
nop
srl r6, r5, r1
srli r7, r4, 2;r6, r7 must be equal
addi r2, r0, 0xF0000000
ori r3, r0, 0xF0F0F0F0
addi r1, r0, 5

