//
//  MOKepler.swift
//  MacOccult
//
//  Created by Michele Bigi on 30/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MOKepler : AstroBase{
   
    
    func EccAnom( M: Double , e: Double) ->Double {
        let maxit = 15
        let eps = 100.0 * Double.ulpOfOne
        var E: Double
        var f: Double
        var i = 0
        var MeanAnomaly = modulo( x: M, y:(2.0 * Double.pi ))
        
        if( e<0.8) {
            E = MeanAnomaly
        } else {
            E = Double.pi
        }
        
        repeat {
            f = E - e * sin( E )
            E = E - f / ( 1.0 - e * cos(E) )
            i += 1
            
            if( i == maxit ) {
                print( "ERROR: Convergence problems in EccAnom" )
                break
            }
        }
        while ( fabs(f) < eps )
    
        return E
    }
    
    func Ellip( GM: Double, M: Double, a:Double, e:Double , p :inout Vector, v :inout Vector) {
        let k = sqrt(GM/a)
        let E = EccAnom(M: M, e: e)
        let cosE = cos( E )
        let sinE = sin( E )
        let fac = sqrt( ( 1.0-e ) * (1.0+e) )
        let rho = 1.0 - e * cosE
        
        p[0] = a * ( cosE - e )
        p[1] = a * fac * sinE
        p[2] = 0.0
        
        v[0] = -k * sinE / rho
        v[1] = k * fac * cosE / rho
        v[2] = 0.0
    }
    
    func Kepler( elem: MOAsteroidElement , t :Double, GM:Double, r: inout Vector, v: inout Vector ) {
        let delta = fabs(1.0-elem.EC)
        let invax = delta / elem.QR
        let tau = sqrt( GM )*( t - elem.Tp)
        let M = tau * sqrt( invax * invax * invax)
        let PQR = GaussVec(Omega: elem.OM, i: elem.IN, omega: elem.W )
        
        Ellip(GM: GM, M: M, a: 1.0/invax, e: elem.EC, p: &r, v: &v)
        
        var r_orb =  PQR .* r
        var v_orb = PQR .* v
        
        r[0] = r_orb[0,0]
        r[1] = r_orb[1,0]
        r[2] = r_orb[2,0]
        v[0] = v_orb[0,0]
        v[1] = v_orb[1,0]
        v[2] = v_orb[2,0]
        
    }
}
