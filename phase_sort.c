//Copyright TheZouave007 (2024)
//All rights reserved, see License.txt for details

#include<stdio.h>
#include<stdlib.h>
#include<time.h>

void _phase_sort1(int* array, int size, int offset, int stride) {
	if (offset + stride >= size) {
		return;
	}
	_phase_sort1(array, size, offset       , stride*2);
	_phase_sort1(array, size, offset+stride, stride*2);
	
	int tail = offset, head = offset + stride;
	while(head < size) {
		if (array[head] < array[tail]) {
			int temp = array[head];
			for (int i = head; i > tail; i -= stride) {
				array[i] = array[i-stride];
			}
			array[tail] = temp;
			head += 2* stride;
		}
		tail += stride;
		head += (tail == head) ? stride : 0;
	}
}

void phase_sort1(int* array, int size) {
	_phase_sort1(array, size, 0, 1);
}

//round down to the nearest power of 2
int pow2floor(int a) {
	a |= a>>1;
	a |= a>>2;
	a |= a>>4;
	a |= a>>8;
	a |= a>>16;
	return a - (a >> 1);
}

void phase_sort2(int* array, int size) {
	for (int stride = pow2floor(size-1); stride > 0; stride >>= 1) {
		for (int offset = 0; offset < stride && offset + stride < size; offset++) {
			int tail = offset, head = offset + stride;
			while(head < size) {
				if (array[head] < array[tail]) {
					int temp = array[head];
					for (int i = head; i > tail; i -= stride) {
						array[i] = array[i-stride];
					}
					array[tail] = temp;
					head += 2* stride;
				}
				tail += stride;
				head += (tail == head) ? stride : 0;
			}
		}
	}
}

#define ARR_SIZE 65536
#define NUM_METHODS 4

extern void phase_sort3(int*, int);
extern void phase_sort4(int*, int);

typedef void (*f)(int*, int);

f methods[NUM_METHODS] = {phase_sort1, phase_sort2, phase_sort3, phase_sort4};

void main() {
	int* build_random_numbers[NUM_METHODS];
	double cpu_time_used[NUM_METHODS];
	
	for (int i = 0; i < NUM_METHODS; i++) {
		build_random_numbers[i] = (int*)malloc(ARR_SIZE * sizeof(int));
	}
	int seed = time(NULL);
	srand(seed);
	
	for (int i = 0; i < ARR_SIZE; i++) {
		build_random_numbers[0][i] = rand() % 65536;
	}
	for (int i = 1; i < NUM_METHODS; i++) {
		for (int j = 0; j < ARR_SIZE; j++) {
			build_random_numbers[i][j] = build_random_numbers[0][j];
		}
	}
	for (int i = 0; i < NUM_METHODS; i++) {
		clock_t start = clock();
		
		methods[i](build_random_numbers[i], ARR_SIZE);
		
		clock_t end = clock();
		
		for (int j = 0; j < ARR_SIZE-1; j++) {
			if (build_random_numbers[i][j] > build_random_numbers[i][j+1]) {
				printf("Sort Method %i Failed! seed = %d, i = %d\n", i, seed, j);
			}
		}
		cpu_time_used[i] = ((double) (end - start)) / CLOCKS_PER_SEC;
	}
	for (int i = 0; i < NUM_METHODS; i++) {
		printf("Method %i sorted %d numbers in %f seconds!\n",
			i, ARR_SIZE, cpu_time_used[i]);
	}
}
