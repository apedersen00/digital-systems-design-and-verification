ifneq ($(words $(CURDIR)),1)
	$(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################
# Verilator setup
ifeq ($(VERILATOR_ROOT),)
	VERILATOR = verilator
	VERILATOR_COVERAGE = verilator_coverage
else
	export VERILATOR_ROOT
	VERILATOR = $(VERILATOR_ROOT)/bin/verilator
	VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

VERILATOR_FLAGS += -cc --exe
VERILATOR_FLAGS += -x-assign fast
VERILATOR_FLAGS += -Wall
VERILATOR_FLAGS += --trace-vcd
VERILATOR_FLAGS += --assert -Wno-EOFNEWLINE

######################################################################
TARGETS = mult adder imc

SRC_DIR     = src
SIM_DIR     = sim
SOURCE_FILES = $(wildcard $(SRC_DIR)/*.sv)

######################################################################
default: $(TARGETS)

######################################################################
$(TARGETS):
	@echo
	@echo "-- VERILATE ($@) -----------"
	$(VERILATOR) $(VERILATOR_FLAGS) --top-module tb_$@ \
		$(SOURCE_FILES) $(SIM_DIR)/tb_$@.sv $(SIM_DIR)/sim_$@.cpp

	@echo
	@echo "-- BUILD ($@) --------------"
	$(MAKE) -j -C obj_dir -f Vtb_$@.mk

	@echo
	@echo "-- RUN ($@) ----------------"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/Vtb_$@ +trace
	@echo
	@echo "-- DONE ($@) ---------------"
	@echo

######################################################################
show-config:
	$(VERILATOR) -V

clean mostlyclean distclean maintainer-clean:
	-rm -rf obj_dir logs *.log *.dmp *.vpd coverage.dat core

maintainer-copy::
	@echo "Nothing to copy (yet)"
