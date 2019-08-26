//
//  ViewController.swift
//  STDebuggerClient
//
//  Created by liuaaaddxiaoer on 08/14/2019.
//  Copyright (c) 2019 liuaaaddxiaoer. All rights reserved.
//

import UIKit
import ObjectiveC.runtime
class ViewController: UIViewController {
    
    var task: URLSessionDataTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Client.shared().inject()
        
        print(ApplicationInformation().documentsPath)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        
        
        UserDefaults.standard.register(defaults: ["name2": "hahasdads"])
        
        UserDefaults.standard.synchronize()
        
        return
        
        
        UserDefaults.resetStandardUserDefaults()
        UserDefaults.standard.set(true, forKey: "test")
        UserDefaults.standard.synchronize()
        
        print("key is" + (UserDefaults.standard.string(forKey: "name") ?? "1"))
        
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.current)

        let task = session.dataTask(with: URL.init(string: "http://yapi.base.eoffcn.com/api/group/list")!)
        task.resume()

        self.task = task
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}

