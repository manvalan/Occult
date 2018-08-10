//
//  MOHorizon.swift
//  MacOccult
//
//  Created by Michele Bigi on 22/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Foundation

class MOHorizon {
    
    /*
   
    self.start_epoch    = None
    self.stop_epoch     = None
    self.step_size      = None
    self.discreteepochs = None
    self.url            = None
    self.data           = None
    */
    
    private var TargetName: String?
    private var notSmallbody :Bool?
    private var Cap :Bool?
    private var noFrag :Bool?
    private var Comet : Bool?
    private var Asteroid: Bool?
    
    init () {}
    init( aTargetName : String, aNotSmallBody: Bool, aCap: Bool, aNoFrag: Bool, aComet: Bool, aAsteroid: Bool) {
        TargetName = aTargetName
        notSmallbody = aNotSmallBody
        Cap = aCap
        noFrag = aNoFrag
        Comet = aComet
        Asteroid = aAsteroid
    }
    
    init ( asteroid : MOAsteroid ) {
        TargetName = asteroid.AsteroidName
        notSmallbody = false
        Cap = false
        noFrag = false
        Comet = false
        Asteroid = true
        
    }
    
    func getURL( Center : String) -> String {
        //var Query :String
        
        var Query = String( "http://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=1" )
            //"https://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=l" );
        if canOpenURL(string: Query) {
            print( Query + " valid url." )
        } else {
            print( Query + " invalid url.")
        }
        Query += "&TABLE_TYPE='ELEMENTS'"
        Query += "&CSV_FORMAT='YES'"
    
        //Query += "&CENTER='" + Center + "'"
            
        Query += "&OUT_UNITS='AU-D'"
            
        Query += "&REF_PLANE='ECLIPTIC'"
        Query += "REF_SYSTEM='J2000'"
        Query += "&TP_TYPE='ABSOLUTE'"
        Query += "&ELEM_LABELS='YES'"
        Query += "CSV_FORMAT='YES'"
        Query += "&OBJ_DATA='YES'"
       
        return Query
        
    }
    
    func dateElement( date : MOData ) -> String {
        var dateString = String( format: "\'%4.4i-%2.2i-%2.2i\'" , date.year, date.month, date.day )
        
        return dateString
    }
    
    func getElement(  StartEphem : MOData, EndEphem : MOData , StepTime : MOData) -> String {
        var Query = String( "http://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=1" )
        //"https://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=l" );
        if canOpenURL(string: Query) {
            print( Query + " valid url." )
        } else {
            print( Query + " invalid url.")
        }
        Query += "&TABLE_TYPE='ELEMENTS'"
        Query += "&CSV_FORMAT='YES'"
        
        //Query += "&CENTER='" + Center + "'"
        
        Query += "&OUT_UNITS='AU-D'"
        
        Query += "&REF_PLANE='ECLIPTIC'"
        Query += "REF_SYSTEM='J2000'"
        Query += "&TP_TYPE='ABSOLUTE'"
        Query += "&ELEM_LABELS='YES'"
        Query += "CSV_FORMAT='YES'"
        Query += "&OBJ_DATA='YES'"
        
        Query += "&COMMAND='" + TargetName! + "'"
        
        Query += "&START_TIME="
        Query += dateElement(date: StartEphem )
        Query += "&STOP_TIME="
        Query += dateElement(date: EndEphem )
        Query += "&STEP_SIZE='"
        Query += String( format: "%im'", StepTime.min + StepTime.hour * 60 )
        
        
        print(Query)
       
        return Query
    }
    
    func canOpenURL(string: String?) -> Bool {
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func parseURLResult( str: String ) ->String {
        
        print( str )
        let rangeStart = str.range( of: "$$SOE" )
        let rangeEnd   = str.range( of: "$$EOE")
        let dataRows   = String(str[rangeStart!.upperBound...rangeEnd!.lowerBound])
        
        //print(dataRows)
        return String( dataRows )
    }
    
    func parseQueryElements( jplQueryRes: String ) ->[MOAsteroidElement] {
        var Elements = [ MOAsteroidElement ]()
        let elemArray = jplQueryRes.components(separatedBy: "\n")
        
        for row in elemArray {
            if( ( row != "" ) && ( row != "$" ) ){
                //print( row )
                let AstElem = MOAsteroidElement( jplString: row )
                Elements.append( AstElem )
            }
        }
        return Elements
    }
    
    func ExecQuery( StartEphem : MOData, EndEphem : MOData , StepTime : MOData)-> [MOAsteroidElement] {
    
        var Elements = [ MOAsteroidElement ]()
        let urlString = getElement(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime)
        let url = URL( string: urlString )
        if (url != nil) {
            do {
                let contents = try String( contentsOf: url! )
                let dataRow = parseURLResult(str: contents )
                Elements = parseQueryElements( jplQueryRes: dataRow )
                //print( dataRow )
            } catch {
                print( "Contents could not be loaded" )
            }
        } else {
            print("BAD URL")
        }
        return Elements
    }
}
  
