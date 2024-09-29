# FizzBuzz Copyable 2

Popular problem FizzBuzz implemented in ARM64 for the XNU kernel (MacOS).

## Compatibility

First ensure that your device architecture is compatible with the program:

```bash
uname -a
```

Confirm that your device is using ARM64 on a XNU kernel (darwin).

## Compliation

#### Clang:

```bash
clang fizzbuzz.s -o fizzbuzz -e _start
```

#### Assembler

```bash
as -o fizzbuzz.o fizzbuzz.s
ld -o fizzbuzz fizzbuzz.o
```

## Execution

```bash
./fizzbuzz n
```

Where n is an integer.
