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

class JPLDE {
    var ephem : UnsafeMutableRawPointer!
    
    init() {
        //ephem = UnsafePointer<Int8>.
    }
        //std::map <const std::string,double> constants;
    func Init( FilePath: String )-> Int {
        
        return 0
    }
    
    func jpl_get_double( ephem:UnsafeMutableRawPointer, value :Int )->Double {
        let dPointer = ephem + value
        let dVal = dPointer.load(as: CDouble.self )
        return dVal
    }
    
    func jpl_get_long( ephem:UnsafeMutableRawPointer, value :Int )->Int32 {
        let dPointer = ephem + value
        let dVal = dPointer.load(as: Int32.self )
        return dVal
    }

    //    double GetConst( const std::string & ConstName ) const;
        
    //    double GetAU( void ) const;
        
    //    int GetPosVelEph( const double Mjd, const int Target, const int Center, APSVec3d & Pos, APSVec3d & Vel ) const;
        
    //    APSVec3d GetPosEph( const double Mjd, const int Target, const int Center ) const;
        
    //    APSVec3d SunEquPos( const double Mjd ) const;
        
    //    APSVec3d EarthBaryEquPos( const double Mjd ) const;
        
    //    APSVec3d MoonEquPos( const double Mjd ) const;
        
    //    const std::map <const std::string,double> & GetAllConstants( void ) const
    //    { return( constants ); }
        
    //    void Print( std::ostream & s ) const;
}
