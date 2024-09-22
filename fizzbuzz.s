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

.global _start
.align 2

_start:
    b _terminate

_terminate:
    // exit program
    mov x0, #0
    mov x16, #1
    svc 0