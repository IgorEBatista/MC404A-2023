.globl _start
_start:
Syscall_read_serial:
    #a0: buffer -> Number of characters read.
    #a1: size
    #a7: 17
    #t0: endereço base
    #t1: carregamento
    #t2: 1
    #t3: apoio origem

    la a0, vetor # 
    li a1, 1 # a1 = 2


    LW t0, BASE_SERIAL #
    li t2, 1 # t2 = 1
    mv t3, a0

    1:
        sb t2, 2(t0) # ativa a leitura 
        
        2: #Espera a leitura terminar
            nop
            lb t1, 2(t0) # 
            bne t1, zero, 2b # if t1 != zero then 2b
        2:

        lb t1, 3(t0) # carrega o byte lido 
        sb t1, 0(t3) # salva o byte lido no buffer
        addi t3, t3, 1 # t3 = t3 + 1 avança o endereço
        addi a1, a1, -1 # a1 = a1 + -1
        beq t1, zero, 1f # if t1 == zero then 1f -- sai do loop se ler zero
        beq a1, zero, 2f # if a1 = zero then 2f
        j 1b
    1:
    
    addi a0, a0, -1 # a0 = a0 + -1
    
    2:
    sub a0, t3, a0 # a0 = t3 - a0



.bss

vetor: .skip 10

.data
BASE_SERIAL: .word 0xFFFF0100