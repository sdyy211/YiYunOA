//
//  yongZhangAuditVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yongZhangAuditVController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tv: UITableView!
    
    //待审
    //通过 bid=4869C6FA-EB4D-41B2-B10F-32E962E4823B flag=1
    var url = "http://172.16.8.250:8085/Cachet/JShenHeCachet"
    //退回 bid=4869C6FA-EB4D-41B2-B10F-32E962E4823B flag=0
    var url2 = "http://172.16.8.250:8085/Cachet/JShenHeCachet"
    
    // 已审批 http://172.16.8.250:8085/Cachet/CheckList?curpage=0&uname=&zt=1
    
    
   
    var itemArry:NSArray = ["待审","已审"]
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    var titleStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftItem()
        self.automaticallyAdjustsScrollViewInsets = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = color
        
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
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
            titleStr = "用章待审"
            self.performSegueWithIdentifier("pushYZPending", sender: self)
        }else if(indexPath.row == 1)
        {
            titleStr = "用章已审"
            self.performSegueWithIdentifier("pushYZHasbeen", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(titleStr == "用章待审")
        {
            let channel:yongZhangPendingVController = segue.destinationViewController as! yongZhangPendingVController
            channel.title = titleStr
        }else{
            let channel:yongZhangHasbeenVController = segue.destinationViewController as! yongZhangHasbeenVController
            channel.title = titleStr
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
