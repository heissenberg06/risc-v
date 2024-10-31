.data
prompt:  .asciz "Enter an odd integer for the height of the diamond: " # prompt for user input
error:   .asciz "Invalid input. Please enter an odd integer.\n"        # error message for invalid input
newline:  .asciz "\n"                                                 # newline character for formatting
star:     .asciz "*"                                                  # symbol for the stars in the diamond
space:    .asciz " "                                                  # space character for formatting

.text
.globl main

main:

input_loop:
    la a0, prompt                     # load the address of the input prompt into a0
    li a7, 4                          # system call number for printing strings
    ecall                             # execute the print string system call
    li a7, 5                          # system call number for reading integers
    ecall                             # execute the read integer system call
    mv t0, a0                         # move the read integer into register t0
    li t1, 2                          # load the immediate value 2 into t1
    div t2, t0, t1                    # divide t0 by 2 to check if it's even
    mul t2, t2, t1                    # multiply the quotient by 2 to get the nearest even number
    sub t2, t0, t2                    # subtract to find the remainder
    beq t2, zero, print_error         # if remainder is zero, it's an even number, jump to error message
    j print_diamond                   # if valid, proceed to print the diamond

print_error:
    la a0, error                      # load the address of the error message into a0
    li a7, 4                          # system call for printing strings
    ecall                             # execute the print string system call
    j input_loop                      # jump back to input loop after printing the error

print_diamond:
    li t1, 2                          # immediate value 2 for division
    div t2, t0, t1                    # t0 / 2 to calculate middle index of the diamond
    li t3, 0                          # counter initialized to 0
    mv t4, t2                         # move half-height value to t4

outer_loop_upper:
    bgt t3, t4, end_upper_half        # if t3 > t4, end the upper half
    mv t5, t4                         # move t4 to t5
    sub t5, t5, t3                    # calculate spaces: half-height - current line
    call print_spaces                 # call the function to print leading spaces
    slli t6, t3, 1                    # double the line number and shift left
    addi t6, t6, 1                    # add 1 for the central star
    call print_hollow                 # call function to print hollow spaces and star
    la a0, newline                    # load newline character address
    li a7, 4                          # system call for printing strings
    ecall                             # print newline
    addi t3, t3, 1                    # increment line counter
    j outer_loop_upper                # jump back to start of loop for next line

end_upper_half:
    j print_lower_half                # jump to print the lower half of the diamond

print_spaces:
    beqz t5, end_spaces               # if no spaces left, return from function

space_loop:
    la a0, space                      # load address of space character
    li a7, 4                          # system call for printing strings
    ecall                             # print a space
    addi t5, t5, -1                   # decrement space count
    bnez t5, space_loop               # if not zero, print another space
end_spaces:
    ret                               # return from print_spaces function

print_hollow:
    la a0, star                       # load address of star character
    li a7, 4                          # system call for printing strings
    ecall                             # print star
    li t1, 1                          # immediate value 1 for comparison
    beq t6, t1, end_hollow            # if only one star needed, skip the inner loop
    addi t6, t6, -2                   # adjust count for spaces inside diamond

space_hollow_loop:
    la a0, space                      # load address of space character
    li a7, 4                          # system call for printing strings
    ecall                             # print space
    addi t6, t6, -1                   # decrement counter for spaces
    bnez t6, space_hollow_loop        # if not zero, continue loop
    la a0, star                       # load address of star character
    li a7, 4                          # system call for printing strings
    ecall                             # print final star of the row

end_hollow:
    ret                               # return from print_hollow function

print_lower_half:
    addi t3, t4, -1                   # set counter for lower half

lower_loop:
    blt t3, zero, end_program         # if counter < 0, end the program
    mv t5, t4                         # reset spaces counter
    sub t5, t5, t3                    # calculate spaces for current line
    call print_spaces                 # call function to print spaces
    slli t6, t3, 1                    # calculate number of stars and spaces
    addi t6, t6, 1                    # adjust for central star
    call print_hollow                 # call function to print hollow part
    la a0, newline                    # load newline character address
    li a7, 4                          # system call for printing strings
    ecall                             # print newline
    addi t3, t3, -1                   # decrement line counter
    j lower_loop                      # repeat loop for next line

end_program:
    li a7, 10                         # system call number for exit
    ecall                             # exit the program
