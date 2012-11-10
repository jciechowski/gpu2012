/*
Mnozenie macierzy CUDA,
Jakub Ciechowski GPU 2012

*/

#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>


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

    dim3 blockDim(width, width);
    dim3 gridDim(1,1);

    cudaMemcpy(devA, hostA, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(devB, hostB, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(devC, hostC, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    naiveMul<<<gridDim,blockDim>>>(devA, devB, devC, width);
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
