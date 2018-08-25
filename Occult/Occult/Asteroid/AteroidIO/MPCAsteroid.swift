//
//  MPCAsteroid.swift
//  Occult
//
//  Created by Michele Bigi on 12/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MPCAsteroidName {
    
    //var number : Int32
    var name: String
    
    init(){
        //number = 0;
        name = ""
    }
    
    func MPCgetName( key :String )->String {
        var aname :String = ""
        var cName :[CChar] = key.cString(using: String.Encoding.ascii )!
        
        if( cName.count > 6 ) {
            aname = MPCgetProvName(key: key)
        } else {
            aname = MPCgetDefName(key: key )
        }
        return aname
    }
    
    func MPCgetDefName( key :String )->String {
        var aname :String = ""
        var cName :[CChar] = key.cString(using: String.Encoding.ascii )!
        var num :Int32 = 0
        var prx :Int32 = 0
        if((cName[0] > 47) && (cName[0] < 58) ){
            num = atoi( cName )
        } else if( (cName[0] > 64) && (cName[0] < 91)) {
            // digit A-Z: A = 10 - 35
            prx = Int32((Int( cName[0] ) - 65 + 10 ) * 10000)
            cName[0] = 32
            num = atoi( cName ) + prx
            
        } else if( (cName[0] > 96) && (cName[0] < 123)) {
            // digit a-z: a = 36 - 61
            prx = Int32((Int( cName[0] ) - 97 + 36 ) * 10000)
            cName[0] = 32
            num = atoi( cName ) + prx
        }
        aname = String( num )
        
        return aname
    }
    
    func MPCgetProvName( key :String )->String {
        var aname :String = ""
        let cName :[CChar] = key.cString(using: String.Encoding.ascii )!
        var sec :Int = 0
        
        switch cName[0] {
        case 73:
            // 18XX
            sec = 1800
            break
            
        case 74:
            //19XX
            sec = 1900
            break
            
        case 75:
            //20XX
            sec = 2000
            break
            
        default:
            sec = 0
            break
        }
        let dec :Int = Int(cName[1]) - 48
        let yea :Int = Int(cName[2]) - 48
        
        let yer = sec + dec * 10 + yea
        var des :[CChar] = [CChar](repeating: 0, count: 3)
        des[0] = cName[3]
        des[1] = cName[6]
        
        var dcn :Int = 0
        
        if( (cName[4] > 47) && (cName[4] < 58)) {
            // digit 0-9: 0-99
            dcn = (Int( cName[4] ) - 48 ) * 10
        } else if( (cName[4] > 64) && (cName[4] < 91)) {
            // digit A-Z: A = 100 -> 350
            dcn = (Int( cName[4] ) - 65 + 10 ) * 10
        } else if( (cName[4] > 96) && (cName[4] < 123)) {
            // digit a-z: a = 360 ->
            dcn = (Int( cName[4] ) - 97 + 36 ) * 10
        }
        dcn += Int( cName[5]-48 )
       
        if( dcn != 0 ) {
            aname = String( yer ) + " " + String( cString: &des ) + String( dcn )
        } else {
            aname = String( yer ) + " " + String( cString: &des )
        }
        return aname
    }
    
}

class MPCAsteroidEpoc {
    init() {
    }
    
    /****
     The first two digits of the year are packed into a single character in column 1 (I = 18, J = 19, K = 20). Columns 2-3 contain the last two digits of the year. Column 4 contains the month and column 5 contains the day, coded as detailed below:
     
     Month     Day      Character         Day      Character
                      in Col 4 or 5               in Col 4 or 5
     Jan.       1           1             17           H
     Feb.       2           2             18           I
     Mar.       3           3             19           J
     Apr.       4           4             20           K
     May        5           5             21           L
     June       6           6             22           M
     July       7           7             23           N
     Aug.       8           8             24           O
     Sept.      9           9             25           P
     Oct.      10           A             26           Q
     Nov.      11           B             27           R
     Dec.      12           C             28           S
               13           D             29           T
               14           E             30           U
               15           F             31           V
               16           G

 ****/
}
