# Ex. 7.3: Hamming Code
Instructions:
In this activity, you must write a program in RISC-V assembly language that performs the encoding and decoding of a Hamming(7, 4) code.

Encoding
For the first part of this exercise, you will receive a sequence of 4 bits, and you have to encode these data bits using the Hamming Code. Assuming that the 4 bit input is given as:
d1d2d3d4
The output will be
p1p2d1p3d2d3d4
The new inserted bits with radical p are parity bits. Each one of the 3 parity bits is responsible for reflecting the parity of a given subset of bits (subset of 3 elements from the 4 available input bits). A parity bit is 1 if the evaluated set of bits has an odd number of 1s, or 0 otherwise. The following table can be used as reference:

Parity bit
Subset of tested bits
| Parity bit | Subset of tested bits |
|------------|----------------------|
| p1         | d1d2d4               |
| p2         | d1d3d4               |
| p3         | d2d3d4               |


Decoding
On the second part of this exercise, you will receive a sequence of 7 bits that has been encoded. You have to extract the data field from this sequence, and also check if the data contains an error caused by a bit flip (there is no need for correcting the data if an error is detected). For this error checking, you have to verify the parity of each one of the 3 subsets. 

The XOR operator can be used for a given subset of bits. For instance, to check the parity for which p1 is responsible, p1 XOR d1 XOR d2 XOR d4 must be equal to 0. Otherwise, there is an error on the encoded data. Do this for the 3 subsets of bits in order to check if you can trust the data encoded with Hamming(7, 4).

Input:
* Line 1 - a sequence of 4 bits that must be encoded in a Hamming code using 3 parity bits.
* Line 2 - a sequence of 7 bits that is Hamming encoded, and must be decoded and checked.
Output:
* Line 1 - sequence of 7 bits that has been encoded using Hamming code
* Line 2 - sequence of 4 bits that has been decoded from the Hamming code.
* Line 3 - 1 if an error was detected when decoding the Hamming code, 0 otherwise.

Examples:

Input:
1001
0011001

Output:
0011001
1001
0


Input:
0000
0000000

Output:
0000000
0000
0


Input:
0001
0010001

Output:
1101001
1001
1


Input:
1111
1001001

Output:
1111111
0001
1


Input:
1010
1011010

Output:
1011010
1010
0


Notes and Tips:
* Exclusive OR (XOR) is a logic operator that facilitates the computation of parity bits
* AND instruction is useful to leave only a given group of bits set (masking).
* The decoded data doesn't need to be corrected, in case an error is detected.
* You can test your code using the simulator's assistant from this link.
