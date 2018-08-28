//
//  ChebyshevCalc.swift
//  Occult
//
//  Created by Michele Bigi on 26/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
//
//  ChebyshevCoeff.swift
//  Occult
//
//  Created by Michele Bigi on 16/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

/***************************************************************************
 *
 *
 *
 *
 ***************************************************************************/

import Foundation
/***************************************************************************
 * ChebyshevCalc
 *
 * Implements the interface to calc the Chebyshev poly.
 * Parameter:
 *      Order: Order of Chebyshev poly
 *      Array of double <Double, Double> [x(i), y(i)]
 *
 * Return:
 *      Array of <Double> with chebyshev coeff
 ***************************************************************************/

class ChebyshevCalc {
    var order    :Int      = 0
    var Coeff    :[Double] = [Double]()
    var start    :Double = 0.0
    var end      :Double = 0.0
    var Couples  :Array<(Double, Double)> = Array<(Double, Double)>()
    
    var posInd : Int = 0
    
    init() {
    }
    
    init( aOrder :Int, aCouple :Array<(Double,Double)> ) {
        order = aOrder
        Couples = aCouple
        Coeff = [Double]( repeating: 0.0, count: order )
        start = Couples[0].0
        end   = Couples[Couples.count-1].0
        CalcChebyshev()
    }
    
    func CalcChebyshev() {
        Coeff = Calc(Order: order, ta: Couples[0].0, tb: Couples[Couples.count-1].0)
    }
    
    func getVal( val :Double )->Double {
        return Value(Order: order, t: val, ta: Couples[0].0, tb: Couples[Couples.count-1].0, coeff: Coeff )
    }
    
    func getChebyshev() -> [Double] {
        return Coeff
    }
    
    func interp( t :Double, i :Int, tab :Array<(Double, Double)> )->Double {
        var v : Double = 0.0
        if( i != 0 ) {
            let dx = tab[i].0 - tab[i-1].0
            let dy = tab[i].1 - tab[i-1].1
            let dt =        t - tab[i-1].0
            
            v = dt * dy / dx + tab[i-1].1
        }
        return v
    }
    
    func tableValue( t :Double, tab :Array<(Double,Double)>)->Double {
        for i in 0...tab.count-1 {
            if( tab[i].0 == t ) {
                return tab[i].1
            }
            
            if( i != 0 ){
                if( (tab[i-1].0 < t) && (tab[i].0 > t) ) {
                    return interp( t: t, i: i , tab: tab)
                }
            }
        }
        return 0
    }
    
    func GetValue( t: Double )->Double {
        return tableValue(t: t , tab: Couples )
        //return sin( t )
    }
    
    func Calc( Order :Int, ta :Double, tb :Double )->[Double] {
        var tau :Double = 0.0
        var t   :Double = 0.0
        var f   :Double = 0.0
        
        start           = ta
        end             = tb
        
        var T     :[Double] = [Double]( repeating: 0.0, count: Order+1 )
        var coeff :[Double] = [Double]( repeating: 0.0, count: Order+1 )
        
        for k in stride(from: Order, to: -1, by: -1 ) {
            tau = cos( ( 2 * Double(k) + 1 ) * Double.pi / ( 2 * Double(Order) + 2 ) )
            t = ( ( tb - ta ) / 2.0 ) * tau + ( ( tb + ta ) / 2.0 )
            f = GetValue( t: t )
            
            for j in 0...Order{
                switch( j ) {
                case 0:
                    T[ 0 ] = 1.0
                    break
                case 1:
                    T[ 1 ] = tau
                    break
                default:
                    T[ j ] = 2.0 * tau * T[ j - 1 ] - T[ j - 2 ]
                }
                
                coeff[j] += f * T[ j ]
            }
        }
        let fac = 2.0 / Double( Order + 1 )
        
        for j in 0...Order {
            coeff[j] *= fac
        }
        
        return coeff
    }
    
    func Value( Order :Int, t :Double, ta :Double, tb :Double, coeff :[Double])->Double{
        
        let tau = ( 2.0 * t - ta - tb ) / ( tb - ta )
        var f1 :Double = 0.0
        var f2 :Double = 0.0
        var old_f1:Double  = 0.0
        
        for i in stride(from: Order, to: 0, by: -1) {
            old_f1 = f1;
            f1 = 2.0 * tau * f1 - f2 + coeff[i]
            f2 = old_f1;
        }
        
        let val = tau * f1 - f2 + 0.5 * coeff[0]
        return val
    }
    
 }
