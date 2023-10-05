la a0, oi # 
jal gets  # jump to gets and save position to ra
li a1, 10 # a1 = 10
jal atoi  # jump to atoi and save position to ra


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
    li t2, '\n' # t2 = '\n'
    li a0, 0  # file descriptor = 0 (stdin)
    # la a1, i #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    1:
        # ecall
        lb t1, 0(a1) # 
        beq t1, t2, 1f # if t1 == t2 then 1f
        addi a1, a1, 1 # a1 = a1 + 1
        j 1b
    1:
    li t1, 0 # t1 = 0
    sb t1, 0(a1) # 
    mv  a0, a6 # a0 = a6

    ret

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
        # li t1, 10 # t1 = 10
        # beq t0, t1, 1f # if t0 == t1 then 1f -- Verifica se é um \n
        addi t0, t0, -48 # t0 = t0 + -48
        mul a0, a0, a1 # Multiplica o valor anterior pela base
        add a0, a0, t0 # a0 = a0 + t0 -- adiciona o novo digito ao total
        j 1b  # jump to 1b
    1:
    mul a0, a0, t2 # corrige o sinal
    ret





puts: #corrigir a alteracao na string
    #a0 : endereço da string a ser impressa
    #t0 : endereço atual --> contador
    #t1: byte da vez

    mv  t0, a0 # t0 = a0  -- inicia o endereço no inicio da string

    1:
        lb t1, 0(t0) # carrega o byte da vez 
        beq t1, zero, 1f # if t0 == zero then 1f
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
        ret



.data
oi: .string "123456\n"
