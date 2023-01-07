class axi_env extends uvm_env;

        
    // Factory Registration
    `uvm_component_utils(axi_env)

	
	// Declare handles for ram_wr_agt_top, ram_rd_agt_top and ram_virtual_sequencer as
	//wagt_top,ragt_top and v_sequencer respectively
	
	axi_master_agent_top master_a_h;
	axi_slave_agent_top slave_a_h;
	axi_virtual_sequencer v_sequencer;
	
	// Declare handle for ram scoreboard as sb
	axi_scoreboard sb;
	
	// Declare handle for axi_env configuration class as m_cfg
        
	env_config m_cfg;
	
	//------------------------------------------
	// Methods
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "axi_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass: axi_env
	
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function axi_env::new(string name = "axi_env", uvm_component parent);
	super.new(name,parent);
endfunction

//-----------------  build phase method  -------------------//

function void axi_env::build_phase(uvm_phase phase);

	 master_a_h=axi_master_agent_top::type_id::create("master_a_h",this);
         
	 slave_a_h=axi_slave_agent_top::type_id::create("slave_a_h",this);
        

         super.build_phase(phase);
    
	 v_sequencer=axi_virtual_sequencer::type_id::create("v_sequencer",this);
	
	 // LAB : Create the instance of score_board handle 
       
	  sb=axi_scoreboard::type_id::create("sb",this);

endfunction

//-----------------  connect phase method  -------------------//

// In connect phase
// Connect virtual sequencers to UVC sequencers
// Hint : v_sequencer.wr_seqr = wagt_top.wr_agnth.sequencer
// 	  v_sequencer.rd_seqr = ragt_top.rd_agnth.sequencer
 
function void axi_env::connect_phase(uvm_phase phase);
   				v_sequencer.master_seqr = master_a_h.agnth.seqrh;
            
				v_sequencer.slave_seqr = slave_a_h.agnth.seqrh;
		
	// connect the monitor analysis port to scoreboard's uvm_tlm fifo's analysis export
	// Hint : wagt_top.agnth.monh.monitor_port.connect(sb.fifo_wrh.analysis_export)
    //        ragt_top.agnth.monh.monitor_port.connect(sb.fifo_rdh.analysis_export)
	
			master_a_h.agnth.monh.monitor_port.connect(sb.fifo_mah.analysis_export);
			slave_a_h.agnth.monh.monitor_port.connect(sb.fifo_slh.analysis_export);
		

endfunction




