//
//  Threadsynchronization.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit

class Account {
    var accountNumber: String
    var balance: Double
    var lock: NSLock!
    init(_ accountNumber: String, _ balance : Double) {
        self.accountNumber = accountNumber
        self.balance = balance
        self.lock = NSLock()
    }
    func draw(_ drawAmmount : Double)  {
        //        objc_sync_enter(self)
        lock.lock()
        if self.balance > drawAmmount {
            print("Thread name = \(Thread.current.name ?? "" ) sucess to draw : \(drawAmmount)")
            Thread.sleep(forTimeInterval: 0.1)
            self.balance -= drawAmmount
            print("balance = \(self.balance)")
        } else {
            print("Thread name = \(Thread.current.name ?? "" ) failed to draw because of  insufficient founds")
        }
        lock.unlock()
        //        objc_sync_exit(self)
    }
}

extension ViewController {
    func testConcurrentDrawMoney()  {
        account = Account("123456789", 1000.0)
        drawMoney = UIButton(type: .system)
        drawMoney.frame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20 , height: 30)
        drawMoney.setTitle("Cocurrent Draw Money", for: .normal)
        drawMoney.addTarget(self, action: #selector(ViewController.draw), for: .touchUpInside)
        view.addSubview(drawMoney)
    }
    @objc func draw()  {
        let thread1 = Thread(target: self, selector: #selector(ViewController.drawMoneyFromAccount(money:)), object: 800.0)
        thread1.name = "thread1"
        let thread2 = Thread(target: self, selector: #selector(ViewController.drawMoneyFromAccount(money:)), object: 800.0)
        thread2.name = "threa2"
        thread1.start()
        thread2.start()
    }
    @objc func drawMoneyFromAccount(money : NSNumber)  {
        account.draw(money.doubleValue)
    }
}
/*
 Thread name = thread1 sucess to draw : 800.0
 Thread name = threa2 sucess to draw : 800.0
 balance = -600.0
 balance = -600.0
 Solution1 :         objc_sync_enter(self)         objc_sync_exit(self)
 solution2 : NSLock()
 Thread name = thread1 sucess to draw : 800.0
 balance = 200.0
 Thread name = threa2 failed to draw because of  insufficient founds
 */
