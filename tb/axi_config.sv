class env_config extends uvm_object;
    
	`uvm_object_utils(env_config)
    
  
    virtual axi_intf vif;

    // Master and Slave are active or passive

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name = "env_config");
        super.new(name);
    endfunction

endclass 

// Configuration object which configures the sequence item generation

class test_config extends uvm_object;

    `uvm_object_utils(test_config)
    
    // Vartiables

    int no_write_cases  = 20;
    int no_read_cases   = 20;

    // Set whether to produce aligned address or unalinged address
    // -1: produce both aligned and unaligned randomly
    //  0: produce unaligned adresses for all bursts
    //  1: produce alligned adress for all bursts

    byte isAligned = -1;

    // Set the specific burst type for a test
    // -1: produce all the burst type randomly
    //  0: produce fixed bursts
    //  1: produce incr bursts
    //  2: produce wrap bursts

    byte burst_type = -1;

    function new(string name = "test_config");
        super.new(name);
    endfunction 

endclass 
