//
//  CustomSplitView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/20.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class CustomSplitView: NSSplitView {
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeNotification()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        var leftColor = NSColor(red: 193/255.0, green: 101/255.0, blue: 221/255.0, alpha: 1.0)
        var rightColor = NSColor(red: 92/255.0, green: 39/255.0, blue: 254/255.0, alpha: 1.0)
        
        if index == 1 {
            leftColor = NSColor(red: 29/255.0, green: 229/255.0, blue: 226/255.0, alpha: 1.0)
            rightColor = NSColor(red: 181/255.0, green: 136/255.0, blue: 247/255.0, alpha: 1.0)
        }
        
        
        
        let graident = NSGradient(colors: [leftColor,rightColor])
    
//        graident?.draw(in: dirtyRect, angle: 100)
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
    
    override var dividerColor: NSColor {
        return NSColor.clear
    }
    
}

extension CustomSplitView {
    
    func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(toggleChildVc), name: NSNotification.Name(rawValue: menuNavToggleIndexNotification), object: nil)
    }
    
    @objc func toggleChildVc(notification: NSNotification) {
        let index: Int = notification.object as? Int ?? 0
        
        if self.index == index {return}
        
        self.index = index
        
        setNeedsDisplay(self.bounds)
    }
}
