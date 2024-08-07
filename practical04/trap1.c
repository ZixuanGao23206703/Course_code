#include<stdio.h>
#include<math.h>

double degtorad(double deg);

int main(){

  int N=12, i ;
  double TanValues[N+1],deg,rad;
  for(i=0; i<=N; i++){
    deg = i*5.0;
    rad = degtorad(deg);
    TanValues[i] = tan(rad);
    printf("TanValues[%d] = %f at x=%.2f degrees\n", i,TanValues[i],deg);
    
  }
  
}

double degtorad(double deg){
  return (deg *M_PI)/180.0;
}