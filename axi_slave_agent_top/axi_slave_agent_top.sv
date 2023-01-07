

class axi_slave_agent_top extends uvm_env;

	
	`uvm_component_utils(axi_slave_agent_top)
    
   
        axi_slave_agent agnth;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	
	extern function new(string name = "axi_slave_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//
// Define Constructor new() function

function axi_slave_agent_top::new(string name = "axi_slave_agent_top" , uvm_component parent);

	super.new(name,parent);

endfunction

    
//-----------------  build() phase method  -------------------//

function void axi_slave_agent_top::build_phase(uvm_phase phase);

	super.build_phase(phase);
   	agnth=axi_slave_agent::type_id::create("agnth",this);

endfunction


//-----------------  run() phase method  -------------------//
// Print the topology

task axi_slave_agent_top::run_phase(uvm_phase phase);

//	uvm_top.print_topology;

endtask   



