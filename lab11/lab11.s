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
    lw t2, 12(a0) # carrega o z da direcao
    lw t3, 4(a1) # carrega o z alvo

    #faz o produto vetorial
    mul t0, t0, t3 #
    mul t1, t1, t2 #
    
    sub t0, t0, t1 # t0 = t0 - t1

    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    
    bgt t0, zero, 1f # if t0 > zero then 1f
    li a0, -127 # a0 = -127
    ret

    1:
    li a0, 127 # a0 = 127 #curva para direita
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
    # A padronização acima foi feita para diminuir o numero de acessos a memória, 
    # visando maior otimização de processamento do sistema embarcado

    mv  a0, s1 # a0 = s1
    mv  a1, s2 # a1 = s2
    jal get_coord  # jump to get_coord and save position to ra
    
    li a0, 1 # a0 = 1
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
        jal dir  # jump to dir and save position to ra

        mv  a0, s1 # a0 = s1
        mv  a1, s2 # a1 = s2
        jal get_coord  # jump to get_coord and save position to ra
        
        li a7, 5000 # a7 = 5000
        1:
            nop
            addi a7, a7, -1 # a7 = a7 + -1
            bne a7, zero, 1b # if a7 != zero then 1b


        j 1b  # jump to 1b


        mv  a0, s1 # a0 = s1
        mv  a1, s3 # a1 = s3
        jal calc_dist  # jump to calc_dist and save position to ra
        
        
        li t1, 15 # t1 = 15
        sub a0, a0, t1 # a0 = a0 - t1
        blt a0, zero, 1f # if a0 < zero then 1f
        sub a0, a0, t1 # a0 = a0 - t1
        bgt a0, zero, 1b # if a0 > zero then 1b
        li a0, 0 # a0 = 0
        jal motor  # jump to motor and save position to ra
    1:
#Finalizacao
    
    jal freia  # jump to freia and save position to ra
    j exit

exit:
    li a7, 93           # syscall exit (93) \n
    ecall
    
itoa:
    #a0: inteiro a ser convertido --> endereço da string de saida
    #a1: endereço da string de saida
    #a2: base numerica para conversão
    #t0: valor da vez / constante comparacao / sinal
    #t1: contador de repetição
    #t2: marcador de sinal
    #t3: 10

    li a2, 10 # a2 = 10
    
    #Salva o endereço da string
    mv  a3, a1 # a3 = a1
    
    #verifica se a base é 10, caso for o sinal é relevante
    li t3, 10 # t3 = 10
    bne a2, t3, 1f # if a2 != t3 then 1f
    
    li t2, 0 # t2 = 0
    bge a0, zero, 1f # if a0 >= zero then 1f
    
    li t0, '-' # t0 = '-'
    sb t0, 0(a1) # adiciona o - ao começo da string
    addi a1, a1, 1 # a1 = a1 + 1
    li t2, 1 # t2 = 1
    sub a0, zero, a0 # a0 = zero - a0 -- inverte o sinal de a0    

    1:
    li t1, 0 # t1 = 0 -- zera o contador    
    li t0, '\n' # t0 = '\n'
    addi sp, sp, -1
    sb t0, 0(sp) # adiciona o \n ao inicio da pilha
    
    #coloca na pilha os bytes a serem impressos
    1: #inicio do loop
        rem t0, a0, a2 # acha o resto da divisão

        bge t0, t3, 2f # if t0 >= t3 then 2f
        addi t0, t0, 48 # t0 = t0 + 48 -- transforma em caractere
        j 3f
        2:
        sub t0, t0, t3 # t0 = t0 - t3
        addi t0, t0, 'A' # t0 = t0 + 'A' -- transoforma em caractere hexa
        3:
        addi sp, sp, -1
        sb t0, 0(sp) # adiciona o caractere na pilha
        addi t1, t1, 1 # t1 = t1 + 1 atualiza contador de caracteres

        div a0, a0, a2 #divide pela base
        bne a0, zero, 1b # if a0 != zero then 1b
    1: #fim do loop

    mv  a0, t1 # a0 = t1
    addi a0, a0, 1 # soma 1 para contar o /n
    add a0, a0, t2 # a0 = a0 + t2 -- para contar a adição ou não do sinal de menos

    
    #remove da pilha e coloca na string

    1: #inicio do loop
        lb t0, 0(sp) # remove o caractere da pilha 
        addi sp, sp, 1
        sb t0, 0(a1) # salva o byte na string
        addi a1, a1, 1 # a1 = a1 + 1 -- avança para o próx endereço
        addi t1, t1, -1 # t1 = t1 + 1 atualiza contador de caracteres

        bne t1, zero, 1b # if t1 != zero then 1b
    1: #fim do loop

    lb t0, 0(sp) # remove o \n da pilha 
    addi sp, sp, 1
    sb t0, 0(a1) # salva o byte na string
    mv  a0, a3 # a0 = a3
    ret

puts:
    #a0 : endereço da string a ser impressa
    #t0 : endereço atual --> contador
    #t1: byte da vez
    #t2: '\n'

    mv  t0, a0 # t0 = a0  -- inicia o endereço no inicio da string
    li t2, '\n' # t2 = '\n'
    1:
        lb t1, 0(t0) # carrega o byte da vez 
        beq t1, zero, 1f # if t0 == zero then 1f
        beq t1, t2, 1f # if t0 == t2 then 1f
        addi t0, t0, 1 # t0 = t0 + 1 -- atualiza o contador
        j 1b
    1:
    li t1, '\n' # t1 = '\n'
    sb t1, 0(t0) # 
    addi t0, t0, 1 # t0 = t0 + 1 -- atualiza o contador
    mv  a1, a0 # a1 = a0
    sub a2, t0, a0 # a2 = t0 - a0
    
    j write

    write:
        # a0: file descriptor
        # a1 endereço da string de saida
        # a2 numero de bits a serem escritos
        li a0, 1            # file descriptor = 1 (stdout)
        # la a1, saida       # buffer
        # li a2, 20           # size
        li a7, 64           # syscall write (64)
        ecall
        addi t0, t0, -1 # t0 = t0 + -1 -- desfaz o /n
        li t1, 0 # t1 = 0
        sb t1, 0(t0) #    
        ret


.data
alvo: .word 73, -19
base: .word 0xFFFF0100
string: .string "XXXXXXXXXXXXXX"

#estrutura:
    # Coord x,z (int,int)
    # Vetor dir x,z (int,int)

estrutura: .word 0,0,0,0