//
//  CalcChebyshev.swift
//  Occult
//
//  Created by Michele Bigi on 16/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
//
//  Chebyshev.swift
//  Occult
//
//  Created by Michele Bigi on 14/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

private let max_order  : Int = 24
private let order      : Int = max_order

class CalcChebyshev{
    private var astpos : [AsteroidXYZPosition] = [AsteroidXYZPosition]()
    private var coeff  : [ChebyshevCoeff] = [ChebyshevCoeff]()
    
    private var lowEpoc: Double = 0.0
    private var higEpoc: Double = 0.0
    private var posInd : Int = 0
    /******************************************************************************/

    init() {
    }
    
    init( aAst: String, dJDStart: Double, dJDEnd: Double ) {
        var jplHor : JPLHorizon = JPLHorizon(BodyName: aAst)
        CalcPeriod( jplHorizon: jplHor, jdStart: dJDStart, jdEnd: dJDEnd )
    }
    
    func calcDaylyCoeff( jplHorizons: JPLHorizon, epoc :Double ) -> ChebyshevCoeff {
        var AstCoef = ChebyshevCoeff()
        
        lowEpoc = epoc
        higEpoc = epoc+1
        let startEpoc : MOData = MOData( jd: lowEpoc)
        let endEpoc   : MOData = MOData( jd: higEpoc  )

        let dStepH = 0
        let dStepM = 60

        let stp : MOData = MOData( hh: dStepH, mn: dStepM )
        
        // JPL Horizons batch
        jplHorizons.PositionsVector(StartEphem: startEpoc, EndEphem: endEpoc, StepTime: stp )
        // waiting...
        while ( jplHorizons.GetPosState() == false ) {
        }
        // get X,Y,Z pos
        let pos : [AsteroidXYZPosition] = jplHorizons.GetPosVec()
        // Calc Chebyshev poly for positons
        AstCoef.CalcChebyshevCoeff2(n: order, start: lowEpoc, end: higEpoc, Positions: pos )
        
        return AstCoef
}
    
    func CalcPeriod( jplHorizon: JPLHorizon, jdStart: Double, jdEnd: Double ){
        let len =  Int( jdEnd - jdStart ) - 1    
        coeff = [ChebyshevCoeff]( repeating: ChebyshevCoeff(), count: len+1 )
        for j in 0...len {
            let jd = jdStart + Double( j )
            
            coeff[j] = calcDaylyCoeff( jplHorizons: jplHorizon, epoc:jd )
            //print( "\(j)\t\(coeff[j].startEpoc)\t\(coeff[j].endEpoc)\t\(coeff[j].cX.count)" )
        }
    }
    
    func GetCoeff() -> [ChebyshevCoeff] {
        return coeff
    }
    
   
    
    
}
