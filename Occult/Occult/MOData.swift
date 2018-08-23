//
//  MOData.swift
//  MacOccult
//
//  Created by Michele Bigi on 22/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MOData :AstroBase {
    var year  : Int
    var month : Int
    var day   : Int
    var hour  : Int
    var min   : Int
    var sec   : Int
    
    override init() {
        year = 0
        month = 0
        day = 0
        hour = 0
        min = 0
        sec = 0
    }
    
    init( aa: Int, mm: Int, dd: Int) {
        year = aa
        month = mm
        day = dd
        hour = 0
        min = 0
        sec = 0
    }
    
    init( hh: Int, mn: Int ) {
        year = 0
        month = 0
        day = 0
        hour = hh
        min = mn
        sec = 0
    }
    
    init( jd: Double ) {
        year = 0
        month = 0
        day = 0
        hour = 0
        min = 0
        sec = 0
        
        //Date( JD: jd )
        //var data = MOData()
        var num1 : Double
        var num2 : Double
        var num3 : Double
        var num4 : Double
        var num5 : Double
        var num6 : Double
        var num7 : Double
        var num9 : Double
        
        num1 = floor(jd) + 0.5
        if ( num1 > jd ) {
            num1 -= 1
        }
        num2 = jd - num1
        
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
        
        day = Int(num4 - floor(365.25 * num3) - floor(30.6001 * num7) + num2)
        month = Int( num7 )
        year = Int( num3 )
        
        if( month > 13) {
            month -= 13
            year += 1
        } else {
            month -= 1
        }
        num9 = 24 * 3600 * num2
        
        hour = Int( num9 / 3600 )
        min = Int( ( num9 - Double(hour) * 3600) / 60 )
        sec = Int( ( num9 - Double(hour) * 3600 - Double( min ) * 60 ) )
        
    }
    
    func Date( JD : Double ) {
        
        //var data = MOData()
        var num1 : Double
        var num2 : Double
        var num3 : Double
        var num4 : Double
        var num5 : Double
        var num6 : Double
        var num7 : Double
        var num9 : Double
        
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
        
        day = Int(num4 - floor(365.25 * num3) - floor(30.6001 * num7) + num2)
        month = Int( num7 )
        year = Int( num3 )
        
        if( month > 13) {
            month -= 13
            year += 1
        } else {
            month -= 1
        }
        num9 = 24 * 3600 * num2
        
        hour = Int( num9 / 3600 )
        min = Int( ( num9 - Double(hour) * 3600) / 60 )
        sec = Int( ( num9 - Double(hour) * 3600 - Double( min ) * 60 ) )
        
        return
    }
    
    func JulianDay() -> Double {
        return JulianDay(data: self )
    }
    
    func toString() -> String {
        var dateString = ""
        
        dateString = NSString( format:"%4.4i-%2.2i-%2.2i %2.2i:%2.2i:%2.2i" , year, month, day, hour, min, sec ) as String
        
        return dateString
    }
}
