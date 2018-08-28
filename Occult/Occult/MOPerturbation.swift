//
//  MOPerturbation.swift
//  MacOccult
//
//  Created by Michele Bigi on 01/05/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

let o = 16
let dim = 2 * o + 1

class MOPerturbation{
    
    private var m_T :Double
    private var m_cosM: Double
    private var m_sinM: Double
    private var m_C = [ Double ](repeating: 0.0, count: dim)
    private var m_S = [ Double ](repeating: 0.0, count: dim)
    private var m_c = [ Double ](repeating: 0.0, count: dim)
    private var m_s = [ Double ](repeating: 0.0, count: dim)
    private var m_dl = 0.0
    private var m_db = 0.0
    private var m_dr = 0.0
    private var m_u = 0.0
    private var m_v = 0.0
    
    init( T: Double, M: Double, I_min :Int, I_max : Int,
        m: Double, i_min: Int, i_max: Int, phi: Double ){
        
       
        m_dl = 0
        m_db = 0
        m_dr = 0
        m_T = T
        
        m_cosM = cos( M )
        m_sinM = sin( M )
        m_C[o] = cos( phi )
        m_S[o] = sin( phi )
        
        for i in 0...I_max {
            self.AddThe(c1: m_C[o+i], s1: m_S[o+i], c2: m_cosM, s2: m_sinM, c: &m_C[o+i+1], s: &m_S[o+i+1])
        }
        
        for i in stride(from: 0, to: I_min, by: -1) {
            self.AddThe(c1: m_C[o+i], s1: m_S[o+i], c2: m_cosM, s2: -m_sinM, c: &m_C[o+i-1], s: &m_S[o+i-1])
        }
        
        m_c[o] = 1.0
        m_c[o+1] = cos( m )
        m_c[o-1] = m_c[o+1]
        m_s[o] = 0.0
        m_s[o+1] = sin( m )
        m_s[o-1] = -m_s[o+1]
        if( i_max > 1 ) {
            for i in 1...i_max {//stride(from: 1, to: i_max, by: -1) {
                self.AddThe(c1: m_c[o+i], s1: m_s[o+i], c2: m_c[o+1], s2: m_c[o+1], c: &m_c[o+i+1], s: &m_s[o+i+1])
            }
        }
            for i in stride(from: -1, through: i_min, by: -1){
                self.AddThe(c1: m_c[o+i], s1: m_s[o+i], c2: m_c[o-1], s2: m_c[o-1], c: &m_c[o+i-1], s: &m_s[o+i-1])
            }
        
    }
    
    func Term( I: Int, i: Int, iT: Int, dlc:Double, dls: Double, drc: Double, drs: Double, dbc: Double, dbs: Double ) {
        if( iT == 0){
            AddThe(c1: m_C[o+I], s1: m_S[o+I], c2: m_c[o+i], s2: m_s[o+i], c: &m_u, s: &m_v)
        }
        else {
            m_u *= m_T
            m_v *= m_T
        }
        m_dl += ( dlc * m_u + dls * m_v )
        m_dr += ( drc * m_u + drs * m_v )
        m_db += ( dbc * m_u + dbs * m_v )
    }
    
    func dl()-> Double{
        return m_dl
    }
    
    func dr()-> Double{
        return m_dr
    }
    func db()-> Double{
        return m_db
    }
    
    func AddThe( c1: Double, s1: Double, c2: Double, s2: Double, c: inout Double, s: inout Double) {
        c = c1 * c2 - s1 * s2
        s = s1 * c2 + c1 * s2
    }
}
