//
//  ViewController.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/17.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Server.shared.inject()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(with event: NSEvent) {
    
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

