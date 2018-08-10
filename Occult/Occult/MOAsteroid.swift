//
//  MOAsteroid.swift
//  MacOccult
//
//  Created by Michele Bigi on 21/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MOAsteroid{
    var AsteroidID           : Int?
    var AsteroidName         : String?
    var ObservationEpoch     : Double?
    
    var Element              = [MOAsteroidElement]()
    
    var Diameter             : Double?
    var Brightness           : Double?
    var Slope                : Double?
    var EphemerisUncertainty : Double?
    
    /*
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
     */
    
    init( aAsteroidID : Int , aAsteroidName: String, aObservationEpoch : Double, aM : Double, aW : Double, aO : Double, aI : Double, aE : Double, aA: Double, aDiameter: Double, aBrightness : Double, aSlope: Double, aEphemerisUncertainty : Double ) {
        AsteroidID = aAsteroidID
        AsteroidName = aAsteroidName
        ObservationEpoch = aObservationEpoch
        
        let elem = MOAsteroidElement(aJDTB: aObservationEpoch, aEC: aE, aQR: 0, aIN: aI, aOM: aO, aW: aW, aTp: 0, aN: 0, aMa: aM, aTA: 0, aA: aA, aAD: 0, aPR: 0 )
        Element.append(elem)
        
        // M = aM
        // W = aW
        // O = aO
        // I = aI
        // E = aE
        // A = aA
        Diameter = aDiameter
        Brightness = aBrightness
        Slope = aSlope
        EphemerisUncertainty = aEphemerisUncertainty
    }
    
    init( name : String , startData: MOData, endData: MOData, step: MOData ) {
        AsteroidName = name 
        let elem = MOHorizon( asteroid: self )
        
        Element = elem.ExecQuery( StartEphem: startData, EndEphem: endData, StepTime: step )
    
    }
}


