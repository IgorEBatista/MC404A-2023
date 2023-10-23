.text
.globl _start
_start:
    jal main  # jump to main and save position to ra

motor:
    #controla o motor do carro
    #a0: comando do motor (-1, 0, 1)
    sb a0, 33(s2) # a posicao 0x21 controla o motor 
    ret

freia:
    #aciona o freio de mão ( o motor deve estar desligado)
    li t1, 1 # t1 = 1
    sb t1, 34(s2) #  a posicao 0x22 controla o freio
    ret

dir:
    #controla a direção das rodas
    #a0: comando da roda (-127 ~ 127)
    sb a0, 32(s2) # a posicao 0x20 controla a direcao da roda 
    ret

get_coord:
    #Coleta as coordenadas do gps e salva numa estrutura
    #a0: endereço da estrutura

    li t1, 1 # t1 = 1
    sb t1, 0(s2) # aciona o gps
    1:
        nop
        lb t1, 0(a0) # 
        bne t1, zero, 1b # if t1 != zero then 1b

    lw t1, 16(s2) # carrega a coord x
    ##TODO atualiza a dir x
    sw t1, 0(a0) # salva a coord x
    
    lw t1, 16(s2) # carrega a coord z
    ##TODO atualiza a dir z
    sw t1, 0(a0) # salva a coord z
    ret

calc_dist:
    #Calcula a distância de separação com o centro do objetivo
    #a0: endereço da estrutura --> distância de separação

calc_dir:
    #Determina se o carro deve virar a esquerda ou a direita
    #a0: endereço da estrutura -> direção da roda

root:
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
    # A padronização acima foi feita para diminuir o numero de acessos a memória, 
    # visando maior otimização de processamento do sistema embarcado

    mv  a0, s1 # a0 = s1
    jal get_coord  # jump to get_coord and save position to ra
    
    li a0, 1 # a0 = 1
    jal motor  # jump to motor and save position to ra

    mv  a0, s1 # a0 = s1
    jal get_coord  # jump to get_coord and save position to ra

#Conducao
    1:
        mv  a0, s1 # a0 = s1
        jal calc_dir  # jump to calc_dir and save position to ra
        jal dir  # jump to dir and save position to ra
    
        mv  a0, s1 # a0 = s1
        jal calc_dist  # jump to calc_dist and save position to ra
        li t1, 15 # t1 = 15
        sub a0, a0, t1 # a0 = a0 - t1
        blt a0, zero, 1f # if a0 < zero then 1f
        sub a0, a0, t1 # a0 = a0 - t1
        bgt a0, zero, 1b # if a0 > zero then 1b
        li a0, 0 # a0 = 0
        jal motor  # jump to motor and save position to ra
        j 1b  # jump to 1b
    1:
#Finalizacao
    
    jal freia  # jump to freia and save position to ra
    j exit

exit:
    li a7, 93           # syscall exit (93) \n
    ecall
    


.data
X_alvo: .word 73
Z_alvo: .word -19
base: .word 0xFFFF0100

.bss
#estrutura:
    # Coord x,z (int,int)
    # Vetor dir x,z (int,int)

estrutura: .skip 16