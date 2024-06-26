int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code){
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}


#define STDIN_FD  0
#define STDOUT_FD 1

/* Aloca um buffer com 10 bytes.*/
char buffer[10];

int resultado;

/* Calcula o resultado da operação. */
int calcula(char dado1, char dado2, char opera){
  char result;
  switch (opera){
    case '-' :
    return (dado1 - '0' ) - (dado2 - '0');
    
    case '+' :
    return (dado1 - '0' ) + (dado2 - '0');
    
    case '*' :
    return (dado1 - '0' ) * (dado2 - '0');

    default:
    return 0;
  }
}

int main()
{
  /* Lê a entrada */
  int n = read(STDIN_FD, (void*) buffer, 10);

  resultado = calcula(buffer[0], buffer[4], buffer[2]);
 
  /* Sobreescreve a entrada */
  buffer[0] = resultado + 48;
  
  for (int i = 1; i < 5; i++){
      buffer[i] = 00;
    }
  
  /* Imprime o resultado sobreescrito a entrada */
  write(STDOUT_FD, (void*) buffer, 6);

  return 0;
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}