#Makefile for UVM Testbench#RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/axi_top.sv
INC = +incdir+../tb +incdir+../test +incdir+../axi_master_agent_top +incdir+../axi_slave_agent_top
SVTB2 = ../test/axi_test_pkg.sv
COVOP=-coveropt 3 +cover=bcft
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit axi_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit axi_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit axi_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit axi_cov4;run -all; exit"




help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                             											!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.       								!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   								!"
	@echo "! run_sim    =>  run the simulation in batch mode.                   								!"
	@echo "! run_test	=>  clean, compile & run the simulation for axi_signle_adddr_test in batch mode.		!" 
	@echo "! run_test1	=>  clean, compile & run the simulation for axi_ten_adddr_test in batch mode.			!" 
	@echo "! run_test2	=>  clean, compile & run the simulation for axi_odd_adddr_test in batch mode.			!"
	@echo "! run_test3	=>  clean, compile & run the simulation for axi_even_adddr_test in batch mode.			!" 
	@echo "! view_wave1 =>  To view the waveform of axi_signle_addr_test	    								!" 
	@echo "! view_wave2 =>  To view the waveform of axi_ten_addr_test	    									!" 
	@echo "! view_wave3 =>  To view the waveform of axi_odd_addr_test	  	  									!" 
	@echo "! view_wave4 =>  To view the waveform of axi_even_addr_test	    									!" 
	@echo ====================================================================================================================



sv_cmp:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) 	
	
run_test:sv_cmp
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave_file1.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=axi_master_write_xtns_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html axi_cov1

	
run_test1:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=axi_ten_addr_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2
	
run_test2:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file3.wlf -l test3.log  -sv_seed random  work.top +UVM_TESTNAME=axi_even_addr_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3
	
run_test3:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)  -wlf wave_file4.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=axi_odd_addr_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov4

	
view_wave1:
	vsim -view wave_file1.wlf
	
view_wave2:
	vsim -view wave_file2.wlf
	
view_wave3:
	vsim -view wave_file3.wlf
	
view_wave4:
	vsim -view wave_file4.wlf


cov_report:
	firefox covhtmlreport/index.html&

clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* axi_cov* *.wlf modelsim.ini
	clear
