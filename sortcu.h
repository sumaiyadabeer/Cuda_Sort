#pragma once

__global__ void sortcu(int *data, int ndata); // Sorting Kernel runs on GPU
void sort(int *data, int ndata); // Host sort function, uses cusort

