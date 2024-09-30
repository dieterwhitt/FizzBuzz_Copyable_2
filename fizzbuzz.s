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

fizz: .asciz "Fizz"
buzz: .asciz "Buzz"
fizzbuzz: .asciz "FizzBuzz"
wspace: .asciz " "
errormsg: .asciz "Error running the program. Refer to README.md for execution instructions.\n"
newline: .asciz "\n"

.global _start
.align 2

_start:
    bl _readn
    //mov x10, #10
    //mov x15, #10
    //mov x15, x10
    //bl _printi
    bl _iterate
    b _terminate

// attempts to read argv[1] and parses to int, which is stored in x10
_readn:
    cmp x0, #1 // x0 has argument count
    ble _error // exit with error
    // now, x1 contains offset from sp to argv[0]
    // add 8 bytes to get argv[1]
    add x1, x1, #8
    // currently x1 is a pointer to a pointer to a string. need to dereference:
    ldr x3, [x1]
    // now have address of null terminated string n in x3
    // need to iterate 1 byte at a time. check if it's an int
    // (between #'0' and #'9')
    // each iteration, multiplying the result by 10, then adding the digit
    // stopping at null byte
    mov x10, #0 // output val
    mov x9, #10 // base 10 
    convert_loop:
        ldrb w2, [x3], #1 // reads 1 byte from the string x3 references into w2 and shift x3
        cbz w2, convert_done // finish loop on null character
        // error if char not a number
        cmp w2, '0'
        blt _error
        cmp w2, '9'
        bgt _error

        sub w2, w2, '0' // convert to int
        //sxtw x2, w2 // convert 32 bit to 64
        mul x10, x10, x9 // multiply output by 10
        add x10, x10, x2
        b convert_loop // loop again
    convert_done:
        ret

// performs fizzbuzz operation with n in x10
_iterate:
    // 15 is i
    mov x15, #1
    mov x17, lr // store return address now because will be branching soon
    cbz x10, _error // terminate if input was 0
    loop:
        mov x14, #15 // fizzbuzz divisor
        bl _modulo // get remainder
        cmp x13, #0 // check if 15 divides index
        beq _printfizzbuzz

        mov x14, #3 // fizz divisor
        bl _modulo
        cmp x13, #0
        beq _printfizz

        mov x14, #5 // buzz divisor
        bl _modulo
        cmp x13, #0
        beq _printbuzz

        // else: printi
        bl _printi

        fi1: // end of if/elif/else
            bl _printsp // print space

            add x15, x15, #1 // increment index
            cmp x15, x10 
            ble loop // iterate while index <= n
    // return to original caller
    br x17

// modulo operator
// x15 % x14 -> x13
_modulo:
    udiv x12, x15, x14 // quotient stored in x12
    mul x11, x12, x14 // multiply by smaller number and store in 11
    sub x13, x15, x11 // x15 - x11 yields remainder
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
    mov     x2, #9 // 9 bytes long
    mov     x16, #4 // write command
    svc     0
    b fi1

_printfizz:
    mov     x0, #1 // stdout
    adr     x1, fizz
    mov     x2, #5 
    mov     x16, #4 
    svc     0
    b fi1

_printbuzz:
    mov     x0, #1 // stdout
    adr     x1, buzz
    mov     x2, #5 
    mov     x16, #4 
    svc     0
    b fi1

_printsp:
    mov     x0, #1 // stdout
    adr     x1, wspace
    mov     x2, #2
    mov     x16, #4
    svc     0
    ret

// prints integer (not null terminated)
// integer in x15
_printi:
    sub sp, sp, #16 // allocate 16 bytes of stack space
    mov x12, x15 // preserve x15, operations will be done on x12
    mov x11, #0 // byte counter
    mov x9, sp // insertion pointer (end of buffer)
    add x9, x9, #16
    printNumber:
        mov  x16, #10 // store quotient
        udiv x14, x12, x16
        msub x13, x14, x16, x12 // get remainder (digit) into x13
        sub  x12, x12, x13
        udiv x12, x12, x16 // update 12 for next iteration
        add  x13, x13, '0' // digit to string

        sub x9, x9, #1 // shift insertion point left
        strb w13, [x9] // put byte in buffer insertion point
        add x11, x11, #1 // update byte counter

        cmp  x12, #0
        beq  exit // exit loop
        b    printNumber

    exit:
        // print buffer
        mov  x0, #1
        mov  x1, x9 // insertion point is start of string
        mov  x2, x11 // x11 is length
        mov  x16, #4
        svc  #0

        add  sp, sp, #16 // restore stack
        ret

// exit program
_terminate:
    mov     x0, #1 // stdout
    adr     x1, newline
    mov     x2, #2
    mov     x16, #4
    svc     0

    mov x0, #0
    mov x16, #1
    svc 0

// print error messsage and exit with error code 1
_error:
    mov     x0, #1 // stdout
    adr     x1, errormsg
    mov     x2, #75
    mov     x16, #4
    svc     0

    mov x0, #1
    mov x16, #1
    svc 0
