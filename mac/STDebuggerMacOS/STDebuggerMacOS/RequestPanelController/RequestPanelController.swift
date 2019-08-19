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
//        tableView.usesAlternatingRowBackgroundColors = true
        tableView.allowsTypeSelect = true
        
        
        
        
        // 注册view
        tableView.register(NSNib(nibNamed: "RequestPanelRowView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("row"))
        tableView.register(NSNib(nibNamed: "RequestPanelCellView", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier.init("cell"))
        tableView.cornerView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), owner: nil);
        
    }
}

extension RequestPanelController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }
   
    func test() {
        
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
        let view =  tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), owner: nil);
        view?.wantsLayer = true
        view?.layer?.backgroundColor = NSColor.clear.cgColor
        return view
    }
    
}
