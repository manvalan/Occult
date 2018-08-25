//
//  MPEliocentricPosition.swift
//  Occult
//
//  Created by Michele Bigi on 13/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

let Neqn = 6                // Number of differential eqns.

class MPPosition : AstroBase{
    let EQU2ECL   = 23.43929111
    let def_eps = 1.0e-10       // Relative accuracy
    let def_abserr = 0.0        // Absolute accuracy
    
    var Y :[Double] = [Double]( repeating: 0.0 , count: (Neqn + 1) )
    var integration_type: Int = 0
    var GM :[Double] = [Double]( repeating: 0.0, count: 11)
    var jplEph : UnsafeMutablePointer<JPLDE>? = nil
    var jdCurrent : Double = 0.0
    var eps :Double = 0.0
    var abs_err_val :Double = 0.0
    
    override init() {
        
    }
    
    func AstOrbIntegFunction( aJplEph :UnsafeMutablePointer<JPLDE> ) {
        jplEph = aJplEph
        let emrat : Double = (jplEph?.pointee.GetConst(const: "EMRAT"))!
        let gmb   : Double = (jplEph?.pointee.GetConst(const: "GMB"))!
        GM[0] = (jplEph?.pointee.GetConst(const: "GMS"))!
        GM[1] = (jplEph?.pointee.GetConst(const: "GM1"))!
        GM[2] = (jplEph?.pointee.GetConst(const: "GM2"))!
        GM[3] = gmb * emrat / ( 1.0 + emrat )
        GM[4] = (jplEph?.pointee.GetConst(const: "GM4"))!
        GM[5] = (jplEph?.pointee.GetConst(const: "GM5"))!
        GM[6] = (jplEph?.pointee.GetConst(const: "GM6"))!
        GM[7] = (jplEph?.pointee.GetConst(const: "GM7"))!
        GM[8] = (jplEph?.pointee.GetConst(const: "GM8"))!
        GM[9] = (jplEph?.pointee.GetConst(const: "GM9"))!
        GM[10] = gmb / ( 1.0 + emrat )
    }
    
    
    
    func AccelJPL( jd : Double , r : inout Vector ) -> Vector {
        //int      iPlanet;
        //APSVec3d a, r_p, d;
        //double   D;
        var iPlanet :Int = 0
        var a   :Vector = [0, 0, 0]
        var r_p :Vector = [0, 0, 0]
        var d   :Vector = [0, 0, 0]
        var D   :Double = 0.0
        
        // Solar attraction
        D = Norm(a: r )
        a = ( -GM[0] / ( D * D * D )) .* r
        
        // Planetary perturbation
        for iPlanet in 1 ... 10 {
            var rPlanet = (jplEph?.pointee.GetPosEph(JD: jd, Target: PlanetType(rawValue: iPlanet)!, Center: PlanetType.Sun ))!
            r_p = R_x(phi: EQU2ECL * Rad ) * rPlanet // From equatorial to ecliptic
            d = r - r_p
            
            // Direct acceleration
            D = Norm(a: d)
            a += ( -GM[ iPlanet ] / (D * D * D )) .* d
            
        }
        return a
    }
    
    func Run( X : Double, Y :[Double], dYdX : inout [Double] ) {
        var r :Vector = [ Y[1] , Y[2] , Y[3] ]
        var a :Vector = AccelJPL(jd: X, r: &r)
        
        dYdX[0] = 0.0
        dYdX[0] = Y[ 4 ]   // velocity
        dYdX[0] = Y[ 5 ]   // velocity
        dYdX[0] = Y[ 6 ]   // velocity
        dYdX[0] = a[0]     // acceleration
        dYdX[0] = a[1]     // acceleration
        dYdX[0] = a[2]     // acceleration
    }
    
    func AstOrbCalc( ObservationEpoch :Double , r: Vector, v: Vector, a_eps :Double, a_abserr: Double) {
        jdCurrent = ObservationEpoch
        eps = a_eps
        abs_err_val = a_abserr
        
        Y[0] = 0.0
        Y[1] = r[0]
        Y[2] = r[1]
        Y[3] = r[2]
        Y[4] = v[0]
        Y[5] = v[1]
        Y[6] = v[2]
    }
    
    func Integrate( end : Double )->Int {
        var relerr : Double = eps
        var abserr : Double = abs_err_val
        
       // repeat {
            
            
//        } while
        
        return 0
    }
    
//    int APSAstOrbCalc :: Integrate( const double End )
//    {
//    apsmathlib::DE_STATE State  = apsmathlib::DE_INIT;
//    double               relerr = eps;
//    double               abserr = abs_err_val;
//
//    do {
//    IntegMethod->Integ( Y, ETMjdCurrent, End, relerr, abserr, State );
//
//    if( State == apsmathlib::DE_INVALID_PARAMS ) {
//    pModule->ErrorMessage( APS_ASTORBCALC_PARAM );
//    return( 1 );
//    }
//    } while( State > apsmathlib::DE_DONE );
//
//    return( 0 );
//    }



    
    //var Y : [Double] =
    /***
    static const double   def_eps    = 1.0e-10; // Relative accuracy
    static const double   def_abserr = 0.0;     // Absolute accuracy
    
    APSModuleAstOrbCalc        * pModule;
    const APS_INTEGRATION_TYPE   IntegType;
    APSDE                      * IntegMethod;
    double                     * Y;
    double                       ETMjdCurrent;
    double                       eps;
    double                       abs_err_val;
    
     
     
    
     
     //======================= APSAstOrbCalc ==========================
     
     APSAstOrbCalc :: APSAstOrbCalc( APSSubModule * pAPSSubModule,
     const APS_INTEGRATION_TYPE aIntegType,
     const APSAstOrbIntegFunction * IntegFunction,
     const double ObservationEpoch,
     const APSVec3d & r,
     const APSVec3d & v,
     const double a_eps,
     const double a_abserr ) :
     IntegType( aIntegType ), ETMjdCurrent( ObservationEpoch ),
     eps( a_eps ), abs_err_val( a_abserr )
     {
     pModule      = new APSModuleAstOrbCalc( pAPSSubModule );
     
     if( aIntegType != APS_INTEGRATION_DE ) {
     pModule->ErrorMessage( APS_ASTORBCALC_TYPE );
     }
     
     IntegMethod  = new APSDE( IntegFunction );
     
     ETMjdCurrent = ObservationEpoch;
     
     Y = new double[ IntegFunction->GetNeqn() + 1 ];
     
     Y[ 0 ] = 0.0;  // Unused
     Y[ 1 ] = r[ apsmathlib::x ];
     Y[ 2 ] = r[ apsmathlib::y ];
     Y[ 3 ] = r[ apsmathlib::z ];
     Y[ 4 ] = v[ apsmathlib::x ];
     Y[ 5 ] = v[ apsmathlib::y ];
     Y[ 6 ] = v[ apsmathlib::z ];
     }
     
     APSAstOrbCalc :: ~APSAstOrbCalc( void )
     {
     delete [] Y;
     delete IntegMethod;
     delete pModule;
     }
     
     int APSAstOrbCalc :: Integrate( const double End )
     {
     apsmathlib::DE_STATE State  = apsmathlib::DE_INIT;
     double               relerr = eps;
     double               abserr = abs_err_val;
     
     do {
     IntegMethod->Integ( Y, ETMjdCurrent, End, relerr, abserr, State );
     
     if( State == apsmathlib::DE_INVALID_PARAMS ) {
     pModule->ErrorMessage( APS_ASTORBCALC_PARAM );
     return( 1 );
     }
     } while( State > apsmathlib::DE_DONE );
     
     return( 0 );
     }
     
     APSVec3d APSAstOrbCalc :: GetR( void ) const
     {
     return( APSVec3d( Y[ 1 ], Y[ 2 ], Y[ 3 ] ) );
     }
     
     APSVec3d APSAstOrbCalc :: GetV( void ) const
     {
     return( APSVec3d( Y[ 4 ], Y[ 5 ], Y[ 6 ] ) );
     }
     
     }}
 *////
}

