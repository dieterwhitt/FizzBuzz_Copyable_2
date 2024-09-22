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
    b _terminate

// gets command line arg and converts to int
// exits w/ error if invalid
// exits w/ error if >1 args
_loadarg:
    ret

// prints string
_prints:
    ret

// prints integer
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
