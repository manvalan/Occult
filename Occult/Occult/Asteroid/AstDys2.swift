//
//  AstDys2.swift
//  Occult
//
//  Created by Michele Bigi on 30/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class AstDys2 {
    
    init() {
        
    }
    
    func read()-> [String] {
        let fileName = "allnum.cat"
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName){
            /*
            // Write to the file named Test
            let outString = "Write this text to the file"
            do {
                try outString.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            */
            // Then reading it back from the file
            var inString = ""
            do {
                inString = try String(contentsOf: fileURL)
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            let ElemStringArray = inString.lines
            return Array<String>( ElemStringArray[6...ElemStringArray.count-1] )
        }
        return [String]()
    }
}
