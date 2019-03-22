//
//  ViewController.swift
//  TableViewDemo
//
//  Created by liulongyang on 2019/3/22.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var tableView : UITableView?
    var numberOfRows = [3,5,8]
    var sectionNames = ["Section 0","Section 1","Section 2"]
    var allItems : [NSDate] = [NSDate]()
    var refreshControl : UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView = UITableView(frame: view.bounds, style: .plain)
        if let table = tableView {
            tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
            tableView?.dataSource = self
            tableView?.delegate = self
            
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(handleRefresh(sender:)), for: .valueChanged)
            tableView?.addSubview(refreshControl!)
            
            view.addSubview(table)
        }
    }
    
    @objc  func handleRefresh(sender: AnyObject)  {
        let queue = DispatchQueue.main
        let time = DispatchTime(uptimeNanoseconds: NSEC_PER_SEC)
        queue.asyncAfter(deadline: time) {
            self.allItems.append(NSDate())
            self.refreshControl?.endRefreshing()
            let indexOfNewRow =  IndexPath(row: self.allItems.count - 1, section: 0)
            self.tableView?.insertRows(at: [indexOfNewRow], with: UITableView.RowAnimation.automatic)
        }
    }
}

