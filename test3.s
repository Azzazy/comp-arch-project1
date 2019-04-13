nop
lui x1, 1
addi x2, x0, 1
add x3, x2, x2
addi x4, x0, 4
addi x5, x0, 8
addi x6, x0, 16
or x7, x6, x5
or x8, x4, x3
or x8, x8, x7
ori x8, x8, 1
addi x7, x0, 30
blt x7, x8, branch
nop
nop
nop
nop
branch:jalr x4, x4, 4
addi x10, x0, 100
blt x10, x6, branch