#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

double sin_squared(float theta) {
  return sin(theta) * sin(theta);
} 

double cos_squared(float theta) {
  return cos(theta) * cos(theta);
}

int main( int argc, char* argv[] ) {
 
    // Size of vectors
    int n = 1000000;
    int teams = 0;
    int threads = 0;
 
    // Input vectors
    double *restrict a;
    double *restrict b;
    // Output vector
    double *restrict c;
 
    // Size, in bytes, of each vector
    size_t bytes = n*sizeof(double);
 
    #pragma omp target teams
    {
        threads = omp_get_num_threads();
        teams = omp_get_num_teams();
    }

    printf("Teams = %d, Threads = %d \n",teams,threads);

    // Allocate memory for each vector
    a = (double*)malloc(bytes);
    b = (double*)malloc(bytes);
    c = (double*)malloc(bytes);
    #pragma omp target data map(alloc:a[0:n],b[0:n],c[0:n]) map(from:c)
    {

    // Initialize content of input vectors, vector a[i] = sin(i)^2 vector b[i] = cos(i)^2
    int i;
    #pragma omp target teams distribute parallel for
    for(i=0; i<n; i++) {
        a[i] = sin_squared(i/M_PI);;
        b[i] = cos_squared(i/M_PI);
    }   

    // sum component wise and save result into vector c
    #pragma omp target teams distribute parallel for
    for(i=0; i<n; i++) {
        c[i] = a[i] + b[i];
    }
 
    // Sum up vector c and print result divided by n, this should equal 1 within error
    double sum = 0.0;
    #pragma omp target teams distribute parallel for reduction(+:sum)
    for(i=0; i<n; i++) {
        sum += c[i];
    }
    
    
    sum /= n;
    if(sum - 1.0 < 0.0000001)
      printf("result correct: %f\n",sum);
    else
      printf("result incorrect!\n");
 
    }
    // Release memory
    free(a);
    free(b);
    free(c);
 
    return 0;
}
