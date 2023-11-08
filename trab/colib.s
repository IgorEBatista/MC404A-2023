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


.globl gets
gets:
    #a0: buffer -> Number of characters read.
    #a1: size
    #a7: 17
    #t0: endereço base
    #t1: carregamento
    #t2: 1
    #t3: apoio origem


#a0: endereço da string a ser guardada -> file descriptor
    #a1: -> endereço da string 
    # a2 numero de bits a serem lidos ( 1)
    # a6 inicio da string
    #t1: byte da vez
    #t2: '\n'
    mv  a1, a0 # a1 = a0
    mv  a6, a0 # a6 = a0
    li t2, 10 # t2 = 10
    # la a1, i #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    1:
        li a0, 0  # file descriptor = 0 (stdin)
        ecall
        lb t1, 0(a1) # 
        beq t1, t2, 1f # if t1 == t2 then 1f
        addi a1, a1, 1 # a1 = a1 + 1

        j 1b  
    1:
    li t1, 0 # t1 = 0
    sb t1, 0(a1) # 
    mv  a0, a6 # a0 = a6
    ret

.globl atoi
atoi:


.globl itoa
itoa:


.globl strlen_custom
strlen_custom:


.globl approx_sqrt
approx_sqrt:


.globl get_distance
get_distance:


.globl fill_and_pop
fill_and_pop: