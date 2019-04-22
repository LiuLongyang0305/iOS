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
    
    lazy var session : URLSession! = {
        let configuration = URLSessionConfiguration.default
         return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    var totaldata  : NSMutableData! = NSMutableData()
    var showView : UITextView!
    public var url = URL(string: "https://996.icu/manifest.json")
    public lazy  var sessionWithDetail : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //initCheckNetworkViews()
       //testURLSessionGetDataFromServer()
        testUploadDataToServer()
    }
}

