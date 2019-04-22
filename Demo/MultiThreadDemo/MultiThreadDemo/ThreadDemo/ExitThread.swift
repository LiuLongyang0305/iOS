//
//  ExitThread.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    func testExitThread()  {
        exitThread = UIButton(type: .system)
        exitThread.frame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20 , height: 30)
        exitThread.setTitle("Exit Thread", for: .normal)
        exitThread.addTarget(self, action: #selector(ViewController.cancelThread), for: .touchUpInside)
        view.addSubview(exitThread)
        
        thread = Thread.init(target: self, selector: #selector(ViewController.exitThreadRun), object: nil)
        thread.name = "WillExitThread"
        thread.start()
    }
    @objc func exitThreadRun()  {
        for i in 0...100 {
            if Thread.current.isCancelled {
                Thread.exit()
            }
            print("current thread name = \(String(describing: Thread.current.name))  ----> number = \(i)")
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    @objc func cancelThread()  {
        thread.cancel()
    }
}
/*
 current thread name = Optional("WillExitThread")  ----> number = 0
 current thread name = Optional("WillExitThread")  ----> number = 1
 current thread name = Optional("WillExitThread")  ----> number = 2
 current thread name = Optional("WillExitThread")  ----> number = 3
 current thread name = Optional("WillExitThread")  ----> number = 4
 current thread name = Optional("WillExitThread")  ----> number = 5
 current thread name = Optional("WillExitThread")  ----> number = 6
 */
