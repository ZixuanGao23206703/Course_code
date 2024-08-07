#include <stdio.h>

int main(void) {
    int i;
    double a;

    // Enter information from the user
    printf("Enter an int and double:\n");
    scanf("%d %lf", &i, &a);

    // Print the entered values
    printf("You entered: %d and %lf\n", i, a);

    return 0;
}
