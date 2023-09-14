.text
.globl
_start:
    jal main  # jump to main and save position to ra

exit:
    li a7, 93           # syscall exit (93) \n
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
    # a2 numero de bits a serem escritos
    li a0, 1            # file descriptor = 1 (stdout)
    # la a1, saida       # buffer
    # li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall    
    ret

dec_int:
    #a0 = vetor input
    #a1 = numero de grupos
    #a2 = numero de digitos
    #a3 = base numerica
    #s1 = vetor destino
    mv a4, s1 # a4 = s1 - define endereço do vetor de inteiros
    li t0, 0 # t0 = 0 marcador de repetição externo (qual grupo)
    

    1:
        li t4, 0 # t4 = 0 - reseta o valor acumulado
        li t1, 0 # t1 = 0 - reseta o marcador de repetição interno (qual caractere)

        2:
            mul t2, t0, a2 #define o grupo
            add t2, t2, t1 #define o caracter
            add t2, a0, t2 # t2 = a0 + t2

            lb t3, 0(t2) # carega o char da vez
            addi t3, t3, -48 # t3 = t3 + -48 - transforma em numero
            mul t4, t4, a3 # multiplica o valor anterior por 10
            add t4, t4, t3 # t4 = t4 + t3  adiciona o valor atual
    
            addi t1, t1, 1 # t1 = t1 + 1
            bne t1, a2, 2b # if t0 != a1 then 2b - verifica se já terminou o grupo
            
        sw t4, 0(a4) # salva o valor de t4 em a4
        addi a4, a4, 4 # a4 = a4 + 4 - atualiza o endereço de salvamento
        addi t0, t0, 1 # t0 = t0 + 1 - atualiza o grupo
        bne t0, a1, 1b # if t0 != a1 then 1b - verifica se já terminou a entrada

    ret

conta_p:
    #a0 - inteiro inicial -> p final
    #a1 - mascara dos bits importantes
    mv  t0, a0 # t0 = a0 -- salva o numero inicial
    mv  a0, zero # a0 = zero -- zera o novo total
    and t0, t0, a1  #resgata os valores importantes
    li t3, 4 # t3 = 0 -- inicia contador interno
    
    1:
        andi t1, t0, 0b0001
        add a0, a0, t1 # a0 = a0 + t1 -- adiciona a contagem ao total p

        srli t0, t0, 1  #avança o próximo bit
        addi t3, t3, -1 # t3 = t3 + -1 atualiza o contador interno
        bne t3, zero, 1b # if t3 != zero then 1b
    
    andi a0, a0, 0b0001 # define se par ou impar

    ret

int_str: #Tranforma um vetor de inteiros em uma string (não liga para sinal)
    #Entradas:
    # s1 vetor de inteiros
    # s2 vetor a ser preenchido com caracteres
    # a0 inicio do ultimo grupo (contador)
    # a1 posição do ultimo caracter (contador)
    # a2 base de escrita dos numeros

    #Uso interno
    # t0 inteiro sendo convertido em string
    # t1 dado que será adicionado a string
    # t2 contador interno (dentro do grupo) (numero de digitos a serem escritos)

    add a0, a0, s1 # a0 = a0 + s1  (transforma no endereço do ultimo grupo)
    add a1, a1, s2 # a1 = a1 + s2   (tranforma em endereço do ultimo caracter)
    
    
    li t1, '\n' # t1 = 10 = \n
    sb t1, 0(a1) # adiciona \n ao fim do vetor
    ret
    addi a1, a1, -1 # a1 = a1 -1  - atualiza o contador de caractere
        
    1:
        lw t0, 0(a0) # carrega o inteiro da vez
        li t2, 4 # t2 = 4 - contador interno (numero de digitos)
        
        2:
            rem t1, t0, a2 # salva em t1 o resto da divisão pela base
            addi t1, t1, 48 # t1 = t1 + 48 transforma o numero em caractere
            sb t1, 0(a1) # salva o caractere na string
            
            div t0, t0, a2 # divide o inteiro pela base
            addi a1, a1, -1 # a1 = a1 + -1 - atualiza o contador de caractere
            addi t2, t2, -1 # t2 = t2 + -1 - atualiza o contador interno
            bnez t2, 2b #if t2 != 0 than 2b
            
        blt a1, s2, 1f # if a1 < s2 then 1f
        
        addi a0, a0, -4 # a0 = a0 + -4 - atualiza o inteiro da vez
        li t1, 32 # t1 = 32 carrega o espaço na memória
        sb t1, 0(a1) # grava o espaço na string
        addi a1, a1, -1 # a1 = a1 + -1 - atualiza o contador de caractere
        j 1b  # jump to 1b
        
    1:
        ret
            

main:
    # Lê os 4 bits da primeira entrada
    li a2, 4 # a2 = 4
    # jal read  # jump to read and save position to ra
.data
    input: .asciiz "1001"

.text

    # converte em um inteiro
    la a0, input # vetor input
    li a1, 1 # numero de grupos
    li a2, 4 # numero de digitos
    li a3, 2 # base numerica
    la s1, int_i # vetor destino
    jal dec_int  # jump to dec_int and save position to ra
    
    la s2, saida # carrega endereço vetor string de saida
    #decobrir p1
    lw a0, 0(s1) # carrega o inteiro
    li a1, 0b1101 # a1 = 0b1101
    jal conta_p  # jump to conta_p and save position to ra
    addi a0, a0, '0' # a0 = a0 + '0' -- Transforma em caractere
    
    sb a0, 0(s2) # salva o byte na string
    
    #decobrir p2
    lw a0, 0(s1) # carrega o inteiro
    li a1, 0b1011 # a1 = 0b1011
    jal conta_p  # jump to conta_p and save position to ra
    addi a0, a0, '0' # a0 = a0 + '0' -- Transforma em caractere
    
    sb a0, 1(s2) # salva o byte na string
    
    #decobrir p3
    lw a0, 0(s1) # carrega o inteiro
    li a1, 0b0111 # a1 = 0b0111
    jal conta_p  # jump to conta_p and save position to ra
    addi a0, a0, '0' # a0 = a0 + '0' -- Transforma em caractere
    
    sb a0, 3(s2) # salva o byte na string

    #transforma o inteiro em string
    mv  s3, s2 # s3 = s2
    la s2, temp # carrega o endereço da string temporaria
    li a0, 0 # a0 = 0 -- inicio do ultimo grupo (contador)
    li a1, 4 # a1 = 4 -- posição do ultimo caracter (contador)
    li a2, 2 # a2 = 2 -- base de escrita dos numeros
    jal int_str  # jump to int_dec and save position to ra
    
    # adiciona os bits nas posições corretas para impressão
    la s2, input # 
    # la s2, temp
    
    la s1, saida # carrega a string de destino
    mv  t0, zero # t0 = zero -- zera um contador

    lb t1, 0(s2) # Carrega o primeiro digito
    sb t1, 2(s1) # salva o primeiro digito
    lb t1, 1(s2) # Carrega o segundo digito
    sb t1, 4(s1) # salva o segundo digito
    lb t1, 2(s2) # Carrega o terceiro digito
    sb t1, 5(s1) # salva o terceiro digito
    lb t1, 3(s2) # Carrega o quarto digito
    sb t1, 6(s1) # salva o quarto digito

    li t1, '\n' # t1 = '\n'
    sb t1, 7(s1) #  adiciona \n na ultima posição da string de saida

    li a2, 8 # a2 = 10
    la a1, saida
    jal write  # jump to write and save position to ra
    la a1, temp
    li a2, 8 # a2 = 10
    jal write  # jump to write and save position to ra
    
     
    
    
    

    j exit


.data

# input: .asciiz "1001\n56789ABCEF\n"
temp: .asciiz "AAAAA"
saida: .asciiz "FEDCBA9876543210\n"

int_i: .word 0 # Um inteiro de 4 bytes
int_f: .word 0 # Um inteiro de 4 bytes

# .bss

# int_i: .skip 0x4 # Um inteiro de 4 bytes
# int_f: .skip 0x4 # Um inteiro de 4 bytes

# # input: .skip 0x10  # buffer de entrada
# temp:  .skip 0x4 #string temporaria
# saida:  .skip 0x10 #saida que sera escrita