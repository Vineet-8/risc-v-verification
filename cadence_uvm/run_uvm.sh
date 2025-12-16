#!/bin/bash

TEST="${1:-uvm_smoke_test}"

echo "=========================================="
echo "  Cadence Xcelium UVM Simulation"
echo "=========================================="
echo "Test: $TEST"

xrun \
    -64bit \
    -sv \
    -uvm \
    +UVM_TESTNAME=$TEST \
    +UVM_VERBOSITY=UVM_MEDIUM \
    -access +rwc \
    -linedebug \
    -coverage all \
    -covoverwrite \
    -f filelist.f \
    -log xrun_${TEST}.log \
    -timescale 1ns/1ps

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Simulation completed"
    echo "Log: xrun_${TEST}.log"
else
    echo "✗ Simulation failed"
    exit 1
fi
