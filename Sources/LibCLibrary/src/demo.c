#include "demo.h"

int demo_number() {
    return 123;
}

char* demo_string() {
    return "Hello Skip!";
}

double demo_compute(int n, double a, double b) {
    double result = 0.0;
    for (int i = 0; i < n; i++) {
        result += (a * b) / (a + b + i);
    }
    return result;
}

short add_with_assembly(short a, short b) {
    short result;

    #if __aarch64__ // ARM 64-bit
    // add the two source W (32-bit) registers, writing the sum to the result register
    asm ("add %w[result], %w[a], %w[b]"
                : [result] "=r" (result)
                : [a] "r" (a), [b] "r" (b));
    #elif __i386__ // Intel 32-bit
    // tie `a` into the result register, then add `b` into it (AT&T order: addw src, dst)
    asm ("addw %[b], %[result]"
                : [result] "=r" (result)
                : [b] "r" (b), "0" (a)
                : "cc");
    #elif __x86_64__ // Intel 64-bit
    // tie `a` into the result register, then add `b` into it (AT&T order: addw src, dst)
    asm ("addw %[b], %[result]"
                : [result] "=r" (result)
                : [b] "r" (b), "0" (a)
                : "cc");
    #elif __arm__ // ARM 32-bit
    // add Rn (a) and Rm (b), writing the sum to Rd (result)
    asm ("add %[result], %[a], %[b]"
                : [result] "=r" (result)
                : [a] "r" (a), [b] "r" (b));
    #elif defined(__riscv) && (__riscv_xlen == 64) // RISC-V 64-bit (future)
    // add rs1 (a) and rs2 (b), writing the sum to rd (result)
    asm ("add %[result], %[a], %[b]"
                : [result] "=r" (result)
                : [a] "r" (a), [b] "r" (b));
    #else
    #error "Unsupported architecture"
    #endif

    return result;
}
