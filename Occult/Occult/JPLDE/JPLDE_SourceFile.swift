//
//  MODE_SourceFile.swift
//  Occult
//
//  Created by Michele Bigi on 27/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class JPLDE_SourceFile {
    var File : String {
        get {
            return self.File
        }
        set( value ){
            self.File = value
        }
    }
    
    var toBeUsed : Bool {
        get {
            return self.toBeUsed
        }
        set( value ){
            self.toBeUsed = value
        }
    }
    
    var FileName : String {
        get {
            return self.FileName
        }
        set( value ){
            self.FileName = value
        }
    }
    
    var startJD : Double {
        get {
            return self.startJD
        }
        set( value ){
            self.startJD = value
        }
    }
    
    var endJD : Double {
        get {
            return self.endJD
        }
        set( value ){
            self.endJD = value
        }
    }
    
    static func == ( left: JPLDE_SourceFile, right: JPLDE_SourceFile)->Bool {
        return left.startJD == right.startJD
    }
    
    func toString() -> String {
        let Start = MOData( jd: startJD )
        let End   = MOData( jd: endJD )
        
        return FileName + "\t" + Start.toString() + "\t" + End.toString()
    }
    
}

