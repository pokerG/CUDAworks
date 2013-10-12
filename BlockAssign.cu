#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void whatIsMyId (unsigned int * const block,unsigned int * const thread,unsigned int * const warp,unsigned int * const clacThread){
	const unsigned int idx = (blockIdx.x * blockDim.x) + threadIdx.x;
	block[idx] = blockIdx.x;
	thread[idx] = threadIdx.x;
	warp[idx] = threadIdx.x / warpSize;
	clacThread[idx] = idx;
}
#define ARRAY_SIZE 128
#define ARRAY_SIZE_IN_BYTES (sizeof(unsigned int) * (ARRAY_SIZE))
unsigned int cpuBlock[ARRAY_SIZE];
unsigned int cpuThread[ARRAY_SIZE];
unsigned int cpuWarp[ARRAY_SIZE];
unsigned int cpucalcThread[ARRAY_SIZE];

int main(){
	const unsigned int numBlock = 2;
	const unsigned int numThreads = 64;
	char ch;

	unsigned int * gpuBlock;
	unsigned int * gpuThread;
	unsigned int * gpuWarp;
	unsigned int * gpuclacThread;
	unsigned int i;

	cudaMalloc((void **)&gpuBlock,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuThread,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuWarp,ARRAY_SIZE_IN_BYTES);
	cudaMalloc((void **)&gpuclacThread,ARRAY_SIZE_IN_BYTES);

	whatIsMyId<<<numBlock,numThreads>>>(gpuBlock,gpuThread,gpuWarp,gpuclacThread);

	cudaMemcpy(cpuBlock,gpuBlock,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpuThread,gpuThread,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpuWarp,gpuWarp,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);
	cudaMemcpy(cpucalcThread,gpuclacThread,ARRAY_SIZE_IN_BYTES,cudaMemcpyDeviceToHost);

	cudaFree(gpuBlock);
	cudaFree(gpuThread);
	cudaFree(gpuWarp);
	cudaFree(gpuclacThread);

	for(i = 0; i < ARRAY_SIZE; i++){
		printf("Calculate Thread: %3u - Block£º %2u - Warp %2u - Thread: %3u\n",
			cpucalcThread[i],cpuBlock[i],cpuWarp[i],cpuThread[i]);
	}
	ch = getch();
}