.macro DEBUG_PRINT reg
csrw 0x800, \reg
.endm
	
.text
.global div              # Export the symbol 'div' so we can call it from other files
.type div, @function
div:
    addi sp, sp, -32     # Allocate stack space

    # store any callee-saved register you might overwrite
    sw   ra, 28(sp)      # Function calls would overwrite
    sw   s0, 24(sp)      # If t0-t6 is not enough, can use s0-s11 if I save and restore them
    # ...

    # do your work
    # a0 = N, a1 = D

    beq a1, zero, zero_error # Check for D = 0

    # Find number of bits in N
    mv t0, a0 # t0 = N
    li t1, 0 # t1 = bit_count
    count_bits: 
        srli t0, t0, 1 # right shift N
        addi t1, t1, 1 # increment bit_count
        bnez t0, count_bits

    addi t1, t1, -1 # convert bit_count to highest bit index

    # Div algorithm
    li t2, 0 # t2 = Q
    li t3, 0 # t3 = R
    loop: # t1 = i
        
        blt t1, zero, break # Break if i < 0

        slli t3, t3, 1 # left shift R
        slli t2, t2, 1 # left shift Q

        srl  t4, a0, t1 # right shift N to move bit i to N[0]
        andi t4, t4, 1 # mask out all other bits
        or t3, t3, t4 # set R[0] to N[0]

        blt t3, a1, end # R < D
        sub t3, t3, a1 # R -= D
        ori t2, t2, 1 # Q[0] = 1
        end:

        addi t1, t1, -1 # decremenet i

        j loop # loop

    break:

    mv a0, t2    # write back to a0
    mv a1, t3    # write back to a1
    j finish

    zero_error:
    mv a0, zero
    mv a1, zero

    finish:




    # example of printing inputs a0 and a1
    DEBUG_PRINT a0
    DEBUG_PRINT a1

    # load every register you stored above
    lw   ra, 28(sp)
    lw   s0, 24(sp)
    # ...
    addi sp, sp, 32      # Free up stack space
    ret

