//
//  AtStartForTest.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
let Equinox2000 = 2451545.0

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
       
        //var ephemeris_file = Bundle.main.resourcePath! + "/unxp2000.405"
        var ephemeris_file = Bundle.main.resourcePath! + "/DE_Ephemeris.bin"
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
        
//        let urlPath = Bundle.main.url(forResource: "mpcorb_extended", withExtension: "json")
//
//        var MPCOrbTest = MPCOrb()
//        MPCOrbTest.MPCOrbParseJSONFile(urlFile: urlPath! )
        //print( "Number of Asteroid in Database: \(MPCOrbTest.database.count)" )
        //MPCOrbTest.database
        
        /*
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
        */
        let ara :HourAngle   = HourAngle(hour: 16, minute: 27, second: 59.33)
        let adec:DegreeAngle = DegreeAngle(degree: 0, minute: 58, second: 7.0)
        let true_pos = EquatorialCoordinate(rightAscension: ara, declination: adec, distance: 0)
        print( "Electra Apparent True: RA:\(true_pos.raString())  DEC: \(true_pos.decString())")
 
        let startData = 2458346.5
        let endData   = 2458356.5
        let aBase = AstroBase()
        let elektra = Asteroid(name: "130")
        elektra.KeplerianElements(from: startData, to: endData, step: 1 )
        
        let jd = 2458349.166666667
        var elektra_Pos : Vector = [0.0 , 0.0, 0.0 ]
        var elektra_Vel : Vector = [0.0 , 0.0, 0.0 ]
        var elektra_eq = elektra.EquatorialPosition(jplDE: jplDEEff, t: jd , t0: Equinox2000 )
        var elektra_eq_app = elektra.EquatorialApparentPosition(jplDE: jplDEEff, t: jd )
        print( "Electra Apparent Eq:   RA:\(elektra_eq_app.raString())  DEC: \(elektra_eq_app.decString())")
        let sep  = true_pos.angularSeparation( from: elektra_eq_app )
        print( "Angular Separation:  \(sep)" )
        /***** NEW INTERFACE *****/
        let ele2 = Asteroid(name: "130")
        ele2.NewKeplerianElements(from: startData, to: endData )
        let ele2_app = ele2.EquatorialApparentPositionNew(jplDE: jplDEEff, t: jd )
        print( "Electra Apparent Eq:   RA:\(ele2_app.raString())  DEC: \(ele2_app.decString())")
        let sep2 = true_pos.angularSeparation( from: ele2_app )
        print( "Angular Separation:  \(sep2)" )
        
//        let ady = AstDys2()
//        let adyLine = ady.read()
//        for i in 0...20 {
//            print( adyLine[i] )
//        }
 
    }
}
