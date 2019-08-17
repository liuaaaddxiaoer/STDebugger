//
//  URLSessionHook.swift
//  STDebuggerClient_Example
//
//  Created by 小2 on 2019/8/14.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC.runtime
open class URLSessionHook: NSObject {
    public override init() {
        super.init()
    }
    
   @objc public func inject() {
        // iOS9的底层类
        let cfURLSessionClassName = NSString.init(string: "__NSCFURLLocalSessionConnection").utf8String!
        // iOS8
        let ios8CFURLSessionClassName = NSString.init(string: "__NSCFURLSessionConnection").utf8String!
        
        var cfURLSessionClass = objc_getClass(cfURLSessionClassName)
        cfURLSessionClass = cfURLSessionClass ?? objc_getClass(ios8CFURLSessionClassName)
        
        // Task
        let cfURLSessionTaskClassName = NSString.init(string: "__NSCFURLSessionTask").utf8String!
        let cfURLSessionTaskClass = objc_getClass(cfURLSessionTaskClassName)!
        
        if cfURLSessionClass == nil {return}
        
        // 开始交换系统方法
        
        // 交换resume方法
        swizzleResumeWithClass(sessionClass: cfURLSessionTaskClass)
        // 交换响应方法
        swizzleResponseSniffWithClass(sessionClass: cfURLSessionClass!)
        // 交换接收数据的方法
        swizzleReveiceDataWithClass(sessionClass: cfURLSessionClass!)
        // 交换完成
        swizzleFinishedWithClass(sessionClass: cfURLSessionClass!)
    }
    
    /// 交换resume方法
    func swizzleResumeWithClass(sessionClass: Any) {
        let anyClass: AnyClass = sessionClass as! AnyClass
        
        let cmd: Selector = Selector.init(("resume"))
        
        let method = class_getInstanceMethod(anyClass, cmd)
        
        if let resMethod = method {
            // 获取方法实现
            let imp = method_getImplementation(resMethod)
            
            typealias OldImpType = @convention(c) (AnyClass, Selector) -> Void
            
            // imp是函数指针 将闭包转函数指针
            let oldImpBlock = unsafeBitCast(imp, to: OldImpType.self)
            
            
            // 闭包转OC的Block
            let hookBlock :@convention(block) (AnyClass) -> Void = { wself in
                print("开始交换Resume")
                // 执行系统的方法
                oldImpBlock(wself, cmd)
            }
            
            // hookImp
            let newImp = imp_implementationWithBlock(hookBlock)
            
            // 设置新的方法实现
            method_setImplementation(resMethod, newImp)
        }
    }
    
    
    /// 交换完成
    func swizzleFinishedWithClass(sessionClass: Any) {
        let anyClass: AnyClass = sessionClass as! AnyClass
        
        let cmd: Selector = Selector.init(("_didFinishWithError:"))
        
        let method = class_getInstanceMethod(anyClass, cmd)
        
        if let resMethod = method {
            // 获取方法实现
            let imp = method_getImplementation(resMethod)
            
            typealias OldImpType = @convention(c) (AnyClass, Selector, AnyObject) -> Void
            
            // imp是函数指针 将闭包转函数指针
            let oldImpBlock = unsafeBitCast(imp, to: OldImpType.self)
            
            
            // 闭包转OC的Block
            let hookBlock :@convention(block) (AnyClass, AnyObject) -> Void = { wself, arg in
                print("开始交换URLSession结束数据方法")
                // 执行系统的方法
                oldImpBlock(wself, cmd, arg)
            }
            
            // hookImp
            let newImp = imp_implementationWithBlock(hookBlock)
            
            // 设置新的方法实现
            method_setImplementation(resMethod, newImp)
        }
    }
    
    /// 交换接收数据的方法
    func swizzleReveiceDataWithClass(sessionClass: Any) {
        let anyClass: AnyClass = sessionClass as! AnyClass
        
        let cmd: Selector = Selector.init(("_didReceiveData:"))
        
        let method = class_getInstanceMethod(anyClass, cmd)
        
        if let resMethod = method {
            // 获取方法实现
            let imp = method_getImplementation(resMethod)
            
            typealias OldImpType = @convention(c) (AnyClass, Selector, AnyObject) -> Void
            
            // imp是函数指针 将闭包转函数指针
            let oldImpBlock = unsafeBitCast(imp, to: OldImpType.self)
            
            
            // 闭包转OC的Block
            let hookBlock :@convention(block) (AnyClass, AnyObject) -> Void = { wself, arg in
                print("开始交换URLSession接收数据方法")
                // 执行系统的方法
                oldImpBlock(wself, cmd, arg)
            }
            
            // hookImp
            let newImp = imp_implementationWithBlock(hookBlock)
            
            // 设置新的方法实现
            method_setImplementation(resMethod, newImp)
        }
    }
    
    /// 交换响应方法
    func swizzleResponseSniffWithClass(sessionClass: Any) {
        
        
        let anyClass: AnyClass = sessionClass as! AnyClass
        
        let cmd: Selector = Selector.init(("_didReceiveResponse:sniff:"))
        
        let method = class_getInstanceMethod(anyClass, cmd)
        
        if let resMethod = method {
            
            // 获取方法实现
            let imp = method_getImplementation(resMethod)
            
            typealias OldImpType = @convention(c) (AnyClass, Selector, Any, Bool) -> Void
            
            // imp是函数指针 将闭包转函数指针
            let oldImpBlock = unsafeBitCast(imp, to: OldImpType.self)
            
            
            // 闭包转OC的Block
            let hookBlock :@convention(block) (AnyClass, Any, Bool) -> Void = { wself, arg, sniff in
                print("开始交换URLSession响应方法")
                // 执行系统的方法
                oldImpBlock(wself, cmd, arg, sniff)
            
            }
            
            // hookImp
            let newImp = imp_implementationWithBlock(hookBlock)
            
            // 设置新的方法实现
            method_setImplementation(resMethod, newImp)
            
        }
    }
    
    func methodList() {
        
        
    }
}
