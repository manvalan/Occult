//
//  ChebyshevCoeff.swift
//  Occult
//
//  Created by Michele Bigi on 16/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class ChebyshevCoeff {
    var order    : Int      = 0
    var cX       : [Double] = [Double]()
    var cY       : [Double] = [Double]()
    var cZ       : [Double] = [Double]()
    var startEpoc: Double = 0.0
    var endEpoc  : Double = 0.0
    
    private var astpos : [AsteroidXYZPosition] = [AsteroidXYZPosition]()
    var posInd : Int = 0
    
    init() {
    }
    
    init( n:Int, start :Double, end :Double, cx :[Double], cy :[Double], cz :[Double]) {
        order = n
        startEpoc = start
        endEpoc = end
        cX = cx
        cY = cy
        cZ = cz
    }
    
    init( n:Int, start :Double, end :Double ) {
        order = n
        startEpoc = start
        endEpoc = end
        cX = [Double]( repeating: 0.0, count: order+2)
        cY = [Double]( repeating: 0.0, count: order+2)
        cZ = [Double]( repeating: 0.0, count: order+2)
    }
    
    func chebyshev_interpolant( a :Double, b :Double, n :Int, c :[Double], m :Int, x :[Double]) -> [Double] {
        
        var cf   :[Double] = [Double]( repeating: 0.0, count: m )
        var di   :Double = 0.0
        var dip1 :Double = 0.0
        var dip2 :Double = 0.0
        var y    :Double = 0.0
        
        for j in 0 ... (m-1) {
            dip1 = 0.0
            di = 0.0
            y = ( 2.0 * x[j] - a  - b ) / ( b - a )
            for i in stride(from: n-1, through: 1, by: -1){
                //n-1 ... 1 {
                dip2 = dip1
                dip1 = di
                di = 2.0 * y * dip1 - dip2 + c[i]
            }
            cf[j] = y * di - dip1 + 0.5 * c[0]
        }
        return cf
    }
    
    func chebyshev_zeros2( n :Int ) -> [Double] {
        var x: [Double] = [Double]( repeating: 0.0, count: n)
        
        var angle :Double = 0.0
        
        for i in 0...n-1 {
            angle = Double( ( 2 * ( n - i ) - 1 ) ) * Double.pi / Double( 2 * n )
            x[i] = cos ( angle )
        }
        return x
    }
    
    func chebyshev_coefficients2( a :Double, b :Double, n :Int, f: ((Double)->Double) ) ->[Double] {
        var angle :Double = 0.0
        var c :[Double] = [Double]( repeating: 0.0, count: n )
        var fx:[Double] = [Double]( repeating: 0.0, count: n )
        var x :Double = 0.0
        for i in 0 ... n-1 {
            angle = Double( 2 * i + 1 ) * Double.pi / Double( 2 * n )
            x = cos( angle )
            x = 0.5 * (a + b ) + x * 0.5 * ( b - a )
            fx[i] = f( x )
        }
        for i in 0 ... n-1{
            c[i] = 0.0
            for j in 0 ... n-1 {
                angle = Double( i * ( 2 * j + 1 ) ) * Double.pi / Double( 2 * n )
                c[i] += fx[j] * cos( angle )
            }
        }
        for i in 0...n-1 {
            c[i] = 2.0 * c[i] / Double(n)
        }
        
        return c
    }
    
    func chebyshev_coefficients_new( order :Int, ta:Double, tb:Double )-> Int {
        let iRet :Int = 0
        var tau  :Double = 0.0
        var t    :Double = 0.0
        var pval :Vector = Vector()
        
        for j in 0...(cX.count-1) {
            cX[j] = 0.0
            cY[j] = 0.0
            cZ[j] = 0.0
        }
        var T :[Double] = [Double]( repeating: 0.0, count: order+1)
        
        for k in stride(from: order, to: -1, by: -1) {
            t = GetT(x: order - k )
            pval = GetValue(x: order - k )
            
            tau = ( 2 * t - tb - ta) / ( tb - ta )
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
                cX[ j ] += pval[ 0 ] * T[ j ]
                cY[ j ] += pval[ 1 ] * T[ j ]
                cZ[ j ] += pval[ 2 ] * T[ j ]
            }
        }
        
        let fac :Double = 2.0 / Double( order + 1 )
        
        for j in 0...order {
            cX[ j ] *= fac
            cY[ j ] *= fac
            cZ[ j ] *= fac
            
        }
        return iRet
    }
    
    func ChebyshevValue( t :Double ) -> Vector {
        var pos :Vector = [ 0.0 , 0.0 , 0.0 ]
        var f1 :Vector = [ 0.0 , 0.0 , 0.0 ]
        var f2 :Vector = [ 0.0 , 0.0 , 0.0 ]
        var cvec :Vector = [ 0.0 , 0.0 , 0.0 ]
        var old_f1 :Vector = [ 0.0 , 0.0 , 0.0 ]
        var tau :Double = 0.0
        let ta = startEpoc
        let tb = endEpoc
        
        if( (t >= ta) && (t <= tb) ) {
            tau = ( 2.0 * t - ta - tb ) / ( tb - ta )
            for i in stride(from: order, to: 0, by:-1) {
                old_f1 = f1
                //let cvet = Vector[ cX[ i ], cY[ i ], cZ[ i ] ]
                cvec[0] = cX[i]
                cvec[1] = cY[i]
                cvec[2] = cZ[i]
                f1 = 2.0 * tau .* f1 - f2 + cvec
                f2 = old_f1
            }
            cvec[0] = cX[0]
            cvec[1] = cY[0]
            cvec[2] = cZ[0]
            pos = tau .* f1 - f2 + 0.5 .* cvec
        }
        return pos
    }

    private func getCoordPos( t :Double, coeff :[Double] )-> Double {
        var dRet = 0.0
        var x :[Double] = [Double]( repeating: 0.0, count: 2)
        let a  :Double = -1.0
        let b  :Double = +1.0
        
        x = chebyshev_zeros2(n: 1 )
        x[0] = 0.5 * ( a + b ) + x[0] * 0.5 * ( b - a );
        let ps = chebyshev_interpolant(a: a, b: b, n: order, c: coeff, m: 1, x: x)
        dRet = ps[0]
        
        return dRet
    }
    
    func findIndexInPosX( j :Int ) -> Double {
        var tmp : Double = 0.0
        if( (posInd >= 0) && (posInd < astpos.count ) ) {
            tmp = astpos[posInd].pos[j]
            posInd += 1
        }
        return tmp
    }
    
    func GetT( x: Int ) -> Double {
        return astpos[x].t
    }
    
    func GetValue( x:Int )->Vector {
        return astpos[x].pos
    }

    func CalcChebyshevCoeff2( n: Int, start :Double, end :Double, Positions: [AsteroidXYZPosition] ) {
       
        order     = n
        startEpoc = start
        endEpoc   = end
     
        cX = [Double]( repeating: 0.0, count: order+2)
        cY = [Double]( repeating: 0.0, count: order+2)
        cZ = [Double]( repeating: 0.0, count: order+2)
        
        astpos = Positions
        
        startEpoc = Positions[0].t
        endEpoc   = Positions[Positions.count-1].t
        
        chebyshev_coefficients_new(order: order, ta: startEpoc, tb: endEpoc)
    }
    
    func GetPosNew( t : Double ) -> Vector {
        let pos = ChebyshevValue(t: t)
        return pos
    }
    
    func test(  ) {
        let n = 24
        let len = 24
        
        let jdStart = 2458349.5
        let jdEnd   = 2458350.5
        var Positions: [AsteroidXYZPosition] =  [AsteroidXYZPosition]()
        
        let startEpoc : MOData = MOData( jd: jdStart)
        let endEpoc   : MOData = MOData( jd: jdEnd  )
        var t         : Double = jdStart
        
        let dStepH = 0
        let dStepM = 60
        
        let stp : MOData = MOData( hh: dStepH, mn: dStepM )
        
        // JPL Horizons batch
        let hor = JPLHorizon(BodyName: "267")
        hor.PositionsVector(StartEphem: startEpoc, EndEphem: endEpoc, StepTime: stp )
        // waiting...
        hor.WaitResults()
        
        // get X,Y,Z pos
        let pos  :[AsteroidXYZPosition] = hor.GetPosVec()
        print( pos.count )
        
        let coeff = [ChebyshevCoeff]( repeating: ChebyshevCoeff(), count: len+1 )
        CalcChebyshevCoeff2(n: n, start: jdStart, end: jdEnd, Positions: pos )
        print( "Test Results")
        print( "x(t)               y(t) [real]            y(t)  [Calculated]")
        for j in 0...pos.count-1 {
            t = pos[j].t
            let to = ChebyshevValue(t: t )
            print( "\(j)   \(t)   \(pos[j].pos[0]) \(to[0])")
        }
        
    }
}
