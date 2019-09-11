//
//  ViewController.swift
//  STCarUnPack
//
//  Created by liuaaaddxiaoer on 09/10/2019.
//  Copyright (c) 2019 liuaaaddxiaoer. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    lazy var stView: STCustomDragView = {
        if let v = STCustomDragView.fromNib() {
            return v as! STCustomDragView
        }
        return STCustomDragView()
    }()
    
  override func viewDidLoad() {
    super.viewDidLoad()

    
    view.addSubview(stView)
  }
    
    override func viewWillLayout() {
        stView.frame = view.bounds
    }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

