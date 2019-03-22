//
//  extension.swift
//  TableViewDemo
//
//  Created by liulongyang on 2019/3/22.
//  Copyright © 2019 liulongyang. All rights reserved.
//

import Foundation
import UIKit
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    // Provideing the Number of Rows and Sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return numberOfRows[section]
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //Providing Cells, Headers, and Footers
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        cell.textLabel?.text = "Section \(indexPath.section) Cell : \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section) Header"
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Section \(section) Fotter"
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
            let rows = numberOfRows[indexPath.section]
            if rows > 0 {
                numberOfRows[indexPath.section] = rows - 1
            }
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
    
    //Confighre an Index
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionNames
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("title = \(title)")
        return 0
    }
    
//    func newLabelwithTitle(title: String) -> UILabel {
//        let label = UILabel()
//        label.text = title
//        label.backgroundColor = UIColor.clear
//        label.sizeToFit()
//        return label
//    }
//    func newheaderOrFooterWithText(text: String) -> UIView {
//        let label = newLabelwithTitle(title: text)
//        label.frame.origin.x += 10
//        label.frame.origin.y += 5
//        let resultFrame = CGRect(x: 0, y: 0, width: label.frame.size.width + 10, height: label.frame.size.height)
//        let view = UIView(frame: resultFrame)
//        view.addSubview(label)
//        return view
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        print("111")
//        return newheaderOrFooterWithText(text: "Section: \(section) Header")
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        print("222")
//        return newheaderOrFooterWithText(text: "Section: \(section) Footer")
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
}

