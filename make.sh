#!/bin/bash

if [ "$1" = "clean" ]
then
	rm -f os4.bin
	exit 0
fi

if [ ! -f toolchain/macro-assembler/NKMacroASM.py ]
then
	./updatetools.sh
fi

if [ ! -f toolchain/macro-assembler/NKMacroASM.py ]
then
	echo "Can not find macro assembler!"
	exit 1
fi

cd toolchain

./macro.sh ../src/core.asm ../os4.bin

cd ..

size="$(wc -c < os4.bin)"

echo -n "OS/4 is $size bytes "

if [ "$size" -gt 446 ]
then
	echo "which is too big."
else 
	echo "which is okay."
fi
