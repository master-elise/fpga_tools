# Compiling free, opensource tools for programming Xilinx FPGAs (e.g. for the Zynq 7010 of the Redpitaya)

## yosys:

The prefered solution is to use the packaged binary, i.e. for Debian GNU/Linux
``sudo apt install yosys``. If not available, then

```
git clone https://github.com/YosysHQ/yosys.git
cd yosys
make
sudo make install
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
cmake -DARCH=xilinx -DUSE_OPENMP=ON .
make 
sudo make install
python3 xilinx/python/bbaexport.py \
	--xray /usr/share/nextpnr/prjxray-db/zynq7 \
	--device xc7z010clg400-1 \
	--bba xilinx/xc7z010.bba
bbasm --l xilinx/xc7z010.bba xilinx/xc7z010.bin
sudo cp xilinx/xc7z010.bin /usr/share/nextpnr/xilinx-chipdb/
cd ../
```

## openFPGAloader:

The prefered solution is to use the packaged binary, i.e. for Debian GNU/Linux
``sudo apt install openfpgaloader``. If not available, follow instructions at
https://github.com/trabucayre/openFPGALoader
