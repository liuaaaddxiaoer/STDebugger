//
//  ViewController.swift
//  STDebuggerClient
//
//  Created by liuaaaddxiaoer on 08/14/2019.
//  Copyright (c) 2019 liuaaaddxiaoer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var task: URLSessionDataTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Client.shared.inject()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
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

