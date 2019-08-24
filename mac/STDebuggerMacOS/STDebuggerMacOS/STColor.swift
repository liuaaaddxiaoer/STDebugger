//
//  STColor.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/22.
//  Copyright © 2019 euming. All rights reserved.
//

import Cocoa

extension NSColor {
    public convenience init?(hex: String) {
        
        if hex.count < 6 {return nil}
        
        var str = hex
        
        if str.hasPrefix("#") {
            str = String(str[str.index(str.startIndex, offsetBy: 1)..<str.endIndex])
        }
        
        // 直接截取后6位
        
        let scanner = Scanner(string: str)
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r: Double = Double((rgbValue & 0xff0000) >> 16)
        let g: Double = Double((rgbValue & 0xff00) >> 8)
        let b: Double = (Double(rgbValue & 0xff))
        
        
        self.init(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: 1)
    }
}
