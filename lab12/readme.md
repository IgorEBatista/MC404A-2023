# Ex. 8.2: Accessing Peripherals - Using Serial Port
Instructions:
In this activity, you will communicate with the Serial Port device via MMIO. You will need to read a stream of bytes from the Serial Port and then perform an operation on top of the data read. 
Interactions with Serial Port can be done through two memory addresses:
* base+0x00: storing the value 1 triggers a write, writing the byte that is stored at base+0x01. The byte at base+0x00 is set to 0 when write is complete.
* base+0x02: storing the value 1 triggers a read, reading one byte and storing it at base+0x03. The byte at base+0x02 is set to 0 when read is complete.

There will be 4 different sets of operations to perform:
* Operation 1: read a string and write it back to Serial Port
    * Input: 1\n{string with variable size}\n
    * Output: {string with variable size}\n
* Operation 2: read a string and write it back to Serial Port reversed
    * Input: 2\n{string with variable size}\n
    * Output: {string with variable size reversed}\n
* Operation 3: read a number in decimal representation and write it back in hexadecimal representation.
    * Input: 3\n{decimal number with variable size}\n
    * Output: {number in hexadecimal}\n
* Operation 4: read a string that represents an algebraic expression, compute the expression and write the result to Serial Port.
    * Input: 4\n{number with variable size} {operator} {number with variable size}\n
    * Output: {operation result in decimal representation}\n
    * Operator can be + (add) , - (sub), * (mul) or / (div)

Examples:

Input:
1
Random String
Output:
Random String


Input:
2
Reversed String
Output:
gnirtS desreveR


Input:
3
1876
Output:
754


Input:
4
244 + 67
Output:
311


Input:
4
2340 / 50
Output:
46


Notes and Tips:
* You can debug your program reading from STDIN and writing to STDOUT. Before testing with the Assistant, the functions responsible for IO need to be changed in order to interact with the Serial Port.
* The final version of your program can't use syscalls except for the exit syscall.
* You can use the program stack to store strings with variable sizes.
* You can test your code using the simulator's assistant from this link.
