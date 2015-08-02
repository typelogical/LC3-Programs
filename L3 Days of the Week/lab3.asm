; LC3 Program
; Class: CSE 313, Machine Organization 
; Section: 02
; Term: Spring 14
; Instructor: Taline Georgio
; Name(s): William Ng
; Created : 4 /28/ 14
; Lab: #3 Days of the Week
; Description:
; 	This program displays the days of the week to the console.
;	A day of the week is displayed to the console corresponding
; 	to whatever the user inputs.
;
;	Input is read from the user as a number from 0-6. A 0 
;	corresponds to sunday, a one corresponds to 1, a 2 
;	corresponds to a 3, and so on. The output will be a
;	day of the week reprented as a string. So 0 would
;	display "Sunday" to the console, 1 would dispaly 
; 	"Monday" to the console, 2 would display "Tuesday"
; 	to the console, and so on. 


.ORIG x3000
	LEA R0, PROMPT		; Prompt user for input
	PUTS
	GETC			; Get input from user

; Convert input from ascii to integer
	ADD R0, R0, #-16
	ADD R0, R0, #-16
	ADD R0, R0, #-16

; Validate input
;/-----------------------------

;check lower bound and check upper bound
;	if input < 0
;		invalid
;	else if input - 6 > 0
;		invalid
;	else 
;		valid
;/-----------------------------
	ADD R0, R0, #0
	BRn INVALID
	ADD R0, R0, #-6
	BRp INVALID
;	OUT 
; Display the day of the week
;/-----------------------------

;/-----------------------------

LOOP				; Go thR0ugh the days of the week
	LEA R0, DAYS
	ADD R0, R0, #0
	BRz DISPLAY		; Day of week found, so display 	
	ADD R0, R0, #10		; Go to the next day of the week 
	ADD R0, R0, #-1		; Decrement the counter
	BRp LOOP
DISPLAY				; Display the day of the week
	PUTS

INVALID				; Input is invalid

HALT

PROMPT .STRINGZ "Please enter a number fR0m 0-6: "
DAYS .STRINGZ "Sunday   "
 .STRINGZ "Monday   "
 .STRINGZ "Tuesday  "
 .STRINGZ "Wendsday "
 .STRINGZ "Thursday "
 .STRINGZ "Friday   "
 .STRINGZ "Saturday " 


.END


