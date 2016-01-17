# OS/4
Twice as good as OS/2

## Usage:
./updatetools.sh: downloads and builds the nessecary tools. "./updatetools.sh clean" will clean the working directory.
./make.sh: Builds OS/4. Currently, only builds the single source file "src/core.asm" to "os4.bin". Will warn if OS/4 is too but to fit in the MBR. "./make.sh clean" will delete os4.bin.
./load.sh: Loads OS/4 into the MBR. Extremely dangerous, use with care.
