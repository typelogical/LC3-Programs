; Class:CSE 313 Machine Orignizaiton Lab
; Section: 01
; Instructor: Taline Georgiou
; Term: Spring 2014
; Names (s): William Ng
; Lab#2: Arithmetic Functions
; Description:
;
; This program performs some basic arithmetic. The input will be 
; two values X and Y. They are stored at locations x3120 and x3121.
; Given the two inputs, the following out will be computed.
; 
; X-Y
; |X|
; |Y|
; Z

; X - Y is the subtraction of X and Y. |X| and |Y| or the absolute
; values of X and Y. Z is obtained by comparing X and Y. Z will
; get a value of 0 if they are equal, 1 if X is greater than Y,
; and 2 if  X is less than Y.

.ORIG x3000

;---------------------------------------------------
; X - Y
; X - Y = X + (-Y) = X + (NOT(Y) + 1)
; Ex. 5 - 3 = 2 = x0002
;---------------------------------------------------

LDI R3, X 		; Load the values of X and Y
LDI R4, Y		; Stored in x3120 and x3121
NOT R2, R4		; Do two's complement on Y
ADD R1, R3, R2		; Subtract Y from X
STI R1, X_minus_Y	; Store the result

;---------------------------------------------------
; |X|
;---------------------------------------------------







;---------------------------------------------------
; |Y|
;---------------------------------------------------














;---------------------------------------------------
; Z
;---------------------------------------------------



HALT

X 		.FILL x3120
Y 		.FILL x3121
X_minus_Y 	.FILL x3122
absX 		.FILL x3123
absY 		.FILL x3124
Z		.FILL x3125

.END


