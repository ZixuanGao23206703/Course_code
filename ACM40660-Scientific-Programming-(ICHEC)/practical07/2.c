#include <stdio.h>
#include <stdlib.h>

// Allocate Array
int *allocateArray(int n) {
  int *p;
  p = (int *)malloc(n * sizeof(int));
  return p;
}

// 2.Fill with ones
void fillWithOnes(int *array, int n) {
  int i;
  for (i = 0; i < n; i++) {
    array[i] = 1;
  }
}

// 3.Print the array
void printArray(int *array, int n) {
  int i;
  for (i = 0; i < n; i++) {
    printf("a[%d]: %d\n", i, array[i]); // Corrected formatting of the printf statement
  }
}

// Deallocate the array
void freeArray(int *array) {
  free(array);
}

int main() {
  int n, *a;

  printf("Size of the array: ");
  scanf("%d", &n);

  a = allocateArray(n);
  fillWithOnes(a, n);
  printArray(a, n);
  freeArray(a);

  a = NULL;

  return 0;
}
