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

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

int pot(int base, int potencia){
  int result = 1;
  for (int i = 0; i < potencia; i++)
  {
    result *= base;
  }
  return result;
}


void cv_d_b(char v_bin[] , int decimal){}

int le_dec(char v_ent[], int n, int base, int sinal){
  /*  Transforma a entrada de string para inteiro
  Sinal = 0 -> Decimal positivo
  Sinal = 2 -> Decimal negativo */
  int valor = 0;
  for (int i = 0; i < n - sinal; i++){

    if (v_ent[n -i - 1] >= 48 && v_ent[n -i - 1] <= 57){
      valor += (v_ent[n -i -1] - 48) * pot(base, i);
      
    }
    else if(v_ent[n -i - 1] >= 97 && v_ent[n -i - 1] <= 102){
      valor += (v_ent[n -i -1] - 87) * pot(base, i);
    }
    
  }
  return valor;
}
  



int main()
{
  char entrada[32], binario[32], apoio[32];
  int sinal = 0; //Sinal = 0 -> Decimal positivo, Sinal = 2 -> Decimal negativo
  
  /* Read up to 32 bytes from the standard input into the entrada buffer */
  int n = read(STDIN_FD, entrada, 32);
  

  if (entrada[0] != '0'){
    if (entrada[0] != '-'){
      //Caso entrada seja decimal positiva
      
      //Converte para valor decimal
      int dec_ent = le_dec(entrada, n, sinal);
      
      //Converte de decimal para binario
      cv_d_b(binario, dec_ent);



    }
    else{
      //Caso entrada seja decimal negativa
      sinal = 2;
      int dec_ent = le_dec(entrada, n, sinal); 
    }



  } else{
    //Caso hexadecimal
  }
  
  
  
  
  
  
  /* Write n bytes from the entrada buffer to the standard output */
  write(STDOUT_FD, entrada, n);
  return 0;
}