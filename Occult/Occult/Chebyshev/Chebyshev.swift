//
//  Chebyshev.swift
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

import Foundation

class Chebyshev {
    var order    : Int    = 0
    var start    : Double = 0.0
    var end      : Double = 0.0
    var coeff    : [Double] = [Double]()
    
   init() {
    }
    
    init( ord :Int, from :Double, to :Double, withcoeff :[Double] ) {
        order = ord
        start = from
        end   = to
        coeff = withcoeff
    }
    
    init( from :ChebyshevCalc ) {
        order = from.order
        start = from.start
        end   = from.end
        coeff = from.Coeff
    }
    
    func getval( val :Double )->Double {
        return Value(Order: order, t: val, ta: start, tb: end, coeff: coeff )
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
