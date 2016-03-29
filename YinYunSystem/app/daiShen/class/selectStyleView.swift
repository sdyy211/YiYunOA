//
//  selectStyleView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol selectProtocol{
    func getSelectStyle(style:String)
}

class selectStyleView: UIView,UITableViewDelegate,UITableViewDataSource{

    var tv = UITableView()
    var itemArry = NSArray()
    var delegate:selectProtocol?
    override func drawRect(rect: CGRect) {
        tv.delegate = self
        tv.dataSource = self
        tv.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        self.addSubview(tv)
        tv.reloadData()
    }
    
        //MARK: UItableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = itemArry.objectAtIndex(indexPath.row) as? String
        cell.textLabel?.textAlignment  = NSTextAlignment.Center
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.getSelectStyle(itemArry.objectAtIndex(indexPath.row) as! String)
        self.removeFromSuperview()
    }
    
    
}
