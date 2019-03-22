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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView = UITableView(frame: view.bounds, style: .plain)
        if let table = tableView {
            tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
            tableView?.dataSource = self
            view.addSubview(table)
        }
    }
}

