

class axi_slave_agent extends uvm_agent;

	`uvm_component_utils(axi_slave_agent)

        env_config m_cfg;
       
   
	axi_slave_monitor monh;
	axi_slave_sequencer seqrh;
	axi_slave_driver drvh;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
  
  extern function new(string name = "axi_slave_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : axi_slave_agent

//-----------------  constructor new method  -------------------//

function axi_slave_agent::new(string name = "axi_slave_agent", 
                           uvm_component parent = null);

	   	   super.new(name, parent);
endfunction
     
  
//-----------------  build() phase method  -------------------//
// Call parent build phase
// Create ram_wr_monitor instance
// If is_active=UVM_ACTIVE, create ram_wr_driver and ram_wr_sequencer instances

function void axi_slave_agent::build_phase(uvm_phase phase);
		
	super.build_phase(phase);
    
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")  
         
        monh=axi_slave_monitor::type_id::create("monh",this);	

	if(m_cfg.is_active==UVM_ACTIVE)

		begin
			drvh=axi_slave_driver::type_id::create("drvh",this);
			seqrh=axi_slave_sequencer::type_id::create("seqrh",this);
		end
endfunction

      
//-----------------  connect() phase method  -------------------//
//If is_active=UVM_ACTIVE, 
//connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
function void axi_slave_agent::connect_phase(uvm_phase phase);
	
	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
		end
endfunction
   

   



