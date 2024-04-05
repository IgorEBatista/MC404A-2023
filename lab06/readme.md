Ex. 7.1: Square Root --- lab06a.s
Instructions:
Write a program in RISC-V assembly language that computes the approximated square root of integers.

To perform read and write of data from/to the terminal, you must use the read and write syscalls (similarly to exercise 4.1, but now in assembly language)

read syscall example:

    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

input_address: .skip 0x10  # buffer


write syscall example:

    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall    
string:  .asciz "Hello! It works!!!\n"


Input
    Four 4-digit decimal numbers separated by spaces (' '), followed by a newline character ('\n'). The whole input takes up 20 bytes.
        String Format - "DDDD DDDD DDDD DDDD\n"
        D: a decimal digit, (0-9)
Output:
For each 4-digit number read, you must compute its approximate square root and write its value to STDOUT using 4-digits and each square root must be separated by a space (' ') and the last one is followed by a newline character ('\n'), so the output will also take up 20 bytes.
    String Format - "DDDD DDDD DDDD DDDD\n"
    D: a decimal digit, (0-9)

Examples:

Input:
0400 5337 2240 9166
Output:
0020 0073 0047 0095


Notes and Tips:
The usage of Babylonian method with 10 iterations is recommended. Considering that we want to compute the square root of a number y, the basic idea of this method is:
Compute an initial guess for the square root:

Approximate your estimative, k, to the real value of the square root by applying the following equation:

Each time the above equation is applied is considered "one iteration". For this exercise, use 10 iterations.
For this exercise, approximate solutions are accepted.
Solutions with an absolute error smaller than 10 will be considered correct.
Other methods to square root approximation can be used, as long as:
It used only integers. Floating point numbers or the RISC-V square root instruction cannot be used.
The approximation is as or more precise than the suggested method.


Ex. 7.2: GPS  --- lab06b.s
Instructions:
In this activity, you must write a program in RISC-V assembly language that computes your geographical coordinates in a bidimensional plane, based on the current time and messages received from 3 satellites. 

To simplify the exercise, it is assumed that satellite A is placed at the origin of the cartesian plane (0, 0), while B and C are positioned at (0, YB) and (XC, 0), respectively. The satellites continuously send messages with a timestamp via waves that propagate in all directions at a speed of 3 x 108 m/s. At a given time TR, you receive a message from each satellite containing the timestamps TA, TB and TC. Assuming that all clocks are perfectly synchronized, print your coordinates (x, y) in the cartesian plane. Note that the formulation used in this exercise is not realistic.

Input:
    Line 1 - Coordinates YB and Xc. Values are in meters, represented by 4-digit integers in decimal base and preceded by a sign ('+' or '-').
    Line 2 - Times TA, TB, Tc and TR. Values are in nanoseconds, represented by 4-digit integers in decimal base
Output:
    Your coordinate - (x, y). Values are in meters, approximated, represented by 4-digit integers in decimal base and preceded by a sign ('+' or '-').

Examples:

Input:
+0700 -0100
2000 0000 2240 2300
Output:
-0088 +0016


Input:
+1042 -2042
6823 4756 6047 9913
Output:
-0902 -0215


Input:
-2168 +0280
3207 5791 3638 9550
Output:
+0989 -1626


Input:
-2491 +0965
2884 7511 2033 9357
Output:
-0065 -1941


Input:
-0656 +1337
0162 2023 1192 9133
Output:
+1255 -2381


Notes and Tips:
    Multiple values written or read on/from the same line will be separated by a single space.
    Each line ends with a newline character '\n'.
    For this exercise, approximate solutions are accepted.
        Solutions with an absolute error smaller than 10 will be considered correct.
    The usage of the same method used in Exercise 7.1 with more iterations (e.g. 21 iterations) is recommended. Other methods to square root approximation can be used, as long as:
        It used only integers. Floating point numbers or the RISC-V square root instruction cannot be used.
        The approximation is as or more precise than the suggested method.
    It is best to work with distances in meters and time in nanoseconds, so that the provided input values do not cause overflow when using the proposed method and a good precision might be achieved. 
    Problem Geometry:
        There are many ways to solve this exercise. Here, we propose an approach that uses the equation of a circle. Given that dA, dB and dC are the distances between your position and the satellites A, B and C, respectively:
            x² + y² = dA²  		(Eq. 1)
            x² + (y - YB)² = dB² 	(Eq. 2)
            (x - XC)² + y² = dC² 	(Eq. 3)
        Using Equations 1 and 2:
            y =  (dA² + YB² - dB²) / 2YB 	                    (Eq. 4)
            x = + sqrt(dA² - y²) OU - sqrt(dA² - y²) 	        (Eq. 5)
    To find the correct x, you can try both possible values in Equation 3 and check which one is closer to satisfying the equation.