//
//  UserDefaultsView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class UserDefaultsView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        let graident = NSGradient(colors: [.red,.cyan])
        
//        let path = NSBezierPath(rect: dirtyRect)
        
        graident?.draw(in: dirtyRect, angle: 20)
        
    }
    
}
