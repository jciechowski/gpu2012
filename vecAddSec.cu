#include <stdlib.h>
#include <stdio.h>
#include "timers.h"

long int MAX;
__global__ void VecAdd(int* A, int* B, long int MAX)
{
  long int i = 0;
  while(i++ < MAX)
    A[i] += B[i];
}

// Host code
int main(int argc, char** argv)
{
  MAX = (long int)atoi(argv[1]);
  size_t size = MAX * sizeof(float);
  // Allocate input vectors h_A and h_B in host memory
  int* h_A = (int*)malloc(size);
  int* h_B = (int*)malloc(size);
  int i;
  pTimer zegar = newTimer();
  // Initialize input vectors
  srand(time(NULL));
  for(i=0;i<MAX;i++) {
    h_A[i] = rand();
    h_B[i] = rand();
  }
  
  // Allocate vectors in device memory
  int* d_A;
  cudaMalloc(&d_A, size);
  int* d_B;
  cudaMalloc(&d_B, size);
  // Copy vectors from host memory to device memory
  cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
  // Invoke kernel
  int threadsPerBlock = 256;
  int blocksPerGrid = (MAX + threadsPerBlock -1) / threadsPerBlock;
  startTimer(zegar);
  VecAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, MAX);
  // Copy result from device memory to host memory
  // h_C contains the result in host memory
  cudaMemcpy(h_A, d_A, size, cudaMemcpyDeviceToHost);
  stopTimer(zegar);
  printf("calkowity czas gpu sekwencyjnie: ");
  printTimer(zegar);
  printf("\n");
  // Free device memory
  cudaFree(d_A);
  cudaFree(d_B);
  // Free host memory
  free(h_A);
  free(h_B);
  freeTimer(zegar);
}
