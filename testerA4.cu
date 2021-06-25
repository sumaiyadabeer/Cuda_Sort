#include <iostream>
#include <ctime> 
#include <time.h>
#include <fstream>
#include <string>
#include <bits/stdc++.h> 

#include "sortcu.h"

using namespace std;

int* read_raw_file(int ndata, string unsorted_filename) {
    ifstream fin;
    fin.open(unsorted_filename);

    string line;
    int *test_data = new int[ndata];

    for (int i = 0; i < ndata; i++) {
        getline(fin, line);
        stringstream str(line);

        str >> test_data[i];
    }

    fin.close();
    return test_data;
}

bool check_sorted(int *test_data, int ndata, string sorted_filename) {
    ifstream fin;
    fin.open(sorted_filename);

    string line;
    int ith_data = 0;

    for (int i = 0; i < ndata; i++) {
        getline(fin, line);
        stringstream str(line);

        str >> ith_data;
        if (test_data[i] != ith_data) {
            cout << "data@" << i << " is " << test_data[i] << " must be " << ith_data << endl;  
            fin.close();
            return false;
        }
    }

    return true;
}

void runExperiment(int ndata, string sorted_filename, string unsorted_filename) {
    int *test_data  = read_raw_file(ndata, unsorted_filename);

    /*Calling functions defined in pSort library to sort records stored in test_data[]*/
    time_t begin,end;
    time(&begin);
    sort(test_data, ndata);
    time(&end);

    double time_taken = difftime(end,begin);
    bool success_status = check_sorted(test_data, ndata, sorted_filename);

    if (success_status) 
        cout << "success in " << time_taken << endl;
    else
        cout << "failed" << endl;
}

int main(int argc,  char *argv[]) {
    int datasize = 0;
    string sorted_filename = "";
    string unsorted_filename = "";
    
	if (argc < 2) {
		cout << "supply datasize and filenames\n";
		exit(0);
	}

    if (argc < 4) {
		cout << "supply filenames\n";
		exit(0);
	}

    datasize = strtol(argv[1], NULL, 10);
    sorted_filename = argv[2];
    unsorted_filename = argv[3];
	
    runExperiment(datasize, sorted_filename, unsorted_filename);

    return 0;
}