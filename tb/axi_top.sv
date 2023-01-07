
module top;

	// import ram_test_pkg
    import axi_test_pkg::*;
	
	//import uvm_pkg.sv
	import uvm_pkg::*;
	//include uvm_macros.svh"
	`include "uvm_macros.svh"

    // Generate clock signal
	bit clock;  
	
   // Instantiate ram_if with clock as input
   axi_intf in0(clock);
     
initial begin

        clock=0;
  	forever
		begin
		#10 clock=~clock;     
		end

end   
   // In initial block
    initial 
		begin
			//set the virtual interface using the uvm_config_db
			uvm_config_db #(virtual axi_intf)::set(null,"*","vif",in0);
			// Call run_test
			run_test();

		
		end

endmodule

  
   
  

