//
//  MOKepler.swift
//  MacOccult
//
//  Created by Michele Bigi on 30/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class Kepler : AstroBase{
    
    func EccAnom( M: Double , e: Double) ->Double {
        let maxit = 15
        let eps = 100.0 * Double.ulpOfOne
        var E: Double
        var f: Double
        var i = 0
        var MA = fmod( M , Double.pi * 2 )//modulo( x: M, y:(2.0 * Double.pi ))
    
        if( e<0.8) {
            E = MA
        } else {
            E = Double.pi
        }
        
        repeat {
            f = E - e * sin( E ) - M
            E = E - f / ( 1.0 - e * cos(E) )
            i += 1
            
            if( i == maxit ) {
                print( "ERROR: Convergence problems in EccAnom" )
                break
            }
        }
        while ( fabs(f) > eps )
        
        return fmod( E , Double.pi * 2 )
    }
    
    func Ellip( GM: Double, M: Double, a:Double, e:Double , r :inout Vector, v :inout Vector) {
        print( "Ellip" )
        print( "   GM: \(GM)" )
        print( "   M : \(M)" )
        print( "   a : \(a)" )
        print( "   e : \(e)" )
        
        
        let k = sqrt(GM/a)
        let E = EccAnom(M: M, e: e)
        
        let cosE = cos( E )
        let sinE = sin( E )
        let fac = sqrt( ( 1.0-e ) * (1.0+e) )
        let rho = 1.0 - e * cosE
        //r = APSVec3d (a*(cosE-e),  a*fac*sinE,     0.0);
        r[0] = a * ( cosE - e )
        r[1] = a * fac * sinE
        r[2] = 0.0
        
        v[0] = -k * sinE / rho
        v[1] = k * fac * cosE / rho
        v[2] = 0.0
    }
/*********
 
 ********/
    
    func Position( elem: AsteroidElement , t :Double, GM:Double, r: inout Vector, v: inout Vector ) {
        let delta = fabs(1.0-elem.EC)
        let invax = delta / elem.QR
        let tau   = sqrt( GM )*( t - elem.JDTB)
        var M     = elem.MA + tau * sqrt( invax * invax * invax)
        
        //let PQR = GaussVec(Omega: elem.OM, i: elem.IN, omega: elem.W )
        //RetCode = Ellip (GM, M, 1.0/invax, e, r_orb, v_orb);
        Ellip(GM: GM, M: M, a: 1.0/invax, e: elem.EC, r: &r, v: &v)
        //r = PQR * r
        //v = PQR * v
        
    }
    
    func PositionNew( elem: AsteroidElement , t :Double, GM:Double, r: inout Vector, v: inout Vector ) {
        print("Elem: ")
        print("     JDTB: \(elem.JDTB)")
        print("     E:    \(elem.EC)")
        print("     A:    \(elem.A)")
        print("     MA:   \(elem.MA)")
        print("     OM:   \(elem.OM)")
        print("     IN:   \(elem.IN)")
        print("     W:    \(elem.W)")
        
        let e = elem.EC
        let delta_t =  ( t - elem.JDTB )
        var M = elem.MA + delta_t * sqrt( GM / ( elem.A * elem.A * elem.A) )
        M = fmod(M,2.0 * Double.pi)
        let E = EccAnom(M: M, e: e)
        let p1 :Double = sqrt( 1 + e ) * sin( E / 2 )
        let p2 :Double = sqrt( 1 - e ) * cos( E / 2 )
        let nu = atan2( p1 , p2 )
        let dist = elem.A * (1 - e * cos( E ) )
        var o  :Vector = Vector( [ cos( nu ) , sin(nu) , 0 ] )
        o = o .* dist
        var op :Vector = Vector( [ -sin( E ), sqrt( 1 - e*e) * cos(E) , 0 ] )
        op = sqrt( GM * elem.A ) / dist .* op
        let PQR = GaussVec(Omega: elem.OM, i: elem.IN, omega: elem.W )
        
        r = PQR * o
        v = PQR * op
    }
}
