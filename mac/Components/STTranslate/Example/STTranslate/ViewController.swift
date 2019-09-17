//
//  ViewController.swift
//  STTranslate
//
//  Created by liuaaaddxiaoer on 09/17/2019.
//  Copyright (c) 2019 liuaaaddxiaoer. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
    
    override func mouseDown(with event: NSEvent) {
        presentViewControllerAsModalWindow(TranslateViewController())
    }
    
    override func keyDown(with event: NSEvent) {
        print(1);
    }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

