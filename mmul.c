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

void mulMat(int *a, int *b, int *c, int m, int n, int p, int r) {
  int i, j, k;
  for(i=0;i<m;i++) {
    for(k=0;k<m*r;k++) {
      for(j=0;j<r;j++) {
        c[k] += a[n*i+i] * b[j*p+j];
        printf("%d * %d = %d\n", a[n*i+i], b[j*p+j], c[k]);
      }
    }
  }
}

int main (int argc, char** argv) {
  int m, n, p, r, i = 0, j;
  int *a, *b, *c;
  while( i < argc ){
    m = atoi(argv[++i]);
    n = atoi(argv[++i]);
    p = atoi(argv[++i]);
    r = atoi(argv[++i]);
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

  if(m < 4 && r < 4) {
    for(i=0;i<m;i++) {
      for(j=0;j<n;j++)
        printf("%d ",a[i*j+i]);
      printf("\n");
    }

    printf("\n\n");
    for(i=0;i<p;i++) {
      for(j=0;j<r;j++)
        printf("%d ",b[i*j+i]);
      printf("\n");
    }
  }
  printf("\n");

  

  mulMat(a, b, c, m, n, p, r);

  for(i=0;i<m;i++) {
    for(j=0;j<n;j++)
      printf("%d ",c[i*j+j]);
    printf("\n");
  }
  
  free(a);
  free(b);
  free(c);

  return 0;
}
