//
//  STCustomDragView.swift
//  STCarUnPack_Example
//
//  Created by 小2 on 2019/9/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Cocoa
import CoreGraphics

extension NSView {
    class func fromNib<T: NSView>() -> T? {
        var viewArray:NSArray?
        guard Bundle.main.loadNibNamed(String(describing:self), owner: nil, topLevelObjects: &viewArray) else {
            return nil
        }
        return viewArray?.first(where: { $0 is T }) as? T
    }
}

@objc class STCustomDragView: NSView {
    
    var types: [NSPasteboard.PasteboardType] = []
    var shapeLayer: CAShapeLayer?
    var selectedPath: String?

    @IBOutlet weak var fileAddressLabel: NSTextField!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        window?.isMovableByWindowBackground = true
        
        self.wantsLayer = true
        
        // 注册拖拽
        if #available(OSX 10.13, *) {
            types = [.fileURL]
            registerForDraggedTypes(types)
        } else {
            types = [.fileContents]
            registerForDraggedTypes(types)
        };
        
        // 画虚线
        let shapeLayer = CAShapeLayer()
       
        
        shapeLayer.backgroundColor = NSColor.clear.cgColor
        shapeLayer.frame = bounds
        shapeLayer.lineDashPattern = [NSNumber(value: 8),NSNumber(value: 8)];
        shapeLayer.lineWidth = 1;

        shapeLayer.fillColor = NSColor.clear.cgColor;
        shapeLayer.strokeColor = NSColor.gray.cgColor;
        self.layer?.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
    
    }
    

    
    override func mouseDown(with event: NSEvent) {
        let open = NSOpenPanel()
        open.canChooseDirectories = false
        open.allowsMultipleSelection = false
        open.delegate = self
        open.allowedFileTypes = ["car", "app"]
        open.beginSheetModal(for: window!) { (res) in
            if (res == NSApplication.ModalResponse.OK) {
                
                // 如果选择的是app文件
                var path = open.url!.path
                if (path.hasSuffix("app")) {
                    
                    let manager = FileManager.default
                    let strs = try? manager.contentsOfDirectory(atPath: path)
                    for file in strs ?? []{
                        print(file)
                        if (file.hasSuffix("car")) {
                            path = (path as NSString).appendingPathComponent(file)
                            print(path)
                            self.selectedPath = path
                            self.fileAddressLabel.stringValue = path
                            break
                        }
                    }
                    
                } else {
                    self.selectedPath = path
                    self.fileAddressLabel.stringValue = path
                }
                
            }
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    override func layout() {
        super.layout()
         let path = NSBezierPath(rect: NSInsetRect(bounds, 10, 10))
        shapeLayer?.frame = bounds
        shapeLayer?.path = path.cgPath
    }
    
    /// 保存
    @IBAction func saveClick(_ sender: NSButton) {
        guard let url = selectedPath else {
            return
        }
        
        let save = NSOpenPanel()
        save.canChooseFiles = false
        save.canChooseDirectories = true
        save.prompt = "保存"
        save.beginSheetModal(for: window!) { (res) in
            if (res == NSApplication.ModalResponse.OK) {
                
                guard let saveURL = save.url?.path else {
                    return
                }
                // 生成目录
                
                let date = Date()
                let fmt = DateFormatter()
                fmt.dateFormat = "YYYY-MM-dd HH:mm:ss"
                
                let dateStr = "/\(fmt.string(from: date))"
                
               let success = self.runCommandWithPath(path: "/bin/mkdir", args: [saveURL + dateStr])
                
                if (success) {
                    var fileURL = ""
                    if (url.hasPrefix("file://")) {
                        fileURL = (url as NSString).substring(from: "file://".count)
                    } else {
                        fileURL = url
                    }

                   let saveOk = self.runCommandWithPath(path: Bundle.main.path(forResource: "cartool", ofType: nil)!,args: [fileURL, saveURL + dateStr])
                    if (saveOk) {
                        NSWorkspace.shared.openFile(saveURL + dateStr, withApplication: "Finder")
                    }
                }
            }
        }
    }
}

extension STCustomDragView: NSOpenSavePanelDelegate {
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        return true
    }

}

extension STCustomDragView {
    @discardableResult
    func runCommandWithPath(path: String, args: [String]) -> Bool {
        let task = Process()
        
        task.launchPath = path
        task.arguments = args
        
        let pipe = Pipe()
        task.standardInput = Pipe()
        task.standardOutput = pipe
        
        let errPipe = Pipe()
        task.standardError = errPipe
        
        let fileHandle = pipe.fileHandleForReading
        
        task.launch()
        
        
        // read
        let data = fileHandle.readDataToEndOfFile()
        
        let errHandle = errPipe.fileHandleForReading
        
        
        print(data)
        let errStr = String(data: errHandle.readDataToEndOfFile(), encoding: String.Encoding.utf8)
        
        if ((errStr) != nil && errStr!.count > 0) {
            print(errStr!)
            task.waitUntilExit()
            return false
        }
        task.waitUntilExit()
        return true
    }
}

extension NSBezierPath {
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            
            switch type {
            case .moveTo:
                path.move(to: points[0])
                
            case .lineTo:
                path.addLine(to: points[0])
                
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
                
            case .closePath:
                path.closeSubpath()
                
            default:
                break
            }
        }
        return path
    }
}

/// 拖拽代理方法
extension STCustomDragView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("draggingEntered")
        
        shapeLayer?.strokeColor = NSColor.red.cgColor
        
        let pb = sender.draggingPasteboard
        
        let type = pb.availableType(from: types)
        let url = URL(string: pb.string(forType: type!) ?? "")?.absoluteString ?? ""
        
        // 只解压car后缀的
        if (url.hasSuffix("car")) {
            
            return .copy
            
        } else {
            
            
            // 提示
            let alert = NSAlert()
            alert.messageText = "只能上传car文件"
            alert.beginSheetModal(for: window!, completionHandler: nil)
            
            return NSDragOperation()
        }
        
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("prepareForDragOperation")
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("performDragOperation")
        
        // 得到确切的信息
        let pb = sender.draggingPasteboard
        
        let type = pb.availableType(from: types)
        let url = URL(string: pb.string(forType: type!) ?? "")?.absoluteString ?? ""
        
        print("文件地址: \(url)")
        self.selectedPath = url
        self.fileAddressLabel.stringValue = url
        return true
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("draggingExited")
        shapeLayer?.strokeColor = NSColor.gray.cgColor
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        print("draggingEnded")
        shapeLayer?.strokeColor = NSColor.gray.cgColor
    }
}
