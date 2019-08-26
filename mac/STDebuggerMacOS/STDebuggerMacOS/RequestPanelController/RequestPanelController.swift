//
//  RequestPanelController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/18.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class RequestPanelController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var garbageBtn: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initializeTableViewStyle()
        
        // 通知
        initializeNotification()
    }
    
    // 清理包
    @IBAction func cleanPackets(_ sender: NSButton) {
//
        Server.shared.packets = []
        Server.shared.selectRequestPanelRow = 0
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: receivePacketNotification), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: selectPacketNotification), object: nil)
        
        
        let notification = NSUserNotification()
        notification.title = ""
        notification.subtitle = "清理数据成功"
        notification.deliveryDate = Date(timeIntervalSinceNow: 0)
        notification.hasActionButton = true
        notification.additionalActions = [NSUserNotificationAction(identifier: "a1", title: "确定")]
        
        
        let notificationCenter = NSUserNotificationCenter.default
        notificationCenter.delegate = self
        notificationCenter.scheduleNotification(notification)
        
        
    }
    fileprivate func initializeTableViewStyle() {
        
        // 清理声音
        let sound = NSSound(contentsOfFile: Bundle.main.path(forResource: "CleanDidFinish", ofType: "m4a")!, byReference: true)
        garbageBtn.sound = sound
        garbageBtn.toolTip = "清理数据"
        
        tableView.allowsEmptySelection = false
        tableView.enclosingScrollView?.drawsBackground = false
        tableView.enclosingScrollView?.backgroundColor = NSColor.red
        tableView.headerView?.wantsLayer = true
        tableView.gridColor = NSColor.clear
        tableView.headerView?.layer?.backgroundColor = NSColor(white: 1, alpha: 0.1).cgColor
        tableView.enclosingScrollView?.borderType = NSBorderType.noBorder
        tableView.wantsLayer = true
        tableView.backgroundColor = NSColor.clear
        tableView.rowHeight = 40
//        tableView.gridColor = NSColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        tableView.gridStyleMask = [.solidVerticalGridLineMask, .solidHorizontalGridLineMask]
        tableView.allowsColumnResizing = true
        tableView.intercellSpacing = NSSize(width: 10, height: 0)
        tableView.allowsMultipleSelection = false
        tableView.usesAlternatingRowBackgroundColors = false
        tableView.allowsTypeSelect = true
        
        
        // 注册view
        tableView.register(NSNib(nibNamed: "RequestPanelRowView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("row"))
        tableView.register(NSNib(nibNamed: "RequestPanelCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("cell"))
        tableView.cornerView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), owner: nil);
        
    }
}


extension RequestPanelController: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}

extension RequestPanelController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Server.shared.packets.count
    }
   
    func test() {
        
    }
}

extension RequestPanelController {
    func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveClientPacket(obj:)), name: NSNotification.Name(rawValue: receivePacketNotification), object: nil)
    }
    
    // 接收客户端数据包
    @objc func receiveClientPacket(obj: NSNotification) {
        self.tableView.reloadData()
    }
}

extension RequestPanelController {
    fileprivate enum TableRowIdentifier: String {
        case code = "Code"
        case method = "Method"
        case url = "URL"
        case start = "Start"
        case duration = "Duration"
        case size = "Size"
        case status = "Status"
    }
}

extension RequestPanelController: NSTableViewDelegate {
   
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("row"), owner: nil)
        view?.wantsLayer = true
        view?.layer?.backgroundColor = NSColor.clear.cgColor
        return view as? NSTableRowView
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        // 逆序
        let packet = Server.shared.packets[Server.shared.packets.count - row - 1]
        
        let view =  tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), owner: nil) as! RequestPanelCellView;
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        let identifier = tableColumn?.identifier.rawValue
        
        // size
        let responseSize = packet.expectedContentLength
        let bodySize = packet.body?.count
        if (responseSize < 0 || responseSize < Int(bodySize ?? 0)) {
            packet.expectedContentLength = Int64(bodySize ?? 0)
        }
        
        switch identifier {
        case TableRowIdentifier.code.rawValue:
            view.titleLabel.stringValue = String(packet.code!)
            view.titleLabel.alignment = .center
            view.titleLabel.textColor = ((packet.code != nil) && packet.code == 200) ? NSColor(hex: "#58D68D") : NSColor.red
        case TableRowIdentifier.method.rawValue:
            view.titleLabel.stringValue = packet.method
            view.titleLabel.alignment = .center
            view.titleLabel.textColor = NSColor(hex: "#E74C3C")
        case TableRowIdentifier.url.rawValue:
            view.titleLabel.stringValue = packet.url ?? ""
            view.titleLabel.toolTip = packet.url
            view.titleLabel.textColor = NSColor(hex: "#00ff00")
        case TableRowIdentifier.start.rawValue:
            
            let format = DateFormatter()
            format.dateFormat = "hh:mm:ss"
            view.titleLabel.stringValue = format.string(from: packet.startTime!)
        case TableRowIdentifier.duration.rawValue:
            view.titleLabel.stringValue = String(format: "%.0fms", packet.duration * 1000)
            view.titleLabel.textColor = NSColor(hex: "#ff0000")
        case TableRowIdentifier.size.rawValue:
            view.titleLabel.stringValue = String(Int(packet.expectedContentLength)) + "Byte"
        default:
            if (packet.code != nil) && packet.code == 200 {
                view.titleLabel.stringValue = "Completed"
            } else {
                view.titleLabel.toolTip = packet.errMsg
                view.titleLabel.stringValue = packet.errMsg ?? "Error"
            }
            view.titleLabel.textColor = NSColor.cyan
        }
        
        return view
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        print(tableView.selectedRow)
        let server = Server.shared
        server.selectRequestPanelRow = tableView.selectedRow
        
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: selectPacketNotification), object: server.selectRequestPacket)
    }
    
}

extension RequestPanelController {
    
}
