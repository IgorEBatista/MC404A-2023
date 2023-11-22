int_handler:
    ###### Syscall and Interrupts handler ######
  
    # salva contexto
        csrrw sp, mscratch, sp # Troca sp com mscratch
        addi sp, sp, -16 # Aloca espaço na pilha da ISR

        sw t0, 0(sp) #
        sw t1, 4(sp) #
        sw t2, 8(sp)
        sw t3, 12(sp)
        

    #identifica a interrupção
    li t0, 10 # t0 = 10
    beq t0, a7, Syscall_set_engine_and_steering # if t0 == a7 then set_engine_and_steering
    li t0, 11 # t0 = 11
    beq t0, a7, Syscall_set_handbrake # if t0 == a7 then set_handbrake
    li t0, 12 # t0 = 12
    beq t0, a7, Syscall_read_sensors # if t0 == a7 then read_sensors
    li t0, 13 # t0 = 13
    beq t0, a7, Syscall_read_sensor_distance # if t0 == a7 then _read_sensor_distance
    li t0, 15 # t0 = 15
    beq t0, a7, Syscall_get_position # if t0 == a7 then get_position
    li t0, 16 # t0 = 16
    beq t0, a7, Syscall_get_rotation # if t0 == a7 then get_rotation
    li t0, 17 # t0 = 16
    beq t0, a7, Syscall_read_serial # if t0 == a7 then read_serial
    li t0, 18 # t0 = 18
    beq t0, a7, Syscall_write_serial # if t0 == a7 then write_seral
    li t0, 20 # t0 = 20
    beq t0, a7, Syscall_get_systime # if t0 == a7 then get_systime
    
    resolvido:
    csrr t0, mepc  # load return address (address of the instruction that invoked the syscall)
    addi t0, t0, 4 # adds 4 to the return address (to return after ecall) 
    csrw mepc, t0  # stores the return address back on mepc

    # restaura o contexto
        
        lw t0, 0(sp) #
        lw t1, 4(sp) 
        lw t2, 8(sp)
        lw t3, 12(sp)
        
        addi sp, sp, 16 # Desaloca espaço na pilha da ISR
        csrrw sp, mscratch, sp # Troca sp com mscratch novamente
  
    mret           # Recover remaining context (pc <- mepc)

Syscall_set_engine_and_steering:
    #a0: Movement direction -> 0 if successful or -1 if error
    #a1: Steering wheel angl
    #a7: 10 

    #faz as verificações
    li t0, -1 # t0 = -1
    blt a0, t0, 1f # if a0 < t0 then 1f
    li t0, 1 # t0 = 1
    bgt a0, t0, 1f # if a0 > t0 then 1f
    li t0, -127 # t0 = -127
    blt a1, t0, 1f # if a0 < t0 then 1f
    li t0, 127 # t0 = 127
    bgt a1, t0, 1f # if a0 > t0 then 1f

    #comanda o veículo

    
    lw t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 0x21(t0) # a posicao 0x21 controla o motor
    sb a1, 0x20(t0) # a posicao 0x20 controla a direcao da roda

    li a0, 0 # a0 = 0
    j resolvido  # jump to resolvido
    
    1: #se falhar retorna -1
    li a0, -1 # a0 = -1
    j resolvido

Syscall_set_handbrake:
    #a0: value stating if the hand brakes must be used.
    #a7: 11

    lw t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 34(t0) #  a posicao 0x22 controla o freio
    

    j resolvido  # jump to resolvido
    

Syscall_read_sensors:
    #a0: address of an array with 256 elements that will store the values read by the luminosity sensor.
    #a7: 12

    # addi sp, sp, -4 # Aloca espaço na pilha da ISR

    #     sw t0, 0(sp) #

    lw t0, BASE_MIMO # t0 = BASE_MIMO
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
    

Syscall_get_position:
    #a0: address of the variable that will store the value of x position. 
    #a1: address of the variable that will store the value of y position.
    #a2: address of the variable that will store the value of z position.
    #a7: 15

    lw t0, BASE_MIMO # t0 = BASE_MIMO
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


Syscall_read_sensor_distance:
    #a0 -> Value obtained on the sensor reading; -1 in case no object has been detected in less than 20 meters.
    #a7: 13

    lw t0, BASE_MIMO # t0 = BASE_MIMO
    li t1, 1 # t1 = 1
    sb t1, 2(t0) #  a posicao 0x02 liga o detector
    1:
        nop
        lb t1, 2(t0) # 
        bne t1, zero, 1b # if t1 != zero then 1b
    1:

    lw a0, 28(t0) # a posição 0x1C detem a leitura do sensor    

    j resolvido

Syscall_get_rotation:
    #a0: address of the variable that will store the value of the Euler angle in x. 
    #a1: address of the variable that will store the value of the Euler angle in y.
    #a2: address of the variable that will store the value of the Euler angle in z
    #a7: 16

    lw t0, BASE_MIMO # t0 = BASE_MIMO
    li t1, 1 # t1 = 1
    sb t1, 0(t0) #  a posicao 0x1 liga o gps
    1:
        nop
        lb t1, 0(t0) # 
        bne t1, zero, 1b # if t1 != zero then 1b
    1:

    lw t1, 4(t0) # le a posição x
    sw t1, 0(a0) # salva a posição x
    lw t1, 8(t0) # le a posição y
    sw t1, 0(a1) # salva a posição y
    lw t1, 12(t0) # le a posição z
    sw t1, 0(a2) # salva a posição z

    j resolvido  # jump to resolvido

Syscall_read_serial:
    #a0: buffer -> Number of characters read.
    #a1: size
    #a7: 17
    #t0: endereço base
    #t1: carregamento
    #t2: 1
    #t3: apoio origem

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
        beq a1, zero, 2f # if a1 == zero then 2f
        j 1b
    1:
    sub a0, t3, a0 # a0 = t3 - a0
    addi a0, a0, -1 # a0 = a0 + -1
    j resolvido

    2:
    sub a0, t3, a0 # a0 = t3 - a0
    
    j resolvido
    

Syscall_write_serial:
    #a0: buffer
    #a1: size
    #a7: 18

    LW t0, BASE_SERIAL #
    li t2, 1 # t2 = 1

    1:
        lb t1, 0(a0) # carrega o byte da vez
        sb t1, 1(t0) # salva para impressão
        sb t2, 0(t0) # imprime 
        
        2: #Espera a escrita terminar
            nop
            lb t1, 0(t0) # 
            bne t1, zero, 2b # if t1 != zero then 2b
        ##
        sb zero, 0(a0) # 
        ##
        addi a0, a0, 1 # a0 = a0 + 1 -- atualiza o endereço
        addi a1, a1, -1 # a1 = a1 + -1 -- atualiza o contador
        bgt a1, zero, 1b # if a1 > zero then 1b
    1:

    j resolvido



Syscall_get_systime:
    #a0 -> Time since the system has been booted, in milliseconds.
    #a7: 20

    lw t0, BASE_GPT # t0 = BASE_GPT
    li t1, 1 # t1 = 1
    sb t1, 0(t0) #  a posicao 0x02 liga o relogio
    1:
        nop
        lb t1, 0(t0) # 
        bne t1, zero, 1b # if t1 != zero then 1b
    1:

    lw a0, 4(t0) # a posição 0x4 detem a leitura do relogio    

    j resolvido


.globl _start
_start:

    la t0, int_handler  # Load the address of the routine that will handle interrupts
    csrw mtvec, t0      # (and syscalls) on the register MTVEC to set the interrupt array.

    .data 
    BASE_GPT: .word 0xFFFF0100
    BASE_MIMO: .word 0xFFFF0300
    BASE_SERIAL: .word 0xFFFF0500

    prog_stack: .word 0x7FFFFFC
    .bss

    fim_irs_stack: .skip 1024
    irs_stack:

    .text

    ##Inicia as pilhas
    lw sp, prog_stack # carrega a pilha para o programa
    la t0, irs_stack # carrega a pilha para as irs
    csrw mscratch, t0 # aponta mscratch para a pilha dedicada as irs



    # Write here the code to change to user mode and call the function user_main (defined in another file).
    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc
    mret # PC <= MEPC; mode <= MPP;
