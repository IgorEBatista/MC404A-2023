# Ex. 7.4: Image on Canvas --- lab08a.s
Instructions:
In this activity, you must write a program in RISC-V assembly language that reads an image in PGM format from a file and shows it on screen using the canvas peripheral.

Input:
Your program must read a file called "image.pgm" that will be in the same directory as the executable file. The syscall open can be used to open the file (an example is shown at the Notes section)

Some examples of PGM images can be found on this site:
PGMB Files - Binary Portable Gray Map Graphics Files

Output:
Your program must show the image on the screen using syscalls to the Canvas peripheral. The Canvas must be adjusted to have the image size. The available syscalls are:

| Syscall       | Input                                                                                                                                                                                       | Description                                                                                                                 |
|---------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| setPixel      | a0: pixel's x coordinate a1: pixel's y coordinate a2: concatenated pixel's colors: R\|G\|B\|A A2[31..24]: Red A2[23..16]: Green A2[15..8]: Blue A2[7..0]: Alpha a7: 2200 ( syscall  number) | Defines the color of a given canvas' pixel. For gray scale, use the same values for the colors (R = G = B) and alpha = 255. |
| setCanvasSize | a0: canvas width (value between 0 and 512) a1: canvas height (value between 0 and 512) a7: 2201 (syscall number)                                                                            | Resets and defines canvas' size.                                                                                            |
| setScaling    | a0: horizontal scaling a1: vertical scaling a7: 2202 (syscall number)                                                                                                                       | Updates canvas' scaling                                                                                                     |

Notes and Tips:
* To test on the simulator, you have to load your program (.s file) and the image file (name "image.pgm") simultaneously.
* When new files are loaded to the simulator, older ones are erased, so you have to load the program and image files together every time.
* To use the Canvas, you must enable it on the simulator. To do so, go to the tab  “Hardware” -> “External Devices” table ->  “+” Icon on the Canvas row. A new tab will appear where the canvas can be seen. 
* This exercise uses multiple syscall numbers. These values will always be stored on the register a7, and the ecall function has a different behavior for each value. To check the syscall for a specific functionality, the simulator table can be checked (note that the syscalls related to external devices, like Canvas, are not shown in this table if the device is not enabled). 
* You will not receive images larger than 512x512 (that typically takes up 262159 bytes).
* In all images, Maxval will be  255. 
* The canvas is indexed starting on 0.
* You need to resize the canvas (setCanvasSize syscall) according to the file header.
* You can test your code using the simulator's assistant from this link.

```
setPixel example:
    li a0, 100 # x coordinate = 100
    li a1, 200 # y coordinate = 200
    li a2, 0xFFFFFFFF # white pixel
    li a7, 2200 # syscall setPixel (2200)
    ecall


open example:
The open syscall returns the file descriptor (fd) for the file on a0. This file descriptor must be used on the read syscall to indicate the file from which the operating system must read from syscall to get the contents of the file.
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall

input_file: .asciz "image.pgm"
```

# Ex. 7.5: Applying a Filter to an Image  --- lab08b.s
Instructions:
In this activity, you must write a program in RISC-V assembly language that reads an image in PGM format from a file, applies an edge detection filter and shows the result on screen using the canvas peripheral.
 
The first step of this exercise is to read an image in the PGM format and store its content in a matrix (exactly as done in exercise 7.4). After that, you must apply the following filter on the image:

        | -1 | -1 | -1 |
w =     | -1 | 8  | -1 |
        | -1 | -1 | -1 |

Assuming w the filter matrix above, Minthe matrix representing the input image and Mout the matrix representing the output image. The basic idea of applying the filter is that each Mout pixel[i, j] is defined as:


Note that this can lead to the Min matrix to be indexed with invalid indices (negative or out of bounds). In order to avoid these cases, the border pixels of the image Mout must be initialized with black and it is not necessary to compute the filter value for them. You can visualize how this filter works in Image Kernels explained visually (select the "outline" filter). This filter is also known as the Laplacian operator for edge detection.

Also note that the image pixels must have values between 0 (black) and 255 (white). If the result of the equation presented above is not in this interval, you must use the closest value in the interval (i.e., values lower than 0 become 0, and values greater than 255 become 255).

Input:
Your program must read a file called "image.pgm" that will be in the same directory as the executable file, as explained in exercise 7.4.

Output:
Your program must show the result image on the screen,  using the Canvas peripheral, as explained in exercise 7.4.

Notes and Tips:
* You need to resize the canvas (setCanvasSize syscall) according to the file header.
* You can test your code using the simulator's assistant from this link.