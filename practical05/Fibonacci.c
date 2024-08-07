#include <stdio.h>
#include <stdlib.h>

// Function declaration/prototype
// Input arguments: Fn-1 and Fn-2
// On exit: Fn and Fn-1
void fibonacci(int *a, int *b);

int main() {
    int n, i;
    int fo = 0, f1 = 1;

    printf("Enter a positive integer: ");
    scanf("%d", &n);

    if (n < 1) {
        printf("The number is not positive.\n");
        exit(1);
    }

    printf("The Fibonacci sequence is:\n");
    printf("%d, %d, ", fo, f1);

    // Calculating Fibonacci sequence from 2
    for (i = 2; i <= n; i++) {
        fibonacci(&f1, &fo);
        printf("%d, ", f1);

        if ((i + 1) % 10 == 0) {
            printf("\n");
        }
    }

    return 0;
}

void fibonacci(int *a, int *b) {
    int next;
    // *a = fn-1, *b = fn-2, next = fn
    next = *a + *b;
    // *a = fn, *b = fn-1
    *b = *a;
    *a = next;
}
