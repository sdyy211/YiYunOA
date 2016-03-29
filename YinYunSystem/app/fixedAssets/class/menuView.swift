//
//  menuView.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
protocol menuDelegate
{
    func passSheBei(name:String)
}
class menuView: UIView,UITableViewDataSource,UITableViewDelegate {
   
    var tv:UITableView = UITableView()
    var delegate:menuDelegate?
    var itemAry:NSArray = NSArray(objects: "设备一","设备2","设备3","设备54","设备55","设备12","设备46","设备78","设备45","设备45")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        tv.frame = CGRectMake(0, 0, CGRectGetWidth(frame),CGRectGetHeight(frame))
        tv.delegate = self
        tv.dataSource = self
        self.addSubview(tv)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemAry.count;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:.Default, reuseIdentifier:"mycell")
        cell.textLabel?.text = itemAry.objectAtIndex(indexPath.row) as? String
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let name:String = itemAry.objectAtIndex(indexPath.row) as! String
        delegate?.passSheBei(name)
        self.removeFromSuperview()
    }
}
