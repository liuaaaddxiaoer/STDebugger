//
//  HeadersHeaderView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class HeadersHeaderView: NSTableHeaderView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    override func layout() {
        super.layout()
        
    }
    
}
