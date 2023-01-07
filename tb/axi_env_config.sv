

class env_config extends uvm_object;
    
	`uvm_object_utils(env_config)

   
	 bit has_m_agent = 1;
         bit has_s_agent = 1;
     
	 // Whether the virtual sequencer is used:

	 bit has_virtual_sequencer = 1;

	 master_agent_config m_a_cfg[];

	 slave_agent_config s_a_cfg[];

	 int no_of_duts;

	 extern function new(string name = "env_config");



endclass 


function env_config::new(string name = "env_config");
        	
	super.new(name);

endfunction





