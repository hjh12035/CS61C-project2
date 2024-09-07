.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    
    addi sp, sp, -12
    sw a1, 0(sp)
    sw ra, 4(sp)
    sw a2, 8(sp)
    mv a1, x0
    jal ra, fopen
    li t0, -1
    beq a0, t0, error_fopen
    lw ra, 4(sp)
    lw a1, 0(sp)
    lw a2, 8(sp)
    addi sp, sp, 12

    addi sp, sp, -16
    sw a2, 0(sp)
    sw ra, 4(sp)
    sw a0, 8(sp)
    sw a1, 12(sp)
    li a2, 4
    jal ra, fread
    li a2, 4
    bne a0, a2, error_fread
    lw a1, 12(sp)
    lw ra, 4(sp)
    lw a2, 0(sp)
    lw a0, 8(sp)
    addi sp, sp, 16
    lw s0, 0(a1) # store the number of rows in s0

    addi sp, sp, -16
    sw a2, 0(sp)
    sw ra, 4(sp)
    sw a1, 8(sp)
    sw a0, 12(sp)
    mv a1, a2
    li a2, 4
    jal ra, fread
    li a2, 4
    bne a0, a2, error_fread
    lw ra, 4(sp)
    lw a2, 0(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16
    lw s1, 0(a2) # store the number of columns in s1
    
    mul s2, s0, s1
    addi sp, sp, -8
    sw ra, 0(sp)
    sw a0, 4(sp)
    slli a0, s2, 2
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s0, a0
    lw ra, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8
    
    li s1, 0
loop_start:
    slli t0, s1, 2
    add t0, t0, s0
    addi sp, sp, -16
    sw a2, 0(sp)
    sw ra, 4(sp)
    sw a1, 8(sp)
    sw a0, 12(sp)
    li a2, 4
    mv a1, t0
    jal ra, fread
    li a2, 4
    bne a0, a2, error_fread
    lw ra, 4(sp)
    lw a2, 0(sp)
    lw a1, 8(sp)
    lw a0, 12(sp)
    addi sp, sp, 16
loop_end:
    addi s1, s1, 1
    blt s1, s2, loop_start
    
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, fclose
    bne a0, x0, error_fclose
    lw ra, 0(sp)
    addi sp, sp, 4
    
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12

    jr ra

error_fopen:
    li a0, 27
    j exit
    
error_fread:
    li a0, 29
    j exit
    
error_malloc:
    li a0, 26
    j exit
    
error_fclose:
    li a0, 28
    j exit