#include <iostream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <thrust/device_vector.h>
#include <thrust/for_each.h>
#include <thrust/reduce.h>
#include <thrust/pair.h>

__device__ double sin_squared(double theta) {
  return sin(theta) * sin(theta);
} 

__device__ double cos_squared(double theta) {
  return cos(theta) * cos(theta);
}

int main( int argc, char* argv[] ) {
 
    // Size of vectors
    const int n = 1000000;
 
    // Input device vectors
    thrust::device_vector<double> a(n);
    thrust::device_vector<double> b(n);
    // Output device  vector
    thrust::device_vector<double> c(n);
 
    // Create counting iterators to describe our vectors
    const auto begin_index = thrust::counting_iterator<int>(0);
    const auto end_index   = thrust::counting_iterator<int>(n);

    // Unary transform: a_i = sin^2(i/pi)
    thrust::transform(begin_index,         // Input begin
                      end_index,           // Input end
                      a.begin(),           // Output begin
                      [] __device__ (int i) {
      return sin_squared(i/M_PI);
    });

    // Unary transform: b_i = cos^2(i/pi)
    thrust::transform(begin_index,         // Input begin
                      end_index,           // Input end
                      b.begin(),           // Output begin
                      [] __device__ (int i) {
      return cos_squared(i/M_PI);
    });

    // Tie our vectors a,b together
    auto begin_zip = thrust::make_zip_iterator(thrust::make_tuple(a.begin(), b.begin()));
    auto end_zip = thrust::make_zip_iterator(thrust::make_tuple(a.end(), b.end()));

    typedef thrust::tuple<double, double> double_tuple;

    // Binary transform: c_i = a_i + b_i
    thrust::transform(begin_zip,
                      end_zip,
                      c.begin(),
                      [] __device__ (const double_tuple& pair_i) {
       double a_i, b_i;
       thrust::tie(a_i, b_i) = pair_i;
       return a_i + b_i;   
    });

    // Sum up vector c and print result divided by n, this should equal 1 within error
    double sum = thrust::reduce(c.begin(), c.end());
    sum /= n;
    if(sum - 1.0 < 0.0000001)
      printf("result correct\n");
    else
      printf("result incorrect!\n");

    return 0;
}
