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
    
    var selectRequestPanelRow: Int = 0 {
        didSet {
            selectRequestPacket = packets[selectRequestPanelRow < 0 ? 0 : selectRequestPanelRow]
        }
    }
    var selectRequestPacket: Packet?
    
    var service: NetService?
    
    var clientSockets: [GCDAsyncSocket] = []
    
    var serverSocket: GCDAsyncSocket?
    
    var packets: [Packet] = []
    
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
                self.serverSocket?.readData(withTimeout: -1, tag: 1)
            
            }catch _ {
                print("连接失败")
            }
        }
    }
}

extension Server: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        newSocket.readData(withTimeout: -1, tag: 1)
        guard self.clientSockets.contains(newSocket) else {
            self.clientSockets.append(newSocket)
            return
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.readData(withTimeout: -1, tag: tag)
        
       
        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        if dict == nil {return};
        
        
        let packet = Packet.init(dict: dict as! [String : Any?])
        if (packet == nil) {return}
        
        // 添加
        packets.append(packet!)
        
        // 发送通知
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: receivePacketNotification), object: packet)
        }
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        self.clientSockets = self.clientSockets.filter{ $0 !== sock}
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
