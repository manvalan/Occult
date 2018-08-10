//
//  MOStar.swift
//  MacOccult
//
//  Created by Michele Bigi on 21/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation
class MOStar{
    var RA                  : Double
    var pmRA                : Double
    var DEC                 : Double
    var pmDEC               : Double
    var Parallax            : Double
    var Vrad                : Double
    var Epoch               : Double
    var Catalogue           : CUnsignedChar
    var StarNumber          : Int
    var SupNum              : CUnsignedChar
    var Mv                  : Double
    
    
    init( aRA :Double, apmRA :Double, aDEC: Double, apmDEC: Double, aParallax :Double, aVrad :Double, aEpoch : Double, aCatalogue: CUnsignedChar, aStarNumber : Int, aSupNum :CUnsignedChar, aMv : Double ) {
        RA = aRA
        pmRA = apmRA
        DEC = aDEC
        pmDEC = apmDEC
        Parallax = aParallax
        Vrad = aVrad
        Epoch = aEpoch
        Catalogue = aCatalogue
        StarNumber = aStarNumber
        SupNum = aSupNum
        Mv = aMv
    }
}

