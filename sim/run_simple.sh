#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  RISC-V Simple Simulation${NC}"
echo -e "${BLUE}========================================${NC}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RTL_DIR="${PROJECT_ROOT}/rtl"
TB_DIR="${PROJECT_ROOT}/tb"
RESULTS_DIR="${PROJECT_ROOT}/results"

mkdir -p "${RESULTS_DIR}"

echo -e "${BLUE}[1/3] Checking files...${NC}"

if [ ! -f "${RTL_DIR}/picorv32.v" ]; then
    echo -e "${RED}ERROR: picorv32.v not found${NC}"
    echo "Download it first:"
    echo "  cd ${RTL_DIR}"
    echo "  curl -O https://raw.githubusercontent.com/YosysHQ/picorv32/master/picorv32.v"
    exit 1
fi

echo -e "${GREEN}✓ Files OK${NC}"

echo -e "${BLUE}[2/3] Compiling...${NC}"
iverilog -g2012 -o "${RESULTS_DIR}/sim.out" \
    "${RTL_DIR}/picorv32.v" \
    "${TB_DIR}/simple_tb.sv"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Compilation successful${NC}"
else
    echo -e "${RED}✗ Compilation failed${NC}"
    exit 1
fi

echo -e "${BLUE}[3/3] Running simulation...${NC}"
cd "${RESULTS_DIR}"
vvp sim.out

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}Success! Waveform saved to:${NC}"
    echo "  ${RESULTS_DIR}/waves.vcd"
    echo ""
    echo -e "View with: ${BLUE}surfer ${RESULTS_DIR}/waves.vcd${NC}"
    echo ""
else
    echo -e "${RED}✗ Simulation failed${NC}"
    exit 1
fi
