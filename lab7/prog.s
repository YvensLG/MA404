.globl _start

exit:
    li a0, 0
    li a7, 93 # exit
    ecall

_start:
    la a1, input_1      # lê primeira linha
    li a2, 12           # tamanho da linha
    jal read

    li t1, 1            # inicio do vetor
    li t2, 4            # fim do vetor
    jal save_number
    li t1, 0
    jal sign
    mv s0, a0           # salva Xc em s0

    li t1, 7            # inicio do vetor
    li t2, 10           # fim do vetor
    jal save_number
    li t1, 6
    jal sign
    mv s1, a0           # salva Yb em s1
    
    la a1, input_2      # lê segunda linha
    li a2, 20           # tamanho da linha
    jal read

    li t1, 0            # inicio do vetor
    li t2, 3            # fim do vetor
    jal save_number
    mv s2, a0           # salva TR em s2

    li t1, 5            # inicio do vetor
    li t2, 8            # fim do vetor
    jal save_number
    mv s3, a0           # salva TA em s3

    li t1, 10           # inicio do vetor
    li t2, 13           # fim do vetor
    jal save_number
    mv s4, a0           # salva TB em s4

    li t1, 15           # inicio do vetor
    li t2, 18           # fim do vetor
    jal save_number
    mv s5, a0           # salva TC em s5

    sub s3, s2, s3      # troca TA por dA²
    mul s3, s3, s3
    sub s4, s2, s4      # troca TB por dB²
    mul s4, s4, s4
    sub s5, s2, s5      # troca TC por dC²
    mul s5, s5, s5

    li t1, 9
    li t2, 100
    li t3, 2

    # x = (((da²-dc²)/xc) * 0.09 + xc) / 2

    mv s6, s3           # x = da²
    sub s6, s6, s5      # x = da²-dc²
    mul s6, s6, t1      # x = (da²-dc²) * 9
    div s6, s6, s0      # x = (da²-dc²) * 9 / xc
    div s6, s6, t2      # x = ((da²-dc²)/xc) * 0.09
    add s6, s6, s0      # x = ((da²-dc²)/xc) * 0.09 + xc
    div s6, s6, t3      # x = (((da²-dc²)/xc) * 0.09 + xc) / 2


    # y = (((da²-db²)/yb) * 0.09 + yb) / 2

    mv s7, s3           # x = da²
    sub s7, s7, s4      # x = da²-db²
    mul s7, s7, t1      # x = (da²-db²) * 9
    div s7, s7, s1      # x = (da²-db²) * 9 / yb
    div s7, s7, t2      # x = ((da²-db²)/yb) * 0.09
    add s7, s7, s1      # x = ((da²-db²)/yb) * 0.09 + yb
    div s7, s7, t3      # x = (((da²-db²)/yb) * 0.09 + yb) / 2

    la a1, output       # setta a1 como a resposta

    mv a0, s6           # coloca primeiro numero no output
    li t1, 0
    li t2, 4
    jal save_string
    
    addi t0, a1, 5      # coloca espaço no output
    li t3, 32
    sb t3, (t0)

    mv a0, s7           # coloca segundo numero no output
    li t1, 6
    li t2, 10
    jal save_string

    addi t0, a1, 11     # coloca \n no output
    li t3, 10
    sb t3, (t0)

    jal write           # imprime a1

    jal exit            # mete o pé

save_number:

    add t0, a1, t1              # t0 recebe endereço de a1[t1]

    li a0, 0                    # a0 recebe 0
    li a6, 10                   # a6 recebe 10

    for1:

        mul a0, a0, a6              # a0 *= 10
        lb a4, 0(t0)                # a4 = t0[0]
        addi a5, a4, -48            # a5 = a4 - '0'
        add a0, a0, a5              # a0 += a5

        bge t1, t2, outfor1         # se t1 >= t2 sai do for
        addi t0, t0, 1              # t0 += 1
        addi t1, t1, 1              # t1 += 1
        j for1                      # volta pra for1

    outfor1:
    ret

save_string:
    
    add t0, a1, t1              # t0 = a1[t1]
    li t3, 43                   # t3 = '+'
    sb t3, (t0)                 # a1[t1] = '+'

    bge a0, zero, cont          # se a0 >= 0, vai pra cont

    li t3, 45                   # t3 = '-'
    sb t3, (t0)                 # a1[t1] = '-'
    li t3, -1                   # t3 = -1
    mul a0, a0, t3              # a0 = |a0|

cont:

    addi t1, t1, 1              # t1 += 1 
    add t0, a1, t2              # t0 = a1[t2]
    li a6, 10                   # a6 = 10

    for2:

        rem a4, a0, a6              # a4 = (a0 % 10)
        addi a4, a4, 48             # a4 = a4 + '0'
        sb a4, 0(t0)                # t0[0] = a4
        div a0, a0, a6              # a0 /= 10

        bge t1, t2, outfor2         # se t1 >= t2 sai do for
        addi t0, t0, -1             # t0 volta uma posição
        addi t2, t2, -1             # soma -1 no iterador
        j for2                      # volta pra for2

    outfor2:
    ret

sign:
    add t0, a1, t1
    li t2, 45
    lb a3, (t0)
    beq a3, t2, outsign
    ret

outsign:
    li t2, -1
    mul a0, a0, t2
    ret

read:
    li a0, 0             # file descriptor = 0 (stdin)
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    li a2, 20           # size - Writes 20 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret

.bss

input_1: .skip 0x20
input_2: .skip 0x20 
output: .skip 0x20 