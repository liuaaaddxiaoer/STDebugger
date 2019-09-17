//
//  TranslateViewController.swift
//  STTranslate_Example
//
//  Created by 小2 on 2019/9/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import WebKit

class TranslateViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var event: Any?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.setContentSize(NSSize(width: 800, height: 700))
        view.window?.minSize = NSSize(width: 800, height: 700)
        view.window?.maxSize = NSSize(width: 800, height: 700)
        view.window?.center()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "谷歌翻译"
        // Do view setup here.
        webView.load(URLRequest(url: URL(string: "https://translate.google.cn/")!))
        
        // 注册全局事件
       self.event = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged]) { (e) in
            print(e);
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
      
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        webView.reload()
    }
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        
        print("hello world")
        
        return true
    }
}
extension TranslateViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        let av = N
    }
    
}
