#TODO - figure out which values correspond to what (read, write, which perif, etc)
#       Do the buffer counter stuff
#       Do we want to update audio/vga together or spereately?
#       What to send to vga?

#The core of the basic os right now written in macro assembly 
#Loops waiting for ready from the keyboard to recieve a key stroke-
#- then updates the audio and waits for vga ready to update vga

#Split into one main loop which checks for the keyboard to send data, then outputs it to the vga and updates the sounds

INF 19

MOV N_[0b0000] INTO *STATUS_BUS
MOV N_[0b0000] INTO *CHIP_SELECT

MAIN:
    #Check if keyboard has input
    MOV KEYB INTO *CHIP_SELECT
    MOV READOUT INTO *STATUS_BUS
    #If the values are the same then xor = 0 so jump to keyboard_in
    
    #XOR *STATUS_BUS READOUT INTO RESULT
    #JMPEQ RESULT N_[0] TO KEYBOARD_IN
    
    #Trying the way bailey had stuff set in keyboardandsound.txt
    AND *STATUS_BUS N_[0b0010] INTO RESULT
    JMPNEQ RESULT N_[0] TO KEYBOARD_IN
    KEYBOARD_IN.RET
    

    #Check if character buffer has anything in it - if yes check vga ready, if no go back to start of loop
    JMPEQ BUFFER_COUNT N_[0] TO MAIN
    #Check for vga ready
    MOV VGA INTO *CHIP_SELECT
    MOV READOUT INTO *STATUS_BUS
    XOR *STATUS_BUS READOUT INTO RESULT
    JMPEQ RESULT N_[0] TO VGAOUT

    #Restart the main loop
    LOD N_[0]
    JMP MAIN

#Read the keyboard and store the value in a buffer
KEYBOARD_IN:
    #Read in first half of keyboard value
    MOV N_[0b1000] INTO *STATUS_BUS
    MOV *DATA_BUS INTO BUFFER[BUFFER_COUNT]
    MOV N_[0b0000] INTO *STATUS_BUS
    
    #Read in latter half of value
    MOV N_[0b1000] INTO *STATUS_BUS
    ADD BUFFER_COUNT N_[1] INTO TEMP
    MOV *DATA_BUS INTO BUFFER[TEMP]
    MOV N_[0b0000] INTO *STATUS_BUS

    #Keep track of how many key presses have been read in then return
    INC BUFFER_COUNT INTO BUFFER_COUNT  
    LOD N_[0]
    JMP KEYBOARD_IN.RET

#Output the audio - currently thinking this will be updated when vga is updated? 
AUDIO_OUT:
	#MOV AUDIO INTO *CHIP_SELECT
	#MOV WRITEOUT INTO *STATUS_BUS
	#NOP
	#MOV CURRENT INTO *DATA_BUS

    #Put the second half of the keyboard value into audio
    MOV AUDIO INTO *CHIP_SELECT
    MOV N_[0b0100] INTO *STATUS_BUS
    ADD BUFFER_COUNT N_[1] INTO TEMP
    MOV TEMP INTO *DATA_BUS

    LOD N_[0]
    JMP AUDIO_OUT.RET


#Output to the screen - TODO figure out how i have to send, if it needs the char or the ps/2 code or what
VGA_OUT:
    #Update the audio then update the screen
    LOD N_[0]
    JMP AUDIO_OUT
    AUDIO_OUT.RET
    
    #Output to the vga
    MOV VGA INTO *CHIP_SELECT
    MOV WRITEOUT INTO *STATUS_BUS
    NOP
    #TODO fix this part since i know this doesnt work
    ADD BUFFER_COUNT N_[1] INTO TEMP

    #Send first half of character
    MOV N_[0b1000] INTO *STATUS_BUS
    MOV BUFFER[BUFFER_COUNT] INTO *DATA_BUS
    MOV N_[0b0000] INTO *STATUS_BUS

    #Send second half
    MOV N_[0b1000] INTO *STATUS_BUS
    MOV BUFFER[TEMP] INTO *DATA_BUS
    MOV N_[0b0000] INTO *STATUS_BUS

    #Remove a value from counter when a succesful write to vga happens
    SUB BUFFER_COUNT N[1] INTO BUFFER_COUNT
    LOD N_[0]
    JMP MAIN


#These values are all subject to change as im not 100% sure this is right
AUDIO: .data 1 0b0000
KEYB: .data 1 0b0001
VGA: .data 1 0b0010
READOUT: .data 1 0b0101
WRITEOUT: .data 1 0b1001    
READLOW: .data 1 0b0001
READY: .data 1 0b0111

RESULT: .data 1 0x0

BUFFER: .data 16 0x0000000000000000
BUFFER_COUNT: .data 1 0x0
TEMP: .data 1 0

#not sure if this is needed yet
#all the main ps/2 key values
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
