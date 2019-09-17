//
//  CustomWindow.swift
//  STTranslate_Example
//
//  Created by 小2 on 2019/9/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa

class CustomWindow: NSWindow {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        
        print("hello world")
        
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
}
