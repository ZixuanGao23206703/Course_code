#include <stdio.h>
// Checks if a matrix is a magic square.
// A magic square is an n-sided matrix whose sum of values for each
// row, column, main and secondary diagonals equals to n(n^2 + 1)/2.
// The function takes as input a matrix 'square' and its side length 'n'
// and outputs 0 if 'n' is negative or 'square' is NOT a magic square;
// otherwise, outputs a non-zero value
//

int isMagicSquare(int ** square, const int n) {

    // Eliminate the case where 'n' is negative
    if(n < 0) {
        return 0;
    }

    // M is the sum of every row, column,
    // and the main and secondary diagonals
    int M = (n * (n*n + 1))/2;
    printf("M=%d\n", M); // Added a semicolon here

    int i, j;
    // TODO: Checking that every row and column add up to M
    for(i = 0; i < n; i++) {
        int rowSum = 0;
        int colSum = 0;
        for(j = 0; j < n; j++) {
            rowSum += square[i][j];
            colSum += square[j][i];
        }
        printf("i=%d, rowSum=%d, colSum=%d\n", i, rowSum, colSum); // Added a semicolon here
        if(rowSum != M || colSum != M) { // Fixed the logical condition here
            return 0;
        }
    }

    // TODO: Checking that the main and secondary diagonals each add up to M
    // If passed all checks, it is a magic square
    int diagSum = 0; // Corrected the variable name
    int secDiagSum = 0; // Corrected the variable name
   
    for(i = 0; i < n; i++) {
        diagSum += square[i][i]; // Fixed the index here
        secDiagSum += square[i][n-i-1];
    }
    
    printf(" diagSum=%d, secDiagSum=%d\n", diagSum, secDiagSum);
    if(diagSum != M || secDiagSum != M) { // Fixed the variable name here
        return 0;
    }


    //If passed all checks, it is a magic aquare,return 1
    return 1;
}

