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
    
    private lazy var effectView:NSVisualEffectView = {
        let view = NSVisualEffectView()
        
        view.blendingMode = NSVisualEffectView.BlendingMode.withinWindow
        view.alphaValue = 0.5
        view.material = NSVisualEffectView.Material.popover
        view.state = NSVisualEffectView.State.active
    
        return view
    }()
    
    override func viewWillAppear() {
        let window = NSApplication.shared.windows[0]
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        
        
        effectView.frame = window.contentView?.bounds ?? NSRect(x: 0, y: 0, width: 0, height: 0)
        window.contentView?.addSubview(effectView, positioned: .below, relativeTo: nil)
        window.contentView?.wantsLayer = true
        window.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
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
        
        let img = NSImage(named: "bg.jpg")!
//
        let sourceRef = CGImageSourceCreateWithData(img.tiffRepresentation! as CFData, nil)!
        view.layer?.opacity = 1
        view.layer?.allowsGroupOpacity = false
//        view.layer?.contents = CGImageSourceCreateImageAtIndex(sourceRef, 0, nil)
    
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        effectView.frame = view.bounds
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let s = Server.shared
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

