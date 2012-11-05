/*
  Mnozenie macierzy CUDA,
  Jakub Ciechowski GPU 2012

*/

#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
#include "timers.h"

int TILE_WIDTH = 5;

__global__ void tilingMul(int *M, int *N, int *P, int width, int TILE_WIDTH) {
  
  int row = blockIdx.y * TILE_WIDTH + threadIdx.y;
  int col = blockIdx.x * TILE_WIDTH + threadIdx.x;
  
  int sum = 0;
  
  for(int k = 0; k < width; k++)
    sum += M[row*width+k] * N[k*width+col];
  
  P[row*width+col] = sum;
  
}

void printMat(int *a, int width) {
  int i,j;
  for(i=0;i<width;i++) 
    for(j=0;j<width;j++)
      printf("%d%c",a[i*width+j],(j == (width-1))?'\n':'\t');

  printf("\n");
}

int* genMatrix(int width) {
  int *a = (int*)calloc(width*width, sizeof(int));
  int i,j;
  for(i=0;i<width;i++)
    for(j=0;j<width;j++)
      a[i*width+j] = rand()%10;
  return a;
}

int *matMul(int *hostA, int *hostB, int width) {
  int *hostC = (int*)malloc(width*width*sizeof(int));

  int *devA, *devB, *devC;
  cudaMalloc((void**) &devA, width*width*sizeof(int));
  cudaMalloc((void**) &devB, width*width*sizeof(int));
  cudaMalloc((void**) &devC, width*width*sizeof(int));
    
  TILE_WIDTH = sqrt(width);
  dim3 blockDim(width/TILE_WIDTH, width/TILE_WIDTH);
  dim3 gridDim(TILE_WIDTH, TILE_WIDTH);
  cudaMemcpy(devA, hostA, width*width*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(devB, hostB, width*width*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(devC, hostC, width*width*sizeof(int), cudaMemcpyHostToDevice);
  pTimer zegar = newTimer();
  printf("n = %d\n",width);
  startTimer(zegar);
  tilingMul<<<gridDim, blockDim>>> (devA, devB, devC, width, TILE_WIDTH);
  cudaMemcpy(hostC, devC, width*width*sizeof(int), cudaMemcpyDeviceToHost);
  stopTimer(zegar);
  printTimer(zegar);
  printf("\n");
    
  cudaFree(devA);
  cudaFree(devB);
  cudaFree(devC);
  freeTimer(zegar);
  return hostC;
}

int main(int argc, char** argv) {
  int m = 4;
  int *A;
  int *B;
  int *C;
  if(argc > 1) {
    m = atoi(argv[1]);
  }

  A = genMatrix(m);
  /*
    printMat(A,m);
  */
  B = genMatrix(m);
  /*
    printMat(B,m);
  */
  C = matMul(A,B,m*i);

  /*
    printMat(C,m);
  */
    
  return 0;
}
