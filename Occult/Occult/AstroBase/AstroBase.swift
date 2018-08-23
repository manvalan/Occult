//
//  MOAstroBase.swift
//  MacOccult
//
//  Created by Michele Bigi on 01/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class AstroBase {
    let pi2  = Double.pi * 2.0
    let Arcs = 3600.0 * 180.0 / Double.pi
    let Rad  = Double.pi / 180.0
    let Deg  = 180.0 / Double.pi
    
    func R_x( phi: Double)->Matrix {
        var RX = Matrix(3,3)
        
        RX[0,0] = 1
        RX[0,1] = 0
        RX[0,2] = 0
        RX[1,0] = 0
        RX[1,1] = cos( phi )
        RX[1,2] = sin( phi )
        RX[2,0] = 0
        RX[2,1] = -sin( phi )
        RX[2,2] = cos( phi )
        
        return RX
    }
    
    func R_y( phi: Double)->Matrix {
        var RX = Matrix(3,3)
        
        RX[0,0] = cos( phi )
        RX[0,1] = 0
        RX[0,2] = -sin( phi )
        RX[1,0] = 0
        RX[1,1] = 1
        RX[1,2] = 0
        RX[2,0] = sin( phi )
        RX[2,1] = 0
        RX[2,2] = cos( phi )
        
        return RX
    }
    
    func R_z( phi: Double)->Matrix {
        var RX = Matrix(3,3)
        
        RX[0,0] = cos( phi )
        RX[0,1] = sin( phi )
        RX[0,2] = 0
        RX[1,0] = -sin( phi )
        RX[1,1] = cos( phi )
        RX[1,2] = 0
        RX[2,0] = 0
        RX[2,1] = 0
        RX[2,2] = 1
        
        return RX
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
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) / Rad
    
        return R_x( phi: eps )
    }
    
    func Epsilon( T :Double )->Double {
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) / Rad
        
        return eps
    }
    
    func Ecl2EquMatrix( T:Double ) ->Matrix {
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) / Rad
        
        return transpose( R_x( phi: eps ) )
    }
    
    func PreclMatrix_Ecl( T1 :Double, T2 :Double )->Matrix {
        let dT = T2 - T1
        
        var Pi = 174.876383889 * Rad + (((3289.4789+0.60622 * T1)*T1) + ( ( -869.8089 - 0.50491 * T1 ) + 0.03536 * dT ) * dT ) / Arcs
        var pi  = ( (47.0029 - ( 0.06603 - 0.000598 * T1 ) * T1 ) + (( -0.03302 + 0.000598 * T1) + 0.000060 * dT ) * dT ) * dT / Arcs
        var p_a = ( ( 5029.0966 + ( 2.22226 - 0.000042 * T1 ) * T1 ) + (( 1.11113 - 0.000042 * T1 ) - 0.000006 * dT ) * dT ) * dT / Arcs
        
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
    
    func RectangularToEquatorial( a: Vector , t:Double) -> Vector {
       /*
         Converting from heliocentric ecliptic coordinates to geocentric celestial coordinates. Given the heliocentric positions of Earth [x₀,y₀,z₀] and of another planet in ecliptic coordinates [x,y,z] for the same moment of time, t, expressed as a Julian Date, we will find the geocentric position of the planet in celestial coordinates; i.e., we want the planet's right ascension and declination. dx = x − x₀ dy = y − y₀ dz = z − z₀
         
         We find the obliquity of Earth, ε, at time t. T = t − 2451545.0 ε = 23.4392911° − 3.562266e-7 T − 1.22848e-16 T² + 1.03353e-20 T³ This equation gives the obliquity in degrees.
         dx' = dx
         dy' = dy cos ε − dz sin ε
         dz' = dy sin ε + dz cos ε
         The distance between Earth and the planet,
         dr, at time t is found from
         dr = √{ (dx)² + (dy)² + (dz)² }
         The planet's geocentric right ascension in decimal hours, α, at time t is found from
         
                        α = (12/π) Arctan( dy' , dx' )
         The planet's geocentric declination in decimal degrees, δ, at time t is found from
                        δ = (180/π) Arcsin( dz' / dr )
         
         Reference https://www.physicsforums.com/threads/position-and-velocity-in-heliocentric-ecliptic-coordinates.872682/
 
            Vector Results = alfa, delta, 1
         */
        let Ti = T(jd: t )
        let epsilon = Epsilon(T: Ti )
        
        let dx1 = a[0]
        let dy1 = a[1] * cos( epsilon ) - a[2] * sin( epsilon )
        let dz1 = a[1] * sin( epsilon ) + a[2] * cos( epsilon )
        let dr = sqrt( a[0] * a[0] + a[1] * a[1] + a[2] * a[2] )
        
        let alfa  = (  12.0 / Double.pi ) * atan2( dy1 , dx1 )
        let delta = ( 180.0 / Double.pi ) * asin( dz1 / dr )
        
        var eqpos :Vector = [ 0.0 , 0.0 ]
        eqpos[0] = alfa
        eqpos[1] = delta
        
        return eqpos
    }
    
    func polar( m_r :Double, m_theta:Double, m_phi:Double ) -> Vector {
        var res :Vector = [ 0.0 , 0.0 , 0.0 ]
        
        let cosEl = cos( m_theta )
        res[0] = m_r * cos(m_phi ) * cosEl
        res[1] = m_r * sin(m_phi ) * cosEl
        res[2] = m_r * cos(m_theta ) * sin( m_theta )
        
        return res
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
