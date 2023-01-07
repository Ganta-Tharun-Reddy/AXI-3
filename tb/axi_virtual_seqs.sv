
class axi_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	
      `uvm_object_utils(axi_vbase_seq)  
  
      //Handles for all sequencers

       axi_master_sequencer master_seqr;

       axi_slave_sequencer slave_seqr;
   
       axi_virtual_sequencer vsqr;

       // Handles for all the sequences

       axi_master_write_xtns m_w_h;
 
       axi_slave_xtns s_t_h;


 	extern function new(string name = "axi_vbase_seq");

	extern task body();
        
endclass : axi_vbase_seq  

//-----------------  constructor new method  -------------------//

	function axi_vbase_seq::new(string name ="axi_vbase_seq");
	
		super.new(name);
	
	endfunction

//-----------------  task body() method  -------------------//


task axi_vbase_seq::body();
    
       	assert($cast(vsqr,m_sequencer)) 
        
	else begin
        
	`uvm_error("BODY", "Error in $cast of virtual sequencer")
  
	end

	master_seqr = vsqr.master_seqr;

	slave_seqr = vsqr.slave_seqr;

endtask: body


class axi_master_write_vseq extends axi_vbase_seq;

 	`uvm_object_utils(axi_master_write_vseq)

         extern function new(string name="axi_master_write_vseq");
	 
	 extern task body();
endclass



function axi_master_write_vseq::new(string name="axi_master_write_vseq");

	super.new(name);

endfunction

task axi_master_write_vseq::body();

	super.body();

	m_w_h=axi_master_write_xtns::type_id::create("m_w_h");

	s_t_h=axi_slave_xtns::type_id::create("s_t_h");

	fork

	m_w_h.start(master_seqr);

	s_t_h.start(slave_seqr);

	join


endtask


