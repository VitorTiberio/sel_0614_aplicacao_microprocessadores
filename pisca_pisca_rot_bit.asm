org 0000h
jmp main 
org 0033h
main:	
	MOV A, #0FEh
	MOV P1, A
	ACALL delay
esq:
	RL A
	MOV P1, A
	ACALL delay 
	CJNE A, #07Fh, esq
dir:
	RR A
	MOV P1, A
	ACALL delay 
	CJNE A, #0FEh, dir 

	SJMP main 
delay:
	MOV R0, #250h
loop2: 
	MOV R1, #100h
loop1: 
	DJNZ R1, loop1
	DJNZ R0, loop2
	RET

	END 

