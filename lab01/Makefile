lab01.s: lab01.c
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab01.c -S -o lab01.s

lab01.o: lab01.s
	clang-15 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab01.s -c -o lab01.o

lab01.x: lab01.o 
	ld.lld lab01.o -o lab01.x