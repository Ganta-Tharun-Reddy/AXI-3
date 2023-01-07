package axi_test_pkg;

	
	import uvm_pkg::*;
	
	`include "uvm_macros.svh"
	`include "axi_transaction.sv"
	`include "axi_config.sv"
	`include "axi_master_driver.sv"
	`include "axi_master_monitor.sv"
	`include "axi_master_sequencer.sv"
	`include "axi_master_agent.sv"
	`include "axi_master_agent_top.sv"
	`include "axi_master_seqs.sv"

	
	`include "axi_slave_monitor.sv"
	`include "axi_slave_sequencer.sv"
	`include "axi_slave_seqs.sv"
	`include "axi_slave_driver.sv"
	`include "axi_slave_agent.sv"
	`include "axi_slave_agent_top.sv"

	`include "axi_virtual_sequencer.sv"
	`include "axi_virtual_seqs.sv"
	`include "axi_scoreboard.sv"

	`include "axi_env.sv"

	`include "axi_test.sv"

	
	
endpackage

`include"axi_interface.sv"
