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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.\
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
        self.tf.stringValue = Server.shared.applicationInfo.documentsPath
        initizalizeNotification()
    }
    
    @IBAction func click(_ sender: Any) {
        
        print(self.tf.stringValue)
        // 打开偏好设置
        
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canSelectHiddenExtension = false
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.directoryURL = URL(fileURLWithPath: self.tf.stringValue, isDirectory: true)
        panel.beginSheetModal(for: view.window!) { (res) in
            if res.rawValue == 1 {
                
            NSWorkspace.shared.openFile(panel.url!.absoluteString, withApplication: "Xcode")
                print(panel.url!.path)
                FileMonitorManager.default.startMonitor(paths: [panel.url!.path]).callBack = {
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
                        sock.write(data!, withTimeout: -1, tag: 0)
                    }
                }
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
