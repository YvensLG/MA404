.globl _start

.text
exit:
    li a0, 0
    li a7, 93               # exit
    ecall

_start:
    jal read                    # le input
    la s0, input_address        # salva input em s1
    
    
    
    la s1, head_node

    li t1, 0
    li t2, -1

    li s2, 4                    # coloca input aqui

    for:
        lw a1, (s1)
        addi s1, s1, 4
        lw a2, (s1)
        addi s1, s1, 4
        lw a3, (s1)
        addi s1, s1, 4
        lw s1, (s1)

        add a4, a1, a2
        add a4, a4, a3

        bne a4, s2, continua
        mv t2, t1
        j outfor

        continua:

        beq s1, zero, outfor
        addi t1, t1, 1
        j for

    outfor:

    # printa t2

    jal exit                # mete o pé


read:
    li a0, 0                    # file descriptor = 0 (stdin)
    la a1, input_address        # buffer
    li a2, 20                   # size - Reads 20 bytes.
    li a7, 63                   # syscall read (63)
    ecall
    ret

write:
    li a0, 1                    # file descriptor = 1 (stdout)
    la a1, input_address        # buffer
    li a2, 20                   # size - Writes 20 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

.bss

input_address: .skip 0x25  # buffer