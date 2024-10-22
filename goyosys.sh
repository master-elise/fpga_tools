# used on Debian GNU Linux stable October 2024
nproc=12

sudo apt install tcl8.6-dev libreadline-dev libffi-dev bison flex

git clone https://github.com/YosysHQ/yosys.git
cd yosys
git submodule update --init
make  -j$nproc
sudo make install
cd ../

sudo apt install gnat
git clone https://github.com/ghdl/ghdl
cd ghdl
./configure
make -j$nproc
sudo make install
cd ../

git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin/
make -j$nproc
sudo mkdir -p /usr/local/share/yosys/plugins/
sudo cp ghdl.so /usr/local/share/yosys/plugins/
cd ../

git clone https://github.com/SymbiFlow/prjxray.git
cd prjxray
make -j$nproc build
sudo make ALLOW_ROOT=1 install
./download-latest-db.sh
sudo mkdir -p /usr/share/nextpnr
sudo cp -r database /usr/share/nextpnr/prjxray-db
pip3 install --user -r requirements.txt --break-system-packages
cd ../

sudo apt install libboost-iostreams-dev

git clone https://github.com/gatecat/nextpnr-xilinx.git
cd nextpnr-xilinx
git submodule update --init --recursive
cmake -DARCH=xilinx -DUSE_OPENMP=ON .
make -j$nproc
sudo make install
python3 xilinx/python/bbaexport.py \
	--xray /usr/share/nextpnr/prjxray-db/zynq7 \
	--device xc7z010clg400-1 \
	--bba xilinx/xc7z010.bba
bbasm --l xilinx/xc7z010.bba xilinx/xc7z010.bin
sudo mkdir -p /usr/share/nextpnr/xilinx-chipdb/
sudo cp xilinx/xc7z010.bin /usr/share/nextpnr/xilinx-chipdb/
cd ../

sudo apt install openfpgaloader gtkwave # ghdl <- manually installed

echo 'export PATH=$PATH:$HOME/.local/bin' >> $HOME/.bashrc
