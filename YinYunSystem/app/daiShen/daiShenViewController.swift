//
//  daiShenViewController.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class daiShenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,selectProtocol,segmentProtocol,AuditDetileProtocol,yongZhangProtocol{
    @IBOutlet weak var tabbarView: UIView!

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var selectStyleBtn: UIButton!
    
    @IBOutlet weak var rightItem: UIButton!
    var color = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
    var  selectStyle = ""
    var tv = UITableView()
    var itemArry = NSMutableArray()
    var selectViewItemArry = NSMutableArray()
    var dataArry = NSMutableArray()
    var flageArry = NSMutableArray()
    var selectView = selectStyleView()
    var yongzhangDetileView = yongZhangDetileView()
    var segmentV = segmentView()
    var request = HttpRequest()
    var baoXiaoTV:baoXiaoTableView?
    var baoXiao = ""
    var flag = "0"
    var flag2 = ""
    var permissionURL = "/Mobile/Mobile/right"
    
    var kaoqinURL = "/KaoQinCheck/JDaiShenList"
    var KaoqinPiFuURL = "/KaoQinCheck/JShenHe"
    
    var yongZhangURL = "/mobile/mobile/JGetCachetCheckList"
    var yongZhangPiFuURL = "/mobile/mobile/JShenHeCachet"
    override func viewDidLoad() {
        super.viewDidLoad()

        let cusView = UIView()
        cusView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),20)
        cusView.backgroundColor = UIColor(red: 0.0/255.0, green:
            122.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        self.view.addSubview(cusView)
        
        selectStyleBtn.selected = false
        rightItem.tag = 1
        request.delegate = self
        self.navigationController?.navigationBar.hidden = true
        tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame))
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = color
        self.view.addSubview(tv)
        
        permissionLoadData()
    }
    // MARK: rightItem 点击事件
    @IBAction func rightItemAction(sender: AnyObject) {
        selectView.removeFromSuperview()
        //右上角批复按钮的点击事件
        if(itemArry.count > 0)
        {
            if(rightItem.tag == 1)
            {
                rightItem.tag = 2
                if(flag == "1")
                {
                    //对考勤中的tableview的frame的改变
                    tv.frame = CGRectMake(0, CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(segmentV.frame)-40)
                }else if(flag == "2"){
                    //对用章中的tableview的frame的改变
                    tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame)-40)
                }
                footerView.hidden = false
                rightItem.setTitle("取消", forState: UIControlState.Normal)
            }else if(rightItem.tag == 2){
                rightItem.tag = 1
                if(flag == "1")
                {
                    tv.frame = CGRectMake(0, CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(segmentV.frame)+40)
                }else if(flag == "2"){
                    tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame)+40)
                }
                
                footerView.hidden = true
                RemoveFlagArray()
                rightItem.setTitle("批", forState: UIControlState.Normal)
                
            }
            tv.reloadData()
        }
        if(baoXiao == "1")
        {
            if(rightItem.tag == 1)
            {
                rightItem.tag = 2
//                rightItem.setTitle("取消", forState: UIControlState.Normal)
                baoXiaoTV?.reshframe("1")
            }else if(rightItem.tag == 2){
                rightItem.tag = 1
//                rightItem.setTitle("批", forState: UIControlState.Normal)
                baoXiaoTV?.reshframe("2")
            }

        }
    }
    


    @IBAction func selectStyleBtnAction(sender: AnyObject) {
        //点击全部按钮显示所有类型的列表
        if !selectStyleBtn.selected
        {
            selectStyleBtn.selected = true
            selectView.removeFromSuperview()
            selectView = selectStyleView()
            selectView.frame = CGRectMake(CGRectGetMinX(selectStyleBtn.frame),CGRectGetMinY(tabbarView.frame)+CGRectGetMaxY(selectStyleBtn.frame),CGRectGetWidth(selectStyleBtn.frame),CGFloat(selectViewItemArry.count)*40)
            selectView.delegate  = self
            selectView.itemArry = selectViewItemArry
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(selectView)
            window?.makeKeyAndVisible()
        }else{
            selectStyleBtn.selected = false
            selectView.removeFromSuperview()
        }
    }
    @IBAction func backBtnAction(sender: AnyObject) {
        //返回的按钮
        selectView.removeFromSuperview()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    //MARK: UItableviewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(flag == "0"){
            //全部列表的高度
            return 50
        }else if(flag == "1")
        {
            //考勤列表的高度
            return 90
        }else if(flag == "2"){
            //用章列表的高度
            return 113
        }else if(flag == "3"){
            //报销列表的高度
            return 50
        }else{
            //其他
            return 50
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(flag == "1")
        {
            //考勤列表的cell
            tableView.registerNib(UINib(nibName: "AuditTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            let cell:AuditTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell1") as! AuditTableViewCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if(rightItem.tag == 1)
            {
                cell.imageFlage.hidden = true
                cell.imageFlage.image = UIImage(named: "inchoose")
            }else if(rightItem.tag == 2){
                cell.imageFlage.hidden = false
                if(flageArry.count > 0)
                {
                    let flagStr =  flageArry.objectAtIndex(indexPath.row) as! String
                    if(flagStr == "0")
                    {
                        cell.imageFlage.image = UIImage(named: "inchoose")
                    }else if(flagStr == "1")
                    {
                        cell.imageFlage.image = UIImage(named: "choosed")
                    }
                }
            }
            cell.cellBackView.layer.borderWidth = 1
            cell.cellBackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellBackView.layer.cornerRadius  = 10
            
            
            let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
            cell.name.text = dic.objectForKey("U_Name") as? String
            cell.endTime.text = dic.objectForKey("KQ_EndTime") as? String
            cell.startTime.text = dic.objectForKey("KQ_AddTime") as? String
            return cell
        }else if(flag == "2"){
            //用章列表的cell
            tableView.registerNib(UINib(nibName: "yongZhangPendingCell", bundle: nil), forCellReuseIdentifier: "cell2")
            
            let cell:yongZhangPendingCell = tableView.dequeueReusableCellWithIdentifier("cell2") as! yongZhangPendingCell
            cell.contentView.backgroundColor = color
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.textLabel?.textColor = UIColor(colorLiteralRed: 113.0/255.0, green: 123.0/255.0, blue: 128.0/255.0, alpha: 1)
            cell.cellbackView.layer.borderWidth = 1
            cell.cellbackView.layer.borderColor = UIColor.grayColor().CGColor
            cell.cellbackView.layer.cornerRadius  = 10
            
            if(rightItem.tag == 1)
            {
                cell.yongzhangImage.hidden = true
                cell.yongzhangImage.image = UIImage(named: "inchoose")
            }else if(rightItem.tag == 2){
                cell.yongzhangImage.hidden = false
                if(flageArry.count > 0)
                {
                    let flagStr =  flageArry.objectAtIndex(indexPath.row) as! String
                    if(flagStr == "0")
                    {
                        cell.yongzhangImage.image = UIImage(named: "inchoose")
                    }else if(flagStr == "1")
                    {
                        cell.yongzhangImage.image = UIImage(named: "choosed")
                    }
                }
            }
            
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
        selectView.removeFromSuperview()
        if(selectStyle == "考勤"){
            //点击考勤的列表判断
            let flagStr = flageArry.objectAtIndex(indexPath.row) as! String
            if(rightItem.tag == 2)
            {
                if(flagStr == "0")
                {
                    flageArry.replaceObjectAtIndex(indexPath.row, withObject:"1")
                }else if(flagStr == "1"){
                    flageArry.replaceObjectAtIndex(indexPath.row, withObject:"0")
                }
                tableView.reloadData()
            }else if(rightItem.tag == 1){
                
                let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
                let detileView = AuditDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                detileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                detileView.deleteURL = "/KaoQinCheck/JShenHe"
                detileView.itemDic = dic
                detileView.viewController = self
                detileView.delegate = self
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(detileView)
            }

        }else if(selectStyle == "用章"){
            //点击用章的列表判断
            let flagStr = flageArry.objectAtIndex(indexPath.row) as! String
            if(rightItem.tag == 2)
            {
                if(flagStr == "0")
                {
                    flageArry.replaceObjectAtIndex(indexPath.row, withObject:"1")
                }else if(flagStr == "1"){
                    flageArry.replaceObjectAtIndex(indexPath.row, withObject:"0")
                }
                tableView.reloadData()
            }else if(rightItem.tag == 1){
                let dic = itemArry.objectAtIndex(indexPath.row) as! NSDictionary
                yongzhangDetileView = yongZhangDetileView.init(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen .mainScreen().bounds)))
                yongzhangDetileView.backgroundColor = UIColor.init(colorLiteralRed:0, green: 0, blue: 0, alpha:0.5)
                yongzhangDetileView.dataDic = dic
                yongzhangDetileView.nameKey = "BD_UName"
                yongzhangDetileView.departmentKey = "BD_BuMen"
                yongzhangDetileView.viewController = self
                yongzhangDetileView.titleArry = ["用印分类","用印时间","用印事由","备注","留存材料","用印次数","当前状态"]
                yongzhangDetileView.keyArry = ["BD_LeiXing","BD_Time","BD_Reason","BD_BeiZhu","BD_CaiLiao","BD_CiShu","BD_State"]
                yongzhangDetileView.delegate = self
                let window:UIWindow = UIApplication.sharedApplication().keyWindow!
                window.addSubview(yongzhangDetileView)

            }
        }
    }
    //MARK:获取选择的待审的类型
    func getSelectStyle(style: String) {
        baoXiao = ""
        selectStyleBtn.selected = false
        selectStyleBtn.setTitle(style, forState: UIControlState.Normal)
        selectStyle = style
        if(style == "全部")
        {
            segmentV.removeFromSuperview()
        
            tv.removeFromSuperview()
            tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame))
            self.view.addSubview(tv)
            AllLoadData()
        }else if(style == "考勤"){
//            baoXiaoTV!.removeFromSuperview()
            
            segmentV.removeFromSuperview()
            tv.removeFromSuperview()
            segmentV = segmentView()
            segmentV.segmentArray = ["公出","调休","加班","请假","补录考勤"]
            segmentV.delegate = self
            segmentV.frame = CGRectMake(0,CGRectGetMaxY(tabbarView.frame),CGRectGetWidth(self.view.frame),40)
            self.view.addSubview(segmentV)
            tv.frame = CGRectMake(0, CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(segmentV.frame))
            self.view.addSubview(tv)
            KaoQinLoadData()
        }else if(style == "用章"){
            segmentV.removeFromSuperview()
            tv.removeFromSuperview()
            tv.frame = CGRectMake(0, CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-CGRectGetMaxY(tabbarView.frame))
            self.view.addSubview(tv)
            YongZhangLoadData()
        }else if(style == "报销"){
            segmentV.removeFromSuperview()
            tv.removeFromSuperview()
            baoXiao = "1"
            let frame = CGRectMake(0,  CGRectGetMaxY(tabbarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(UIScreen.mainScreen().bounds)-CGRectGetMaxY(tabbarView.frame))
           
            baoXiaoTV = baoXiaoTableView(frame:frame)
            baoXiaoTV?.rightBtn = rightItem
            baoXiaoTV?.VC = self
            self.view.addSubview(baoXiaoTV!)
        
        }
    }
    //MARK:全部请求
    func permissionLoadData()
    {
        flag2 = "permission"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let par = ["":""]
        let str = GetService + permissionURL
        request.Get(str, parameters: par)
    }
    func AllLoadData()
    {
        flag = "0"
        itemArry.removeAllObjects()
        tv.reloadData()
    }
    func KaoQinLoadData()
    {
        //kaoqin
        flag = "1"
        loadingAnimationMethod.sharedInstance.startAnimation()
        let bodyStr = NSString(format:"page=1&rows=100000&lx=0&Name=")
        let str = GetService + kaoqinURL
        
        request.Post(str, str: bodyStr as String)
    }
    func YongZhangLoadData()
    {
        //yongzhang
        flag = "2"
        itemArry.removeAllObjects()
        loadingAnimationMethod.sharedInstance.startAnimation()
        let param = ["zt":"2"]
        request.Get(GetService + yongZhangURL, parameters: param)

    }
   
    func BaoXiaoLoadData()
    {
        //baoxiao
        flag = "3"
        itemArry.removeAllObjects()
        tv.reloadData()
    }
    // 批量通过 和 批量退回请求的接口
    func KaoQinloadBatch(type:String,kqid:String)
    {
        flag = "批量通过和退回"
        loadingAnimationMethod.sharedInstance.startAnimation()
        
        let bodyStr = NSString(format:"type=\(type)&kqid=\(kqid)")
        let str = GetService + KaoqinPiFuURL
        request.delegate = self
        request.Post(str, str: bodyStr as String)
    }
    // 用章详情页面的 退回，通过按钮的请求方法
    func loadData_exitAction(id:String)
    {
        flag = "用章详情退回"
        loadingAnimationMethod.sharedInstance.startAnimation()
        
        let param = ["flag":"－1","bid":id]
        request.Get(GetService + yongZhangPiFuURL, parameters: param)
    }
    func loadData_trueAction(id:String)
    {
        flag = "用章详情通过"
        loadingAnimationMethod.sharedInstance.startAnimation()
        let param = ["flag":"1","bid":id]
        request.Get(GetService + yongZhangPiFuURL, parameters: param)
    }

    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        
        if(flag2 == "permission")
        {
            flag2 = ""
            let ary =  result.objectForKey("dt") as? NSArray
            
            //考勤审批列表 报销审批列表
            for(var i = 0;i < ary?.count ;i++)
            {
                let dic =  ary?.objectAtIndex(i) as! NSDictionary
                let name = dic.objectForKey("Menu_Name") as? String
                if(name == "考勤审批列表")
                {
                    selectViewItemArry.addObject("考勤")
                }else if(name == "报销审批列表"){
                    selectViewItemArry.addObject("报销")
                }else if(name == "用章审批列表"){
                    selectViewItemArry.addObject("用章")
                }else if(name == "借还款审核列表"){
                    selectViewItemArry.addObject("借还款")
                }else if(name == "云资源审核列表"){
                    selectViewItemArry.addObject("云资源")
                }else if(name == "项目审核"){
                    selectViewItemArry.addObject("项目")
                }else if(name == "合同审核列表"){
                    selectViewItemArry.addObject("合同")
                }
            }

        }
        if(flag == "0")
        {
            
        }else if(flag == "1"){
            let ary = result.objectForKey("rows") as! NSArray
            dataArry.setArray(ary as [AnyObject])
            panduan(segmentV.segmentArray.objectAtIndex(segmentV.segmented.selectedSegmentIndex) as! String)
        }else if(flag == "2"){
            let ary = result.objectForKey("dt") as? NSArray
            itemArry = NSMutableArray(array: ary!)
            
            for _ in 0..<itemArry.count
            {
                flageArry.addObject("0")
            }
            tv.reloadData()
            
        }else if(flag == "3"){
            
        }else if(flag == "4"){
            
        }else if(flag == "用章详情退回"){
            let num = result.objectForKey("flag") as! NSNumber
            let flagindex =  "\(num)"
            if(flagindex == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                yongzhangDetileView.removeFromSuperview()
                alter("提示", message: "操作成功！")
                flag = "1"
                YongZhangLoadData()
            }
        
        }else if(flag == "用章详情通过"){
            let num = result.objectForKey("flag") as! NSNumber
            let flagindex =  "\(num)"
            if(flagindex == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                yongzhangDetileView.removeFromSuperview()
                alter("提示", message: "操作成功！")
                flag = "1"
                YongZhangLoadData()
            }
        }else if(flag == "批量通过和退回"){
            let num = result.objectForKey("flag") as! NSNumber
            let flagIndex =  "\(num)"
            rightItem.tag == 1
            rightItem.setTitle("批量", forState: UIControlState.Normal)
            if(flagIndex == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                alter("提示", message: "操作成功！")
                
                if(selectStyle == "考勤")
                {
                    flag = "1"
                    KaoQinLoadData()
                }
            }
        }
    }
    //MARK: 获取segment点击的哪一个
    func getSegmentDidchange(index: String) {
        if(footerView.hidden == false)
        {
            footerView.hidden = true
            rightItem.setTitle("批量", forState: UIControlState.Normal)
            rightItem.tag = 1
        }
        panduan(index)
    }

    // MARK: 处理数据，把数据分开
    func panduan(index:String)
    {
        itemArry.removeAllObjects()
        flageArry.removeAllObjects()
        for(var i = 0;i < dataArry.count;++i)
        {
            let dic = dataArry.objectAtIndex(i)
            let indexstr = dic.objectForKey("KQ_Type") as! String
            if(indexstr == index)
            {
                itemArry.addObject(dic)
                flageArry.addObject("0")
            }
        }
        tv.reloadData()
    }
    // MARK: 清空已选择标示的数组
    func RemoveFlagArray()
    {
        if(flageArry.count > 0)
        {
            for(var i = 0;i < flageArry.count;++i)
            {
                let str = flageArry.objectAtIndex(i) as! String
                if(str == "1")
                {
                    flageArry.replaceObjectAtIndex(i, withObject:"0")
                }
            }
        }
    }

    // MARK: 批量退回
    @IBAction func piLiangTuiHui(sender: AnyObject) {
        rightItem.tag = 1
        rightItem.setTitle("批量", forState: UIControlState.Normal)
        footerView.hidden = true
        let kqid =  getID()
        if(flag == "1")
        {
            KaoQinloadBatch("0",kqid: kqid)
        }else if(flag == "2")
        {
            loadData_exitAction(kqid)
        }
        
        RemoveFlagArray()
    }
    // MARK: 批量通过
    @IBAction func piLiangTongGuo(sender: AnyObject) {
        rightItem.tag = 1
        rightItem.setTitle("批量", forState: UIControlState.Normal)

        footerView.hidden = true
        let kqid =  getID()
        if(flag == "1")
        {
            KaoQinloadBatch("1",kqid: kqid)
        }else if(flag == "2")
        {
            loadData_trueAction(kqid)
        }
        RemoveFlagArray()
    }
    
    // MARK: 获取要删除的id
    func getID()->String
    {
        var kqid = ""
        if(flageArry.count > 0)
        {
            for(var i = 0; i < flageArry.count; ++i)
            {
                let str = flageArry.objectAtIndex(i) as! String
                if(str == "1")
                {
                    let dic =  itemArry.objectAtIndex(i) as! NSDictionary
                    var id = ""
                    if(flag == "1")
                    {
                        //取考勤的id
                        id = dic.objectForKey("KQ_ID") as! String
                    }else if(flag == "2")
                    {
                        //取用章的id
                        id = dic.objectForKey("BD_ID") as! String
                    }
                    
                    kqid = kqid+"\(id),"
                }
            }
        }
        if(kqid != "")
        {
            kqid = (kqid as NSString).substringToIndex(kqid.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)-1)
        }
        return kqid
    }
    // MARK: 弹出窗口
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }

    func setLoadData() {
        KaoQinLoadData()
    }
    //MARK: 用章详情页面的代理方式
    func trueBtnAct(button: UIButton, id: String) {
        loadData_trueAction(id)
    }
    func exitBtnAct(button: UIButton, id: String) {
        loadData_exitAction(id)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        selectView.removeFromSuperview()
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
