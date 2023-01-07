
class axi_slave_sequencer extends uvm_sequencer #(axi_transaction);

	
	`uvm_component_utils(axi_slave_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	
	extern function new(string name = "axi_slave_sequencer",uvm_component parent);
endclass

//-----------------  constructor new method  -------------------//

function axi_slave_sequencer::new(string name="axi_slave_sequencer",uvm_component parent);

	super.new(name,parent);

endfunction

  










