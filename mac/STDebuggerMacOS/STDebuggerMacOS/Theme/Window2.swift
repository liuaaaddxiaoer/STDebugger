//
//  Window2.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/9/5.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class Window2: NSWindow {
    
    override func awakeFromNib() {
        self.minSize = NSSize(width: 100, height: 100)
        self.maxSize = NSSize(width: 500, height: 500)
        self.setContentSize(NSSize(width: 600, height: 600))
    }
    
    deinit {
        print("delloc ")
    }

}
