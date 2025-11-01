org 0000h
select: 
SETB P0.7
SETB P3.3 
SETB P3.4 
init: 
MOV R3, #00Ah

org 0033h
main: MOV DPTR, #lut 
volta: CLR A 
MOVC A, @A+DPTR
MOV P1, A
ACALL delay
INC DPTR 
DJNZ R3, volta 
SJMP init 
delay:
MOV R0, #05h
loop2:
MOV R1, #0BCh
loop1:
DJNZ R1, loop1
DJNZ R0, loop2
RET

org 0200h
lut: 
DB 0C0h, 0F9h, 0A4h, 0B0h, 99h, 92h, 82h, 0F8h, 80h, 90h
end 

