//
//  InterpElements.swift
//  Occult
//
//  Created by Michele Bigi on 27/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class Elements {
    var Order  :Int    = 24             // Order of Chebyshev Daily poly
    var step   :Double = 1
    var data   :[Coeff] = [Coeff]() // Array of daily coeff
    
    var AsteroidName :String = ""
    
    init() {
    }
    
    init( name :String) {
        AsteroidName = name
    }
    
    /*
        Split the period in 1-day step and calc the Chebyshev
        poly for 1 day.
    */
    func calcDaily( epoc :Double, kep_daily_array :[KepElements] )-> Coeff {
        let daily = Coeff()
        daily.Calc(from: epoc, to: epoc + 1 , kep_array: kep_daily_array )
        
        return daily
    }
    
    func getIndexStart( epoc :Double, kep_array :[KepElements] )->Int{
        for i in 0...kep_array.count-1 {
            if( kep_array[i].jd0 >= epoc ) {
                return i
            }
        }
        return 0
    }
    
    func getIndexEnd( epoc :Double, kep_array :[KepElements] )->Int{
        for i in stride(from: kep_array.count-1 , to: 0, by: -1 ) {
            if( kep_array[i].jd0 <= epoc ) {
                return i
            }
        }
        return  kep_array.count-1
    }
    
    func calcPeriod( from :Double, to :Double, kep_array :[KepElements] )  {
        var epoc :Double = from
        
        let len  :Int    = Int( to - from )
        data = [Coeff]( repeating: Coeff(), count: len+1)
        for j in 0...len-1 {
            epoc = from + Double( j )
            let epc_start = getIndexStart(epoc: epoc, kep_array: kep_array)
            let epc_end   = getIndexEnd(epoc: epoc+1, kep_array: kep_array)
            let sub = kep_array[epc_start...epc_end]
            let kep_daily_array = Array( sub )
            data[j] = calcDaily(epoc: epoc, kep_daily_array: kep_daily_array )
        }
    }
    
    func findItemAtTime( t :Double )->Coeff {
        for i in 0...data.count-1 {
            //print( "\(data[i].start) to \(data[i].end)" )
            if( ( data[i].start < t) && (data[i].end > t) ) {
                //print( "Element found at: \(i)")
                return data[i]
            }
        }
        //print( " Element not found ")
        return data[0]
    }
    
    func val( t :Double ) -> KepElements {
        let item = findItemAtTime(t: t)
        return item.value(t: t )
    }
    
    func InitWithJPLHorizons( from :Double, to :Double ){
        let hor :JPLHorizon = JPLHorizon(BodyName: AsteroidName )
        let step = 24.0 / Double( Order )
        hor.KeplerianElements(Start: from, End: to, Step: step )
        hor.WaitResults()
        let horElem = hor.GetKeplerianElements()
        calcPeriod(from: from, to: to, kep_array: horElem )
    }
}
