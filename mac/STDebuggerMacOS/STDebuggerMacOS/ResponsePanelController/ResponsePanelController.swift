//
//  ResponsePanelController.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/19.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class ResponsePanelController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        
        // 点击请求
        if tabViewItem?.identifier as! String == "request" {
            NotificationCenter.default.post(name: NSNotification.Name(toggleRequestTabTypeNotification), object: ToggleRequestTabType.request)
            // 点击响应
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(toggleRequestTabTypeNotification), object: ToggleRequestTabType.response)
        }
    }
}
