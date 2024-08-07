ssh sp73@sciprog.ichec.ie
cd practical6


gcc -c main.c -o main.o
gcc -c matmult.c -o matmult.o
gcc -o main main.o matmult.o
./main

#result：
#This is matrix A:
#0.0 1.0 2.0
#1.0 2.0 3.0
#2.0 3.0 4.0
#3.0 4.0 5.0
#4.0 5.0 6.0

#This is matrix B:
#0.0 -1.0 -2.0 -3.0
#1.0 0.0 -1.0 -2.0
#2.0 1.0 0.0 -1.0

#This is matrix C:
#5.0 2.0 -1.0 -4.0
#8.0 2.0 -4.0 -10.0
#11.0 2.0 -7.0 -16.0
#14.0 2.0 -10.0 -22.0
#17.0 2.0 -13.0 -28.0
