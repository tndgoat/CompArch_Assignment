#include <bits/stdc++.h>
using namespace std;

int binRead(int outputArray[], const string& fileName, const unsigned int length) {
	ifstream inputData;
	inputData.open(fileName);
	if (inputData) {
		inputData.read(reinterpret_cast<char *>(outputArray), sizeof(int) * length);
		inputData.close();
		return 0;
	}
	else return -1;
}

int binWrite(const int inputArray[], const string& fileName, const unsigned int length) {
	ofstream outputData;
	outputData.open(fileName);
	if (outputData) {
		outputData.write(reinterpret_cast<const char *>(inputArray), sizeof(int) * length);
		outputData.close();
		return 0;
	}
	else return -1;
}

int main() {
	int error;
	int x[] = {-90, -13, -36, -35, 72, -74, 56, -65, -78, -72, 97, -47, -54, -63, 88};
	error = binWrite(x, "test_case_18.bin", 15);
	if (error == 0) error = binRead(x, "test_case_18.bin", 15);
	for (int i = 0; i < 15; i++) {
        cout << x[i] << " ";
	}
	// cout << "x = " << x[0] << ", " << x[1] << ", " << x[2] << endl;
	// cout << "y = " << y[0] << ", " << y[1] << ", " << y[2] << endl;

	// //Stack
	// int z[1024];
	// error = binWrite(z ,"largeFile.bin", 1024);

	// //Heap
	// int *k = new int[2000000];
	// error = binWrite(k, "verylargeFile.bin", 2000000);

	// getchar();
    return error;
}






// int main()
// {
//     int arr[5] = {1,4,9,2,3};
//     fstream file("test.bin", ios::binary | ios::in | ios::out | ios::trunc);
//     file.write((char*) &arr, sizeof(arr));

//     int brr[5];
//     file.read((char*) &brr, sizeof(brr));
//     for (int i=0; i<5; i++)
//         cout << brr[i] << " ";
// }
