.globl _start

.text
exit:
    li a0, 0
    li a7, 93               # exit
    ecall

_start:
    jal read                        # le input
    la s0, input_address            # salva input em s0

    jal save_number                 # recebe s0 e retorna o numero em a0
    mv s2, a0                       # s2 recebe a0

    la s1, head_node                # s1 recebe o inicio da lista ligada
    li t1, 0                        # t1 recebe 0  (contador)
    li t2, -1                       # t2 recebe -1 (resposta)

    for:                            # checa todos os nodes
        lw a1, (s1)                 # primeiro numero
        addi s1, s1, 4
        lw a2, (s1)                 # segundo numero
        addi s1, s1, 4
        lw a3, (s1)                 # terceiro numero
        addi s1, s1, 4
        lw s1, (s1)                 # proximo node

        add a4, a1, a2              # a4 = a1 + a2 + a3
        add a4, a4, a3

        bne a4, s2, continua        # se a4 for diferente de s2, continua
        mv t2, t1                   # t2 recebe o contador
        j outfor

        continua:

        beq s1, zero, outfor        # se não há proximo node, sai do for
        addi t1, t1, 1              # soma 1 no contador
        j for

    outfor:

    mv a0, t2                       # a0 recebe a resposta
    la a1, output                   # a1 recebe o endereço do output
    jal save_string                 # salva a0 no output

    jal write                       # imprime output

    jal exit                        # mete o pé

save_number:                    # recebe s0 e retorna o numero em a0

    add t0, s0, zero            # t0 recebe endereço de s0[zero]
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

save_string:                        # a0 tem o numero a ser salvo, a1 tem o endereço do output
    
    add t0, a1, zero                # t0 = a1[0]
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
        li a6, 10                   # a6 = 10

        for3:                       # conta a quantidade de caracteres
            addi t2, t2, 1          # t2++
            div t4, t4, a6          # t4 remove um caractere

            beq t4, zero, outfor3   # se t4 = 0, sai do for
            j for3
        outfor3:

        add t2, t2, t1              # t2 += t1, soma 1 se já apareceu o -
        add t0, a1, t2              # t0 = a1[t2]

        addi t0, t0, 2              # t0 += 1
        sb a6, (t0)                 # termina com \n
        addi t0, t0, -2             # t0 -= 1

        for2:
            rem a4, a0, a6              # a4 = (a0 % 10)
            addi a4, a4, 48             # a4 = a4 + '0'
            sb a4, (t0)                 # t0[0] = a4
            div a0, a0, a6              # a0 /= 10

            bge t1, t2, outfor2         # se t1 >= t2 sai do for
            addi t0, t0, -1             # t0 volta uma posição
            addi t2, t2, -1             # soma -1 no iterador
            j for2                      # volta pra for2

        outfor2:
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
    la a1, output               # buffer
    li a2, 20                   # size - Reads 20 bytes.
    li a7, 64                   # syscall write (64)
    ecall
    ret

.bss

input_address: .skip 0x20
output: .skip 0x20