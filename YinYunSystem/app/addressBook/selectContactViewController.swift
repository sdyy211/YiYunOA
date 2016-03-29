//
//  selectContactViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol selectContactProtocol{
    func getSelectData(array:NSMutableArray)
}

class selectContactViewController: UITableViewController,HttpProtocol{
    
    var  url = "/Mobile/Mobile/JContacts"
    var itemArray:NSMutableArray = NSMutableArray()
    var titleArray:NSArray = NSArray()
    var selectFlagArray = NSMutableArray()
    var selectPeopleArray = NSMutableArray()
    var dataDic:NSDictionary = NSDictionary()
    var request = HttpRequest()
    var delegate = selectContactProtocol?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "选择联系人"
       
//        loadDataMethod()
        addLeftItem()
        addRightItem()
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
    func addRightItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,50	, 30))
        btn1.setTitle("确定", forState: UIControlState.Normal)
        btn1.addTarget(self, action: Selector("rightBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
    }
    func rightBtnAction(send:UIButton)
    {
        if(selectFlagArray.count > 0)
        {
            for(var i = 0;i < selectFlagArray.count;++i)
            {
                let str =  titleArray.objectAtIndex(i) as! String
                let ary = dataDic.objectForKey(str) as! NSArray
                let flagAry = selectFlagArray.objectAtIndex(i) as! NSArray
                for(var j = 0;j < flagAry.count;++j)
                {
                    let flag = flagAry.objectAtIndex(j) as! String
                    if(flag == "1")
                    {
                        let data = ary.objectAtIndex(j) as! NSDictionary
                        selectPeopleArray.addObject(data)
                    }
                }
            }
        }
        delegate!.getSelectData(selectPeopleArray)
        self.navigationController?.popViewControllerAnimated(true)
//        print("selectPeopleArray = \(selectPeopleArray)")
//        for(var i = 0;i < selectPeopleArray.count;++i)
//        {
//            let dic = selectPeopleArray.objectAtIndex(i) as! NSDictionary
//            let str = dic.objectForKey("U_Name")
//            print("str = \(str)")
//        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadDataMethod()
    }
    func loadDataMethod()
    {
        let bodyStr = NSString(format: "page=1&rows=100000")
        let str = GetService + url
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func didResponse(result: NSDictionary) {
        print("\(result)")
        itemArray =  (result.objectForKey("dt") as? NSMutableArray)!
        if(itemArray.count > 0)
        {
            dataDic = addressMethod.sharedInstance.dealAddressData(itemArray, str:"")
            print("\(dataDic)")
            titleArray = dataDic.allKeys
            titleArray = titleArray.sortedArrayUsingComparator { (str1, str2) -> NSComparisonResult in
                return str1.compare(str2 as! String)
            }
            tableView.reloadData()
        }
        selectFlagArray.removeAllObjects()
        if(titleArray.count > 0)
        {
            
            for(var i = 0;i < titleArray.count;++i)
            {
                let  str =  titleArray.objectAtIndex(i) as! String
                let  ary =  dataDic.objectForKey(str) as! NSArray
                let aryData = NSMutableArray()
                aryData.removeAllObjects()

                for(var j = 0;j < ary.count;++j)
                {
                    aryData.addObject("0")
                }
                selectFlagArray.addObject(aryData)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titleArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let str:AnyObject? = titleArray.objectAtIndex(section)
        let ary:NSArray = dataDic.objectForKey(str!)! as! NSArray
        return ary.count;
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
        let str:AnyObject? = titleArray.objectAtIndex(indexPath.section)
        let ary:NSArray = dataDic.objectForKey(str!)! as! NSArray
        
        let dic = ary.objectAtIndex(indexPath.row)
        
        cell.textLabel?.text = dic.objectForKey("U_Name") as? String
        cell.textLabel?.textColor = UIColor.blueColor()
        if(selectFlagArray.count > 0)
        {
            let muAry = selectFlagArray.objectAtIndex(indexPath.section) as! NSMutableArray
            let flag = muAry.objectAtIndex(indexPath.row) as! String
            if(flag == "0")
            {
                cell.imageView?.image = UIImage(named: "inchoose")
            }else if(flag == "1"){
                cell.imageView?.image = UIImage(named: "choosed")
            }
        }
       
        
        return cell
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return titleArray as? [String]
    }
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
        
        return index;
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cusView:UIView = UIView()
        cusView.frame = CGRectMake(0, 0,CGRectGetWidth(UIScreen.mainScreen().bounds),30);
        cusView.backgroundColor = UIColor.groupTableViewBackgroundColor	()
        let label:UILabel = UILabel()
        label.frame = CGRectMake(20, 0,CGRectGetWidth(UIScreen.mainScreen().bounds)-20,30);
        label.text =  titleArray.objectAtIndex(section) as? String
        cusView.addSubview(label)
        return cusView
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let muAry = selectFlagArray.objectAtIndex(indexPath.section) as! NSMutableArray
         let flag = muAry.objectAtIndex(indexPath.row) as! String
        if(flag == "0")
        {
            muAry.replaceObjectAtIndex(indexPath.row, withObject:"1")
        }else if(flag == "1"){
            muAry.replaceObjectAtIndex(indexPath.row, withObject:"0")
        }
        selectFlagArray.replaceObjectAtIndex(indexPath.section, withObject:muAry)
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
