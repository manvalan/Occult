//
//  Coeff.swift
//  Occult
//
//  Created by Michele Bigi on 27/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class Coeff{
    var a_coeff :[Double] = [Double]()
    var e_coeff :[Double] = [Double]()
    var i_coeff :[Double] = [Double]()
    var Ω_coeff :[Double] = [Double]()
    var ω_coeff :[Double] = [Double]()
    var m_coeff :[Double] = [Double]()
    
    var start :Double = 0.0
    var end   :Double = 0.0
    var order :Int    = 24
    
    init() {
    }
    
    func Calc( from :Double, to: Double, kep_array :[KepElements]) {
        
        let kep_len    = kep_array.count - 1
        var a_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        var e_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        var i_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        var m_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        var Ω_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        var ω_table    = Array<(Double,Double)>( repeating: (0.0,0.0) , count: kep_len )
        //var epoc_table = [Double]( repeating: 0.0 , count: kep_len )
        
        for i in 0...order-1 {
            //epoc_table[i] = kep_array[i].jd0
            e_table[i] = (kep_array[i].jd0, kep_array[i].e )
            i_table[i] = (kep_array[i].jd0, kep_array[i].i )
            m_table[i] = (kep_array[i].jd0, kep_array[i].m )
            a_table[i] = (kep_array[i].jd0, kep_array[i].a )
            Ω_table[i] = (kep_array[i].jd0, kep_array[i].Ω )
            ω_table[i] = (kep_array[i].jd0, kep_array[i].ω )
        }
        start   = from
        end     = to
        a_coeff = ChebyshevCalc(aOrder: order, aCouple: a_table ).Coeff
        e_coeff = ChebyshevCalc(aOrder: order, aCouple: e_table ).Coeff
        i_coeff = ChebyshevCalc(aOrder: order, aCouple: i_table ).Coeff
        m_coeff = ChebyshevCalc(aOrder: order, aCouple: m_table ).Coeff
        Ω_coeff = ChebyshevCalc(aOrder: order, aCouple: Ω_table ).Coeff
        ω_coeff = ChebyshevCalc(aOrder: order, aCouple: ω_table ).Coeff
        
        //print( "Ω: \(Ω_coeff.count )")
    }
    
    func value( t: Double )->KepElements {
        let element :KepElements = KepElements()
        let a_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: a_coeff )
        let e_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: e_coeff )
        let i_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: i_coeff )
        let m_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: m_coeff )
        let Ω_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: Ω_coeff )
        let ω_calc = Chebyshev(ord: order, from: start, to: end, withcoeff: ω_coeff )
        if( ( t >= start ) && ( t <= end) ) {
            element.a = a_calc.getval(val: t )
            element.e = e_calc.getval(val: t )
            element.i = i_calc.getval(val: t )
            element.m = m_calc.getval(val: t )
            element.Ω = Ω_calc.getval(val: t )
            element.ω = ω_calc.getval(val: t )
        }
        return element
    }
}
