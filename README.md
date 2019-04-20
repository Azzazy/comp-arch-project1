# comp-arch-project1
The project is an implementation of the RISCV32IC ISA supporting all user-level instructions.
The implementation features a 5-stage pipeline with instructions fetched every 2 clock cycles to remove the need for a double-ported memory.
The pipeline stages are Fetch / Decode / Execute / Memory / Write-Back.
The branching is situated in the Decode stage to reduce the need for stalling the pipeline.
The instructions are initialised in memory in a begin block. 
Note that the first instruction must be a Nop to properly initialise the program counter.
