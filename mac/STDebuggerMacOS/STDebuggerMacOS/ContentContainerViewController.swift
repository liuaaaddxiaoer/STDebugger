//
//  ContentContainerViewController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/21.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class ContentContainerViewController: NSViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var httpSplit = NSStoryboard.init(name: "HttpClient", bundle: nil).instantiateController(withIdentifier: "http") as! HttpSplitController
    
    lazy var sp : UserDefaultsController = {
        let sharedSp = UserDefaultsController()
        sharedSp.view.frame = view.bounds
        sharedSp.view.autoresizingMask = [.width, .height]
        return sharedSp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initializeNotification()
        addChildVcs()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        httpSplit.view.frame = view.bounds
    }
    
  
    
    func addChildVcs() {
    
        addChild(httpSplit)
        view.addSubview(httpSplit.view)
        addChild(sp)
        
    }
}

extension ContentContainerViewController {
    func initializeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(toggleChildVc), name: NSNotification.Name(rawValue: menuNavToggleIndexNotification), object: nil)
    }
    
    @objc func toggleChildVc(notification: NSNotification) {
        let index: Int = notification.object as? Int ?? 0
       
        if index != 0 {

            transition(from: httpSplit, to: sp, options: NSViewController.TransitionOptions.slideUp) {
                self.httpSplit.view.alphaValue = 1
            }
        } else {
            
            if sp.view.superview == nil {
                return 
            }
            
            transition(from: sp, to: httpSplit, options: NSViewController.TransitionOptions.slideDown) {
                
            }
        }
    }
}
