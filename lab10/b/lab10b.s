.globl gets
gets:
    #a0: endereço da string a ser guardada -> file descriptor
    #a1: -> endereço da string 
    # a2 numero de bits a serem lidos ( 1)
    # a6 inicio da string
    #t1: byte da vez
    #t2: '\n'
    mv  a1, a0 # a1 = a0
    mv  a6, a0 # a6 = a0
    li t2, 10 # t2 = 10
    # la a1, i #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    1:
        li a0, 0  # file descriptor = 0 (stdin)
        ecall
        lb t1, 0(a1) # 
        beq t1, t2, 1f # if t1 == t2 then 1f
        addi a1, a1, 1 # a1 = a1 + 1

        j 1b  
    1:
    li t1, 0 # t1 = 0
    sb t1, 0(a1) # 
    mv  a0, a6 # a0 = a6
    ret

.globl puts
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

.globl atoi
atoi:
    #a0: endereço da string -> inteiro retornado
    #a1: base numerica do valor (10)
    #t0: byte da vez
    #t1: const para comparacao
    #t2: sinal
    #t3: endereço da string

    #remove espaços
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
        addi t3, t3, 1 # t3 = t3 + 1
        li t1, 0 # t1 = 0
        beq t0, t1, 1f # if t0 == t1 then 1f -- Verifica se é o espaço
        addi t0, t0, -48 # t0 = t0 + -48
        mul a0, a0, a1 # Multiplica o valor anterior pela base
        add a0, a0, t0 # a0 = a0 + t0 -- adiciona o novo digito ao total
        j 1b  # jump to 1b
    1:
    mul a0, a0, t2 # corrige o sinal
    ret

.globl itoa
itoa:
    #a0: inteiro a ser convertido --> endereço da string de saida
    #a1: endereço da string de saida
    #a2: base numerica para conversão
    #t0: valor da vez / constante comparacao / sinal
    #t1: contador de repetição
    #t2: marcador de sinal
    #t3: 10

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

        
.globl recursive_tree_search
recursive_tree_search:
    #a0: endereço do primeiro nó -> valor de retorno
    #a1: valor buscado
    #t0: endereço do nó da vez
    #t1: valor do nó da vez

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    #Verifica se é o valor indicado
        lw t1, 0(a0) # 
        bne a1, t1, 1f # if a1 != t1 then 1f
        
        #Caso sim, retorna 1
        li a0, 1 # a0 = 1
        j 6f  # jump to 6f
        
        1:
        #Empilha os próximos endereços
        addi sp, sp, -8  # Salva os endereços dos nós na pilha do programa
        lw t0, 4(sp) # 
        sw   t0, 4(sp)
        lw t0, 8(sp) # 
        sw   t0, 0(sp)
        #Caso não, verifica se é o filho da direita
            lw a0, 0(sp) # carrega o endereço do filho da direita 
            addi sp, sp, 4
            beq a0, zero, 2f # if a0 == zero then 2f -- se não tiver esse filho, segue em frente
            jal recursive_tree_search  # jump to recursive_tree_search and save position to ra
            
            #Caso retorne 0, segue
            beq a0, zero, 2f # if a0 == zero then 2f
            
            #Caso retorne diferente de zero, retorna o valor + 1
            addi a0, a0, 1 # a0 = a0 + 1
            addi sp, sp, 4 # desempilha o outro nó não utilizado
            j 6f  # jump to 6f
            
        2:
        #Caso não, verifica se é o filho da esquerda    
            lw a0, 0(sp) # carrega o endereço do filho da esquerda 
            addi sp, sp, 4
            beq a0, zero, 3f # if a0 == zero then 3f -- se não tiver esse filho, segue em frente
            jal recursive_tree_search  # jump to recursive_tree_search and save position to ra
            
            #Caso retorne 0, segue
            beq a0, zero, 3f # if a0 == zero then 3f

            #Caso retorne diferente de zero, retorna o valor + 1
            addi a0, a0, 1 # a0 = a0 + 1
            j 6f  # jump to 6f
        
        3:
        #Em último caso, retorna 0
        li a0, 0 # a0 = 0
        
    
    6:
    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret
        
.globl exit
exit:
    #a0 error code
    li a7, 93           # syscall exit (93) \n
    ecall