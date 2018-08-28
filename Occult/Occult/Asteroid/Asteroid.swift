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

let gauss = 0.01720209895
let muc   = ( 2 * gauss * gauss ) / ( c_light.aud.rawValue * c_light.aud.rawValue )

class Asteroid: AstroBase{
    var AsteroidID           : Int?
    var AsteroidName         : String?
    var ObservationEpoch     : Double?
    
    var Element              :[AsteroidElement] = [AsteroidElement]()
    var NewElem              :Elements = Elements()
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
    
    func NewKeplerianElements( from: Double, to: Double ) {
        NewElem = Elements(name: AsteroidName! )
        NewElem.InitWithJPLHorizons(from: from, to: to)
    }
    
    func StateVect( from: Double, to: Double ) {
        let hor :JPLHorizon = JPLHorizon(BodyName: self.AsteroidName! )
        CalcPeriod(hor: hor, jdStart: from, jdEnd: to)
        //for item in coeff {
        //    print( "\(item.posInd)\t\(item.startEpoc)\t\(item.endEpoc)\t\(item.cX.count)" )
        //}
    }
    
    func calcDailyCoeff( pos :[AsteroidXYZPosition], epoc :Double )->ChebyshevCoeff {
        
        let item : ChebyshevCoeff = ChebyshevCoeff()
        // Calc Chebyshev poly for positons
        item.startEpoc = epoc
        item.endEpoc   = epoc + 1.0
        item.CalcChebyshevCoeff2(n: order, start: item.startEpoc, end: item.endEpoc, Positions: pos )
        return item
    }
    
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
    
    func HeliocentricEclipticalPositionElement( jd: Double, pos : inout Vector, vel : inout Vector ) -> Bool {
        let bRet = false
        _ = Kepler()
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
        var gms2 = jplDE.GetGMS()
        var gmsq = sqrt(gms2)
        var GM = 0.01720209895//jplDE.GetGMS()
        
        var kep = KepElements(aElem: Element[minInd] )
        kep.getEclipticalPosition(GMS: GM, jd: jd, pos: &pos, vel: &vel)
        
        return bRet
    }
    
    func SelectElement( t: Double ) -> AsteroidElement {
        var minDT :Double = t - Element[0].JDTB
        var minInd:Int = 0
        
        for i in 1...Element.count-2 {
            let dT = fabs( t - Element[i].JDTB)
            
            if( dT < minDT ){
                minDT  = dT
                minInd = i
            }
        }
        return Element[minInd]
    }
    
    func EclipticalGeocentricVector( GM: Double, jplDE :JPLDE, Sun :Vector, t :Double, pos :inout Vector, vel :inout Vector) {
        var kepl = Kepler()
       
        let AstrElement = SelectElement(t: t)
        let kep = KepElements(aElem: AstrElement)
        
        kep.getEclipticalPosition(GMS: GM, jd: t, pos: &pos, vel: &vel)
        //let R_Sun = jplDE.SunPos(JD: t )
        let geocentric = pos - Sun
        let aberration = AberrationFactor(jplDE: jplDE, t: t, p_corp: geocentric, v_corp: vel)
        pos = geocentric - aberration
    }
    
    func EclipticalVector( GM: Double, jplDE :JPLDE, t :Double, pos :inout Vector, vel :inout Vector) {
        let AstrElement = SelectElement(t: t)
        let kep = KepElements(aElem: AstrElement)
        
        kep.getEclipticalPosition(GMS: GM, jd: t, pos: &pos, vel: &vel)
    }
    
    func EquatorialVector( jplDE :JPLDE, t :Double, pos :inout Vector, vel :inout Vector){
        
        let R_Sun = jplDE.SunPos(JD: t )
        let GM = sqrt( jplDE.GetGMS() )
        EclipticalGeocentricVector(GM: GM, jplDE: jplDE, Sun: R_Sun, t: t, pos: &pos, vel: &vel)
        pos = EclipticalToEquatorial(a: pos, jd: Equinox2000 )
        vel = EclipticalToEquatorial(a: vel, jd: Equinox2000 )
    }
    
    /*********************************************************************
     *  Q( t )                                                           *
     *  Compute the barycentric position of body                         *
     *                                                                   *
     *  Params:                                                          *
     *  t    :Double   Time [jd] in TBD                                  *
     *  GM   :Double   GM Costant                                        *
     *  kep  :Keplerian Elements for the pov & vel calculus              *
     *                                                                   *
     *  Returns                                                          *
     *  pos  :Vector     body position x,y,z vector  (Eclipical Coord.)  *
     *  vel  :Vector     body velocity x,y,z vector  (Eclipical Coord.)  *
     *                                                                   *
     *********************************************************************/
    func Q( t :Double, GM :Double, kep :KepElements, pos : inout Vector, vel :inout Vector, flag :Bool ) {
        if( flag ) {
            kep.getEclipticalPosition(GMS: GM, jd: t, pos: &pos, vel: &vel)
        } else {
            kep.getEclipticalPosition(GMS: GM, jd: t, pos: &pos, vel: &vel)
        }
    }
    
    func Q( t :Double, GM :Double, kep :KepElements , flag :Bool ) -> Vector{
        var q_pos :Vector = Vector([0.0,0.0,0.0])
        var q_dot :Vector = Vector([0.0,0.0,0.0])
        if( flag ) {
            kep.getEclipticalVector(pos: &q_pos, vel: &q_dot)
        } else {
            kep.getEclipticalPosition(GMS: GM, jd: t, pos: &q_pos, vel: &q_dot)
        }
        
        return q_pos
    }
    
    /*********************************************************************
     *  E( t )                                                           *
     *  Compute the barycentric position of Earth                       *
     *                                                                   *
     *  Params:                                                          *
     *  t    :Double   Time [jd] in TBD                                  *
     *  jplDE:JPLDE object                                               *
     *                                                                   *
     *  Returns                                                          *
     *  pos  :Vector     body position x,y,z vector  (Eclipical Coord.)  *
     *  vel  :Vector     body velocity x,y,z vector  (Eclipical Coord.)  *
     *                                                                   *
     *********************************************************************/
    func E( t :Double, jplDE :JPLDE, pos : inout Vector, vel :inout Vector) {
        pos = jplDE.EarthBaryEclPos(t: t)
        vel = jplDE.EarthBaryEclVel(t: t)
    }
    
    func E( t :Double, jplDE :JPLDE )->Vector {
        return jplDE.EarthBaryEclPos(t: t)
    }
    
    /*********************************************************************
     *  S( t )                                                           *
     *  Compute the barycentric position of Sun                          *
     *                                                                   *
     *  Params:                                                          *
     *  t    :Double   Time [jd] in TBD                                  *
     *  jplDE:JPLDE object                                               *
     *                                                                   *
     *  Returns                                                          *
     *  pos  :Vector     body position x,y,z vector  (Eclipical Coord.)  *
     *                                                                   *
     *********************************************************************/
    
    func S( t :Double, jplDE :JPLDE, pos : inout Vector ) {
        pos = jplDE.SunBaryEclPos(t: t)
    }
    
    func S( t :Double, jplDE :JPLDE  ) -> Vector{
        return jplDE.SunBaryEclPos(t: t)
    }
    
    func P( t :Double, GM :Double, kep :KepElements, jplDE :JPLDE , flag :Bool ) -> Vector {
        return Q(t: t, GM: GM, kep: kep, flag: flag) - E( t: t, jplDE: jplDE )
    }
    
    func RelativisticLightTimeCorrection( t: Double, kep :KepElements , jplDE :JPLDE, flag :Bool )->Double {
        var tau = 0.0
        var tau_old = 0.0
        let GMB = sqrt( jplDE.GetGMB() )
        var q_pos :Vector = Vector([0.0,0.0,0.0])
        var q_dot :Vector = Vector([0.0,0.0,0.0])
        var e_pos :Vector = Vector([0.0,0.0,0.0])
        var e_dot :Vector = Vector([0.0,0.0,0.0])
        var s_pos :Vector = Vector([0.0,0.0,0.0])
        
        repeat {
            Q(t: t - tau, GM: GMB, kep: kep, pos: &q_pos, vel: &q_dot, flag: flag)
            E(t: t, jplDE: jplDE, pos: &e_pos, vel: &e_dot)
            S(t: t, jplDE: jplDE, pos: &s_pos )
            
            let p_pos = q_pos - e_pos
            var e_pos_hel = e_pos - s_pos
            
            S(t: t - tau, jplDE: jplDE, pos: &s_pos )
            var q_pos_hel = q_pos - s_pos
            let q_norm = Norm( a: q_pos_hel )
            let p_norm = Norm( a: p_pos )
            let e_norm = Norm( a: e_pos_hel )
            var ctau = p_norm + ( 2 * muc / ( c_light.aud.rawValue * c_light.aud.rawValue ) ) * log( ( e_norm + p_norm + q_norm ) / (e_norm - p_norm + q_norm))
            tau_old = tau
            tau = ctau / c_light.aud.rawValue
        } while( (tau - tau_old) > 1e-15 )
        
        return tau
    }
    
    func printEclVector( a : Vector) {
    
    }
    
    func EclipticalApparentPositionVector( kep : KepElements,jplDE :JPLDE, ta :Double , flag :Bool )->Vector  {
        
        let GM          = sqrt( jplDE.GetGMB() )
        //let AstrElement = SelectElement(t: ta)
        //let kep         = KepElements(aElem: AstrElement)
        let t = ta + RelativisticLightTimeCorrection(t: ta, kep: kep, jplDE: jplDE, flag: flag)
    
        let p_ecl_pos = P(t: t, GM: GM, kep: kep, jplDE: jplDE, flag: flag )
        let q_ecl_pos = Q(t: t, GM: GM, kep: kep , flag: flag )
        let e_ecl_pos = E(t: t, jplDE: jplDE )
        
        let p_norm = Norm(a: p_ecl_pos )
        let q_norm = Norm(a: q_ecl_pos )
        let e_norm = Norm(a: e_ecl_pos )
        
        let p_vers = p_ecl_pos ./ p_norm
        let q_vers = q_ecl_pos ./ q_norm
        let e_vers = e_ecl_pos ./ e_norm
        
        let light_deflection = ( 2 * muc / (e_norm * c_light.aud.rawValue * c_light.aud.rawValue) ) * ( ( p_vers ./ q_vers ) * e_vers - (e_vers ./ p_vers) * q_vers ) ./ (1 + q_vers .* p_vers )
        
        let p1 = p_vers + light_deflection
        
        let V = jplDE.EarthBaryEclVel(t: t) ./ c_light.aud.rawValue
        let V_norm = Norm(a: V )
        let beta = 1.0 / sqrt( 1 - V_norm * V_norm )
        let p2n = p1 ./ beta + ((1 + p1 .* V) ./ ( 1 + 1/beta )) * V
        let p2d = (1 + p1 .* V)
        let p2 = p2n ./ p2d
        
        let N = NutMatrix(T: T(jd: t))
        let PM = PrecMatrix(t1: T(jd: Equinox2000) , t2: T(jd: t) )
        let NP = N * PM
        let p3 = NP * p2
        
        return p3
        
        //
    }
    
    
    func EquatorialApparentPositionVector( kep :KepElements ,jplDE: JPLDE, ta: Double, flag :Bool ) -> Vector {
        let tb = BarycentricDyanamicalTime(jd: ta )
        let pos = EclipticalApparentPositionVector(kep: kep, jplDE: jplDE, ta: tb , flag: flag )
        return EclipticalToEquatorial(a: pos, jd: Equinox2000 )
    }
    
    func EquatorialApparentPosition( kep: KepElements, jplDE :JPLDE, t :Double, flag :Bool ) -> EquatorialCoordinate {
        
        let state = EquatorialApparentPositionVector(kep: kep, jplDE: jplDE, ta: t, flag: flag)
        let eqel = EquatorialCoordinate(cartesian: state )
        
        return eqel
    }
    
    func EquatorialApparentPosition( jplDE :JPLDE, t :Double ) -> EquatorialCoordinate {
        
        let AstrElement = SelectElement(t: t)
        let kep = KepElements( aElem: AstrElement )
        let state = EquatorialApparentPositionVector(kep: kep, jplDE: jplDE, ta: t, flag: false)
        let eqel = EquatorialCoordinate(cartesian: state )
        
        return eqel
    }
    
    func EquatorialApparentPositionNew( jplDE :JPLDE, t :Double ) -> EquatorialCoordinate {
        
        let kep = NewElem.val(t: t)
        let state = EquatorialApparentPositionVector(kep: kep, jplDE: jplDE, ta: t, flag: true )
        let eqel = EquatorialCoordinate(cartesian: state )
        
        return eqel
    }
    
    func EquatorialPosition( jplDE :JPLDE, t :Double , t0 :Double )->EquatorialCoordinate  {
        var pos :Vector = Vector([0.0,0.0,0.0])
        var vel :Vector = Vector([0.0,0.0,0.0])
        
        EquatorialVector(jplDE: jplDE, t: t, pos: &pos, vel: &vel)
        let eqel = EquatorialCoordinate(cartesian: pos )
        if( t != t0 ) {
            eqel.precessed(from: t, to: t0)
        }
        return eqel
    }
}


