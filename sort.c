#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sort.h"
#include "read_data.h"

/* 
 * Takes a file name as input from command line
 * which contains array of integers. These are
 * sorted either in ascending order or descending
 * order. The array is printed out both pre- and 
 * post-sort.
 *
 * DO NOT EDIT THIS MAIN FUNCTION 
 */
int
main(int argc, char **argv)
{
	int i;
        int num;
	int to_sort_array[MAX_NUM];
	int sorted_array[MAX_NUM];
	
	if (argc != 2) {
		perror("Input arguments are not correct.\n");
		return 1;
	}

	/* Fill the input array */
	num = fillInput(to_sort_array, argv[1]);
	if (num <= 0) {
		perror("Data initilization error.\n");
		return 1;
	}

	/* Print input and sort */
	printf("Unsorted array:\t");
	for (i = 0; i < num; i++) {
		printf("%d ",to_sort_array[i]);
	}
	printf("\n");

	merge_sort(to_sort_array, sorted_array, num);
#ifdef DSC
	printf("Sorted (descending) array: ");
#elif ASC
	printf("Sorted (ascending) array: ");
#endif
	for (i = 0; i < num; i++) {
		printf("%d ",sorted_array[i]);
	}
	printf("\n");
	return 0;
}

/* Define the comparison to be used based on the DSC/ASC */
#ifdef DSC
#define COMPARATOR >=
#else
#define COMPARATOR <=
#endif

/*
 * Sorts the input array in the defined direction. The result will be placed
 * into the output array, and the data in the input array will put into an
 * undetermined state.
 */
void 
merge_sort(int input_array[], int output_array[], int num)
{
	/* Just copy the one element if there is only one. */
	if (num == 1) {
		output_array[0] = input_array[0];
		return;
	}

	int mid = num/2;
	/* 
	 * Sort the first and second halves of the input array
	 * into the output.
	 */
	merge_sort(input_array, output_array, mid);
	merge_sort(input_array+mid, output_array+mid, num-mid);

	/* Merge the two lists back into the input */
	int i0 = 0;
	int i1 = mid;
	int j;
	for (j = 0; j < num; ++j) {
		if (i0 < mid && (i1 >= num || output_array[i0] COMPARATOR output_array[i1])) {
			input_array[j] = output_array[i0];
			i0++;
		} else {
			input_array[j] = output_array[i1];
			i1++;
		}
	}

	/* Copy the input list into the output */
	for (j = 0; j < num; ++j) {
		output_array[j] = input_array[j];
	}
}
