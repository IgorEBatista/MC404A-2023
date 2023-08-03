	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab01.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (64) 
	ecall	
	#NO_APP
.Lfunc_end2:
	.size	exit, .Lfunc_end2-exit

	.globl	calcula
	.p2align	2
	.type	calcula,@function
calcula:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sb	a0, -13(s0)
	sb	a1, -14(s0)
	sb	a2, -15(s0)
	lbu	a0, -15(s0)
	sw	a0, -20(s0)
	li	a1, 42
	beq	a0, a1, .LBB3_5
	j	.LBB3_1
.LBB3_1:
	lw	a0, -20(s0)
	li	a1, 43
	beq	a0, a1, .LBB3_4
	j	.LBB3_2
.LBB3_2:
	lw	a0, -20(s0)
	li	a1, 45
	bne	a0, a1, .LBB3_6
	j	.LBB3_3
.LBB3_3:
	lbu	a0, -13(s0)
	lbu	a1, -14(s0)
	sub	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB3_7
.LBB3_4:
	lbu	a1, -13(s0)
	lbu	a0, -14(s0)
	add	a0, a0, a1
	addi	a0, a0, -96
	sw	a0, -12(s0)
	j	.LBB3_7
.LBB3_5:
	lbu	a0, -13(s0)
	addi	a0, a0, -48
	lbu	a1, -14(s0)
	addi	a1, a1, -48
	mul	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB3_7
.LBB3_6:
	li	a0, 0
	sw	a0, -12(s0)
	j	.LBB3_7
.LBB3_7:
	lw	a0, -12(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	calcula, .Lfunc_end3-calcula

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -12(s0)
	lui	a1, %hi(buffer)
	sw	a1, -24(s0)
	addi	a1, a1, %lo(buffer)
	sw	a1, -28(s0)
	li	a2, 10
	call	read
	lw	a2, -28(s0)
	mv	a1, a0
	lw	a0, -24(s0)
	sw	a1, -16(s0)
	lbu	a0, %lo(buffer)(a0)
	lbu	a1, 4(a2)
	lbu	a2, 2(a2)
	call	calcula
	lw	a1, -24(s0)
	mv	a2, a0
	lui	a0, %hi(resultado)
	sw	a2, %lo(resultado)(a0)
	lw	a0, %lo(resultado)(a0)
	addi	a0, a0, 48
	sb	a0, %lo(buffer)(a1)
	li	a0, 1
	sw	a0, -20(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a1, -20(s0)
	li	a0, 4
	blt	a0, a1, .LBB4_4
	j	.LBB4_2
.LBB4_2:
	lw	a1, -20(s0)
	lui	a0, %hi(buffer)
	addi	a0, a0, %lo(buffer)
	add	a1, a0, a1
	li	a0, 0
	sb	a0, 0(a1)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB4_1
.LBB4_4:
	lui	a0, %hi(buffer)
	addi	a1, a0, %lo(buffer)
	li	a0, 1
	li	a2, 6
	call	write
	li	a0, 0
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	exit
.Lfunc_end5:
	.size	_start, .Lfunc_end5-_start

	.type	buffer,@object
	.bss
	.globl	buffer
buffer:
	.zero	10
	.size	buffer, 10

	.type	resultado,@object
	.section	.sbss,"aw",@nobits
	.globl	resultado
	.p2align	2
resultado:
	.word	0
	.size	resultado, 4

	.ident	"clang version 15.0.7 (Fedora 15.0.7-1.fc37)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym exit
	.addrsig_sym calcula
	.addrsig_sym main
	.addrsig_sym buffer
	.addrsig_sym resultado
