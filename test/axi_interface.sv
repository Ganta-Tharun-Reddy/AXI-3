
interface axi_intf(input bit clock);
    
    // Write Address channel
 
    bit [3:0] AWID;
    bit [5:0] AWADDR;
    bit [3:0] AWLEN;
    bit [2:0] AWSIZE;
    bit [1:0] AWBURST;
    bit AWVALID, AWREADY;

    // Write Data channel

    bit [3:0] WID;
    bit [31:0] WDATA;
    bit [3:0] WSTRB;
    bit WLAST, WVALID, WREADY;

    // Write Response channel

    bit [3:0] BID;
    bit [1:0] BRESP;
    bit BVALID, BREADY;

    // Read Address channel

    bit [3:0] ARID;
    bit [5:0] ARADDR;
    bit [3:0] ARLEN;
    bit [2:0] ARSIZE;
    bit [1:0] ARBURST;
    bit ARVALID, ARREADY;

    // Read Data channel

    bit [3:0] RID;
    bit [31:0] RDATA;
    bit [1:0] RRESP;
    bit RLAST, RVALID, RREADY;
//

    clocking m_drv_cb @(posedge clock);

        output AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID, WID, WDATA, WSTRB, WLAST, WVALID, 
                BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, RREADY;
        input AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RDATA, RRESP, RLAST, RVALID;

    endclocking

    clocking mon_cb @(posedge clock);

        input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID, WID, WDATA, WSTRB, WLAST, WVALID, 
                BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, RREADY;
        input AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RDATA, RRESP, RLAST, RVALID;

    endclocking

    clocking s_drv_cb @(posedge clock);

        input AWID, AWADDR, AWLEN, AWSIZE, AWBURST,AWVALID, WID, WDATA, WSTRB, WLAST, WVALID, 
                BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, RREADY;
        output AWREADY, WREADY, BID, BRESP, BVALID, ARREADY, RID, RDATA, RRESP, RLAST, RVALID;

    endclocking

    modport MDRV(clocking m_drv_cb);

    modport MMON(clocking mon_cb);
    
    modport SDRV(clocking s_drv_cb);
    
    modport SMON(clocking mon_cb);

    
endinterface

