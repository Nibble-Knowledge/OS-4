INF BASE_ADDRESS

LOD N_[1]
ADD N_[2]

loop:
    LOD KEYB
    STR CHIP_SELECT
    try: 
    LOD READOUT
    STR STATUS_BUS
    LOD STATUS_BUS
    
    
    
    LOD N_[0]
    JMP loop


AUDIOOUT:
	LOD AUDIO
	STR CHIP_SELECT
	LOD WRITEOUT
	STR STATUS_BUS
	NOP
	LOD CURRENT
	STR DATA_BUS
	LOD N_[0]
	JMP loop

VGAOUT:
    LOD VGA
	STR CHIP_SELECT
	LOD WRITEOUT
	STR STATUS_BUS
	NOP
	LOD NEWCHAR
	STR DATA_BUS
	LOD N_[0]
	JMP loop


XOR:
	STR XIN1
	NND XIN2
	STR XININT1
	NND XIN1
	STR XININT2
	LOD XININT1
	NND XIN2
	NND XININT2
    XORRET: JMP loop



HLT


AUDIO: .data 1 0b0001
KEYB: .data 1 0b0010
VGA: .data 1 0b0011
READOUT: .data 1 0b0101
WRITEOUT: .data 1 0b1001
READLOW: .data 1 0b0001
READY: .data 1 0b0111

CURRENT: .data 1 0x0
CURNIB: .data 1 0x0

XIN1: .data 1 0x0
XIN2: .data 1 0x0
XININT1: .data 1 0x0
XININT2: .data 1 0x0

A: .data 2 0x1C
B: .data 2 0x32
C: .data 2 0x21
D: .data 2 0x23
E: .data 2 0x24
F: .data 2 0x2B
G: .data 2 0x34
H: .data 2 0x33
I: .data 2 0x43
J: .data 2 0x3B
K: .data 2 0x42
L: .data 2 0x4B
M: .data 2 0x3A
N: .data 2 0x31
O: .data 2 0x44
P: .data 2 0x4D
Q: .data 2 0x15
R: .data 2 0x2D
S: .data 2 0x1B
T: .data 2 0x2C
U: .data 2 0x3C
V: .data 2 0x2A
W: .data 2 0x1D
X: .data 2 0x22
Y: .data 2 0x35
Z: .data 2 0x1A

NEWCHAR: .ascii 0

ACHAR: .ascii "A"
BCHAR: .ascii "B"
CCHAR: .ascii "C"
DCHAR: .ascii "D"
ECHAR: .ascii "E"
FCHAR: .ascii "F"
GCHAR: .ascii "G"
HCHAR: .ascii "H"
ICHAR: .ascii "I"
JCHAR: .ascii "J"
KCHAR: .ascii "K"
LCHAR: .ascii "L"
MCHAR: .ascii "M"
NCHAR: .ascii "N"
OCHAR: .ascii "O"
PCHAR: .ascii "P"
QCHAR: .ascii "Q"
RCHAR: .ascii "R"
SCHAR: .ascii "S"
TCHAR: .ascii "T"
UCHAR: .ascii "U"
VCHAR: .ascii "V"
WCHAR: .ascii "W"
XCHAR: .ascii "X"
YCHAR: .ascii "Y"
ZCHAR: .ascii "Z"

BREAK: .data 2 0xF0
