;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - buildMaxArray
;;=============================================================
;; Name: Nandini Ramakrishnan
;;=============================================================

;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;	int A[] = {-2, 2, 1};
;;	int B[] = {1, 0, 3};
;;	int C[3];
;;	int length = 3;
;;
;;	int i = 0;
;;	while (i < length) {
;;		if (A[i] >= B[length - i - 1]) {
;;			C[i] = 1;
;;		}
;;		else {
;;			C[i] = 0;
;;		}
;;		i++;
;;	}

.orig x3000
	;; YOUR CODE HERE
	AND   R0,R0,#0
W1  LD    R1,LENGTH
	NOT   R1,R1
	ADD   R1,R1,#1
	ADD   R1,R0,R1
	BRzp  ENDW1
		NOT   R1,R1
		LD    R2,B
		ADD   R2,R2,R1

		LD    R3,A
		ADD   R3,R3,R0

		LDR   R2,R2,0
		LDR   R3,R3,0

		NOT   R2,R2
		ADD   R2,R2,1
		ADD   R2,R2,R3

		BRn   EL1
		AND   R1,R1,0
		ADD   R1,R1,1
		LD    R4,C
		ADD   R4,R4,R0
		STR   R1,R4,0
		JSR   THEN
		EL1
		AND   R1,R1,0
		LD    R4,C
		ADD   R4,R4,R0
		STR   R1,R4,0
		THEN
		ADD   R0,R0,1
	JSR W1
	ENDW1
	HALT

;; Do not change these addresses! 
;; We populate A and B and reserve space for C at these specific addresses in the orig statements below.
A 		.fill x3200		
B 		.fill x3300		
C 		.fill x3400		
LENGTH 	.fill 3			;; Change this value if you decide to increase the size of the arrays below.
.end

;; Do not change any of the .orig lines!
;; If you decide to add more values for debugging, make sure to adjust LENGTH and .blkw 3 accordingly.
.orig x3200				;; Array A : Feel free to change or add values for debugging.
	.fill -2
	.fill 2
	.fill 1
.end

.orig x3300				;; Array B : Feel free change or add values for debugging.
	.fill 1
	.fill 0
	.fill 3
.end

.orig x3400
	.blkw 3				;; Array C: Make sure to increase block size if you've added more values to Arrays A and B!
.end