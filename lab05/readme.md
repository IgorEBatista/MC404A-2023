Ex. 6.1: Bit Masking and Shift operations
Instructions:
Write a C program that reads 5 numbers from the user input in decimal format and packs its bits to a single 32 bit value that will be written to the standard output as a hexadecimal value. The program should handle both positive and negative numbers. 

A function with the signature void pack(int input, int start_bit, int end_bit, int *val) might be a good start for this exercise.

The previously presented functions read and write can be used for reading/writing information from/to the standard input/output. The code snippet below can be used to write the resulting hexadecimal value to STDOUT (note that it uses the write function).

Input
5 signed 4-digit decimal numbers separated by spaces (' '), followed by a newline character ('\n'). The whole input takes up 30 bytes.
String Format - "SDDDD SDDDD SDDDD SDDDD SDDDD\n"
S: sign, can be either '+' for positive numbers and '-' for negative.
D: a decimal digit, (0-9)
Output:
After reading all 5 numbers, you must pack their least significant bits (LSB) following the rules listed below:
1st number: 3 LSB => Bits 0 - 2
2nd number: 8 LSB => Bits 3 - 10
3rd number: 5 LSB => Bits 11 - 15
4th number: 5 LSB => Bits 16 - 20
5th number: 11 LSB => Bits 21 - 31


Ex. 6.2: RISC-V Instruction Encoding
Instructions:
Write a C program that reads a string with a RISC-V instruction from STDIN, parses its content in a way of obtaining its fields, packs the instruction's fields in a 32 bit value and writes the hexadecimal representation of the instruction to STDOUT.

The code snippet below can be used to compare strings as standard C libraries such as string.h are not available in the simulator. It is similar to string.h's strcmp but it has the number of characters to be compared as a parameter.
int strcmp_custom(char *str1, char *str2, int n_char){
    for (int i = 0; i < n_char; i++){
        if (str1[i] < str2 [i])
            return -1;
        else if (str1[i] > str2 [i])
            return 1;
    }    
    return 0;
}


The set of instructions that need to be encoded by your program is presented in the table below, alongside its opcode, instruction type and other fields (e.g. funct3 and funct7) if applicable.

Input
RV32I assembly instruction string with at most 40 bytes. There will be no pseudo-instructions and the registers will be referenced with their x-name (e.g. x2, x10)
Output:
The 32 bit encoded instruction in its Big Endian hexadecimal representation (hex_code() from the previous exercise can be used).
