/*
Mnozenie macierzy CUDA,
Jakub Ciechowski GPU 2012

*/

#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

int TILE_WIDTH = 5;

__global__ void tilingMul(int *M, int *N, int *P, int width, int TILE_WIDTH) {
  
  int row = blockIdx.y * TILE_WIDTH + threadIdx.y;
  int col = blockIdx.x * TILE_WIDTH + threadIdx.x;
  
  int sum = 0;
  
  for(int k = 0; k < width; k++)
    sum += M[row*width+k] * N[k*width+col];
  
  P[row*width+col] = sum;
  
}

__global__ void naiveMul(int* M, int* N, int* P, int width) {

    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int sum = 0;
    for(int k=0; k < width; k++) 
        sum += M[ty*width+k] * N[k*width+tx];

    P[ty*width+tx] = sum;
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
    int SIZE = width*width;
    int *hostC = (int*)calloc(SIZE,sizeof(int));

    int *devA, *devB, *devC;
    cudaMalloc((void**) &devA, SIZE*sizeof(int));
    cudaMalloc((void**) &devB, SIZE*sizeof(int));
    cudaMalloc((void**) &devC, SIZE*sizeof(int));
    
    // do 256 elementow, naiveMul
//    dim3 blockDim(width, width);
//    dim3 gridDim(1,1);

    // powyzej 256
    TILE_WIDTH = sqrt(width);
    dim3 blockDim(width/TILE_WIDTH, width/TILE_WIDTH);
    dim3 gridDim(TILE_WIDTH, TILE_WIDTH);
    cudaMemcpy(devA, hostA, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(devB, hostB, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(devC, hostC, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    // do 256 elementow
//    naiveMul<<<gridDim,blockDim>>>(devA, devB, devC, width);
    // powyzej 256
    tilingMul<<<gridDim, blockDim>>> (devA, devB, devC, width, TILE_WIDTH);
    cudaMemcpy(hostC, devC, SIZE*sizeof(int), cudaMemcpyDeviceToHost);

    return hostC;
}

int main(int argc, char** argv) {
    int m = 4;
    int *A;
    int *B;
    int *C;
    if(argc > 2) {
        m = atoi(argv[1]);
    }

    A = genMatrix(m);
    printMat(A,m);
    B = genMatrix(m);
    printMat(B,m);
    
    C = matMul(A,B,m);
    printMat(C,m);

    return 0;
}
