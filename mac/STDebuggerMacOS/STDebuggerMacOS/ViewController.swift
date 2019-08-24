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
    
 
    
    
//    override func loadView() {
//        self.view = UserDefaultsView()
//    }
    
    override func viewWillAppear() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Server.shared.inject()
        
        setupUI()
    }
    
    fileprivate func setupWindowStyle() {
        let window = NSApplication.shared.windows[0]
        window.titlebarAppearsTransparent = true
        window.minSize = NSSize.init(width: 800, height: 600)
        window.titleVisibility = .hidden
    }
    
    fileprivate func setupUI() {

        setupWindowStyle()
        setupBgImage()
        
    }

    override func touchesBegan(with event: NSEvent) {
        
    }
    
    fileprivate func setupBgImage() {
        
       
    
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
    }
    
    override func mouseDown(with event: NSEvent) {
        
//        let s = Server.shared
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

