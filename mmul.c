#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "timers.h"

void genMat(int *a, int m, int n) {
  int i,j;
  for(i=0;i<m;i++)
    for(j=0;j<n;j++)
      a[i*j+j] = rand()%10;
}

void printMat(int *a, int m, int n) {
  int i,j;
  for(i=0;i<m;i++) {
    for(j=0;j<n;j++)
      printf("%d%c",a[i*m+j],(j == (m-1))?'\n':'\t');
  }
  printf("\n");
}

void mulMat(int *a, int *b, int *c, int m, int n, int p, int r) {
  int i, j, k, sum;
  for(i=0;i<n;i++) {
    for(j=0;j<p;j++) {
      sum = 0;
      for(k=0;k<m;k++)
        sum += a[i*m+k]*b[k*p+j];
      c[i*p+j] = sum;
    }
  }
}

void mulMatOMP(int *a, int *b, int *c, int m, int n, int p, int r) {
  int i, j, k, sum;
#pragma omp parallel for private(i,j,k) shared(c)
  for(i=0;i<n;i++) {
    for(j=0;j<p;j++) {
      sum = 0;
      for(k=0;k<m;k++)
        sum += a[i*m+k]*b[k*p+j];
      c[i*p+j] = sum;
    }
  }
}


int main (int argc, char** argv) {
  int m, n, p, r, i = 1;
  int *a, *b, *c;
  m = 4;
  n = 2;
  p = 2;
  r = 4;
  while( i < argc ){
    m = atoi(argv[i++]);
    n = atoi(argv[i++]);
    p = atoi(argv[i++]);
    r = atoi(argv[i++]);
    i++;
  }

  if(m != r) {
    printf("Zle rozmiary macierzy!\n");
    return 0;
  }

  a = (int*)calloc(m*n,sizeof(int));
  b = (int*)calloc(p*r,sizeof(int));
  c = (int*)calloc(m*r,sizeof(int));

  genMat(a,m,n);
  genMat(b,p,r);
  if(m< 4 && r < 4) {
    printMat(a,m,n);
    printMat(b,p,r);
  }

  pTimer zegar = newTimer(); // make new timer
  // mnozenie sekwencyjne na CPU
  startTimer(zegar); // store first timestamp
  mulMat(a, b, c, m, n, p, r);
  stopTimer(zegar);  // store second timestamp
  //printMat(c,m,r);
  printf("czas mnozenia na CPU: \n"); // show time difference
  printTimer(zegar);
  printf("\n");
  
  // mnozenie z OMP
  startTimer(zegar);
  mulMatOMP(a,b,c,m,n,p,r);
  stopTimer(zegar);
  printf("czas mnozenie z OMP: \n");
  printTimer(zegar);
  printf("\n");
  


  free(a);
  free(b);
  free(c);
  freeTimer(zegar);  // free occupied ram
  return 0;
}
