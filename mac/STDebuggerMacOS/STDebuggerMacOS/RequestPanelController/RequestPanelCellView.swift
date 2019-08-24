//
//  RequestPanelCellView.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/19.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class RequestPanelCellView: NSTableCellView {
    @IBOutlet weak var titleLabel: NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.alignment = NSTextAlignment.left
    }
}
