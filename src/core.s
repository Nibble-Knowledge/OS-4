#The core of the basic os right now written in macro assembly 
#Loops waiting for ready from the keyboard to recieve a key stroke
#- then updates the audio and waits for vga ready to update vga

#Split into one main loop which checks for the keyboard to send data, then outputs it to the vga and updates the sounds



MAIN:
    #Check if keyboard has input
    MOV KEYB INTO CHIP_SELECT
    MOV READOUT INTO STATUS_BUS
    #If the values are the same then xor = 0 so jump to keyboard_in
    XOR STATUS_BUS READOUT INTO RESULT
    JMPEQ RESULT N_[0] TO KEYBOARD_IN
    KEYBOARD_IN.RET
    

    #Check if character buffer has anything in it - if yes check vga ready, if no go back to start of loop
    JMPEQ COUNTER N_[0] TO MAIN
    
    #Check for vga ready
    MOV VGA INTO CHIP_SELECT
    MOV READOUT INTO STATUS_BUS
    XOR STATUS_BUS READOUT INTO RESULT
    JMPEQ RESULT N_[0] TO VGAOUT

    #Restart the main loop
    LOD N_[0]
    JMP MAIN

#Read the keyboard and store the value in a buffer
KEYBOARD_IN:
    

    #Keep track of how many key presses have been read in
    INC COUNTER INTO COUNTER  
    LOD N_[0]
    JMP KEYBOARD_IN.RET

#Output the audio - currently thinking this will be updated when vga is updated? 
AUDIO_OUT:
	MOV AUDIO INTO CHIP_SELECT
	MOV WRITEOUT INTO STATUS_BUS
	NOP
	MOV CURRENT INTO DATA_BUS
    LOD N_[0]
    JMP AUDIO_OUT.RET


#Output to the screen
VGA_OUT:
    #Update the audio then updte the screen
    LOD N_[0]
    JMP AUDIO_OUT
    AUDIO_OUT.RET
    
    #Output to the screen
    MOV VGA INTO CHIP_SELECT
    MOV WRITEOUT INTO STATUS_BUS
    NOP
    #TODO fix this part since i know this doesnt work
    MOV BUFFER[BUFFER_COUNT] INTO DATA_BUS

    #Remove a value from counter when a succesful write to vga happens
    SUB COUNTER N[1] INTO COUNTER
    LOD N_[0]
    JMP MAIN





AUDIO: .data 1 0b0001
KEYB: .data 1 0b0010
VGA: .data 1 0b0011
READOUT: .data 1 0b0101
WRITEOUT: .data 1 0b1001
READLOW: .data 1 0b0001
READY: .data 1 0b0111

RESULT: .data 1 0x0

BUFFER: .data 16 0x0000000000000000
BUFFER_COUNT: .data 1 0x0

CURRENT: .data 1 0x0



3not sure if this is needed yet
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
BREAK: .data 2 0xF0
