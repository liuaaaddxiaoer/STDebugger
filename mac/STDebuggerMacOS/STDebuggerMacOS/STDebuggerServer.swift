//
//  STDebuggerServer.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/17.
//  Copyright © 2019 euming. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class Server: NSObject {

    static let shared = Server.init()
    
    var service: NetService?
    
    var clientSockets: [GCDAsyncSocket] = []
    
    var serverSocket: GCDAsyncSocket?

    
    deinit {
        self.service?.stop()
    }
    
    func inject() {
        DispatchQueue.main.async {
            let service = NetService(domain: ServerConfig.domain, type: ServerConfig.type, name: ServerConfig.name, port: ServerConfig.port)
            service.schedule(in: RunLoop.current, forMode: .common)
            service.delegate = self
            service.publish()
            self.service = service
            
            self.serverSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
            do {
                
                try self.serverSocket?.accept(onPort: UInt16(ServerConfig.port))
            }catch _ {
                print("连接失败")
            }
        }
    }
}

extension Server: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        guard self.clientSockets.contains(newSocket) else {
            self.clientSockets.append(newSocket)
            return
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.clientSockets = self.clientSockets.filter{ $0==sock}
    }
}


extension Server: NetServiceDelegate {
    
    public func netServiceWillPublish(_ sender: NetService) {
        
    }
    
    
    public func netServiceDidPublish(_ sender: NetService) {
        
    }
    
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        
    }
    
    
    public func netServiceWillResolve(_ sender: NetService) {
        
    }
    
    
    public func netServiceDidResolveAddress(_ sender: NetService) {
        
    }
    
    
    public func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        
    }
    
    
    public func netServiceDidStop(_ sender: NetService) {
        
    }
    
    
    public func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        
    }
    
    
    @available(OSX 10.9, *)
    public func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        
    }
}
