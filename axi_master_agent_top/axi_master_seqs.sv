
class axi_master_base_seq extends uvm_sequence #(axi_transaction);  
	
  
	`uvm_object_utils(axi_master_base_seq)  
	
    	extern function new(string name ="axi_master_base_seq");
	
endclass

//-----------------  constructor new method  -------------------//

function axi_master_base_seq::new(string name ="axi_master_base_seq");

	super.new(name);

endfunction


class axi_master_write_xtns extends axi_master_base_seq;

       
    `uvm_object_utils(axi_master_write_xtns)

    extern function new(string name ="axi_master_write_xtns");

    extern task body();

endclass

//-----------------  constructor new method  -------------------//

function axi_master_write_xtns::new(string name = "axi_master_write_xtns");
        
	super.new(name);

endfunction

//-----------------  task body method  -------------------//


task axi_master_write_xtns::body();
    
	repeat(1)

        begin
                req=axi_transaction::type_id::create("req");
                start_item(req);
                assert(req.randomize());
	//	$display("\n\n---------------axi_master_seq:: body() task after randomize----------------------@ %0t\n",$time);
	//	req.print();
                finish_item(req);

       end
endtask
                       

