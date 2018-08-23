//
//  MOAsteroid.swift
//  MacOccult
//
//  Created by Michele Bigi on 21/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
private let max_order  : Int = 24
private let order      : Int = max_order

class Asteroid: AstroBase{
    var AsteroidID           : Int?
    var AsteroidName         : String?
    var ObservationEpoch     : Double?
    
    var Element              :[AsteroidElement] = [AsteroidElement]()
    var IsElement            :Bool = false
    var coeff                :[ChebyshevCoeff]  = [ChebyshevCoeff]()
    var IsState              :Bool = false
    
    var Diameter             : Double?
    var Brightness           : Double?
    var Slope                : Double?
    var EphemerisUncertainty : Double?
    
    init( aAsteroidID : Int , aAsteroidName: String, aObservationEpoch : Double, aM : Double, aW : Double, aO : Double, aI : Double, aE : Double, aA: Double, aDiameter: Double, aBrightness : Double, aSlope: Double, aEphemerisUncertainty : Double ) {
        AsteroidID = aAsteroidID
        AsteroidName = aAsteroidName
        ObservationEpoch = aObservationEpoch
        
        let elem = AsteroidElement(aJDTB: aObservationEpoch, aEC: aE, aQR: 0, aIN: aI, aOM: aO, aW: aW, aTp: 0, aN: 0, aMa: aM, aTA: 0, aA: aA, aAD: 0, aPR: 0 )
        Element.append(elem)
        
        Diameter = aDiameter
        Brightness = aBrightness
        Slope = aSlope
        EphemerisUncertainty = aEphemerisUncertainty
    }
    
    init( name : String ) {
        AsteroidName = name
    }
    
    override init() {
        AsteroidName = ""
    }
    
    func KeplerianElements( from: Double, to: Double , step: Double) {
        let hor :JPLHorizon = JPLHorizon(BodyName: self.AsteroidName! )
        hor.KeplerianElements(Start: from, End: to, Step: step )
        hor.WaitResults()
        Element = hor.GetElements()
        IsElement = true
    }
    
    func StateVect( from: Double, to: Double ) {
        let hor :JPLHorizon = JPLHorizon(BodyName: self.AsteroidName! )
        CalcPeriod(hor: hor, jdStart: from, jdEnd: to)
        //for item in coeff {
        //    print( "\(item.posInd)\t\(item.startEpoc)\t\(item.endEpoc)\t\(item.cX.count)" )
        //}
    }
    
    func calcDailyCoeff( pos :[AsteroidXYZPosition], epoc :Double )->ChebyshevCoeff {
        
        var item : ChebyshevCoeff = ChebyshevCoeff()
        // Calc Chebyshev poly for positons
        item.startEpoc = epoc
        item.endEpoc   = epoc + 1.0
        item.CalcChebyshevCoeff2(n: order, start: item.startEpoc, end: item.endEpoc, Positions: pos )
        return item
    }
    
    /****
     var item : ChebyshevCoeff = ChebyshevCoeff()
     item.startEpoc = epoc
     item.endEpoc   = epoc+1
     let startEpoc : MOData = MOData( jd: item.startEpoc)
     let endEpoc   : MOData = MOData( jd: item.endEpoc  )
     
     let dStepH = 0
     let dStepM = 60
     
     let stp : MOData = MOData( hh: dStepH, mn: dStepM )
     
     // JPL Horizons batch
     jplHorizons.PositionsVector(StartEphem: startEpoc, EndEphem: endEpoc, StepTime: stp )
     // waiting...
     jplHorizons.WaitResults()
     
     // get X,Y,Z pos
     let pos : [AsteroidXYZPosition] = jplHorizons.GetPosVec()
 *****/
    
    func CalcPeriod( hor: JPLHorizon, jdStart: Double, jdEnd: Double ){
        let len =  Int( jdEnd - jdStart ) - 1
        let startEpoc : MOData = MOData( jd: jdStart)
        let endEpoc   : MOData = MOData( jd: jdEnd  )
        
        let dStepH = 0
        let dStepM = 60
        
        let stp : MOData = MOData( hh: dStepH, mn: dStepM )
        // JPL Horizons batch
        hor.PositionsVector(StartEphem: startEpoc, EndEphem: endEpoc, StepTime: stp )
        // waiting...
        hor.WaitResults()
        
        // get X,Y,Z pos
        let pos  :[AsteroidXYZPosition] = hor.GetPosVec()
        
        coeff = [ChebyshevCoeff]( repeating: ChebyshevCoeff(), count: len+1 )
        
        for j in 0...len {
            let jd = jdStart + Double( j )
            
            var k = 0
            var minRange :Int = 0
            var eMin : Double = pos[0].t
            var maxRange :Int = 0
            var eMax : Double = pos[0].t
            
            for i in 0...pos.count-1 {
                if( ( pos[i].t <= jd ) && ( pos[i].t > eMin ) ) {
                    eMin = pos[i].t
                    minRange = i
                }
                if( ( pos[i].t <= (jd+1)) && ( pos[i].t > eMax ) ) {
                    eMax = pos[i].t
                    maxRange = i
                }
            }
            
            let pos_slice = pos[minRange...maxRange]
            let pos2 :[AsteroidXYZPosition] = Array<AsteroidXYZPosition>( pos_slice )
            coeff[j] = calcDailyCoeff( pos: pos2, epoc:jd )
            
        }
    }
    
    func HeliocentricEclipticalPositionState( jd: Double, pos : inout Vector, vel : inout Vector ) -> Bool {
        var bRet = false
        
        for i in 0...coeff.count-1 {
            if( ( jd >= coeff[i].startEpoc ) && ( jd < coeff[i].endEpoc ) ) {
                pos = coeff[i].GetPosNew(t: jd)
                break
            }
        }
        return bRet
    }
        
    func HeliocentricEclipticalPositionElement( jd: Double, pos : inout Vector, vel : inout Vector ) -> Bool {
        var bRet = false
        var kepl = Kepler()
        var minDT :Double = jd - Element[0].JDTB
        var minInd:Int = 0
        let jplDE = JPLDE()
        
        for i in 1...Element.count-2 {
            var dT = fabs( jd - Element[i].JDTB)
            if( dT < minDT ){
                minDT  = dT
                minInd = i
            }
        }
        print( "Elem :\(minInd)\t @:\(Element[minInd].JDTB)\tJD: \(jd)" )
        print( Element[minInd].Print() )
        var GM = 0.01720209895//jplDE.GetGMS()
        print( "GM: \(GM)")
        print( "KG: 0.01720209895")
        //kepl.Position(elem: Element[minInd], t: jd, GM: GM, r: &pos, v: &vel)
        kepl.PositionNew(elem: Element[minInd], t: jd, GM: GM, r: &pos, v: &vel)
        return bRet
    }
}


