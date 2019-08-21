//
//  HeadersController.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/19.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class HeadersController: NSViewController {
    
    /// 页面类型
    var requestTabType = ToggleRequestTabType.response
    
    /// 工具tab类型
    var toolTabType = ToolPanelTabType.body
    

    @IBOutlet weak var tableView: NSTableView!
    var packet: Packet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.packet = Server.shared.selectRequestPacket
        
        // 样式
        initializeStyles()
        
        // 通知
        initializeNotification()
    }
    
    func initializeStyles() {
        
        tableView.wantsLayer = true
        tableView.rowHeight = 44.0
        tableView.enclosingScrollView?.borderType = NSBorderType.noBorder
        tableView.backgroundColor = NSColor.clear
        tableView.gridColor = NSColor.clear
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.enclosingScrollView?.drawsBackground = false
        
    }
}

extension HeadersController {
    func initializeNotification() {
        // 选择单个请求
        NotificationCenter.default.addObserver(self, selector: #selector(receiveClientPacket), name: NSNotification.Name(rawValue: selectPacketNotification), object: nil)
        
        // 切换Tab请求类型还是响应类型
        NotificationCenter.default.addObserver(self, selector: #selector(toggleRequestTabType), name: NSNotification.Name(rawValue: toggleRequestTabTypeNotification), object: nil)
        
        // 切换TabHeaders/Body/Query
        NotificationCenter.default.addObserver(self, selector: #selector(toggleToolTabType), name: NSNotification.Name(rawValue: toggleRequestTabTypeNotification), object: nil)
    }
    
    // 接收客户端数据包
    @objc func receiveClientPacket(obj: NSNotification) {
        self.packet = obj.object as? Packet
        self.tableView.reloadData()
    }
    
    // 切换请求还是响应类型
    @objc func toggleRequestTabType(obj: NSNotification) {
        let type = obj.object as? ToggleRequestTabType
        self.requestTabType = type ?? .request
        self.tableView.reloadData()
    }
    
    // 切换TabHeaders/Body/Query
    @objc func toggleToolTabType(obj: NSNotification) {
        let type = obj.object as? ToolPanelTabType
        self.toolTabType = type ?? .body
        self.tableView.reloadData()
    }
}

extension HeadersController {
    fileprivate enum NSTableColumnIdendifier: String {
        case key = "Key"
        case value = "Value"
    }
}

extension HeadersController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return packet?.requestHeaders?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        

        let requestHeaders = packet?.requestHeaders
        let responseHeaders = packet?.responseHeaders
        
        let requestKeys = requestHeaders?.keys
        let requestValues = requestHeaders?.values

        let responseKeys = responseHeaders?.keys
        let responseValues = responseHeaders?.values
        
        if tableColumn?.identifier.rawValue == NSTableColumnIdendifier.key.rawValue {
            
            // 如果是请求tab
            if self.requestTabType == .request {
                
                // headers
                if self.toolTabType == .headers {
                    if let keys = requestKeys {
                        var arrKeys: [String] = Array(keys)
                        return arrKeys[row]
                    }
                } else if self.toolTabType == .body {
                
       
                } else {
                    // query
                    if let keys = requestKeys {
                        var arrKeys: [String] = Array(keys)
                        return arrKeys[row]
                    }
                }
                
                
            } else {
              
                
                // headers
                if self.toolTabType == .headers {
                    if let keys = responseKeys {
                        var arrKeys: [String] = Array(keys)
                        return arrKeys[row]
                    }
                } else if self.toolTabType == .body {
                    
                    
                } else {
                    // query
                    if let keys = requestKeys {
                        var arrKeys: [String] = Array(keys)
                        return arrKeys[row]
                    }
                }
            }
            
        } else {
            
            // 如果是请求tab
            if self.requestTabType == .request {
                if let values = requestValues {
                    var arrValues: [String] = Array(values)
                    return arrValues[row]
                }
            } else {
                if let values = responseValues {
                    var arrValues: [String] = Array(values)
                    return arrValues[row]
                }
            }
        }
        return nil
    }
}
