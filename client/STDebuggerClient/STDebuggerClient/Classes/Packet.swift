//
//  Packet.swift
//  STDebuggerClient_Example
//
//  Created by 刘小二 on 2019/8/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

extension Packet {
    func setData() {
        expectedContentLength = response?.expectedContentLength ?? 0
        method = task?.originalRequest?.httpMethod ?? "GET"
        url = task?.originalRequest?.url?.absoluteString ?? "404 Error Address"
        requestHeaders = task?.originalRequest?.allHTTPHeaderFields
        responseHeaders = response?.allHeaderFields as? [String: String]
        code = response?.statusCode ?? 0;
        body = task?.originalRequest?.httpBody
    }
}


extension Packet {
    
    public convenience init?(dict: [String : Any?]) {
        self.init()
        
        var hasEmpty = false
        
        for value in dict.values {
            if value == nil {
                hasEmpty = true
            }
        }
        
        if hasEmpty == true {return nil}
        
        startTime = Date.init(timeIntervalSince1970: (dict["startTime"] != nil) ? (dict["startTime"] as! TimeInterval) : (NSDate().timeIntervalSince1970))
        endTime = Date.init(timeIntervalSince1970: dict["endTime"] as! TimeInterval)
        data = (dict["data"] as? String)?.data(using: String.Encoding.utf8)
        duration = dict["duration"] as! TimeInterval
        expectedContentLength = dict["expectedContentLength"] as! Int64
        method = dict["method"] as! String
        url = dict["url"] as? String
        requestHeaders = dict["requestHeaders"] as? [String : String]
        responseHeaders = dict["responseHeaders"] as? [String : String]
        code = dict["code"] as? Int
        body = (dict["body"] as? String)?.data(using: String.Encoding.utf8)
        errMsg = dict["errMsg"] as? String 
    }
}

public class Packet: NSObject {
    
    var startTime: Date?
    var endTime: Date?
    var task: URLSessionDataTask?
    var response: HTTPURLResponse? {
        didSet {
            setData()
        }
    }
    var data: Data?
    var duration: TimeInterval = 0
    var expectedContentLength: Int64 = 0
    var method: String = ""
    
    var url: String?
    
    var requestHeaders: [String: String]?
    
    var responseHeaders: [String: String]?
    var code: Int?
    var body: Data?
    var errMsg: String?
    
    override init() {
        
    }
    
    
    func toJson() -> [String : Any?] {
        return [
            "startTime" : startTime?.timeIntervalSince1970 ?? 0,
            "endTime" : endTime?.timeIntervalSince1970 ?? 0,
            "data" : String.init(data: data ?? Data(capacity: 1), encoding: String.Encoding.utf8),
            "duration" : duration ,
            "expectedContentLength" : expectedContentLength,
            "method" : method,
            "url" : url ?? "",
            "requestHeaders" : requestHeaders ?? ["" : ""],
            "responseHeaders" : responseHeaders ?? ["" : ""],
            "code" : code,
            "body" : String.init(data: body ?? Data(capacity: 1), encoding: String.Encoding.utf8),
            "errMsg": errMsg ?? ""
        ]
    }

}


