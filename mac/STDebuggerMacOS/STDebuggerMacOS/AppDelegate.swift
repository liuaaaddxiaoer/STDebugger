//
//  AppDelegate.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/17.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var effectView:NSVisualEffectView = {
        let view = CustomView()
        
        view.blendingMode = NSVisualEffectView.BlendingMode.withinWindow
        view.alphaValue = 0.3
        view.material = NSVisualEffectView.Material.sidebar
        view.state = NSVisualEffectView.State.active
        view.autoresizingMask = [.width, .height]
        
        return view
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection10.bundle")?.load()
        
        
        let window = NSApplication.shared.windows[0]
        window.isOpaque = false
        window.backgroundColor = NSColor.red
        window.contentMinSize = NSSize(width: 1350, height: 820)
        window.hasShadow = true
        window.contentView?.addSubview(effectView)
        effectView.frame = window.contentView?.bounds ?? .zero
        
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = NSColor.red.cgColor
        window.isMovable = true
        window.isMovableByWindowBackground = true
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

