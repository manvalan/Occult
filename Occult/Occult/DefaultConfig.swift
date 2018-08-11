//
//  DefaultConfig.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation


class DefaultConfig {
    init() {
        makeFolder(pathFolder: defaultData )
        makeFolder(pathFolder: defaultJPLDE )
    }
    
    let defaultPath  = "/Users/michelebigi/Documents/Develop/OccultData"
    let defaultData  = "/Users/michelebigi/Documents/Develop/OccultData/data"
    let defaultJPLDE = "/Users/michelebigi/Documents/Develop/OccultData/data/JPLDE"
    let JPLDEFilename :String = "/Users/michelebigi/Documents/Develop/OccultData/data/JPLDE/unxp2000.405"
    
    func makeFolder ( pathFolder: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory( atPath: pathFolder, withIntermediateDirectories: true, attributes: nil)
            print("Create Folder \(pathFolder) \n")
        }
        catch let error as NSError {
            print("Folder Exist or \(error)")
        }
    }
    
}
