; LC-3 Program
; Course: CSE 313 Machine Orginization
; Instructor: Taline Georgio
; Section: 02
; Term: Spring 14
; Names(s): William Ng
; Created: 6 / 1/ 14
; Lab7: Day of the Week
; Description:
; This program computes the day of the week, given a paticular
; date. The algorithm used by this program is the famous 
; Zeller Function. It is defined by the following equation
;	f = k + (13 * m - 1) / 5 + D + D / 4 + C / 4 - 2 * C
; where k is the month
; 	m  =
;		k + 12; if x <= 2
;		k ; otherwise
; 	D is the last zero padded two digits of the year
;	C is the first zero padded two digits of the year
; The return value is a number 0, 1, 2, ... 6 corresponding
; to the day of the week.
;


.ORIG x3000

	
	LDI R3, MONTH			; m
	LDI R4, DAY			; q (Day)
	LDI R5, YEAR			; 
	
	JSR COMPUTE_M			; Calculate M
	JSR COMPUTE_D			
	JSR COMPUTE_C
			
	ADD R6, R4 #0			; Add q (Day)
		
			
	LDI R2, M
	ADD R2, R2, #1 			; (M + 1)
	AND R1, R1, #0	
	ADD R1, R1, #13 
	JSR MULT			; 13 * ( M + 1)
	
	LDI R1, X_MUL_Y					
	AND R2, R2, #0
	ADD R2, R2, #5
	JSR DIV				; (13 * (M + 1)) / 5
	
	LDI R1, X_DIV_Y
	ADD R6, R6, R1			; q + (13 * (M + 1)) / 5
	
	LDI R1, D
	ADD R6, R6, R1			; q + (13 * (M + 1)) / 5 + D
	
	AND R2, R2, #0
	ADD R2, R2, #4
	JSR DIV				; D / 4
	LDI R1, X_DIV_Y
	ADD R6, R6, R1			; q + (13 * (M + 1))  / 5 + D + D / 4
	
	LDI R1, C
	AND R2, R2, #0
	ADD R2, R2, #4
	JSR DIV				; C / 4
		
	LDI R1, X_DIV_Y		
	ADD R6, R6, R1			; q + (13 * (M + 1)) / 5 + D + (D / 4) + C / 4
	
	
	LDI R1, C
	AND R2, R2, #0
	ADD R2, R2, #5			
	JSR MULT			; 5 * C
	
	LDI R1, X_MUL_Y
	ADD R6, R6, R1			; q + ((13 * (M + 1)) / 5) + D + (D / 4) + C / 4 + 5 * C
	
	ADD R1, R6, #0
	AND R2, R2, #0
	ADD R2, R2, #7
	JSR MOD				; h mod 7
	
	LDI R1, X_MOD_Y
	LD R0, DAYS_OF_THE_WEEK_LIST
	AND R2, R2, #0
	ADD R2, R2, #9
	JSR MULT
	LDI R1, X_MUL_Y
	ADD R0, R0, R1
	PUTS
	

HALT

MONTH	.FILL x31F0
DAY	.FILL x31F1
YEAR	.FILL x31F2
DAY_OF_THE_WEEK .FILL x31F3
DAYS_OF_THE_WEEK_LIST .FILL x3600
M	.FILL x3100
D	.FILL x3101
C	.FILL x3102	
X_MUL_Y .FILL x3103
X_DIV_Y .FILL x3104
X_MOD_Y .FILL x3105
N_100	.FILL #100


; Compute the value of M. It is defined by the following.
; if [ k <= 2 ]
;	k + 12
; else
; 	k	
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''' 
COMPUTE_M
	STI R1, SAVE_R1			; Save reigisters
	STI R2, SAVE_R2
	STI R3, SAVE_R3
		
	LDI R1, MONTH
	ADD R3, R1, #0
	AND R2, R2, #0
	ADD R2, R2, #-2
	ADD R1, R1, R2
	BRp MONTH_GT_2
	ADD R3, R3, #12
	BR #2
	MONTH_GT_2
		ADD R3, R3, #0
	STI R3, M 
	LDI R1, SAVE_R1			; Restore reigisters
	LDI R2, SAVE_R2
	LDI R3, SAVE_R3
	RET
		
; Compute the value of D. It is the last two digits of the year.
;''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
COMPUTE_D
	STI R1, SAVE_R1			; Save reigisters
	STI R2, SAVE_R2
	STI R3, SAVE_R3
	STI R7, SAVE_R7

	LDI R1, YEAR
	LD  R2, N_100	
	JSR MOD				; Calculate D
	LDI R3, X_MOD_Y
	STI R3, D
	LDI R1, SAVE_R1			; Restore reigisters
	LDI R2, SAVE_R2
	LDI R3, SAVE_R3
	LDI R7, SAVE_R7
	RET

; Compute the value of C. It is the first two digits of the year.
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
COMPUTE_C
	STI R1, SAVE_R1			; Save reigisters
	STI R2, SAVE_R2
	STI R3, SAVE_R3
	STI R7, SAVE_R7

	LDI R1, YEAR
	LD  R2, N_100	
	JSR DIV				; Calculate C
	LDI R3, X_DIV_Y
	STI R3, C
	LDI R1, SAVE_R1			; Restore reigisters
	LDI R2, SAVE_R2
	LDI R3, SAVE_R3
	LDI R7, SAVE_R7
	RET

MULT	
	STI R1, SAVE_R1			; Save registers
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	;STI R7, SAVE_R7
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
	LDI R5, SAVE_R5
	RET

MOD
	STI R1, SAVE_R1			; Save registors
	STI R2, SAVE_R2			;
	STI R3, SAVE_R3			;
	STI R4, SAVE_R4			;
	STI R5, SAVE_R5			;
	;STI R7, SAVE_R7

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
		BRnz #2			; If R3 cannot go into R1 exit loop
		ADD R4, R4, R3		; else continue to calculate modulo
		BR MOD_REPEAT
	STI R4, X_MOD_Y
	LDI R1, SAVE_R1			; Restore registers
	LDI R2, SAVE_R2			;
	LDI R3, SAVE_R3			;
	LDI R4, SAVE_R4			;
	LDI R5, SAVE_R5			;
	;LDI R7, SAVE_R7			;
	RET

; Used to save and restore registers
SAVE_R1 .FILL x3500
SAVE_R2 .FILL x3501
SAVE_R3 .FILL x3502
SAVE_R4 .FILL x3503
SAVE_R5 .FILL x3504
SAVE_R7 .FILL x3505

		

.END

 
;


