//
//  UserDefaultsController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class UserDefaultsController: NSViewController {

  
    @IBOutlet weak var tf: NSTextField!
    
    override func mouseDown(with event: NSEvent) {
        print("mouseDown")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.\
        view.wantsLayer = true
//        view.layer?.backgroundColor = NSColor.red.cgColor
        self.tf.stringValue = Server.shared.applicationInfo.documentsPath
        initizalizeNotification()
    }
    
    /// 更改偏好设置
    @IBAction func changeUserDefaults(_ sender: NSButton) {
        let path = Server.shared.applicationInfo.userPlistPath
        if path.count == 0 {return}
        
        let panel = NSOpenPanel()
        let index =  path.lastIndex(of: "/")
        let subPath =  String(path[path.startIndex ..< index!])
        panel.directoryURL = URL(fileURLWithPath: subPath, isDirectory: true)
        panel.title = "请打开正确的偏好设置文件"
        panel.beginSheetModal(for: view.window!) { (res) in
            
            guard let realpath = panel.url?.path, realpath.hasSuffix("plist")  else {
                let alert = NSAlert()
                alert.messageText = "请打开正确的偏好设置文件"
                alert.runModal()
                return
            }
            
            NSWorkspace.shared.openFile(realpath, withApplication: "Xcode")
            
            self.fileMonitor(path: realpath)
        }
        
//        print(result)
    }
    
    @IBAction func click(_ sender: Any) {
        
        // 打开偏好设置
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canSelectHiddenExtension = false
        panel.canCreateDirectories = false
        panel.isExtensionHidden = false
        panel.directoryURL = URL(fileURLWithPath: self.tf.stringValue, isDirectory: true)
        panel.beginSheetModal(for: view.window!) { (res) in
            if res.rawValue == 1 {
                
            NSWorkspace.shared.openFile(panel.url!.absoluteString, withApplication: "Finder")
                print(panel.url!.path)
                
            }
        }
    }
    
    override func moveDown(_ sender: Any?) {
//        self.tf.stringValue = "11111"
    }
    
    
}

extension UserDefaultsController {
    func initizalizeNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(receivePacket), name: NSNotification.Name(rawValue: receivePacketNotification), object: nil)
    }
    
    @objc func receivePacket(obj: Notification) {
        self.tf.stringValue = Server.shared.applicationInfo.documentsPath
    }
}


extension UserDefaultsController {
    func fileMonitor(path: String) {
        FileMonitorManager.default.startMonitor(paths: [path]).callBack = {
            print($0)
            // 文件发生变化
            let plistPath = $0[0]
            
            Server.shared.notificationManager.deliver(message: "偏好设置被更改了")
            
            let dic = NSDictionary(contentsOfFile: plistPath)
            if dic == nil {return}
            let data = try? JSONSerialization.data(withJSONObject: dic!, options: JSONSerialization.WritingOptions.prettyPrinted)
            if data == nil {return}
            // 发送数据给客户端让客户端完成偏好设置的更新
            for sock in Server.shared.clientSockets {
                sock.write(data!, withTimeout: -1, tag: 1)
            }
//            Server.shared.serverSocket?.write(data!, withTimeout: -1, tag: 0)
        }
    }
}
