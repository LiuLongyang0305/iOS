//
//  DispatchQueue.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    func testDispatchQueue()  {
        serialQueue = DispatchQueue(label: "Serial Queue")
        concurrentQueue = DispatchQueue(label: "Concurrent Queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        submitAsyncToSerialQueue = UIButton(type: .system)
        submitAsyncToSerialQueue.frame = CGRect(x: 10, y: 50, width: self.view.bounds.width - 20, height: 30)
        submitAsyncToSerialQueue.setTitle("Submit Async To Serial Queue", for: .normal)
        submitAsyncToSerialQueue.backgroundColor = UIColor.green
        submitAsyncToSerialQueue.addTarget(self, action: #selector(ViewController.serialAsync), for: .touchUpInside)
        
        submitAsyncToConcurrentQueue = UIButton(type: .system)
        submitAsyncToConcurrentQueue.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width - 20, height: 30)
        submitAsyncToConcurrentQueue.setTitle("Submit Async To Concurrent Queue", for: .normal)
        submitAsyncToConcurrentQueue.backgroundColor = UIColor.yellow
        submitAsyncToConcurrentQueue.addTarget(self, action: #selector(ViewController.concurrentAsync), for: .touchUpInside)
        
        
        submitSyncToSerialQueue = UIButton(type: .system)
        submitSyncToSerialQueue.frame = CGRect(x: 10, y: 150, width: self.view.bounds.width - 20, height: 30)
        submitSyncToSerialQueue.setTitle("Submit Sync To Serial Queue", for: .normal)
        submitSyncToSerialQueue.backgroundColor = UIColor.green
        submitSyncToSerialQueue.addTarget(self, action: #selector(ViewController.serialSync), for: .touchUpInside)
        
        submitSyncToConcurrentQueue = UIButton(type: .system)
        submitSyncToConcurrentQueue.frame = CGRect(x: 10, y: 200, width: self.view.bounds.width - 20, height: 30)
        submitSyncToConcurrentQueue.setTitle("Submit Sync To Concurrent Queue", for: .normal)
        submitSyncToConcurrentQueue.backgroundColor = UIColor.yellow
        submitSyncToConcurrentQueue.addTarget(self, action: #selector(ViewController.concurrentSync), for: .touchUpInside)
        
        executeButton = UIButton(type: .system)
        executeButton.frame = CGRect(x: 10, y: 250, width: self.view.bounds.width - 20, height: 30)
        executeButton.setTitle("Execute Several Times", for: .normal)
        executeButton.backgroundColor = UIColor.blue
        executeButton.addTarget(self, action: #selector(ViewController.execute), for: .touchUpInside)
        
        view.addSubview(submitAsyncToConcurrentQueue)
        view.addSubview(submitAsyncToSerialQueue)
        view.addSubview(submitSyncToConcurrentQueue)
        view.addSubview(submitSyncToSerialQueue)
        view.addSubview(executeButton)
    }
    
    @objc func serialAsync()  {
        serialQueue.async {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        serialQueue.async {
            for i in 1...10 {
                print("------- currend thread = \(Thread.current)    ------- number = \(i)")
            }
        }
    }
    @objc func concurrentAsync()  {
        concurrentQueue.async {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        concurrentQueue.async {
            for i in 1...10 {
                print("------- currend thread = \(Thread.current)    ------- number = \(i)")
            }
        }
    }
    @objc func serialSync()  {
        serialQueue.sync {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        serialQueue.sync {
            for i in 1...10 {
                print("------- currend thread = \(Thread.current)    ------- number = \(i)")
            }
        }
    }
    @objc func concurrentSync()  {
        concurrentQueue.sync {
            for i in 1...10 {
                print("======= currend thread = \(Thread.current)    ======= number = \(i)")
            }
        }
        concurrentQueue.sync {
            for i in 1...10 {
                print("------- currend thread = \(Thread.current)    ------- number = \(i)")
            }
        }
    }
    @objc func execute()  {
        executeSeveralTimes(times: 5)
    }
    func executeSeveralTimes(times : Int)  {
        DispatchQueue.concurrentPerform(iterations: times) { (val) in
            print("Execute time = \(val)")
        }
    }
}
/*
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 1
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 2
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 3
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 4
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 5
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 6
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 7
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 8
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 9
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 10
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 1
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 2
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 3
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 4
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 5
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 6
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 7
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 8
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 9
 ------- currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ------- number = 10
 
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 1
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 1
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 2
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 2
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 3
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 3
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 4
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 5
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 4
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 6
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 5
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 7
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 6
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 8
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 9
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 7
 ======= currend thread = <NSThread: 0x600001a021c0>{number = 3, name = (null)}    ======= number = 10
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 8
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 9
 ------- currend thread = <NSThread: 0x600001a11780>{number = 4, name = (null)}    ------- number = 10
 
 
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 1
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 2
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 3
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 4
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 5
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 6
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 7
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 8
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 9
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 10
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 1
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 2
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 3
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 4
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 5
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 6
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 7
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 8
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 9
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 10
 
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 1
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 2
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 3
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 4
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 5
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 6
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 7
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 8
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 9
 ======= currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ======= number = 10
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 1
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 2
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 3
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 4
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 5
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 6
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 7
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 8
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 9
 ------- currend thread = <NSThread: 0x60000271e8c0>{number = 1, name = main}    ------- number = 10
 
 Execute time = 3
 Execute time = 2
 Execute time = 0
 Execute time = 1
 Execute time = 4
 
 */
