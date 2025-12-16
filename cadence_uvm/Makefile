TEST ?= uvm_smoke_test
XRUN = xrun
XRUN_FLAGS = -64bit -sv -uvm -access +rwc -linedebug -timescale 1ns/1ps

.PHONY: all run gui coverage clean help

all: run

run:
	@echo "Running test: $(TEST)"
	$(XRUN) $(XRUN_FLAGS) \
		+UVM_TESTNAME=$(TEST) \
		+UVM_VERBOSITY=UVM_MEDIUM \
		-coverage all \
		-f filelist.f \
		-log xrun_$(TEST).log

gui:
	@echo "Running with GUI..."
	$(XRUN) $(XRUN_FLAGS) -gui \
		+UVM_TESTNAME=$(TEST) \
		-f filelist.f

coverage:
	@echo "Generating coverage report..."
	imc -load cov_work/scope/test -execcmd "report -detail -html -output cov_report"

clean:
	rm -rf xcelium.d INCA_libs *.log *.history *.shm cov_work

help:
	@echo "Usage:"
	@echo "  make run TEST=uvm_smoke_test"
	@echo "  make gui TEST=uvm_smoke_test"
	@echo "  make coverage"
	@echo "  make clean"
