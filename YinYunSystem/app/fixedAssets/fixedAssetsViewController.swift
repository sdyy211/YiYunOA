//
//  fixedAssetsViewController.swift
//  YinYunSystem
//  固定资产
//  Created by Mac on 16/1/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class fixedAssetsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,menuDelegate{

//    @IBOutlet weak var tv: UITableView!
    var  tv:UITableView = UITableView()
    var  selectField:UITextField = UITextField()
    var  menuV = menuView()
    var  fixedDetileV = fixedDetileView()
    var  fixedDetileBV = fixedDetileBorrowView()
    var  itemArry:NSArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "固定资产"
        self.tabBarController?.tabBar.hidden = true
        self.navigationController!.navigationBar.translucent = true
        tv.dataSource = self
        tv.delegate = self
        initView()
    }
    func initView()
    {
        let cusview:UIView = UIView()
        cusview.frame = CGRectMake(0, 65, CGRectGetWidth(UIScreen.mainScreen().bounds), 40)
        cusview.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        selectField.frame = CGRectMake(010, 5,200 , 30);
        selectField.delegate = self
        selectField.borderStyle = UITextBorderStyle.RoundedRect
        selectField.placeholder = "请选择设备"
        selectField.textAlignment = NSTextAlignment.Center
        cusview.addSubview(selectField)
        self.view.addSubview(cusview)
        
        tv.frame = CGRectMake(0,CGRectGetMaxY(cusview.frame),CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds)-40-65)
        self.view.addSubview(tv)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.loadData()
    }
    func loadData()
    {
        let path:String = NSBundle.mainBundle().pathForResource("fixedAsset", ofType: "plist")!
        itemArry = NSArray(contentsOfFile: path)!
        tv.reloadData()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib.init(nibName: "fixedAssetsTableCell", bundle: nil), forCellReuseIdentifier: "cell")
        let cell:fixedAssetsTableCell = tableView.dequeueReusableCellWithIdentifier("cell") as! fixedAssetsTableCell
        let dic:NSDictionary = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
        let meg:NSDictionary = dic.objectForKey("meg") as! NSDictionary
        let status:String = meg.objectForKey("status") as! String
        let titlestr:String =  dic.objectForKey("dev") as! String
        if(status == "1")
        {
              cell.titlelabel.text = "\(titlestr)(已借出)"
        }else if(status == "0"){
        
              cell.titlelabel.text = "\(titlestr)(可借用)"
        }
      
        let detile:NSDictionary = dic.objectForKey("meg") as! NSDictionary
        cell.name.text = detile.objectForKey("name") as? String
        cell.phone.text = detile.objectForKey("iphone") as? String
        cell.date.text = detile.objectForKey("data") as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        menuV.removeFromSuperview()
        selectField.resignFirstResponder()
        
        let view:UIView = (UIApplication.sharedApplication().keyWindow?.subviews.last)!
        if(view.isKindOfClass(fixedDetileView))
        {
             fixedDetileV.removeFromSuperview()

        }else{
            
            let dic:NSDictionary = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            let meg:NSDictionary = dic.objectForKey("meg") as! NSDictionary
            let status:String = meg.objectForKey("status") as! String
            if(status == "1")
            {
                //详情页面
                fixedDetileV = fixedDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                fixedDetileV.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                fixedDetileV.megDic = dic
                
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(fixedDetileV)
            }else if(status == "0")
            {
                //借用页面
                fixedDetileBV = fixedDetileBorrowView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                fixedDetileBV.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                fixedDetileBV.vc = self.navigationController!
                fixedDetileBV.megDic = dic
                
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(fixedDetileBV)
            }
            
        }

    }
    func textFieldDidBeginEditing(textField: UITextField) {
        selectField.resignFirstResponder()
        
        menuV = menuView.init(frame: CGRectMake(CGRectGetMinX(selectField.frame),CGRectGetMaxY(selectField.frame)+70, 200, 500))
        menuV.delegate = self
        menuV.backgroundColor = UIColor.whiteColor()
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(menuV)
    }
    func passSheBei(name: String) {
        selectField.text = name;
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectField.resignFirstResponder()
        menuV.removeFromSuperview()
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
