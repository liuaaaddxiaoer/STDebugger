//
//  Const.swift
//  STDebuggerMacOS
//
//  Created by 小2 on 2019/8/19.
//  Copyright © 2019 euming. All rights reserved.
//

import Foundation

/// Tab切换请求还是响应
public enum ToggleRequestTabType: Int {
    case request
    case response
}


/// 工具Tab切换
public enum ToolPanelTabType: Int {
    case headers
    case body
    case query
}


/// 接收数据包通知
let receivePacketNotification = "receivePacketNotification"

/// 选择某个请求
let selectPacketNotification = "selectPacketNotification"

/// 选择显示请求头信息还是响应头信息的切换点击
let toggleRequestTabTypeNotification = "toggleRequestTabTypeNotification"

/// Headers/Body/Query Tab切换通知
let toggleToolTabTypeNotification = "toggleToolTabTypeNotification"
