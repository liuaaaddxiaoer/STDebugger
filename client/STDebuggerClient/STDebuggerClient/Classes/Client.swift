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
    private var packets: [Packet] = []
    private var queue = DispatchQueue.init(label: "www.liuxiaoer.club")
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
    
    func urlSessionHookDidStart(_ hook: URLSessionHook, dataTask: URLSessionDataTask) {
        print(#function)
        let packet = getPacket(task: dataTask)
        packet.startTime = Date()
    }
    
    func urlSessionHook(_ hook: URLSessionHook, dataTask: URLSessionDataTask, didReceive response: URLResponse) {
        print(#function)
        let packet = getPacket(task: dataTask)
        packet.response = response as? HTTPURLResponse
    }
    
    func urlSession(_ hook: URLSessionHook, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function)
        let packet = getPacket(task: dataTask)
        packet.data = data
    }
    
    func urlSession(_ hook: URLSessionHook, task: URLSessionDataTask, didCompleteWithError error: Error?) {
        print(#function)
        let packet = getPacket(task: task)
        packet.endTime = Date()
        packet.duration = oneHookURLSessionDuration(packet: packet)
        
        performBlock(packet: packet)
    }
    
    func oneHookURLSessionDuration(packet: Packet) -> TimeInterval {
        guard let begin = packet.startTime, let end = packet.endTime else {return 0}
        
        return end.timeIntervalSince(begin)
    }
    
    func performBlock(packet: Packet) {
        queue.async {
            self.browser.sendPacket(packet: packet)
            self.packets = self.packets.filter{ $0 !== packet }
        }
    }
    
    func getPacket(task: URLSessionDataTask) -> Packet{
        
        var tmpPacket: Packet?;
        
        for packet in packets {
            if packet.task?.taskIdentifier == task.taskIdentifier {
                tmpPacket = packet
                break
            }
        }
        
        if tmpPacket == nil {
            tmpPacket = Packet()
            tmpPacket?.task = task
            packets.append(tmpPacket!)
        }
        
        
        return tmpPacket!
    }
}
