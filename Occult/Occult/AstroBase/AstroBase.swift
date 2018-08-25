//
//  MOAstroBase.swift
//  MacOccult
//
//  Created by Michele Bigi on 01/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

enum c_light:Double {
    case ms  = 299792458.0
    case kms = 299792.458
    case kmh = 1079252848.8
    case aud = 173.144632684657
} 

class AstroBase {
    let pi2  = Double.pi * 2.0
    let Arcs = Double.pi / ( 3600 * 180.0 ) //3600.0 * 180.0 / Double.pi
    let Rad  = Double.pi / 180.0
    let Deg  = 180.0 / Double.pi
    
    func R_x( phi: Double)->Matrix {
        var R = Matrix(3,3)
        
        R[0,0] = 1
        R[0,1] = 0
        R[0,2] = 0
        R[1,0] = 0
        R[1,1] = cos( phi )
        R[1,2] = sin( phi )
        R[2,0] = 0
        R[2,1] = -sin( phi )
        R[2,2] = cos( phi )
        
        return R
    }
    
    func R_y( phi: Double)->Matrix {
        var R = Matrix(3,3)
        
        R[0,0] = cos( phi )
        R[0,1] = 0
        R[0,2] = -sin( phi )
        R[1,0] = 0
        R[1,1] = 1
        R[1,2] = 0
        R[2,0] = sin( phi )
        R[2,1] = 0
        R[2,2] = cos( phi )
        
        return R
    }
    
    func R_z( phi: Double)->Matrix {
        var R = Matrix(3,3)
        
        R[0,0] = cos( phi )
        R[0,1] = sin( phi )
        R[0,2] = 0
        R[1,0] = -sin( phi )
        R[1,1] = cos( phi )
        R[1,2] = 0
        R[2,0] = 0
        R[2,1] = 0
        R[2,2] = 1
        
        return R
    }
    
    func GaussVec( Omega: Double, i : Double, omega: Double)->Matrix {
        var PQM = Matrix( 3,3 )
        
        PQM = R_z( phi: Omega ) * R_x(phi: i) * R_z(phi: omega )
        
        return PQM
    }
    
    func frac( x: Double )->Double {
        return x - floor(x)
    }
    
    func modulo( x: Double, y: Double )->Double {
        return fmod( x, y )
        //return y * frac( x: (x / y ) )
    }
    
    func T( jd: Double )-> Double {
        return ( jd - 2451545.0 ) / 36525.0
    }
    
    func Norm( a :Vector )->Double {
        return sqrt( a[0] * a[0] + a[1] * a[1] + a[2] * a[2])
    }
    
    func Equ2EclMatrix( T:Double ) ->Matrix {
        let eps = Epsilon(T: T )
       
        return R_x(phi: eps )
    }
    
    func Epsilon( T :Double )->Double {
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) * Rad
        
        return eps
    }
    
    func Ecl2EquMatrix( T:Double ) ->Matrix {
        let eps = Epsilon(T: T)
        
        return transpose( R_x( phi: eps ) )
    }
    
    func PreclMatrix_Ecl( T1 :Double, T2 :Double )->Matrix {
        let dT = T2 - T1
        
        var Pi = 174.876383889 * Rad + (((3289.4789+0.60622 * T1)*T1) + ( ( -869.8089 - 0.50491 * T1 ) + 0.03536 * dT ) * dT ) * Arcs
        var pi  = ( (47.0029 - ( 0.06603 - 0.000598 * T1 ) * T1 ) + (( -0.03302 + 0.000598 * T1) + 0.000060 * dT ) * dT ) * dT * Arcs
        var p_a = ( ( 5029.0966 + ( 2.22226 - 0.000042 * T1 ) * T1 ) + (( 1.11113 - 0.000042 * T1 ) - 0.000006 * dT ) * dT ) * dT * Arcs
        
        return R_z( phi: -( Pi + p_a ) ) * R_x( phi: pi ) * R_z( phi: Pi )
    }
   
    func EquatorialToEcliptical( a: Vector , jd: Double ) -> Vector {
        var U = Equ2EclMatrix(T: T(jd: jd ))
        var Ecli = U * a
        
        return Ecli
    }
    
    func EclipticalToEquatorial( a: Vector , jd: Double ) -> Vector {
        var U = Ecl2EquMatrix(T: T(jd: jd ))
        let Equ =  U * a
        
        return Equ
    }
    
    func BarycentricDyanamicalTime( jd :Double )->Double {
        var tbd = 0.0
        var g   = 0.0
        
        g = Rad * ( 357.53 + 0.9856003 * ( jd - 2451545.0 ))
        let tat = jd + (32.184 / 86400.0)
        tbd = tat + (0.001658 * sin( g ) + 0.000014 * sin( 2 * g ))/86400.0
        return tbd
    }
   
    func polar( m_r :Double, m_theta:Double, m_phi:Double ) -> Vector {
        var res :Vector = [ 0.0 , 0.0 , 0.0 ]
        
        let cosEl = cos( m_theta )
        res[0] = m_r * cos(m_phi ) * cosEl
        res[1] = m_r * sin(m_phi ) * cosEl
        res[2] = m_r * cos(m_theta ) * sin( m_theta )
        
        return res
    }
    
    func PrecMatrix( t1: Double , t2:Double)->Matrix {
        let dT = t2 - t1
        let Pi = Rad * 174.876383889 + ( (( 3289.4789+0.60622 * t1 ) * t1 ) + ((-869.8089 - 0.50491 * t1) + 0.03536 * dT ) * dT ) * Arcs
        let pi = ((47.0029 - (0.06603 - 0.000598 * t1 ) * t1 ) + (( -0.03302 + 0.000598 * t1 ) + 0.000060 * dT ) * dT ) * dT * Arcs
        let p_a = ( ( 5029.0966 + ( 2.22226 - 0.000042 * t1 ) * t1 ) + ((1.11113-0.000042 * t1 ) - 0.000006 * dT ) * dT ) * dT * Arcs
        
        return R_z(phi: -(Pi + p_a) ) * R_x(phi: pi) * R_z(phi: Pi)
    }
    
    func NutMatrix( T :Double )->Matrix {
        let pi2 = 2.0 * Double.pi
        let ls  = pi2 * frac(x: 0.993133 +   99.997306 * T )
        let D   = pi2 * frac(x: 0.827362 + 1236.853087 * T )
        let F   = pi2 * frac(x: 0.259089 + 1342.227826 * T )
        let N   = pi2 * frac(x: 0.347346 +    5.372447 * T )
        
        let dpsi = ( -17.200 * sin(N) - 1.319 * sin( 2 * (F - D + N)) - 0.227 * sin(2 * (F + N)) + 0.206 * sin(2 * N ) + 0.143 * sin(ls)) * Arcs
        
        let deps = ( 9.203 * cos(N) + 0.574 * cos( 2 * (F - D + N)) + 0.098 * cos(2 * (F + N)) - 0.090 * cos(2 * N ) ) * Arcs
        
        let eps = 0.4098928 - 2.2696E-4 * T
        
        let NM = R_x(phi: -eps - deps) * R_z(phi: -dpsi) * R_x(phi: eps )
        
        return NM
    }
    
    func AberrationFactor( jplDE :JPLDE, t :Double, p_corp :Vector, v_corp :Vector ) -> Vector {
        let v_Earth = jplDE.EarthVel(t: t)
        let dist = Norm(a: p_corp )
        let fac  = dist / c_light.aud.rawValue
        return fac .* ( v_corp - v_Earth )
    }
    
    func CalcPolarAngles( a :Vector )->Vector {
        var res :Vector = [ 0.0 , 0.0 , 0.0 ]
        let m_r :Double = 0.0
        let rho_sqr : Double = a[0] * a[0] + a[1] * a[1]
        res[2] = sqrt( rho_sqr + a[2] * a[2] ) // R
        
        if( ( a[0] == 0.0 ) && ( a[1] == 0 ) ) {
            res[0] = 0.0 // phi
        } else {
            res[0] = atan2( a[ 1 ], a[ 0 ] )
        }
        
        if( res[0] < 0 ) {
            res[0] += 2.0 * Double.pi
        }
        
        var rho :Double = sqrt( rho_sqr )
        
        if(( a[1] == 0.0 ) && ( rho == 0 )) {
            res[1] = 0.0 // theta
        } else {
            res[1] = atan2( a[ 1 ], rho )
        }
        return res
    }
    
    func JulianDay( data :MOData ) ->Double {
        return 2400000.5 + MJulianDay(data: data)
    }
    
    func MJulianDay( data: MOData ) ->Double {
        var Month = data.month
        var Year  = data.year
        var b = 0
        var jd:Double
        let MjdMidnight : Double
        let FracOfDay   : Double
        
        jd = 0.0
        
        if ( Month <= 2 ) {
            Month += 12
            Year -= 1
        }
        if( (Year * 10000 + Month * 100 + data.day ) <= 15821004 ){
            // Julian Calendar
            b = -2 + (( Year+4716)/4) - 1179
        } else {
            b = (Year/400) - ( Year/100) + (Year/4)
        }
        
        var bt = floor(30.6001 * ( 1.0 + Double( Month) ) )
        
        MjdMidnight = 365.0 * Double( Year ) - 679004.0 + Double( b ) + bt + Double( data.day )
        FracOfDay = Double( data.hour ) + Double( data.min )  / 60.0 + Double( data.sec ) / 3600.0
        jd = MjdMidnight + FracOfDay / 24.0
        
        return jd
        
    }
    
    func Date( JD : Double ) ->MOData {
    
        var data = MOData()
        var num1 : Double
        var num2 : Double
        var num3 : Double
        var num4 : Double
        var num5 : Double
        var num6 : Double
        var num7 : Double
        
        num1 = floor(JD) + 0.5
        if ( num1 > JD ) {
            num1 -= 1
        }
        num2 = JD - num1
        
        if (num1 >= 2299160.5) {
            num5 = floor(num1 - 1720981.0)
            num6 = floor((num5 - 122.1) / 365.25)
            num3 = floor((num5 - 15.0 + floor(num6 / 100.0) - floor(num6 / 400.0) - 122.1) / 365.25);
            num4 = num5 - 15.0 + floor(num3 / 100.0) - floor(num3 / 400.0);
            
        } else {
            num4 = floor(num1 - 1720994.0)
            num3 = floor((num4 - 122.1) / 365.25)
        }
        
        num7 = floor((num4 - floor(365.25 * num3)) / 30.6001)
        
        data.day = Int(num4 - floor(365.25 * num3) - floor(30.6001 * num7) + num2)
        data.month = Int( num7 )
        data.year = Int( num3 )
        
        if( data.month > 13) {
            data.month -= 13
            data.year += 1
        } else {
            data.month -= 1
        }
    
        return data
    }
    
    
}
