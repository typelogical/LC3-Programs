; LC-3 Program
; Course: CSE 313 Machine Orginization
; Section: 02
; Term: Spring 14
; Instructor: Taline Georgio 
; Name(s): William Ng
; Created: 5/5/14
; Lab4: Fibonacci Number
; Description:
;	This program implements the finacci sequence. 
;	The program will compute the nth fibonacci number Fn, and 
; 	the greatest fibonacci number FN that can be represented 
;	in 16 bit twos complement format. If Fn
;	becomes to large, it won't be able to be represented in
;	16 bits, and an overflow will occur, in which the bits
;	overlap the sign bit causing the value to become a negative. 
;	
;	The input will be an integer,n, found at location x3100.
;  	The ouput will be found at x3101, x3102, and x3103. Fn 
;	will be stored in location x3101. The Nth number will be
;	stored in x3102. The FN will be stored in x3103.


.ORIG x3000
	
	; Get and initialize registers.

	LEA R1, xFF		
	LDR R1, R1, #0		; Input n
	
	ADD R2, R2, #0		; Initlize other data values
	ADD R3, R3, #1		; R2 and R3 are used to store n-1 and n-2
	ADD R4, R4, #0		; R4 is used to store n	
	ADD R5, R5, #0		; R5 is used as the counter the current number

	ADD R1, R1, x-2		; Check if N is < 2
	BRnz nth_FIB_FOUND	; If T do not enter loop

FIND_nth_FIB
	; Find the nth fib.	
	
	NOT R6, R1		
	ADD R6, R6, #1		; Compare the counter against N
	ADD R6, R6, R5		; subtract the counter from N
	BRz nth_FIB_FOUND	; continue loop if counter not eq to N	

	ADD R4, R2, R3 		; Compute next fib number
	ADD R5, R5, #1		; Increment the counter
	ADD R2, R3, #0		; Set R2 = R3
	ADD R3, R4, #0		; Set R3 = R4

	BR FIND_nth_FIB	

nth_FIB_FOUND	
	; The nth fib found. Store the value.
	
	STI R4, Fn		; Store nth fibonacci number	

FIND_LARGEST_FIB
	; Find the largest Fib.
	
	ADD R4, R2, R3 		; Compute next fib number
	BRn LARGEST_FOUND	; If negative occurred there was an overflow

	ADD R2, R3, #0		; Set R2 = R3
	ADD R3, R4, #0		; Set R3 = R4
	ADD R5, R5, #1		; Increment the counter

	BR FIND_LARGEST_FIB

LARGEST_FOUND 

	; The largest Fib found. Store the values.

	STI R5, N		; Store the counter
	STI R3, FN		; Store the Nth fibonacci number

HALT
	; The storage locations for values
	Fn 	.FILL x3101	; The nth fib
	N 	.FILL x3102	; The counter for Nth fib
	FN	.FILL X3103	; The Nth fib

.END