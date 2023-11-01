.text
.globl _start
_start:
    
    .bss
    stack: .skip 1024
    dedicada: .skip 1024
    .data
    .globl _system_time
    _system_time: .word 0
    
    .text
    la sp, stack # 
    addi sp, sp, 1024 # sp = sp + 1024 -- corrige o apontador para pilha descendente cheia

    la t0, dedicada # 
    addi t0, t0, 1024 # t0 = t0 + 1024 -- corrige o apontador
    csrw mscratch, t0 # aponta mscratch para a pilha dedicada as irs

    la t0, main_isr # Carrega o endereço da main_isr
    csrw mtvec, t0 # em mtvec

    # Habilita Interrupções Externas
    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1
    
    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 3 (MIE)
    ori t1, t1, 0x8 # do registrador mstatus
    csrw mstatus, t1



    li t0, 0xFFFF0100 # t0 = 0xFFFF0100 -- carrega o endereço base do GPT
    # li t2, 0 # t2 = 0
    # sw t2, 4(t0) # zera o cronometro (deve iniciar zerado)
    li t2, 100 # t2 = 100
    sw t2, 8(t0) # programa a próxima interrupção 

    jal main  # jump to main and save position to ra

.globl exit
    exit:
    li a7, 93           # syscall exit (93) \n
    ecall


main_isr:
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
        sw x10, 36(sp) # Salva x10
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
    
    # trata a interrupção
    li t0, 0xFFFF0100 # t0 = 0xFFFF0100 -- carrega o endereço base do GPT
    la t1, _system_time # 

    lw t2, 0(t1) # 
    li t3, 100 # t2 = 100 avança o contador de tempo a cada interreupção
    add t2, t2, t3 # t2 = t2 + t3
    sw t2, 0(t1) # 
    
    
    sw t3, 8(t0) # programa a próxima interrerupção

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
        lw x10, 36(sp) # Salva x10
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

    mret



.globl play_note
play_note:
    #a0: channel (int) -> byte
    #a1: intrument id (int) -> short
    #a2: musical note (int) -> byte
    #a3: note velocity (int) -> byte
    #a4: note duration (int) -> short

    li t0, 0xFFFF0300 # t0 = 0xFFFF0300 -- carrega o endereço base do syntetizer

    sh a4, 6(t0) #define a duração da nota
    sb a3, 5(t0) #define a velocidade da nota
    sb a2, 4(t0) #define qual a nota musical
    sh a1, 2(t0) #define o id do instrumento
    sb a0, 0(t0) #define o canal e inicia a reprodução

    ret