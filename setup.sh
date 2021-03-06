#!/bin/bash
#Setup File
#Directory Rescue Crawler, direscraw v1.43; Error Percentage and Runtime Calculation Summary, errcalc v2.1
#Copyright (c) 2014 by Brian Mikolajczyk, brianm12@gmail.com

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

if [ $1 == "install" ]; then
        if [ ! $(which g++) ]; then
                gverdir=$(wget http://mirrors.concertpass.com/gcc/releases/ -qO - | grep gcc- | tail -1 | cut -d= -f3 | cut -d\" -f2)
                gver=$(wget http://mirrors.concertpass.com/gcc/releases/$gverdir -qO - | grep .tar.gz | cut -d= -f3 | cut -d\" -f2)
                wget -q http://mirrors.concertpass.com/gcc/releases/$gverdir/$gver
                gunzip $gver
                tar xf "${gver%.gz}"
                cd "${gver%.tar.gz}"
		sudo ./configure && make && sudo make install
		cd ..
        fi
	if [ ! $(which lzip) ]; then
		lver=$(wget http://download.savannah.gnu.org/releases/lzip/ -qO - | grep lzip | grep -v plzip | grep tar.gz | grep -v sig | cut -d\" -f8 | tail -1)
		wget -q http://download.savannah.gnu.org/releases/lzip/$lver
		gunzip $lver
		tar xf "${lver%.gz}"
		cd "${lver%.tar.gz}"
		sudo ./configure && make && sudo make install
		cd ..
	fi
	if [ ! $(which ddrescue) ]; then
		ddver=$(wget http://mirrors.kernel.org/gnu/ddrescue/ -qO - | grep -v sig | grep href | tail -1 | cut -d\> -f2 | cut -d\< -f1)
		wget -q http://mirrors.kernel.org/gnu/ddrescue/$ddver
		lzip -d $ddver
		tar xf "${ddver%.lz}"
		cd "${ddver%.tar.lz}"
		sudo ./configure && make && sudo make install
		cd ..
	fi
	wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
	if [[ $(pydoc -w bitmath | head -1 | cut -c1-2) == "no" ]]; then
		sudo easy_install -U bitmath
	fi
	rm bitmath.html setuptools*
	sudo cp errcalc.py /usr/local/bin/errcalc
	sudo cp direscraw.py /usr/local/bin/direscraw
	sudo chmod a+x /usr/local/bin/direscraw
	sudo chmod a+x /usr/local/bin/errcalc
	echo "direscraw and errcalc installed successfully"
elif [[ $1 == "uninstall" ]]; then
	sudo rm /usr/local/bin/errcalc /usr/local/bin/direscraw
	echo "direscraw and errcalc uninstalled successfully"
else
	echo "Usage"
	echo "sudo ./setup.sh install to install"
	echo "sudo ./setup.sh uninstall to uninstall"
fi
