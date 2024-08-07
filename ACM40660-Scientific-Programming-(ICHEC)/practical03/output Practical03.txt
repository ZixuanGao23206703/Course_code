ssh sp73@sciprog.ichec.ie
cd practical3

gcc -o print print.c
./print
#result：
#Two ints 10 200 and two floats 1.11 2.2222

gcc -o excercise3 excercise3.c -lm
./excercise3
#Your approximation of the integral from x+0 to x=pi/3 of the function tan(x)wit
#0.07557
#The exact solution is :
#0.69315


