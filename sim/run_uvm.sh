#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

TEST_NAME="${1:-uvm_smoke_test}"

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}  Running UVM Test: ${TEST_NAME}${NC}"
echo -e "${BLUE}================================================${NC}"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="${PROJECT_ROOT}/results"

./compile_uvm.sh
if [ $? -ne 0 ]; then
    exit 1
fi

echo ""
echo -e "${BLUE}Executing test...${NC}"

cd "${RESULTS_DIR}"
vvp uvm_sim.out +UVM_TESTNAME=${TEST_NAME} +UVM_VERBOSITY=UVM_LOW 2>&1 | tee ${TEST_NAME}.log

if grep -q "TEST PASSED" ${TEST_NAME}.log; then
    echo ""
    echo -e "${GREEN}✓ Test completed successfully${NC}"
    echo "Waveform: ${RESULTS_DIR}/uvm_waves.vcd"
    exit 0
else
    echo -e "${RED}✗ Test had issues${NC}"
    exit 1
fi
