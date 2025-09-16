org 0000h 
jmp main 

org 0033h 
main: 
	JB P2.1, $
	CLR P1.0
	JNB P2.1, $
	SETB P1.0

jmp main 

end 

