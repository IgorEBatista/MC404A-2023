.text
.align 4

int_handler:
    ###### Syscall and Interrupts handler ######
  
    # salva contexto
        csrrw sp, mscratch, sp # Troca sp com mscratch
        addi sp, sp, -124 # Aloca espaço na pilha da ISR
        sw x1, 0(sp) # Salva x1
        sw x2, 4(sp) # Salva x2
        sw x3, 8(sp) # Salva x3
        sw x4, 12(sp) # Salva x4
        sw x5, 16(sp) # Salva x5
        sw x6, 20(sp) # Salva x6
        sw x7, 24(sp) # Salva x7
        sw x8, 28(sp) # Salva x8
        sw x9, 32(sp) # Salva x9
        # sw x10, 36(sp) # Salva x10
        sw x11, 40(sp) # Salva x11
        sw x12, 44(sp) # Salva x12
        sw x13, 48(sp) # Salva x13
        sw x14, 52(sp) # Salva x14
        sw x15, 56(sp) # Salva x15
        sw x16, 60(sp) # Salva x16
        sw x17, 64(sp) # Salva x17
        sw x18, 68(sp) # Salva x18
        sw x19, 72(sp) # Salva x19
        sw x20, 76(sp) # Salva x20
        sw x21, 80(sp) # Salva x21
        sw x22, 84(sp) # Salva x22
        sw x23, 88(sp) # Salva x23
        sw x24, 92(sp) # Salva x24
        sw x25, 96(sp) # Salva x25
        sw x26, 100(sp) # Salva x26
        sw x27, 104(sp) # Salva x27
        sw x28, 108(sp) # Salva x28
        sw x29, 112(sp) # Salva x29
        sw x30, 116(sp) # Salva x30
        sw x31, 120(sp) # Salva x31

    #identifica a interrupção
    li t0, 10 # t0 = 10
    beq t0, a7, set_engine_and_steering # if t0 == a7 then set_engine_and_steering
    li t0, 11 # t0 = 11
    beq t0, a7, set_handbrake # if t0 == a7 then set_handbrake
    li t0, 12 # t0 = 12
    beq t0, a7, read_sensors # if t0 == a7 then read_sensors
    li t0, a7 # t0 = a7
    beq t0, a7, get_position # if t0 == a7 then get_position
    
    resolvido:

    # restaura o contexto
        lw x1, 0(sp) # Salva x1
        lw x2, 4(sp) # Salva x2
        lw x3, 8(sp) # Salva x3
        lw x4, 12(sp) # Salva x4
        lw x5, 16(sp) # Salva x5
        lw x6, 20(sp) # Salva x6
        lw x7, 24(sp) # Salva x7
        lw x8, 28(sp) # Salva x8
        lw x9, 32(sp) # Salva x9
        # lw x10, 36(sp) # Salva x10
        lw x11, 40(sp) # Salva x11
        lw x12, 44(sp) # Salva x12
        lw x13, 48(sp) # Salva x13
        lw x14, 52(sp) # Salva x14
        lw x15, 56(sp) # Salva x15
        lw x16, 60(sp) # Salva x16
        lw x17, 64(sp) # Salva x17
        lw x18, 68(sp) # Salva x18
        lw x19, 72(sp) # Salva x19
        lw x20, 76(sp) # Salva x20
        lw x21, 80(sp) # Salva x21
        lw x22, 84(sp) # Salva x22
        lw x23, 88(sp) # Salva x23
        lw x24, 92(sp) # Salva x24
        lw x25, 96(sp) # Salva x25
        lw x26, 100(sp) # Salva x26
        lw x27, 104(sp) # Salva x27
        lw x28, 108(sp) # Salva x28
        lw x29, 112(sp) # Salva x29
        lw x30, 116(sp) # Salva x30
        lw x31, 120(sp) # Salva x31
        addi sp, sp, 124 # Desaloca espaço na pilha da ISR
        csrrw sp, mscratch, sp # Troca sp com mscratch novamente
  
    csrr t0, mepc  # load return address (address of the instruction that invoked the syscall)
    addi t0, t0, 4 # adds 4 to the return address (to return after ecall) 
    csrw mepc, t0  # stores the return address back on mepc
    mret           # Recover remaining context (pc <- mepc)
  

set_engine_and_steering:
    #a0: Movement direction -> 0 if successful or -1 if error
    #a1: Steering wheel angl
    #a7: 10

    #faz as verificações
    li t0, -1 # t0 = -1
    blt a0, t0, 1f # if a0 < t0 then 1f
    li t0, 1 # t0 = 1
    bgt a0, t0, 1f # if a0 > t0 then 1f
    li t0, -127 # t0 = -127
    blt a0, t0, 1f # if a0 < t0 then 1f
    li t0, 127 # t0 = 127
    bgt a0, t0, 1f # if a0 > t0 then 1f

    #comanda o veículo
    li t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 33(t0) # a posicao 0x21 controla o motor
    sb a1, 32(s2) # a posicao 0x20 controla a direcao da roda

    li a0, 0 # a0 = 0
    j resolvido  # jump to resolvido
    
    1: #se falhar retorna -1
    li a0, -1 # a0 = -1
    j resolvido

set_handbrake:
    #a0: value stating if the hand brakes must be used.
    #a7: 11

    li t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 34(t0) #  a posicao 0x22 controla o freio
    
    j resolvido  # jump to resolvido
    

read_sensors:
    #a0: address of an array with 256 elements that will store the values read by the luminosity sensor.
    #a7: 12

    li t0, BASE_MIMO # t0 = BASE_MIMO
    li t1, 1 # t1 = 1
    sb t1, 1(t0) #  a posicao 0x1 liga a cam
    1:
        nop
        lb t1, 1(t0) # 
        bne t1, zero, 1b # if t1 != zero then 1b
    1:

    li t2, 256 # t2 = 256
    addi t0, t0, 0x24 # t0 = t0 + 0x24 -- inicio do vetor salvo
    mv  t3, a0 # t3 = a0

    1:
        lb t1, 0(t0) # le o byte do sensor
        sb t1, 0(a0) # guarda no vetor
        
        addi t0, t0, 1 # t0 = t0 + 1 -- atualiza o byte da vez
        addi a0, a0, 1 # a0 = a0 + 1
        
        addi t2, t2, -1 # t2 = t2 + -1
        bge t2, zero, 1b # if t2 >= zero then 1b
    1:

    mv  a0, t3 # a0 = t3        

    j resolvido  # jump to resolvido
    

get_position:
    #a0: address of the variable that will store the value of x position. 
    #a1: address of the variable that will store the value of y position.
    #a2: address of the variable that will store the value of z position.
    #a7: 15

    li t0, BASE_MIMO # t0 = BASE_MIMO
    li t1, 1 # t1 = 1
    sb t1, 0(t0) #  a posicao 0x1 liga o gps
    1:
        nop
        lb t1, 0(t0) # 
        bne t1, zero, 1b # if t1 != zero then 1b
    1:

    lw t1, 16(t0) # le a posição x
    sw t1, 0(a0) # salva a posição x
    lw t1, 20(t0) # le a posição y
    sw t1, 0(a1) # salva a posição y
    lw t1, 24(t0) # le a posição z
    sw t1, 0(a2) # salva a posição z

    j resolvido  # jump to resolvido


.globl _start
_start:

    la t0, int_handler  # Load the address of the routine that will handle interrupts
    csrw mtvec, t0      # (and syscalls) on the register MTVEC to set the interrupt array.

    .set BASE_MIMO 0xFFFF0100

    .bss

    fim_prog_stack: .skip 6400
    prog_stack:

    fim_irs_stack: .skip 6400
    irs_stack:

    .text

    ##Inicia as pilhas
    la sp, prog_stack # carrega a pilha para o programa
    la t0, irs_stack # carrega a pilha para as irs
    csrw mscratch, t0 # aponta mscratch para a pilha dedicada as irs



# Write here the code to change to user mode and call the function user_main (defined in another file).
    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, user_main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;


    # implement your control logic here, using only the defined syscalls
motor:
    #controla o motor do carro
    #a0: comando do motor (-1, 0, 1)
    sb a0, 33(s2) # a posicao 0x21 controla o motor 
    ret

freia:
    #aciona o freio de mão ( o motor deve estar desligado)
    li t1, 1 # t1 = 1
    sb t1, 34(s2) #  a posicao 0x22 controla o freio
    ret

dir:
    #controla a direção das rodas
    #a0: comando da roda (-127 ~ 127)
    sb a0, 32(s2) # a posicao 0x20 controla a direcao da roda 
    ret

get_coord:
    #Coleta as coordenadas do gps e salva numa estrutura
    #a0: endereço da estrutura
    #a1: endereço base da memoria de acesso ao carro
    #t1: carregamento de valores
    #t2: att dir

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    li t1, 1 # t1 = 1
    sb t1, 0(a1) # aciona o gps
    1:
        nop
        lb t1, 0(a1) # 
        bne t1, zero, 1b # if t1 != zero then 1b

    lw t1, 16(a1) # carrega a nova coord x

    lw t2, 0(a0) # carrega a coord anterior x
    sub t2, t1, t2 # t2 = t1 - t2 calcula a dir
    sw t2, 8(a0) # salva a dir
    sw t1, 0(a0) # salva a nova coord x
    
    lw t1, 24(a1) # carrega a nova coord z
    lw t2, 4(a0) # carrega a coord anterior z
    sub t2, t1, t2 # t2 = t1 - t2 calcula a dir
    sw t2, 12(a0) # salva a dir
    sw t1, 4(a0) # salva a nova coord z

    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret

calc_dist:
    #Calcula a distância de separação com o centro do objetivo
    #a0: endereço da estrutura --> distância de separação
    #a1: endereço das coords do alvo

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)
    
    lw t0, 0(a0) # carrega coord x atual
    lw t1, 0(a1) # carrega coord x alvo
    lw t2, 4(a0) # carrega coord z atual
    lw t3, 4(a1) # carrega coord z alvo

    sub t0, t1, t0 # t0 = t1 - t0 -- calcula dx
    sub t1, t3, t2 # t1 = t3 - t2 -- calcula dz

    mul t0, t0, t0 # dx²
    mul t1, t1, t1 # dz²

    add t0, t0, t1 # t0 = t0 + t1 -- dx² + dz²
    mv  a0, t0 # a0 = t0
    
    jal root  # jump to root and save position to ra
    
    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret
    

calc_dir:
    #Determina se o carro deve virar a esquerda ou a direita
    #a0: endereço da estrutura -> direção da roda
    #a1: endereço das coords alvo

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    lw t0, 8(a0) # carrega o x da direcao
    lw t1, 0(a1) # carrega o x alvo
    lw t4, 0(a0) # carrega o x atual 

    lw t2, 12(a0) # carrega o z da direcao
    lw t3, 4(a1) # carrega o z alvo
    lw t5, 4(a0) # carrega o z atual 
    
    #Acha a direção atual do alvo
    sub t1, t1, t4 # t1 = t1 - t4
    sub t3, t3, t5 # t3 = t3 - t5

    #faz o produto vetorial
    mul t0, t0, t3 #
    mul t1, t1, t2 #
    
    sub t0, t1, t0 # t0 = t0 - t1

    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    
    bgt t0, zero, 1f # if t0 > zero then 1f
    li a0, -63 # a0 = -127
    ret

    1:
    li a0, 63 # a0 = 127 #curva para direita
    ret

root:
    # Determinba a raiz de um número com 11 iterações
    #a0: num -> raiz do num

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

.globl control_logic
control_logic:
#Inicializacao
    la s1, estrutura #  s1 será o endereço da estrutura
    LW s2, base # s2 será o endereço base do acesso à memória
    la s3, alvo # s3 será o endereço do alvo
    # A padronização acima foi feita para diminuir o numero de acessos a memória, 
    # visando maior otimização de processamento do sistema embarcado

    mv  a0, s1 # a0 = s1
    mv  a1, s2 # a1 = s2
    jal get_coord  # jump to get_coord and save position to ra
    
    li a0, 1 # a0 = 1
    jal motor  # jump to motor and save position to ra
    
    li a7, 5000 # a7 = 5000
    1:
        nop
        addi a7, a7, -1 # a7 = a7 + -1
        bne a7, zero, 1b # if a7 != zero then 1b

    mv  a0, s1 # a0 = s1
    mv  a1, s2 # a1 = s2
    jal get_coord  # jump to get_coord and save position to ra

#Conducao
    1:
        mv  a0, s1 # a0 = s1
        mv  a1, s3 # a1 = s3
        jal calc_dir  # jump to calc_dir and save position to ra
        jal dir  # jump to dir and save position to ra

        mv  a0, s1 # a0 = s1
        mv  a1, s2 # a1 = s2
        jal get_coord  # jump to get_coord and save position to ra
        
        li a7, 1000 # a7 = 1000
        2:
            nop
            addi a7, a7, -1 # a7 = a7 + -1
            bne a7, zero, 2b # if a7 != zero then 2b



        mv  a0, s1 # a0 = s1
        mv  a1, s3 # a1 = s3
        jal calc_dist  # jump to calc_dist and save position to ra
        
        li t1, 30 # t1 = 30
        sub a0, a0, t1 # a0 = a0 - t1
        blt a0, zero, 1f # if a0 < zero then 1f
        li t1, 30 # t1 = 30
        sub a0, a0, t1 # a0 = a0 - t1
        bgt a0, zero, 1b # if a0 > zero then 1b
        li a0, 0 # a0 = 0
        jal motor  # jump to motor and save position to ra

        j 1b  # jump to 1b
        
    1:
#Finalizacao
    
    jal freia  # jump to freia and save position to ra

    li a7, 1000 # a7 = 1000
        2:
            nop
            addi a7, a7, -1 # a7 = a7 + -1
            bne a7, zero, 2b # if a7 != zero then 2b


base: .word 0xFFFF0100

#estrutura:
    # Coord x,z (int,int)
    # Vetor dir x,z (int,int)

estrutura: .word 0,0,0,0
