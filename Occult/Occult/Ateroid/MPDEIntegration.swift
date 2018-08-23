//
//  MO_DEIntegration.swift
//  Occult
//
//  Created by Michele Bigi on 14/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

let maxnum  = 500           // Maximum number of steps to take
let umach   = Double.ulpOfOne
let twou    = umach * 2
let four    = umach * 4

func sign( a: Double, b: Double)->Double {
    return (b>=0.0) ? fabs(a) : -fabs(a)
}

enum DE_STATE : Int {
    case DE_INIT                  = 1    // Starting step
    case DE_DONE                  = 2    // Successful integration step
    case DE_ACCURACY_NOT_ACHIEVED = 3    // Too stringent accuracy requirements
    case DE_TOO_MANY_STEPS        = 4    // Too many steps required
    case DE_STIFF                 = 5    // Suspect of stiff differential equation
    case DE_INVALID_PARAMS        = 6     // Invalid input
}

class MP_DEIntegration {
    var NEqn : Int
    
    var yy :[Double]
    var wt  :[Double]
    var p  :[Double]
    var yp :[Double]
    var ypout :[Double]
    var phi :[[Double]]
    
    var alpha :[Double] = [Double]( repeating: 0.0, count: 13 )
    var beta  :[Double] = [Double]( repeating: 0.0, count: 13 )
    var v     :[Double] = [Double]( repeating: 0.0, count: 13 )
    var w     :[Double] = [Double]( repeating: 0.0, count: 13 )
    var psi   :[Double] = [Double]( repeating: 0.0, count: 13 )
    
    var sig   :[Double] = [Double]( repeating: 0.0, count: 14 )
    var g     :[Double] = [Double]( repeating: 0.0, count: 14 )
    
    var x : Double = 0.0
    var h : Double = 0.0
    var hold: Double = 0.0
    var told: Double = 0.0
    var delsgn: Double = 0.0
    var ns   :Int = 0
    var k    :Int = 0
    var kold :Int = 0
    
    var OldPermit : Bool = false
    var phase1    : Bool = false
    var start     : Bool = false
    var nornd     : Bool = false

    init( aNqen :Int) {
        NEqn = aNqen
        yy = [Double]( repeating: 0.0 , count: Neqn + 1 )
        wt = [Double]( repeating: 0.0 , count: Neqn + 1 )
        p = [Double]( repeating: 0.0 , count: Neqn + 1 )
        yp = [Double]( repeating: 0.0 , count: Neqn + 1 )
        ypout = [Double]( repeating: 0.0 , count: Neqn + 1 )
        phi = Array(repeating: Array<Double>(repeating: 0.0, count: 17), count: Neqn+1)
    }
    
    func Interp( x :Double, y :[Double], xout :Double, yout :inout [Double], ypout :inout [Double]){
        
        var i      :Int = 0
        var jm1    :Int = 0
        var ki     :Int = 0
        var kip1   :Int = 0
        var limit1 :Int = 0
        var eta    :Double = 0.0
        var gamma  :Double = 0.0
        var hi     :Double = 0.0
        var psijm1 :Double = 0.0
        var temp2  :Double = 0.0
        var temp3  :Double = 0.0
        var term   :Double = 0.0
        var g      :[Double] = [Double]( repeating: 0.0, count: 14 )
        var rho    :[Double] = [Double]( repeating: 0.0, count: 14 )
        var w      :[Double] = [Double]( repeating: 0.0, count: 14 )
        
        g[1]   = 1.0
        rho[1] = 1.0
        
        hi = xout - x
        ki = kold + 1
        kip1 = ki + 1
        
        // Initialize W[*] for computing G[*]
        for i in 1...ki {
            w[i] = 1.0 / Double(i)
        }
        term = 0.0
        
        // compute G[*]
        for j in 2 ... ki {
            jm1 = j - 1
            psijm1 = psi[jm1]
            gamma =  (hi + term) / psijm1
            eta = hi / psijm1
            limit1 = kip1 - j
            for i in 1 ... limit1 {
                w[i] = gamma * w[i] - eta * w[i+1]
            }
            g[j]   = w[i]
            rho[j] = gamma * rho[jm1]
            term = psijm1
        }
        
        // Interpolate for the solution YOUT and for
        // the derivative of the solution YPOUT
        
        for l in 1 ... Neqn {
            ypout[l] = 0.0
            yout[l]  = 0.0
        }
        for j in 1 ... ki {
            i = kip1 - j
            temp2 = g[i]
            temp3 = rho[i]
            for l in 1 ... Neqn {
                yout[l]  +=  temp2 * phi[l][i]
                ypout[l] +=  temp3 * phi[l][i]
            }
        }
        for l in 1 ... Neqn {
            yout[l] = y[l] + hi * yout[l]
        }
    }
    
    func Step( x :inout Double, y:inout [Double], eps :inout Double, crash :inout Bool ) {
        let two :[Double] = [ 1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0, 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0 ]
        let gstr:[Double] = [ 1.0, 0.5, 0.0833, 0.0417, 0.0264, 0.0188, 0.0143, 0.0114, 0.00936, 0.00789, 0.00679, 0.00592, 0.00524, 0.00468 ]
    }
}
/******
 void APSDE :: Step( double& x, double y[], double& eps, bool& crash )
 {
 //
 // Constants
 //
 static const double two[14] = // Powers of two (two(n)=2**n)
 { 1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0,
 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0 };
 
 static const double gstr[14] =
 {1.0, 0.5, 0.0833, 0.0417, 0.0264, 0.0188,
 0.0143, 0.0114, 0.00936, 0.00789, 0.00679,
 0.00592, 0.00524, 0.00468 };
 
 
 //
 // Variables
 //
 bool    success;
 int     i,ifail, im1, ip1, iq, j, km1, km2, knew, kp1, kp2;
 int     l, limit1, limit2, nsm2, nsp1, nsp2;
 double  absh, erk, erkm1, erkm2, erkp1, err, hnew;
 double  p5eps, r, reali, realns, rho, round, sum, tau, temp1;
 double  temp2, temp3, temp4, temp5, temp6, xold;
 
 
 //
 // Begin block 0
 //
 // Check if step size or error tolerance is too small for machine
 // precision.  If first step, initialize PHI array and estimate a
 // starting step size. If step size is too small, determine an
 // acceptable one.
 //
 if (fabs(h) < fouru*fabs(x)) {
 h = sign(fouru*fabs(x),h);
 crash = true;
 return;  // exit
 };
 
 p5eps  = 0.5*eps;
 crash  = false;
 g[1]   = 1.0;
 g[2]   = 0.5;
 sig[1] = 1.0;
 
 ifail = 0;
 
 
 // If error tolerance is too small, increase it to an
 // acceptable value.
 round = 0.0;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) round += (y[l]*y[l])/(wt[l]*wt[l]);
 round = twou*sqrt(round);
 if (p5eps<round) {
 eps = 2.0*round*(1.0+fouru);
 crash = true;
 return;
 };
 
 
 if (start) {
 // Initialize. Compute appropriate step size for first step.
 GetIntegFunction()->Run(x, y, yp);
 sum = 0.0;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][1] = yp[l];
 phi[l][2] = 0.0;
 sum += (yp[l]*yp[l])/(wt[l]*wt[l]);
 }
 sum = sqrt(sum);
 absh = fabs(h);
 if (eps<16.0*sum*h*h) absh=0.25*sqrt(eps/sum);
 h = sign(max(absh, fouru*fabs(x)), h);
 hold = 0.0;
 hnew = 0.0;
 k = 1;
 kold = 0;
 start = false;
 phase1 = true;
 nornd = true;
 if (p5eps<=100.0*round) {
 nornd = false;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][15]=0.0;
 };
 };
 
 //
 // End block 0
 //
 
 
 //
 // Repeat blocks 1, 2 (and 3) until step is successful
 //
 do {
 
 //
 // Begin block 1
 //
 
 // Compute coefficients of formulas for this step. Avoid computing
 // those quantities not changed when step size is not changed.
 //
 kp1 = k+1;
 kp2 = k+2;
 km1 = k-1;
 km2 = k-2;
 
 // NS is the number of steps taken with size H, including the
 // current one.  When K<NS, no coefficients change.
 if (h !=hold)  ns=0;
 if (ns<=kold)  ns=ns+1;
 nsp1 = ns+1;
 
 if (k>=ns) {
 
 // Compute those components of alpha[*],beta[*],psi[*],sig[*]
 // which are changed
 beta[ns] = 1.0;
 realns = ns;
 alpha[ns] = 1.0/realns;
 temp1 = h*realns;
 sig[nsp1] = 1.0;
 if (k>=nsp1) {
 for (i=nsp1;i<=k;i++) {
 im1 = i-1;
 temp2 = psi[im1];
 psi[im1] = temp1;
 beta[i] = beta[im1]*psi[im1]/temp2;
 temp1 = temp2 + h;
 alpha[i] = h/temp1;
 reali = i;
 sig[i+1] = reali*alpha[i]*sig[i];
 };
 };
 psi[k] = temp1;
 
 
 // Compute coefficients g[*]; initialize v[*] and set w[*].
 if (ns>1) {
 
 // If order was raised, update diagonal part of V[*]
 if (k>kold) {
 temp4 = k*kp1;
 v[k] = 1.0/temp4;
 nsm2 = ns-2;
 for (j=1;j<=nsm2;j++) {
 i = k-j;
 v[i] = v[i] - alpha[j+1]*v[i+1];
 };
 };
 
 // Update V[*] and set W[*]
 limit1 = kp1 - ns;
 temp5 = alpha[ns];
 for (iq=1;iq<=limit1;iq++) {
 v[iq] = v[iq] - temp5*v[iq+1];
 w[iq] = v[iq];
 };
 
 g[nsp1] = w[1];
 }
 else {
 for (iq=1;iq<=k;iq++) {
 temp3 = iq*(iq+1);
 v[iq] = 1.0/temp3;
 w[iq] = v[iq];
 };
 };
 
 
 // Compute the g[*] in the work vector w[*]
 nsp2 = ns + 2;
 if (kp1>=nsp2) {
 for (i=nsp2;i<=kp1;i++) {
 limit2 = kp2 - i;
 temp6 = alpha[i-1];
 for (iq=1;iq<=limit2;iq++) w[iq] = w[iq] - temp6*w[iq+1];
 g[i] = w[1];
 };
 };
 
 }; // if K>=NS
 
 //
 // End block 1
 //
 
 
 //
 // Begin block 2
 //
 // Predict a solution p[*], evaluate derivatives using predicted
 // solution, estimate local error at order k and errors at orders
 // k, k-1, k-2 as if constant step size were used.
 //
 
 // Change phi to phi star
 if (k>=nsp1) {
 for (i=nsp1;i<=k;i++) {
 temp1 = beta[i];
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][i] = temp1 * phi[l][i];
 }
 };
 
 
 // Predict solution and differences
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][kp2] = phi[l][kp1];
 phi[l][kp1] = 0.0;
 p[l] = 0.0;
 };
 for (j=1;j<=k;j++) {
 i = kp1 - j;
 ip1 = i+1;
 temp2 = g[i];
 for (l=1; l<=GetIntegFunction()->GetNeqn();l++) {
 p[l] = p[l] + temp2*phi[l][i];
 phi[l][i] = phi[l][i] + phi[l][ip1];
 };
 };
 if (nornd) {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) p[l] = y[l] + h*p[l];
 }
 else {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 tau = h*p[l] - phi[l][15];
 p[l] = y[l] + tau;
 phi[l][16] = (p[l] - y[l]) - tau;
 };
 };
 xold = x;
 x = x + h;
 absh = fabs(h);
 GetIntegFunction()->Run(x, p, yp);
 
 
 // Estimate errors at orders k, k-1, k-2
 erkm2 = 0.0;
 erkm1 = 0.0;
 erk = 0.0;
 
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 temp3 = 1.0/wt[l];
 temp4 = yp[l] - phi[l][1];
 if (km2> 0) erkm2 = erkm2 + ((phi[l][km1]+temp4)*temp3)
 *((phi[l][km1]+temp4)*temp3);
 if (km2>=0) erkm1 = erkm1 + ((phi[l][k]+temp4)*temp3)
 *((phi[l][k]+temp4)*temp3);
 erk = erk + (temp4*temp3)*(temp4*temp3);
 };
 
 if (km2> 0)  erkm2 = absh*sig[km1]*gstr[km2]*sqrt(erkm2);
 if (km2>=0)  erkm1 = absh*sig[k]*gstr[km1]*sqrt(erkm1);
 
 temp5 = absh*sqrt(erk);
 err = temp5*(g[k]-g[kp1]);
 erk = temp5*sig[kp1]*gstr[k];
 knew = k;
 
 // Test if order should be lowered
 if (km2 >0) if (max(erkm1,erkm2)<=erk) knew=km1;
 if (km2==0) if (erkm1<=0.5*erk) knew=km1;
 
 //
 // End block 2
 //
 
 //
 // If step is successful continue with block 4, otherwise repeat
 // blocks 1 and 2 after executing block 3
 //
 
 success = (err<=eps);
 
 if (!success) {
 
 //
 // Begin block 3
 //
 
 // The step is unsuccessful. Restore x, phi[*,*], psi[*]. If
 // 3rd consecutive failure, set order to 1. If step fails more
 // than 3 times, consider an optimal step size. Double error
 // tolerance and return if estimated step size is too small
 // for machine precision.
 //
 
 // Restore x, phi[*,*] and psi[*]
 phase1 = false;
 x = xold;
 for (i=1;i<=k;i++) {
 temp1 = 1.0/beta[i];
 ip1 = i+1;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][i]=temp1*(phi[l][i]-phi[l][ip1]);
 };
 
 if (k>=2)
 for (i=2;i<=k;i++) psi[i-1] = psi[i] - h;
 
 
 // On third failure, set order to one.
 // Thereafter, use optimal step size
 ifail++;
 temp2 = 0.5;
 if (ifail>3)
 if (p5eps < 0.25*erk) temp2 = sqrt(p5eps/erk);
 if (ifail>=3) knew = 1;
 h = temp2*h;
 k = knew;
 if (fabs(h)<fouru*fabs(x)) {
 crash = true;
 h = sign(fouru*fabs(x), h);
 eps *= 2.0;
 return;   // exit
 };
 
 //
 // End block 3, return to start of block 1
 //
 
 };  // end if(successful)
 
 }
 while (!success);
 
 
 //
 // Begin block 4
 //
 // The step is successful. Correct the predicted solution, evaluate
 // the derivatives using the corrected solution and update the
 // differences. Determine best order and step size for next step.
 //
 
 kold = k;
 hold = h;
 
 
 // Correct and evaluate
 temp1 = h*g[kp1];
 if (nornd)
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) y[l] = p[l] + temp1*(yp[l] - phi[l][1]);
 else
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 rho = temp1*(yp[l] - phi[l][1]) - phi[l][16];
 y[l] = p[l] + rho;
 phi[l][15] = (y[l] - p[l]) - rho;
 };
 
 GetIntegFunction()->Run(x,y,yp);
 
 
 // Update differences for next step
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][kp1] = yp[l] - phi[l][1];
 phi[l][kp2] = phi[l][kp1] - phi[l][kp2];
 };
 for (i=1;i<=k;i++)
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++)
 phi[l][i] = phi[l][i] + phi[l][kp1];
 
 
 // Estimate error at order k+1 unless
 // - in first phase when always raise order,
 // - already decided to lower order,
 // - step size not constant so estimate unreliable
 erkp1 = 0.0;
 if ( (knew==km1) || (k==12) )  phase1=false;
 
 if (phase1) {
 k = kp1;
 erk = erkp1;
 }
 else {
 if (knew==km1) {
 // lower order
 k = km1;
 erk = erkm1;
 }
 else {
 
 if (kp1<=ns) {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++)
 erkp1 = erkp1 + (phi[l][kp2]/wt[l])*(phi[l][kp2]/wt[l]);
 erkp1 = absh*gstr[kp1]*sqrt(erkp1);
 
 // Using estimated error at order k+1, determine
 // appropriate order for next step
 if (k>1) {
 if ( erkm1<=min(erk,erkp1)) {
 // lower order
 k=km1; erk=erkm1;
 }
 else {
 if ( (erkp1<erk) && (k!=12) ) {
 // raise order
 k=kp1; erk=erkp1;
 };
 };
 }
 else {
 if (erkp1<0.5*erk) {
 // raise order
 // Here erkp1 < erk < max(erkm1,ermk2) else
 // order would have been lowered in block 2.
 // Thus order is to be raised
 k = kp1;
 erk = erkp1;
 };
 };
 
 }; // end if kp1<=ns
 
 }; // end if knew!=km1
 
 }; // end if !phase1
 
 
 // With new order determine appropriate step size for next step
 if ( phase1 || (p5eps>=erk*two[k+1]) )
 hnew = 2.0*h;
 else {
 if (p5eps<erk) {
 temp2 = k+1;
 r = pow(p5eps/erk, 1.0/temp2);
 hnew = absh*max(0.5, min(0.9,r));
 hnew = sign(max(hnew, fouru*fabs(x)), h);
 }
 else hnew = h;
 };
 
 h = hnew;
 
 //
 // End block 4
 //
 }
 
 
 //
 // Integration step
 //
 void APSDE :: Step( double& x, double y[], double& eps, bool& crash )
 {
 //
 // Constants
 //
 static const double two[14] = // Powers of two (two(n)=2**n)
 { 1.0, 2.0, 4.0, 8.0, 16.0, 32.0, 64.0, 128.0,
 256.0, 512.0, 1024.0, 2048.0, 4096.0, 8192.0 };
 
 static const double gstr[14] =
 {1.0, 0.5, 0.0833, 0.0417, 0.0264, 0.0188,
 0.0143, 0.0114, 0.00936, 0.00789, 0.00679,
 0.00592, 0.00524, 0.00468 };
 
 
 //
 // Variables
 //
 bool    success;
 int     i,ifail, im1, ip1, iq, j, km1, km2, knew, kp1, kp2;
 int     l, limit1, limit2, nsm2, nsp1, nsp2;
 double  absh, erk, erkm1, erkm2, erkp1, err, hnew;
 double  p5eps, r, reali, realns, rho, round, sum, tau, temp1;
 double  temp2, temp3, temp4, temp5, temp6, xold;
 
 
 //
 // Begin block 0
 //
 // Check if step size or error tolerance is too small for machine
 // precision.  If first step, initialize PHI array and estimate a
 // starting step size. If step size is too small, determine an
 // acceptable one.
 //
 if (fabs(h) < fouru*fabs(x)) {
 h = sign(fouru*fabs(x),h);
 crash = true;
 return;  // exit
 };
 
 p5eps  = 0.5*eps;
 crash  = false;
 g[1]   = 1.0;
 g[2]   = 0.5;
 sig[1] = 1.0;
 
 ifail = 0;
 
 
 // If error tolerance is too small, increase it to an
 // acceptable value.
 round = 0.0;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) round += (y[l]*y[l])/(wt[l]*wt[l]);
 round = twou*sqrt(round);
 if (p5eps<round) {
 eps = 2.0*round*(1.0+fouru);
 crash = true;
 return;
 };
 
 
 if (start) {
 // Initialize. Compute appropriate step size for first step.
 GetIntegFunction()->Run(x, y, yp);
 sum = 0.0;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][1] = yp[l];
 phi[l][2] = 0.0;
 sum += (yp[l]*yp[l])/(wt[l]*wt[l]);
 }
 sum = sqrt(sum);
 absh = fabs(h);
 if (eps<16.0*sum*h*h) absh=0.25*sqrt(eps/sum);
 h = sign(max(absh, fouru*fabs(x)), h);
 hold = 0.0;
 hnew = 0.0;
 k = 1;
 kold = 0;
 start = false;
 phase1 = true;
 nornd = true;
 if (p5eps<=100.0*round) {
 nornd = false;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][15]=0.0;
 };
 };
 
 //
 // End block 0
 //
 
 
 //
 // Repeat blocks 1, 2 (and 3) until step is successful
 //
 do {
 
 //
 // Begin block 1
 //
 
 // Compute coefficients of formulas for this step. Avoid computing
 // those quantities not changed when step size is not changed.
 //
 kp1 = k+1;
 kp2 = k+2;
 km1 = k-1;
 km2 = k-2;
 
 // NS is the number of steps taken with size H, including the
 // current one.  When K<NS, no coefficients change.
 if (h !=hold)  ns=0;
 if (ns<=kold)  ns=ns+1;
 nsp1 = ns+1;
 
 if (k>=ns) {
 
 // Compute those components of alpha[*],beta[*],psi[*],sig[*]
 // which are changed
 beta[ns] = 1.0;
 realns = ns;
 alpha[ns] = 1.0/realns;
 temp1 = h*realns;
 sig[nsp1] = 1.0;
 if (k>=nsp1) {
 for (i=nsp1;i<=k;i++) {
 im1 = i-1;
 temp2 = psi[im1];
 psi[im1] = temp1;
 beta[i] = beta[im1]*psi[im1]/temp2;
 temp1 = temp2 + h;
 alpha[i] = h/temp1;
 reali = i;
 sig[i+1] = reali*alpha[i]*sig[i];
 };
 };
 psi[k] = temp1;
 
 
 // Compute coefficients g[*]; initialize v[*] and set w[*].
 if (ns>1) {
 
 // If order was raised, update diagonal part of V[*]
 if (k>kold) {
 temp4 = k*kp1;
 v[k] = 1.0/temp4;
 nsm2 = ns-2;
 for (j=1;j<=nsm2;j++) {
 i = k-j;
 v[i] = v[i] - alpha[j+1]*v[i+1];
 };
 };
 
 // Update V[*] and set W[*]
 limit1 = kp1 - ns;
 temp5 = alpha[ns];
 for (iq=1;iq<=limit1;iq++) {
 v[iq] = v[iq] - temp5*v[iq+1];
 w[iq] = v[iq];
 };
 
 g[nsp1] = w[1];
 }
 else {
 for (iq=1;iq<=k;iq++) {
 temp3 = iq*(iq+1);
 v[iq] = 1.0/temp3;
 w[iq] = v[iq];
 };
 };
 
 
 // Compute the g[*] in the work vector w[*]
 nsp2 = ns + 2;
 if (kp1>=nsp2) {
 for (i=nsp2;i<=kp1;i++) {
 limit2 = kp2 - i;
 temp6 = alpha[i-1];
 for (iq=1;iq<=limit2;iq++) w[iq] = w[iq] - temp6*w[iq+1];
 g[i] = w[1];
 };
 };
 
 }; // if K>=NS
 
 //
 // End block 1
 //
 
 
 //
 // Begin block 2
 //
 // Predict a solution p[*], evaluate derivatives using predicted
 // solution, estimate local error at order k and errors at orders
 // k, k-1, k-2 as if constant step size were used.
 //
 
 // Change phi to phi star
 if (k>=nsp1) {
 for (i=nsp1;i<=k;i++) {
 temp1 = beta[i];
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][i] = temp1 * phi[l][i];
 }
 };
 
 
 // Predict solution and differences
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][kp2] = phi[l][kp1];
 phi[l][kp1] = 0.0;
 p[l] = 0.0;
 };
 for (j=1;j<=k;j++) {
 i = kp1 - j;
 ip1 = i+1;
 temp2 = g[i];
 for (l=1; l<=GetIntegFunction()->GetNeqn();l++) {
 p[l] = p[l] + temp2*phi[l][i];
 phi[l][i] = phi[l][i] + phi[l][ip1];
 };
 };
 if (nornd) {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) p[l] = y[l] + h*p[l];
 }
 else {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 tau = h*p[l] - phi[l][15];
 p[l] = y[l] + tau;
 phi[l][16] = (p[l] - y[l]) - tau;
 };
 };
 xold = x;
 x = x + h;
 absh = fabs(h);
 GetIntegFunction()->Run(x, p, yp);
 
 
 // Estimate errors at orders k, k-1, k-2
 erkm2 = 0.0;
 erkm1 = 0.0;
 erk = 0.0;
 
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 temp3 = 1.0/wt[l];
 temp4 = yp[l] - phi[l][1];
 if (km2> 0) erkm2 = erkm2 + ((phi[l][km1]+temp4)*temp3)
 *((phi[l][km1]+temp4)*temp3);
 if (km2>=0) erkm1 = erkm1 + ((phi[l][k]+temp4)*temp3)
 *((phi[l][k]+temp4)*temp3);
 erk = erk + (temp4*temp3)*(temp4*temp3);
 };
 
 if (km2> 0)  erkm2 = absh*sig[km1]*gstr[km2]*sqrt(erkm2);
 if (km2>=0)  erkm1 = absh*sig[k]*gstr[km1]*sqrt(erkm1);
 
 temp5 = absh*sqrt(erk);
 err = temp5*(g[k]-g[kp1]);
 erk = temp5*sig[kp1]*gstr[k];
 knew = k;
 
 // Test if order should be lowered
 if (km2 >0) if (max(erkm1,erkm2)<=erk) knew=km1;
 if (km2==0) if (erkm1<=0.5*erk) knew=km1;
 
 //
 // End block 2
 //
 
 //
 // If step is successful continue with block 4, otherwise repeat
 // blocks 1 and 2 after executing block 3
 //
 
 success = (err<=eps);
 
 if (!success) {
 
 //
 // Begin block 3
 //
 
 // The step is unsuccessful. Restore x, phi[*,*], psi[*]. If
 // 3rd consecutive failure, set order to 1. If step fails more
 // than 3 times, consider an optimal step size. Double error
 // tolerance and return if estimated step size is too small
 // for machine precision.
 //
 
 // Restore x, phi[*,*] and psi[*]
 phase1 = false;
 x = xold;
 for (i=1;i<=k;i++) {
 temp1 = 1.0/beta[i];
 ip1 = i+1;
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) phi[l][i]=temp1*(phi[l][i]-phi[l][ip1]);
 };
 
 if (k>=2)
 for (i=2;i<=k;i++) psi[i-1] = psi[i] - h;
 
 
 // On third failure, set order to one.
 // Thereafter, use optimal step size
 ifail++;
 temp2 = 0.5;
 if (ifail>3)
 if (p5eps < 0.25*erk) temp2 = sqrt(p5eps/erk);
 if (ifail>=3) knew = 1;
 h = temp2*h;
 k = knew;
 if (fabs(h)<fouru*fabs(x)) {
 crash = true;
 h = sign(fouru*fabs(x), h);
 eps *= 2.0;
 return;   // exit
 };
 
 //
 // End block 3, return to start of block 1
 //
 
 };  // end if(successful)
 
 }
 while (!success);
 
 
 //
 // Begin block 4
 //
 // The step is successful. Correct the predicted solution, evaluate
 // the derivatives using the corrected solution and update the
 // differences. Determine best order and step size for next step.
 //
 
 kold = k;
 hold = h;
 
 
 // Correct and evaluate
 temp1 = h*g[kp1];
 if (nornd)
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) y[l] = p[l] + temp1*(yp[l] - phi[l][1]);
 else
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 rho = temp1*(yp[l] - phi[l][1]) - phi[l][16];
 y[l] = p[l] + rho;
 phi[l][15] = (y[l] - p[l]) - rho;
 };
 
 GetIntegFunction()->Run(x,y,yp);
 
 
 // Update differences for next step
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++) {
 phi[l][kp1] = yp[l] - phi[l][1];
 phi[l][kp2] = phi[l][kp1] - phi[l][kp2];
 };
 for (i=1;i<=k;i++)
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++)
 phi[l][i] = phi[l][i] + phi[l][kp1];
 
 
 // Estimate error at order k+1 unless
 // - in first phase when always raise order,
 // - already decided to lower order,
 // - step size not constant so estimate unreliable
 erkp1 = 0.0;
 if ( (knew==km1) || (k==12) )  phase1=false;
 
 if (phase1) {
 k = kp1;
 erk = erkp1;
 }
 else {
 if (knew==km1) {
 // lower order
 k = km1;
 erk = erkm1;
 }
 else {
 
 if (kp1<=ns) {
 for (l=1;l<=GetIntegFunction()->GetNeqn();l++)
 erkp1 = erkp1 + (phi[l][kp2]/wt[l])*(phi[l][kp2]/wt[l]);
 erkp1 = absh*gstr[kp1]*sqrt(erkp1);
 
 // Using estimated error at order k+1, determine
 // appropriate order for next step
 if (k>1) {
 if ( erkm1<=min(erk,erkp1)) {
 // lower order
 k=km1; erk=erkm1;
 }
 else {
 if ( (erkp1<erk) && (k!=12) ) {
 // raise order
 k=kp1; erk=erkp1;
 };
 };
 }
 else {
 if (erkp1<0.5*erk) {
 // raise order
 // Here erkp1 < erk < max(erkm1,ermk2) else
 // order would have been lowered in block 2.
 // Thus order is to be raised
 k = kp1;
 erk = erkp1;
 };
 };
 
 }; // end if kp1<=ns
 
 }; // end if knew!=km1
 
 }; // end if !phase1
 
 
 // With new order determine appropriate step size for next step
 if ( phase1 || (p5eps>=erk*two[k+1]) )
 hnew = 2.0*h;
 else {
 if (p5eps<erk) {
 temp2 = k+1;
 r = pow(p5eps/erk, 1.0/temp2);
 hnew = absh*max(0.5, min(0.9,r));
 hnew = sign(max(hnew, fouru*fabs(x)), h);
 }
 else hnew = h;
 };
 
 h = hnew;
 
 //
 // End block 4
 //
 };
 
 
 //
 // DE integration
 //
 void APSDE :: Integ ( double y[], double& t, const double tout,
 double& relerr, double& abserr,
 DE_STATE& State, bool PermitTOUT /* = true */ )
 {
 
 //
 // Variables
 //
 bool    stiff, crash;
 int     nostep;
 int     kle4 = 0;
 double  releps, abseps, tend;
 double  absdel, del, eps;
 
 
 //
 // Start
 //
 
 // Return, if output time equals input time
 
 if (t==tout) return;    // No integration
 
 
 // Test for improper parameters
 eps   = max(relerr,abserr);
 
 if ( ( GetIntegFunction()->GetNeqn()   <   1    ) ||             // invalid number of equations
 ( relerr <   0.0  ) ||             // negative relative error bound
 ( abserr <   0.0  ) ||             // negative absolute error bound
 ( eps    <=  0.0  ) ||             // both error bounds are non-positive
 ( State  >  DE_INVALID_PARAMS ) || // invalid range of State
 ( (State != DE_INIT) && (t != told) ) ) {
 
 State = DE_INVALID_PARAMS;    // set error code
 return;                       // exit
 };
 
 
 // On each call set interval of integration and counter for
 // number of steps. Adjust input error tolerances to define
 // weight vector for subroutine STEP.
 
 del    = tout - t;
 absdel = fabs(del);
 
 tend   = t + 100.0*del;
 if (!PermitTOUT) tend = tout;
 
 nostep = 0;
 kle4   = 0;
 stiff  = false;
 releps = relerr/eps;
 abseps = abserr/eps;
 
 if  ( (State==DE_INIT) || (!OldPermit) || (delsgn*del<=0.0) ) {
 // On start and restart also set the work variables X and YY(*),
 // store the direction of integration and initialize the step size
 start  = true;
 x      = t;
 for (int l=1; l<=GetIntegFunction()->GetNeqn(); l++) yy[l] = y[l];
 delsgn = sign(1.0, del);
 h      = sign( max(fouru*fabs(x), fabs(tout-x)), tout-x );
 }
 
 
 while (true) {  // Start step loop
 
 // If already past output point, interpolate solution and return
 if (fabs(x-t) >= absdel) {
 
 Intrp (x, yy, tout, y, ypout);
 
 State     = DE_DONE;        // set return code
 t         = tout;           // set independent variable
 told      = t;              // store independent variable
 OldPermit = PermitTOUT;
 return;                     // normal exit
 };
 
 
 // If cannot go past output point and sufficiently close,
 // extrapolate and return
 if ( !PermitTOUT && ( fabs(tout-x) < fouru*fabs(x) ) ) {
 
 h = tout - x;
 GetIntegFunction()->Run(x,yy,yp);              // compute derivative yp(x)
 
 for (int l=1; l<=GetIntegFunction()->GetNeqn(); l++)
 y[l]=yy[l]+h*yp[l];       // extrapolate vector from x to tout
 
 State     = DE_DONE;        // set return code
 t         = tout;           // set independent variable
 told      = t;              // store independent variable
 OldPermit = PermitTOUT;
 return;                     // normal exit
 };
 
 
 // Test for too much work
 if (nostep >= maxnum) {
 
 State = DE_TOO_MANY_STEPS;    // too many steps
 if (stiff) State = DE_STIFF;  // stiffness suspected
 for (int l=1; l<=GetIntegFunction()->GetNeqn(); l++)
 y[l]=yy[l];                 // copy whole vector of last step
 t         = x;
 told      = t;
 OldPermit = true;
 return;                       // weak failure exit
 };
 
 
 // Limit step size, set weight vector and take a step
 h  = sign(min(fabs(h), fabs(tend-x)), h);
 for (int l=1; l<=GetIntegFunction()->GetNeqn(); l++)
 wt[l] = releps*fabs(yy[l]) + abseps;
 
 Step (x, yy, eps, crash);
 
 
 // Test for too small tolerances
 if (crash) {
 
 State     = DE_ACCURACY_NOT_ACHIEVED;
 relerr    = eps*releps;          // modify relative and absolute
 abserr    = eps*abseps;          // accuracy requirements
 for (int l=1; l<=GetIntegFunction()->GetNeqn(); l++)
 y[l] = yy[l];                  // copy last step
 t         = x;
 told      = t;
 OldPermit = true;
 return;                          // weak failure exit
 }
 
 nostep++;  // Count total number of steps
 
 // Count number of consecutive steps taken with the order of
 // the method being less or equal to four and test for stiffness
 kle4++;
 if (kold>  4) kle4=0;
 if (kle4>=50) stiff=true;
 
 } // End step loop
 };
 
 }}
 
 //---------------------------- End of file ---------------------------

 ******/