Ex. 4.1: Number Base Conversion in C

Instructions:
Write a C program that reads a number from the user input in either hexadecimal or decimal format and converts it to binary, decimal, and hexadecimal representations. The program should handle both positive and negative numbers.

Your program must read a series of characters encoded in ASCII format from the standard input (STDIN). These characters will represent a number in either decimal or hexadecimal format. Below, you will find the necessary functions for reading/writing information from/to the standard input/output., along with a concise illustration of how they can be utilized:

Input:
A 32-bit number represented by a string of up to 10 characters, followed by a newline character ("\n").
If the string represents a number in the hexadecimal base, it will start with characters "0x".
Otherwise, it will start with a number from 1 to 9 or with the minus sign (-), indicating that the number to be read is negative.
Note: The minus sign (-) will not be used in inputs in hexadecimal representation (e.g., -0x12 is not a valid input).

Output:
After reading the 32-bit number, you should print the following information followed by newline characters:
The value in binary base preceded by "0b". If the number is negative, you must display the value in two's complement representation (as illustrated in the third example below);
The value in decimal base assuming that the 32-bit number is encoded in two's complement representation (In this case, if the most significant bit is 1, the number is negative);
The value in hexadecimal base preceded by "0x". If the number is negative, you must show the value in two's complement representation (as illustrated in the third example below);
The value in decimal base assuming that the 32-bit number is encoded in unsigned representation and its endianness has been swapped;
For example, assuming the 32-bit number 0x00545648 was entered as input, after the endian swap, the number becomes 0x48565400, and its decimal value is 1213617152.
