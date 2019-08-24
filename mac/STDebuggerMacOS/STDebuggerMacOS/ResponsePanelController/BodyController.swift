//
//  BodyController.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/20.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class BodyController: NSViewController {

    var packet: Packet?
    /// 页面类型
    var requestTabType = ToggleRequestTabType.response
    
    @IBOutlet weak var content: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.packet = Server.shared.selectRequestPacket
        
        // 通知
        initializeNotification()
        
        // 内容赋值
        setupContent()
    }
    
    func setupContent() {
        
        if Server.shared.packets.count == 0 {
            self.packet = nil
        }
        
        var data = self.packet?.data
        if requestTabType == .request {
            data = self.packet?.body
        }
        
        var jsonStr = ""
        if let bodyData = data {
            var dic = try? JSONSerialization.jsonObject(with: bodyData, options: JSONSerialization.ReadingOptions.mutableContainers)
            if dic == nil {
                dic = ["" : ""]
            }
            jsonStr = try! String(data: JSONSerialization.data(withJSONObject: dic!, options: JSONSerialization.WritingOptions.prettyPrinted), encoding: String.Encoding.utf8) ?? ""
            
        }
        
        
        self.content.isAutomaticDataDetectionEnabled = true
//        let str = jsonStr as NSString
//        str.replacingOccurrences(of: "\\/", with: "/")
        self.content.isEditable = false
        self.content.backgroundColor = NSColor(white: 1, alpha: 0.1)
        self.content.font = NSFont.systemFont(ofSize: 15.0)
        self.content.textColor = NSColor(hex: "#2ecc71")
        self.content.string = jsonStr
        self.content.isSelectable = true
    }
    
}

extension BodyController {
    func initializeNotification() {
        // 选择单个请求
        NotificationCenter.default.addObserver(self, selector: #selector(receiveClientPacket), name: NSNotification.Name(rawValue: selectPacketNotification), object: nil)
        
        // 切换Tab请求类型还是响应类型
        NotificationCenter.default.addObserver(self, selector: #selector(toggleRequestTabType), name: NSNotification.Name(rawValue: toggleRequestTabTypeNotification), object: nil)
        
     
    }
    
    // 接收客户端数据包
    @objc func receiveClientPacket(obj: NSNotification) {
        self.packet = obj.object as? Packet
        setupContent()
    }
    
    // 切换请求还是响应类型
    @objc func toggleRequestTabType(obj: NSNotification) {
        let type = obj.object as? ToggleRequestTabType
        self.requestTabType = type ?? .request
        setupContent()
    }
    
}
