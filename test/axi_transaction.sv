
class axi_transaction extends uvm_sequence_item;


	`uvm_object_utils(axi_transaction)
	
	typedef enum bit[1:0] {FIXED,INCR,WRAP} b_type;
	typedef enum bit[1:0] {OKAY,EXOKAY,SLVERR,DECERR} resp;
 

	//write address channel

	rand bit[3:0] AWID;
	rand bit [5:0] AWADDR;
	rand bit [3:0] AWLEN;
	rand bit [2:0] AWSIZE;
	rand b_type AWBURST;
        bit AWVALID,AWREADY;
        bit[5:0] addr[];

	//Write data channel

	rand bit [3:0] WID;
	rand bit [31:0] WDATA[];
	rand bit [3:0] WSTRB[];
	rand bit WLAST;
	rand bit WVALID;
	
	//Write Response channel

        rand bit [3:0] BID;
	bit BVALID,BREADY;
	rand resp BRESP;


	//Read Adrr channel

	rand bit [3:0] ARID;
	rand bit [5:0] ARADDR;
	rand bit [3:0] ARLEN;
	rand bit [2:0] ARSIZE;
        rand bit ARVALID,ARREADY;
	rand b_type ARBURST;

	//Read Data Channel

	rand bit [3:0] RID;
	bit [31:0] RDATA[];
	bit RLAST,RVALID,RREADY;
        rand resp RRESP;


	bit [5:0] start_address;
	bit [3:0] number_bytes;
	bit [5:0] aligned_address;
	bit [5:0] address_N;
	bit [5:0] wrap_boundary;
        bit [4:0] burst_length;
	int p=0;
        int data_bus_bytes;

    
	extern function new(string name="axi_transaction");
	extern function void address_cal();
	extern function void strobe_cal();
	extern function void post_randomize(); 
        extern function void do_print (uvm_printer printer);
	extern function void r_address_cal();
	extern function bit do_compare(uvm_object rhs,uvm_comparer comparer );


	constraint c1{ AWID==WID;ARID==RID;}

	constraint c2{WDATA.size==AWLEN+1;WSTRB.size==WDATA.size;}

	constraint c3{AWSIZE inside{[0:2]};ARSIZE inside{[0:2]};}

	constraint c4{
		      
		      AWBURST==2'b10&&AWSIZE==1->AWADDR%2==0;
		      AWBURST==2'b10&&AWSIZE==2->AWADDR%4==0;

                      ARBURST==2'b10&&ARSIZE==1->ARADDR%2==0;
		      ARBURST==2'b10&&ARSIZE==2->ARADDR%4==0;
	             }

endclass



function axi_transaction::new(string name = "axi_transaction");
       
	 super.new(name);
	 
endfunction: new


function void axi_transaction::address_cal();

	start_address=AWADDR;

	number_bytes=2**AWSIZE;

	burst_length=AWLEN+1;

	addr=new[burst_length];

	addr[0]= start_address;

	aligned_address=(int'(start_address/number_bytes))*number_bytes;

	wrap_boundary=(int'(start_address/(number_bytes*burst_length)))*(number_bytes*burst_length);

	for(int i=1;i<burst_length;i++)
		
		begin
			if(AWBURST==0)
			
				addr[i]=start_address;

			else if(AWBURST==1)
			
				addr[i]=aligned_address+i*(number_bytes);
                  
			else if(AWBURST==2)
  
			   begin
				
				   if(p==0)

				  	 begin
			  		
						addr[i]=wrap_boundary+i*number_bytes;
			
						if(addr[i]==wrap_boundary+(number_bytes*burst_length))
							
					       		begin
							        addr[i]=wrap_boundary;
								p++;	
							end	
				 	 end	

				   else
	      			
				  	addr[i]= start_address+((i*number_bytes)-(number_bytes*burst_length));
                       	end			  
		end	
	
             endfunction

function void axi_transaction::r_address_cal();

	start_address=ARADDR;

	number_bytes=2**ARSIZE;

	burst_length=ARLEN+1;

	addr=new[burst_length];

	addr[0]= start_address;

	aligned_address=(int'(start_address/number_bytes))*number_bytes;

	wrap_boundary=(int'(start_address/(number_bytes*burst_length)))*(number_bytes*burst_length);

	for(int i=1;i<burst_length;i++)
		
		begin
			if(ARBURST==0)
			
				addr[i]=start_address;

			else if(ARBURST==1)
			
				addr[i]=aligned_address+i*(number_bytes);
                  
			else if(ARBURST==2)
  
			   begin
				
				   if(p==0)

				  	 begin
			  		
						addr[i]=wrap_boundary+i*number_bytes;
			
						if(addr[i]==wrap_boundary+(number_bytes*burst_length))
							
					       		begin
							        addr[i]=wrap_boundary;
								p++;	
							end	
				 	 end	

				   else
	      			
				  	addr[i]= start_address+((i*number_bytes)-(number_bytes*burst_length));
                       	end			  
		end	
	
             endfunction



function void axi_transaction::strobe_cal();
      
	reg[1:0] lower_byte_lane, upper_byte_lane;

        start_address=AWADDR;
	number_bytes=2**AWSIZE;
	burst_length=AWLEN+1;
	data_bus_bytes=4;

	WSTRB=new[burst_length];

    	aligned_address=(int'(start_address/number_bytes))*number_bytes;


	lower_byte_lane=start_address-(int'(start_address/data_bus_bytes))*data_bus_bytes;

	upper_byte_lane=aligned_address+(number_bytes-1)-(int'(start_address/data_bus_bytes))*data_bus_bytes;

        
	for(int i=lower_byte_lane;i<=upper_byte_lane;i++)
                
		WSTRB[0][i]=1'b1;
		
	for(int i=1;i<WSTRB.size;i++)
	   
       	   begin
	    	  
		   lower_byte_lane=addr[i]-(int'(addr[i]/data_bus_bytes))*data_bus_bytes;
		   upper_byte_lane=lower_byte_lane+number_bytes-1;
	       
		   if(AWBURST==2'b00)
		   	
		   	begin
				for(int k=1;k<=AWLEN;k++)
					
					begin
						WSTRB[i]=WSTRB[0];
					end

			end
                 
		else if(ARBURST==2'b00)

			begin
				for(int l=1;l<=ARLEN;l++)
					
					begin
						WSTRB[i]=WSTRB[0];
					end

			end	

		   else

		   	begin

		   		for(int j=lower_byte_lane;j<=upper_byte_lane;j++)
		      
		  	 		begin
		         			WSTRB[i][j]=1'b1;
		      	 		end
	    	         end

	  end


endfunction



function void axi_transaction:: post_randomize();


    strobe_cal();


endfunction



function void  axi_transaction::do_print (uvm_printer printer);
    
	super.do_print(printer);


	// WRITE ADDRESS CHANNEL
   
    //    srting name   	    	      bitstream value     size       radix for printing
   
    printer.print_field( "AWID", 		this.AWID, 	$bits(AWID),     UVM_DEC     );
    printer.print_field( "AWADDR", 		this.AWADDR, 	$bits(AWADDR),   UVM_DEC     );
    printer.print_field( "AWLEN", 		this.AWLEN, 	$bits(AWLEN),    UVM_DEC     );
    printer.print_field( "AWSIZE", 		this.AWSIZE,    $bits(AWSIZE),	 UVM_DEC     );
    printer.print_field( "AWVALID", 		this.AWVALID, 	$bits(AWVALID),	 UVM_DEC     );
    printer.print_generic( "xtn_type", 		"AWBURST",	$bits(AWBURST),	 AWBURST.name);
 

      // WRITE DATA CHANNEL   
   
     printer.print_field( "WID", 		                this.WID, 	    $bits(WID),		 UVM_DEC	);
   
     for(int i=0;i<=AWLEN;i++)

  	  begin
  		  $display("WDATA[%0d]=%0h",i,WDATA[i]);
	  end

	  $display("\n");

     for(int i=0;i<=AWLEN;i++)

  	  begin
  		  $display("WSTRB[%0d]=%0b",i,WSTRB[i]);
	  end

    printer.print_field( "WLAST", 	                    	this.WLAST, 	   $bits(WLAST),         UVM_DEC	);
    printer.print_field( "WVALID", 	                	this.WVALID, 	   $bits(WLAST),         UVM_DEC	);

    //WRITE RESP CHANNEL
    printer.print_field( "BID", 		this.BID, 	$bits(BID),     UVM_DEC     );
    printer.print_generic( "w_resp", 		"BRESP",	$bits(BRESP),	 BRESP.name);
    

   // 	READ ADDRESS CHANNEL
    
    printer.print_field( "ARID", 		this.ARID, 	$bits(ARID),     UVM_DEC     );
    printer.print_field( "ARADDR", 		this.ARADDR, 	$bits(ARADDR),   UVM_DEC     );
    printer.print_field( "ARLEN", 		this.ARLEN, 	$bits(ARLEN),    UVM_DEC     );
    printer.print_field( "ARSIZE", 		this.ARSIZE,    $bits(ARSIZE),	 UVM_DEC     );
    printer.print_field( "ARVALID", 		this.ARVALID, 	$bits(ARVALID),	 UVM_DEC     );
   
 
    
  // READ DATA CHANNEL

    printer.print_field( "RID", 		this.RID, 	$bits(RID),     UVM_DEC     );
    printer.print_generic( "r_resp", 		"RRESP", 	$bits(RRESP),	 RRESP.name);
    
 
   for(int i=0;i<=ARLEN;i++)

  	  begin
  		  $display("RDATA[%0d]=%0h",i,RDATA[i]);
	  end


    
endfunction:do_print


 function bit axi_transaction::do_compare(uvm_object rhs,uvm_comparer comparer );
 
	 axi_transaction  rhs_;
	
     	 if(!$cast(rhs_,rhs)) 
	
 		 begin
			`uvm_fatal("do_compare","cast of the rhs object failed")
			return 0;
		end

	return super.do_compare(rhs,comparer) &&
	AWID== rhs_.AWID &&
	AWADDR== rhs_.AWADDR &&
	AWLEN== rhs_.AWLEN &&
	AWSIZE== rhs_.AWSIZE &&
	AWBURST== rhs_.AWBURST&&

	WID== rhs_.WID &&
	WDATA== rhs_.WDATA&&
	WSTRB== rhs_.WSTRB&&
	WLAST== rhs_.WLAST &&

	BID== rhs_.BID &&
	BRESP== rhs_.BRESP&&

	ARID== rhs_.ARID &&
	ARADDR== rhs_.ARADDR&&
	ARLEN== rhs_.ARLEN&&
	ARSIZE== rhs_.ARSIZE &&
	
	RID== rhs_.RID&&
	RDATA== rhs_.RDATA&&
	RLAST== rhs_.RLAST &&
	RRESP== rhs_.RRESP;

	


  
 endfunction


