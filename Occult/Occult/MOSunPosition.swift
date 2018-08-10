//
//  MOSunPosition.swift
//  MacOccult
//
//  Created by Michele Bigi on 01/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation



class MOSunPosition : AstroBase {
    private var M2 = 0.0
    private var M3 = 0.0
    private var M4 = 0.0
    private var M5 = 0.0
    private var M6 = 0.0
    private var D  = 0.0
    private var A  = 0.0
    private var U  = 0.0
    
    func SunPosition( JD: Double )-> Vector {
        var SunPosition = Vector( arrayLiteral: 0.0, 0.0, 0.0 )
        var dl = 0.0
        var dr = 0.0
        var db = 0.0
        
        let Ts = T(jd: JD)

        M2 = pi2 * frac(x: 0.1387306 + 162.5485917 * Ts )
        M3 = pi2 * frac(x: 0.9931266 +  99.9973604 * Ts )
        M4 = pi2 * frac(x: 0.0543250 +  53.1666028 * Ts )
        M5 = pi2 * frac(x: 0.0551750 +   8.4293972 * Ts )
        M6 = pi2 * frac(x: 0.8816500 +   3.3938722 * Ts )
        D  = pi2 * frac(x: 0.8274 + 1236.8531 * Ts )
        A  = pi2 * frac(x: 0.3749 + 1325.5524 * Ts )
        U  = pi2 * frac(x: 0.2591 + 1342.2278 * Ts )
        
        VenusPerturbation(T: Ts, dl: &dl, dr: &dr, db: &db)
        MarsPerturbation(T: Ts, dl: &dl, dr: &dr, db: &db)
        JupiterPerturbation(T: Ts, dl: &dl, dr: &dr, db: &db)
        SaturnPerturbation(T: Ts, dl: &dl, dr: &dr, db: &db)
        
        // Difference Earth-Moon Barycentre and centre of the Earth
        dl += (6.45 * sin(D) - 0.42 * sin(D-A) + 0.18 * sin(D+A) + 0.17 * sin(D-M3) - 0.06 * sin(D+M3) )
        dr += (30.76 * cos(D) - 3.06 * cos(D-A) + 0.85 * cos(D+A) - 0.58 * cos(D-M3) + 0.57 * cos(D+M3) )
        db += (0.576 * sin(U) )
        
        //Long periodic perturbation
        dl +=  6.70 * sin( pi2 * ( 0.6983 + 0.0561 * Ts ) ) + 1.87 * sin( pi2 * ( 0.5764 + 0.4174 * Ts ) ) + 0.27 * sin( pi2 * ( 0.4189 + 0.3306 * Ts ) ) + 0.20 * sin( pi2 * ( 0.3581 + 0.2814 * Ts ) )
        
        //Ecliptic Coordinates ([rad],[AU])
        var l = pi2 * frac(x: 0.7859453 + M3/pi2 + (( 6191.2 + 1.1 * Ts ) * Ts + dl )/1296.0e3)
        var r = 1.0001398 - 0.0000007 * Ts + dr * 1.0e-6
        var b = db / Arcs
        
        SunPosition[0] = l
        SunPosition[1] = b
        SunPosition[2] = r
        
        return SunPosition
    }
    
    //( T: Double, M: Double, I_min :Int, I_max : Int,
    //m: Double, i_min: Int, i_max: Int, phi: Double ){
    
    func VenusPerturbation( T: Double, dl: inout Double, dr: inout Double, db: inout Double ){
        var Venu = MOPerturbation( T:T , M:M3, I_min: 0, I_max: 7, m: M2, i_min: -6, i_max: 0, phi: 0.0 )
        
        Venu.Term(I: 1, i: 0, iT: 0, dlc: -0.22, dls: 6892.76, drc: -16707.37, drs: -0.54, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 1, i: 0, iT: 1, dlc: -0.06, dls:  -17.35, drc:    42.04, drs: -0.15, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 1, i: 0, iT: 2, dlc: -0.01, dls:   -0.05, drc:     0.13, drs: -0.02, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 2, i: 0, iT: 0, dlc:  0.00, dls:   71.98, drc:  -139.57, drs:  0.0, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 2, i: 0, iT: 1, dlc: 0.00, dls:   -0.36, drc:     0.70, drs:  0.0, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 3, i: 0, iT: 0, dlc: 0.00, dls:    1.04, drc:    -1.75, drs:  0.0, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 0, i: -1, iT: 0, dlc: 0.03, dls:   -0.07, drc:   -0.16, drs: -0.07, dbc: 0.02, dbs: -0.02)
        Venu.Term(I: 1, i: -1, iT: 0, dlc: 2.35, dls:   -4.23, drc:   -4.75, drs: -2.64, dbc: 0.0, dbs: 0.0)
        Venu.Term(I: 1, i: -2, iT: 0, dlc:-0.10, dls:    0.06, drc:   0.12, drs:  0.20, dbc: 0.02, dbs: 0.0)
        Venu.Term(I: 2, i: -1, iT: 0, dlc:-0.06, dls:   -0.03, drc:     0.20, drs: -0.01, dbc: 0.01, dbs: -0.09)
        Venu.Term(I: 2, i: -2, iT: 0, dlc:-4.70, dls:    2.90, drc:     8.28, drs: 13.42, dbc: 0.01, dbs: -0.01)
        Venu.Term(I: 3, i: -2, iT: 0, dlc: 1.80, dls:   -1.74, drc:    -1.44, drs:  1.57, dbc: 0.04, dbs: -0.06)
        Venu.Term(I: 3, i: -3, iT: 0, dlc:-0.67, dls:    0.03, drc:     0.11, drs:  2.43, dbc: 0.01, dbs: 0.0)
        Venu.Term(I: 4, i: -2, iT: 0, dlc: 0.03, dls:   -0.03, drc:     0.10, drs:  0.09, dbc: 0.01, dbs: -0.01 )
        Venu.Term(I: 4, i: -3, iT: 0, dlc: 1.51, dls:   -0.40, drc:    -0.88, drs: -3.36, dbc: 0.18, dbs: -0.10)
        Venu.Term(I: 4, i: -4, iT: 0, dlc: -0.19, dls:  -0.09, drc:    -0.38, drs: 0.77, dbc: 0.00, dbs: 0.00)
        Venu.Term(I: 5, i: -3, iT: 0, dlc: 0.76, dls:   -0.68, drc:     0.30, drs: 0.37, dbc: 0.01, dbs: 0.00)
        Venu.Term(I: 5, i: -4, iT: 0, dlc:-0.14, dls:   -0.04, drc:    -0.11, drs: 0.43, dbc: -0.03, dbs: 0.00)
        Venu.Term(I: 5, i: -5, iT: 0, dlc:-0.05, dls:   -0.07, drc:    -0.31, drs: 0.21, dbc: 0.00, dbs: 0.00)
        Venu.Term(I: 6, i: -4, iT: 0, dlc: 0.15, dls:   -0.04, drc:    -0.06, drs: -0.21, dbc: 0.01, dbs: 0.00)
        Venu.Term(I: 6, i: -5, iT: 0, dlc:-0.03, dls:   -0.03, drc:    -0.09, drs:  0.09, dbc: -0.01, dbs: 0.00)
        Venu.Term(I: 6, i: -6, iT: 0, dlc: 0.00, dls:   -0.04, drc:    -0.18, drs: 0.02, dbc: 0.00, dbs: 0.00)
        Venu.Term(I: 7, i: -5, iT: 0, dlc:-0.12, dls:   -0.03, drc:    -0.08, drs: 0.31, dbc: -0.02, dbs: -0.01)
        
        dl = Venu.dl()
        dr = Venu.dr()
        db = Venu.db()
    }
    
    func MarsPerturbation( T: Double, dl: inout Double, dr: inout Double, db: inout Double ){
        var Mars = MOPerturbation( T:T , M:M3, I_min: 1, I_max: 5, m: M4, i_min: -8, i_max: -1, phi: 0.0 )
        
        Mars.Term(I: 1, i: -1, iT: 0, dlc: -0.22, dls: 0.17, drc: -0.21, drs: -0.27, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 1, i: -2, iT: 0, dlc: -1.66, dls: 0.62, drc:  0.16, drs:  0.28, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 2, i: -2, iT: 0, dlc:  1.96, dls: 0.57, drc: -1.32, drs: 4.55, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 2, i: -3, iT: 0, dlc:  0.40, dls: 0.15, drc: -0.17, drs: 0.46, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 2, i: -4, iT: 0, dlc:  0.53, dls: 0.26, drc:  0.09, drs: -0.22, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 3, i: -3, iT: 0, dlc:  0.05, dls: 0.12, drc: -0.35, drs:  0.15, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 3, i: -4, iT: 0, dlc: -0.13, dls:-0.48, drc:  1.06, drs: -0.29, dbc: 0.01, dbs: 0.00)
        Mars.Term(I: 3, i: -5, iT: 0, dlc: -0.04, dls:-0.20, drc:  0.20, drs: -0.04, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 4, i: -4, iT: 0, dlc:  0.00, dls:-0.03, drc:  0.10, drs:  0.04, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 4, i: -5, iT: 0, dlc:  0.05, dls:-0.07, drc:  0.20, drs:  0.14, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 4, i: -6, iT: 0, dlc: -0.10, dls: 0.11, drc: -0.23, drs: -0.22, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 5, i: -7, iT: 0, dlc: -0.05, dls: 0.00, drc:  0.01, drs: -0.14, dbc: 0.00, dbs: 0.00)
        Mars.Term(I: 5, i: -8, iT: 0, dlc:  0.05, dls: 0.01, drc: -0.02, drs:  0.10, dbc: 0.00, dbs: 0.00)
       
        dl += Mars.dl()
        dr += Mars.dr()
        db += Mars.db()
    }
    
    func JupiterPerturbation( T: Double, dl: inout Double, dr: inout Double, db: inout Double ){
        var Jupi = MOPerturbation( T:T , M:M3, I_min: -1, I_max: 3, m: M5, i_min: -4, i_max: -1, phi: 0.0 )
        Jupi.Term(I: -1, i: -1, iT: 0, dlc:  0.01, dls:  0.07, drc:  0.18, drs: -0.02, dbc:  0.00, dbs: -0.02)
        Jupi.Term(I:  0, i: -1, iT: 0, dlc: -0.31, dls:  2.58, drc:  0.52, drs:  0.34, dbc:  0.02, dbs:  0.00)
        Jupi.Term(I:  1, i: -1, iT: 0, dlc: -7.21, dls: -0.06, drc:  0.13, drs: -16.27, dbc:  0.00, dbs: -0.02)
        Jupi.Term(I:  1, i: -2, iT: 0, dlc: -0.54, dls: -1.52, drc:  3.09, drs: -1.12, dbc:  0.01, dbs: -0.17)
        Jupi.Term(I:  1, i: -3, iT: 0, dlc: -0.03, dls: -0.21, drc:  0.38, drs: -0.06, dbc:  0.00, dbs: -0.02)
        Jupi.Term(I:  2, i: -1, iT: 0, dlc: -0.16, dls:  0.05, drc: -0.18, drs: -0.31, dbc:  0.01, dbs:  0.00)
        Jupi.Term(I:  2, i: -2, iT: 0, dlc:  0.14, dls: -2.73, drc:  9.23, drs:  0.48, dbc:  0.00, dbs:  0.00)
        Jupi.Term(I:  2, i: -3, iT: 0, dlc:  0.07, dls: -0.55, drc:  1.83, drs:  0.25, dbc:  0.01, dbs:  0.00)
        Jupi.Term(I:  2, i: -4, iT: 0, dlc:  0.02, dls: -0.08, drc:  0.25, drs:  0.06, dbc:  0.00, dbs:  0.00)
        Jupi.Term(I:  3, i: -2, iT: 0, dlc:  0.01, dls: -0.07, drc:  0.16, drs:  0.04, dbc:  0.00, dbs:  0.00)
        Jupi.Term(I:  3, i: -3, iT: 0, dlc: -0.16, dls: -0.03, drc:  0.08, drs: -0.64, dbc:  0.00, dbs:  0.00)
        Jupi.Term(I:  3, i: -4, iT: 0, dlc: -0.04, dls: -0.01, drc:  0.03, drs: -0.17, dbc:  0.00, dbs:  0.00)
        
        dl += Jupi.dl()
        dr += Jupi.dr()
        db += Jupi.db()
    }
    
    func SaturnPerturbation( T: Double, dl: inout Double, dr: inout Double, db: inout Double ){
        var Sat = MOPerturbation( T:T , M:M3, I_min: 0, I_max: 2, m: M6, i_min: -2, i_max: -1, phi: 0.0 )
        
        Sat.Term(I: 0, i: -1, iT: 0, dlc: 0.00, dls: 0.32, drc: 0.01, drs: 0.00, dbc: 0.00, dbs: 0.00)
        Sat.Term(I: -1, i: -1, iT: 0, dlc: -0.08, dls: -0.41, drc: 0.97, drs: -0.18, dbc: 0.00, dbs: 0.00)
        Sat.Term(I: 1, i: -2, iT: 0, dlc: 0.04, dls: 0.10, drc: -0.23, drs: 0.10, dbc: 0.00, dbs: 0.00)
        Sat.Term(I: 2, i: -2, iT: 0, dlc: 0.04, dls: 0.10, drc: -0.35, drs: 0.13, dbc: 0.00, dbs: 0.00)
        
        dl += Sat.dl()
        dr += Sat.dr()
        db += Sat.db()
    }
    
}
