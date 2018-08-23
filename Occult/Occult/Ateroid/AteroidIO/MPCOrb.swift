//
//  MPCOrbJSON.swift
//  Occult
//
//  Created by Michele Bigi on 13/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

struct MPCOrbData :Codable {
    let Name: String?
    let Number: String?
    let Principal_desig: String?
    let Other_desigs: [String]?
    let H : Double?
    let G : Double?
    let Epoch: Double?
    let a: Double?
    let e: Double?
    let i: Double?
    let Node: Double?
    let Peri: Double?
    let M: Double?
    let n: Double?
    let U: String?
    let Ref: String?
    let Num_obs: Int?
    let Num_opps: Int?
    let Arc_years: String?
    let Arc_length: Int?
    let rms: Double?
    let Perturbers: String?
    let Perturbers_2: String?
    let Last_obs: String?
    let Hex_flags: String?
    let Computer: String?
    let orbit_type: String?
    let NEO_flag: Int?
    let One_km_NEO_flag: Int?
    let PHA_flag: Int?
    let One_opposition_object_flag : Int?
    let Critical_list_numbered_object_flag :Int?
    let Perihelion_dist : Double?
    let Aphelion_dist :Double?
    let Semilatus_rectum : Double?
    let Orbital_period : Double?
    let Synodic_period : Double?
}

class MPCOrb {
    
    var database : [MPCOrbData] = [MPCOrbData]()
    var isDBExist : Bool = false
    
    init() {
        isDBExist = false
    }
    
    func MPCOrbParseJSONFile( urlFile : URL ) {
        let jsonData = try! Data.init(contentsOf: urlFile )
        let decoder = JSONDecoder()
        database = try! decoder.decode( Array<MPCOrbData>.self , from: jsonData)
        isDBExist = true
    }
}

/*****
 SQLite DB for MinorPlanet
 
 Key                        Type        Description
 Name                       String
 Number                     String
 Principal_desig            String
 H                      Double
 let G                      Double
 let Epoch                  Double
 let a: Double?
 let e: Double?
 let i: Double?
 let Node: Double?
 let Peri: Double?
 let M: Double?
 let n: Double?
 let U: String?
 let Ref: String?
 let Num_obs: Int?
 let Num_opps: Int?
 let Arc_years: String?
 let Arc_length: Int?
 let rms: Double?
 let Perturbers: String?
 let Perturbers_2: String?
 let Last_obs: String?
 let Hex_flags: String?
 let Computer: String?
 let orbit_type: String?
 let NEO_flag: Int?
 let One_km_NEO_flag: Int?
 let PHA_flag: Int?
 let One_opposition_object_flag : Int?
 let Critical_list_numbered_object_flag :Int?
 let Perihelion_dist : Double?
 let Aphelion_dist :Double?
 let Semilatus_rectum : Double?
 let Orbital_period : Double?
 let Synodic_period : Double?
 *****/
class AsteroidDatabase {
    
}
