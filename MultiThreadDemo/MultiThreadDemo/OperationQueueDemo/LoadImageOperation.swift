//
//  LoadImageOperation.swift
//  MultiThreadDemo
//
//  Created by liulongyang on 2019/3/27.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
class LoadImageOperation: Operation {
    var url : URL!
    var imageView : UIImageView!
    
    init(filePath : String,imageView : UIImageView) {
        self.url = URL(fileURLWithPath: filePath)
        self.imageView = imageView
    }
    
    override func main() {
        var data : Data? = nil
        Thread.sleep(forTimeInterval: 2)
        do {
            data = try Data(contentsOf: url)
        } catch {
            print("error : \(error.localizedDescription)")
        }
        if let imageData = data {
            let image = UIImage(data: imageData)
            self.perform(#selector(LoadImageOperation.updateUI(image:)), on: Thread.main, with: image, waitUntilDone: false)
        } else {
            print("Load image error!")
        }
    }
    @objc func updateUI(image : UIImage)  {
        self.imageView.image = image
    }
}

extension ViewController {
    func testImplementOperation()  {
        initOperationQueueDemo()
        addTargetForLoadImage(action: #selector(ViewController.onLoadImagePressed2))
    }
    @objc func onLoadImagePressed2()  {
        let operation = LoadImageOperation(filePath: "/Users/liulongyang/Documents/GitHub/iOS/StateLab/StateLab/smile.png", imageView: imageView)
        operationQueue.addOperation(operation)
    }
}
