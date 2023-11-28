ssh sp73@sciprog.ichec.ie
cd practical9
gcc main_stub.c
ls
#a.out                 magic_square_stub.h  main         not_magic_square.txt
#magic_square_stub.fh  magic_square.txt     main_stub.c  practical9.pdf

 ./a.out
Enter file name: magic_square.txt
#No. lines, 3
#2       7       6
#9       5       1
#4       3       8
#M=15
#i=0, rowSum=15, colSum=15
#i=1, rowSum=15, colSum=15
#i=2, rowSum=15, colSum=15
# diagSum=15, secDiagSum=15
#This square is magic

./a.out
Enter file name: not_magic_square.txt
#No. lines, 3
#1       2       3
#4       5       6
#7       8       9
#M=15
#i=0, rowSum=6, colSum=12
#This square is NOT magic
