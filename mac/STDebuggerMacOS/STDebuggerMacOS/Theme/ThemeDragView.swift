//
//  ThemeDragView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/9/1.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class ThemeDragView: NSView {

    

    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([.fileURL])
        } else {
            // Fallback on earlier versions
            registerForDraggedTypes([.fileContents])
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        NSColor.red.setFill()
        
        NSBezierPath.init(rect: dirtyRect).fill()
        
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("draggingEntered")
        return NSDragOperation.copy
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("draggingEnded")
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("draggingExited")
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
//    override func cursorUpdate(with event: NSEvent) {
//        print("cursorUpdate")
//        NSCursor.dragCopy.set()
//    }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
}
