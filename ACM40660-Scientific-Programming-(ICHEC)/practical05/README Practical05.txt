ssh sp73@sciprog.ichec.ie
cd practical5
gcc -o printf print.c
./printf
#result:
#Enter an int and double:
#33
#2
#You entered: 33 and 2.000000


gcc -o Fib Fibonacci.c -lm
./Fib
#result:
#Enter a positive integer: 2
#The Fibonacci sequence is:
#0, 1, 1, 

./Fib
#result:
#Enter a positive integer: 10
#The Fibonacci sequence is:
#0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
#55, 

./Fib
#result:
#Enter a positive integer: 49
#The Fibonacci sequence is:
#0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
#55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
#6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229,
#832040, 1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, #39088169, 63245986,
#102334155, 165580141, 267914296, 433494437, 701408733, 1134903170, 1836311903, -1323752223, 512559680, -811192543,


gcc -o artan artan.c -lm
 ./artan
#result:
#Enter the precision for the Maclaurin series:
#3
#The difference at x=-0.900000 between them is 0.5722194896.
#The difference at x=-0.800000 between them is 0.2986122887.
#The difference at x=-0.700000 between them is 0.1673005277.
#The difference at x=-0.600000 between them is 0.0931471806.
#The difference at x=-0.500000 between them is 0.0493061443.
#The difference at x=-0.400000 between them is 0.0236489302.
#The difference at x=-0.300000 between them is 0.0095196042.
#The difference at x=-0.200000 between them is 0.0027325541.
#The difference at x=-0.100000 between them is 0.0003353477.
#The difference at x=-0.000000 between them is 0.0000000000.
#The difference at x=0.100000 between them is 0.0003353477.
#The difference at x=0.200000 between them is 0.0027325541.
#The difference at x=0.300000 between them is 0.0095196042.
#The difference at x=0.400000 between them is 0.0236489302.
#The difference at x=0.500000 between them is 0.0493061443.
#The difference at x=0.600000 between them is 0.0931471806.
#The difference at x=0.700000 between them is 0.1673005277.
#The difference at x=0.800000 between them is 0.2986122887.
#The difference at x=0.900000 between them is 0.5722194896.












