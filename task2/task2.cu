#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <time.h>


__global__ void whatIsMyId (unsigned int * const block,unsigned int * const thread,unsigned int * const warp,unsigned int * const clacThread, float * const tm){
	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);
	const unsigned int idx = (blockIdx.x * blockDim.x) + threadIdx.x;
	block[idx] = blockIdx.x;
	thread[idx] = threadIdx.x;
	warp[idx] = threadIdx.x / warpSize;
	clacThread[idx] = idx;
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&tm[idx],start,stop);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);
}
#define ARRAY_SIZE 128
#define ARRAY_SIZE_IN_BYTES (sizeof(unsigned int) * (ARRAY_SIZE))
#define ARRAY_SIZE_IN_FLOAT (sizeof(float) * ARRAY_SIZE)
unsigned int cpuBlock[ARRAY_SIZE];
unsigned int cpuThread[ARRAY_SIZE];
unsigned int cpuWarp[ARRAY_SIZE];
unsigned int cpucalcThread[ARRAY_SIZE];

float cpuTime[ARRAY_SIZE];


int main(){
	const unsigned int numBlock = 2;
	const unsigned int numThreads = 64;
	char ch;

	unsigned int * gpuBlock;
	unsigned int * gpuThread;
	unsigned int * gpuWarp;
	unsigned int * gpuclacThread;
	unsigned int i;
	float *gpuTime;

	cudaMalloc((void **)&gpuBlock,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuThread,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuWarp,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuclacThread,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuTime,ARRAY_SIZE_IN_FLOAT);

	whatIsMyId<<<numBlock,numThreads>>>(gpuBlock,gpuThread,gpuWarp,gpuclacThread,gpuTime);

	cudaMemcpy(cpuBlock,gpuBlock,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpuThread,gpuThread,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpuWarp,gpuWarp,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpucalcThread,gpuclacThread,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpuTime,gpuTime,ARRAY_SIZE_IN_FLOAT,cudaMemcpyDeviceToHost);

	cudaFree(gpuTime);
	cudaFree(gpuBlock);
	cudaFree(gpuThread);
	cudaFree(gpuWarp);
	cudaFree(gpuclacThread);

	cudaDeviceProp prop;
	if(cudaGetDeviceProperties(&prop,0) == cudaSuccess){
		printf("warpSize: %d\n",prop.warpSize);
	}
	for(i = 0; i < ARRAY_SIZE; i++){
		printf("Calculate Thread: %3u - Block£º %2u - Warp %2u - Thread: %3u\n",
			cpucalcThread[i],cpuBlock[i],cpuWarp[i],cpuThread[i]);
	}
	ch = getch();
}