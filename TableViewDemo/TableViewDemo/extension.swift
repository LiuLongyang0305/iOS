//
//  extension.swift
//  TableViewDemo
//
//  Created by liulongyang on 2019/3/22.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController : UITableViewDataSource{
    // Provideing the Number of Rows and Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nums.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Providing Cells, Headers, and Footers
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.textLabel?.text = "\(nums[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView?.setEditing(editing, animated: animated)
    }
    
    //Inserting or Deleting
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            nums.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Recording Table Rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Remove Row")
    }
    
    func configureDataSource() {
        generateNumbers()
        tableView?.reloadData()
    }
    func generateNumbers()  {
        nums.removeAll()
        for _ in 0..<10 {
            nums.append(Int(arc4random_uniform(100)))
        }
    }
}

extension ViewController : UITableViewDelegate {
    
    func newLabelwithTitle(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.backgroundColor = UIColor.green
        label.sizeToFit()
        return label
    }
    func newheaderOrFooterWithText(text: String) -> UIView {
        let label = newLabelwithTitle(title: text)
        label.frame.origin.x += 10
        label.frame.origin.y += 5
        let resultFrame = CGRect(x: 0, y: 0, width: label.frame.size.width + 10, height: label.frame.size.height)
        let view = UIView(frame: resultFrame)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return newheaderOrFooterWithText(text: "Section: \(section) Header")
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return newheaderOrFooterWithText(text: "Section: \(section) Footer")
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}


