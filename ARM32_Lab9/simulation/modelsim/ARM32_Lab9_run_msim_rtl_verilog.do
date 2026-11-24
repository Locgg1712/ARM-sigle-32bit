transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/alu.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/dmem.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/flopenr.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/flopr.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/imem.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/mux2.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/common {D:/ARM sigle 32bit/ARM32_Lab9/rtl/common/regfile.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/arm.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/condcheck.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/condlogic.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/controller.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/datapath.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/decoder.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl/processor {D:/ARM sigle 32bit/ARM32_Lab9/rtl/processor/extend.sv}
vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/rtl {D:/ARM sigle 32bit/ARM32_Lab9/rtl/top.sv}

vlog -sv -work work +incdir+D:/ARM\ sigle\ 32bit/ARM32_Lab9/sim {D:/ARM sigle 32bit/ARM32_Lab9/sim/tb_top.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  tb_top

add wave *
view structure
view signals
run -all
