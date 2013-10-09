#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "string.h"

void printDevice(cudaDeviceProp prop){
	printf("\t Name: \t%s\n",prop.name);
    printf("\t Capability Major/Minor version number:    %d.%d\n", prop.major, prop.minor);
	printf("\t Total amount of global memory: \t%.0f MBytes (%llu bytes)\n",
                (float)prop.totalGlobalMem/1048576.0f, (unsigned long long) prop.totalGlobalMem);
	printf("\t maxThreadsPerBlock: \t%d\n",prop.maxThreadsPerBlock);
	printf("\t totalConstMen: \t%d\n",prop.totalConstMem);
	printf("\t sharedMemPerBlcok: \t%d\n",prop.sharedMemPerBlock);
	printf("\t regsPerBlock: \t%d\n",prop.regsPerBlock);
	printf("\t maxThreadsPerMultiProcessor: \t%d\n",prop.maxThreadsPerMultiProcessor);
	printf("\t multiProcessorCount: \t%d\n",prop.multiProcessorCount);
}

int main(){

	int count;
	cudaGetDeviceCount(&count);
	printf("There are %d devices.\n",count);	
	int i;
	for(i = 0; i < count; i++){
		cudaDeviceProp prop;
		if(cudaGetDeviceProperties(&prop,i) == cudaSuccess){
			printf("The %dth device's informations\n",i + 1);
			printDevice(prop);
		}

	}

	return 0;
}