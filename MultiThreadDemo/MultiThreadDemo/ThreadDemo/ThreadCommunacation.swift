//
//  ThreadCommunacation.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit

class SavingAccount : Account {
    var condition : NSCondition!
    var flag : Bool = true
    override init(_ accountNumber: String, _ balance: Double) {
        self.condition = NSCondition()
        super.init(accountNumber, balance)
    }
    override func draw(_ drawAmmount: Double) {
        condition.lock()
        if !flag {
            condition.wait()
        } else {
            print("Thread name = \(Thread.current.name ?? "" ) sucess to draw : \(drawAmmount)")
            self.balance -= drawAmmount
            print("balance = \(self.balance)")
            flag = false
            condition.broadcast()
        }
        condition.unlock()
    }
    
    func deposit(money : Double)  {
        condition.lock()
        if flag {
            condition.wait()
        } else {
            print("Thread name = \(Thread.current.name ?? "" ) sucess to deposit : \(money)")
            self.balance += money
            print("balance = \(self.balance)")
            flag = true
            condition.broadcast()
        }
        condition.unlock()
    }
}

extension ViewController {
    func testProducersAndConsumers()  {
        savingAccount = SavingAccount("123456", 1000.0)
        drawMoney = UIButton(type: .system)
        drawMoney.frame = CGRect(x: 10, y: 20, width: self.view.bounds.width - 20 , height: 30)
        drawMoney.setTitle("Cocurrent Draw Money", for: .normal)
        drawMoney.addTarget(self, action: #selector(ViewController.depositThenDraw), for: .touchUpInside)
        view.addSubview(drawMoney)
    }
    
    @objc func depositThenDraw()  {
        for i in 0..<3 {
            let thread = Thread(target: self, selector: #selector(ViewController.depositMoneyMethod(money:)), object: 800)
            thread.name = "Deposit thread\(i)"
            thread.start()
        }
        let thread = Thread(target: self, selector: #selector(ViewController.drawMoneyMethod(money:)), object: 800)
        thread.name = "draw thread"
        thread.start()
    }
    
    @objc func depositMoneyMethod(money: NSNumber)  {
        for _ in 0..<10 {
            savingAccount.deposit(money: money.doubleValue)
        }
    }
    @objc func drawMoneyMethod(money: NSNumber)  {
        for _ in 0..<30 {
            savingAccount.draw(money.doubleValue)
        }
    }
}

/*
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread0 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread1 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread1 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread2 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread2 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread2 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread0 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread2 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 Thread name = Deposit thread0 sucess to deposit : 800.0
 balance = 1000.0
 Thread name = draw thread sucess to draw : 800.0
 balance = 200.0
 */
