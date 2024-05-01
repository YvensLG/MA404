.globl _start

exit:
    li a0, 0
    li a7, 93 # exit
    ecall

_start:
    jal read                    # le input
    la s1, input_address        # salva input em s1

    li a0, 0                    # salva posição 0 em a0
    li t6, 20                   # a0 para em 20

    for0:
        jal save_number             # salva a0-ésimo número do input em s2
        jal sqrt                    # calcula a raiz de s2 e salva em s3
        jal save_string             # salva s3 na string do input

        bge a0, t6, outfor0         # se a0 >= 20 sai do for
        addi a0, a0, 5              # soma 5 em a0
        j for0                      # volta pra for0

    outfor0:

    jal write                   # imprime
    jal exit                    # mete o pé

save_number:                    # salva em s2 os 4 bits a partir da posicao a0 no input(s1)

    add t0, s1, a0              # t0 recebe endereço de s1[a0]

    li s2, 0                    # s2 recebe 0
    li a6, 10                   # a6 recebe 10

    li t1, 0                    # t1 é o iterador
    li t2, 3                    # t2 é o maximo

    for1:

        mul s2, s2, a6              # s2 *= 10
        lb a4, 0(t0)                # a4 = t0[0]
        addi a5, a4, -48            # a5 = a4 - '0'
        add s2, s2, a5              # s2 += a5

        bge t1, t2, outfor1         # se t1 >= t2 sai do for
        addi t0, t0, 1              # t0 anda 1 vez 
        addi t1, t1, 1              # soma 1 no iterador
        j for1                      # volta pra for1

    outfor1:
    ret

sqrt:                           # calcula a raiz quadrada de s2

    li t0, 2                    # t0 = 2
    mv a3, s2                   # a3 = s2
    div a3, a3, t0              # a3 /= 2

    li t1, 0                    # t1 é o iterador
    li t2, 10                   # t2 é o maximo

    for2:
        div t3, s2, a3              # t3 = s2 / a3
        add a3, a3, t3              # a3 = a3 + t3
        div a3, a3, t0              # a3 = a3 / 2

        bge   t1, t2, outfor2       # se t1 >= t2 sai do for
        addi  t1, t1, 1             # soma 1 no iterador
        j for2                      # volta pra for1

    outfor2:

    mv s3, a3

    ret

save_string:                    # salva em s1[a0] os 4 dígitos do número em s3

    add t0, s1, a0              # t0 recebe o endereço de s1[a0]
    addi t0, t0, 3              # t0 recebe o endereço de s1[a0 + 3]
    li a6, 10

    li t1, 0                    # t1 é o iterador
    li t2, 3                    # t2 é o maximo

    for3:

        rem a4, s3, a6              # a4 = (s3 % 10)
        addi a4, a4, 48             # a4 = a4 + '0'
        sb a4, 0(t0)                # t0[0] = a4
        div s3, s3, a6              # s3 /= 10

        bge t1, t2, outfor3         # se t1 >= t2 sai do for
        addi t0, t0, -1             # t0 volta uma posição
        addi t1, t1, 1              # soma 1 no iterador
        j for3                      # volta pra for3

    outfor3:
    ret


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

input_address: .skip 0x20  # buffer

# result: .skip 0x20