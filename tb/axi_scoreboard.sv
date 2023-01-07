
class axi_scoreboard extends uvm_scoreboard;


	`uvm_component_utils(axi_scoreboard)


	uvm_tlm_analysis_fifo #(axi_transaction) fifo_mah;
        uvm_tlm_analysis_fifo #(axi_transaction) fifo_slh;

       
        int wr_xtns,rd_xtns, xtns_compared, xtns_dropped;
       
	semaphore sem1;
	
	logic [63:0] ref_data [bit[31:0]];
	

	axi_transaction ma_data,ma1_data;
	axi_transaction sl_data,sl1_data;

	axi_transaction  write_cov_data;
	axi_transaction  read_cov_data;

	
	covergroup axi_fcov1;
	
	option.per_instance=1;
	
        NO_WR_TRANSFERS : coverpoint write_cov_data.AWLEN{

						bins bin1 = {[0:5]};
						bins bin2 = {[6:10]};
						bins bin3 = {[11:15]};
										    	  
					           }

	BURST_SIZE : coverpoint write_cov_data.AWSIZE{

						bins bin1 = {[0:2]};
										    	  
					           }

	
	BURST_TYPE : coverpoint write_cov_data.AWBURST{

						bins bin1 = {[0:2]};
										    	  
					           }


    	     	     
        WRITE_FC : cross NO_WR_TRANSFERS,BURST_SIZE,BURST_TYPE;
          
    
	
	endgroup:axi_fcov1



    
        covergroup axi_fcov2;
	
	option.per_instance=1;
	
        NO_RD_TRANSFERS : coverpoint read_cov_data.ARLEN{

						bins bin1 = {[0:5]};
						bins bin2 = {[6:10]};
						bins bin3 = {[11:15]};
										    	  
					           }

	BURST_SIZE : coverpoint read_cov_data.ARSIZE{

						bins bin1 = {[0:2]};
										    	  
					           }

	
	BURST_TYPE : coverpoint read_cov_data.ARBURST{

						bins bin1 = {[0:2]};
										    	  
					           }


    	     	     
        READ_FC : cross NO_RD_TRANSFERS,BURST_SIZE,BURST_TYPE;
          
    
	endgroup:axi_fcov2

    

	extern function new(string name,uvm_component parent);

	extern task run_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

function axi_scoreboard::new(string name,uvm_component parent);


	super.new(name,parent);

	fifo_mah = new("fifo_mah", this);
	
	fifo_slh= new("fifo_slh", this);

	axi_fcov1=new;
	axi_fcov2=new;

	sem1=new(1);

endfunction



task axi_scoreboard::run_phase(uvm_phase phase);
   
		int p=0;
			forever
				begin

				 sem1.get(1);
                               
				 fifo_mah.get(ma_data);
				 write_cov_data=ma_data;
				 ma1_data=ma_data;
				$display("\n----------master monitor data collected in sb @%0t------------\n",$time);
				ma1_data.print;
 				
	 			 #1;			 
                                 
				 fifo_slh.get(sl_data);
				 read_cov_data=sl_data;
                                 sl1_data=sl_data;
				 $display("\n----------slave monitor data collected in sb@ %0t------------\n",$time);
				 sl1_data.print;
				 
				 sem1.put(1);

              

                                assert(ma1_data.compare(sl1_data))
				
				begin
					$display("Data matched @%0t   %0d",$time,p++);

				 //       $display("\n------Displaying master and slave data after comparision---------@%0t\n",$realtime);
				//	ma1_data.print();
				//	sl1_data.print();
				end

				else
				begin
					$display("Data mismatch @%0t",$time);

				  //      $display("\n------Displaying master and slave data after comparision---------@%0t\n",$realtime);
				//	ma1_data.print();
				//	sl1_data.print();
				end

 
				axi_fcov1.sample();
				axi_fcov2.sample();

				
				end

				
			            
         
endtask



 




