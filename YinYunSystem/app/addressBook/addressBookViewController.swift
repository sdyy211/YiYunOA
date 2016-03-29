//
//  addressBookViewController.swift
//  YiYunSystem
//  通讯录 的主视图控制器
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 Mac. All rights reserved.
//

import UIKit

class addressBookViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,HttpProtocol{
    
    var  url = "/MyInfo/JContacts"

    @IBOutlet weak var mytableview: UITableView!
    @IBOutlet weak var searchControl: UISearchBar!
    
    
    var itemArray:NSMutableArray = NSMutableArray()
    var filterArray:NSMutableArray = NSMutableArray()
    var titleArray:NSArray = NSArray()
    var dataDic:NSDictionary = NSDictionary()
    var detileView = addressDetileView()
    var request = HttpRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.delegate = self
        mytableview.dataSource = self
        searchControl.delegate = self
        searchControl.backgroundColor = UIColor.brownColor()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnAction"))
        
        loadDataMethod()
      
    }
    //测试选择联系人
    func btnAction()
    {
        self.performSegueWithIdentifier("pushSelectContact", sender: self)
    }
    func loadDataMethod()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        let bodyStr = NSString(format: "page=1&rows=100000")
        let str = GetService + url 
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        print(result)
        itemArray =  (result.objectForKey("rows") as? NSMutableArray)!
        if(itemArray.count > 0)
        {
            dataDic = addressMethod.sharedInstance.dealAddressData(itemArray, str:"")
            titleArray = dataDic.allKeys
            titleArray = titleArray.sortedArrayUsingComparator { (str1, str2) -> NSComparisonResult in
                return str1.compare(str2 as! String)
            }
            NSUserDefaults.standardUserDefaults().setObject(dataDic, forKey: "addressData")
            mytableview.reloadData()
        }
    }
	
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == mytableview)
        {
            let str:AnyObject? = titleArray.objectAtIndex(section)
            let ary:NSArray = dataDic.objectForKey(str!)! as! NSArray
            return ary.count;
        }else{
            return filterArray.count
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == mytableview)
        {
             return titleArray.count
        }else{
            return 1
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == mytableview)
        {
            return 30;
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.sectionIndexColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1)
        let cell = UITableViewCell(style:.Default, reuseIdentifier:"myCell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if(tableView == mytableview)
        {
            let str:AnyObject? = titleArray.objectAtIndex(indexPath.section)
            let ary:NSArray = dataDic.objectForKey(str!)! as! NSArray
            
            let dic = ary.objectAtIndex(indexPath.row)
            
            cell.textLabel?.text = dic.objectForKey("U_Name") as? String
            cell.textLabel?.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        }else{
            let dic = filterArray.objectAtIndex(indexPath.row)
            cell.textLabel?.text =  dic.objectForKey("U_Name") as? String
        }
        cell.imageView?.image = UIImage(named: "h7")
        return cell
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if(tableView == mytableview)
        {
            return titleArray as? [String]
        }else{
            return nil
        }
    }
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int{
        return index;
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == mytableview)
        {
            let cusView:UIView = UIView()
            cusView.frame = CGRectMake(0, 0,CGRectGetWidth(UIScreen.mainScreen().bounds),30);
            cusView.backgroundColor = UIColor(red: 212.0/255.0, green: 226.0/255.0, blue: 235.0/255.0, alpha: 1)
            let label:UILabel = UILabel()
            label.frame = CGRectMake(20, 0,CGRectGetWidth(UIScreen.mainScreen().bounds)-20,30);
            label.text =  titleArray.objectAtIndex(section) as? String
            label.textColor = UIColor(red: 95.0/255.0, green: 139.0/255.0, blue: 167.0/255.0, alpha: 1)
            cusView.addSubview(label)
            return cusView

        }else{
            return nil
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchControl.resignFirstResponder() 
        let item = NSMutableArray()
        var dic = NSDictionary()
        if(tableView == mytableview)
        {
            let str:AnyObject? = titleArray.objectAtIndex(indexPath.section)
            let ary:NSArray = dataDic.objectForKey(str!)! as! NSArray
            dic = ary.objectAtIndex(indexPath.row) as! NSDictionary
        }else{
        
            dic =  filterArray.objectAtIndex(indexPath.row) as! NSDictionary
        }
        
//        if(dic.objectForKey("TELEPHONE")?.length > 0)
//        {
            item.addObject("移动电话")
//        }
//        if(dic.objectForKey("Phone")?.length > 0)
//        {
            item.addObject("办公电话")
//        }
//        if(dic.objectForKey("EMAIL")?.length > 0)
//        {
            item.addObject("电子邮箱")
//        }
        detileView = addressDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
        detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
        detileView.itemArray = item
        detileView.itemDic = dic
        detileView.viewController = self
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(detileView)

    }
    
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // 没有搜索内容时显示全部组件
        if searchText == "" {
            self.filterArray = self.itemArray
        }
        else { // 匹配用户输入内容的前缀
            self.filterArray = []
            for ctrl in self.itemArray {
                let name = ctrl.objectForKey("U_Name") as! String
                let pinyin = toChinesePinYin(name)
                if((name.rangeOfString("\(searchText)")) != nil || (pinyin.rangeOfString("\(searchText)")) != nil)
                {
                    filterArray.addObject(ctrl)
                }
            }
        }
        // 刷新Table View显示
        mytableview.reloadData()
    }
    func toChinesePinYin(name:String) -> String
    {
        
        //转成了可变字符串
        let  str:NSMutableString  = NSMutableString(string:name)
        //先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin,false)
        //再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics,false)
        
        //转化为大写拼音
//        let  pinYin:NSString = str.capitalizedString;
        return str as String
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
