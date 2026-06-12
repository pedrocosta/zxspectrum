10 REM [A simple BASIC program to save and execute a machine code program in memory]
20 RESTORE 9000: REM [Refresh DATA]
30 CLS:REM [Clear the display]
40 PRINT "Press a key to load M.C program"
50 PAUSE 0: REM [Wait for user to press a key]
60 LET memory=40000: REM [Initialize "memory" variable to store address locations for MC]

100 READ i$: REM [Read z80 assembly instruction description]
110 PRINT 'i$,: REM [Print z80 assembly instruction]
120 READ bytenum: REM [Read number of MC bytes for instruction]
130 PRINT "Bytes: ";bytenum
140 for f=1 to bytenum: REM [Set loop counter for number of bytes]
150 READ byte: REM [Read a MC byte into the variable "byte"]
160 POKE memory, byte : REM [Save MC byte to memory address]
170 PRINT memory, PEEK (memory): REM [Print memory address and MC byte]
180 IF byte=201 THEN GOTO 1000: REM [Check for RETURN instruction (201)]
190 LET memory=memory+1: REM [Incrememt memory address]
200 NEXT f: REM [Go read next MC byte]
210 PRINT '"Press a key for next instruction"
220 PAUSE 0: REM [Wait for user input]
230 GOTO 100: REM [Go read next z80 instruction]
1000 PRINT '"Press any key to execute M.C."
1010 PAUSE 0: REM [Wait for user input]
1020 RANDOMIZE usr 40000: REM [Execute MC program (stored at address 40000)]
8999 STOP: REM [End program once MC has finished executing]

9000 REM [MACHINE CODE BYTES BELOW]
9001 DATA "LD A,2",2,62,2:REM [Load border color (red) into register A]
9002 DATA "OUT (254),A",2,211,254:REM [Set border to color stored in register A]
9003 DATA "RETURN",1,201:REM [Return to BASIC]
