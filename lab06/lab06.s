

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall    
    ret

_start:
    jal main  # jump to main and save position to ra
    
root:
    mv  a1, a0 # a1 = a0
    srli a0, a1, 1  #divide por 2 e salva em a0 (estima k inicial)
    li t0, 11 # t0 = 11 marcador de repetições
    
    1:  #inicio do loop
        div t1, a1, a0 #divide y por k atual
        add a0, a0, t1; # a0 = a0 + t1
        srli a0, a0, 1 #divide por 2 e salva em a0 (novo k)
        addi t0, t0, -1; # t0 = t0  -1  fim do loop
    bnez t0, 1b; # if t0 != 0  then  1b:
    ret

dec_int:
    li t0, 0 # t0 = 0 marcador de repetição externo (qual grupo)
    li t1, 0 # t1 = 0 marcador de repetição interno (qual caractere)
    li t2, 0 # t2 = 0 valor de acesso
    li t4, 0 # t4 = 0
    
    li a2, 5 # a2 = 5
    li a3, 10 # a3 = 10
    li a4, 4 # a4 = 4
    mul t2, t0, a2 #define o grupo
    add t2, t2, t1 #define o caracter
    add t2, a0, t2; # t2 = a0 + t2

    lb t3, 0(t2) # carega o char da vez
    addi t3, t3, -48; # t3 = t3 + -48
    mul t4, t4, a3 #multiplica o valor anterior por 10
    add t4, t4, t3; # t4 = t4 + t3  adiciona o valor atual
    
    addi t1, t1, 1; # t1 = t1 + 1
    beq t0, a4, 1f; # if t0 == t1 then 1f

    1:
        
    

    
    
    

main:
    jal read  # jump to read and save position to ra
    LB a0, input #carrega a string de input no registrador
    li a1, 4 # a1 = 4
    la a2, inteiros # carrega em a2 o endereço do vetor de inteiros
    jal dec_int  # jump to dec_int and save position to ra
    

.bss

string:  .asciz "Hello! It works!!!\n"

inteiros: .skip 0x20 #vetor de 4 inteiros de 8 bytes

input: .skip 0x14  # buffer
