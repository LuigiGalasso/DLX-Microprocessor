
addi r1, r0, 100
xor r2, r2, r2

ciclo:
lw r3, 0(r2)
nop
nop
nop 
addi r3, r3, 10
sw 100(r2), r3
subi r1, r1, 1
addi r2, r2, 4
nop
nop
bnez r1, ciclo

addi r4, r0, 65535
nop
nop
nop 
ori r5, r4, 100000
nop
nop
nop
add r6, r4, r5
nop
nop
nop
andi r5, r4, 100000
nop
nop
nop
end:
j end
