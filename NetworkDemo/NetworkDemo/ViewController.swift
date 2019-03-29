//
//  ViewController.swift
//  NetworkDemo
//
//  Created by liulongyang on 2019/3/27.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //check network status
    var siteField : UITextField!
    
    var session : URLSession!
    var totaldata : NSMutableData!
    var showView : UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //initCheckNetworkViews()
        testURLSessionGetDataFromServer()
    }
}

