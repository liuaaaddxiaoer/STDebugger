//
//  CustomSplitView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/20.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class CustomSplitView: NSSplitView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override var dividerColor: NSColor {
        return NSColor.clear
    }
    
}
