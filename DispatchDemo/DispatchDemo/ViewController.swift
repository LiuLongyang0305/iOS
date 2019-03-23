//
//  ViewController.swift
//  DispatchDemo
//
//  Created by liulongyang on 2019/3/22.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func dowork(_ sender: Any) {
        let startTime = Date()
        self.resultsTextView.text = ""
        startButton.isEnabled = false
        spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let fetchData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchData)
            var firstResult : String!
            var secondResult : String!
            let group = DispatchGroup()
            queue.async(group: group, execute: DispatchWorkItem(block: {
                firstResult = self.caculateFirstResult(processedData)
            }))
            queue.async(group: group, execute: DispatchWorkItem(block: {
                secondResult = self.caculateSecondResult(processedData)
            }))
            
            group.notify(queue: queue, work: DispatchWorkItem(block: {
                var  resultsSummary = "First: \(String(describing: firstResult)),\nSecond: \(String(describing: secondResult))"
                let endTime = Date()
                resultsSummary += "\nCompleted in \(Int(endTime.timeIntervalSince(startTime))) seconds!"
                DispatchQueue.main.async {
                    self.resultsTextView.text = resultsSummary
                    self.startButton.isEnabled = true
                    self.spinner.stopAnimating()
                }
            }))
        }
    }
    
    func fetchSomethingFromServer() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "Hello, here!"
    }
    func processData(_ data : String) -> String {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }
    func caculateFirstResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars : \(data.count)"
    }
    func caculateSecondResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
}

