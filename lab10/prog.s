.data
teste: .string "sagagasagaueueueueusdvsdrgaw"

.globl _start

.text
_start:

    j exit

puts:
    mv a1, a0                   # a1 <- vetor        
    li a2, 1                    # a2 é a qtdd de caracteres de a1

    for:
        lbu a4, (a1)            # a4 <- a1[0]
        beq a4, zero, outfor    # se a4 == NULL, acaba

        addi a2, a2, 1
        addi a1, a1, 1
        j for
    outfor:

    li a4, '\n'
    sb a4, (a1)                 # a1[fim] <- '\n'

    mv a1, a0
    li a0, 1                    # file descriptor = 1 (stdout)
    li a7, 64                   # syscall write (64)
    ecall

    sb zero, (a1)               # a1[fim] <- NULL

    ret

gets:
    mv a1, a0
    li a0, 0                    # file descriptor = 0 (stdin)
    li a2, 1000000              # size - Reads 20 bytes.
    li a7, 63                   # syscall read (63)
    ecall
    ret

atoi:                           
    mv t0, a0                   # t0 <- a0
    li a1, 1                    # a1 recebe o sinal do numero
    
    lb a4, (t0)                 # a4 = t0[0]
    li t3, 45
    beq a4, t3, sign            # se a4 = '-'
    j outsign

    sign:
        addi t0, t0, 1          # avança 1 na string
        li a1, -1               # sinal fica negativo

    outsign:

    li a0, 0                    # a0 recebe 0
    li a6, 10                   # a6 recebe 10

    for1:
        lb a4, (t0)                 # a4 = t0[0]
        beq a4, a6, outfor1         # se a4 = \n sai do for

        mul a0, a0, a6              # a0 *= 10
        addi a5, a4, -48            # a5 = a4 - '0'
        add a0, a0, a5              # a0 += a5

        addi t0, t0, 1              # t0 += 1
        j for1                      # volta pra for1

    outfor1:

    mul a0, a0, a1                  # a0 = a1 * a0

    ret

itoa:                               # valor, string, base

    mv t0, a1                       # t0 <- a1
    li t1, 0                        # t1 recebe 0, a posicao inicial do vetor

    bge a0, zero, cont              # se a0 >= 0, vai direto pra cont

    li t3, 45                       # t3 recebe '-' 
    sb t3, (t0)                     # a1[0] = '-'
    li t3, -1                       # t3 = -1
    li t1, 1                        # t1 recebe 1, a posicao inicial do vetor
    mul a0, a0, t3                  # a0 = |a0|

    cont:
    mv t4, a0                   # t4 recebe o numero a0     
    li t2, -1                   # t2 é a posicao do ultimo caractere de a0

    for3:                       # conta a quantidade de caracteres
        addi t2, t2, 1          # t2++
        div t4, t4, a2          # t4 remove um caractere

        beq t4, zero, outfor3   # se t4 = 0, sai do for
        j for3
    outfor3:

    add t2, t2, t1              # t2 += t1, soma 1 se já apareceu o -
    add t0, a1, t2              # t0 = a1[t2]

    addi t0, t0, 2              # t0 += 1
    li a6, '\n'
    sb a6, (t0)                 # termina com \n
    addi t0, t0, -2             # t0 -= 1

    for2:
        rem a4, a0, a2              # a4 = (a0 % base)
        addi a4, a4, 48             # a4 = a4 + '0'
        sb a4, (t0)                 # t0[0] = a4
        div a0, a0, a2              # a0 /= base

        bge t1, t2, outfor2         # se t1 >= t2 sai do for
        addi t0, t0, -1             # t0 volta uma posição
        addi t2, t2, -1             # soma -1 no iterador
        j for2                      # volta pra for2

    outfor2:

    mv a0, a1
    ret

exit:
    li a0, 0
    li a7, 93               # exit
    ecall

recursive_tree_search:              # Node, value
    li a2


.bss
input_address: .skip 0x20