
//
//  WindowContentVc.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class WindowContentVc: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        Server.shared.inject()
        view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        
        let img = NSImage(named: "bg2.jpg")!
        //
        let sourceRef = CGImageSourceCreateWithData(img.tiffRepresentation! as CFData, nil)!
        view.layer?.opacity = 1
        view.layer?.allowsGroupOpacity = false
//        view.layer?.contents = CGImageSourceCreateImageAtIndex(sourceRef, 0, nil)
    }
    
}

