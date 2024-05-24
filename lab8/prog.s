.globl _start

exit:
    li a0, 0
    li a7, 93 # exit
    ecall

_start:
    jal open
    jal read
    jal write           # imprime a1
    jal exit            # mete o pé

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

read:
    la a1, input_address        # buffer
    li a2, 2000                 # size - Reads 20 bytes.
    li a7, 63                   # syscall read (63)
    ecall
    ret

write:
    li a0, 1                    # file descriptor = 1 (stdout)
    la a1, input_address        # buffer
    li a2, 2000                 # size - Writes 20 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

input_file: .asciz "image.pgm"
.bss
input_address: .skip 0x2000