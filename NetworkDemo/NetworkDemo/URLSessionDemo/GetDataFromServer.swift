//
//  GetDataFromServer.swift
//  NetworkDemo
//
//  Created by liulongyang on 2019/3/28.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController :URLSessionDataDelegate{


    func testURLSessionGetDataFromServer()  {
        initURLSession()
    }
    func initURLSession()  {
        showView = UITextView(frame: CGRect(x: 10, y: 40, width: view.bounds.width - 20, height: 100))
        showView.backgroundColor = UIColor.lightGray
        view.addSubview(showView)
        
        let url = URL(string: "https://996.icu/manifest.json")
        
        totaldata = NSMutableData()
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 2)
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        if nil == session {
            return
        }
        let task = session.dataTask(with: request)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
       totaldata.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("=====  Finish Downloading data! =====")
        if let err = error {
            print("error : \(err.localizedDescription)")
            return
        }
        let content = String(data: totaldata as Data, encoding: String.Encoding.utf8)
        totaldata = nil
        print("\(content!.debugDescription)")
        showView.performSelector(onMainThread: #selector(setter: UITextView.text), with: content, waitUntilDone: true)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        print("====  \(#function) =====")
    }
}
/*
 "{\n  \"name\": \"996.icu\",\n  \"short_name\": \"996.icu\",\n  \"start_url\": \"./index.html\",\n  \"display\": \"standalone\",\n  \"background_color\": \"#de335e\",\n  \"theme_color\": \"#de335e\"\n}\n"
 */
