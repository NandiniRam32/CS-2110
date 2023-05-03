;;=============================================================
;; CS 2110 - Spring 2023
;; Homework 5 - octalStringToInt
;;=============================================================
;; Name: Nandini Ramakrishnan
;;=============================================================

;;  Pseudocode (see PDF for explanation)
;;  Pseudocode values are based on the labels' default values.
;;
;;  String octalString = "2110";
;;  int length = 4;
;;  int value = 0;
;;  int i = 0;
;;  while (i < length) {
;;      int leftShifts = 3;
;;      while (leftShifts > 0) {
;;          value += value;
;;          leftShifts--;
;;      }
;;      int digit = octalString[i] - 48;
;;      value += digit;
;;      i++;
;;  }
;;  mem[mem[RESULTADDR]] = value;

.orig x3000
    ;; YOUR CODE HERE
    LD    R0,OCTALSTRING
    AND   R1,R1,#0    ;;R1 holds i, do NOT store temporary values in R1
    AND   R2,R2,#0    ;;R2 holds value, do NOT store temporary values in R2
W1  LD    R3,LENGTH
    NOT   R3,R3
    ADD   R3,R3,#1
    ADD   R3,R3,R1
    BRzp  ENDW1    ;;Exits loops if i - length is zero or positive
    AND   R4,R4,#0
    ADD   R4,R4,#3 ;;leftShifts = 3
    W2    ADD   R4,R4,#0
          BRnz  ENDW2
          ADD   R2,R2,R2
          ADD   R4,R4,#-1
          JSR   W2
          ENDW2
    LD    R0,OCTALSTRING
    ADD   R0,R0,R1
    LDR   R0,R0,0
    ADD   R0,R0,#-12
    ADD   R0,R0,#-12
    ADD   R0,R0,#-12
    ADD   R0,R0,#-12    ;;R0 is digit
    ADD   R2,R2,R0
    ADD   R1,R1,#1
    JSR   W1
    ENDW1
    STI   R2,RESULTADDR
    HALT
    
;; Do not change these values! 
;; Notice we wrote some values in hex this time. Maybe those values should be treated as addresses?
ASCII           .fill -48
OCTALSTRING     .fill x5000
LENGTH          .fill 4
RESULTADDR      .fill x4000
.end

.orig x5000                    ;;  Don't change the .orig statement
    .stringz "2110"            ;;  You can change this string for debugging!
.end
