//
//  yongZhangHasbeenVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yongZhangHasbeenVController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol{

    @IBOutlet weak var tv: UITableView!
    
    var url = "/mobile/mobile/JGetCachetCheckList"
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    var itamArry = NSArray()
    var request = HttpRequest()
    var cusView = UIView()
    var flag = "0"
   
    var detileView = yongZhangDetileView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tv.backgroundColor = color
        addLeftItem()
        loadData()
       
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
    func loadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let param = ["zt":"-1"]
        request.Get(GetService + url, parameters: param)
    }
    func loadData_tuiHui()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let param = ["zt":"1"]
        request.Get(GetService + url, parameters: param)
    }
    
    func didResponse(result: NSDictionary) {
        itamArry = []
        loadingAnimationMethod.sharedInstance.endAnimation()
        itamArry = (result.objectForKey("dt") as? NSArray)!
        tv.reloadData()
    }
    //MARK:UItableviewdelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itamArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell2")
        
        let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! yongZhangPendingCell
        cell.contentView.backgroundColor = color
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
        cell.cellbackView.layer.borderWidth = 1
        cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
        cell.cellbackView.layer.cornerRadius  = 10
        
        let dic =  itamArry.objectAtIndex(indexPath.row) as! NSDictionary
        cell.name.text = dic.objectForKey("BD_UName") as? String
        cell.department.text = dic.objectForKey("BD_BuMen") as? String
        cell.type.text = dic.objectForKey("BD_LeiXing") as? String
        cell.time.text = dic.objectForKey("BD_Time") as? String
//        cell.state.text = dic.objectForKey("FCK_State") as? String
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dic = itamArry.objectAtIndex(indexPath.row) as! NSDictionary
        detileView = yongZhangDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
        detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
        detileView.dataDic = dic
        detileView.nameKey = "BD_UName"
        detileView.departmentKey = "BD_BuMen"
        detileView.viewController = self
        detileView.titleArry = ["用印分类","用印时间","用印事由","备注","留存材料","用印次数","当前状态"]
        detileView.keyArry = ["BD_LeiXing","BD_Time","BD_Reason","BD_BeiZhu","BD_CaiLiao","BD_CiShu","BD_State"]
        detileView.state = "1"
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
        window.addSubview(detileView)
    }
    func yishenAction(button:UIButton)
    {
        loadData()
    }
    func tuihuiAction(button:UIButton)
    {
        loadData_tuiHui()
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
