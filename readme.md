# Team
Abdallah Gabara
Marc Boutros [Team leader]
Mohamed Abdelfattah
Muhammad Azzazy

# Release notes
A RISCV 32I implementation for FPGA. It supports all RISCV32I instructions except for few. It is a single cycle implementation without any pipelining, hence no data hazard occur. All supported instruction are tested and work as expected. The implementation assumes that the program is loaded into the instrucion memory beforehand. The instruction memroy is left word addressable by design.

## Unsupported instructions
FENCE
FENCE.I
ECALL (Halt the program)
EBREAK (Halt the program)
CSRRW
CSRRW
CSRRC
CSRRWI
CSRRSI
CSRRCI
