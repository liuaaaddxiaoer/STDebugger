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
            
            if packets.count > 0 {
                
               let index = packets.count - 1 - (selectRequestPanelRow < 0 ? 0 : selectRequestPanelRow)
                
                selectRequestPacket = packets[index]
            }
        }
    }
    var selectRequestPacket: Packet?
    
    var service: NetService?
    
    var clientSockets: [GCDAsyncSocket] = []
    
    var serverSocket: GCDAsyncSocket?
    
    var packets: [Packet] = []
    
    var notificationManager = LocalNotificationManager()
    
    var applicationInfo = ApplicationInformation()
    
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
        
        notificationManager.deliver(message: "新的客户端连接")
        
        newSocket.readData(withTimeout: -1, tag: 200)
        
        
        guard self.clientSockets.contains(newSocket) else {
            self.clientSockets.append(newSocket)
            return
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock.readData(withTimeout: -1, tag: tag)
        
        notificationManager.deliver(message: "接收到新的请求")
        
        if tag == 200 {
            let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if dict == nil {return};
            
            if (dict as! [String : Any?])["documentsPath"] == nil {
                
                let packet = Packet.init(dict: dict as! [String : Any?])
                if (packet == nil) {return}
                
                // 添加
                DispatchQueue.main.async {
                    self.packets.append(packet!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: receivePacketNotification), object: packet!)
                }
            } else {
                DispatchQueue.main.async {
                    self.applicationInfo = ApplicationInformation(dict: dict as! [String : Any])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: receivePacketNotification), object: nil)
                }
            }
        }
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        notificationManager.deliver(message: "客户端断开连接")
        objc_sync_enter(self)
        self.clientSockets = self.clientSockets.filter{ $0 !== sock}
        objc_sync_exit(self)
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
