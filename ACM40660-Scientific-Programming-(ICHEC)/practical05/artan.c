#include<stdio.h>
#include<math.h>

double arctanh1(const double x, const double delta);
double arctanh2(const double x);

int main() {
    double delta, x;

    printf("Enter the precision for the Maclaurin series:\n");
    scanf("%lf", &delta);

    int length = 1000;
    double tan1[length]; // storing the result of arctan1
    double tan2[length]; // storing the result of arctan2

    int j = 0; // j: array index
    x = -0.9;
    while (x <= 0.9 && j < length) {
        tan1[j] = arctanh1(x, delta);
        tan2[j] = arctanh2(x);
        printf("The difference at x=%lf between them is %.10lf.\n", x, fabs(tan1[j] - tan2[j]));
        j++;
        x = x + 0.1; // try with 0.01 as well
    }

    return 0;
}

double arctanh1(const double x, const double delta) {
    double arcTan = 0; // approximation
    double elem, val; // element in the series
    int n = 0; // sum parameter

    do {
        val = 2 * n + 1;
        elem = pow(x, val) / val;
        arcTan += elem;
        n++;
    } while (fabs(elem) >= delta);

    return arcTan;
}

double arctanh2(const double x) {
    return (log(1 + x) - log(1 - x)) / 2;
}
