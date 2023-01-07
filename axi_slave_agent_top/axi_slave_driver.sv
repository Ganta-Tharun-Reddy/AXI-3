
class axi_slave_driver extends uvm_driver #(axi_transaction);

	
	`uvm_component_utils(axi_slave_driver)

	virtual axi_intf.SDR_MP vif;

        env_config m_cfg;

	axi_transaction q1[$],q2[$],q3[$],q4[$];
	
	semaphore sem1,sem2,sem3,sem4,sem5,semA,semB,semC;

	bit[31:0] mem[int];
     	
	extern function new(string name ="axi_slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task drive(axi_transaction xtn);
	extern task drive_w_response();
	extern task get_w_addr();
	extern task get_w_data();
	extern task get_r_addr();
	extern task drive_r_data();

endclass

//-----------------  constructor new method  -------------------//
 
 function axi_slave_driver::new (string name ="axi_slave_driver", uvm_component parent);

 	 super.new(name,parent);

	 sem1=new(1);
	 sem2=new();
	 sem3=new(1);
         sem4=new();
         sem5=new(1);
	 semA=new(1);
	 semB=new();
         semC=new(1);

endfunction : new

//-----------------  build() phase method  -------------------//

function void axi_slave_driver::build_phase(uvm_phase phase);
	
    	super.build_phase(phase);

	if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
		
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 

endfunction

//-----------------  connect() phase method  -------------------//

function void axi_slave_driver::connect_phase(uvm_phase phase);

    vif = m_cfg.vif;

endfunction

//-----------------  run() phase method  -------------------//


task axi_slave_driver::run_phase(uvm_phase phase);
   
  forever
	  begin
		  	seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
	  end

endtask

task axi_slave_driver::drive(axi_transaction xtn);

	q3.push_back(xtn);

	fork
	       	get_w_addr();
		get_r_addr();
                get_w_data();
		drive_r_data();
		drive_w_response();
	        
        join_any
	


endtask	


task axi_slave_driver::get_w_addr();

     
	axi_transaction xtn = axi_transaction::type_id::create("xtn");
       
       	sem1.get(1);

	repeat(1) @(vif.s_drv_cb)

      
	vif.s_drv_cb.AWREADY<=1'b1;
       
	wait(vif.s_drv_cb.AWVALID);

      	xtn.AWADDR=vif.s_drv_cb.AWADDR;
        xtn.AWLEN=vif.s_drv_cb.AWLEN;
	xtn.AWBURST=vif.s_drv_cb.AWBURST;
	xtn.AWSIZE=vif.s_drv_cb.AWSIZE;
	xtn.AWID=vif.s_drv_cb.AWID;
   
	q1.push_back(xtn);
	q2.push_back(xtn);
  
	@(vif.s_drv_cb)
        
	vif.s_drv_cb.AWREADY<=1'b0;
        
        sem1.put(1);
        sem2.put(1);
endtask


task axi_slave_driver::get_w_data();

	
	axi_transaction xtn;

	sem2.get(1);
        sem3.get(1);

	xtn=q1.pop_front();
       	
	xtn.address_cal();
         


	 for(int i=0;i<=xtn.AWLEN;i++)
		
		begin

			repeat(1)@(vif.s_drv_cb)
        
			vif.s_drv_cb.WREADY<=1'b1;

		        wait(vif.s_drv_cb.WVALID)


			case(vif.s_drv_cb.WSTRB) 

				4'b0001:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[7:0];
				4'b0010:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[15:8];
				4'b0100:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[23:16];
				4'b1000:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[31:24];
				4'b1100:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[31:16];
				4'b0011:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[15:0];
				4'b1110:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA[31:8];
				4'b1111:mem[xtn.addr[i]]=vif.s_drv_cb.WDATA;
				default: mem[xtn.addr[i]]=1;
		        
		        endcase
		       
	 		@(vif.s_drv_cb)
	
         		vif.s_drv_cb.WREADY<=1'b0;

		end

  

     //	$display("\nwrite address array =%0p\n",xtn.addr);
  
     //	$display("\n---------Data collected---------@ %0t\n",$time);

       // foreach(xtn.addr[i])

//	$display("mem[%0d]=%0h",xtn.addr[i],mem[xtn.addr[i]]);

     sem3.put(1);
     sem4.put(1);

endtask


task axi_slave_driver:: drive_w_response();

     axi_transaction xtn1,xtn2;

     sem4.get(1);
     sem5.get(1);

     xtn1=q2.pop_front();
  
     xtn2=q3.pop_front();

    @(vif.s_drv_cb)
    
    wait(vif.s_drv_cb.WLAST)
    
    vif.s_drv_cb.BID<=xtn1.AWID;
    vif.s_drv_cb.BRESP<=xtn2.BRESP;
    vif.s_drv_cb.BVALID<=1'b1;

    @(vif.s_drv_cb)

    wait(vif.s_drv_cb.BREADY)

    vif.s_drv_cb.BVALID<=1'b0;

    sem5.put(1);

endtask

task axi_slave_driver::get_r_addr();

     
	axi_transaction xtn1 = axi_transaction::type_id::create("xtn1");
       
       	semA.get(1);

	repeat(1) @(vif.s_drv_cb)

      
	vif.s_drv_cb.ARREADY<=1'b1;
       
	wait(vif.s_drv_cb.ARVALID);

      	xtn1.ARADDR=vif.s_drv_cb.ARADDR;
        xtn1.ARLEN=vif.s_drv_cb.ARLEN;
	xtn1.ARBURST=vif.s_drv_cb.ARBURST;
	xtn1.ARSIZE=vif.s_drv_cb.ARSIZE;
	xtn1.ARID=vif.s_drv_cb.ARID;
   
	q4.push_back(xtn1);
  
	@(vif.s_drv_cb)
        
	vif.s_drv_cb.ARREADY<=1'b0;
        
        semA.put(1);
        semB.put(1);
endtask



task axi_slave_driver:: drive_r_data();

     axi_transaction xtn2;


     semB.get(1);
     semC.get(1);
  
     xtn2=q4.pop_front();

    
     for(int i=0;i<=xtn2.ARLEN;i++)
     
	     begin
     	
	     	@(vif.s_drv_cb)

    	        case(xtn2.ARSIZE)
		 
		 2'b00:vif.s_drv_cb.RDATA<=$urandom_range(255,8);

	         2'b01:vif.s_drv_cb.RDATA<=$urandom_range(65535,4369);

		 2'b11:vif.s_drv_cb.RDATA<=$urandom_range(4294967295,286331153);

		 default:vif.s_drv_cb.RDATA<=$random;

    		//vif.s_drv_cb.RDATA<=$random;
	         
	        endcase
		
		vif.s_drv_cb.RVALID<=1'b1;
    
		if(i==xtn2.ARLEN)

		vif.s_drv_cb.RLAST<=1'b1;

             
		else
		 
		vif.s_drv_cb.RLAST<=1'b0;

    		@(vif.s_drv_cb)

    		wait(vif.s_drv_cb.RREADY)

    		vif.s_drv_cb.RVALID<=1'b0;

 	     end

    semC.put(1);

endtask

