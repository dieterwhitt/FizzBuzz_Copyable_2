// dieter whittingham 9/22/24

// for arm64 assembly on xnu kernel
// list of all syscalls:
// https://opensource.apple.com/source/xnu/xnu-1504.3.12/bsd/kern/syscalls.master 

// steps:
// convert command line arg to number n
// loop from 1 to n
// create modulus operator to determine divisibility by 3 and 5
// print n, Fizz, Buzz, or FizzBuzz
// terminate

.section .data
fizz: .ascii "Fizz"
buzz: .ascii "Buzz"
fizzbuzz: .ascii "FizzBuzz"
sp: .ascii " "

.section .text
.global _start
.align 2

_start:
    bl _iterate
    b _terminate

// performs fizzbuzz operation with n in x15
_iterate:
    loop:
        mov x14 x15 // fizzbuzz divisor
        bl modulo // get remainder
        cmp x13 #0 // check if 15 divides index
        beq


        sub x15 x15 #1 // subtract index
        cmp x15 #0 
        beq loop // iterate while index is still positive
    ret

// modulo operator
// x15 % x14 -> x13
_modulo:
    udiv x12 x15 x14 // quotient stored in x12
    mul x11 x12 x14 // multiply by smaller number and store in 11
    sub x13 x15 x11 // x15 - x11 yields remainder
    ret

// gets command line arg and converts to int
// loads to x15
// exits w/ error if invalid
// exits w/ error if >1 args
_loadarg:
    ret

// prints fizzbuzz
_printfizzbuzz:
    // write: x0-output stream x1-address of string x2-size of string in bytes
    // system call command: 4
    mov     x0, #1 // stdout
    adr     x1, fizzbuzz // string label
    mov     x2, #8 // 8 bytes long
    mov     x16, #4 // write command
    svc     0
    ret

_printfizz:
    mov     x0, #1 // stdout
    adr     x1, fizz
    mov     x2, #4 
    mov     x16, #4 
    svc     0
    ret

_printbuzz:
    mov     x0, #1 // stdout
    adr     x1, buzz
    mov     x2, #4 
    mov     x16, #4 
    svc     0
    ret

_printsp:
    mov     x0, #1 // stdout
    adr     x1, sp
    mov     x2, #1
    mov     x16, #4
    svc     0
    ret

// prints integer
// integer in x15
_printi:
    ret

// exit program
_terminate:
    mov x0, #0
    mov x16, #1
    svc 0

// exit with error code 1
_error:
    mov x0, #1
    mov x16, #1
    svc 0
