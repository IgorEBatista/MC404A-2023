
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
    lw t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 33(t0) # a posicao 0x21 controla o motor
    sb a1, 32(t0) # a posicao 0x20 controla a direcao da roda

    li a0, 0 # a0 = 0
    j resolvido  # jump to resolvido
    
    1: #se falhar retorna -1
    li a0, -1 # a0 = -1
    j resolvido

set_handbrake:
    #a0: value stating if the hand brakes must be used.
    #a7: 11

    lw t0, BASE_MIMO # t0 = BASE_MIMO
    sb a0, 34(t0) #  a posicao 0x22 controla o freio
    
    j resolvido  # jump to resolvido
    

read_sensors:
    #a0: address of an array with 256 elements that will store the values read by the luminosity sensor.
    #a7: 12

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
    

get_position:
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

Syscall_get_rotation:
    #a0: address of the variable that will store the value of the Euler angle in x. 
    #a1: address of the variable that will store the value of the Euler angle in y.
    #a2: address of the variable that will store the value of the Euler angle in z
    16

Syscall_read_serial:
a0: buffer
a1: size
17

Syscall_write_seral:
a0: buffer
a1: size
18

Syscall_get_systime:
    #a0 
    #a7: 20