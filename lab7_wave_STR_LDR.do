onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/s
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/reset
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/clk
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/opcode
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/op
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/w
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/write
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/loada
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/loadb
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/loadc
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/loads
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/asel
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/bsel
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/load_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/reset_pc
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/addr_sel
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/load_ir
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/load_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/nsel
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/vsel
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/mem_cmd
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/state
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/reset_state
add wave -noupdate /lab7_check_tb/DUT/CPU/FSM/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
