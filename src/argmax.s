.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp) 
    sw s1, 4(sp)
    bge x0, a1, error
    li t0, 0 # set the counter to 0
    
loop_start:
    slli t1, t0, 2 # calculate the offset
    add t2, a0, t1
    lw t3, 0(t2)
    beq t0, x0, set 
    bge s0, t3, loop_continue
set:    
    mv s0, t3
    mv s1, t0
    
loop_continue:
    addi t0, t0, 1 # increment the counter
    beq t0, a1, loop_end
    j loop_start

loop_end:
    mv a0, s1
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    jr ra

error:
    li a0 36
    j exit
    
    
