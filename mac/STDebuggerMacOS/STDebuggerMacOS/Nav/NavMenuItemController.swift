//
//  NavMenuItemController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/18.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class NavMenuItemController: NSCollectionViewItem {
    
    
    @IBOutlet weak var icon: NSImageView!
    @IBOutlet weak var name: NSTextField!
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            updateBackGroundColor()
        }
    }
    
    
    override func viewDidLoad() {

        view.wantsLayer = true
    }
    
    func updateBackGroundColor() {
        if isSelected {
            switch highlightState {
            case .none, .forDeselection, .asDropTarget:
                view.layer?.backgroundColor = NSColor.clear.cgColor
            case .forSelection:
                view.layer?.backgroundColor = NSColor(white: 1, alpha: 0.5).cgColor
            }
           
        } else {
            view.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    override func viewWillLayout() {
        
    }
    
    
}
