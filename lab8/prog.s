.globl _start

exit:
    li a0, 0
    li a7, 93               # exit
    ecall

_start:
    jal open                # abre arquivo e coloca em a0

    la a1, input           
    jal read                # le a0 e coloca em input

    addi a1, a1, 3          # pula o P5 inicial

    jal save_xy             # s1 = x, s2 = y

    addi a1, a1, 4          # pula o 255 final
    jal process_image       # processa a imagem

    jal exit                # mete o pé

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret

save_xy:
    li s1, 0
    li s2, 0
    li a6, 10
    li t2, 32
    li t3, 10

    fory:
        lb a4, (a1)                 # a4 = a1[0]
        beq a4, t2, outfory         # se a4 == '  ' sai do for
        beq a4, t3, outfory         # se a4 == '\n' sai do for
        
        addi a4, a4, -48            # a4 = a4 - 48
        mul s2, s2, a6              # s2 = 10 * a6
        add s2, s2, a4              # s2 += a4

        addi a1, a1, 1              # a1 segue
        j fory                      # volta pra fory

    outfory:

    addi a1, a1, 1                  # pula a quebra de linha

    forx:
        lb a4, (a1)                 # a4 = a1[0]
        beq a4, t2, outforx         # se a4 == '  ' sai do for
        beq a4, t3, outforx         # se a4 == '\n' sai do for
        
        addi a4, a4, -48            # a4 = a4 - 48
        mul s1, s1, a6              # s1 = 10 * a6
        add s1, s1, a4              # s1 += a4

        addi a1, a1, 1              # a1 segue
        j forx                      # volta pra forx

    outforx:

    addi a1, a1, 1                  # pula a quebra de linha

    ret

process_image:
    li t1, 0                        # coordenada do primeiro for inicia em 0
    li a5, 256                      # a5 = 2^7
    mv a3, a1                       # coloca o arquivo de leitura em a3

    mv a0, s2                       
    mv a1, s1
    li a7, 2201                     # setta o canvas para uma imagem s2 x s1
    ecall
    
    for1:
        li t2, 0

        for2:
            lbu a4, (a3)

            mv a0, t2               # coordenada x
            mv a1, t1               # coordenada y
            
            li a2, 0
            add a2, a2, a4
            mul a2, a2, a5

            add a2, a2, a4
            mul a2, a2, a5

            add a2, a2, a4
            mul a2, a2, a5
            
            addi a2, a2, 255        # setta o a2 para a cor em hexadecimal
            
            li a7, 2200             # syscall setPixel (2200)
            ecall

            addi t2, t2, 1
            addi a3, a3, 1
            bge t2, s2, outfor2
            j for2

        outfor2:
    
        addi t1, t1, 1
        bge t1, s1, outfor1 
        j for1

    outfor1:

read:
    li a7, 63                   # syscall read (63)
    li a2, 270000
    ecall
    ret

input_file: .asciz "image.pgm"
.bss

input: .skip 0x270000