# Ex. 7.7: ABI-compliant linked list custom search --- lab10a.s
Instructions:
In this activity, you must write a program in RISC-V assembly language that has a ABI-compliant function int linked_list_search(Node *head_node, int val), similar to the one implemented in exercise 7.6. Your code will be linked to a code in C that calls the linked_list_search function and expects the return value to be the index of the node where the sum of the values is equal to val  or -1 in case there isn't such a node on the linked list.

In addition to linked_list_search, you will need to implement a few utility functions that will be required for this exercise and future ones.

```

lib.h:
typedef struct Node {
    int val1, val2;
    struct Node *next;
} Node;

int linked_list_search(Node *head_node, int val);
void puts ( const char *str );
char *gets ( char *str );
int atoi (const char *str);
char *itoa ( int value, char *str, int base );
void exit(int code);

```

Input:
Test Case index and specific input depending on the test case (check example.c). 

Output:
Output according to the test case.

Notes and Tips:
* The linked_list_search function will receive the address of the head node on register a0 and the value being searched on register a1, and must return on the register a0 the index of the node, if found, or -1 otherwise.
* The fields of the linked list node struct are VAL1, VAL2 and NEXT, in this order. VAL1 and VAL2 are the signed int values stored on the node and NEXT is the pointer to the next node on the linked list. If there isn't a next node, it will be a NULL pointer.
*  To check if the received value is on the current node, the comparison VAL1 + VAL2 = received value must be made.
* A NULL pointer is represented by the value 0.
* The indexing of the list nodes starts at 0 (i.e. the head_node has index 0).
* All nodes will have different sum values.
* You can test your code using the simulator's assistant from this link.


# Ex. 7.8: ABI-compliant recursive binary tree search --- lab10b.s
Instructions:
In this activity, you must write a program in RISC-V assembly language that has a ABI-compliant recursive function int recursive_tree_search(Node *root, int val). Your code will be linked to a code in C that calls the recursive_tree_search function and expects the return value to be the depth of the value if the searched value is present on the tree, 0 if not. 


The image above shows an example of a binary tree. If the value 361 was being searched, 3 would be the return value of the function, as it is the depth of the value in the tree.

Each tree node is a struct that contains a value on its first position, pointers to the left child and right child on the second and third positions, respectively. In case one of the children does not exist, the pointer will be NULL.

```
lib.h:
typedef struct Node {
    int val;
    struct Node *left, *right;
} Node;

int recursive_tree_search(Node *root_node, int val);
void puts ( const char *str );
char *gets ( char *str );
int atoi (const char *str);
char *itoa ( int value, char *str, int base );
void exit(int code);
```

Input:
Your function will receive the address of the root of the tree on register a0 and the value being searched on register a1.

Output:
Your function must return on the register a0 the depth of the value if the searched value is present on the tree, 0 otherwise.

Examples:
Input:
12
Output:
1


Input:
562
Output:
3


Input:
-40
Output:
0


Notes and Tips:
* The root node has depth 1.
* The fields of the binary tree node struct are VAL, LEFT and RIGHT, in this order. VAL is a signed int value stored on the node and LEFT and RIGHT are pointers to the node's children. If a node doesn't have one of these children, the respective pointer will be NULL.
* To check if the received value is on the current node, the comparison VAL = received value must be made.
* A NULL pointer is represented by the value 0.
* All nodes will have different values.
* The utility functions implemented in exercise 7.7 are necessary in this exercise.
* You can test your code using the simulator's assistant from this link.
