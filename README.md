# Compiling free, opensource tools for programming Xilinx FPGAs (e.g. for the Zynq 7010 of the Redpitaya)

The complete yosys installation is 4.7 GB when Vivado/Vitis 2024 requires downloading 18 GB 
and installing 70 GB !

## Opensource tools allowing for PS (CPU) access

See <a href="https://fosdem.org/2025/schedule/event/fosdem-2025-4850-all-open-source-toolchain-for-zynq-7000-socs/">GenZ and OpenXC7 (FOSDEM presentation)</a>.

Gwenhael Goavec-Merou has contributed <a href="openxc7_build_install.sh">this script</a>
automating the compilation of the OpenXC7 branch of the tools *which are not the same branch* 
than selected below. 

Once compilation is completed, always
```
source /opt/openxc7/export.sh
```
before using these tools by selecting the appropriate paths.

For NFS compatible installation:
* make sure the patch https://github.com/openXC7/prjxray/pull/3 is installed and that the package ``python3-flufl.lock`` is installed
* make sure the directories ``.../openxc7/share/nextpnr/prjxray-db/zynq7/`` and ``.../openxc7/share/nextpnr/prjxray-db/zynq7/mapping`` are world writable (``chmod 777``) to allow for lock file creation by other users
* the content of ``$HOME/.local`` of the user who installed openXC7 on the NFS server is copied to the user ``.local`` (to avoid the error ``importlib.metadata.PackageNotFoundError: No package metadata was found for prjxray``)

Tested with the examples found at https://github.com/openXC7/demo-projects: make sure to
```
make -f Makefile.openXC7
```
to compile these examples with the OpenXC7 toolchain.
## Legacy: manual compilation of the tools. PL (FPGA) only, no access to PS (CPU) with these tools. 

Take care that not all version combinations are functional. Below we do *not* checkout a given version, always using the latest github master branch. This combination can lead to a non-functional set of tools.

Tools: GHDL and GTKWave as binary packages, e.g. ``sudo apt install ghdl ghdl-gcc gtkwave``. Some additional dependencies found in this document are
```bash
sudo apt install pypy3 python3-simplejson python3-intervaltree python3-flufl.lock tcl-dev libffi-dev bison flex libboost-dev libboost-iostreams-dev libboost-filesystem-dev libboost-thread-dev libboost-program-options-dev libeigen3-dev
```

If manually compiling, all ``make`` commands can be parallelized using ``make -j$(ncpu)`` after setting ``ncpu`` to the appropriate value (e.g. number of CPU cores)

**WARNING**: yosys/nextpnr-xilinx seem to have version conflict issues. The
installation sequence below is using the lates ``master`` branch of all 
repositories, possibly mixing with binary distribution version, leading to
too many combinations to sort out. Maybe safer is the ``openxc7_build_install.sh`` script which makes sure to checkout known functional versions of each tool.

### yosys:

The preferred solution is to use the packaged binary, i.e. for Debian GNU/Linux sid
``sudo apt install yosys yosys-dev yosys-plugin-ghdl``. If not available (e.g. on Debian GNU/Linux stable or testing), 
then assuming the dependencies 
``sudo apt install tcl8.6-dev libreadline-dev libffi-dev bison flex`` is met:

```sh
git clone https://github.com/YosysHQ/yosys.git
cd yosys
git checkout yosys-0.44     # make sure to use a trusted version
git submodule update --init
make
sudo make install
cd ../
```

### ghdl

The preferred solution is to use the packaged ``sudo apt install libghdl-dev`` unless the version of the packaged library is too
old to support libghdl-dev (error such as ``error: ‘Id_Dlatch’ was not declared in this scope``). If such an error occurs in the
next step, remove the packaged ``sudo apt remove --purge libghdl-dev``, then install dependency ``sudo apt install gnat`` and
compile manually:

```sh
sudo apt install gnat
git clone https://github.com/ghdl/ghdl
cd ghdl
./configure
make
sudo make install
cd ../
```

### ghdl-yosys-plugin:

``sudo apt install libghdl-dev`` to meet dependencies, and

```sh
git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin/
make
sudo mkdir -p /usr/local/share/yosys/plugins/
sudo cp ghdl.so /usr/local/share/yosys/plugins/
cd ../
```

### prjxray:

This directory will be needed even after completing ``make install`` so perform
these compilation steps in a directory you will keep (e.g. *not* in ``/tmp`` !)

```sh
git clone https://github.com/SymbiFlow/prjxray.git
cd prjxray
make build
sudo make ALLOW_ROOT=1 install
./download-latest-db.sh
sudo mkdir -p /usr/share/nextpnr
sudo cp -r database /usr/share/nextpnr/prjxray-db
pip3 install --user -r requirements.txt # for Debian: add --break-system-packages # add --use-pep517 for Ubuntu
cd ../
```

### nextpnr-xilinx:

Depends on the ``libboost-iostreams-dev`` package:

```sh
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

### openFPGAloader:

The preferred solution is to use the packaged binary, i.e. for Debian GNU/Linux
``sudo apt install openfpgaloader``. If not available, follow instructions at
https://github.com/trabucayre/openFPGALoader

The JTAG pinout of the Redpitaya is given at <a href="https://redpitaya.readthedocs.io/en/latest/_images/JTAG_pins.jpg">this image</a> and is compatible with the Digilent HS2 probe. For transfering the bitstream to the PL of the Zynq:
```bash
openFPGALoader -c digilent_hs2 mybitstream.bit
```

### Update PATH

Once all tools are installed, make sure to update the PATH with ``/usr/local/bin`` and ``$HOME/.local/bin`` e.g. using
```sh
export PATH=$PATH:/usr/local/bin:$HOME/.local/bin
```
which can be added to ``.bashrc`` to make the modification permanent.
