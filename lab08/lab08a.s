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
    ##Constrói a cor, e pinta o pixel designado
    # a0: pixel's x coordinate
    # a1: pixel's y coordinate
    # a2: concatenated pixel's colors: R|G|B|A
        # A2[31..24]: Red
        # A2[23..16]: Green
        # A2[15..8]: Blue
        # A2[7..0]: Alpha
    # a7: 2200 (syscall number)
    # Constroi a cor
    li t0, 0 # t0 = 0 zera um temporário
    or t0, t0, a2 #adiciona a primeira parcela da cor
    slli t0, t0, 8
    or t0, t0, a2 #adiciona a segunda parcela da cor
    slli t0, t0, 8
    or t0, t0, a2 #adiciona a terceira parcela da cor
    slli t0, t0, 8
    mv  a2, t0 # a2 = t0 -- configura a impressão da cor
    li t0, 0xFF # t0 = 0xFF
    or a2, a2, t0
    # Imprime
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
    #a0 -> a3: endereco do byte atual  // a0: Cord atual x
    #a1 -> a4: largura da imagem // a1: Cord atual y
    #a2 -> a5: altura da imagem // a2: Cor base pixel atual
    #t0: apoio cria cor
    #t6: endereço de retorno (ra)

    mv  a3, a0 # a3 = a0
    mv  a4, a1 # a4 = a1
    mv  a5, a2 # a5 = a2

    li a0, 0 # a0 = 0 coord de x
    li a1, 0 # a1 = 0 coord de y
    mv  t6, ra # t6 = ra -- salva endereço de retorno

    1:
        #Loop para cada linha
        2:
            #Loop para cada coluna em uma linha
            lb a2, 0(a3) # carrega o byte da vez
            jal setPixel  # jump to setPixel and save position to ra
            addi a0, a0, 1 # a0 = a0 + 1 -- atualiza a coord x
            addi a3, a3, 1 # a3 = a3 + 1 -- atualiza o endereço do byte da vez
            bne a0, a4, 2b # if a0 != a4 then 2b    
        
        li a0, 0 # a0 = 0 - reseta coord de x
        addi a1, a1, 1 # a1 = a1 + 1 -- atualiza coord de y
        bne a1, a5, 1b # if a1 != a5 then 1b
    
    mv  ra, t6 # ra = t6 -- usa endereço de retorno
    ret

leCoisas:
    #a0: inicio do cabecalho -> inicio da imagem
    #a4: byte da vez
    #t0: valor acumulado
    #t1: endereço para salvar os dados
    #t2: fase do loop
    li a1, 32 # a1 = 32 -- carrega o espaco para comparação
    li a2, 10 # a1 = 32 -- carrega o \n para comparação (e o valor 10 para multiplicação)
    li a3, 48 # a3 = 48 -- carrega o '0', para facilitar a conversão
    li t0, 0 # t0 = 0 -- zera o valor acumulado
    li t2, 0 # t2 = 0 -- zera a fase

    addi a0, a0, 3 # a0 = a0 + 3 -- skipa o numero magico
    
    #leLargura_Altura:
    2:
        #Na primeira iteração do loop externo, le largura, depois le altura
        la t1, largura # carrega o endereço para salvar a largura
        beq t0, zero, 1f # if t0 == zero then 1f
        addi t2, t2, 5 # t2 = t2 + 5
        la t1, altura # carrega o endereço para salvar a largura
        li t0, 0 # t0 = 0 -- zera o valor acumulado
        beq t2, a2, 2f # if t2 == a2 then 2f
        
        1:
            lb a4, 0(a0) # carrega o byte da vez
            addi a0, a0, 1 # a0 = a0 + 1
            beq a4, a1, 1f # if a4 == a1 then 1f -- Verifica se é o espaço
            beq a4, a2, 1f # if a4 == a2 then 1f -- Verifica se é um \n
            add a4, a4, a3 # a4 = a4 + a3 -- converte em numero
            mul t0, t0, a2 # Multiplica o valor anterior por 10
            add t0, t0, a4 # t0 = t0 + a4 -- adiciona o novo digito ao total
            j 1b  # jump to 1b
        1:
        
        sb t0, 0(t1) # salva a largura
        j 2b  # jump to 2b
    2:
    addi a0, a0, 4 # a0 = a0 + 4 -- skipa o max value (255 por padrão)
    ret

main:
    # j a
    jal openFile # jump to open and save position to ra
    mv s0, a0 # s0 = a0 - salva o file path
    
    la a2, TAM # 
    lw a2, 0(a2) # 
    jal read  # jump to read and save position to ra -- lê o arquivo completo

    la s0, input # carrega o inicio do cabeçalho
    mv  a0, s0 # a0 = s0 - passa o endereço de inicio
    jal leCoisas  # jump to leCoisas and save position to ra
    
    mv  s1, a0 # s1 = a0 -- salva o endereço de inicio da imagem em s1


    
    
    
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
    li a2, 4 # a2 = 4
    jal read  # jump to read and save position to ra
    jal write

    #set tamanho canva
    la t0, largura # 
    lw a0, 0(t0) # 
    la t1, altura # 
    lw a1, 0(t1) # 
    jal setCanvasSize
    
    #Lê imagem
    mv a0, s0 # a0 = s0
    la t0, largura # 
    lw a1, 0(t0) # 
    la t1, altura # 
    lw a2, 0(t1) # 
    jal renderiza  # jump to renderiza and save position to ra
    
    j exit
    ret

.data

input_file: .asciz "image.pgm" # não bota um /0 no final, tem que testar se dá certo

TAM: .word 262.144
_largura: .word 16
_altura: .word 9

# input: .word 0

.bss
largura: .skip 4
altura: .skip 4
input: .skip 262.144