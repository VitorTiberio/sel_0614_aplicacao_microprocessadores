org 0000h
main:
MOV P1, #11000000b
ACALL delay
MOV P1, #11111001b
ACALL delay 
MOV P1, #10100100b
ACALL delay 
MOV P1, #10110000b
ACALL delay 
MOV P1, #10110000b
ACALL delay 
mov P1, #10011001b
ACALL delay
mov P1, #10010010b
ACALL delay 
mov P1, #10000010b
ACALL delay
mov P1, #11111000b
ACALL delay
mov P1, #10000000b
ACALL delay 
mov P1, #10011000b
ACALL delay
jmp main
delay:
MOV R0, #01h
loop1:
MOV R1, #03h
loop2:
DJNZ R1, loop2
DJNZ R0, loop1
RET

end