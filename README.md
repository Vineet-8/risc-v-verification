#  RISC-V Processor Verification Environment  
**End-to-end Verification Framework for PicoRV32**

![Tests](https://img.shields.io/badge/tests-26%2F26%20passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-~90%25-green)

---

## 📌 Introduction

This repository presents a **professional, end-to-end verification environment** developed for the **PicoRV32 RISC-V processor**.  
The project demonstrates **end-to-end verification practices**, combining **directed testing**, **coverage-driven verification**, and **automated regression**, similar to workflows used in commercial silicon validation teams.

The work is organized into **two clearly defined phases**:

- **Phase 1:** Functional correctness using structured directed tests  
- **Phase 2:** Enhanced coverage-driven verification with advanced analysis

Together, both phases achieve **~90% average functional coverage**, exceeding the **85%  benchmark**, with a **100% test pass rate**.

---

## 🎯 Project Objectives

- Build a modular and scalable verification environment  
- Verify arithmetic, memory, and control-flow functionality  
- Achieve comprehensive functional coverage across arithmetic, memory, and control-flow paths 
- Automate regression and waveform-based debugging  
- Demonstrate professional semiconductor verification skills  

---

## 📊 Key Results Summary

| Metric | Target | Achieved |
|------|-----------------|----------|
| Test Suites | — | **5** |
| Total Checks | — | **26 / 26 Passing** |
| Functional Coverage | 85% | **~90%** |
| Regression Status | Stable | **100% Pass** |

---

## 🧩 Verification Architecture

- SystemVerilog-based testbench  
- Directed and scenario-driven tests  
- Centralized functional coverage collector  
- Automated regression using shell scripts  
- Waveform-based debug using VCD traces  

---

# 🔹 Phase 1: Core Functional Verification

## Objective
Establish functional correctness of the PicoRV32 core using **directed instruction-level tests**.

## Scope
- Arithmetic logic verification  
- Register file validation  
- Memory read/write integrity  
- Branch and control-flow correctness  

## Phase 1 Test Suites

### 1️⃣ Simple Test (7/7 Checks)
- ADD, SUB, AND, OR, XOR  
- Register updates  
- Basic instruction execution  

### 2️⃣ Arithmetic Test (7/7 Checks)
- ADD, SUB, AND, OR, XOR  
- MUL and DIV operations  
- Edge-case handling  

### 3️⃣ Load / Store Test (2/2 Checks)
- Memory write operations  
- Memory read operations  
- Address correctness  
- Data integrity  

### 4️⃣ Branch Test (2/2 Checks)
- BEQ instruction  
- Program counter updates  
- Control-flow verification  

## Phase 1 Coverage

| Metric | Coverage |
|------|----------|
| Instruction Coverage | 95% |
| Branch Coverage | 88% |
| Address Coverage | 92% |
| **Overall Coverage** | **87%** |

## Phase 1 Outcome
- Functional correctness established  
- Baseline coverage exceeded  
- Stable regression (18/18 checks passing)  

---

# 🔹 Phase 2: Enhanced & Coverage-Driven Verification

## Objective
Extend verification toward **coverage optimization and analysis**

## Enhancements Introduced

- Advanced functional coverage tracking  
- Instruction type classification  
- Address distribution analysis  
- Memory access pattern detection  
- Professional coverage reporting  

## Enhanced Verification Test

- 8 additional verification checks  
- Deep instruction-level profiling  
- Stress and distribution-based scenarios  

## Phase 2 Coverage Metrics

| Metric | Coverage |
|------|----------|
| Instruction Type Coverage | 85.7% |
| Address Coverage | 100% |
| **Overall Coverage** | **92.9%** |

## Phase 2 Outcome
- Coverage-driven verification achieved  
- Coverage targets significantly exceeded  
- Framework scalable for random/UVM extensions  

---

## 📊 Complete Project Statistics

- **Total Test Suites:** 5  
- **Total Verification Checks:** 26 / 26 Passing  
- **Average Functional Coverage:** ~90%  
- **Lines of Code:** 1200+  
- **Waveform Traces:** Multiple VCD files  
- **Regression:** Fully automated  

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/Vineet-8/risc-v-verification.git
cd risc-v-verification

# Install dependencies (macOS)
brew install icarus-verilog surfer

# Run Phase 1 tests
cd sim
./run_all_tests.sh

# Run Phase 2 enhanced verification
./run_enhanced_test.sh

# Run complete regression (Phase 1 + Phase 2)
./run_all_tests_complete.sh

# View waveforms
surfer ../results/*.vcd
```


## 🎯 Skills Demonstrated

### Verification Methodology
- Directed testing
- Coverage-driven verification
- Instruction-level verification
- Memory interface testing
- Control flow verification

### Technical Skills
- SystemVerilog testbenches
- Coverage analysis
- Waveform debugging
- Test automation
- Professional documentation

### Tools & Technologies
- Icarus Verilog (simulation)
- Surfer (waveform analysis)
- Git (version control)
- Bash scripting (automation)

---


**Project Summary:**
"Designed and implemented a complete RISC-V processor verification environment with 5 test suites and 26 verification checks. Achieved ~90% functional coverage using directed and coverage-driven verification. Phase 2 enhanced coverage to 92.9% with advanced instruction and address tracking."


## Author
VINEET PRABHU TALIKOTI
(B.Tech in ECE at PES University)

---

## 🎓 Phase 3: Complete UVM with Cadence Xcelium

### UVM Implementation (For College Lab with Cadence)

**Location**: `cadence_uvm/`

**Complete UVM testbench with all components:**

✅ **Transaction** - Constrained randomization
✅ **Sequencer** - Test orchestration  
✅ **Driver** - Full implementation with reporting
✅ **Monitor** - Transaction collection with analysis port
✅ **Scoreboard** - Advanced checking and reporting
✅ **Coverage** - Functional coverage with covergroups
✅ **Agent** - Complete UVM agent
✅ **Environment** - Full environment with connections
✅ **Sequences** - Base and reset sequences
✅ **Tests** - Base and smoke tests

### Running with Cadence
```bash
cd cadence_uvm

# Load Cadence tools
module load cadence

# Run UVM test
./run_uvm.sh uvm_smoke_test

# Or using Makefile
make run TEST=uvm_smoke_test
```

### What's Included

- **Complete UVM hierarchy** - All components implemented
- **Functional coverage** - Covergroups for verification
- **Professional reporting** - Detailed test reports
- **Makefile automation** - Professional workflow
- **Full documentation** - See README_CADENCE.md

### UVM Components Breakdown

| Component | Status | Features |
|-----------|--------|----------|
| Transaction | ✅ Complete | Constraints, field macros |
| Sequencer | ✅ Complete | Standard UVM sequencer |
| Driver | ✅ Complete | Full implementation + reporting |
| Monitor | ✅ Complete | Analysis port + transaction collection |
| Scoreboard | ✅ Complete | Transaction tracking + reporting |
| Coverage | ✅ Complete | Covergroups + reporting |
| Agent | ✅ Complete | All connections |
| Environment | ✅ Complete | Full hierarchy |

**This demonstrates production-level UVM verification skills!**

See `cadence_uvm/README_CADENCE.md` for detailed instructions.

