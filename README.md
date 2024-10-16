# Compiling free, opensource tools for programming Xilinx FPGAs (e.g. for the Zynq 7010 of the Redpitaya)

Tools: GHDL and GTKWave as binary packages, e.g. ``sudo apt install ghdl gtkwave``

If manually compiling, all ``make`` commands can be parallelized using ``make -j$(ncpu)`` after setting ``ncpu`` to the appropriate value (e.g. number of CPU cores)

## yosys:

The prefered solution is to use the packaged binary, i.e. for Debian GNU/Linux
``sudo apt install yosys yosys-plugin-ghdl``. If not available, then

```
git clone https://github.com/YosysHQ/yosys.git
cd yosys
git submodule update --init
make
sudo make install
cd ../
```

## ghdl-yosys-plugin:

``sudo apt install libghdl-dev`` to meet dependencies, and

```
git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin/
make
sudo mkdir -p /usr/local/share/yosys/plugins/
sudo cp ghdl.so /usr/local/share/yosys/plugins/
cd ../
```

## prjxray:

```
git clone https://github.com/SymbiFlow/prjxray.git
cd prjxray
make build
sudo make ALLOW_ROOT=1 install
./download-latest-db.sh
sudo mkdir -p /usr/share/nextpnr
sudo cp -r database /usr/share/nextpnr/prjxray-db
pip3 install --user -r requirements.txt --break-system-packages
cd ../
```

## nextpnr-xilinx:

Depends on the ``libboost-iostreams-dev`` package:

```
git clone https://github.com/gatecat/nextpnr-xilinx.git
cd nextpnr-xilinx
git submodule update --init --recursive
cmake -DARCH=xilinx -DUSE_OPENMP=ON .
make 
sudo make install
python3 xilinx/python/bbaexport.py \
	--xray /usr/share/nextpnr/prjxray-db/zynq7 \
	--device xc7z010clg400-1 \
	--bba xilinx/xc7z010.bba
bbasm --l xilinx/xc7z010.bba xilinx/xc7z010.bin
sudo mkdir -p /usr/share/nextpnr/xilinx-chipdb/
sudo cp xilinx/xc7z010.bin /usr/share/nextpnr/xilinx-chipdb/
cd ../
```

## openFPGAloader:

The prefered solution is to use the packaged binary, i.e. for Debian GNU/Linux
``sudo apt install openfpgaloader``. If not available, follow instructions at
https://github.com/trabucayre/openFPGALoader

The JTAG pinout of the Redpitaya is given at https://redpitaya.readthedocs.io/en/latest/_images/JTAG_pins.jpg and is compatible with the Digilent HS2 probe. For transfering the bitstream to the PL of the Zynq: ``openFPGALoader -c digilent_hs2 mybitstream.bit``
