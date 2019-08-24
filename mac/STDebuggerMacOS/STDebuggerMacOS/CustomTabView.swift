//
//  CustomTabView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/23.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class CustomTabView: NSTabView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
    
}
