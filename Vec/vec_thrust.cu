#include <iostream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <thrust/device_vector.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/transform.h>
#include <thrust/tuple.h>
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>

using namespace thrust;

int main( int argc, char* argv[] ) {
 
    // Size of vectors
    const int n = 1000000;
 
    // Input device vectors
    device_vector<double> a(n);
    device_vector<double> b(n);
    // Output device  vector
    device_vector<double> c(n);
 
    // Create counting iterators to describe our vectors
    auto begin_index = counting_iterator<int>(0);
    auto end_index   = begin_index + n;

    // Unary transform: a_i = sin^2(i/pi)
    transform(thrust::device,      // Execution policy
              begin_index,         // Input begin
              end_index,           // Input end
              a.begin(),           // Output begin
              [] __device__ (int i) {
      return sin(i/M_PI) * sin(i/M_PI);
    });

    // Unary transform: b_i = cos^2(i/pi)
    transform(thrust::device,
              begin_index,
              end_index,
              b.begin(),
             [] __device__ (int i) {
      return cos(i/M_PI) * cos(i/M_PI);
    });

    // Zip vectors a,b together
    auto begin_zip = make_zip_iterator(make_tuple(a.begin(), b.begin()));
    auto end_zip = begin_zip + n;

    // Binary transform: c_i = a_i + b_i
    transform(thrust::device,
              begin_zip,
              end_zip,
              c.begin(),
              [] __device__ (const tuple<double,double>& tuple_i) {
       double a_i, b_i;
       tie(a_i, b_i) = tuple_i;
       return a_i + b_i;   
    });

    // Sum up vector c and print result divided by n, this should equal 1 within error
    double sum = reduce(thrust::device, c.begin(), c.end());
    sum /= n;
    if(sum - 1.0 < 0.0000001)
      printf("result correct\n");
    else
      printf("result incorrect!\n");

    return 0;
}
