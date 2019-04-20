nop
li x1, 128
li x2, 8
li x3, 16
li x4, 24
lui x5, 1
auipc x6, 1
sub x6, x6, x5
and x7, x4, x2
beq x7, x2, eight
bgeutaken: srli x11, x11, 1
bge x13, x11, eight
jal x2, jalhere
srli x14, x13, 20
srai x15, x11, 20
slt x16, x14, x16
beq x10, x16, beq2
ecall

beq2:
nop
nop
nop
ecall



eight: or x8, x3, x2
slli x9, x3, 1
sltu x10, x8, x9
lui x11, 1048575
ori x13, x0, -1
bgeu x13, x11, bgeutaken
jalhere: sb x13, 200(x0)
sh	x11, 201(x0)
sw x1, 203(x0)
sh x2, 207(x0)
lbu x14, 207(x0)
jalr x0, x14, 0
