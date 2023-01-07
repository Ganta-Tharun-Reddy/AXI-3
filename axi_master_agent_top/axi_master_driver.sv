
class axi_master_driver extends uvm_driver#(axi_transaction);  

       `uvm_component_utils(axi_master_driver)
	
	virtual axi_intf.MDR_MP vif;                          

        env_config m_cfg;

	bit [31:0] mem[];

	semaphore sem1,sem2,sem3,sem4,sem5,semA,semB,semC;

	axi_transaction t1[$],t2[$],t3[$],t4[$],t5[$];

	extern function new(string name ="axi_master_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
   	extern task run_phase(uvm_phase phase);
        extern task drive(axi_transaction xtn);
	extern task drive_w_address();
	extern task drive_w_data();
	extern task get_w_response();
	extern task drive_r_address();
	extern task get_r_data();


endclass

//-----------------  constructor new method  -------------------//

function axi_master_driver::new(string name ="axi_master_driver",uvm_component parent);

	super.new(name,parent);
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

function void axi_master_driver::build_phase(uvm_phase phase);

	super.build_phase(phase);
	
	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))

	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

//-----------------  connect() phase method  -------------------//

function void axi_master_driver::connect_phase(uvm_phase phase);
   
       	vif = m_cfg.vif;

endfunction

//-----------------  run() phase method  -------------------//

task axi_master_driver::run_phase(uvm_phase phase);

    forever 
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
endtask



task axi_master_driver:: drive(axi_transaction xtn);

         t1.push_back(xtn);
	 t2.push_back(xtn);
	 t3.push_back(xtn);
	 t4.push_back(xtn);
	 t5.push_back(xtn);

	 fork
		drive_w_address();
		drive_w_data();
	        get_w_response();
		drive_r_address();
		get_r_data();
		
	 join_any
 
endtask


task axi_master_driver::drive_w_address();

	axi_transaction xtn;
	sem1.get(1);
	xtn=t1.pop_front();

	@(vif.m_drv_cb)

	vif.m_drv_cb.AWADDR<=xtn.AWADDR;
	vif.m_drv_cb.AWLEN<=xtn.AWLEN;
	vif.m_drv_cb.AWSIZE<=xtn.AWSIZE;
	vif.m_drv_cb.AWBURST<=xtn.AWBURST;
	vif.m_drv_cb.AWID<=xtn.AWID;
	vif.m_drv_cb.AWVALID<=1'b1;

	@(vif.m_drv_cb)

	wait(vif.m_drv_cb.AWREADY)
	vif.m_drv_cb.AWVALID<=1'b0;

	sem1.put(1);
	sem2.put(1);

 endtask


 task axi_master_driver::drive_w_data();

	 axi_transaction xtn; 

	 xtn=t2.pop_front();
       
	 sem2.get(1);
	 sem3.get(1);

	
	 foreach(xtn.WDATA[i])
            
	 	begin
			@(vif.m_drv_cb)

	 		vif.m_drv_cb.WDATA<=xtn.WDATA[i];
 			vif.m_drv_cb.WSTRB<=xtn.WSTRB[i];
	 		vif.m_drv_cb.WVALID<=1'b1;

	 		if(i==xtn.WDATA.size-1)

		 	    vif.m_drv_cb.WLAST<=1'b1;
	 		else
		 	    vif.m_drv_cb.WLAST<=1'b0;

			@(vif.m_drv_cb)

	 		wait(vif.m_drv_cb.WREADY)

	 		vif.m_drv_cb.WVALID<=1'b0;
			
		end

	 sem3.put(1);
	 sem4.put(1);

endtask



task axi_master_driver::get_w_response();

	axi_transaction xtn=axi_transaction::type_id::create("xtn");

	sem4.get(1);
	sem5.get(1);
	 

        @(vif.m_drv_cb)

	vif.m_drv_cb.BREADY<=1'b1;

	wait(vif.m_drv_cb.BVALID)

	xtn.BID=vif.m_drv_cb.BID;
	xtn.BRESP=vif.m_drv_cb.BRESP;

        @(vif.m_drv_cb)
        
        vif.m_drv_cb.BREADY<=1'b0;

        //$display("\n-----------Write response-------------\n");
	//$display("Write response ID recieved @%0t :: %0d",$time,xtn.BID);
	//$display("Write response  recieved @%0t :: %0d",$time,xtn.BRESP);

	sem5.put(1);

endtask




task axi_master_driver::drive_r_address();

	axi_transaction xtn1=axi_transaction::type_id::create("xtn1");

	semA.get(1);

	xtn1=t4.pop_front();

	@(vif.m_drv_cb)

	vif.m_drv_cb.ARADDR<=xtn1.ARADDR;
	vif.m_drv_cb.ARLEN<=xtn1.ARLEN;
	vif.m_drv_cb.ARSIZE<=xtn1.ARSIZE;
	vif.m_drv_cb.ARBURST<=xtn1.ARBURST;
	vif.m_drv_cb.ARID<=xtn1.ARID;
	vif.m_drv_cb.ARVALID<=1'b1;

	@(vif.m_drv_cb)

	wait(vif.m_drv_cb.ARREADY)
	vif.m_drv_cb.ARVALID<=1'b0;

	semA.put(1);
	semB.put(1);

 endtask


task axi_master_driver::get_r_data();

	axi_transaction xtn1;

	semB.get(1);
	semC.get(1);
	
        xtn1=t5.pop_front();
   
        xtn1.r_address_cal();	

	for(int i=0;i<=xtn1.ARLEN;i++)
	
		begin
       			repeat(1)@(vif.m_drv_cb)

			vif.m_drv_cb.RREADY<=1'b1;

			wait(vif.m_drv_cb.RVALID)

			mem[xtn1.addr[i]]=vif.m_drv_cb.RDATA;
			
        		@(vif.m_drv_cb)
        
        		vif.m_drv_cb.RREADY<=1'b0;


					end
		
//	$display("\n----------------Data Read ------------------\n");
        
//	for(int i=0;i<=xtn1.ARLEN;i++)

//	$display("mem[%0d]=%0h",xtn1.addr[i],mem[xtn1.addr[i]]);
         			
        semC.put(1);

endtask

