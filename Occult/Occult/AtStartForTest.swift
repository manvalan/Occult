//
//  AtStartForTest.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
let Equinox = 2451545.0
class AtStartForTest{

    let defConfig :DefaultConfig = DefaultConfig()

    init () {
        var jplDEEff = JPLDE()

        let fm = FileManager.default
        let documentsURL = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = Bundle.main.resourcePath!
        print( "Path: \(path)\n" )
        do {
            let items = try fm.contentsOfDirectory(atPath: path )
            
            for item in items {
                print("Found \(item)")
            }
        } catch {
            print( "not found" )
            // failed to read directory – bad permissions, perhaps?
        }
       
        var ephemeris_file = Bundle.main.resourcePath! + "/unxp2000.405"
        jplDEEff.Init(FilePath: ephemeris_file )
        let aud = jplDEEff.GetAU()
        let ver = jplDEEff.DEVersion()
        
        print( "AU:\t\(aud)\n" )
        print( "DE:\t\(ver)\n")
       
        var tooday : Double = 2458342.5
        let sun = jplDEEff.EarthBaryEquPos(JD: tooday )
        print( sun )
        
//        var an :MPCAsteroidName = MPCAsteroidName()
        
//        print( "J95X00A\t" + an.MPCgetName(key: "J95X00A") )
//        print( "J95X01L\t" + an.MPCgetName(key: "J95X01L") )
//        print( "J95F13B\t" + an.MPCgetName(key: "J95F13B") )
//        print( "J98SA8Q\t" + an.MPCgetName(key: "J98SA8Q") )
//
//        print( "J98SC7V\t" + an.MPCgetName(key: "J98SC7V") )
//        print( "J98SG2S\t" + an.MPCgetName(key: "J98SG2S") )
//        print( "K99AJ3Z\t" + an.MPCgetName(key: "K99AJ3Z") )
//        print( "K08Aa0A\t" + an.MPCgetName(key: "K08Aa0A") )
//        print( "K07Tf8A\t" + an.MPCgetName(key: "K07Tf8A") )
//
//        print( "03202\t" + an.MPCgetName(key: "03202") )
//        print( "50000\t" + an.MPCgetName(key: "50000") )
//        print( "A0345\t" + an.MPCgetName(key: "A0345") )
//        print( "a0017\t" + an.MPCgetName(key: "a0017") )
//        print( "K3289\t" + an.MPCgetName(key: "K3289") )
        
        //let urlPath = Bundle.main.url(forResource: "mpcorb_extended", withExtension: "json")

        //var MPCOrbTest = MPCOrb()
        //MPCOrbTest.MPCOrbParseJSONFile(urlFile: urlPath! )
        //print( "Number of Asteroid in Database: \(MPCOrbTest.database.count)" )
        //MPCOrbTest.database
        print( "EMRAT:\t\(jplDEEff.GetConst(const: "EMRAT"))" )
        print( "GMS:\t\(jplDEEff.GetConst(const: "GMS"))" )
        print( "GMB:\t\(jplDEEff.GetConst(const: "GMB"))" )
        print( "GM1:\t\(jplDEEff.GetConst(const: "GM1"))" )
        print( "GM2:\t\(jplDEEff.GetConst(const: "GM2"))" )
        print( "GM4:\t\(jplDEEff.GetConst(const: "GM4"))" )
        print( "GM5:\t\(jplDEEff.GetConst(const: "GM5"))" )
        print( "GM6:\t\(jplDEEff.GetConst(const: "GM6"))" )
        print( "GM7:\t\(jplDEEff.GetConst(const: "GM7"))" )
        print( "GM8:\t\(jplDEEff.GetConst(const: "GM8"))" )
        print( "GM9:\t\(jplDEEff.GetConst(const: "GM9"))" )
        
        
        let startData = 2458346.5
        let endData   = 2458356.5
        let aBase = AstroBase()
        let elektra = Asteroid(name: "130")
        elektra.KeplerianElements(from: startData, to: endData, step: 24 )
        //elektra.StateVect(from: startData, to: endData)
        
        
        //var elektra_state = elektra.State
        
        let jd = 2458348.5
        
        var elektra_Pos : Vector = [0.0 , 0.0, 0.0 ]
        var elektra_Vel : Vector = [0.0 , 0.0, 0.0 ]
        
        //elektra.HeliocentricEclipticalPositionState(jd: jd, pos: &elektra_Pos, vel: &elektra_Vel)
        
        elektra.HeliocentricEclipticalPositionElement(jd: jd, pos: &elektra_Pos, vel: &elektra_Vel)
        let R_Sun = jplDEEff.SunPos(JD: jd )
        print("130 - Elektra")
        print("\tHeliocentric Ecliptical Position: \(elektra_Pos)")
        print("\tHeliocentric Ecliptical Velocity: \(elektra_Vel)")
        var R_Elektra = elektra_Pos + R_Sun
        let dist = aBase.Norm(a: R_Elektra)
        let fac = 0.00578 * dist
        R_Elektra = R_Elektra + fac .* elektra_Vel
        print("\tGeocentric Ecliptical Velocity  : \(R_Elektra)")
        
//        //let R_Elektra = elektra_Pos + R_Sun
//        let dist = aBase.Norm(a: R_Elektra)
//        let fac = 0.00578 * dist
//        print( elektra_Pos )
//        //print( elektra_Vel )
//        print( R_Sun )
//        print( R_Elektra )
//        var ElektraEQ = aBase.Ecl2EquMatrix(T: aBase.T(jd: Equinox )) * R_Elektra
//        var ElektraEQP = aBase.CalcPolarAngles(a: ElektraEQ)
//        print( "Equatorial XYZ: \(ElektraEQ)" )
//        print( "Equatorial    : \(ElektraEQP)" )
//        //ElektraEQP = ElektraEQP .* aBase.Deg
//        print( ElektraEQP )
//
//        //        var a: Matrix = Matrix( [ [1,0,0],[0,1,0],[0,0,1]] )
////        var b: Vector = [ 2, 2, 2]
////        let ab = a * b
////        let ab2 = a .* b
   }
    
}
