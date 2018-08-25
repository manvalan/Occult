//
//  AsteroidIO.swift
//  Occult
//
//  Created by Michele Bigi on 12/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

/*********************************************************************************
 AsteroidIO
 
 Base class for asteroid IO.
 Contain the basic function for reading MPCORB and ASTORB database.
 IO function for read/write internal DB (Dictionary)
 
 V 0.1 - 2018/08/12 - Michele Bigi - mikbigi@gmail.com
 *********************************************************************************/

class AsteroidIO {
    init() {
    }
    
    func GetInteger( line : UnsafeBufferPointer<CChar>, Offset :Int, Lenght : Int)->Int32 {
        var iRes : Int32 = 0
        
        if( ( line.count >= Offset ) && ( line.count < (Offset+Lenght) )) {
            var tmp :[CChar] = [CChar]( repeating: 0, count: Lenght+1)
            for i in Offset ... Offset+Lenght {
                tmp[i-Offset] = line[i]
            }
            return atoi( &tmp )
            
        } else {
            iRes = -1
        }
        return iRes
    }
    
    func GetLong( line : UnsafeBufferPointer<CChar>, Offset :Int, Lenght : Int)->Int64 {
        var iRes : Int64 = 0
        
        if( ( line.count >= Offset ) && ( line.count < (Offset+Lenght) )) {
            var tmp :[CChar] = [CChar]( repeating: 0, count: Lenght+1)
            for i in Offset ... Offset+Lenght {
                tmp[i-Offset] = line[i]
            }
            return atoll( &tmp )
            
        } else {
            iRes = -1
        }
        return iRes
    }
    
    func GetShort( line : UnsafeBufferPointer<CChar>, Offset :Int, Lenght : Int)->Int {
        var iRes : Int = 0
        
        if( ( line.count >= Offset ) && ( line.count < (Offset+Lenght) )) {
            var tmp :[CChar] = [CChar]( repeating: 0, count: Lenght+1)
            for i in Offset ... Offset+Lenght {
                tmp[i-Offset] = line[i]
            }
            return atol( &tmp )
            
        } else {
            iRes = -1
        }
        return iRes
    }
    
    func GetString( line : UnsafeBufferPointer<CChar>, Offset :Int, Lenght : Int)->String {
        var aStr = ""
        
        if( ( line.count >= Offset ) && ( line.count < (Offset+Lenght) )) {
            var tmp :[CChar] = [CChar]( repeating: 0, count: Lenght+1)
            for i in Offset ... Offset+Lenght {
                tmp[i-Offset] = line[i]
            }
            
            aStr = String( cString: tmp )
        }
        return aStr
    }
    
    func GetDouble( line : UnsafeBufferPointer<CChar>, Offset :Int, Lenght : Int)->Double {
        var dRet : Double = 0.0
        
        if( ( line.count >= Offset ) && ( line.count < (Offset+Lenght) )) {
            var tmp :[CChar] = [CChar]( repeating: 0, count: Lenght+1)
            for i in Offset ... Offset+Lenght {
                tmp[i-Offset] = line[i]
            }
            dRet = atof( tmp )
        }
        else {
            dRet = -1
        }
        return dRet
    }
}

