# -Wall turns on all warnings
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -g2012 -Wall -y./hdl -y./tests -Y.sv -I./hdl
VVP=vvp
VVP_POST=-vcd
VIVADO=vivado -mode batch -source

WAVE_SRCS = wave_generators/saw_wave.sv wave_generators/square_wave.sv wave_generators/triangle_wave.sv

# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions

%.memh : %.s
	./assembler.py $< -o $@

test_saw_wave: tests/test_saw_wave.sv ${WAVE_SRCS}
	${IVERILOG} $^ -o test_saw_wave.bin && ${VVP} test_saw_wave.bin ${VVP_POST}

test_triangle_wave: tests/test_triangle_wave.sv ${WAVE_SRCS}
	${IVERILOG} $^ -o test_triangle_wave.bin && ${VVP} test_triangle_wave.bin ${VVP_POST}

test_square_wave: tests/test_square_wave.sv ${WAVE_SRCS}
	${IVERILOG} $^ -o test_saw_wave.bin && ${VVP} test_saw_wave.bin ${VVP_POST}

waves_saw: test_saw_wave ${WAVE_SRCS}
	gtkwave results/test_saw.vcd

waves_square: test_square_wave ${WAVE_SRCS}
	gtkwave results/test_square.vcd

waves_triangle: test_triangle_wave ${WAVE_SRCS}
	gtkwave results/test_triangle.vcd

test_main: tests/test_main.sv main.sv debouncer.sv edge_detector.sv ${WAVE_SRCS}
	${IVERILOG} $^ -o test_main.bin && ${VVP} test_main.bin ${VVP_POST}

main.bit: main.sv $(MAIN_SRCS) build.tcl
	@echo "########################################"
	@echo "#### Building FPGA bitstream        ####"
	@echo "########################################"
	${VIVADO} build.tcl

program_fpga_vivado: main.bit build.tcl program.tcl
	@echo "########################################"
	@echo "#### Programming FPGA (Vivado)      ####"
	@echo "########################################"
	${VIVADO} program.tcl

program_fpga_digilent: main.bit build.tcl
	@echo "########################################"
	@echo "#### Programming FPGA (Digilent)    ####"
	@echo "########################################"
	djtgcfg enum
	djtgcfg prog -d CmodA7 -i 0 -f main.bit


# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml
	rm -rf .Xil
	rm -rf __pycache__
	rm -rf results/*.vcd

# Call this to generate your submission zip file.
submission:
	zip submission.zip Makefile *.sv README.md docs/* *.tcl *.xdc tests/*.sv *.pdf
