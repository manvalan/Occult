//
//  AtStartForTest.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation


class AtStartForTest {

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
        print( "AU:\t\(aud)\n" );
        print( "DE:\t\(ver)\n")
       
        //jplDE.jpl_init_ephemeris( ephemeris_filename: ephemeris_file, nam: nam, val: val)
    }
    
}
