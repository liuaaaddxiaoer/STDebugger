//
//  ApplicationInformation.swift
//  STDebuggerClient_Example
//
//  Created by 刘小二 on 2019/8/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class ApplicationInformation: NSObject {
    var documentsPath: String = ""
    var userPlistPath: String = ""
    
    func toJson() -> Dictionary<String, Any> {
        return [
            "documentsPath": documentsPath,
            "userPlistPath": userPlistPath
        ]
    }
    
}

extension ApplicationInformation {
    public convenience init(dict: [String : Any]) {
        self.init()
        documentsPath = (dict["documentsPath"] as? String) ?? ""
        userPlistPath = (dict["userPlistPath"] as? String) ?? ""
    }
}
