//
//  NetworkBrowser.swift
//  STDebuggerClient_Example
//
//  Created by 小2 on 2019/8/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

open class Browser : NSObject {
    
    var browser : NetServiceBrowser?
    var services: [NetService] = []
    var socketClient: GCDAsyncSocket?
    
    func sendPacket(packet: Packet) {
        print(packet)
        
        
        do {
           
            let dic = packet.toJson()
            
            let arData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            
            // 发送
            self.socketClient?.write(arData, withTimeout: -1, tag: 0)
//            self.socketClient?.readData(withTimeout: -1, tag: 1)
            
        } catch let err {
            print(err)
        }
        
        
    }
    
    func inject() {
        DispatchQueue.main.async {
            let browser = NetServiceBrowser()
            browser.schedule(in: RunLoop.current, forMode: .common)
            browser.delegate = self
            browser.searchForServices(ofType: "_xiao2._tcp", inDomain: "")
            self.browser = browser
        }
        
//        DispatchQueue.global(qos: .background).async {
//
//
//        }
        self.socketClient = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
//        self.socketClient?.readData(withTimeout: -1, tag: 110)
    }
    
    func reload() {
        
    }
    
    deinit {
        
    }
}

extension Browser: GCDAsyncSocketDelegate {
    
     public func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        
    }
    
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 1)
    }
    
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        sock.readData(withTimeout: -1, tag: 1)

//        sock.readData(withTimeout: -1, tag: 110)
        
    
        
    }
    private func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
//        Client.shared().browser.inject()
    }
    
//
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
        if (dict != nil) {
            for (key, value) in dict! {
                UserDefaults.standard.set(value, forKey: key)
            }
        }
        
        
//        sock.readData(withTimeout: -1, tag: 110);
    }
    
    
}


extension Browser: NetServiceBrowserDelegate {
    public func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        
    }
    
    
    public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        
    }
    
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        
        
    }
    
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        
        
    }
    
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        self.services.append(service)
        service.delegate = self;
        service.resolve(withTimeout: Double(Int.max))
        
    }
    
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        
    }
    
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {

        self.services = self.services.filter{$0 !== service}
    }
}

extension Browser: NetServiceDelegate {
    
    
    public func netServiceWillResolve(_ sender: NetService) {
        // 拿到远程服务器ip地址建立socket连接
        self.socketClient?.disconnect()
    }
    
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        
        
        if let address = sender.addresses?[0] {
            do {
                try self.socketClient?.connect(toAddress: address)
//                self.socketClient?.readData(withTimeout: -1, tag: 2)
            } catch let err {
                print(err)
            }
        }
        
        self.services = self.services.filter{$0 !== sender}
    }
    
    
    public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        self.services = self.services.filter{$0 !== sender}
    }
    
    
    public func netServiceDidStop(_ sender: NetService) {
        
    }
}
