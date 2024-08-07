 ssh sp73@sciprog.ichec.ie
 cd practical2

gcc -o Conversion Conversion.c -lm
 ./Conversion
#result:
#The number of digits is 25
#Temp is 2147483621
#inum=33554431,  fnum=33554432.000000, inum in binary=1111111111111111111111111

gcc -o sizeof sizeof.c
./sizeof
#Size of x: 4 bytes
#Size of y: 8 bytes

gcc -o log2 log2.c
./log2
#result:
#log(2) = 0.693147

gcc -o Sum2 Sum2.c
./Sum2
#result:
#Sum1=0.000000
#Sum2=0.000000
#Difference between the two is -0.003448
#It is different between sum1 and sum2.Mathematically it is the same but on computer calculation it is different.
