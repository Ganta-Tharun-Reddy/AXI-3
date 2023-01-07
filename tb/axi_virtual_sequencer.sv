

   
   // Extend axi_vvirtual_sequencer from uvm_sequencer
   //
	class axi_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
      // Factory Registration
	`uvm_component_utils(axi_virtual_sequencer)

   // Declare handles for ram_wr_sequencer and ram_rd_sequencer

	axi_master_sequencer master_seqr;
	axi_slave_sequencer slave_seqr;

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:

 
	extern function new(string name = "axi_virtual_sequencer",uvm_component parent);
	
endclass

   // Define Constructor new() function


   function axi_virtual_sequencer::new(string name="axi_virtual_sequencer",uvm_component parent);

	   super.new(name,parent);

   endfunction



