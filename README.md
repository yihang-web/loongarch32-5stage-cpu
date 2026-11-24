# LoongArch32 Five-Stage CPU

A 32-bit LoongArch32 subset processor written in Verilog. The core implements
a classic IF/ID/EX/MEM/WB pipeline with forwarding, load-use stalling, branch
resolution, pipeline flushing, and a small branch target buffer.

This repository contains the portfolio-relevant RTL from a larger FPGA project.
Course-provided verification assets, generated Xilinx IP, and Vivado build
products are intentionally excluded.

## Highlights

- Five-stage pipeline: IF, ID, EX, MEM, and WB
- Arithmetic, logical, immediate, load/store, and branch instructions
- EX-stage forwarding from both MEM and WB
- Load-use dependency detection and one-cycle stall logic
- Pipeline flush when a branch is resolved or a prediction is corrected
- 512-entry branch target buffer with a two-bit direction state
- Register file with `x0` hard-wired to zero
- Debug write-back signals for instruction-level tracing
- Separate four-way set-associative read cache developed for the same
  computer-organization coursework

## Pipeline

```text
instruction memory
       |
      IF -> IF/ID -> ID -> ID/EX -> EX -> EX/MEM -> MEM -> MEM/WB -> WB
             \       decoder      ALU       data memory       regfile
              \
               +---- branch target buffer and pipeline control
```

The `cpu` module exposes separate instruction and data SRAM interfaces. This
keeps the core independent of board-specific memory, LCD, AXI, and clock IP.

## Supported instruction subset

| Class | Instructions |
|---|---|
| Register-register | `add.w`, `sub.w`, `and`, `mul.w` |
| Shift / immediate | `slli.w`, `slti`, `ori`, `addi.w` |
| Memory | `ld.w`, `st.w` |
| Control flow | `b`, `beq` |

The decoder is intentionally limited to the subset exercised by the original
laboratory project. It is not a full LoongArch32 implementation.

## Repository layout

```text
rtl/
  my_cpu.v          pipeline registers, PC logic, hazards, forwarding
  my_decoder.v      instruction decoder and immediate generation
  my_alu.v          arithmetic logic unit
  my_register.v     register file
  btb.v             512-entry branch target buffer
extensions/
  four_way_cache.v  16 KiB four-way set-associative read cache
```

The cache module is a companion experiment and is not instantiated by the
five-stage core above. It uses a 128-set, four-way organization with 32-byte
lines, pseudo-LRU replacement, and an AXI read interface.

## Core interface

The main module is `cpu` in `rtl/my_cpu.v`.

```verilog
module cpu (
    input         clk,
    input         resetn,
    output        inst_sram_en,
    output [31:0] inst_sram_addr,
    input  [31:0] inst_sram_rdata,
    output        data_sram_en,
    output [ 3:0] data_sram_wen,
    output [31:0] data_sram_addr,
    output [31:0] data_sram_wdata,
    input  [31:0] data_sram_rdata,
    output [31:0] debug_wb_pc,
    output        debug_wb_rf_wen,
    output [ 4:0] debug_wb_rf_wnum,
    output [31:0] debug_wb_rf_wdata
);
```

## Source check

The RTL was checked with Vivado 2020.2 `xvlog`. To repeat the check:

```powershell
xvlog rtl/my_alu.v
xvlog rtl/my_register.v
xvlog rtl/my_decoder.v
xvlog rtl/btb.v
xvlog rtl/my_cpu.v
xvlog extensions/four_way_cache.v
```

No board-level Xilinx IP is required for these source checks.

## Scope

This repository is a source-code portfolio, not a turnkey Vivado project. The
original project used generated ROM/RAM IP and a course checker. Those assets
are omitted so the repository remains small and contains only the work intended
for public review.
