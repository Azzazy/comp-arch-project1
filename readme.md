# RISCV32I FPGA Implementation
## Team
- Abdallah Gabara
- Marc Boutros [Team leader]
- Mohamed Abdelfattah
- Muhammad Azzazy

## Release notes
A RISCV 32I implementation for FPGA. It supports all RISCV32I instructions except for few. It is a pipelined implementation, hence there is a data hazard unit and a forwarding unit. All supported instruction are tested and work as expected. The memory is single ported and shared between instructions and data. To structural hazards a single instruction is fetched every two clock cycles.

### Unsupported instructions
- FENCE
- FENCE.I
- ECALL (Halt the program)
- EBREAK (Halt the program)
- CSRRW
- CSRRW
- CSRRC
- CSRRWI
- CSRRSI
- CSRRCI
