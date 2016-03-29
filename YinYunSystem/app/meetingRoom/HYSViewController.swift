//
//  HYSViewController.swift
//  YinYunSystem
//  会议室系统页面
//  Created by 魏辉 on 16/1/13.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class HYSViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tv: UITableView!
    var itemArry = NSMutableArray(objects: "查看会议室","我的会议室")
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
//    var color = UIColor.whiteColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会议室管理"
        tv.delegate = self
        tv.dataSource = self;
        tv.backgroundColor = color
        addLeftItem()
    }
    func addLeftItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,12, 20))
        btn1.setBackgroundImage(UIImage(named: "7"), forState: UIControlState.Normal)
        btn1.addTarget(self, action: Selector("letfItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.leftBarButtonItem = item2
    }
    func letfItemAction(send:UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: tableviewdelegate 和 delegatedatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
        cell.textLabel?.text = itemArry.objectAtIndex(indexPath.row) as? String
        cell.imageView?.image = UIImage(named: "1")
        let image = UIImageView(image: UIImage(named: "10"))
        image.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)-20,15, 10, 20)
        cell.addSubview(image)
        cell.backgroundColor = color
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            self.performSegueWithIdentifier("pushCheck", sender: self)
        }else if(indexPath.row == 1)
        {
            self.performSegueWithIdentifier("pushMySelf", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
