//
//  yiShenViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yiShenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,selectProtocol,HttpProtocol{


    @IBOutlet weak var tabbarView: UIView!
    
    @IBOutlet weak var selectStypeBtn: UIButton!
    
    
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    var request2 = HttpRequest()
    var tv = UITableView()
    var itemArry = NSArray()
    var selectViewItemArry = NSMutableArray()
    var selectView = selectStyleView()
    var styleStr = "考勤"
    var permissionURL = "/Mobile/Mobile/right"
    var kaoQinURL = "/KaoQinCheck/JDaiShenList"
    var yongZhangURL = "/mobile/mobile/JGetCachetCheckList"
    var detileView = yongZhangDetileView()
    var baoXiao = ""
    var segmentV = segmentView()
    var baoXiaoTV:baoXiaoTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cusView = UIView()
        cusView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),20)
        cusView.backgroundColor = UIColor(red: 0.0/255.0, green:
            122.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        self.view.addSubview(cusView)
        
        selectStypeBtn.selected = false
        self.navigationController?.navigationBar.hidden = true
        tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame))
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = color
        self.view.addSubview(tv)
        
        permissionLoadData()
        
        kaoQinLoadData()
    }
    @IBAction func selectStypeAction(sender: AnyObject) {
        //点击全部按钮显示所有类型的列表
        if !selectStypeBtn.selected
        {
            selectStypeBtn.selected = true
            selectView.removeFromSuperview()
            selectView = selectStyleView()
            selectView.frame = CGRectMake(CGRectGetMinX(selectStypeBtn.frame),CGRectGetMinY(tabbarView.frame)+CGRectGetMaxY(selectStypeBtn.frame),CGRectGetWidth(selectStypeBtn.frame),CGFloat(selectViewItemArry.count)*40)
            selectView.delegate  = self
             selectView.itemArry = selectViewItemArry
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(selectView)
            window?.makeKeyAndVisible()
        }else{
            selectStypeBtn.selected = false
            selectView.removeFromSuperview()
        }
        
    }
    
    @IBAction func backbtn(sender: AnyObject) {
        selectView.removeFromSuperview()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    
    //MARK:获取选择的待审的类型
    func getSelectStyle(style: String) {
        selectStypeBtn.selected = false
        selectStypeBtn.setTitle(style, forState: UIControlState.Normal)
        styleStr = style
        if(style == "考勤"){
            baoXiaoTV?.removeFromSuperview()
            kaoQinLoadData()
        }else if(style == "用章"){
            baoXiaoTV?.removeFromSuperview()
            yongZhangLoadData()
            
        }else if(style == "报销"){
            segmentV.removeFromSuperview()
            tv.removeFromSuperview()
            let frame = CGRectMake(0,  CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(UIScreen.mainScreen().bounds)-CGRectGetMaxY(tabbarView.frame))
            
            baoXiaoTV = baoXiaoTableView(frame:frame)
            baoXiaoTV?.VC = self
            baoXiaoTV?.loadStyleFlag = "1"
            self.view.addSubview(baoXiaoTV!)
        }
    }
    //MARK:全部请求方法
    func permissionLoadData()
    {
        
        let par = ["":""]
        let str = GetService + permissionURL
        
        request(.GET, str, parameters: par, encoding: ParameterEncoding.URLEncodedInURL, headers: nil).responseJSON { (response) -> Void in
            guard let _ = response.response else{
                return
            }
            if(response.result.value != nil)
            {
                let ary =  response.result.value!.objectForKey("dt") as? NSArray
                
                //考勤审批列表 报销审批列表
                for(var i = 0;i < ary?.count ;i++)
                {
                    let dic =  ary?.objectAtIndex(i) as! NSDictionary
                    let name = dic.objectForKey("Menu_Name") as? String
                    if(name == "考勤审批列表")
                    {
                        self.selectViewItemArry.addObject("考勤")
                    }else if(name == "报销审批列表"){
                        self.selectViewItemArry.addObject("报销")
                    }else if(name == "用章审批列表"){
                        self.selectViewItemArry.addObject("用章")
                    }else if(name == "借还款审核列表"){
                        self.selectViewItemArry.addObject("借还款")
                    }else if(name == "云资源审核列表"){
                        self.selectViewItemArry.addObject("云资源")
                    }else if(name == "项目审核"){
                        self.selectViewItemArry.addObject("项目")
                    }else if(name == "合同审核列表"){
                        self.selectViewItemArry.addObject("合同")
                    }
                }

            }
        }
    }
    func kaoQinLoadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        itemArry = []
        let bodyStr = NSString(format:"page=1&rows=100000&lx=1&Name=")
        let str = GetService + kaoQinURL
        request2.delegate = self
        request2.Post(str, str: bodyStr as String)
    }
    func yongZhangLoadData()
    {
        loadingAnimationMethod.sharedInstance.startAnimation()
        request2.delegate = self
        let param = ["zt":"-1"]
        request2.Get(GetService + yongZhangURL, parameters: param)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        
        itemArry = []
       if(styleStr == "考勤"){
            itemArry = (result.objectForKey("rows") as? NSMutableArray)!
            tv.reloadData()

        }else if(styleStr == "用章"){
            itemArry = (result.objectForKey("dt") as? NSArray)!
            tv.reloadData()
        }else if(styleStr == "报销"){
            
        }
        
      
    }


    //MARK: UItableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(styleStr == "考勤")
        {
            return 90
        }else if(styleStr == "用章"){
            return 113
        }else {
            return 50
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(styleStr == "考勤")
        {
            tableView.registerNib(UINib(nibName: "auditHasbeenViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            let cell:auditHasbeenViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! auditHasbeenViewCell
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellBackView.layer.borderWidth = 1
            cell.cellBackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellBackView.layer.cornerRadius  = 10
            
            
            let dic = itemArry.objectAtIndex(indexPath.row) as? NSDictionary
            cell.name.text = dic!.objectForKey("U_Name") as? String
            cell.startTime.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.endTime.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            
            
            cell.startTime.text = dic!.objectForKey("KQ_StartTime") as? String
            cell.endTime.text = dic!.objectForKey("KQ_EndTime") as? String
            cell.state.text = dic!.objectForKey("KQ_State") as? String
            return cell

        }else if(styleStr == "用章"){
            tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell2")
            
            let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! yongZhangPendingCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellbackView.layer.borderWidth = 1
            cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellbackView.layer.cornerRadius  = 10
            
            let dic =  itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            cell.name.text = dic.objectForKey("BD_UName") as? String
            cell.department.text = dic.objectForKey("BD_BuMen") as? String
            cell.type.text = dic.objectForKey("BD_LeiXing") as? String
            cell.time.text = dic.objectForKey("BD_Time") as? String
//            cell.state.text = dic.objectForKey("FCK_State") as? String
            return cell
        }else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            return cell
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(styleStr == "考勤")
        {
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            let detileView = AuditHasbeenView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
            detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
            detileView.itemDic = dic
            detileView.viewController = self
            
            let window:UIWindow = UIApplication.sharedApplication().keyWindow!
            window.addSubview(detileView)
        }else if(styleStr == "用章"){
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
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
