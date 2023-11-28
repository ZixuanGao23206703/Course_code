 ssh sp73@sciprog.ichec.ie
 cd practical4
 
 gcc -o trap1 trap1.c -lm
 ./trap1
#results：
#TanValues[0] = 0.000000 at x=0.00 degrees
#TanValues[1] = 0.087489 at x=5.00 degrees
#TanValues[2] = 0.176327 at x=10.00 degrees
#TanValues[3] = 0.267949 at x=15.00 degrees
#TanValues[4] = 0.363970 at x=20.00 degrees
#TanValues[5] = 0.466308 at x=25.00 degrees
#TanValues[6] = 0.577350 at x=30.00 degrees
#TanValues[7] = 0.700208 at x=35.00 degrees
#TanValues[8] = 0.839100 at x=40.00 degrees
#TanValues[9] = 1.000000 at x=45.00 degrees
#TanValues[10] = 1.191754 at x=50.00 degrees
#TanValues[11] = 1.428148 at x=55.00 degrees
#TanValues[12] = 1.732051 at x=60.00 degrees

 gcc -o trap2 trap2.c -lm
 ./trap2
#results：
#Your approximation of the integral from x=0 degrees to x=60 degrees of the function tan(x) with respect to x is :
#0.69504
#The exact solution is :
#0.69315

 gcc -o trap3 trap3.c -lm
 ./trap3
#results：
#Your approximation of the integral from x=0 degrees to x=60 degrees of the function tan(x) with respect to x is :
#0.69504
#The exact solution is :
#0.69315
