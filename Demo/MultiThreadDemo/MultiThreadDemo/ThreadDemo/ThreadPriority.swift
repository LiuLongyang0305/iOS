//
//  ThreadPriority.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation

extension ViewController {
    func testThreadPriority()  {
        print("UI thread priority = \(Thread.current.threadPriority)")
        let threadA = Thread(target: self, selector: #selector(ViewController.run), object: nil)
        threadA.name = "threadA"
        print("ThreadA priority = \(Thread.current.threadPriority)")
        threadA.threadPriority = 0.05
        
        let threadB = Thread(target: self, selector: #selector(ViewController.run), object: nil)
        threadB.name = "threadB"
        print("ThreadB priority = \(Thread.current.threadPriority)")
        threadB.threadPriority = 1.0
        
        threadA.start()
        threadB.start()
    }
}

/*
 UI thread priority = 0.5
 ThreadA priority = 0.5
 ThreadB priority = 0.5
 ----------- curent thread = Optional("threadB")   number = 0 ----------
 ----------- curent thread = Optional("threadA")   number = 0 ----------
 ----------- curent thread = Optional("threadB")   number = 1 ----------
 ----------- curent thread = Optional("threadA")   number = 1 ----------
 ----------- curent thread = Optional("threadB")   number = 2 ----------
 ----------- curent thread = Optional("threadB")   number = 3 ----------
 ----------- curent thread = Optional("threadB")   number = 4 ----------
 ----------- curent thread = Optional("threadB")   number = 5 ----------
 ----------- curent thread = Optional("threadB")   number = 6 ----------
 ----------- curent thread = Optional("threadB")   number = 7 ----------
 ----------- curent thread = Optional("threadA")   number = 2 ----------
 ----------- curent thread = Optional("threadB")   number = 8 ----------
 ----------- curent thread = Optional("threadB")   number = 9 ----------
 ----------- curent thread = Optional("threadA")   number = 3 ----------
 ----------- curent thread = Optional("threadB")   number = 10 ----------
 ----------- curent thread = Optional("threadA")   number = 4 ----------
 ----------- curent thread = Optional("threadA")   number = 5 ----------
 ----------- curent thread = Optional("threadA")   number = 6 ----------
 ----------- curent thread = Optional("threadA")   number = 7 ----------
 ----------- curent thread = Optional("threadA")   number = 8 ----------
 ----------- curent thread = Optional("threadA")   number = 9 ----------
 ----------- curent thread = Optional("threadA")   number = 10 ----------
 
 */
