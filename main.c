#include <stdio.h>
#include <stdlib.h>

extern int imgAvgFilter(int* input_image, int* filtered_image, int image_size_x, int image_size_y, int sampling_window_size);


//input_image 1d array 
//filtered_image 1d array 

int main () {
	
	int image_size_x, image_size_y, sampling_window_size;

    // Get input for image_size_x
    do {
        printf("Enter image size x (greater than 2): ");
        scanf("%d", &image_size_x);
    } while (image_size_x <= 2);

    // Get input for image_size_y
    do {
        printf("Enter image size y (greater than 2): ");
        scanf("%d", &image_size_y);
    } while (image_size_y <= 2);

    // Get input for sampling_window_size (positive odd integer greater than 1)
    do {
        printf("Enter sampling window size (positive odd integer greater than 1): ");
        scanf("%d", &sampling_window_size);
    } while (sampling_window_size <= 1 || sampling_window_size % 2 == 0 || sampling_window_size > image_size_x || sampling_window_size > image_size_y);
	
	int* input_image = (int*)malloc(image_size_x * image_size_y * sizeof(*input_image));
	
	printf("Enter %d elements for the input image:\n", image_size_x * image_size_y);
    for (int i = 0; i < image_size_x * image_size_y; i++) {
        scanf("%d", &input_image[i]);
    }
	
	int* filtered_image = (int*)malloc(image_size_x * image_size_y * sizeof(*filtered_image));
	//int input_image[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3};
	//int* filtered_image;
	//filtered_image = (int*)malloc(35*sizeof(*filtered_image));
	//int image_size_x = 5;
	//int image_size_y = 7;
	//int sampling_window_size = 3;
	
	int c = imgAvgFilter(input_image, filtered_image, image_size_x, image_size_y, sampling_window_size);
	printf("The inputs are: image x = %d, image y = %d, sample size = %d\n", image_size_x, image_size_y, sampling_window_size);
	printf("original\n");

    for (int i = 0; i < image_size_x * image_size_y; i++) {
        printf("%-5d", input_image[i]);
        if (i % image_size_x == image_size_x - 1)
            printf("\n");
        else
            printf(" ");
    }

    printf("filtered\n");

    for (int i = 0; i < image_size_x * image_size_y; i++) {
        printf("%-5d", filtered_image[i]);
        if (i % image_size_x == image_size_x - 1)
            printf("\n");
        else
            printf(" ");
    }
	
	free(input_image);
    free(filtered_image);
    
    printf("Enter a int to close:");
    scanf("%d", &image_size_x);
	
	return 0;
}
