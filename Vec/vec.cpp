#include <iostream>
#include <cmath>
#include <vector>

double sin_squared(double theta) {
  return sin(theta) * sin(theta);
} 

double cos_squared(double theta) {
  return cos(theta) * cos(theta);
}

int main( int argc, char* argv[] ) {
 
    // Size of vectors
    const int n = 1000000;
 
    // Input vectors
    std::vector<double> a(n);
    std::vector<double> b(n);
    // Output vector
    std::vector<double> c(n);
 
    // Initialize content of input vectors, vector a[i] = sin(i)^2 vector b[i] = cos(i)^2
    for(int i=0; i<n; i++) {
        a[i] = sin_squared(i/M_PI);
        b[i] = cos_squared(i/M_PI);
    }   
 
    // sum component wise and save result into vector c
    for(int i=0; i<n; i++) {
        c[i] = a[i] + b[i];
    }
 
    // Sum up vector c and print result divided by n, this should equal 1 within error
    double sum = 0.0;
    for(int i=0; i<n; i++) {
        sum += c[i];
    }
    sum /= n;
    if(sum - 1.0 < 0.0000001)
      printf("result correct\n");
    else
      printf("result incorrect!\n");
 
    return 0;
}
