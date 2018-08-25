//
//  Spherical.swift
//  Occult
//
//  Created by Michele Bigi on 23/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

//
//  Spherical.swift
//  Harmonikr
//
//  Created by David Gavilan on 2/8/15.
//  Copyright (c) 2015 David Gavilan. All rights reserved.
//
import Foundation

func Length( a :Vector )->Double {
    return sqrt( a[0] * a[0] + a[1] * a[1] + a[2] * a[2] )
}

class Spherical {
    var r       : Double = 1     ///< Radial distance
    var θ       : Double = 0     ///< Inclination (theta) {0,π}
    var φ       : Double = 0     ///< Azimuth (phi) {0,2π}
    
    // Maybe I'll hate myself later for using symbols 😂
    // (they aren't difficult to type with Japanese input, type シータ and ファイ)
    init (r: Double, θ: Double, φ: Double) {
        self.r = r
        self.θ = θ
        self.φ = φ
    }
    
    /// Converts from Cartesian to Spherical coordinates
    init (v: Vector ) {
        r = Length(a: v)
        θ = acos(v[1] / r)
        // convert -pi..pi to 0..2pi
        φ = atan2(v[0], v[2])
        φ = φ < 0 ? 2.0 * Double.pi + φ : φ
    }
    
    init () {
    }
    
    func ToVector() -> Vector {
        let a = Vector( [ r * sin(θ) * sin(φ),  r * cos(θ), r * sin(θ) * cos(φ) ] )
        return a
    }
}
