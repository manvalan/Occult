//
//  ViewController.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDataSource, NSTableViewDelegate{
    
    var MPCOrbData :MPCOrb = MPCOrb()
    var jplDE      :JPLDE  = JPLDE()
    var curAst     :Asteroid = Asteroid()
    var jdTime     :[Double] = [Double]()
    var eq_pos     :[EquatorialCoordinate] = [EquatorialCoordinate]()
    
    @IBOutlet weak var UINameLaber: NSTextField!
    @IBOutlet weak var UIAsteroidName: NSTextField!
    @IBOutlet weak var UIAstNumber: NSTextField!
    @IBOutlet weak var UIDataStart: NSDatePicker!
    @IBOutlet weak var UIDataEnd: NSDatePicker!
    @IBOutlet weak var UICalc: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBAction func NumberOk(_ sender: Any) {
        print( sender)
        
        //let step  = UIDataStep.dateValue
        //print( step )
        let AsteroidNumber = UIAstNumber.stringValue
        for item in MPCOrbData.database {
            if( item.Number != nil ){
                if(( item.Number?.range(of: AsteroidNumber ) ) != nil) {
                    print( "trovato: \(item.Number) \(item.Name)")
                    UINameLaber.stringValue = item.Name!
                    break
                }
            }
        }
    }
    
    func asteroitTableData( ast :Asteroid, start :Double, end:Double, step :Double, jpl :JPLDE) {
        let lenght = 1 + Int( ( end - start ) / step )
        
        ast.KeplerianElements(from: start, to: end, step: 1 )
        
        let eq_foo = EquatorialCoordinate(rightAscension: HourAngle(), declination: DegreeAngle(), distance: 0.0 )
        
        jdTime = [Double]( repeating: 0.0, count: lenght )
        eq_pos = [EquatorialCoordinate](repeating: eq_foo, count: lenght)
        
        for i in 0...lenght-1 {
            jdTime[i] = start + Double( i ) * step
            eq_pos[i] = ast.EquatorialApparentPosition(jplDE: jpl, t: jdTime[i])
        }
        print( "JD Count: \(jdTime.count)")
    }
    
    func jdDate( a :Date )->Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: a)

        let st = MOData(aa: components.year! , mm: components.month!, dd: components.day!)
        return st.JulianDay()
    }
    
    @IBAction func UICalcButton(_ sender: Any) {
        // Calc Button Pressed
        print( "Hai premuto Calc")
        
        let start = UIDataStart.dateValue
        let end   = UIDataEnd.dateValue
        print( start )
        print( end )
        let AsteroidNumber = UIAstNumber.stringValue
        for item in MPCOrbData.database {
            if( item.Number != nil ){
                if(( item.Number?.range(of: AsteroidNumber ) ) != nil) {
                    print( "trovato: \(item.Number) \(item.Name)")
                    UINameLaber.stringValue = item.Name!
                    break
                }
            }
        }
        let data_start = UIDataStart.dateValue
        let data_end   = UIDataEnd.dateValue
        let start_jd   = jdDate(a: data_start)
        let end_jd     = jdDate(a: data_end  )
        curAst = Asteroid( name: AsteroidNumber )
        asteroitTableData(ast: curAst, start: start_jd, end: end_jd, step: 1, jpl: jplDE)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var ephemeris_file = Bundle.main.resourcePath! + "/unxp2000.405"
        jplDE.Init(FilePath: ephemeris_file )

        let urlPath = Bundle.main.url(forResource: "mpcorb_extended", withExtension: "json")
        
        MPCOrbData = MPCOrb()
        MPCOrbData.MPCOrbParseJSONFile(urlFile: urlPath!)
        print( "MPCOrbDB Letto")
        UIDataEnd.dateValue   = Date() + 1
        UIDataStart.dateValue = Date()
        
        self.tableView.dataSource = self as! NSTableViewDataSource
        self.tableView.delegate = self as? NSTableViewDelegate
        self.tableView.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return jdTime.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let item = String( jdTime[row] )
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = item
        return cell
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = String( jdTime[row] )
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = item
        return cell
    }
}

