;;=============================================================
;;  CS 2110 - Spring 2023
;;  Homework 6 - Preorder Traversal
;;=============================================================
;;  Name: Nandini Ramakrishnan
;;============================================================

;;  In this file, you must implement the 'PREORDER_TRAVERSAL' subroutine.

;;  Little reminder from your friendly neighborhood 2110 TA staff: don't run
;;  this directly by pressing 'Run' in complx, since there is nothing put at
;;  address x3000. Instead, call the subroutine by doing the following steps:
;;      * 'Debug' -> 'Simulate Subroutine Call'
;;      * Call the subroutine at the 'PREORDER_TRAVERSAL' label
;;      * Add the [root (addr), arr (addr), index] params separated by a comma (,) 
;;        (e.g. x4000, x4020, 0)
;;      * Proceed to run, step, add breakpoints, etc.
;;      * Remember R6 should point at the return value after a subroutine
;;        returns. So if you run the program and then go to 
;;        'View' -> 'Goto Address' -> 'R6 Value', you should find your result
;;        from the subroutine there (e.g. Node 8 is found at x4008)

;;  If you would like to setup a replay string (trace an autograder error),
;;  go to 'Test' -> 'Setup Replay String' -> paste the string (everything
;;  between the apostrophes (')) excluding the initial " b' ". If you are 
;;  using the Docker container, you may need to use the clipboard (found
;;  on the left panel) first to transfer your local copied string over.

.orig x3000
    ;; You do not need to write anything here
    HALT

;;  PREORDER_TRAVERSAL Pseudocode (see PDF for explanation and examples)
;;  - Nodes are blocks of size 3 in memory:
;;      * The data is located in the 1st memory location (offset 0 from the node itself)
;;      * The node's left child address is located in the 2nd memory location (offset 1 from the node itself)
;;      * The node's right child address is located in the 3rd memory location (offset 2 from the node itself)

;;  PREORDER_TRAVERSAL(Node root (addr), int[] arr (addr), int index) {
;;      if (root == 0) {
;;          return index;
;;      }
;;
;;      arr[index] = root.data;
;;      index++;
;;
;;      index = PREORDER_TRAVERSAL(root.left, arr, index);
;;      return PREORDER_TRAVERSAL(root.right, arr, index);
;;  }


PREORDER_TRAVERSAL ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the PREORDER_TRAVERSAL subroutine here!
    ADD   R6, R6, -1    ;;Make space for return value
    ADD   R6, R6, -1    ;;Push the return address
    STR   R7, R6, 0
    ADD   R6, R6, -1    ;;Save old frame pointer
    STR   R5, R6, 0
    ADD   R6, R6, -1
    ADD   R5, R6, 0     ;;Sets both stack and frame pointer to the same location
    ADD   R6,R6,-5    ;;Go up 5

    STR   R0, R6, #0    ;;Store old R0
    STR   R1, R6, #1    ;;Store old R1
    STR   R2, R6, #2    ;;Store old R2
    STR   R3, R6, #3    ;;Store old R3
    STR   R4, R6, #4    ;;Store old R4


    ;;Load address of root into R0
    LDR   R0, R5, 4
    ;;Load address of arr into R1
    LDR   R1, R5, 5
    ;;Load index into R2
    LDR   R2, R5, 6

    ;;If statement needed registers:
        ;;index -> R2
        ;;root -> R0
        ;;arr -> R1

    ;;Check what root is
IF1 ADD   R0, R0, 0
    ;;If root is zero, then branch to ENDIF
    BRnp   ENDIF
    ;;Otherwise, branch to teardown
    STR R2, R5, 3
    BR    TEARDOWN
    ;;ENDIF
    ENDIF


    ;;Middle block needed registers:
        ;;arr -> R1
        ;;index -> R2
        ;;root -> R0
        ;;root.data -> R3
        ;;arr[index] -> R4


    ;;First subroutine call needed registers:
        ;;index -> R2
        ;;arr -> R1
        ;;root.left -> R3
        ;;root -> R0

    ;;Make R3 0
    ;;Make R3 the address of root.left (offset 1)
    ;;Push R2 into stack (index)
    ;;Push R1 into stack (address of arr)
    ;;Push R3 into stack (address of root.left)
    ;;Call subroutine
    ;;Load the return value into R2 (index)
    ;;Pop out 4 values

    ;;Second subroutine call needed registers:
        ;;index -> R2
        ;;arr -> R1
        ;;root.right -> R3
        ;;root -> R0
        ;;register for storage




















    ;;Middle block needed registers:
        ;;arr -> R1
        ;;index -> R2
        ;;root -> R0
        ;;root.data -> R3
        ;;arr[index] -> R4

    ;;Make R4 the address of arr[index]
    ADD   R4, R1, R2
    ;;Make R3 the value of root.data
    ADD   R3, R0, 0
    LDR   R3, R3, 0
    ;;arr[index] = root.data
    STR   R3, R4, 0
    ;;R2++ (index++)
    ADD   R2, R2, 1
    
    ;;First subroutine call needed registers:
        ;;index -> R2
        ;;arr -> R1
        ;;root.left -> R3
        ;;root -> R0

    ;;Reset R3
    AND   R3, R3, 0
    ;;Make R3 the address of root.left
    ADD   R3, R0, 1
    LDR   R3, R3, 0
    ;;Push R2 into stack (index)
    ADD   R6, R6, -1
    STR   R2, R6, 0
    ;;Push R1 into stack (address of arr)
    ADD   R6, R6, -1
    STR   R1, R6, 0
    ;;Push R3 into stack (address of root.left)
    ADD   R6, R6, -1
    STR   R3, R6, 0
    ;;Call subroutine
    JSR   PREORDER_TRAVERSAL
    ;;Load return value into R2 (index)
    LDR   R2, R6, 0
    ;;Pop out 4 values
    ADD   R6, R6, 4
    
    ;;Second subroutine call needed registers:
        ;;index -> R2
        ;;arr -> R1
        ;;root.right -> R3
        ;;root -> R0
        ;;register for storage

    ;;Reset R3
    AND   R3, R3, 0
    ;;Make R3 the address of root.right
    ADD   R3, R0, 2
    LDR   R3, R3, 0
    ;;Push R2 into stack (index)
    ADD   R6, R6, -1
    STR   R2, R6, 0
    ;;Push R1 into stack (address of arr)
    ADD   R6, R6, -1
    STR   R1, R6, 0
    ;;Push R3 into stack (address of root.right)
    ADD   R6, R6, -1
    STR   R3, R6, 0
    ;;Call subroutine
    JSR   PREORDER_TRAVERSAL
    ;;Load the return value into R4
    LDR   R4, R6, 0
    ;;Pop out 4 values
    ADD   R6, R6, 4
    ;;Store R4 into the return value address
    STR   R4, R5, 3
    ;;Branch to teardown
    BR    TEARDOWN




TEARDOWN
    ;; Tear down the stack
    LDR     R0, R6, #0      ;; Restore old R0
    LDR     R1, R6, #1      ;; Restore old R1
    LDR     R2, R6, #2      ;; Restore old R2
    LDR     R3, R6, #3      ;; Restore old R3
    LDR     R4, R6, #4      ;; Restore old R4
    ADD     R6, R5, #0      ;; Pop off restored registers and any local variables (LV)
    LDR     R5, R6, #1      ;; Restore old frame pointer (FP)
    LDR     R7, R6, #2      ;; Restore return address (RA)
    ADD     R6, R6, #3      ;; Pop off LV1, old FP, and RA
    RET

; Needed to Simulate Subroutine Call in Complx
STACK .fill xF000
.end

;;  Assuming the tree starts at address x4000, here's how the tree (see below and in the PDF) is represented in memory
;;
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 

.orig x4000 ;; 4    ;; node itself lives here at x4000
    .fill 4         ;; node.data (4)
    .fill x4004     ;; node.left lives at address x4004
    .fill x4008     ;; node.right lives at address x4008
.end

.orig x4004	;; 2    ;; node itself lives here at x4004
    .fill 2         ;; node.data (2)
    .fill x400C     ;; node.left lives at address x400C
    .fill x4010     ;; node.right lives at address x4010
.end

.orig x4008	;; 8    ;; node itself lives here at x4008
    .fill 8         ;; node.data (8)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

.orig x400C	;; 1    ;; node itself lives here at x400C
    .fill 1         ;; node.data (1)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

.orig x4010	;; 3    ;; node itself lives here at x4010
    .fill 3         ;; node.data (3)
    .fill 0         ;; node does not have a left child
    .fill 0         ;; node does not have a right child
.end

;;  Another way of looking at how this all looks like in memory
;;              4
;;            /   \
;;           2     8 
;;         /   \
;;        1     3 
;;  Memory Address           Data
;;  x4000                    4          (data)
;;  x4001                    x4004      (4.left's address)
;;  x4002                    x4008      (4.right's address)
;;  x4003                    Don't Know
;;  x4004                    2          (data)
;;  x4005                    x400C      (2.left's address)
;;  x4006                    x4010      (2.right's address)
;;  x4007                    Don't Know
;;  x4008                    8          (data)
;;  x4009                    0(NULL)
;;  x400A                    0(NULL)
;;  x400B                    Don't Know
;;  x400C                    1          (data)
;;  x400D                    0(NULL)
;;  x400E                    0(NULL)
;;  x400F                    Dont't Know
;;  x4010                    3          (data)
;;  x4011                    0(NULL)
;;  x4012                    0(NULL)
;;  x4013                    Don't Know
;;  
;;  *Note: 0 is equivalent to NULL in assembly

.orig x4020 ;; Result Array : You can change the block size for debugging!
    .blkw 5
.end