;;=============================================================
;;  CS 2110 - Spring 2023
;;  Homework 6 - Factorial
;;=============================================================
;;  Name: Nandini Ramakrishnan
;;============================================================

;;  In this file, you must implement the 'MULTIPLY' and 'FACTORIAL' subroutines.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'MULTIPLY' or 'FACTORIAL' labels
;;      * Add the [a, b] or [n] params separated by a comma (,) 
;;        (e.g. 3, 5 for 'MULTIPLY' or 6 for 'FACTORIAL')
;;      * Proceed to run, step, add breakpoints, etc.
;;      * Remember R6 should point at the return value after a subroutine
;;        returns. So if you run the program and then go to 
;;        'View' -> 'Goto Address' -> 'R6 Value', you should find your result
;;        from the subroutine there (e.g. 3 * 5 = 15 or 6! = 720)

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  MULTIPLY Pseudocode (see PDF for explanation and examples)
;;  
;;  MULTIPLY(int a, int b) {
;;      int ret = 0;
;;      while (b > 0) {
;;          ret += a;
;;          b--;
;;      }
;;      return ret;
;;  }

MULTIPLY ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the MULTIPLY subroutine here!
    ;;Stack build-up
    ADD   R6,R6,-1    ;;Space for return value
    ADD   R6,R6,-1    ;;Push return address
    STR   R7,R6,#0
    ADD   R6,R6,-1    ;;Save old frame pointer
    STR   R5,R6,0
    ADD   R6,R6,-1    ;;Make space for ret (local variable)
    ADD   R5,R6,0     ;;Stack and frame pointer both point to the local variable
    ADD   R6,R6,-5    ;;Making space for storing the old values of R0-R4
    ADD   R6,R6,-2    ;;Make space for extra local variables (2)
    STR   R0,R6,#0    ;;Store old R0
    STR   R1,R6,#1    ;;Store old R1
    STR   R2,R6,#2    ;;Store old R2
    STR   R3,R6,#3    ;;Store old R3
    STR   R4,R6,#4    ;;Store old R4

    ;;a is R0
    LDR   R0, R5, 4
    ;;b is R1 (offset 0)
    LDR   R1, R5, 5
    STR   R1, R5, 0
    ;;ret is R1 (offset -1)
    AND   R1, R1, 0
    STR   R1, R5, -1

    ;;WHILE loop
W1  LDR   R1, R5, 0
    ;;check what b is
    ADD   R1, R1, 0
    ;;If b is less than or equal to 0, branch to  ENDWHILE
    BRnz  ENDWHILE
    ;;Ret += a
    LDR   R1, R5, -1
    ADD   R1, R1, R0
    STR   R1, R5, -1
    ;;b--
    LDR   R1, R5, 0
    ADD   R1, R1, -1
    STR   R1, R5, 0
    BR W1
    ENDWHILE
    LDR   R1, R5, -1
    STR   R1, R5, 3
    BR TEARDOWN


TEARDOWN
    LDR     R0,R6,#0    ;; Restore old R0
    LDR     R1,R6,#1    ;; Restore old R1
    LDR     R2,R6,#2    ;; Restore old R2
    LDR     R3,R6,#3    ;; Restore old R3
    LDR     R4,R6,#4    ;; Restore old R4
    ADD     R6,R5,#0    ;; Pop off restored registers and any local variables (LV)
    LDR     R5,R6,#1    ;; Restore old frame pointer (FP)
    LDR     R7,R6,#2    ;; Restore return address (RA)
    ADD     R6,R6,#3    ;; Pop off LV1, old FP, and RA
    RET

;;  FACTORIAL Pseudocode (see PDF for explanation and examples)
;;
;;  FACTORIAL(int n) {
;;      int ret = 1;
;;      for (int x = 2; x <= n; x++) {
;;          ret = MULTIPLY(ret, x);
;;      }
;;      return ret;
;;  }

FACTORIAL ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the FACTORIAL subroutine here!
    ;;Stack build-up
    ADD   R6,R6,-1    ;;Space for return value
    ADD   R6,R6,-1    ;;Push return address
    STR   R7,R6,#0
    ADD   R6,R6,-1    ;;Save old frame pointer
    STR   R5,R6,0
    ADD   R6,R6,-1    ;;Make space for ret (local variable)
    ADD   R5,R6,0     ;;Stack and frame pointer both point to the local variable
    ADD   R6,R6,-3    ;;Make space for extra local variables (3)
    ADD   R6,R6,-5    ;;Making space for storing the old values of R0-R4
    STR   R0,R6,#0    ;;Store old R0
    STR   R1,R6,#1    ;;Store old R1
    STR   R2,R6,#2    ;;Store old R2
    STR   R3,R6,#3    ;;Store old R3
    STR   R4,R6,#4    ;;Store old R4

    ;;-n is R0
    LDR   R0, R5, 4
    NOT   R0, R0
    ADD   R0, R0, 1
    ;;ret is R1
    AND   R1, R1, 0
    ADD   R1, R1, 1
    ;;x is R2
    AND   R2, R2, 0
    ADD   R2, R2, 2
    ;;x-n is R3
    AND   R3, R3, 0

    ;;FOR loop
FOR ADD   R3, R2, R0
    ADD   R3, R3, 0
    ;;If x-n is greater than 0, branch to ENDFOR
    BRp   ENDFOR
    ;;Load x into stack
    ADD   R6, R6, -1
    STR   R2, R6, 0
    ;;Load ret into stack
    ADD   R6, R6, -1
    STR   R1, R6, 0
    JSR   MULTIPLY
    ;;Load return value into R1
    LDR   R1, R6, 0
    ;;Pop of arguments
    ADD   R6, R6, 3
    ;;x++
    ADD   R2, R2, 1
    BR    FOR
    ENDFOR
    STR   R1, R5, 3

    BR TEARDOWN

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end