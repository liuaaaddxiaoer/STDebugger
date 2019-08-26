//
//  HttpSplitController.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/20.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class HttpSplitController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        minimumThicknessForInlineSidebars = 100
    }
        
}
