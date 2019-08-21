//
//  RequestPanelRowView.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/19.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class RequestPanelRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        if selectionHighlightStyle != .none{
            let path = NSBezierPath.init(rect: dirtyRect)
            NSColor(white: 1, alpha: 0.3).setFill()
            path.fill()
        }
    }
}
