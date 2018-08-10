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
        return y * frac( x: (x / y ) )
    }
    
    func T( jd: Double )-> Double {
        return ( jd - 2451545.0 ) / 36525.0
    }
    
    func Equ2EclMatrix( T:Double ) ->Matrix {
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) / Rad
    
        return R_x( phi: eps )
    }
    
    func Ecl2EquMatrix( T:Double ) ->Matrix {
        let eps = ( 23.43929111 - (46.8150 + ( 0.00059 - 0.001813 * T ) * T ) * T / 3600.0 ) / Rad
        
        return transpose( R_x( phi: eps ) )
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
    
    func JulianDay( data: MOData ) ->Double {
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
