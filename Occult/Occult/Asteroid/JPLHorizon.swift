//
//  JPLHorizon.swift
//  MacOccult
//
//  Created by Michele Bigi on 22/04/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

/**************************************************************************************
 Questa Classe contiene l'interfaccia con il JPL Horizons per ricavare:
 - Vettore di stato: X, Y, Z, VX, VY, VZ
 - Elementi Orbitali Kepleriani: [ a, e, i, Ω, ω, T ]
 
 
 
 **************************************************************************************/
import Foundation

enum ElementsType:String {
    case Elements = "ELEMENTS"
    case Vectors  = "VECTOR"
    case Observer = "OBSERVER"
}

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

enum URLResult {
    case response(Data, URLResponse)
    case error(Error, Data?, URLResponse?)
}

extension URLSession {
    @discardableResult
    func get(_ url: URL, completionHandler: @escaping (URLResult) -> Void) -> URLSessionDataTask {
        let task = dataTask(with: url) { data, response, error in
            switch (data, response, error) {
            case let (data, response, error?):
                completionHandler(.error(error, data, response))
            case let (data?, response?, nil):
                completionHandler(.response(data, response))
            default:
                preconditionFailure("expected either Data and URLResponse, or Error")
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func get(_ left: URL, _ right: URL, completionHandler: @escaping (URLResult, URLResult) -> Void) -> (URLSessionDataTask, URLSessionDataTask) {
        precondition(delegateQueue.maxConcurrentOperationCount == 1,
                     "URLSession's delegateQueue must be configured with a maxConcurrentOperationCount of 1.")
        
        var results: (left: URLResult?, right: URLResult?) = (nil, nil)
        
        func continuation() {
            guard case let (left?, right?) = results else { return }
            completionHandler(left, right)
        }
        
        let left = get(left) { result in
            results.left = result
            continuation()
        }
        
        let right = get(right) { result in
            results.right = result
            continuation()
        }
        
        return (left, right)
    }
}

extension URLResult {
    var string: String? {
        guard case let .response(data, _) = self,
            let string = String(data: data, encoding: .utf8)
            else { return nil }
        return string
    }
}

class JPLHorizon {
    private var TargetName = ""
    private var notSmallbody :Bool?
    private var Cap :Bool?
    private var noFrag :Bool?
    private var Comet : Bool?
    private var Asteroid: Bool?
    
    private var AstPos  : [AsteroidXYZPosition] = [AsteroidXYZPosition]()
    private var AstElm  : [AsteroidElement]     = [AsteroidElement]()
    private var ElemTyp : ElementsType          = ElementsType.Observer
    private var bPos    : Bool = false
    private var bElem   : Bool = false
    
    init () {}
    
    init( aTargetName : String, aNotSmallBody: Bool, aCap: Bool, aNoFrag: Bool, aComet: Bool, aAsteroid: Bool) {
        TargetName = aTargetName
        notSmallbody = aNotSmallBody
        Cap = aCap
        noFrag = aNoFrag
        Comet = aComet
        Asteroid = aAsteroid
    }
    
    init( BodyName :String ) {
        TargetName = BodyName
        notSmallbody = false
        Cap = false
        noFrag = false
        Comet = false
        Asteroid = true
    }
    
    func dateElement( date : MOData ) -> String {
        var dateString = String( format: "\'%4.4i-%2.2i-%2.2i\'" , date.year, date.month, date.day )
        
        return dateString
    }
    
    
    func parseURLResult( str: String ) ->String {
        let rangeStart = str.range( of: "$$SOE" )
        let rangeEnd   = str.range( of: "$$EOE")
        let dataRows   = String(str[rangeStart!.upperBound...rangeEnd!.lowerBound])
        
        return String( dataRows )
    }
    
    func parseQueryElements( jplQueryRes: String ) ->[AsteroidElement] {
        var Elements = [ AsteroidElement ]()
        let elemArray = jplQueryRes.components(separatedBy: "\n")
        
        for row in elemArray {
            if( ( row != "" ) && ( row != "$" ) ){
                //print( row )
                let AstElem = AsteroidElement( jplString: row )
                Elements.append( AstElem )
            }
        }
        return Elements
    }
    
    
    let baseBatch = "https://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=1&"
    
    func buildHorizonQuery( StartEphem : MOData, EndEphem : MOData , StepTime : MOData, type : ElementsType )-> String {
        var query = ""
        
        query += "COMMAND=%27" + TargetName + "%27"
        query += "&MAKE_EPHEM= %27YES%27"
        query += "&TABLE_TYPE=%27" + type.rawValue + "%27"
        query += "OUT_UNITS  = 'AU-D'"
        query += "REF_PLANE  = 'ECLIPTIC'"
        query += "REF_SYSTEM = 'J2000'"
        
        query += "CENTER = '500@0'"
        if( ElemTyp == ElementsType.Vectors) {
            query += "VECT_TABLE = '2'"
           query += "VECT_CORR  = 'NONE'"
        } else if ( ElemTyp == ElementsType.Elements ) {
            
        }
        query += "&START_TIME=" + dateElement(date: StartEphem )
        query += "&STOP_TIME=" + dateElement(date: EndEphem )
        query += "&STEP_SIZE=" + String( format: "'%im'", StepTime.min + StepTime.hour * 60 )
        query += "&CSV_FORMAT=%27YES%27"
        return query
    }
    
    func batchProcess( a: String )->String {
        var b = a.trimmingCharacters(in: .whitespacesAndNewlines)
        var c = b.replacingOccurrences(of: "?", with: "%3F")
        //var d = c.replacingOccurrences(of: "&", with: "%26")
        var e = c.replacingOccurrences(of: ";", with: "%3b")
        var f = e.replacingOccurrences(of: "\n", with: "&")
        var g = f.replacingOccurrences(of: " ", with: "%20")
        return g
    }
    
    
    func ParsingPosition( line : String ) -> AsteroidXYZPosition {
        var pos: AsteroidXYZPosition = AsteroidXYZPosition()
       
        var val = line.characters.split(separator: ",").map(String.init)
        var c = val.count
        
        pos.t = atof( val[0] )
        pos.pos[0] = atof( val[2] )
        pos.pos[1] = atof( val[3] )
        pos.pos[2] = atof( val[4] )
        pos.vel[0] = atof( val[5] )
        pos.vel[1] = atof( val[6] )
        pos.vel[2] = atof( val[7] )
        return pos;
    }
    
    private func JPLHorizonsBatchRequest( StartEphem : MOData, EndEphem : MOData , StepTime : MOData, type :ElementsType ) {
        bPos = false
        ElemTyp = type
        
        let bQuery = buildHorizonQuery(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime, type: type )
        let urlPath : String = baseBatch + batchProcess(a: bQuery)
        
        let url: URL = URL(string: urlPath)!
    
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlRequest = URLRequest(url: url)
    
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
        }
        session.get(url, completionHandler: dataHandler )
        
        task.resume()
        
        return
    }
    
    func KeplerianElements(  StartEphem : MOData, EndEphem : MOData , StepTime : MOData) {
        JPLHorizonsBatchRequest(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime, type: ElementsType.Elements)
        
        return
    }
    
    func KeplerianElements(  Start :Double, End : Double , Step : Double) {
        let StartEphem = MOData(jd: Start )
        let EndEphem   = MOData(jd: End )
        let StepTime   = MOData(hh: Int(Step), mn: 0)
        
        print( StartEphem.toString() )
        print( EndEphem.toString()   )
        JPLHorizonsBatchRequest(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime, type: ElementsType.Elements)
        
        return
    }

    func PositionsVector(  Start :Double, End : Double , Step : Double) {
        let StartEphem = MOData(jd: Start )
        let EndEphem   = MOData(jd: End )
        let StepTime   = MOData(hh: Int(Step), mn: 0)
        JPLHorizonsBatchRequest(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime, type: ElementsType.Vectors)
       
        return
    }
    
    func PositionsVector(  StartEphem : MOData, EndEphem : MOData , StepTime : MOData) {
        JPLHorizonsBatchRequest(StartEphem: StartEphem, EndEphem: EndEphem, StepTime: StepTime, type: ElementsType.Vectors)
        
        return
    }
    
    func dataHandler( res :URLResult ) {
        if( ElemTyp == ElementsType.Vectors ) {
            VectorDecode(data: res.string! )
        } else if( ElemTyp == ElementsType.Elements ) {
            ElementsDecode(data: res.string! )
        }
    }
    
    func dataDecode( data :String )->[String] {
        let rangeStart = data.range( of: "$$SOE" )
        let rangeEnd   = data.range( of: "$$EOE")
        let dataRows   = String(data[rangeStart!.upperBound...rangeEnd!.lowerBound])
        var lines = dataRows.lines
        //lines.popLast()
        lines.remove(at: 0)
        lines.remove(at: lines.count - 1)
        return lines
    }
    
    func ElementsDecode( data: String )  {
        var lines = dataDecode(data: data )
        let astel :AsteroidElement = AsteroidElement()
        AstElm = [ AsteroidElement ](repeating: astel, count: lines.count)
        
        for i in 0 ... lines.count-1 {
            AstElm[i] = AsteroidElement( jplString: lines[i]  )
        }
        bElem = true
        return
    }
    
    func VectorDecode( data :String ) {
        var lines = dataDecode(data: data )
        let astin :AsteroidXYZPosition = AsteroidXYZPosition()
        var aPos = [AsteroidXYZPosition]( repeating: astin, count: lines.count )
        
        for i in 0 ... lines.count-1 {
            aPos[i] = ParsingPosition( line: lines[i] )
        }
        AstPos = aPos
        bPos = true
        return
    }
    
    func GetPosState() -> Bool {
        return bPos
    }
    
    private func state() -> Bool {
        return ((bPos) || (bElem)) ? true : false
    }
    
    func GetPosVec() -> [AsteroidXYZPosition ] {
        //print( "\(AstPos[0].t)\t\(AstPos[0].pos[0])")
        return AstPos
    }
    
    func GetElements() -> [AsteroidElement ] {
        if( bElem == true) {
            return AstElm
        } else {
            return [AsteroidElement]()
        }
    }
    
    func WaitResults() {
        while ( state() == false ) {
        }
    }
}
  
