//
//  LoadImage.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/27.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController {
    func initOperationQueueDemo()  {
        
        operationQueue = OperationQueue()

        let bounds = view.bounds
        imageView = UIImageView(frame: CGRect(x: 10, y: 160, width: bounds.width - 20, height: 200))
        imageView.contentMode = .center
        
        startDownloadImage = UIButton(type: .system)
        startDownloadImage.frame = CGRect(x: 10, y: 155, width: bounds.width - 20, height: 40)
        startDownloadImage.setTitle("Load Image", for: .normal )
        view.addSubview(startDownloadImage)
        view.addSubview(imageView)
    }
    func addTargetForLoadImage(action : Selector)  {
        startDownloadImage.addTarget(self, action: action, for: .touchUpInside)
    }
    func testLoadImageOnOperationQueue()  {
        initOperationQueueDemo()
        addTargetForLoadImage(action: #selector(ViewController.onLoadImagePressed))
    }
    @objc func onLoadImagePressed()  {
        let url = "/Users/liulongyang/Documents/GitHub/iOS/StateLab/StateLab/smile.png"
        var data : Data? = nil
        
        let operation = BlockOperation {
            Thread.sleep(forTimeInterval: 2)
            do {
                  data = try Data(contentsOf: URL(fileURLWithPath: url))
            } catch {
                print("error : \(error.localizedDescription)")
            }
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.perform(#selector(ViewController.updateUI(image:)), on: Thread.main, with: image, waitUntilDone: false)
            } else {
                print("Load image error!")
            }
        }
        operationQueue.addOperation(operation)
    }
    func updateUIAfterLoadImage(image : UIImage)  {
        imageView.image = image
    }
}
