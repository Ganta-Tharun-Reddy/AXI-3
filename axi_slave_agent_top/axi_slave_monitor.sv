
class axi_slave_monitor extends uvm_monitor;

       `uvm_component_utils(axi_slave_monitor)

   	virtual axi_intf.MMON_MP vif;

    	env_config m_cfg;
	
	axi_transaction t1[$],t2[$];

        semaphore sem1,sem2,sem3,sem4,sem5,semA,semB,semC;
	
	uvm_analysis_port #(axi_transaction) monitor_port;
	
	extern function new(string name = "axi_slave_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern task collect_w_address();
	extern task collect_w_data();
	extern task collect_r_address();
	extern task collect_r_data();
	extern task collect_w_response();

endclass 

//-----------------  constructor new method  -------------------//

function axi_slave_monitor::new(string name = "axi_slave_monitor", uvm_component parent);
	
	super.new(name,parent);
	
        monitor_port=new("monitor_port",this);
	sem1=new(1);
        sem2=new();
	sem3=new(1);
	sem4=new();
	sem5=new(1);
	semA=new(1);
	semB=new();
	semC=new(1);
endfunction

//-----------------  build() phase method  -------------------//

function void axi_slave_monitor::build_phase(uvm_phase phase);

    	super.build_phase(phase);
	 
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

function void axi_slave_monitor::connect_phase(uvm_phase phase);

    vif = m_cfg.vif;

endfunction


//-----------------  run() phase method  -------------------//
	
task axi_slave_monitor::run_phase(uvm_phase phase);
    
	forever
       		collect_data();     
endtask


task axi_slave_monitor::collect_data();

	fork
		collect_w_address();
		collect_w_data();
		collect_w_response();
		collect_r_address();
		collect_r_data();

       join_any

	endtask

task axi_slave_monitor::collect_w_address();

	axi_transaction s_xtn1=axi_transaction::type_id::create("s_xtn1");


	sem1.get(1);

	@(vif.mon_cb)

	wait(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY)

	s_xtn1.AWADDR=vif.mon_cb.AWADDR;
        s_xtn1.AWLEN=vif.mon_cb.AWLEN;
	s_xtn1.AWBURST=vif.mon_cb.AWBURST;
	s_xtn1.AWSIZE=vif.mon_cb.AWSIZE;
	s_xtn1.AWID=vif.mon_cb.AWID;

        t1.push_back(s_xtn1);
	
//	$display("\n--------------w address collected in slave monitor----------\n");
//	s_xtn1.print();

        monitor_port.write(s_xtn1);

	sem1.put(1);
	sem2.put(1);

 endtask


 task axi_slave_monitor::collect_w_data();

	 axi_transaction s_xtn2=axi_transaction::type_id::create("s_xtn2"); 
         

	 sem2.get(1);
	 sem3.get(1);

	 s_xtn2=t1.pop_front();

	 s_xtn2.WDATA=new[s_xtn2.AWLEN+1];

	 	
	 for(int i=0;i<=s_xtn2.AWLEN;i++)
		
		begin
                            
                        @(vif.mon_cb)

                        wait(vif.mon_cb.WVALID&& vif.mon_cb.WREADY)


			case(vif.mon_cb.WSTRB) 

				4'b0001:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[7:0];
					
				4'b0010:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[15:8];
					
				4'b0100:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[23:16];
				
				4'b1000:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:24];
			
				4'b1100:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:16];
				
				4'b0011:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[15:0];
				
				4'b1110:s_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:8];
					
				4'b1111:s_xtn2.WDATA[i]=vif.mon_cb.WDATA;

				default:s_xtn2.WDATA[i]=vif.mon_cb.WDATA;
		        
		        endcase

		end

//	 $display("\n--------------w data collected in slave monitor----------\n");
	 
//	 s_xtn2.print();
	
	 monitor_port.write(s_xtn2);
	 sem3.put(1);
	 sem4.put(1);

endtask



task axi_slave_monitor::collect_w_response();


	axi_transaction s_xtn3=axi_transaction::type_id::create("s_xtn3");
 
	sem4.get(1);
	sem5.get(1);
	 
        @(vif.mon_cb)

	wait(vif.mon_cb.BVALID && vif.mon_cb.BRESP)
	
	s_xtn3.BID=vif.mon_cb.BID;
	s_xtn3.BRESP=vif.mon_cb.BRESP;

        
//	$display("\n-----------Write response collected in slave monitor-------------\n");

//	s_xtn3.print();
	
	monitor_port.write(s_xtn3);

	sem5.put(1);

endtask

task axi_slave_monitor::collect_r_address();

	axi_transaction s_xtn4=axi_transaction::type_id::create("s_xtn4");

	semA.get(1);

	@(vif.mon_cb)

	wait(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY);

      	s_xtn4.ARADDR=vif.s_drv_cb.ARADDR;
        s_xtn4.ARLEN=vif.s_drv_cb.ARLEN;
	s_xtn4.ARBURST=vif.s_drv_cb.ARBURST;
	s_xtn4.ARSIZE=vif.s_drv_cb.ARSIZE;
	s_xtn4.ARID=vif.s_drv_cb.ARID;

        t2.push_back(s_xtn4);
//	$display("\n--------------r address collected in slave monitor----------\n");
//	s_xtn4.print();

	monitor_port.write(s_xtn4);
	semA.put(1);
	semB.put(1);

 endtask


task axi_slave_monitor::collect_r_data();

	axi_transaction s_xtn5=axi_transaction::type_id::create("s_xtn5");

	semB.get(1);
	semC.get(1);
	
        s_xtn5=t2.pop_front();

        s_xtn5.RDATA=new[s_xtn5.ARLEN+1];


	for(int i=0;i<=s_xtn5.ARLEN;i++)
	
		begin
       			@(vif.mon_cb)

			wait(vif.mon_cb.RVALID && vif.mon_cb.RREADY)

			s_xtn5.RDATA[i]=vif.mon_cb.RDATA;
                        
		end
		
//	$display("\n----------------Read data collected in slave monior ------------------\n");
        
//	s_xtn5.print();

	monitor_port.write(s_xtn5);
         			
        semC.put(1);

endtask

