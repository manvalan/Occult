//
//  KeplerianElements.swift
//  Occult
//
//  Created by Michele Bigi on 23/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class KepElements {
    
    /*
     element.a = a_calc.getval(val: t )
     element.e = e_calc.getval(val: t )
     element.i = i_calc.getval(val: t )
     element.m = m_calc.getval(val: t )
     element.Ω = Ω_calc.getval(val: t )
     element.ω = ω_calc.getval(val: t )
 */
    var jd0         : Double = 0.0      // epoc of elements [day]
    var a           : Double = 0.0      // Semi axis major of orbit [AU]
    var e           : Double = 0.0      // eccentricity [1]
    var i           : Double = 0.0      // inclination of orbit [rad]
    var Ω           : Double = 0.0      // Longitude ascendenting node [rad]
    var ω           : Double = 0.0      // Argument of perihelion [rad]
    var m           : Double = 0.0      // mean Anomaly [rad]
    let GM          : Double = 0.01720209895
    
    init() {
    }
    
    init( aElem :AsteroidElement ) {
        
        jd0 = aElem.JDTB
        a = aElem.A
        e = aElem.EC
        i = aElem.IN
        Ω = aElem.OM
        ω = aElem.W
        m = aElem.MA
    }
    
    init( JDTB :Double, A :Double, EC :Double, IN:Double, OM :Double, W:Double, MA:Double ) {
        
        jd0      = JDTB
        a        = A
        e        = EC
        i        = IN
        Ω = OM
        ω  = W
        m = MA
        
    }
    
    init( jd: Double, pos :Vector, vel :Vector ) {
        var ps :PhaseState = PhaseState()
        
        ps.x  = pos[0]
        ps.y  = pos[1]
        ps.z  = pos[2]
        ps.xd = vel[0]
        ps.yd = vel[1]
        ps.zd = vel[2]
        
        var oa = OrbitalElements()
        keplerian( GM, ps, &oa )
        /*Ω = OM
         ω  = W*/
        jd0 = jd
        a = oa.a
        e = oa.e
        i = oa.i
        Ω = oa.longnode
        ω = oa.argperi
        m = oa.meananom
    }
    
    func getEclipticalVector( pos :inout Vector, vel :inout Vector ) {
        let oe = OrbitalElements( a: a, e: e, i: i, longnode: Ω, argperi: ω, meananom: m )
        var state = PhaseState();
        cartesian( GM, oe, &state )
        pos[0] = state.x
        pos[1] = state.y
        pos[2] = state.z
        vel[0] = state.xd
        vel[1] = state.yd
        vel[2] = state.zd
    }
    
    func getEclipticalPosition( GMS :Double, jd :Double, pos :inout Vector, vel :inout Vector ) {
        let oe = OrbitalElements( a: a, e: e, i: i, longnode: Ω , argperi: ω, meananom: m )
        var state = PhaseState();
        ecliptical_position( jd - jd0, GMS, oe, &state )
        
        pos[0] = state.x
        pos[1] = state.y
        pos[2] = state.z
        vel[0] = state.xd
        vel[1] = state.yd
        vel[2] = state.zd
    }
}
