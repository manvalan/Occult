//
//  AppDelegate.swift
//  Occult
//
//  Created by Michele Bigi on 10/08/18.
//  Copyright © 2018 Michele Bigi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        var starter : AtStartForTest = AtStartForTest();
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

