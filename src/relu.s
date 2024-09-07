.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    
    bge x0, a1, error
    li t0, 0 # set the counter to 0
loop_start:
    slli t1, t0, 2 # calculate the offset
    add t2, a0, t1
    lw t3, 0(t2)
    bge t3, x0, loop_continue
    li t3, 0
loop_continue:
    sw t3, 0(t2)
    addi t0, t0, 1 # increment the counter
    beq t0, a1, loop_end
    j loop_start
loop_end:
    # Epilogue
    jr ra
    
error:
    li a0 36
    j exit