PRJ    = encaps_TP1
VHDL_BIBLI = compt10s.vhd
V_LIST = encaps_TP1.v
CONSTR = ./ports.xdc

DEVICE = zynq7
PART   = xc7z010clg400-1

DB_DIR     = /usr/share/nextpnr/prjxray-db
CHIPDB_DIR = /usr/share/nextpnr/xilinx-chipdb

YOSYS_OPT=-q -p "scratchpad -set xilinx_dsp.multonly 1" \
	-p "synth_xilinx -flatten -nowidelut -abc9 -arch xc7 -top $(PRJ); write_json $(PRJ).json"


all: $(PRJ).bit
$(PRJ).v: $(PRJ).vhd
	yosys -m ghdl -p 'ghdl --std=08 $(VHDL_BIBLI) $(PRJ).vhd -e $(PRJ); write_verilog $(PRJ).v'

$(PRJ).json: $(V_LIST)
	yosys ${YOSYS_OPT} ${V_LIST}
	
$(PRJ).fasm: $(PRJ).json $(CONSTR)
	nextpnr-xilinx --chipdb ${CHIPDB_DIR}/xc7z010.bin --xdc $(CONSTR) \
		--json ${PRJ}.json --write ${PRJ}_routed.json --fasm ${PRJ}.fasm

$(PRJ).frames: $(PRJ).fasm
	fasm2frames --part ${PART} --db-root ${DB_DIR}/$(DEVICE) ${PRJ}.fasm > ${PRJ}.frames

$(PRJ).bit: $(PRJ).frames
	xc7frames2bit --part_file ${DB_DIR}/$(DEVICE)/${PART}/part.yaml --part_name ${PART} \
		--frm_file ${PRJ}.frames --output_file ${PRJ}.bit

load: $(PRJ).bit
	openFPGALoader -c digilent_hs2 $(PRJ).bit

clean:
	-rm -f *.rpt *.log *.json* *_synth.v *.place *.eblif *.fasm *.ioplace *.net $(V_LIST)
	-rm -f *.net.post_routing *.route *.premap.v *.frames *.bit
