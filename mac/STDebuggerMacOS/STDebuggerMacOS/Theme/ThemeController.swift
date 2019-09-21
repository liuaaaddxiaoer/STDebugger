//
//  ThemeController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/9/1.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class ThemeController: NSViewController {
    @IBOutlet weak var chooseBtn: NSButton!
    
    @IBOutlet weak var imageV: NSImageView!
    override func loadView() {
        view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 选择按钮样式
        chooseBtn.wantsLayer = true
        chooseBtn.layer?.backgroundColor = NSColor.cyan.cgColor
        chooseBtn.showsBorderOnlyWhileMouseInside = true
        chooseBtn.isBordered = false
        let attr = NSMutableAttributedString(string: "选择本地图片")
        attr.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.white, range: NSRange(location: 0, length: attr.length))
        chooseBtn.attributedTitle = attr
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    }
    
    @objc func handle() {
        print(1);
    }
    
    // 关闭
    @IBAction func closeClick(_ sender: Any) {
        
        view.window?.orderOut(sender)
        NSApp.stopModal()
    }
    
    @IBAction func chooseLocalImageClick(_ sender: Any) {
        
        let panel = NSOpenPanel()
        panel.directoryURL = NSURL.fileURL(withPath: "/Users/liuxiaoer/downloads")
        panel.allowedFileTypes = ["png"]
        panel.beginSheetModal(for: NSApp.keyWindow!) { (res) in
            if res == NSApplication.ModalResponse.OK {
                print(panel.url!)
                self.imageV.image = NSImage(byReferencing: panel.url!)
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        print(1)
        print(view.window!.isMainWindow)
    }
    
//    override func becomeFirstResponder() -> Bool {
//        return true
//    }
    override var acceptsFirstResponder: Bool {
        return false
    }
    
    deinit {
        print("ThemeController deinit")
    }
}
