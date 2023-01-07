

class axi_master_agent extends uvm_agent;

   
	`uvm_component_utils(axi_master_agent)

         // Declare handle for configuration object

         env_config m_cfg;
        
  
	axi_master_monitor monh;
	axi_master_sequencer seqrh;
	axi_master_driver drvh;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods :
	
	extern function new(string name = "axi_master_agent", uvm_component parent = null);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass : axi_master_agent

//-----------------  constructor new method  -------------------//

function axi_master_agent::new(string name = "axi_master_agent", 
                           uvm_component parent = null);

	super.new(name, parent);

endfunction
     
  
//-----------------  build() phase method  -------------------//
// Call parent build phase
// Create axi_master_monitor instance
// If config parameter is_active=UVM_ACTIVE, create axi_master_driver and axi_master_sequencer instances

function void axi_master_agent::build_phase(uvm_phase phase);

	super.build_phase(phase);

   // get the config object using uvm_config_db

	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))

		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 

	monh=axi_master_monitor::type_id::create("monh",this);	

	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh=axi_master_driver::type_id::create("drvh",this);
			seqrh=axi_master_sequencer::type_id::create("seqrh",this);
		end
		
endfunction

      
//-----------------  connect() phase method  -------------------//
//If config paaxieter is_active=UVM_ACTIVE, 
//connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)

function void axi_master_agent::connect_phase(uvm_phase phase);

	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		end
endfunction
   


   



