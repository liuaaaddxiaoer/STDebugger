//
//  STService.swift
//  STCarUnPack_Example
//
//  Created by 小2 on 2019/9/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa

class STService: NSObject {
    @objc public func register(_ pboard: NSPasteboard!, userData: String!, error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        print("service" + userData)
        let window = NSApp.windows[0]
        window.center()
    }
}
