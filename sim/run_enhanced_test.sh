#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Enhanced Verification Test${NC}"
echo -e "${BLUE}========================================${NC}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="${PROJECT_ROOT}/results"

mkdir -p "${RESULTS_DIR}"

echo -e "${BLUE}Compiling...${NC}"

iverilog -g2012 \
    -o "${RESULTS_DIR}/enhanced_test.out" \
    "${PROJECT_ROOT}/rtl/picorv32.v" \
    "${PROJECT_ROOT}/tb/coverage/advanced_coverage.sv" \
    "${PROJECT_ROOT}/tb/tests/enhanced_verification_test.sv"

if [ $? -ne 0 ]; then
    echo -e "${RED}Compilation failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Compilation successful${NC}"
echo -e "${BLUE}Running test...${NC}"

cd "${RESULTS_DIR}"
vvp enhanced_test.out

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Test completed${NC}"
    echo "Waveform: ${RESULTS_DIR}/enhanced_test.vcd"
    exit 0
fi
