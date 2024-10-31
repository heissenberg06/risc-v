.data
array:
.space 1000                  # reserve 1000 bytes for the array storage

.data
.asciz
    init_msg: "please specify the size of the array:"  # prompt message for array size
    before_sort_msg: "original array: "               # message before displaying unsorted array
    after_sort_msg: "sorted array: "                  # message before displaying sorted array
    spacer: " "                                       # space character for output formatting
    newline: "\n"                                     # newline character for line breaks
.text

start: 
  la a0, init_msg            # load address of the initialization message into a0
  li a7, 4                   # set system call for print string
  ecall                      # execute the system call to print the init message

  li a7, 5                   # set system call for reading integer
  ecall                      # read integer (size of the array) from user input
  mv a2, a0                  # move read value (size of the array) into a2

setupVars:
  addi t0, a2, -1            # calculate array size - 1 and store it in t0
  li t1, 0                   # initialize t1 (outer loop index for sorting) to 0
  li t2, 0                   # initialize t2 (inner loop index for sorting) to 0

  li a3, 0                   # initialize a3 (index for printing arrays) to 0
  mv s4, a3                  # copy a3 to s4, starting index for array population

  la s7, array               # load the base address of the array into s7
  mv a1, s7                  # copy the base address of the array into a1 for sorting
  mv s5, s7                  # copy the base address of the array into s5 for population

  addi sp, sp, -4            # adjust stack pointer to make room for local storage
  sw s7, 0(sp)               # save the base address of the array on the stack

populateArray: 
  beq s4, a2 , displayBeforeSort  # check if the array is fully populated
  li a7, 5                        # system call to read integer
  ecall                           # read next integer from user input
  sw a0, 0(s5)                    # store the integer at the current position in array

  addi s5, s5, 4                  # increment the array position pointer by 4 bytes (int size)
  addi s4, s4, 1                  # increment the population index
  j populateArray                 # jump back to continue populating the array

displayBeforeSort: 
  la a0, before_sort_msg          # load the address of the pre-sort message
  li a7, 4                        # system call for printing strings
  ecall                           # print the pre-sort message

printBeforeSort:
  beq a3, a2, startBubbleSort     # check if all elements are printed
  lw a0, 0(a1)                    # load the next array element into a0
  li a7, 1                        # system call for printing integer
  ecall                           # print the integer

  la a0, spacer                   # load the address of the spacer
  li a7, 4                        # system call for printing strings
  ecall                           # print the spacer

  addi a1, a1, 4                  # increment the array element pointer
  addi a3, a3, 1                  # increment the print index
  j printBeforeSort               # jump back to print the next element

startBubbleSort:
  li t1, 0                        # reset t1 for outer loop of bubble sort

bubbleSortLoop:
  li t2, 0                        # reset t2 for inner loop of bubble sort
  lw s7, 0(sp)                    # load the base address of the array from the stack
  j bubbleInner                   # jump to the inner loop

bubbleInner:
  slli s9, t2, 2                  # calculate the address offset for the current element
  add s7, s7, s9                  # calculate the actual address of the current element
  lw s10, 0(s7)                   # load the current element
  lw s11, 4(s7)                   # load the next element

  bge s10, s11, nextIteration     # if current element >= next element, skip the swap
  mv t3, s10                      # temporarily store the current element
  sw s11, 0(s7)                   # swap the elements
  sw t3, 4(s7)                    # complete the swap
  lw s7, 0(sp)                    # reload the base address of the array
  addi t2, t2, 1                  # increment the inner loop index
  sub t4, t0, t1                  # calculate the remaining elements to check
  beq t2, t4, nextOuter           # if end of inner loop, move to next outer loop
  j bubbleInner                   # otherwise, continue inner loop

nextIteration:
  addi t2, t2, 1                  # increment the inner loop index
  sub t4, t0, t1                  # calculate remaining elements to check
  lw s7, 0(sp)                    # reload the base address of the array
  beq t2, t4, nextOuter           # check if end of inner loop, if so, move to next outer loop
  j bubbleInner                   # otherwise, continue inner loop

nextOuter:
  addi t1, t1, 1                  # increment the outer loop index
  beq t1, t0, postSortMsg         # if end of all iterations, move to post sort message
  j bubbleSortLoop                # otherwise, continue outer loop

postSortMsg: 
  la a0, newline                  # load the address of newline character
  li a7, 4                        # system call for printing strings
  ecall                           # print newline

  la a0, after_sort_msg           # load the address of the post-sort message
  li a7, 4                        # system call for printing strings
  ecall                           # print the post-sort message

  li a3, 0                        # reset the print index
  lw a1, 0(sp)                    # reload the base address of the array from the stack

printAfterSort:
  beq a3, a2, finish              # if all elements are printed, finish the program
  lw a0, 0(a1)                    # load the next array element into a0
  li a7, 1                        # system call for printing integer
  ecall                           # print the integer

  la a0, spacer                   # load the address of the spacer
  li a7, 4                        # system call for printing strings
  ecall                           # print the spacer

  addi a1, a1, 4                  # increment the array element pointer
  addi a3, a3, 1                  # increment the print index
  j printAfterSort                # jump back to print the next element

finish:
