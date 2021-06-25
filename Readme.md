#i have tested using main function in sortcu.cu file since input from tester4 is giving conversion error on hpc.

#used sm_35 architecture because other does not support call from kernel function to kernel.

#given below are commands when compiled using main function in sortcu.cu file

nvcc -arch=sm_35 --device-c -o sortcu.o sortcu.cu #to craete object file
nvcc -arch=sm_35 sortcu.o # this will create output file

#given below are commands to generate compiled library

nvcc -c -arch=sm_35 --device-c -o sortcu.o sortcu.cu
ar -rsc libsortcu.a sortcu.o
