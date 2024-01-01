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
