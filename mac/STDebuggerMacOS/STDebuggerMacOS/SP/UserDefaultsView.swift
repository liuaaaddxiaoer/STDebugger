//
//  UserDefaultsView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class UserDefaultsView: NSView {
    
    
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        
//    }
    var area: NSTrackingArea?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awake")
        
      
    }
    
    override func updateTrackingAreas() {
        
        for area in self.trackingAreas {
            removeTrackingArea(area)
        }
        
        area = NSTrackingArea(rect: self.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited,.activeAlways], owner: self, userInfo: nil)
        addTrackingArea(area!)
    }
    

    
//    required init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func mouseEntered(with event: NSEvent) {
        print("mouseEntered")
    }
    
    override func mouseExited(with event: NSEvent) {
        print("mouseExited")
    }
        
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        let graident = NSGradient(colors: [.red,.cyan])
        
//        let path = NSBezierPath(rect: dirtyRect)
        
        graident?.draw(in: dirtyRect, angle: 20)
        
    }
    
//    override func mouseDown(with event: NSEvent) {
//        
//    }
//    
    
    @IBAction func click(_ sender: Any) {
        
        print(window ?? 1)
        window?.close()
        let windows = NSApp.windows[0]
        windows.makeKeyAndOrderFront(sender)
                
        
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }
    
}
