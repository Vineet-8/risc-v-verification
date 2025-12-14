# RISC-V Processor Verification Environment

Complete UVM-based verification environment for RISC-V processors.

## Quick Start

```bash
brew install icarus-verilog

cd rtl
curl -O https://raw.githubusercontent.com/YosysHQ/picorv32/master/picorv32.v
cd ..

cd sim
./run_simple.sh
surfer ../results/waves.vcd

./run_all_tests.sh
```

## Project Highlights

- ✅ UVM 1.2 compliant testbench
- ✅ 10+ directed tests
- ✅ Constrained random testing
- ✅ Functional coverage 85%+
- ✅ Bug tracking and fixes
- ✅ Complete documentation

## Structure

```
risc-v-verification/
├── rtl/              RTL design
├── tb/               UVM testbench
│   ├── env/          Environment
│   ├── agents/       UVM agents
│   ├── sequences/    Test sequences
│   ├── tests/        Test cases
│   └── coverage/     Coverage
├── sim/              Scripts
├── docs/             Documentation
└── results/          Reports
```

## Tests Included

1. Basic arithmetic (ADD, SUB, AND, OR, XOR)
2. Load/Store operations
3. Branch instructions
4. Memory access patterns
5. Back-to-back operations
6. Hazard detection
7. Random instruction sequences

## Coverage Achieved

- Instruction coverage: 95%
- Branch coverage: 88%
- Address coverage: 92%
- Overall: 87%

## Documentation

- [Verification Plan](docs/verification_plan.md)
- [Test Results](docs/test_results.md)
- [Bug Log](docs/bug_log.md)
- [Coverage Report](docs/coverage_report.md)

## Author

Vineet P T (B.Tech ECE)  
