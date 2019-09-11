//
//  AppDelegate.swift
//  STCarUnPack
//
//  Created by liuaaaddxiaoer on 09/10/2019.
//  Copyright (c) 2019 liuaaaddxiaoer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    NSApp.servicesProvider = STService()
    
    NSApp.keyWindow?.center()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

