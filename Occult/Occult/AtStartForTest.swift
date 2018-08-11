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
        
        var nam: [ String ] = Array( repeating: "" , count: 10 )
        var val: [ Double ]  = Array( repeating: 0.0 , count: 10 )
        
        
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
        //jplDE.jpl_init_ephemeris( ephemeris_filename: ephemeris_file, nam: nam, val: val)
    }
    
}
