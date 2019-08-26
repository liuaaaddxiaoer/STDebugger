//
//  LocalNotificationManager.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/25.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

class LocalNotificationManager: NSObject {
    override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    /// 立即发送通知
    func deliver(message: String) {
        
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        
        let notification = NSUserNotification()
        notification.title = ""
        notification.subtitle = message
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
    }
}



extension LocalNotificationManager: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        print("ok")
        return true
    }
}
