# Cuda_Sort
The objective of this experiment is to sort an integer array by using Cuda programming <br/>
We have implemented bitonic sort using Cuda by taking the nature of this algorithm in
consideration. From Figure 1 we can see that for n nnumber of dataitems we need Log n phases
(shown as bounding box in figure) and for each phase we need to have steps from 1 to
phases_number. Nature of algorithm is proper parallel as we can see that at each step all operations
can be done simultaneously. Also this algorithm is very much like Odd-Even sort despite direction
of swap is depending upon the phase number (inversion of swap operation is done after
2^phase_number). A kernel function (gpu_sort) is called from main and then for each phase other
kernel function (gpu_sort_inner) is called.

## Results:
According to my program's output I can say that my program is completing all the basic
requirement, very efficient in speed and also scaled very well. I have summarized the results below.
### Scalability:
Able to run it with 2^25 size of data without any issue. I hope it will scale more than that.
### Sorting: 
Used bitonic sort and working fine.
## Experiment:
### Commands when compiled using main function in sortcu.cu file
nvcc -arch=sm_35 --device-c -o sortcu.o sortcu.cu #to craete object file <br/>
nvcc -arch=sm_35 sortcu.o # this will create output file
### Commands to generate compiled library
nvcc -c -arch=sm_35 --device-c -o sortcu.o sortcu.cu <br/>
ar -rsc libsortcu.a sortcu.o
### Run the file using:
./a.out <br/>
I have checked upto test the data size of 2^25 and it is working fine
without taking much time.
