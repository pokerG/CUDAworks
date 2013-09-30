#include <stdio.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

/*bool InitCUDA(){
	int count;
	cudaGetDeviceCount(&count);
	if(count == 0){
		fprintf(stderr, "There is no device.]n");
		return false;
	}
	int i;
	for(i = 0; i < count; i++){
		cudaDeviceProp prop;
		if(cudaGetDeviceProperties(&prop,i) == cudaSuccess){
			if(prop.major >= 1){
				break;
			}
		}
	}
	if(i == count){
		fprintf(stderr,"There is no device suppoting CUDA 1.x.\n");
		return false;
	}
	cudaSetDevice(i);
	return true;
}*/

int main(){

	int count;
	cudaGetDeviceCount(&count);
	printf("There are %d devices.\n",count);


	return 0;
}