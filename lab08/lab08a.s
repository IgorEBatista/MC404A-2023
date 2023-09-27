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
    # li a0, 0  # file descriptor = 0 (stdin)
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

setPixel:
    # a0: pixel's x coordinate
    # a1: pixel's y coordinate
    # a2: concatenated pixel's colors: R|G|B|A
        # A2[31..24]: Red
        # A2[23..16]: Green
        # A2[15..8]: Blue
        # A2[7..0]: Alpha
    # a7: 2200 (syscall number)
    # li a0, 100 # x coordinate = 100
    # li a1, 200 # y coordinate = 200
    # li a2, 0xFFFFFFFF # white pixel
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret

setCanvasSize:
    # a0: canvas width (value between 0 and 512)
    # a1: canvas height (value between 0 and 512)
    # a7: 2201 (syscall number)
    li a7, 2201 # a7 = 2201
    ecall
    ret

setScaling:
    # a0: horizontal scaling
    # a1: vertical scaling
    # a7: 2202 (syscall number)

openFile:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall
    ret


renderiza:
    #a0: s11: file path
    #a1: s10: largura da imagem
    #a2: s9: altura da imagem
    #s1: endereço dos bits
    la s1, input # 
    
    mv  s11, a0 # s11 = a0
    mv  s10, a1 # s10 = a1
    mv  s9, a2 # s9 = a2
    li t2, 0 # t2 = 0 contador de vetor
    li t4, 0 # t4 = 0 contador de x
    li t5, 0 # t5 = 0 contador de y
    mv  t6, ra # t6 = ra -- salva endereço de retorno
    1:
        mv  a0, s11 # a0 = s11
        mv a2, s10 # a2 = s10
        jal read  # jump to read and save position to ra
        mv  s8, s1 # s8 = s1
        2:
            lb t1, 0(s8) # 
            # li t1, 0x000000ff # t1 = 0x000000ff
            
            
            mv  a0, t4 # a0 = t4 - coord atual x
            mv  a1, t5 # a1 = t5 - coord atual y
            mv  a2, t1 # a2 = t1 - cor do pixel
            jal setPixel  # jump to setPixel and save position to ra
            
            addi t4, t4, 1; # t4 = t4 + 1
            addi s8, s8, 1; # s8 = s8 + 1

            bne t4, s10, 2b # if t4 != s10 then 2b    
        li t4, 0 # t4 = 0 - reseta contador de x
        addi t5, t5, 1; # t5 = t5 + 1
        bne t5, s9, 1b # if t5 != s9 then 1b
    mv  ra, t6 # ra = t6 -- usa endereço de retorno
    ret

main:

    jal openFile # jump to open and save position to ra
    mv  s0, a0 # s0 = a0 - salva o file path
    #set coisas
    #Lê o numero magico
    li a2, 3 # a2 = 3
    jal read  # jump to read and save position to ra
    jal write
    #Lê altura
    li a2, 3 # a2 = 3
    jal read  # jump to read and save position to ra
    jal write
    
    #Lê largura
    li a2, 2 # a2 = 2
    jal read  # jump to read and save position to ra
    jal write
    
    #Lê MaxColor
    li a2, 3 # a2 = 3
    jal read  # jump to read and save position to ra
    jal write

    #set tamanho canva
    la t0, largura # 
    lw a0, 0(t0) # 
    la t1, altura # 
    lw a1, 0(t1) # 
    jal setCanvasSize
    

    #Lê imagem
    mv  a0, s0 # a0 = s0
    la t0, largura # 
    lw a1, 0(t0) # 
    la t1, altura # 
    lw a2, 0(t1) # 
    jal renderiza  # jump to renderiza and save position to ra
    
    j exit
ret

.data

input_file: .asciz "image.pgm" # não bota um /0 no final, tem que testar se dá certo

altura: .word 7
largura: .word 24

.bss

input: .skip 25