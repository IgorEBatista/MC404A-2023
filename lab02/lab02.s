.globl _start

_start:
  li a0, 260511  #<<<=== Academic Record number (RA)
  li a1, 0
  li a2, 0
  li a3, -1
loop:
  andi t0, a0, 1
  add  a1, a1, t0
  xor  a2, a2, t0
  addi a3, a3, 1
  srli a0, a0, 1
  beq  a1, a2, teste1
  bnez a0, loop

teste1:
    bnez a1, fim
    beqz a1, loop

fim:
   ecall

end:
  la a0, result
  sw a1, 0(a0)
  li a0, 0
  li a7, 93
  ecall

result:
  .word 0
