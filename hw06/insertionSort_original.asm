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
    ADD   R6,R6,-1    ;;Makes space for return value
    ADD   R6,R6,-1    ;;Pushes the return address
    STR   R7,R6,#0
    ADD   R6,R6,-1    ;;Saves old frame pointer
    STR   R5,R6,0
    ADD   R6,R6,-1    ;;Makes space for the first local variable
    ADD   R5,R6,0     ;;Sets R5 and R6 to the same pointer location
    ADD   R6,R6,-5    ;;Go up 5
    STR   R0,R6,#0    ;;Store old R0
    STR   R1,R6,#1    ;;Store old R1
    STR   R2,R6,#2    ;;Store old R2
    STR   R3,R6,#3    ;;Store old R3
    STR   R4,R6,#4    ;;Store old R4

    ;;Load the address of arr into R0
    LDR   R0, R5, 4
    ;;Load length into R1
    LDR   R1, R5, 5

    ;;Make R1 (length - 1)
    ADD   R1, R1, -1
    ;;ADD R1 (length - 1) to 0
IF1 ADD   R1, R1, 0
    ;;If that value is positive, then go to ENDIF
    BRp   ENDIF
    ;;Return (go to teardown)
    BR    TEARDOWN
    ;;ENDIF
    ENDIF

    ;;Push R1 (length - 1) into stack
    ADD   R6, R6, -1
    STR   R1, R6, 0
    ;;Push R0 (arr) into stack
    ADD   R6, R6, -1
    STR   R0, R6, 0
    JSR INSERTION_SORT
    ;;Pop out the two arguments and the return value
    ADD   R6, R6, 3

    ;;Make R2 arr[length - 1] (last_element)
    ADD   R2, R0, R1
    ;;Get its value as last_element (R2 -> last_element)
    LDR   R2, R2, 0
    ;;R2 -> -last_element
    NOT   R2, R2
    Add   R2, R2, 1
    ;;Make R1 n (length - 2), new R1 is just R1 - 1
    ADD   R1, R1, -1

    
    ;;While loop stuff starts here
    ;;Add R1 (n) to 0
W1  ADD   R1, R1, 0
    ;;if it's less than 0, go to ENDWHILE
    BRn   ENDWHILE
    ;;Otherwise, assign R3 to be arr[n] (W2)
W2  ADD   R3, R0, R1
    LDR   R3, R3, 0
    ;;ADD arr[n] to R2
    ADD   R3, R3, R2
    ;;if it is zero or negative, go to ENDWHILE
    BRnz  ENDWHILE
    ;;Make R3 arr[n] again
    ADD   R3, R0, R1
    LDR   R3, R3, 0
    ;;Make R1 n + 1
    ADD   R1, R1, 1
    ;;Make R4 the address of arr[n+1]
    ADD   R4, R0, R1
    ;;Make R1 n again
    ADD   R1, R1, -1
    ;;arr[n+1] = arr[n]
    STR   R3, R4, 0
    ;;n--
    ADD   R1, R1, -1
    ;;Loop back to beginning of while loop
    BR    W1
    ENDWHILE
    ;;Switch R2 back to last_element
    NOT   R2, R2
    ADD   R2, R2, 1
    ;;Make R1 n + 1
    ADD   R1, R1, 1
    ;;Make R4 the address of arr[n+1]
    ADD   R4, R0, R1
    ;;arr[n+1] = last_element
    STR   R2, R4, 0


    ;;We need registers for:
        ;;n -> R1
        ;;arr[n] -> R3
        ;;arr[n+1] -> R4 (updating)
        ;;arr -> R0
        ;;last_element -> R2

    ;;Go to teardown
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