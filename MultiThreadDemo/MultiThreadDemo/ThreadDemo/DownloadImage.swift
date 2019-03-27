//
//  DownloadImage.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/26.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func initView() {
        let bounds = view.bounds
        imageView = UIImageView(frame: CGRect(x: 10, y: 160, width: bounds.width - 20, height: 200))
        imageView.contentMode = .center
        
        startDownloadImage = UIButton(type: .system)
        startDownloadImage.frame = CGRect(x: 10, y: 155, width: bounds.width - 20, height: 40)
        startDownloadImage.addTarget(self, action: #selector(ViewController.onStartDownloadImagePredded), for: .touchUpInside)
        startDownloadImage.setTitle("Download", for: .normal )
        view.addSubview(startDownloadImage)
        view.addSubview(imageView)
    }
    @objc func downloadImageFrom(_ url : String)  {
        
        var data : Data? = nil
        do {
            try data = Data(contentsOf: URL(fileURLWithPath: url))
        } catch  {
            print("error : \(error)")
        }
        if let data = data {
            let image = UIImage(data: data)
            if let realImage = image {
                self.performSelector(onMainThread: #selector(ViewController.updateUI(image:)), with: realImage, waitUntilDone: true)
            }
        }
    }
    @objc func updateUI(image : UIImage)  {
        imageView.image = image
    }
    @objc func onStartDownloadImagePredded()  {
        //        let url = "https://github.com/LiuLongyang0305/iOS/blob/master/StateLab/StateLab/smile.png"
        let url = "https://github.com/LiuLongyang0305/iOS/blob/master/README.md"
        let thread = Thread(target: self, selector:#selector(ViewController.downloadImageFrom(_:)) , object: url)
        thread.start()
    }
    
    func testDownloadImageByThread() {
        initView()
    }
}
/*
 error : Error Domain=NSCocoaErrorDomain Code=260 "The file “README.md” couldn’t be opened because there is no such file." UserInfo={NSFilePath=/https:/github.com/LiuLongyang0305/iOS/blob/master/README.md, NSUnderlyingError=0x600002fc8d50 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
 */
