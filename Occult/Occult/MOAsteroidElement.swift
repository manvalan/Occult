//
//  MOAsteroidElement.swift
//  MacOccult
//
//  Created by Michele Bigi on 22/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MOAsteroidElement {
    var JDTB :Double = 0.0
    var EC :Double = 0.0
    var QR :Double = 0.0
    var IN :Double = 0.0
    var OM :Double = 0.0
    var W :Double = 0.0
    var Tp :Double = 0.0
    var N :Double = 0.0
    var MA :Double = 0.0
    var TA :Double = 0.0
    var A :Double = 0.0
    var AD :Double = 0.0
    var PR :Double = 0.0
    
    init( ){
        
    }
    
    init( aJDTB: Double, aEC: Double, aQR: Double, aIN: Double, aOM: Double, aW: Double, aTp: Double, aN: Double, aMa: Double, aTA: Double, aA: Double, aAD: Double, aPR: Double ) {
        
        JDTB = aJDTB
        EC = aEC
        QR = aQR
        IN = aIN
        OM = aOM
        W = aW
        Tp = aTp
        N = aN
        MA = aMa
        TA = aTA
        A = aA
        AD = aAD
        PR = aPR
    }
    
    init( jplString: String ) {
        parseElementFromJPLString(jplString: jplString )
    }
    
    init( jplVector: [String] ) {
        parseElementFromJPLVectorString( jplVectorString: jplVector )
    }
    
    /****
     JDTDB    Julian Day Number, Barycentric Dynamical Time
     EC     Eccentricity, e
     QR     Periapsis distance, q (au)
     IN     Inclination w.r.t XY-plane, i (degrees)
     OM     Longitude of Ascending Node, OMEGA, (degrees)
     W      Argument of Perifocus, w (degrees)
     Tp     Time of periapsis (Julian Day Number)
     N      Mean motion, n (degrees/day)
     MA     Mean anomaly, M (degrees)
     TA     True anomaly, nu (degrees)
     A      Semi-major axis, a (au)
     AD     Apoapsis distance (au)
     PR     Sidereal orbit period (day)
     
     2458239.500000000, A.D. 2018-May-01 00:00:00.0000,  2.196943790444392E+05,  1.559438310088678E+00,  1.339429170576398E+02,  2.897450306697707E+02,  9.812255664307256E+01,  2.458441719941456E+06,  9.032132406446354E+04, -1.826477286459303E+07,  3.045731911132930E+02, -7.098249009011953E-06,  6.684586453809735E+91,  1.157407291666667E+95,
      ****/
    func parseElementFromJPLVectorString( jplVectorString :[String] ) {
        JDTB = Double( String( jplVectorString[0]))!
        
        EC = (jplVectorString[2] as NSString).doubleValue
        
        QR = (jplVectorString[3] as NSString).doubleValue
        IN = (jplVectorString[4] as NSString).doubleValue
        OM = (jplVectorString[5] as NSString).doubleValue
        W = (jplVectorString[6] as NSString).doubleValue
        Tp = (jplVectorString[7] as NSString).doubleValue
        N = (jplVectorString[8] as NSString).doubleValue
        MA = (jplVectorString[9] as NSString).doubleValue
        TA = (jplVectorString[10] as NSString).doubleValue
        A = (jplVectorString[11] as NSString).doubleValue
        AD = (jplVectorString[12] as NSString).doubleValue
        PR = (jplVectorString[13] as NSString).doubleValue
    }
    
    func parseElementFromJPLString( jplString: String ) {
    let rowArray = jplString.components(separatedBy: ", ")
        
        JDTB = Double( String( rowArray[0]))!
        
        EC = (rowArray[2] as NSString).doubleValue
      
        QR = (rowArray[3] as NSString).doubleValue
        IN = (rowArray[4] as NSString).doubleValue
        OM = (rowArray[5] as NSString).doubleValue
        W = (rowArray[6] as NSString).doubleValue
        Tp = (rowArray[7] as NSString).doubleValue
        N = (rowArray[8] as NSString).doubleValue
        MA = (rowArray[9] as NSString).doubleValue
        TA = (rowArray[10] as NSString).doubleValue
        A = (rowArray[11] as NSString).doubleValue
        AD = (rowArray[12] as NSString).doubleValue
        PR = (rowArray[13] as NSString).doubleValue
    }
    
    func JPLElementString()->String {
        let jplElemString = String( format: "%lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg, %lg,", JDTB, EC, QR, IN, OM, W, Tp, N, MA, TA, A, AD, PR)
        
        return jplElemString
    }
}
