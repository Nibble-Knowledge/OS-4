#!/bin/bash

if [ "$1" = "clean" ]
then
	rm -rf toolchain
	./make.sh clean
	exit 0
fi

if [ ! -d toolchain ]
then
	git clone https://github.com/Nibble-Knowledge/toolchain.git
fi
cd toolchain
git pull
if [ "$1" = "refresh" ]
then
	./update.sh refresh
else
	./update.sh
fi
cd ..
