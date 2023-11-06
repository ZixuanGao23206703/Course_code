 ssh sp73@sciprog.ichec.ie
 cd practical1
 
 gcc -o Conversion Conversion.c -lm
 ./Conversion
 
 #The number of digits is 25
 #inum=33554431,  fnum=33554432.000000, inum in binary=1111111111111111111111111

 gcc -o printing printing.c -lm
 ./printing
 #Account: 1 Subtotal: 1234.56 Total: 7890.12
 
 gcc -o scanning scanning.c -lm
 ./scanning
 
 # input two positive integers
 3 14
 #result
 #You entered 3 and 14
 #num1 is odd and num2 is even
 