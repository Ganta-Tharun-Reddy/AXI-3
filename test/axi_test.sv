
class axi_base_test extends uvm_test;

	`uvm_component_utils(axi_base_test)

  
        axi_env axi_envh;
	env_config m_cfg;
 
        //axi_vbase_seq  axi_seqh;
	
	//axi_master_write_vseq axi_seqh;
	
	extern function new(string name = "axi_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
        extern function void config_axi();
 
endclass

//-----------------  constructor new method  -------------------//

function axi_base_test::new(string name = "axi_base_test" , uvm_component parent);

	super.new(name,parent);

endfunction


//-----------------  config_ram() method  -------------------//

function void axi_base_test::config_axi();

   
			m_cfg.is_active = UVM_ACTIVE;
			
			// Get the virtual interface from the config database
			 
			if(!uvm_config_db #(virtual axi_intf)::get(this,"","vif",m_cfg.vif))
		
	                `uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")  
			
                
		         // set the config object into UVM config DB  

		         uvm_config_db #(env_config)::set(this,"*","env_config",m_cfg);


endfunction
	

//-----------------  build() phase method  -------------------//
            
function void axi_base_test::build_phase(uvm_phase phase);

	// Create the instance for ram_env_config
 
	m_cfg=env_config::type_id::create("m_cfg");

   
	//call function config_axi()

        config_axi();
 
        super.build_phase(phase);

        // create the instance for env

        axi_envh=axi_env::type_id::create("axi_envh", this);

endfunction



 

class axi_master_write_xtns_test extends axi_base_test;


  	 `uvm_component_utils(axi_master_write_xtns_test)
	
	 axi_master_write_vseq  axi_seqh;

       	 extern function new(string name = "axi_master_write_xtns_test" , uvm_component parent);
	 extern function void build_phase(uvm_phase phase);
	 extern task run_phase(uvm_phase phase);

endclass


function axi_master_write_xtns_test::new(string name = "axi_master_write_xtns_test" , uvm_component parent);

	super.new(name,parent);

endfunction



function void axi_master_write_xtns_test::build_phase(uvm_phase phase);
	
	super.build_phase(phase);

endfunction


task axi_master_write_xtns_test::run_phase(uvm_phase phase);

	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
    axi_seqh=axi_master_write_vseq::type_id::create("axi_seqh");
	//start the sequence wrt virtual sequencer
    axi_seqh.start(axi_envh.v_sequencer);
	//drop objection
    #4000;
    phase.drop_objection(this);
	

endtask



