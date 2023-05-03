;;=============================================================
;;  CS 2110 - Spring 2023
;;  Homework 6 - Insertion Sort
;;=============================================================
;;  Name: Nandini Ramakrishnan
;;============================================================

;;  In this file, you must implement the 'INSERTION_SORT' subroutine.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'INSERTION_SORT' label
;;      * Add the [arr (addr), length] params separated by a comma (,) 
;;        (e.g. x4000, 5)
;;      * Proceed to run, step, add breakpoints, etc.
;;      * INSERTION_SORT is an in-place algorithm, so if you go to the address
;;        of the array by going to 'View' -> 'Goto Address' -> 'Address of
;;        the Array', you should see the array (at x4000) successfully 
;;        sorted after running the program (e.g [2,3,1,1,6] -> [1,1,2,3,6])

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  INSERTION_SORT **RESURSIVE** Pseudocode (see PDF for explanation and examples)
;; 
;;  INSERTION_SORT(int[] arr (addr), int length) {
;;      if (length <= 1) {
;;        return;
;;      }
;;  
;;      INSERTION_SORT(arr, length - 1);
;;  
;;      int last_element = arr[length - 1];
;;      int n = length - 2;
;;  
;;      while (n >= 0 && arr[n] > last_element) {
;;          arr[n + 1] = arr[n];
;;          n--;
;;      }
;;  
;;      arr[n + 1] = last_element;
;;  }

INSERTION_SORT ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the INSERTION_SORT subroutine here!
    ;; NOTE: Your implementation MUST be done recursively
    ;;Stack build-up
    ADD   R6,R6,-1    ;;Space for return value
    ADD   R6,R6,-1    ;;Push return address
    STR   R7,R6,#0
    ADD   R6,R6,-1    ;;Save old frame pointer
    STR   R5,R6,0
    ADD   R6,R6,-1    ;;Make space for ret (local variable)
    ADD   R5,R6,0     ;;Stack and frame pointer both point to the local variable
    ADD   R6,R6,-4    ;;Make space for extra local variables (4)
    ADD   R6,R6,-5    ;;Making space for storing the old values of R0-R4
    STR   R0,R6,#0    ;;Store old R0
    STR   R1,R6,#1    ;;Store old R1
    STR   R2,R6,#2    ;;Store old R2
    STR   R3,R6,#3    ;;Store old R3
    STR   R4,R6,#4    ;;Store old R4

    ;;Block 1 Registers:
    ;;Load address of arr into R0
IF  LDR   R0, R5, 4
    ;;Load value of length into R1
    LDR   R1, R5, 5
    ;;Make R2 length - 1
    AND   R2, R2, 0
    ADD   R2, R1, -1
    ;;If R2 is positive, branch to ENDIF
    BRp   ENDIF
    ;;Otherwise, branch to teardown
    BR TEARDOWN
    ENDIF

    ;;INSERTION_SORT(arr, length - 1);
    ;;Needed Registers:
    ;;Push R2 into the stack (length - 1)
    ADD   R6, R6, -1
    STR   R2, R6, 0
    ;;Push R0 into the stack (address of arr)
    ADD   R6, R6, -1
    STR   R0, R6, 0
    JSR   INSERTION_SORT
    ;;Load the return value into R3
    LDR   R3, R6, 0
    ;;Pop off 3 values (2 arguments and 1 return value)
    ADD   R6, R6, 3

    ;;int last_element = arr[length - 1];
    ;;int n = length - 2;
    ;;Needed registers:
    ;;R0 is address of arr
    LDR   R0, R5, 4
    ;;R1 is length - 1
    ADD   R1, R1, -1
    ;;R2 is arr[length - 1] (last_element)
    ADD   R2, R1, R0
    LDR   R2, R2, 0
    ;;R4 is n (length - 2)
    ADD   R4, R1, -1



;;  while (n >= 0 && arr[n] > last_element) {
;;      arr[n + 1] = arr[n];
;;      n--;
;;  }
    ;;Block 3 needed registers:
    ;;R0 is the address of arr (R5 offset 0)
    ;;R1 is n



















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

;; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end

.orig x4000	;; Array : You can change these values for debugging!
    .fill 2
    .fill 3
    .fill 1
    .fill 1
    .fill 6
.end