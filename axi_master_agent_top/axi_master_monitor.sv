
class axi_master_monitor extends uvm_monitor;

       `uvm_component_utils(axi_master_monitor)

   	virtual axi_intf.MMON_MP vif;

    	env_config m_cfg;
	
	axi_transaction t1[$],t2[$];

        semaphore sem1,sem2,sem3,sem4,sem5,semA,semB,semC;

	uvm_analysis_port #(axi_transaction) monitor_port;
	
	extern function new(string name = "axi_master_monitor", uvm_component parent);
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

function axi_master_monitor::new(string name = "axi_master_monitor", uvm_component parent);
	
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

function void axi_master_monitor::build_phase(uvm_phase phase);

    	super.build_phase(phase);
	 
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

function void axi_master_monitor::connect_phase(uvm_phase phase);

    vif = m_cfg.vif;

endfunction


//-----------------  run() phase method  -------------------//
	
task axi_master_monitor::run_phase(uvm_phase phase);
    
	forever
       		collect_data();     
endtask


task axi_master_monitor::collect_data();

	fork
		collect_w_address();
		collect_w_data();
		collect_w_response();
		collect_r_address();
		collect_r_data();

       join_any

	endtask

task axi_master_monitor::collect_w_address();

	axi_transaction m_xtn1=axi_transaction::type_id::create("m_xtn1");


	sem1.get(1);

	@(vif.mon_cb)

	wait(vif.mon_cb.AWVALID && vif.mon_cb.AWREADY)

	m_xtn1.AWADDR=vif.mon_cb.AWADDR;
        m_xtn1.AWLEN=vif.mon_cb.AWLEN;
	m_xtn1.AWBURST=vif.mon_cb.AWBURST;
	m_xtn1.AWSIZE=vif.mon_cb.AWSIZE;
	m_xtn1.AWID=vif.mon_cb.AWID;

        t1.push_back(m_xtn1);
	
//	$display("\n--------------write address collected in master monitor----------\n");
	
//	m_xtn1.print();

        monitor_port.write(m_xtn1);

	sem1.put(1);
	sem2.put(1);

 endtask


 task axi_master_monitor::collect_w_data();

	 axi_transaction m_xtn2=axi_transaction::type_id::create("m_xtn2"); 
        
	 sem2.get(1);
	 sem3.get(1);

	 m_xtn2=t1.pop_front();

	 m_xtn2.WDATA=new[m_xtn2.AWLEN+1];
	 	
	 for(int i=0;i<=m_xtn2.AWLEN;i++)
		
		begin
                            
                        @(vif.mon_cb)

                        wait(vif.mon_cb.WVALID&& vif.mon_cb.WREADY)

			case(vif.mon_cb.WSTRB) 

				4'b0001: m_xtn2.WDATA[i]=vif.mon_cb.WDATA[7:0];
				
				4'b0010:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[15:8];
					
				4'b0100:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[23:16];
					
				4'b1000:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:24];
				
				4'b1100:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:16];

				4'b0011:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[15:0];
		
				4'b1110:m_xtn2.WDATA[i]=vif.mon_cb.WDATA[31:8];
		
				4'b1111:m_xtn2.WDATA[i]=vif.mon_cb.WDATA;

				default:m_xtn2.WDATA[i]=vif.mon_cb.WDATA;
		        
		        endcase
		end

//	 $display("\n--------------write data collected in master monitor----------\n");
	 
//	 m_xtn2.print();
	
	 monitor_port.write(m_xtn2);
	
	 sem3.put(1);
	 sem4.put(1);

endtask



task axi_master_monitor::collect_w_response();

	axi_transaction m_xtn3=axi_transaction::type_id::create("m_xtn3");
 
	sem4.get(1);
	sem5.get(1);
	 
        @(vif.mon_cb)

	wait(vif.mon_cb.BVALID && vif.mon_cb.BRESP)
	
	m_xtn3.BID=vif.mon_cb.BID;
	m_xtn3.BRESP=vif.mon_cb.BRESP;

        
//	$display("\n-----------Write response collected in master monitor-------------\n");
//
//	m_xtn3.print();
	
	monitor_port.write(m_xtn3);

	sem5.put(1);

endtask

task axi_master_monitor::collect_r_address();

	axi_transaction m_xtn4=axi_transaction::type_id::create("m_xtn4");

	semA.get(1);

        @(vif.mon_cb)

	wait(vif.mon_cb.ARVALID && vif.mon_cb.ARREADY);

      	m_xtn4.ARADDR=vif.s_drv_cb.ARADDR;
        m_xtn4.ARLEN=vif.s_drv_cb.ARLEN;
	m_xtn4.ARBURST=vif.s_drv_cb.ARBURST;
	m_xtn4.ARSIZE=vif.s_drv_cb.ARSIZE;
	m_xtn4.ARID=vif.s_drv_cb.ARID;

        t2.push_back(m_xtn4);
	
//	$display("\n--------------read address collected in master monitor----------\n");
	
//	m_xtn4.print();

	monitor_port.write(m_xtn4);

	semA.put(1);
	semB.put(1);

 endtask


task axi_master_monitor::collect_r_data();

	axi_transaction m_xtn5=axi_transaction::type_id::create("m_xtn5");

	semB.get(1);
	semC.get(1);
	
        m_xtn5=t2.pop_front();

        m_xtn5.RDATA=new[m_xtn5.ARLEN+1];


	for(int i=0;i<=m_xtn5.ARLEN;i++)
	
		begin
       			@(vif.mon_cb)

			wait(vif.mon_cb.RVALID && vif.mon_cb.RREADY)

			m_xtn5.RDATA[i]=vif.mon_cb.RDATA;
                        
		end
		
//	$display("\n----------------Read data collected in master monior ------------------\n");
        
//	m_xtn5.print();

	monitor_port.write(m_xtn5);
         			
        semC.put(1);

endtask

