//
//  ThemeDragView.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/9/1.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class ThemeDragView: NSView {
    
    var type: NSPasteboard.PasteboardType?
    
    required init?(coder decoder: NSCoder) {
        
        if #available(OSX 10.13, *) {
            type = .fileURL
            
        } else {
            // Fallback on earlier versions
            type = .fileContents
            
        }
        
        super.init(coder: decoder)
        
        registerForDraggedTypes([type!])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        NSColor.blue.setFill()
        
        NSBezierPath.init(rect: dirtyRect).fill()
        
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("draggingEntered")
        let pb = sender.draggingPasteboard
        let data = pb.string(forType: type!)

        guard var ext = URL.init(string: data!)?.pathExtension else {
            return .init()
        }
        
        ext = ext.lowercased()
        
        if (ext == "png" || ext == "jpg") {
            return .copy
        }
        
        return .init()
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("draggingEnded")
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("draggingExited")
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return false
    }
    
    override func cursorUpdate(with event: NSEvent) {
        print("cursorUpdate")
        NSCursor.dragCopy.set()
    }
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    

}
