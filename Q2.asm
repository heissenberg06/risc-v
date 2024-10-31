.data
prompt: .string "Enter the value of N: "   # data storage for input prompt
result_text: .string "F(N) = "            # data storage for output prefix

.text
.globl main
main:
    la a0, prompt                         # load address of prompt string into a0
    li a7, 4                              # system call number for print string
    ecall                                 # make system call to print prompt
    li a7, 5                              # system call number for read integer
    ecall                                 # make system call to read integer into a0
    mv t0, a0                             # move read value into t0 for further processing
    jal ra, f                             # call function f
    la a0, result_text                    # load address of result prefix into a0
    li a7, 4                              # system call number for print string
    ecall                                 # print result prefix
    mv a0, t0                             # move result from function f into a0
    li a7, 1                              # system call number for print integer
    ecall                                 # print computed result
    li a7, 10                             # system call number for exit
    ecall                                 # exit program

f:
    addi sp, sp, -16                      # allocate 16 bytes on stack for storage
    sw ra, 12(sp)                         # save return address on stack
    sw a0, 8(sp)                          # save current value of a0 on stack
    li t1, 1                              # load immediate value 1 into t1
    ble a0, t1, base_case                 # if a0 <= 1, jump to base_case
    addi a0, a0, -1                       # decrement a0 by 1
    jal ra, f                             # recursive call to function f
    slli t2, a0, 1                        # shift left a0 by 1 (multiply by 2)
    lw t3, 8(sp)                          # load original value of N from stack into t3
    mul t3, t3, t3                        # multiply t3 by itself (N^2)
    add t0, t2, t3                        # add 2N to N^2, result in t0
    mv a0, t0                             # move result into a0
    j end_f                               # jump to end of function f

base_case:
    li a0, 5                              # load immediate 5 into a0 (base case result)
    mv t0, a0                             # move base case result into t0

end_f:
    lw ra, 12(sp)                         # restore return address from stack
    addi sp, sp, 16                       # deallocate stack space
    jr ra                                 # return from function f
