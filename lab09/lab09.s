.text
.globl _start
_start:
    jal main  # jump to main and save position to ra

exit:
    li a7, 93           # syscall exit (93) \n
    li a0, 10
    ecall

read:
    # a2 numero de bits a serem lidos
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    # li a2, 20  # size (reads only 20 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    # a1 endereço da string de saida
    # a2 numero de bits a serem escritos
    li a0, 1            # file descriptor = 1 (stdout)
    # la a1, saida       # buffer
    # li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall    
    ret

str_int:
    #a0: endereço da string -> inteiro retornado
    #a1: base numerica do valor
    #t0: byte da vez
    #t1: const para comparacao
    #t2: sinal
    #t3: endereço da string

    li t2, 1 # t2 = 1
    mv  t3, a0 # t3 = a0
    li a0, 0 # a0 = 0 - zera o valor de retorno
    #Verifica se é negativo
    lb t0, 0(t3) # carrega o primeiro byte 
    li t1, '-' # t1 = '-'
    bne t0, t1, 1f # if t0 != t1 then 1f
    li t2, -1 # t2 = -1
    addi t3, t3, 1 # t3 = t3 + 1
    
    1:
        lb t0, 0(t3) # carrega o byte da vez
        addi t3, t3, 1 # t3 = t3 + 1
        li t1, 32 # t1 = 32
        beq t0, t1, 1f # if t0 == t1 then 1f -- Verifica se é o espaço
        li t1, 10 # t1 = 10
        beq t0, t1, 1f # if t0 == t1 then 1f -- Verifica se é um \n
        addi t0, t0, -48 # t0 = t0 + -48
        mul a0, a0, a1 # Multiplica o valor anterior pela base
        add a0, a0, t0 # a0 = a0 + t0 -- adiciona o novo digito ao total
        j 1b  # jump to 1b
    1:
    mul a0, a0, t2 # corrige o sinal
    ret

int_str:
    #a0: inteiro a ser convertido --> tamanho da string
    #a1: endereço da string de saida
    #a2: base numerica para conversão
    #t0: valor da vez
    #t1: contador de repetição
    #t2: marcador de sinal

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
        addi t0, t0, 48 # t0 = t0 + 48 -- transforma em caractere
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
    ret

        

busca:
    #a0: endereço do primeiro nó -> valor de retorno
    #a1: valor buscado
    #t0: endereço do nó atual
    #t1: parcela 1 /total
    #t2: parcela 2

    mv  t0, a0 # t0 = a0
    li a0, 0 # a0 = 0 -- zera o indice retornado
    1: #inicio do loop
        lw t1, 0(t0) # carrega a primeira parcela
        lw t2, 4(t0) # carrega a segunda parcela
        add t1, t1, t2 # t1 = t1 + t2
        beq t1, a1, 1f # if t1 == a1 then 1f -- verifica se é o valor procurado
        
        lw t0, 8(t0) # carrega o endereço do próximo nó
        beq t0, zero, 2f # if t0 == zero then 2f
        addi a0, a0, 1 # a0 = a0 + 1
        j 1b  # jump to 1b
        
    1: #fim do loop
    ret
    
    2:
        li a0, -1 # a0 = -1
        ret
        

main:
    #Lê a entrada
    li a2, 5 # a2 = 5
    jal read  # jump to read and save position to ra
    
    #Converte para um inteiro
    la a0, input # 
    li a1, 10 # a1 = 10 -- carrega base para conversão    
    jal str_int  # jump to str_dec and save position to ra
    SW a0, alvo, t0 #salva o inteiro procurado

    #inicia a busca
    mv  a1, a0 # a1 = a0
    la a0, head_node # 
    jal busca  # jump to busca and save position to ra

    #converte em string
    la a1, saida # 
    li a2, 10 #carrega a base para a conversão
    jal int_str  # jump to int_str and save position to ra
    
    #imprime no terminal
    la a1, saida # 
    mv  a2, a0 # a2 = a0 -- determina o numero de bytes a serem impressos
    jal write  # jump to write and save position to ra
    

    j exit


.data

input: .string "                 "
alvo: .word 0

saida: .string "                 "