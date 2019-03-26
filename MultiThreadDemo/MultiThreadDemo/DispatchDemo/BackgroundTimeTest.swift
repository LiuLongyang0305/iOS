//
//  BackgroundTimeTest.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    func initNoticicationCentre()  {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.enterBack), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func enterBack()  {
        let app = UIApplication.shared
        var backtaskId = UIBackgroundTaskIdentifier(rawValue: 0)
         backtaskId = app.beginBackgroundTask(withName: "BackgroundTask", expirationHandler: {
            print("Havn't complete the task with three minutes!")
            app.endBackgroundTask(backtaskId)
        })
        if backtaskId == UIBackgroundTaskIdentifier.invalid {
            print("Current iOS version don't support background task!")
            return
        }
        print("Apply for background task time remaining \(app.backgroundTimeRemaining)")
        DispatchQueue.global(qos: .default).async {
            for i in 0...9{
                Thread.sleep(forTimeInterval:5 )
                print("Background task fnished : \(10 * (i + 1))%")
            }
            DispatchQueue.main.sync {
                print("Background task time remaining \(app.backgroundTimeRemaining)")
            }
            app.endBackgroundTask(backtaskId)
        }
    }
}
/*
 Apply for background task time remaining 179.96835736199864
 Background task fnished : 10%
 Background task fnished : 20%
 Background task fnished : 30%
 Background task fnished : 40%
 Background task fnished : 50%
 Background task fnished : 60%
 Background task fnished : 70%
 Background task fnished : 80%
 Background task fnished : 90%
 Background task fnished : 100%
 Background task time remaining 129.9426286520029
 */
