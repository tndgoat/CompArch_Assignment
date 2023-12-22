// C++ program for Merge Sort
#include <bits/stdc++.h>
using namespace std;

vector<pair<int, vector<int>>> res;
static int MaxDepth = 0;


void merge(int array[], int const left, int const mid, int const right)
{
	auto const subArrayOne = mid - left + 1;
	auto const subArrayTwo = right - mid;

	auto *leftArray = new int[subArrayOne],
		*rightArray = new int[subArrayTwo];

	for (auto i = 0; i < subArrayOne; i++)
		leftArray[i] = array[left + i];
	for (auto j = 0; j < subArrayTwo; j++)
		rightArray[j] = array[mid + 1 + j];

	auto indexOfSubArrayOne = 0, indexOfSubArrayTwo = 0;
	int indexOfMergedArray = left;

	while (indexOfSubArrayOne < subArrayOne && indexOfSubArrayTwo < subArrayTwo) {
		if (leftArray[indexOfSubArrayOne] <= rightArray[indexOfSubArrayTwo]) {
			array[indexOfMergedArray] = leftArray[indexOfSubArrayOne];
			indexOfSubArrayOne++;
		} else {
			array[indexOfMergedArray] = rightArray[indexOfSubArrayTwo];
			indexOfSubArrayTwo++;
		}
		indexOfMergedArray++;
	}
	while (indexOfSubArrayOne < subArrayOne) {
		array[indexOfMergedArray] = leftArray[indexOfSubArrayOne];
		indexOfSubArrayOne++;
		indexOfMergedArray++;
	}
	while (indexOfSubArrayTwo < subArrayTwo) {
		array[indexOfMergedArray] = rightArray[indexOfSubArrayTwo];
		indexOfSubArrayTwo++;
		indexOfMergedArray++;
	}
	delete[] leftArray;
	delete[] rightArray;

}

void mergeSort(int array[], int const begin, int const end, int level = 0) {
    if (level > MaxDepth) MaxDepth = level + 1;
	if (begin >= end) return;
	auto mid = begin + (end - begin) / 2;

    // cout << "[";
    vector <int> tempLeft;
	for (int i = begin; i <= mid; i++) {
	    tempLeft.push_back(array[i]);
	   // cout << array[i] << " ";
	}
    // cout << "]" << " ";

    // cout << "[";
    vector <int> tempRight;
	for (int i = mid + 1; i <= end; i++) {
	    tempRight.push_back(array[i]);
	   // cout << array[i] << " ";
	}
    // cout << "]" << " " << level << endl;

    res.push_back(make_pair(level, tempLeft));
    res.push_back(make_pair(level, tempRight));

	mergeSort(array, begin, mid, level + 1);

	mergeSort(array, mid + 1, end, level + 1);

	merge(array, begin, mid, end);

    // cout << "[";
    vector <int> temp;
	for (int i=begin; i<=end; i++) {
	    temp.push_back(array[i]);
	   // cout << array[i] << " ";
	}
    // cout << "]" << " " << MaxDepth + 1 - level << endl;

    res.push_back(make_pair(MaxDepth +1 - level, temp));
}

void printArray(int A[], int size) {
	for (auto i = 0; i < size; i++) {
        cout << A[i] << " ";
	}
}

void print(const vector<int>& vec) {
    cout << "[";
    for (auto it = vec.begin(); it != vec.end(); it++) {
        (it == vec.end() - 1) ? printf("%d", *it) : printf("%d, ", *it);
    }
    cout << "]";
}

int main() {
    int vec[] = {-90, -13, -36, -35, 72, -74, 56, -65, -78, -72, 97, -47, -54, -63, 88};

    int vec_size = sizeof(vec)/sizeof(vec[0]);

    mergeSort(vec, 0, vec_size - 1);
    for (int i = -1; i < MaxDepth + 2; i++) {
        for (pair<int, vector<int>> e : res) {
            if (e.first == i) {
                print(e.second);
                cout << "  ";
            }
        }
        cout << "\n";
    }
}
