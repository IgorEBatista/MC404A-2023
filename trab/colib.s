.globl set_engine
set_engine:
    #a0: Movement direction -> 0 if successful or -1 if error
    #a1: Steering wheel angl
    #a7: ->10

    li a7, 10 # a7 = 10
    ecall

    ret

.globl set_handbrake
set_handbrake:
    #a0: value stating if the hand brakes must be used.
    #a7: ->11

    li a7, 11 # a7 = 11
    ecall

    ret

.globl read_sensor_distance
read_sensor_distance:
    #a0 -> Value obtained on the sensor reading; -1 in case no object has been detected in less than 20 meters.
    #a7: -> 13

    li a7, 13 # a7 = 13
    ecall

    ret

.globl get_position
get_position:
    #a0: address of the variable that will store the value of x position. 
    #a1: address of the variable that will store the value of y position.
    #a2: address of the variable that will store the value of z position.
    #a7: -> 15

    li a7, 15 # a7 = 15
    ecall
    ret

.globl get_rotation
get_rotation:
    #a0: address of the variable that will store the value of the Euler angle in x. 
    #a1: address of the variable that will store the value of the Euler angle in y.
    #a2: address of the variable that will store the value of the Euler angle in z
    #a7: -> 16

    li a7, 16 # a7 = 16
    ecall
    ret

.globl get_time
get_time:
    #a0 -> Time since the system has been booted, in milliseconds.
    #a7: -> 20

    li a7, 20 # a7 = 20
    ecall
    ret

.globl puts
puts:
    #a0: buffer
    #a1: size
    #a7: 18


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
    sub a1, t0, a0 # a1 = t0 - a0 -- verifica quantos caracteres há na string
    
    li a7, 18           # syscall write (18)
    ecall

    addi t0, t0, -1 # t0 = t0 + -1 -- desfaz o /n
    li t1, 0 # t1 = 0
    sb t1, 0(t0) #    
    ret

.globl gets
gets:
    #a0: buffer -> Number of characters read.
    #a1: size
    #a6: -> apoio origem
    #a7: -> 17
    #t0: byte da vez
    #t1: '\n'
    #t2: 10 -- '\n'
    
    mv  a6, a0 # a6 = a0
    li a2, 1  # size (reads only 1 byte)
    li a7, 17 # syscall read (17)
    li t1, 10 # t1 = 10
    li t2, 0 # t2 = 0
    
    1:
        add a0, a6, t2 # a0 = a6 + t2
        li a1, 1 # a1 = 1
        ecall
        add a0, a6, t2 # a0 = a6 + t2
        lb t0, 0(a0) # 
        beq t0, t1, 1f # if t0 == t1 then 1f
        addi t2, t2, 1 # t2 = t2 + 1

        j 1b  
    1:
    li t0, 0 # t0 = 0
    sb t0, 0(a0) # 
    mv  a0, a6 # a0 = a6
    ret

.globl atoi
atoi:
    #a0: endereço do inicio da string -> inteiro retornado
    #a1: -> base numerica do valor (10)
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

.globl itoa
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

.globl strlen_custom
strlen_custom:


.globl approx_sqrt
approx_sqrt:


.globl get_distance
get_distance:


.globl fill_and_pop
fill_and_pop: