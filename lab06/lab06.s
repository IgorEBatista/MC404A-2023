.globl
_start:
    jal main  # jump to main and save position to ra

exit:
    li a7, 93           # syscall exit (93) \n
    ecall

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, saida       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall    
    ret
    
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

dec_int:
    #a0 = vetor input
    #a1 = numero degrupos/digitos
    #s1 = vetor destino
    li a2, 5 # a2 = 5
    li a3, 10 # a3 = 10
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
            bne t1, a1, 2b # if t1 != a1 then 2b - verifica se já terminou o grupo
            
        sw t4, 0(a4) # salva o valor de t4 em a4
        addi a4, a4, 4 # a4 = a4 + 4 - atualiza o endereço de salvamento
        addi t0, t0, 1 # t0 = t0 + 1 - atualiza o grupo
        bne t0, a1, 1b # if t0 != a1 then 1b - verifica se já terminou a entrada

    ret

preenche:
    # a0 entrada de inteiros
    # a1 destino das raizes
    mv  a4, a0 # a4 = a0
    mv  a5, a1 # a5 = a1
    li a3, 4 # a3 = 4 - contador de repeticao
    #tem que salvar o ra antes de dar o próximo jump
    mv  t6, ra # t6 = ra
    1:
        lw a0, 0(a4) # carrega o inteiro da vez
        jal root  # jump to root and save position to ra
        sw a0, 0(a5) # salva a raiz da vez
        
        addi a4, a4, 4 # a4 = a4 + 4
        addi a5, a5, 4 # a5 = a5 + 4
        addi a3, a3, -1 # a3 = a3 - 1
        bnez a3, 1b # if a3 != 0 then 1b - verifica se já terminou o vetor
    mv  ra, t6 # ra = t6
    ret

int_dec:
    # s1 vetor de inteiros
    # s2 vetor a ser preenchido com caracteres
    li t0, 12 # t0 = 12 - contador de grupo
    li t1, 19 # t1 = 19 - contador de caracter
    li t2, 10 # t2 = 10

    add t0, t0, s1 # t0 = t0 + s1
    add t1, t1, s2 # t1 = t1 + s2
    
    
    li a1, 10 # a1 = 10 = \n
    sb a1, 0(t1) # adiciona \n ao fim do vetor
    addi t1, t1, -1 # t1 = t1 -1  - atualiza o contador de caractere
        
    1:
        lw a0, 0(t0) # carrega o inteiro da vez
        li t3, 4 # t3 = 4 - contador interno
        
        2:
            rem a1, a0, t2 # salva em a1 o resto da divisão por 10
            addi a1, a1, 48 # a1 = a1 + 48 transforma o numero em caractere
            sb a1, 0(t1) # salva o caractere na string
            
            div a0, a0, t2 # divide o inteiro por 10
            addi t1, t1, -1 # t1 = t1 + -1 - atualiza o contador de caractere
            addi t3, t3, -1 # t3 = t3 + -1 - atualiza o contador interno
            bnez t3, 2b #if t3 != 0 than 2b
            
        blt t1, s2, 1f # if t1 < s2 then 1f
        
        addi t0, t0, -4 # t0 = t0 + -4 - atualiza o inteiro da vez
        li a1, 32 # a1 = 32 carrega o espaço na memória
        sb a1, 0(t1) # grava o espaço na string
        addi t1, t1, -1 # t1 = t1 + -1 - atualiza o contador de caractere
        j 1b  # jump to 1b
        
    1:
        ret
            
        

main:
    # jal read  # jump to read and save position to ra

    la a0, input #carrega o endereço da string de input no registrador
    li a1, 4 # a1 = 4
    la s1, inteiros # carrega em s1 o endereço do vetor de inteiros
    jal dec_int  # jump to dec_int and save position to ra

    la a0, inteiros #carrega em a0 o endereço do vetor de inteiros
    la a1, raizes # carrega em a1 o destino das raizes
    jal preenche  # jump to preenche and save position to ra
    
    la s1, raizes # carrega o vetor de raizes em s1
    la s2, saida # carrega o vetor string de destino em s2 
    jal int_dec  # jump to int_dec and save position to ra 
    
    jal write  # jump to write and save position to ra
    j exit  # jump to exit

.data  #alterar pra .bss depois

inteiros: 
        .word 0,0,0,0
        
raizes: .word 0,0,0,0

input: .asciiz "0400 5337 2240 9166"  # buffer de entrada
saida:  .asciiz "01234567890123456789" #saida que sera escrita

#.bss

# inteiros: .skip 0x10 #vetor de 4 inteiros de 4 bytes
# raizes: .skip 0x10 #vetor de 4 inteiros de 4 bytes

# input: .skip 0x14  # buffer de entrada
# saida:  .skip 0x14 #saida que sera escrita
