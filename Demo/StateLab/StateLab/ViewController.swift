//
//  ViewController.swift
//  StateLab
//
//  Created by liulongyang on 2019/3/23.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var label : UILabel!
    private var animate = false
    private var smile : UIImage!
    private var smileView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let bounds = view.bounds
        let labelFrame = CGRect(origin: CGPoint(x: bounds.origin.x, y: bounds.midY - 50), size: CGSize(width: bounds.size.width, height: 100))
        label = UILabel(frame: labelFrame)
        label.font = UIFont(name: "Helvetica", size: 70)
        label.text = "Bazinga"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let smileFrame = CGRect(origin: CGPoint(x: bounds.midX - 42, y: bounds.midY / 2 - 42), size: CGSize(width: 84, height: 84))
        smileView = UIImageView(frame: smileFrame)
        smileView.contentMode = .center
        let smilePath = Bundle.main.path(forResource: "smile", ofType: "png")!
        smile = UIImage(contentsOfFile: smilePath)
        smileView.image = smile
        
        view.addSubview(smileView)
        view.addSubview(label)
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.applicationwillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)


    }

    func rotateLabelDown()  {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }) { (Bool) in
            self.rotateLabelUp()
        }
    }

    func rotateLabelUp()  {
        UIView.animate(withDuration: 0.5, animations: {
            self.label.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        }) { (Bool) in
            if self.animate {
                self.rotateLabelDown()
            }
        }
    }
    @objc func applicationWillResignActive()  {
        print("VC: \(#function)")
        animate = true
    }
    @objc func applicationDidBecomeActive()  {
        print("VC: \(#function)")
        animate = true
        rotateLabelDown()
    }
    @objc func applicationDidEnterBackground()  {
        print("VC: \(#function)")
        self.smile = nil
        self.smileView.image = nil
        animate = true
    }
    @objc func applicationwillEnterForeground()  {
        print("VC: \(#function)")
        let smilePath = Bundle.main.path(forResource: "smile", ofType: "png")!
        smile = UIImage(contentsOfFile: smilePath)
        smileView.image = smile
    }
}

