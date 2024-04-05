# Ex. 7.6: Custom Search on a Linked List
Instructions:
In this activity, you must write a program in RISC-V assembly language that receives a number via STDIN, goes through a linked list and prints the index of the node where the sum of the two stored values is equal to the number read from STDIN. In case none of the nodes in the linked list fill this requirement, the number -1 must be printed. 


For the linked list above, in case the input was 134, the number 1 (index of the second node on the list) should be printed as 56 + 78 = 134. If the input was a number that is not equal to the sum of any of the nodes (e.g. 8), -1 should be printed.

Input:
An ASCII encoded decimal number on the interval -10000 and 10000.

Output:
Index of the node where the sum of the two stored values is equal to the received value, if it exists on the linked list, -1 if it does not exist.

Examples:
Example of data.s file that will be linked to your program:

```
.globl head_node

.data
head_node: 
    .word 10
    .word -4
    .word node_1
.skip 10
node_1: 
    .word 56
    .word 78
    .word node_2
.skip 5
node_3:
    .word -100
    .word -43
    .word 0
node_2:
    .word -654
    .word 590
    .word node_3
```

Input:
6
Output:
0


Input:
45
Output:
-1


Input:
-64
Output:
2


Notes and Tips:
* The head node of the linked list is stored on the address marked by the label head_node (DO NOT use this label on your code).
* The fields of the linked list node struct are VAL1, VAL2, and NEXT, in this order. VAL1 and VAL2 are 32-bit signed integer values stored on the node and NEXT is the pointer to the next node on the linked list. If there isn't a next node, it will be a NULL pointer.
* To check if the received value is on the current node, the comparison VAL1 + VAL2 = received value must be made.
* A NULL pointer is represented by the value 0.
* The indexing of the list nodes starts at 0 (i.e., the head_node has index 0).
* All nodes will have different sum values.
* You can test your code using the simulator's assistant from this link.
