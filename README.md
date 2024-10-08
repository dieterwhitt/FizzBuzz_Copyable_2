# FizzBuzz Copyable 2

Popular brain teaser [FizzBuzz](https://en.wikipedia.org/wiki/Fizz_buzz) implemented in ARM64 Assembly for the XNU kernel (MacOS).

## Compatibility

First ensure that your device architecture is compatible with the program:

```bash
uname -a
```

Confirm that your device is using ARM64 on the XNU kernel (Darwin).

## Compliation

Compile using clang or assembler.

#### Clang:

```bash
clang fizzbuzz.s -o fizzbuzz -e _start
```

#### Assembler:

```bash
as -o fizzbuzz.o fizzbuzz.s
ld -o fizzbuzz fizzbuzz.o -e _start
```

## Execution

```bash
./fizzbuzz n
```

Where n is a positive integer (below the 64-bit limit).

#### Example

```bash
./fizzbuzz 15
1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz
```
