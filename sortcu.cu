#include <iostream>
#include <cmath>
#include "sortcu.h"
using namespace std;
#define THREADS_PER_BLOCK 8
#include <stdlib.h>
#include <math.h>
#include "sortcu.h"
#include <stdio.h>

__global__ void Egpu_merge(int *ndata)
{
//invert elements of second sublist
//printf("%d\n", blockDim.x);
int swap_pos;
//int temp;
//int nstep=0;
 int shift=0;
   
      int scale=*ndata; 
    for(int i=0;i<*ndata;i++) 
    {
       scale=(scale+1)/2;
       
           
    
       for (int j=0;j<=(*ndata/2)/blockDim.x;j++){
        if(threadIdx.x>=scale)
        shift=(threadIdx.x/scale)*scale+(j*blockDim.x);

       swap_pos=threadIdx.x+scale+shift;
       // printf(" MERGE at %d:%d %d       %d   \n",i,j,threadIdx.x+shift,swap_pos);   
       
       }
       
       //need to have loops of threads till 
       
        //if(data[threadIdx.x+shift]>=data[swap_pos]){
          //printf("swap done: %d  %d\n",data[threadIdx.x+shift],data[swap_pos]);
          //temp=data[threadIdx.x+shift];
          //data[threadIdx.x+shift]=data[swap_pos];
          //data[swap_pos]=temp;        
        //}

        __syncthreads();  
  }//for


}

__global__ void gpu_sort_inner(int *data,int iter2, int iter,  int ndata)
{
   int k=(-1*((2*threadIdx.x)/(iter)));
    int shift=0;
    int scale=iter; 
    int swap_pos;   
    for(int i=0;i<iter+1;i++)
    {
       scale=(scale+1)/2;
       if(threadIdx.x>=scale)
         shift=(threadIdx.x/scale)*scale;
       swap_pos=threadIdx.x+scale+shift;

       if (k<0){
        //printf("SWAP at %d>%d: %d       %d   UP k: %d \n",iter,i,threadIdx.x+shift,swap_pos, k);     
        if(data[threadIdx.x+shift]<data[swap_pos]){
          //printf("swap done: %d  %d\n",data[threadIdx.x+shift],data[swap_pos]);
          /*temp=data[threadIdx.x+shift];
          data[threadIdx.x+shift]=data[swap_pos];
          data[swap_pos]=temp;*/     
        }
      
       }else{
        //printf("SWAP at %d>%d: %d       %d  DOWN k: %d \n",iter,i,threadIdx.x+shift,swap_pos,k);     
        if(data[threadIdx.x+shift]>data[swap_pos]){
          //printf("swap done: %d  %d\n",data[threadIdx.x+shift],data[swap_pos]);
          /*temp=data[threadIdx.x+shift];
          data[threadIdx.x+shift]=data[swap_pos];
          data[swap_pos]=temp;*/      
        }
       }
      
      //__syncthreads();
      if(scale<2)
         break;
           
    }//for


 //bitonic merge: NOT REQUIRED
    /*int shift=0;
    int scale=*ndata;    
    for(int i=0;i<nstep;i++) 
    {
       scale=(scale+1)/2;
       if(threadIdx.x>=scale)
         shift=(threadIdx.x/scale)*scale;

       swap_pos=threadIdx.x+scale+shift;
       
        printf("SWAP at %d: %d       %d   \n",i,threadIdx.x+shift,swap_pos);     
        if(data[threadIdx.x+shift]>=data[swap_pos]){
          //printf("swap done: %d  %d\n",data[threadIdx.x+shift],data[swap_pos]);
          temp=data[threadIdx.x+shift];
          data[threadIdx.x+shift]=data[swap_pos];
          data[swap_pos]=temp;        
        }

        __syncthreads();  
  }//for
//}*/
  int index= threadIdx.x + blockDim.x * blockIdx.x;
  int direction = index^iter2;

  if ((direction)>index)
  {
    /* UP ARROW*/
    if ((index&iter)==0) 
   {
       if (data[index]>data[direction])
    { int temp;
      temp=data[index];
      data[index]=data[direction];
      data[direction]=temp;
     }
    }

    /*DOWN ARROW*/
    if ((index&iter)!=0)   
  {  if (data[index]<data[direction])
 {  int temp;
  temp=data[index];
  data[index]=data[direction];
  data[direction]=temp;
  }
  }

  }
  __syncthreads();

}





__global__ void gpu_sort(int *data, int ndata)
{
   //cout<<"GPU_SORT called\n";

    int num_thread=512;
    int num_blocks=ndata/512;


    int swap_pos;
    //int temp;
    //int nstep=0;
    

    int k=-1;
    for (int iter=2;iter<=ndata;iter=iter*2){
      for (int iter2=iter/2;iter2>0;iter2=iter2/2){
        gpu_sort_inner<<<num_blocks, num_thread>>>(data,iter2, iter, ndata);

      }

    }
  }
   



void sort(int *data, int ndata){
   int *d_data;
   //int *d_ndata;
   
   cudaMalloc((void **)&d_data, sizeof(int)*ndata);
   //cudaMalloc((void **)&d_ndata, sizeof(int));
   
   cudaMemcpy(d_data, data, sizeof(int)*ndata, cudaMemcpyHostToDevice);
   //cudaMemcpy(d_ndata, &ndata, sizeof(int), cudaMemcpyHostToDevice);
   //call gpu_sort with input size of power 2 serialy:
   gpu_sort<<<1,1>>>(d_data,ndata);
   //call gpu_sort 
   //Egpu_merge<<<2,(ndata+1)/4>>>(d_ndata);
   cudaMemcpy(data, d_data, sizeof(int)*ndata, cudaMemcpyDeviceToHost);

   //for (int i=0; i<ndata; i++)
      //cout<<"%d\n", data[i];


   
}

