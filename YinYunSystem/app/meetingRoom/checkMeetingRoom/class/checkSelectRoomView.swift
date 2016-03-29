//
//  checkSelectRoomView.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//
//   选择处室的列表
//
//
import UIKit
@objc protocol selectRoomDelegate{
    func getRoomName(roomName:String)
}
class checkSelectRoomView: UIView,UITableViewDataSource,UITableViewDelegate{

    var itemArray = NSMutableArray()
    var tableView = UITableView()
    var cellHeight:CGFloat = 30
    var delegate = selectRoomDelegate?()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: CGRectMake(0, 0,CGRectGetWidth(self.frame),20))
        tableView.delegate = self;
        tableView.dataSource = self;
        self.addSubview(tableView)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
        let str = itemArray.objectAtIndex(indexPath.row) as? String
        cell.textLabel?.text = str! + "室"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roomName = itemArray.objectAtIndex(indexPath.row) as! String
        delegate?.getRoomName(roomName)
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        let height = CGFloat(itemArray.count) * cellHeight
        tableView.frame = CGRectMake(0, 0,CGRectGetWidth(self.frame),height)
        tableView.reloadData()
    }

}
