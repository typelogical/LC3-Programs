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
;		k + 10; if x <= 2
;		k - 2; otherwise
; 	D is the last zero padded two digits of the year
;	C is the first zero padded two digits of the year
; The return value is a number 0, 1, 2, ... 6 corresponding
; to the day of the week.
;


.ORIG x3000

	
	LDI R3, MONTH
	LDI R4, DAY
	LDI R5, YEAR
	
	ADD R1, R1, R3
	JSR COMPUTE_M			; Calculate m
	
	ADD R1, R5, #0
	LD  R2, N_100
	JSR DIV
	ADD R2, R2, R2 
	AND R6, R6, #0			
	ADD R6, R3, R1			; Add k
		
	ADD R1, R1, #13 		
	LDI R2, M
	JSR MULT			; (13 * m)
	LDI R1, X_MUL_Y			
	ADD R1, R1, #-1			; (13 * m) - 1
	ADD R2, R2, #5
	JSR DIV				; (13 * m - 1) / 5
	LDI R1, X_DIV_Y
	ADD R6, R6, R1			; k + (13 * m - 1) / 5
	ADD R6, R6, R4			; k + (13 * m - 1) / 5 + D
	ADD R1, R4, #0
	ADD R2, R2, #4
	JSR DIV				; D / 4
	LDI R1, X_DIV_Y
	ADD R6, R6, R1			; k + (13 * m - 1) / 5 + D + D / 4
HALT

DAY_OF_THE_WEEK .FILL x31F3
MONTH	.FILL x31F0
DAY	.FILL x31F1
YEAR	.FILL x31F2	
X_MUL_Y .FILL x3100
X_DIV_Y .FILL x3101
M	.FILL x3102

.END




