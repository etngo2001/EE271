transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 271/Projects/lab3/fsm {C:/Users/egeen/Desktop/School/EE 271/Projects/lab3/fsm/DE1_SoC.sv}
vlog -sv -work work +incdir+C:/Users/egeen/Desktop/School/EE\ 271/Projects/lab3/fsm {C:/Users/egeen/Desktop/School/EE 271/Projects/lab3/fsm/fsm1101.sv}

