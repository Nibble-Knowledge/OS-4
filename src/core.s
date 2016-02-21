#TODO - figure out which values correspond to what (read, write, which perif, etc)
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
    MOV N_[0b0000] INTO *STATUS_BUS

    #Loop until keyboard input
    KBWAIT:
        AND *STATUS_BUS READY INTO RESULT
        JMPNEQ RESULT N_[0] TO KEYBOARD_IN
        LOD N_[0]
        JMP KBWAIT
        KEYBOARD_IN.RET
    
    #Loop until vga ready
    MOV VGA INTO *CHIP_SELECT
    MOV N_[0b0000] INTO *STATUS_BUS
    VGAWAIT:
        AND *STATUS_BUS READY INTO RESULT
        JMPNEQ RESULT N_[0] TO VGA_OUT
        LOD N_[0]
        JMP VGAWAIT
        VGA_OUT.RET
        
    #Update the audio
    LOD N_[0]
    JMP AUDIO_OUT
    AUDIO_OUT.RET:

    #Restart the main loop
    LOD N_[0]
    JMP MAIN

#Read the keyboard and store the value in a buffer
KEYBOARD_IN:
    #Read in first half of keyboard value
    MOV N_[0b1000] INTO *STATUS_BUS
    MOV *DATA_BUS INTO KEYIN1
    MOV N_[0b0000] INTO *STATUS_BUS
    
    #Read in latter half of value
    MOV N_[0b1000] INTO *STATUS_BUS
    MOV *DATA_BUS INTO KEYIN2
    MOV N_[0b0000] INTO *STATUS_BUS
    
    LOD N_[0]
    JMP KEYBOARD_IN.RET


#Output to the screen - TODO figure out how i have to send, if it needs the char or the ps/2 code or what
VGA_OUT:
    #Send first half of character
    MOV N_[0b0100] INTO *STATUS_BUS
    MOV KEYIN1 INTO *DATA_BUS
    MOV N_[0b0000] INTO *STATUS_BUS

    #Send second half
    MOV N_[0b0100] INTO *STATUS_BUS
    MOV KEYIN2 INTO *DATA_BUS
    MOV N_[0b0000] INTO *STATUS_BUS

    LOD N_[0]
    JMP VGA_OUT.RET

#Output the audio  
AUDIO_OUT:
    #Put the second half of the keyboard value into audio
    MOV AUDIO INTO *CHIP_SELECT
    MOV N_[0b0100] INTO *STATUS_BUS
    MOV KEYIN2 INTO *DATA_BUS

    LOD N_[0]
    JMP AUDIO_OUT.RET

#These values are all subject to change as im not 100% sure this is right - could use label replacing as well if that would work better
AUDIO: .data 1 0b0000
KEYB: .data 1 0b0001
VGA: .data 1 0b0010

READY: .data 1 0b0010


RESULT: .data 1 0x0

KEYIN1: .data 1 0x0
KEYIN2: .data 1 0x0