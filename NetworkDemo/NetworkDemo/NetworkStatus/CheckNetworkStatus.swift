//
//  CheckNetworkStatus.swift
//  NetworkDemo
//
//  Created by liulongyang on 2019/3/28.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
import Reachability
extension ViewController {
    func initCheckNetworkViews() {
        let viewWidth = view.bounds.width
        let label = UILabel(frame: CGRect(x: 10, y: 80, width: 80, height: 30))
        label.text = "TargetSite:"
        
        siteField = UITextField(frame: CGRect(x: 85, y: 80, width: viewWidth - 95, height: 30))
        siteField.borderStyle = .roundedRect
        siteField.autocapitalizationType = .none
        
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 10, y: 150 , width: Int(viewWidth - 20), height: 30)
        btn.setTitle( "Test Network", for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(ViewController.testNetworkStatus(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        self.view.addSubview(label)
        self.view.addSubview(siteField)
    }
    
    @objc func testNetworkStatus(sender : AnyObject)  {
        let site = siteField.text
        let reach = Reachability(hostname: site!)
        if reach == nil {
            return
        }
        
        switch reach?.currentReachabilityString {
        case  "WiFi":
            showAlert(msg: "WiFi")
        case  "No Connection":
            showAlert(msg: "No connection")
        case  "Cellular":
            showAlert(msg:"3G/4G")
        default:
            break
        }
    }
    func showAlert(msg : String)  {
        let alert = UIAlertController(title: "Network Status", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func checkNetworkStatus() {
        initCheckNetworkViews()
    }
}
