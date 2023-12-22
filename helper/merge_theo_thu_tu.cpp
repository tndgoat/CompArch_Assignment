#include <bits/stdc++.h>
using namespace std;

void merge(int arr[], int const left, int const mid, int const right) {
	auto const len1 = mid - left + 1;
	auto const len2 = right - mid;

	auto *leftArray = new int[len1];
    auto *rightArray = new int[len2];

	for (auto i = 0; i < len1; i++) {
        leftArray[i] = arr[left + i];
	}
	for (auto j = 0; j < len2; j++) {
        rightArray[j] = arr[mid + 1 + j];
	}

	int index1 = 0;
    int index2 = 0;
	int indexMerge = left;

	while (index1 < len1 && index2 < len2) {
		if (leftArray[index1] <= rightArray[index2]) {
			arr[indexMerge] = leftArray[index1];
			index1++;
		} else {
			arr[indexMerge] = rightArray[index2];
			index2++;
		}
		indexMerge++;
	}

	while (index1 < len1) {
		arr[indexMerge] = leftArray[index1];
		index1++;
		indexMerge++;
	}

	while (index2 < len2) {
		arr[indexMerge] = rightArray[index2];
		index2++;
		indexMerge++;
	}
	delete[] leftArray;
	delete[] rightArray;
}

void mergeSort(int arr[], int const left, int const right) {
	if (left >= right) return;
	auto mid = left + (right - left)/2;

    cout << "[";
	for (int i = left; i < mid; i++) {
	    cout << arr[i] << " ";
	}
    cout << arr[mid] << "]" << " ";

    cout << "[";
	for (int i = mid + 1; i < right; i++) {
	    cout << arr[i] << " ";
	}
    cout << arr[right] << "]" << " " << endl;


	mergeSort(arr, left, mid);

	mergeSort(arr, mid + 1, right);

	merge(arr, left, mid, right);

    cout << "[";
	for (int i = left; i < right; i++) {
	    cout << arr[i] << " ";
	}
	cout << arr[right] << "]" << endl;
}

void printArray(int arr[], int size) {
	for (auto i = 0; i < size; i++)
		cout << arr[i] << " ";
}

int main() {
    int arr[] = {-90, -13, -36, -35, 72, -74, 56, -65, -78, -72, 97, -47, -54, -63, 88};
	auto arr_size = sizeof(arr) / sizeof(arr[0]);

	cout << "Given array is \n";
	printArray(arr, arr_size);
	cout << "\n";

	mergeSort(arr, 0, arr_size - 1);

	cout << "\nSorted array is \n";
	printArray(arr, arr_size);
	return 0;
}
