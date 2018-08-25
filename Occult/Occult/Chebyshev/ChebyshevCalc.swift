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
    var order    : Int      = 0
    var Coeff    : [Double] = [Double]()
    var Couples  : Array<(Double, Double)> = Array<(Double, Double)>()
    
    var posInd : Int = 0
    
    init() {
    }
    
    init( aOrder :Int, aCouple :Array<(Double,Double)> ) {
        order = aOrder
        Couples = aCouple
        Coeff = [Double]( repeating: 0.0, count: order+1 )
        CalcChebyshev()
    }
    
    func GetX( index :Int ) -> Double {
        return Couples[index].0
    }
    
    func GetY( index :Int )->Double {
        return Couples[index].1
    }
    
    func CalcChebyshev( ) {
        var tau  :Double = 0.0
        var T    :[Double] = [Double]( repeating: 0.0, count: order+1)
        let ta = GetX( index: 0 )
        let tb = GetX( index: order )
   
        for i in stride( from: 0, to: order, by: 1 ) {
            Coeff[i] = 0.0
        }
        
        for k in stride(from: order, to: -1, by: -1) {
            let x  = GetX( index: order - k )
            let y  = GetY( index: order - k )
            
            
            tau = ( 2 * x - tb - ta) / ( tb - ta )
            for j in 0...order {
                switch j {
                case 0:
                    T[ 0 ] = 1.0
                    break
                case 1:
                    T[ 1 ] = tau
                    break
                    
                default:
                    T[ j ] = 2.0 * tau * T[ j - 1 ] - T[ j - 2 ]
                    break
                }
                Coeff[ j ] += y * T[ j ]
            }
        }
        
        let fac :Double = 2.0 / Double( order + 1 )
        
        for j in 0...order {
            Coeff[ j ] *= fac
        }
    }
    
    func getChebyshev() -> [Double] {
        return Coeff
    }
 }
