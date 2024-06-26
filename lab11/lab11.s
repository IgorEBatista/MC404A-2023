.text
.globl _start
_start:
    jal main  # jump to main and save position to ra

motor:
    #controla o motor do carro
    #a0: comando do motor (-1, 0, 1)
    #a1: endereço base da memoria de acesso ao carro
    
    sb a0, 33(a1) # a posicao 0x21 controla o motor 
    ret

freia:
    #aciona o freio de mão ( o motor deve estar desligado)
    #a1: endereço base da memoria de acesso ao carro
    li t1, 1 # t1 = 1
    sb t1, 34(a1) #  a posicao 0x22 controla o freio
    ret

dir:
    #controla a direção das rodas
    #a0: comando da roda (-127 ~ 127)
    #a1: endereço base da memoria de acesso ao carro
    sb a0, 32(a1) # a posicao 0x20 controla a direcao da roda 
    ret

get_coord:
    #Coleta as coordenadas do gps e salva numa estrutura
    #a0: endereço da estrutura
    #a1: endereço base da memoria de acesso ao carro
    #t1: carregamento de valores
    #t2: att dir

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    li t1, 1 # t1 = 1
    sb t1, 0(a1) # aciona o gps
    1:
        nop
        lb t1, 0(a1) # 
        bne t1, zero, 1b # if t1 != zero then 1b

    lw t1, 16(a1) # carrega a nova coord x

    lw t2, 0(a0) # carrega a coord anterior x
    sub t2, t1, t2 # t2 = t1 - t2 calcula a dir
    sw t2, 8(a0) # salva a dir
    sw t1, 0(a0) # salva a nova coord x
    
    lw t1, 24(a1) # carrega a nova coord z
    lw t2, 4(a0) # carrega a coord anterior z
    sub t2, t1, t2 # t2 = t1 - t2 calcula a dir
    sw t2, 12(a0) # salva a dir
    sw t1, 4(a0) # salva a nova coord z

    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret

calc_dist:
    #Calcula a distância de separação com o centro do objetivo
    #a0: endereço da estrutura --> distância de separação
    #a1: endereço das coords do alvo

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)
    
    lw t0, 0(a0) # carrega coord x atual
    lw t1, 0(a1) # carrega coord x alvo
    lw t2, 4(a0) # carrega coord z atual
    lw t3, 4(a1) # carrega coord z alvo

    sub t0, t1, t0 # t0 = t1 - t0 -- calcula dx
    sub t1, t3, t2 # t1 = t3 - t2 -- calcula dz

    mul t0, t0, t0 # dx²
    mul t1, t1, t1 # dz²

    add t0, t0, t1 # t0 = t0 + t1 -- dx² + dz²
    mv  a0, t0 # a0 = t0
    
    jal root  # jump to root and save position to ra
    
    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret
    

calc_dir:
    #Determina se o carro deve virar a esquerda ou a direita
    #a0: endereço da estrutura -> direção da roda
    #a1: endereço das coords alvo

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    lw t0, 8(a0) # carrega o x da direcao
    lw t1, 0(a1) # carrega o x alvo
    lw t4, 0(a0) # carrega o x atual 

    lw t2, 12(a0) # carrega o z da direcao
    lw t3, 4(a1) # carrega o z alvo
    lw t5, 4(a0) # carrega o z atual 
    
    #Acha a direção atual do alvo
    sub t1, t1, t4 # t1 = t1 - t4
    sub t3, t3, t5 # t3 = t3 - t5

    #faz o produto vetorial
    mul t0, t0, t3 #
    mul t1, t1, t2 #
    
    sub t0, t1, t0 # t0 = t0 - t1

    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    
    bgt t0, zero, 1f # if t0 > zero then 1f
    li a0, -30 # a0 = -127
    ret

    1:
    li a0, 30 # a0 = 127 #curva para direita
    ret

root:
    # Determinba a raiz de um número com 11 iterações
    #a0: num -> raiz do num

    mv  a1, a0 # a1 = a0
    srli a0, a1, 1  #divide por 2 e salva em a0 (estima k inicial)
    li t0, 11 # t0 = 11 marcador de repetições
    
    1:  #inicio do loop
        div t1, a1, a0 #divide y por k atual
        add a0, a0, t1 # a0 = a0 + t1
        srli a0, a0, 1 #divide por 2 e salva em a0 (novo k)
        addi t0, t0, -1 # t0 = t0  -1  fim do loop
    bnez t0, 1b # if t0 != 0  then  1b:
    ret

main:
#Inicializacao
    la s1, estrutura #  s1 será o endereço da estrutura
    LW s2, base # s2 será o endereço base do acesso à memória
    la s3, alvo # s3 será o endereço do alvo
    li s4, 1000 # s4 = 5000 -- contador de ciclos pós alvo
    # A padronização acima foi feita para diminuir o numero de acessos a memória, 
    # visando maior otimização de processamento do sistema embarcado

    mv  a0, s1 # a0 = s1
    mv  a1, s2 # a1 = s2
    jal get_coord  # jump to get_coord and save position to ra
    
    li a0, 1 # a0 = 1
    mv  a1, s2 # a1 = s2
    jal motor  # jump to motor and save position to ra
    
    li a7, 5000 # a7 = 5000
    1:
        nop
        addi a7, a7, -1 # a7 = a7 + -1
        bne a7, zero, 1b # if a7 != zero then 1b

    mv  a0, s1 # a0 = s1
    mv  a1, s2 # a1 = s2
    jal get_coord  # jump to get_coord and save position to ra

#Conducao
    1:
        mv  a0, s1 # a0 = s1
        mv  a1, s3 # a1 = s3
        jal calc_dir  # jump to calc_dir and save position to ra
        mv  a1, s2 # a1 = s2
        jal dir  # jump to dir and save position to ra

        
        li a7, 1000 # a7 = 1000
        2:
            nop
            addi a7, a7, -1 # a7 = a7 + -1
            bne a7, zero, 2b # if a7 != zero then 2b
        2:

        mv  a0, s1 # a0 = s1
        mv  a1, s2 # a1 = s2
        jal get_coord  # jump to get_coord and save position to ra

        mv  a0, s1 # a0 = s1
        mv  a1, s3 # a1 = s3
        jal calc_dist  # jump to calc_dist and save position to ra
        
        li t1, 20 # t1 = 30
        sub a0, a0, t1 # a0 = a0 - t1
        bgt a0, zero, 3f # if a0 < zero then 3f
        mv  a1, s2 # a1 = s2
        jal freia  # jump to freia and save position to ra
        addi s4, s4, -1 # s4 = s4 - 1
        blt s4, zero, 1f # if s4 < zero then 1f        
        
        3:
        li t1, 60 # t1 = 30
        sub a0, a0, t1 # a0 = a0 - t1
        bgt a0, zero, 1b # if a0 > zero then 1b
        li a0, 0 # a0 = 0
        mv  a1, s2 # a1 = s2
        jal motor  # jump to motor and save position to ra

        j 1b  # jump to 1b
        
    1:
#Finalizacao
    li a0, 0 # a0 = 0
    j exit

exit:
    li a7, 93           # syscall exit (93) \n
    ecall


.data
alvo: .word 73, -14
base: .word 0xFFFF0100

#estrutura:
    # Coord x,z (int,int)
    # Vetor dir x,z (int,int)

estrutura: .word 0,0,0,0