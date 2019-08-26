//
//  FileMonitorManager.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/25.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

typealias FileChangesBack = (_ callBack: [String]) -> ()

class FileMonitorManager: NSObject {
    
    static let `default`: FileMonitorManager = FileMonitorManager()
    
    var queue = DispatchQueue(label: "com.xiaoer.file_monitor")
    
    var streamRef: FSEventStreamRef?
    
    var callBack: FileChangesBack?
    
    let eventCallBack: FSEventStreamCallback = { (ref, context,numEvents,eventPaths,eventFlags,ids) in
        guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }
    
        let weakSelf: FileMonitorManager = unsafeBitCast(context!, to: FileManagerDelegate.self) as! FileMonitorManager
        
        weakSelf.handlePaths(paths: paths)
    }
    
    func startMonitor(paths: [String]) -> FileMonitorManager {
        
        
        queue.async {
            if self.streamRef != nil {
                FSEventStreamStop(self.streamRef!)
            }
            let flags = FSEventStreamCreateFlags(kFSEventStreamCreateFlagFileEvents | kFSEventStreamCreateFlagUseCFTypes )
            var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
            context.info = Unmanaged.passUnretained(self).toOpaque()
            
            let streamRef = FSEventStreamCreate(nil, self.eventCallBack, &context, paths as CFArray, FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 2, flags)
            FSEventStreamScheduleWithRunLoop(streamRef!, CFRunLoopGetCurrent(), CFRunLoopMode.commonModes.rawValue)
            FSEventStreamStart(streamRef!)
            self.streamRef = streamRef
            CFRunLoopRun()
            
        }
        return self
    }
    
    func handlePaths(paths: [String]) {
        self.callBack!(paths)
    }
    
    deinit {
        print("delloc")
    }
    
}




