//
//  multiThread.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    @objc func run()  {
        for i in 0...10 {
            print("----------- curent thread = \(String(describing: Thread.current.name))   number = \(i) ----------")
        }
    }
    func testMultiThread(){
        Thread.main.name = "main"
        for i in 1...10 {
            let thread = Thread(target: self, selector: #selector(ViewController.run), object: nil)
            thread.name = "thread\(i)"
            print("=========== curent thread = \(String(describing: Thread.current.name))   child thread = \(String(describing: thread.name)) ==========")
            //Thread.detachNewThreadSelector(#selector(ViewController.run), toTarget: self, with: nil)
            thread.start()
        }
    }
}
/*
 testMultiThread():
 =========== curent thread = Optional("main")   child thread = Optional("thread1") ==========
 =========== curent thread = Optional("main")   child thread = Optional("thread2") ==========
 =========== curent thread = Optional("main")   child thread = Optional("thread3") ==========
 =========== curent thread = Optional("main")   child thread = Optional("thread4") ==========
 =========== curent thread = Optional("main")   child thread = Optional("thread5") ==========
 =========== curent thread = Optional("main")   child thread = Optional("thread6") ==========
 ----------- curent thread = Optional("thread1")   number = 0 ----------
 ----------- curent thread = Optional("thread1")   number = 1 ----------
 ----------- curent thread = Optional("thread2")   number = 0 ----------
 =========== curent thread = Optional("main")   child thread = Optional("thread7") ==========
 ----------- curent thread = Optional("thread2")   number = 1 ----------
 ----------- curent thread = Optional("thread1")   number = 2 ----------
 ----------- curent thread = Optional("thread2")   number = 2 ----------
 ----------- curent thread = Optional("thread1")   number = 3 ----------
 ----------- curent thread = Optional("thread3")   number = 0 ----------
 =========== curent thread = Optional("main")   child thread = Optional("thread8") ==========
 ----------- curent thread = Optional("thread2")   number = 3 ----------
 ----------- curent thread = Optional("thread3")   number = 1 ----------
 ----------- curent thread = Optional("thread3")   number = 2 ----------
 ----------- curent thread = Optional("thread1")   number = 4 ----------
 ----------- curent thread = Optional("thread6")   number = 0 ----------
 ----------- curent thread = Optional("thread2")   number = 4 ----------
 ----------- curent thread = Optional("thread4")   number = 0 ----------
 =========== curent thread = Optional("main")   child thread = Optional("thread9") ==========
 ----------- curent thread = Optional("thread5")   number = 0 ----------
 ----------- curent thread = Optional("thread6")   number = 1 ----------
 =========== curent thread = Optional("main")   child thread = Optional("thread10") ==========
 ----------- curent thread = Optional("thread8")   number = 0 ----------
 ----------- curent thread = Optional("thread2")   number = 5 ----------
 ----------- curent thread = Optional("thread8")   number = 1 ----------
 ----------- curent thread = Optional("thread2")   number = 6 ----------
 ----------- curent thread = Optional("thread2")   number = 7 ----------
 ----------- curent thread = Optional("thread2")   number = 8 ----------
 ----------- curent thread = Optional("thread2")   number = 9 ----------
 ----------- curent thread = Optional("thread3")   number = 3 ----------
 ----------- curent thread = Optional("thread6")   number = 2 ----------
 ----------- curent thread = Optional("thread3")   number = 4 ----------
 ----------- curent thread = Optional("thread7")   number = 0 ----------
 ----------- curent thread = Optional("thread3")   number = 5 ----------
 ----------- curent thread = Optional("thread7")   number = 1 ----------
 ----------- curent thread = Optional("thread1")   number = 5 ----------
 ----------- curent thread = Optional("thread7")   number = 2 ----------
 ----------- curent thread = Optional("thread3")   number = 6 ----------
 ----------- curent thread = Optional("thread9")   number = 0 ----------
 ----------- curent thread = Optional("thread3")   number = 7 ----------
 ----------- curent thread = Optional("thread3")   number = 8 ----------
 ----------- curent thread = Optional("thread9")   number = 1 ----------
 ----------- curent thread = Optional("thread10")   number = 0 ----------
 ----------- curent thread = Optional("thread10")   number = 1 ----------
 ----------- curent thread = Optional("thread8")   number = 2 ----------
 ----------- curent thread = Optional("thread4")   number = 1 ----------
 ----------- curent thread = Optional("thread4")   number = 2 ----------
 ----------- curent thread = Optional("thread2")   number = 10 ----------
 ----------- curent thread = Optional("thread4")   number = 3 ----------
 ----------- curent thread = Optional("thread4")   number = 4 ----------
 ----------- curent thread = Optional("thread4")   number = 5 ----------
 ----------- curent thread = Optional("thread4")   number = 6 ----------
 ----------- curent thread = Optional("thread4")   number = 7 ----------
 ----------- curent thread = Optional("thread4")   number = 8 ----------
 ----------- curent thread = Optional("thread8")   number = 3 ----------
 ----------- curent thread = Optional("thread8")   number = 4 ----------
 ----------- curent thread = Optional("thread6")   number = 3 ----------
 ----------- curent thread = Optional("thread1")   number = 6 ----------
 ----------- curent thread = Optional("thread6")   number = 4 ----------
 ----------- curent thread = Optional("thread1")   number = 7 ----------
 ----------- curent thread = Optional("thread7")   number = 3 ----------
 ----------- curent thread = Optional("thread3")   number = 9 ----------
 ----------- curent thread = Optional("thread7")   number = 4 ----------
 ----------- curent thread = Optional("thread3")   number = 10 ----------
 ----------- curent thread = Optional("thread7")   number = 5 ----------
 ----------- curent thread = Optional("thread7")   number = 6 ----------
 ----------- curent thread = Optional("thread7")   number = 7 ----------
 ----------- curent thread = Optional("thread7")   number = 8 ----------
 ----------- curent thread = Optional("thread9")   number = 2 ----------
 ----------- curent thread = Optional("thread5")   number = 1 ----------
 ----------- curent thread = Optional("thread9")   number = 3 ----------
 ----------- curent thread = Optional("thread5")   number = 2 ----------
 ----------- curent thread = Optional("thread9")   number = 4 ----------
 ----------- curent thread = Optional("thread9")   number = 5 ----------
 ----------- curent thread = Optional("thread9")   number = 6 ----------
 ----------- curent thread = Optional("thread9")   number = 7 ----------
 ----------- curent thread = Optional("thread9")   number = 8 ----------
 ----------- curent thread = Optional("thread9")   number = 9 ----------
 ----------- curent thread = Optional("thread9")   number = 10 ----------
 ----------- curent thread = Optional("thread10")   number = 2 ----------
 ----------- curent thread = Optional("thread10")   number = 3 ----------
 ----------- curent thread = Optional("thread10")   number = 4 ----------
 ----------- curent thread = Optional("thread4")   number = 9 ----------
 ----------- curent thread = Optional("thread4")   number = 10 ----------
 ----------- curent thread = Optional("thread10")   number = 5 ----------
 ----------- curent thread = Optional("thread10")   number = 6 ----------
 ----------- curent thread = Optional("thread8")   number = 5 ----------
 ----------- curent thread = Optional("thread10")   number = 7 ----------
 ----------- curent thread = Optional("thread8")   number = 6 ----------
 ----------- curent thread = Optional("thread6")   number = 5 ----------
 ----------- curent thread = Optional("thread7")   number = 9 ----------
 ----------- curent thread = Optional("thread7")   number = 10 ----------
 ----------- curent thread = Optional("thread5")   number = 3 ----------
 ----------- curent thread = Optional("thread5")   number = 4 ----------
 ----------- curent thread = Optional("thread10")   number = 8 ----------
 ----------- curent thread = Optional("thread1")   number = 8 ----------
 ----------- curent thread = Optional("thread8")   number = 7 ----------
 ----------- curent thread = Optional("thread1")   number = 9 ----------
 ----------- curent thread = Optional("thread10")   number = 9 ----------
 ----------- curent thread = Optional("thread5")   number = 5 ----------
 ----------- curent thread = Optional("thread10")   number = 10 ----------
 ----------- curent thread = Optional("thread8")   number = 8 ----------
 ----------- curent thread = Optional("thread1")   number = 10 ----------
 ----------- curent thread = Optional("thread6")   number = 6 ----------
 ----------- curent thread = Optional("thread5")   number = 6 ----------
 ----------- curent thread = Optional("thread8")   number = 9 ----------
 ----------- curent thread = Optional("thread6")   number = 7 ----------
 ----------- curent thread = Optional("thread5")   number = 7 ----------
 ----------- curent thread = Optional("thread8")   number = 10 ----------
 ----------- curent thread = Optional("thread6")   number = 8 ----------
 ----------- curent thread = Optional("thread5")   number = 8 ----------
 ----------- curent thread = Optional("thread5")   number = 9 ----------
 ----------- curent thread = Optional("thread6")   number = 9 ----------
 ----------- curent thread = Optional("thread5")   number = 10 ----------
 ----------- curent thread = Optional("thread6")   number = 10 ----------
 */
