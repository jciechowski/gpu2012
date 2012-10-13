#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX 20

int main(int argc, char** argv) {
  
  int i=0, j, size, k;
  FILE *f;
  int **m1, **m2, r[MAX][MAX];
  if(argc < 3) {
    f = fopen(argv[1], "r");
    
    fscanf(f,"%d",&size);
    
    m1 = (int**)malloc(size*(sizeof(int*)));
    for(i = 0; i < size; i++) {
      m1[i] = (int*)malloc(size*sizeof(int));
    }
    
    m2 = (int**)malloc(size*(sizeof(int*)));
    for(i = 0; i < size; i++) {
      m2[i] = (int*)malloc(size*sizeof(int));
    }
    
    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
          r[i][j] = 0;
        }
    }

    for(i = 0; i < size; i++) {
        for(j = 0; j < size; j++) {
          fscanf(f,"%d",&m1[i][j]);
        }
    }
    
    for(i = 0; i < size; i++) {
      for(j = 0; j < size; j++) {
        fscanf(f,"%d",&m2[i][j]);
      }
    }

    for(i = 0; i < size; i++) {
      for(j = 0; j < size; j++) {
        for(k = 0; k < size; k++) {
          r[i][j] += m1[i][k] * m2[k][j];
        }
      }
    }
    
    for(i = 0; i < size; i++) {
      for(j = 0; j < size; j++) {
        printf("%d ",r[i][j]);
      }
      printf("\n");
    }
  }

  fclose(f);

  return 0;
}
