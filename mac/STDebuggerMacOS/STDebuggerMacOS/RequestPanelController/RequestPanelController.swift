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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initializeTableViewStyle()
        
        // 通知
        initializeNotification()
    }
    
    fileprivate func initializeTableViewStyle() {
        tableView.allowsEmptySelection = false
        tableView.backgroundColor = NSColor.clear
        tableView.rowHeight = 40
        tableView.gridColor = NSColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        tableView.gridStyleMask = [.solidVerticalGridLineMask, .solidHorizontalGridLineMask]
        tableView.allowsColumnResizing = true
        tableView.intercellSpacing = NSSize(width: 10, height: 0)
        tableView.allowsMultipleSelection = true
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsTypeSelect = true
        
        // 注册view
        tableView.register(NSNib(nibNamed: "RequestPanelRowView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("row"))
        tableView.register(NSNib(nibNamed: "RequestPanelCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("cell"))
        tableView.cornerView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), owner: nil);
        
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
        switch identifier {
        case TableRowIdentifier.code.rawValue:
            view.titleLabel.stringValue = "1"
        case TableRowIdentifier.method.rawValue:
            view.titleLabel.stringValue = packet.method
        case TableRowIdentifier.url.rawValue:
            view.titleLabel.stringValue = packet.url ?? ""
        case TableRowIdentifier.start.rawValue:
            view.titleLabel.stringValue = "1"
        case TableRowIdentifier.duration.rawValue:
            view.titleLabel.doubleValue = packet.duration
        case TableRowIdentifier.size.rawValue:
            view.titleLabel.integerValue = packet.code ?? 0
        default:
            view.titleLabel.integerValue = packet.code ?? 0
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
