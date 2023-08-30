// int read(int __fd, const void *__buf, int __n){
//     int ret_val;
//   __asm__ __volatile__(
//     "mv a0, %1           # file descriptor\n"
//     "mv a1, %2           # buffer \n"
//     "mv a2, %3           # size \n"
//     "li a7, 63           # syscall write code (63) \n"
//     "ecall               # invoke syscall \n"
//     "mv %0, a0           # move return value to ret_val\n"
//     : "=r"(ret_val)  // Output list
//     : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
//     : "a0", "a1", "a2", "a7"
//   );
//   return ret_val;
// }

// void write(int __fd, const void *__buf, int __n)
// {
//   __asm__ __volatile__(
//     "mv a0, %0           # file descriptor\n"
//     "mv a1, %1           # buffer \n"
//     "mv a2, %2           # size \n"
//     "li a7, 64           # syscall write (64) \n"
//     "ecall"
//     :   // Output list
//     :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
//     : "a0", "a1", "a2", "a7"
//   );
// }

// void exit(int code)
// {
//   __asm__ __volatile__(
//     "mv a0, %0           # return code\n"
//     "li a7, 93           # syscall exit (64) \n"
//     "ecall"
//     :   // Output list
//     :"r"(code)    // Input list
//     : "a0", "a7"
//   );
// }

#define STDIN_FD  0
#define STDOUT_FD 1

#include <stdio.h>

int pot(int base, int potencia){
  int result = 1;
  for (int i = 0; i < potencia; i++)
  {
    result *= base;
  }
  return result;
}

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;
    
    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    // write(1, hex, 11);

    printf("%s", hex);
}

void pack(int input, int start_bit, int end_bit, unsigned int val){

    int mascara = 0, alinhado;

    for (int i = 0;  i <= end_bit - start_bit; i++) {
        mascara += pot(2, i);
    }
    
    alinhado = input & mascara;
    alinhado = alinhado << start_bit;

    val += alinhado;

}

int le_str(char leitura[6]){
    int numero = 0;

    for (int i = 4; i > 0; i--) {
        numero += leitura[i] * pot(10, (4-i));
    }
    
    if (leitura[0] == '-') {
        numero *= -1;
    }
    
    return numero;
}

int main(){

    char entrada[6] = "000000";
    int inteiros[5] = {1111, 1111, 1111, 1111, 1111};
    unsigned int final = 0;
    
    //Transforma a entrada em inteiros

    // for (int i = 0; i < 5; i++) {
    //     int n = read(STDIN_FD,entrada,6);
    //     inteiros[i] = le_str(entrada);
    // }


    
    //Junta os binarios
    pack(inteiros[0], 0, 2, final);
    pack(inteiros[1], 3, 10, final);
    pack(inteiros[2], 11, 15, final);
    pack(inteiros[3], 16, 20, final);
    pack(inteiros[4], 21, 31, final);

    hex_code(final);

    return 0;
}

// void _start() {
//   int ret_code = main();
//   exit(ret_code);
// }