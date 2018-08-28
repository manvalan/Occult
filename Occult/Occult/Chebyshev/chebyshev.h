//
//  chebyshev.h
//  ChebTest
//
//  Created by Michele Bigi on 14/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

#ifndef chebyshev_h
#define chebyshev_h

#include <stdio.h>

void setTable( double * tx , double * ty, int len );
double *chebyshev_coefficients_n( double a, double b, int n );
//double *chebyshev_coefficients ( double a, double b, int n,
//                                double f ( double x ) );
double *chebyshev_coefficients ( double a, double b, int n,
                                double f ( double x , int i) );
double *chebyshev_interpolant ( double a, double b, int n, double c[], int m,
                               double x[] );
double *chebyshev_zeros ( int n );
void timestamp ( void );

#endif /* chebyshev_h */
