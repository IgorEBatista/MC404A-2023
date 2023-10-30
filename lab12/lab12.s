.text
.globl _start
_start:
    jal main  # jump to main and save position to ra

exit:
    li a7, 93           # syscall exit (93) \n
    ecall


gets: 
    #a0: endereço base MIMO -> endereço da string
    #a1: endereço do buffer
    #t1: byte da vez
    #t2: '\n'
    #t3: endereço da vez
    
    mv  t3, a1 # t3 = a1  
    li t2, 10 # t2 = 10
    
    1:
        li t1, 1 # t1 = 1
        sb t1, 2(a0) # ativa a leitura 
        
        2: #Espera a leitura terminar
            nop
            lb t1, 2(a0) # 
            bne t1, zero, 2b # if t1 != zero then 2b
        2:

        lb t1, 3(a0) # carrega o byte lido 
        sb t1, 0(t3) # salva o byte lido no buffer
        addi t3, t3, 1 # t3 = t3 + 1 avança o endereço
        beq t1, t2, 1f # if t1 == t2 then 1f -- continua até achar o \n

        j 1b  
    1:
    li t1, 0 # t1 = 0
    addi t3, t3, -1 # t3 = t3 + -1
    sb t1, 0(t3) # 
    # sub a0, t3, a1 # a0 = t3 - a1
    # addi a0, a0, -1 # a0 = a0 + -1 -- não contar o /n -> 0 como um byte lido
    mv  a0, a1 # a0 = a1
    
    ret

atoi:
    #a0: endereço do inicio da string -> inteiro retornado
    #a1: base numerica do valor (10)
    #t0: byte da vez
    #t1: const para comparacao
    #t2: sinal
    #t3: endereço da string

    #ignora espaços
    mv  t3, a0 # t3 = a0
    li t1, ' ' # t1 = ' '
    1:
        lb t0, 0(t3) # carrega o primeiro byte 
        bne t0, t1, 1f # if t0 != t1 then 1f
        addi t3, t3, 1 # t3 = t3 + 1
        j 1b
    1:

    li a1, 10 # a1 = 10
    li t2, 1 # t2 = 1
    li a0, 0 # a0 = 0 - zera o valor de retorno
    #Verifica se é negativo
    lb t0, 0(t3) # carrega o primeiro byte 
    li t1, '+' # t1 = '+'
    beq t0, t1, 1f # if t0 == t1 then 1f -- se for + continua
    li t1, '-' # t1 = '-'
    bne t0, t1, 1f # if t0 != t1 then 1f
    li t2, -1 # t2 = -1
    addi t3, t3, 1 # t3 = t3 + 1
    
    1:
        lb t0, 0(t3) # carrega o byte da vez
        addi t3, t3, 1 # t3 = t3 + 1 -- avança para o próximo na string
        li t1, 0 # t1 = 0
        beq t0, t1, 1f # if t0 == t1 then 1f -- Verifica se é o final
        addi t0, t0, -48 # t0 = t0 + -48
        mul a0, a0, a1 # Multiplica o valor anterior pela base
        add a0, a0, t0 # a0 = a0 + t0 -- adiciona o novo digito ao total
        j 1b  # jump to 1b
    1:
    mul a0, a0, t2 # corrige o sinal
    ret

itoa:
    #a0: inteiro a ser convertido --> endereço da string de saida
    #a1: endereço da string de saida
    #a2: base numerica para conversão
    #t0: valor da vez / constante comparacao / sinal
    #t1: contador de repetição
    #t2: marcador de sinal

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

puts: ##ADAPTADA -- byte a byte
    #a0 : endereço da string a ser impressa
    #a1 : endereço base do MIMO
    #t0 : endereço atual --> contador
    #t1: byte da vez
    #t2: '\n' -> 1
    #t3 : numero de bytes a serem impressos

    mv  t0, a0 # t0 = a0  -- inicia o endereço no inicio da string
    li t2, '\n' # t2 = '\n'
    
    ## Encontra o fim da string
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
    sub t3, t0, a0 # t3 = t0 - a0
    
    mv  t0, a0 # t0 = a0
    li t2, 1 # t2 = 1
    1:
        lb t1, 0(t0) # carrega o byte da vez
        sb t1, 1(a1) # salva para impressão
        sb t2, 0(a1) # imprime 
        
        2: #Espera a escrita terminar
            nop
            lb t1, 0(a1) # 
            bne t1, zero, 2b # if t1 != zero then 2b

        addi t0, t0, 1 # t0 = t0 + 1 -- atualiza o endereço
        addi t3, t3, -1 # t3 = t3 + -1 -- atualiza o contador
        bgt t3, zero, 1b # if t3 > zero then 1b
    1:

    addi t0, t0, -1 # t0 = t0 + -1 -- desfaz o /n
    li t1, 0 # t1 = 0
    sb t1, 0(t0) #    
    ret

reverte: 
    #a0: endereço da string a ser invertida -> endereço da string inicial
    #t0: endereço atual
    #t1: byte atual
    #t2: contador de repetição

    mv  t0, a0 # t0 = a0
    mv  t2, zero # t2 = zero

    1:
        lb t1, 0(t0) # carega o byte
        beq t1, zero, 1f # if t1 == zero then 1f -- verifica se a string acabou
        addi sp, sp, -1 # sp = sp + -1 -- abre espaço na pilha
        sb t1, 0(sp) # armazena o byte na pilha
        addi t0, t0, 1 # t0 = t0 + 1 -- avança o endereço
        addi t2, t2, 1 # t2 = t2 + 1 -- avança o contador
        
        j 1b  # jump to 1b
    1:

    mv  t0, a0 # t0 = a0 -- volta o endereço para o início da string

    1:
        lb t1, 0(sp) # carrega o byte da pilha
        sb t1, 0(t0) # salva o byte na string
        addi sp, sp, 1 # sp = sp + 1 -- remove da pilha
        addi t0, t0, 1 # t0 = t0 + 1 -- avança o endereço
        addi t2, t2, -1 # t2 = t2 + -1 -- avança o contador
        bgt t2, zero, 1b # if t2 > zero then 1b
    1:

    ret

main:
    la s1, MIMO #
    lw s1, 0(s1) # carrega o endereço base

    mv  a0, s1 # a0 = s1
    la a1, buffer # carrega o endereço do buffer
    jal gets  # jump to gets and save position to ra
    jal atoi  # jump to atoi and save position to ra

    ##Identifica qual a opção
    addi a0, a0, -1 # a0 = a0 + -1
    beq a0, zero, opc1 # if a0 == zero then opc1
    addi a0, a0, -1 # a0 = a0 + -1
    beq a0, zero, opc2 # if a0 == zero then opc2
    addi a0, a0, -1 # a0 = a0 + -1
    beq a0, zero, opc3 # if a0 == zero then opc3
    addi a0, a0, -1 # a0 = a0 + -1
    beq a0, zero, opc4 # if a0 == zero then opc4
    
    

    opc1:

        mv  a0, s1 # a0 = s1
        la a1, buffer # 
        jal gets  # jump to gets and save position to ra
        
        mv  a1, s1 # a1 = s1
        jal puts  # jump to puts and save position to ra

        j exit

    opc2:

        mv  a0, s1 # a0 = s1
        la a1, buffer # 
        jal gets  # jump to gets and save position to ra
        
        jal reverte
        
        mv  a1, s1 # a1 = s1
        jal puts  # jump to puts and save position to ra

        j exit

    opc3:

        mv  a0, s1 # a0 = s1
        la a1, buffer # 
        jal gets  # jump to gets and save position to ra

        jal atoi

        la a1, buffer # 
        li a2, 16 # a2 = 16
        jal itoa  # jump to itoa and save position to ra
        
        mv  a1, s1 # a1 = s1
        jal puts  # jump to puts and save position to ra
        

        j exit

    opc4:

        mv  a0, s1 # a0 = s1
        la a1, buffer # 
        jal gets  # jump to gets and save position to ra

        mv  t0, a0 # t0 = a0
        li t1, ' ' # t1 = ' '
        la t3, numero1 # 
        
        1:
            lb t2, 0(t0) # carrega o digito
            beq t2, t1, 1f # if t2 == t1 then 1f
            sb t2, 0(t3) # salva na string de apoio
            addi t0, t0, 1 # t0 = t0 + 1
            addi t3, t3, 1 # t3 = t3 + 1 
            j 1b  # jump to 1b
        1:    

        addi t0, t0, 1 # t0 = t0 + 1
        lb t2, 0(t0) # carrega a operação
        
        addi sp, sp, -4 # sp = sp + -4
        sw t2, 0(sp) # salva a operação na pilha

        ##identifica o segundo numero
        addi t0, t0, 1 # t0 = t0 + 1
        mv  a0, t0 # a0 = t0
        jal atoi  # jump to atoi and save position to ra
        la a1, numero2 # 
        sw a0, 0(a1) # 

        ## identifica o primeiro numero
        la a0, numero1 # 
        jal atoi  # jump to atoi and save position to ra

        LW a1, numero2 # 
        
        ## identifica a operação
        lw t1, 0(sp) # 
        addi sp, sp, 4 # sp = sp + 4 -- traz a operação da pilha
        li t0, '+' # t0 = '+'
        bne t0, t1, 1f # if t0 != t1 then 1f
        add a0, a0, a1 # a0 = a0 + a1
        j 2f  # jump to 2f

        1:
        li t0, '-' # t0 = '-'
        bne t0, t1, 1f # if t0 != t1 then 1f
        sub a0, a0, a1 # a0 = a0 - a1
        j 2f  # jump to 2f
        
        1:
        li t0, '*' # t0 = '*'
        bne t0, t1, 1f # if t0 != t1 then 1f
        mul a0, a0, a1
        j 2f  # jump to 2f
        
        1:
        div a0, a0, a1

        2:



        la a1, buffer # 
        li a2, 10 # a1 = 10
        jal itoa  # jump to itoa and save position to ra
        
        mv  a1, s1 # a1 = s1
        jal puts  # jump to puts and save position to ra
        
        j exit  # jump to exit
        

.data

MIMO: .word 0xFFFF0100

.bss

numero1: .skip 64

numero2: .skip 4

buffer: .skip 64