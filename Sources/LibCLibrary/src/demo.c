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
    asm volatile ("add %w[a], %w[a], %w[b]; mov %w[a], %w[result]"
                : [result] "=r" (result)
                : [a] "r" (a), [b] "r" (b)
                : "cc");
    #elif __i386__ // Intel 32-bit
    result = a + b;
    #elif __x86_64__ // Intel 64-bit
    result = a + b;
    #elif __arm__ // ARM 32-bit
    result = a + b;
    #elif __riscv_64 // RISC-V 64-bit (future)
    result = a + b;
    #else
    #error "Unsupported architecture"
    #endif

    return result;
}
