;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - palindrome
;;=============================================================
;; Name: Nandini Ramakrishnan
;;=============================================================

;;  NOTE: Let's decide to represent "true" as a 1 in memory and "false" as a 0 in memory.
;;
;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;  String str = "aibohphobia";
;;  boolean isPalindrome = true
;;  int length = 0;
;;  while (str[length] != '\0') {
;;		length++;
;;	}
;; 	
;;	int left = 0
;;  int right = length - 1
;;  while(left < right) {
;;		if (str[left] != str[right]) {
;;			isPalindrome = false;
;;			break;
;;		}
;;		left++;
;;		right--;
;;	}
;;	mem[mem[ANSWERADDR]] = isPalindrome;

.orig x3000
	;; YOUR CODE HERE
	LD    R0,STRING   ;;R0 is STRING, do NOT modify
	AND   R1,R1,#0    ;;R1 is length, do NOT modify
W1  ADD   R2,R0,R1
	LDR   R2,R2,0
	;;IS THIS PART^ DONE?
	BRz   ENDW1
	ADD   R1,R1,#1
	JSR   W1
	ENDW1
	AND   R2,R2,#0    ;;Resets R2, R2 is now left
	ADD   R3,R1,#-1   ;;R3 is right
W2  NOT   R3,R3
    ADD   R3,R3,#1    ;;2s complement of right
	AND   R4,R4,#0
	ADD   R4,R3,R2    ;;R4 is left + right
	BRzp  ENDW2
	ADD   R3,R3,#-1
	NOT   R3,R3       ;;R3 is back to being right
	IF1   AND   R4,R4,#0  ;;Temporarily changes R4
	      ADD   R4,R0,R2
		  LDR   R4,R4,0
	      ADD   R0,R0,R3  ;;Temporarily changes R0
		  LDR   R0,R0,0
		  NOT   R0,R0
		  ADD   R0,R0,#1  ;;2s complement of R0
		  ADD   R0,R0,R4
		  BRz   ENDIF1
		  AND   R0,R0,#0
		  STI   R0,ANSWERADDR  ;;Returns false
		  HALT
		  ENDIF1
	AND   R0,R0,#0
	LD    R0,STRING   ;;Reverts R0 back to STRING
	ADD   R2,R2,#1
	ADD   R3,R3,#-1
	JSR   W2
	ENDW2
	AND   R0,R0,#0
	ADD   R0,R0,#1
	STI   R0,ANSWERADDR
	HALT

;; Do not change these values!
STRING	.fill x4004
ANSWERADDR 	.fill x5005
.end

;; Do not change any of the .orig lines!
.orig x4004				   
	.stringz "aibohphobia" ;; Feel free to change this string for debugging.
.end

.orig x5005
	ANSWER  .blkw 1
.end