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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        testMultiThread()
        //        testExitThread()
        //        downloadImageByThread()
//        testThreadPriority()
//        testConcurrentDrawMoney()
        testProducersAndConsumers() 
    }
    
    
}

