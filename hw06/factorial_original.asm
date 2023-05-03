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
    ADD   R6,R6,-1    ;;Space for return value
    ADD   R6,R6,-1    ;;Push return address
    STR   R7,R6,#0
    ADD   R6,R6,-1    ;;Save old frame pointer
    STR   R5,R6,0
    ADD   R6,R6,-1    ;;Make space for ret (local variable)
    ADD   R5,R6,0     ;;Stack and frame pointer both point to the local variable
    ADD   R6,R6,-5    ;;Making space for storing the old values of R0-R4
    STR   R0,R6,#0    ;;Store old R0
    STR   R1,R6,#1    ;;Store old R1
    STR   R2,R6,#2    ;;Store old R2
    STR   R3,R6,#3    ;;Store old R3
    STR   R4,R6,#4    ;;Store old R4
    LDR   R0,R5,#4    ;;Loads the value of the first parameter into R0 (a)
    LDR   R1,R5,#5    ;;Loads b into R1
    AND   R2,R2,#0    ;;int ret = 0
W1  ADD   R1,R1,#0    ;;checks what b is
    BRnz  ENDW1       ;;if b is negative or zero, go to the end of the while loop
    ADD   R2,R2,R0    ;;R2 = R2 + a
    ADD   R1,R1,-1    ;;R1--
    BR    W1
    ENDW1
    ;;ADD POP STUFF HERE
    STR   R2,R5,#3
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
    ADD   R6,R6,-1   ;;Space for return value
    ADD   R6,R6,-1   ;;Push return address
    STR   R7,R6,#0
    ADD   R6,R6,-1   ;;Save old frame pointer
	STR   R5,R6,0
    ADD   R6,R6,-1   ;;Make space for local variables (ret, x, x-n)
    ADD   R5,R6,0    ;;R5 = R6, both point to ret
    ADD   R6,R6,-5	 ;;Make space for old REGs
    STR   R0,R6,#0   ;;Store old R0
    STR   R1,R6,#1   ;;Store old R1
    STR   R2,R6,#2   ;;Store old R2
    STR   R3,R6,#3   ;;Store old R3
    STR   R4,R6,#4   ;;Store old R4
    LDR   R0,R5,4    ;;R0 is n
    AND   R1,R1,0    ;;R1 is ret
    ADD   R1,R1,1    ;;ret = 1
    AND   R2,R2,0    ;;R2 is x
    ADD   R2,R2,2    ;;x = 2
    AND   R3,R3,0    ;;R3 is x-n
    NOT   R0,R0
    ADD   R0,R0,1
F1  ADD   R3,R2,R0   ;;R3 is x-n
    BRp   ENDF1
    ADD   R6,R6,-1   ;pushes b into the stack
    STR   R2,R6,#0
    ADD   R6,R6,-1   ;;pushes a into the stack
    STR   R1,R6,#0
    JSR   MULTIPLY
    LDR   R1,R6,0    ;;loads the value of multiply into ret
    ADD   R6,R6,3    ;;3 is for the three arguments (a, b, n)
    ADD   R2,R2,1    ;;x++
    BR    F1
    ENDF1
    STR   R1,R5,3
    BR TEARDOWN

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end