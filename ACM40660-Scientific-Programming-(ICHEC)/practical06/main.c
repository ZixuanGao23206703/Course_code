// main.c
#include <stdio.h>
#include "matmult.h"

int main() {
    int n = 5, p = 3, q = 4;
    double A[n][p], B[p][q], C[n][q];
    int i, j;

    // Initialize A, B, C
    for (i = 0; i < n; i++) {
        for (j = 0; j < p; j++) {
            A[i][j] = i + j;
        }
    }

    for (i = 0; i < p; i++) {
        for (j = 0; j < q; j++) {
            B[i][j] = i - j;
        }
    }

    // Perform matrix multiplication
    matmult(n, p, q, A, B, C);

    // Print out the matrices
    printf("This is matrix A:\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < p; j++) {
            printf("%3.1f ", A[i][j]);
        }
        printf("\n");
    }

    printf("\nThis is matrix B:\n");
    for (i = 0; i < p; i++) {
        for (j = 0; j < q; j++) {
            printf("%3.1f ", B[i][j]);
        }
        printf("\n");
    }

    printf("\nThis is matrix C:\n");
    for (i = 0; i < n; i++) {
        for (j = 0; j < q; j++) {
            printf("%3.1f ", C[i][j]);
        }
        printf("\n");
    }

    return 0;
}
