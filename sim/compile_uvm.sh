#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Compiling UVM Testbench...${NC}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UVM_HOME="${PROJECT_ROOT}/uvm-core/src"
RESULTS_DIR="${PROJECT_ROOT}/results"

if [ ! -d "${UVM_HOME}" ]; then
    echo -e "${RED}ERROR: UVM not found${NC}"
    exit 1
fi

mkdir -p "${RESULTS_DIR}"

iverilog -g2012 \
    -I"${UVM_HOME}" \
    -I"${PROJECT_ROOT}/tb" \
    -I"${PROJECT_ROOT}/tb/env" \
    -I"${PROJECT_ROOT}/tb/sequences" \
    -I"${PROJECT_ROOT}/tb/tests" \
    -o "${RESULTS_DIR}/uvm_sim.out" \
    "${PROJECT_ROOT}/rtl/picorv32.v" \
    "${PROJECT_ROOT}/tb/riscv_if.sv" \
    "${PROJECT_ROOT}/tb/env/riscv_pkg.sv" \
    "${PROJECT_ROOT}/tb/top_uvm_tb.sv" \
    2>&1 | tee "${RESULTS_DIR}/compile_uvm.log"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation successful${NC}"
    exit 0
else
    echo -e "${RED}✗ Compilation failed${NC}"
    tail -20 "${RESULTS_DIR}/compile_uvm.log"
    exit 1
fi
