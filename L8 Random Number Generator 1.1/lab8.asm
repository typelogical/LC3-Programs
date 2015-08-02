; Lc-3 Program
; Course: CSE 313 Mahcine Orginization
; Section: 02
; Term: Spring 14
; Instructor: Taline Georgiou
; Created: 6 / 8 / 14
; Creator(s): William Ng
; Lab 8: Random Number Generator
; Description: 
;	This program generates random numbers. The algorithm 
;	use is Scharge's Method. It is defined
;	by a recurrence relation,
;		Xn <- aXn-1 mod m
;	where aXn-1 mod m is defined by the following.
; 	if ( x > 0 )
;		a (x mod q) - r (x / q)
; 	else
;		a (x mod q) - r (x / q) + m
;	note: q = m / a, r = m mod a
;


.ORIG x3000		
	
LOOP
	
	; a (x mod q) - r (x / q)
	LD R1, M
	LD R2, A


	JSR DIV			; q  <- m / a
	LDI R3, X_DIV_Y
	ST R3, Q		

	JSR MOD			; r  <- m mod a
	LDI R3, X_MOD_Y
	ST R3, R

	LD R1, X
	LD R2, Q
	JSR MOD			; X mod q
	
	LD R1, A
	LDI R2, X_MOD_Y
	JSR MULT		; A * (X mod q)
	LDI R3, X_MUL_Y		; Save the result
	
	LD R1, X
	LD R2, Q
	JSR DIV			; x / q
	
	LD R1, R
	LDI R2, X_DIV_Y
	JSR MULT 		; R * (x / q)
	LDI R4, X_MUL_Y		; Save the result

	NOT R4, R4
	ADD R4, R4, #1
	
	ADD R3, R3, R4		; A * (X mod q) - R * (x / q)
	ST R3, X		
	LD R5, X		

	BRn X_LT_0
		JSR OUTPUT
	X_LT_0
		LDI R2, M
		ADD R1, R1, R2 
		JSR OUTPUT
		
	LD R1, NGEN
	ADD R1, R1, #-1
	BRz LOOP_END
	ST R1, NGEN
	BR LOOP
LOOP_END

HALT
M .FILL #32767
A .FILL x0007
X .FILL x0001
Q .FILL x0000
R .FILL x0000
X_MUL_Y .FILL x3100
X_DIV_Y	.FILL x3101
X_MOD_Y	.FILL x3102
NGEN .FILL xA 

;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

MULT	
	STI R1, SAVE_R1			; Save registers
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	STI R7, SAVE_R7
	AND R4, R4, #0			; Test the sign of X
	ADD R1, R1, #0
	BRn X_NEG			; If X is negative, change X to positive	
	BR #3				 
	X_NEG				
		NOT R1, R1
		ADD R1, R1, #1
		NOT R4, R4
	ADD R2, R2, #0
	BRn Y_NEG			; If Y is negative, change Y to positive
	BR #3				; Change Y to positive
	Y_NEG
		NOT R2, R2
		ADD R2, R2, #1
		NOT R4, R4
	AND R3, R3, #0		
	MULT_REPEAT
		ADD R3, R3, R1		; Perform addition on X
		ADD R2, R2, #-1		; Use R2 as the counter
		BRnp MULT_REPEAT	; Continue loop while counter not equal to 0		
	
	ADD R4, R4, #0			; Test the sign flag
	BRn CHANGE_SIGN			; Change the result if sign flag is negative
	BR #2
	CHANGE_SIGN			; Change the sign of the result
		NOT R3, R3	
		ADD R3, R3, #1
	STI R3, X_MUL_Y			; Save the result
	LDI R1, SAVE_R1			; Restore registers
	LDI R2, SAVE_R2			;
	LDI R3, SAVE_R3			;
	LDI R4, SAVE_R4			;
	RET
DIV
	STI R1, SAVE_R1			; Save registers
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	STI R5, SAVE_R5			;
	
	AND R3, R3, #0			; Initialize the whole part counter
	AND R5, R5, #0			; Initialize the sign flag
	ADD R1, R1, #0
	BRn X_NEG_2			; If X is negative, change X to positive
	BR #3
	X_NEG_2
		NOT R1, R1
		ADD R1, R1, #1
		NOT R5, R5
	ADD R2, R2, #0
	BRn Y_NEG_2
	BR #3
	Y_NEG_2
		NOT R2, R2
		ADD R2, R2, #1
		NOT R5, R5
	
	NOT R4, R2			; Initialize the decrement counter
	ADD R4, R4, #1			; 
	DIV_REPEAT
		ADD R1, R1, R4		; Subtract Y from X		
		BRn #2
		ADD R3, R3, #1		; Increment the whole number counter
		BR DIV_REPEAT		; Continue loop while X is still greater than Y
	ADD R5, R5, #0			; Test the sign flag
	BRn CHANGE_SIGN_2		; Change the result if sign flag is negative
	BR #2
	CHANGE_SIGN_2			; Change the sign of the result
		NOT R3, R3	
		ADD R3, R3, #1
	STI R3, X_DIV_Y			; Save the result			
	LDI R1, SAVE_R1			; Restore registers
	LDI R2, SAVE_R2			;
	LDI R3, SAVE_R3			;
	LDI R4, SAVE_R4			;
	LDI R5, SAVE_R5			;
	RET

MOD
	STI R1, SAVE_R1			; Save registors
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	STI R5, SAVE_R5			;
	STI R7, SAVE_R7			;

	AND R5, R5, #0
	ADD R1, R1, #0
	BRn X_NEG_3			; If X is negative, change X to positive
	BR #3
	X_NEG_3
		NOT R1, R1
		ADD R1, R1, #1
		NOT R5, R5
	ADD R2, R2, #0
	BRn Y_NEG_3
	BR #3
	Y_NEG_3				; If Y is negative, change Y to positive
		NOT R2, R2
		ADD R2, R2, #1
		NOT R5, R5
	NOT R3, R2			; Initialize the decrement counter	
	ADD R3, R3, #1			;
	ADD R4, R1, #0			; Initialize the modulo counter
	MOD_REPEAT			
		ADD R1, R1, R3 		; 
		BRn #2			; If R3 cannot go into R1 exit loop
		ADD R4, R4, R3		; else continue to calculate modulo
		BR MOD_REPEAT
	STI R4, X_MOD_Y
	LDI R1, SAVE_R1			; Restore registers
	LDI R2, SAVE_R2			;
	LDI R3, SAVE_R3			;
	LDI R4, SAVE_R4			;
	LDI R5, SAVE_R5			;
	LDI R7, SAVE_R7			;
	RET

OUTPUT
	STI R1, SAVE_R1			; Save registors
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	STI R5, SAVE_R5			;
	STI R7, SAVE_R7			;
 

	
	LD R1, X
	AND R2, R2, #0
	ADD R2, R2, #10

	PUSH_DIGITS	
		ADD R1, R1, #0
		BRz PUSH_DIGITS_END
		JSR MOD				; Get last digit
		JSR DIV				; Reomove last digit
		LDI R3, X_MOD_Y
		JSR PUSH			; Put last digit onto stack
		LDI R1, X_DIV_Y
		BR NUMBER_LOOP		
	
		PUSH_DIGITS_END
	POP_DIGITS
		JSR POP
		LDI R1, TOP
		JSR ITOA
		LDI R0, ASCII
		OUT
			
	

		









	LDI R1, SAVE_R1			; Restore registers
	LDI R2, SAVE_R2			;
	LDI R3, SAVE_R3			;
	LDI R4, SAVE_R4			;
	LDI R5, SAVE_R5			;
	LDI R7, SAVE_R7	

	RET

; Used to save and restore registers
SAVE_R1 .FILL x3500
SAVE_R2 .FILL x3501
SAVE_R3 .FILL x3502
SAVE_R4 .FILL x3503
SAVE_R5 .FILL x3504
SAVE_R7 .FILL x3505


.END



