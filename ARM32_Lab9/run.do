# From ARM32_Lab9: do run.do  (or do run.do tb_datapath)
set bench tb_top
if {[info exists 1]} {set bench [set 1]}
if {$bench ni {tb_top tb_units tb_datapath tb_control_cpu}} {error "Unknown testbench: $bench"}
if {![file exists program/memfile.dat]} {error "cd to ARM32_Lab9 before running run.do"}
if {![file isdirectory work]} {vlib work}
vmap work work
set sources [concat [lsort [glob rtl/common/*.sv]] [lsort [glob rtl/processor/*.sv]] [list rtl/top.sv sim/${bench}.sv]]
vlog -sv {*}$sources
vsim -voptargs=+acc -onfinish stop work.$bench
if {$bench eq "tb_top"} {
    set t sim:/tb_top
    set d $t/dut/cpu/dp
    add wave $t/clk $t/reset
    add wave -radix unsigned $t/dut/PC
    add wave -radix hexadecimal $t/dut/Instr
    add wave -radix binary $d/RegSrc $d/ImmSrc $d/ALUSrc $d/ALUControl
    add wave -radix unsigned $d/RA1 $d/RA2 $d/SrcA $d/SrcB $d/ExtImm
    add wave -radix unsigned $t/DataAdr $t/WriteData $t/dut/ReadData $d/Result
    add wave $d/MemtoReg $d/RegWrite $t/MemWrite $d/PCSrc
    add wave -radix unsigned $d/PCNext
    add wave -radix binary $d/ALUFlags $t/dut/cpu/c/cl/Flags
} else {
    add wave -r sim:/$bench/*
}
run -all
wave zoom full
