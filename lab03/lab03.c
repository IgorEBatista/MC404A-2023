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

int int_str(unsigned long int numero, char string[], int sinal){
  //Transforma o int numa string, e retorna o tamanho da string utilizada
  unsigned long int apoio = numero;
  char temp[32];
  int tam = 0;
  for (int i = 0; apoio > 0; i++) {
    int digito  = apoio % 10;
    temp[i] = digito + '0';
    apoio = (apoio - digito)/10;
    tam = i;
  }
  for (int i = 0; i < tam; i++) {
    string[i + sinal] = temp[tam - i];
  }

  if (sinal) {
    string[0] = '-';
  }
  
  return tam +1 + sinal;  
}

unsigned long int str_int(char v_ent[], int tam, int base, int parada){
  /*  Transforma a entrada de string para inteiro na base 10
  parada é o número de digitos que devem ser ignorados no início da string */
  unsigned long int valor = 0;

  for (int i = 0; (tam -i - 1) >= parada; i++){

    if (v_ent[tam -i - 1] >= 48 && v_ent[tam -i - 1] <= 57){
      valor += (v_ent[tam -i -1] - 48) * pot(base, i);
      
    }
    else if(v_ent[tam -i - 1] >= 97 && v_ent[tam -i - 1] <= 102){
      valor += (v_ent[tam -i -1] - 87) * pot(base, i);
    }
    
  }
  return valor;
}
  
int hex_dec(char bin[], int tam){
  return str_int(bin, tam, 16, 0);
}

int bin_dec(char bin[], int tam, int sinal){
  return str_int(bin, tam, 2, sinal);
}

void dec_hex(int dec, char hex){

  if (dec < 10){
    hex = dec;
  }
  else{
    hex = 87 + dec;
  }
  

}

void bin_hex(char bin[34], char hex[34]){
  hex[0] = '0';
  hex[1] = 'x';
  char apoio[4] = "0000";
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < 4; j++){
      apoio[j] = bin[(4*i) + j + 2];
    }

    dec_hex(bin_dec(apoio, 4, 0), hex[i + 2]);

  }
}

void dec_bin(int dec, char bin[34]){
  int apoio = dec, i = 33;
  bin[0] = '0';
  bin[1] = 'b';
  while (apoio != 0 && i > 1 ) {
    bin[i] = apoio % 2;
    apoio /= 2;
    i--;
  }
}

void inv_bin(char bin[], int tam){
  int inicio = 0;
  if (tam == 33) {
    inicio = 2;
  }
  for (int i = inicio; i < 32 + inicio; i++) {
    if (bin[i] == '0') {
      bin[i] = '1';
    } else {
      bin[i] = '0';
    } 
  } 

}

void swap_bin(char bin[34], char saida[32]) {

  for (int i = 2; i < 34; i++) {
    saida[i + ((3 - (2*((i-2)/8))) * 8)] = bin[i-2];
  }
  inv_bin(saida, 31);
}

int main() {
  char entrada[33], binario[34], hexa[34], uns_bin[32], apoio[34];
  char s_dec[34], s_longo[34];
  unsigned long int longo = 0;
  int negativo = 0; //Valor booleano que define o sinal trabalhado
  int dec_ent = 0;

  
  /* Read up to 33 bytes from the standard input into the entrada buffer */
  int n = read(STDIN_FD, entrada, 33);
  

  if (entrada[0] != '0') {
      //Caso entrada seja decimal
    if (entrada[0] != '-') {
      // Positiva
      
      //Converte para valor decimal
      dec_ent = str_int(entrada, n, 10, 0);
      
      //Converte de decimal para binario
      dec_bin(dec_ent, binario);

      //Converte de binario para hexadecimal
      bin_hex(binario, hexa);

      //Faz o swap e inverte o binário
      swap_bin(binario, uns_bin);

      longo = str_int(uns_bin, 32, 2, 0);
  
    }  else {
      //Caso entrada seja decimal negativa
      negativo = 1;
      dec_ent = str_int(entrada, n, 10, 1);

      //Converte de decimal para binario em complemento de 2
      dec_ent --;
      dec_bin(dec_ent, binario);
      inv_bin(binario, 33);

      //Converte de binario para hexadecimal
      bin_hex(binario, hexa);

      //Faz o swap e inverte o binário
      swap_bin(binario, uns_bin);

      longo = str_int(uns_bin, 32, 2, 0);
    }
  } else {
    //Caso hexadecimal

    //Converte para valor decimal
      dec_ent = str_int(entrada, n, 16, 2);
      
      //Converte de decimal para binario
      dec_bin(dec_ent, binario);

      //Converte de binario para hexadecimal
      bin_hex(binario, hexa);

      //Faz o swap e inverte o binário
      swap_bin(binario, uns_bin);

      longo = str_int(uns_bin, 32, 2, 0);
  }
  
  //Torna o decimal imprimível
  int tam_dec = int_str(dec_ent, s_dec, negativo);
  s_dec[tam_dec] = '\n';
  
  //Torna o binário imprimível

  binario[34] = '\n';
  int posicao = 2, tam_bin = 0;
  
  while (binario[posicao] == '0') {
    posicao++;
  }

  for (int i = 0; binario[posicao + i -1] != '\n'; i++) {
    binario[2 + i] = binario[posicao + i];
    tam_bin = 2 + i;
  }
  
  // Torna o Hexadecimal imprimível
  hexa[34] = '\n';
  posicao = 2;
  int tam_hexa = 0;
  
  while (hexa[posicao] == '0') {
    posicao++;
  }

  for (int i = 0; hexa[posicao + i -1] != '\n'; i++) {
    hexa[2 + i] = hexa[posicao + i];
    tam_hexa = 2 + i;
  }

  // Torna o longo imprimível
  int tam_long = int_str(longo, s_longo, 0);
  s_longo[tam_long] = '\n';

  //Imprime os valores

  write(STDOUT_FD, s_dec, tam_dec);
  write(STDOUT_FD, binario, tam_bin);
  write(STDOUT_FD, hexa, tam_hexa);
  write(STDOUT_FD, s_longo, tam_long);
  
  return 0;
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}
