//
//  Client.swift
//  STDebuggerClient_Example
//
//  Created by 小2 on 2019/8/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class Client : NSObject {
    
    private var browser = Browser()
    private var sessionHook = URLSessionHook()
    
    static let shared = Client()
    func inject() {
        sessionHook.hookDelegate = self
        sessionHook.inject()
        browser.inject()
    }
    
    deinit {
        
    }
}

extension Client: URLSessionHookDelegate {
    func urlSessionHookDidStart() {
        print(#function)
    }
    
    func urlSessionHook(_ hook: URLSessionHook, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
        print(#function)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
    }
    
    
}
