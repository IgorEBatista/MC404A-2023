itoa:
    #a0: inteiro a ser convertido --> endereço da string de saida
    #a1: endereço da string de saida
    #a2: base numerica para conversão
    #t0: valor da vez / constante comparacao / sinal
    #t1: contador de repetição
    #t2: marcador de sinal
    #t3: 10 ou 16
    #t4: 4294967296

    li a0, 748 # a0 = -748
    li a1, 0 # a1 = 0xFfffff000
    li a2, 16 # a2 = 16

    li t4, 0 # t4 = 0

    #Salva o endereço da string
    mv  a3, a1 # a3 = a1
    
    #verifica se é negativo
    li t2, 0 # t2 = 0
    bge a0, zero, normal # if a0 >= zero then normal
    
    #verifica se a base é 10
    li t3, 10 # t3 = 10
    bne a2, t3, 1f # if a2 != t3 then 1f
    
    li t0, '-' # t0 = '-'
    sb t0, 0(a1) # adiciona o - ao começo da string
    addi a1, a1, 1 # a1 = a1 + 1
    li t2, 1 # t2 = 1
    sub a0, zero, a0 # a0 = zero - a0 -- inverte o sinal de a0    
    j normal  # jump to normal
    
    1:  #Verifica se a base é 16
    li t3, 16 # t3 = 16
    bne a2, t3, 2f # if a2 != t3 then 2f
    
    li t1, 0 # t1 = 0 -- zera o contador    
    li t0, '\n' # t0 = '\n'
    addi sp, sp, -1
    sb t0, 0(sp) # adiciona o \n ao inicio da pilha

    li t3, 10 # t3 = 10
    1:
        andi t0, a0, 0b1111
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

        srli a0, a0, 4 #divide por 16        
        bne a0, zero, 1b # if a0 != zero then 1b
    1: #fim do loop
    j continua  # jump to continua
    
    ### Fim do caso especial se base 16 negativa
    
    
    
    normal:
    li t1, 0 # t1 = 0 -- zera o contador    
    li t0, '\n' # t0 = '\n'
    addi sp, sp, -1
    sb t0, 0(sp) # adiciona o \n ao inicio da pilha
    
    li t3, 10 # t3 = 10
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
    1: #fim do loop de caso normal

    continua:
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