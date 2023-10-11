la a0, a # 
la a1, b # 
sw a1, 4(a0) # 

li a1, 5 # a1 = 12


.globl recursive_tree_search
recursive_tree_search:
    #a0: endereço do primeiro nó -> valor de retorno
    #a1: valor buscado
    #t0: endereço do nó da vez
    #t1: valor do nó da vez

    addi sp, sp, -4  # Salva enrdereço de ra na pilha do programa
    sw   ra, 0(sp)

    #Verifica se é o valor indicado
        lw t1, 0(a0) # 
        bne a1, t1, 1f # if a1 != t1 then 1f
        
        #Caso sim, retorna 1
        li a0, 1 # a0 = 1
        j 6f  # jump to 6f
        
        1:
        #Empilha os próximos endereços
        addi sp, sp, -8  # Salva os endereços dos nós na pilha do programa
        lw t0, 4(a0) # 
        sw   t0, 4(sp)
        lw t0, 8(a0) # 
        sw   t0, 0(sp)
        #Caso não, verifica se é o filho da direita
            lw a0, 0(sp) # carrega o endereço do filho da direita 
            addi sp, sp, 4
            beq a0, zero, 2f # if a0 == zero then 2f -- se não tiver esse filho, segue em frente
            jal recursive_tree_search  # jump to recursive_tree_search and save position to ra
            
            #Caso retorne 0, segue
            beq a0, zero, 2f # if a0 == zero then 2f
            
            #Caso retorne diferente de zero, retorna o valor + 1
            addi a0, a0, 1 # a0 = a0 + 1
            addi sp, sp, 4 # desempilha o outro nó não utilizado
            j 6f  # jump to 6f
            
        2:
        #Caso não, verifica se é o filho da esquerda    
            lw a0, 0(sp) # carrega o endereço do filho da esquerda 
            addi sp, sp, 4
            beq a0, zero, 3f # if a0 == zero then 3f -- se não tiver esse filho, segue em frente
            jal recursive_tree_search  # jump to recursive_tree_search and save position to ra
            
            #Caso retorne 0, segue
            beq a0, zero, 3f # if a0 == zero then 3f

            #Caso retorne diferente de zero, retorna o valor + 1
            addi a0, a0, 1 # a0 = a0 + 1
            j 6f  # jump to 6f
        
        3:
        #Em último caso, retorna 0
        li a0, 0 # a0 = 0
        
    
    6:
    lw   ra, 0(sp)    # Recupera endereço de ra da pilha
    addi sp, sp, 4
    ret
        

.data
a: .word 12,0,0
b: .word 5,0,0