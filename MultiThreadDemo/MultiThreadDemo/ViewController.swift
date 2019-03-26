//
//  ViewController.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/25.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    public var exitThread : UIButton!
    public var thread: Thread!
    public var imageView : UIImageView!
    public var startDownloadImage : UIButton!
    public var account: Account!
    public var drawMoney : UIButton!
    public var savingAccount : SavingAccount!
    public var serialQueue : DispatchQueue!
    public var concurrentQueue : DispatchQueue!
    public var submitAsyncToSerialQueue : UIButton!
    public var submitAsyncToConcurrentQueue : UIButton!
    public var submitSyncToSerialQueue : UIButton!
    public var submitSyncToConcurrentQueue : UIButton!
    public var executeButton : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        testMultiThread()
        //        testExitThread()
        //        downloadImageByThread()
        //        testThreadPriority()
        //        testConcurrentDrawMoney()
        //        testProducersAndConsumers()
        //        testDispatchQueue()
        initNoticicationCentre()
    }
    
    
}

