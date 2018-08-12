//
//  JPLDE.swift
//  Occult
//
//  Created by Michele Bigi on 11/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

enum PlanetType:Int {
        case Mercury = 1,
        Venus,
        Earth,
        Mars,
        Jupiter,
        Saturn,
        Uranus,
        Neptune,
        Pluto,
        Moon,
        Sun,
        Barycenter,
        EMBarycenter,
        Nutations,
        Librations
    }
    
    enum aps_error: Int{
        case APS_JPL_NO_ERROR = 0,
        APS_JPL_INIT,
        APS_JPL_INIT_CONST,
        APS_JPL_REINIT,
        APS_JPL_CONST,
        APS_JPL_GET
    }

class APSJPLERR {
    var ErrCode : Int
    
    init( aErrCode : Int ) {
        ErrCode = aErrCode
    }
    
    func GetErrCode()->Int {
        return( ErrCode )
        
    }
}

let JPL_MAX_CONST_NUM = 400
let JPL_CONST_LENGTH  = 6

class JPLDE {
    var ephem : UnsafeMutableRawPointer!
    var Constants = [ String : Double ]()
    
    init() {
    }
    
    //std::map <const std::string,double> constants;
    func Init( FilePath: String )-> aps_error  {
        var RetCode = aps_error.APS_JPL_NO_ERROR
        
        if( ephem != nil ){
            return aps_error.APS_JPL_REINIT
        }
        
        var vals = Array<Double>(repeating: 0.0 , count: JPL_MAX_CONST_NUM)
        var n_constants : Int32 = 0
        var const_num = Int(JPL_MAX_CONST_NUM )
        var nams = [(Int8, Int8, Int8, Int8, Int8, Int8)](repeating: (0,0,0,0,0,0), count: const_num)
        
        ephem = jpl_init_ephemeris( FilePath.cString(using: String.Encoding.ascii), UnsafeMutablePointer(&nams), &vals )
        if (ephem != nil ){
            n_constants = Int32(jpl_get_long( ephem, JPL_EPHEM_N_CONSTANTS ))
            for i in 0 ... Int(n_constants) {
                var cs_name = [CChar]( repeating: 0 , count: JPL_CONST_LENGTH+1 )
                cs_name[0] = nams[i].0
                cs_name[1] = nams[i].1
                cs_name[2] = nams[i].2
                cs_name[3] = nams[i].3
                cs_name[4] = nams[i].4
                cs_name[5] = nams[i].5
                cs_name[6] = 0
                let tmp :String = String( cString: &cs_name )
                
                let const_name = tmp.trimmingCharacters(in: .whitespaces)
                Constants[ const_name ] = vals[i]
                //print( "\(const_name)\t\(vals[i])\n" )
            }
            print( Constants )
        }
        else {
            RetCode = aps_error.APS_JPL_INIT
        }
         
        return RetCode
    }
    
    func GetConst( const :String )->Double {
        return Constants[ const ]!
    }
    
    func GetAU()->Double {
        return GetConst(const: "AU")
    }
    
    func GetPosVelEph( JD : Double, Target : PlanetType, Center :PlanetType, Pos : inout Vector, Vel : inout Vector)->aps_error {
        var RetCode = aps_error.APS_JPL_NO_ERROR
        var jpl_r :[Double] = [Double]( repeating: 0.0, count: 6)
        //let calc_vel: Int32 = 1
        let iRet = jpl_pleph(ephem, JD, Int32(Target.rawValue), Int32(Center.rawValue), &jpl_r[0], 1  )
        if( iRet == 0 ) {
            Pos = Vector( arrayLiteral: jpl_r[0] , jpl_r[1] , jpl_r[2] )
            Vel = Vector( arrayLiteral: jpl_r[3] , jpl_r[4] , jpl_r[5] )
        } else {
            RetCode = aps_error.APS_JPL_INIT
        }
        
        return RetCode
    }

    func GetPosEph( JD : Double, Target : PlanetType, Center :PlanetType)->Vector {
        
        var jpl_r :[Double] = [Double]( repeating: 0.0, count: 6)
        //let calc_vel: Int32 = 1
        jpl_pleph(ephem, JD, Int32(Target.rawValue), Int32(Center.rawValue), &jpl_r[0], 0 )
        let Pos = Vector( arrayLiteral: jpl_r[0] , jpl_r[1] , jpl_r[2] )
        
        return Pos
    }
    
    func SunEquPos( JD : Double)->Vector {
        let Pos = GetPosEph( JD: JD, Target: PlanetType.Earth, Center: PlanetType.Sun )
        
        return Pos
    }
    
    func EarthBaryEquPos( JD :Double ) -> Vector {
        let Pos = GetPosEph( JD: JD, Target: PlanetType.Earth, Center: PlanetType.Barycenter )
        
        return Pos

    }
    
    func MoonEquPos( JD :Double ) -> Vector {
        let Pos = GetPosEph( JD: JD, Target: PlanetType.Moon, Center: PlanetType.Earth )
        
        return Pos
    }
    
    func DEVersion() -> String {
        let denum = GetConst(const: "DENUM")
        return String( denum )
    }
}
