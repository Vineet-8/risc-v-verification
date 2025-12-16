# RISC-V UVM Verification with Cadence Xcelium

## Quick Start at College Lab
```bash
# Clone repository
cd ~
git clone https://github.com/Vineet-8/risc-v-verification.git
cd risc-v-verification/cadence_uvm

# Load Cadence tools
module load cadence
# OR
source /path/to/cadence/setup.sh

# Verify
xrun -version

# Run simulation
./run_uvm.sh uvm_smoke_test
```

## Files Included

- `riscv_pkg.sv` - Complete UVM package with:
  - ✅ Transaction (with constraints)
  - ✅ Sequencer
  - ✅ Driver (full implementation)
  - ✅ Monitor (full implementation)
  - ✅ Scoreboard (with reporting)
  - ✅ Coverage Collector (with covergroups)
  - ✅ Agent
  - ✅ Environment
  - ✅ Sequences (base, reset)
  - ✅ Tests (base, smoke)

- `riscv_if.sv` - SystemVerilog interface
- `top_uvm_tb.sv` - Top-level testbench
- `filelist.f` - File list for compilation
- `run_uvm.sh` - Run script
- `Makefile` - Professional automation

## Running Tests
```bash
# Method 1: Using script
./run_uvm.sh uvm_smoke_test

# Method 2: Using Makefile
make run TEST=uvm_smoke_test

# With GUI
make gui TEST=uvm_smoke_test

# Coverage report
make coverage

# Clean
make clean
```

## Expected Output
```
UVM_INFO @ 0: reporter [RNTST] Running test uvm_smoke_test...
UVM_INFO: ========== SMOKE TEST ==========
...
UVM_INFO: *** TEST PASSED ***
```

## Components Verified

✅ All UVM components present:
- Transaction, Sequencer, Driver, Monitor
- Scoreboard, Coverage, Agent, Environment
- Sequences and Tests

✅ Functional coverage tracking
✅ Professional reporting
✅ Complete UVM hierarchy

## Troubleshooting

**Q: xrun not found**
A: Load Cadence module: `module load cadence`

**Q: License error**
A: Contact lab admin for license access

**Q: Compilation error**  
A: Check that picorv32.v exists in `../rtl/` directory

## Success Indicators

- See "UVM_INFO" messages
- "TEST PASSED" at end
- Scoreboard shows transaction counts
- Coverage report generated
- No UVM_ERROR or UVM_FATAL

## Support

For issues, check:
1. Cadence tools loaded: `which xrun`
2. Files present: `ls -lh`
3. Logs: `cat xrun_*.log`

Ask lab admin for:
- Cadence installation path
- License server info
- Module load commands
