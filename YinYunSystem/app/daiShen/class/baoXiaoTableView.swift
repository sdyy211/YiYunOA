//
//  baoXiaoTableView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//"通讯费": "1DC10AAA-5074-482E-9DC4-B6E721EF8C46",values
//"差旅费": "AC624F0C-3A8E-4A54-A7EC-C2BA0BE7DFBE",
//"市内交通费": "999107B6-4A8D-4718-9F14-2ED4C4EEB318",
//"通用": "BE9F26FC-2D6D-44CB-ADC8-6187BBC196A9",
//"招待费": "B4377AC7-BFF4-416C-BD68-5E7865A71796",
//"培训费": "F67C2ABE-62C0-40DE-BF6A-4A1046AC4F3E",
//"会议费": "F67C2ABE-62C0-40DE-BF1A-111046AC413E",
//"财务费用": "F67C2ABE-62C0-40DE-BF1A-102246AC413E"


import UIKit

class baoXiaoTableView: UIView,UITableViewDelegate,UITableViewDataSource,segmentProtocol,HttpProtocol,baoXiaoBottomProtocol,downLoadProtocol{

    var tv = UITableView()
    var itemArry = NSMutableArray()
    var flageArry = NSMutableArray()
    var dataArry = NSArray()
    var detileArry = NSMutableArray()
    var chongDiArry = NSMutableArray()
    var rightBtn = UIButton()
    var cellH:CGFloat = 0.0
    var styleIdDic = NSDictionary()
    var styleId = ""
    var styleTitle = ""
    var request = HttpRequest()
    var segmentV = segmentView()
    var showImage = showImageView()
    //这是显示退回和通过的视图
    var buttomView = baoXiaoBottomView()
    var downfile = downLoadFile()
    var openfile = openDownloadFile()
    var VC = UIViewController()
    var url = "/mobile/mobile/JReimbureseList"
    var detileURL = "/mobile/mobile/JReimburseseDetail"
    
    var piFuURL = "/mobile/mobile/JShenHeReimburese"
    var rightBtnFlag = ""
    var loadFlag = ""
    var loadStyleFlag = "2"  // 当待审的时候默认的为2  当已审时为1或0
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    func initView()
    {
        segmentV = segmentView()
        let ary = NSUserDefaults.standardUserDefaults().objectForKey("baoXiaoPermissions") as! NSArray
        print(ary)
        for permissions in ary
        {
            print(permissions)
            if(permissions as! String == "副总经理" || permissions as! String == "总经理助理")
            {
                segmentV.segmentArray = ["全部","通讯费","差旅费","市内交通费","通用","培训费","会议费"]
            }else if(permissions as! String == "总经理")
            {
                segmentV.segmentArray = ["全部","通讯费","差旅费","市内交通费","通用","培训费","会议费"]
            }
        }
        
        segmentV.delegate = self
        segmentV.frame = CGRectMake(0,0,CGRectGetWidth(self.frame),40)
        self.addSubview(segmentV)
        
        tv.frame = CGRectMake(0,CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(segmentV.frame))
        tv.delegate = self
        tv.dataSource = self
        self.addSubview(tv)
        
        loadData()
    }
    func loadData()
    {
        
        if(loadStyleFlag == "2")
        {
            //待审请求
            loadFlag = "0"
            loadingAnimationMethod.sharedInstance.startAnimation()
            request.delegate = self
            let parmer = "zt=2"
            let str = GetService + url
            request.Post(str, str: parmer)

        }else{
            //已审请求
            loadFlag = "0"
            loadingAnimationMethod.sharedInstance.startAnimation()
            request.delegate = self
            let parmer = "zt=-1"
            let str = GetService + url
            request.Post(str, str: parmer)
        }
    }
    func loadData2()
    {
        
        loadingAnimationMethod.sharedInstance.startAnimation()
        if(loadStyleFlag == "2")
        {
            loadFlag = "1"
            //获取待审的二级菜单的数据
            request.delegate = self
            let parmer = "bxaid=\(styleId)&zt=2"
            let str = GetService + detileURL
            request.Post(str, str: parmer)
        }else{
            loadFlag = "1"
            //获取已审二级菜单的数据
            request.delegate = self
            let parmer = "bxaid=\(styleId)&zt=-1"
            let str = GetService + detileURL
            request.Post(str, str: parmer)
        }
        
    }
    func piFuLoadData(piflag:String,id:String)
    {
        loadFlag = "pifu"
        loadingAnimationMethod.sharedInstance.startAnimation()
        request.delegate = self
        let parmer = "bxid=\(id)&flag=\(piflag)"
        let str = GetService + piFuURL
        request.Post(str, str: parmer)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        if(loadFlag == "0")
        {
            let segmentTitle = segmentV.segmentArray.objectAtIndex(0) as! String
            dataArry = result.objectForKey("dt") as! NSArray
            panduan(segmentTitle)
            styleIdDic = result.objectForKey("values") as! NSDictionary
            if(segmentTitle == "全部")
            {
                styleId = ""
                loadData2()
            }else{
                styleId = styleIdDic.objectForKey(segmentTitle) as! String
                loadData2()
            }
        }else if(loadFlag == "1"){
            let dic =  result.objectForKey("values") as! NSDictionary
            chongDiArry = result.objectForKey("objs") as! NSMutableArray
            if(dic.allKeys.count > 0)
            {
                let str = dic.objectForKey("sbudate") as! String
                
                let jsonStr = str.stringByReplacingOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                
                let data = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
                
                let jsonArry = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                detileArry.setArray(jsonArry as [AnyObject])
                detileArry.removeObjectAtIndex(0)
                
                
            }
        }else if(loadFlag == "pifu"){
            let num = result.objectForKey("flag") as! NSNumber
            let flagindex =  "\(num)"
            if(flagindex == "0")
            {
                alter("提示", message: "操作失败！")
            }else{
                buttomView.removeFromSuperview()
                reshframe("0")
                alter("提示", message: "操作成功！")
                loadData()
            }

        
        }
    }
    override func drawRect(rect: CGRect) {
        // Drawing code
        initView()
    }
    //MARK:segment 点击改变的函数u
    func getSegmentDidchange(index: String) {
        reshframe("0")
        if(index != "全部")
        {
            styleId = styleIdDic.objectForKey(index) as! String
        }else{
            styleId = ""
        }
        panduan(index)
        loadData2()
    }
    // MARK: 处理数据，把数据分开
    func panduan(index:String)
    {
        itemArry.removeAllObjects()
        flageArry.removeAllObjects()
        if(index == "全部")
        {
            for(var i = 0;i < dataArry.count;++i)
            {
                let dic = dataArry.objectAtIndex(i)
                
                    let nsdata =  NSDataOfCell()
                    nsdata.level = "0"
                    nsdata.selectState = "0"
                    nsdata.selectFlag = "0"
                    nsdata.name = dic.objectForKey("BX_UName") as! String
                    nsdata.time = dic.objectForKey("BX_AddTime") as! String
                    nsdata.style = dic.objectForKey("BX_ABName") as! String
                    nsdata.zongFeiYong = dic.objectForKey("BX_Total") as! String
                    nsdata.BXID = dic.objectForKey("BX_ID") as! String
                    itemArry.addObject(nsdata)
            }

        }else{
            for(var i = 0;i < dataArry.count;++i)
            {
                let dic = dataArry.objectAtIndex(i)
                
                let indexstr = dic.objectForKey("BX_ABName") as! String
                if(indexstr == index)
                {
                    
                    let nsdata =  NSDataOfCell()
                    nsdata.level = "0"
                    nsdata.selectState = "0"
                    nsdata.selectFlag = "0"
                    nsdata.name = dic.objectForKey("BX_UName") as! String
                    nsdata.time = dic.objectForKey("BX_AddTime") as! String
                    nsdata.style = dic.objectForKey("BX_ABName") as! String
                    nsdata.zongFeiYong = dic.objectForKey("BX_Total") as! String
                    nsdata.BXID = dic.objectForKey("BX_ID") as! String
                    itemArry.addObject(nsdata)
                }
            }

        }
        tv.reloadData()
    }


    //MARK:UItableviewdelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var ns = NSDataOfCell()
        ns = itemArry.objectAtIndex(indexPath.row) as! NSDataOfCell
        if(ns.level == "0")
        {
            return 76
        }else{
            return cellH
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var nsdata = NSDataOfCell()
        nsdata = itemArry.objectAtIndex(indexPath.row) as! NSDataOfCell
        if(nsdata.level == "0")
        {
            //第一层的cell
            tableView.registerNib(UINib(nibName: "baoXiaoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            let cell:baoXiaoTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! baoXiaoTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.cusView.layer.cornerRadius = 5
            
            cell.name?.text =  nsdata.name
            cell.style.text =  nsdata.style
            cell.time.text =   nsdata.time
            cell.feiYong.text = nsdata.zongFeiYong + "元"
            if(rightBtnFlag == "1")
            {
                cell.imageV.hidden = false
            }else{
                cell.imageV.hidden = true
            }
            if(nsdata.selectFlag == "1")
            {
                
                cell.imageV.image = UIImage(named: "choosed")
            }else{
                cell.imageV.image = UIImage(named: "inchoose")
            }
            return cell

        }else{
            var cell = UITableViewCell()
            cell = returnStyleCellNib(nsdata, indexpath:indexPath)
            return cell
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var nsdata = NSDataOfCell()
        nsdata = itemArry.objectAtIndex(indexPath.row) as! NSDataOfCell
        if(rightBtnFlag == "1")
        {
            //这是在右上角按钮的编辑状态  
            if(nsdata.selectFlag == "0")
            {
                nsdata.selectFlag = "1"
            }else{
                nsdata.selectFlag = "0"
            }
            itemArry.replaceObjectAtIndex(indexPath.row, withObject: nsdata)
            tv.reloadData()
        }else{
           
            if(nsdata.level == "0")
            {
                
                if(nsdata.selectState == "0")
                {
                    nsdata.selectState = "1"
                    itemArry.replaceObjectAtIndex(indexPath.row, withObject: nsdata)
                    
                    //获取点击的cell 中有多少二级菜单以及冲抵总金额
                    let data = jiSuanChongDIYue(nsdata.BXID, indexpath: indexPath)
                    let index = data.objectForKey("index") as! Int
                    let chongDi = data.objectForKey("chongDi")  as! float_t
                    
                    let chongDiZongYuE = float_t(nsdata.zongFeiYong)! - chongDi
                    
                    for dic in detileArry
                    {
                        if(dic.objectForKey("BX_ID") as! String == nsdata.BXID)
                        {
                            let str = nsdata.style
                            
                            var nsdata2 = NSDataOfCell()
                            nsdata2 = chaRuShuJu(dic as! NSDictionary,styleName:str,index: index, chongDi: "\(chongDiZongYuE)")
                            
                            itemArry.insertObject(nsdata2, atIndex: indexPath.row+1)
                        }
                    }
                    tv.reloadData()
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                    
                }else if(nsdata.selectState == "1"){
                    nsdata.selectState = "0"
                    itemArry.replaceObjectAtIndex(indexPath.row, withObject: nsdata)
                    
                    let ary = NSMutableArray(array: itemArry)
                    for(var i = 0;i < itemArry.count;i++)
                    {
                        for(var j = 0;j < ary.count;j++)
                        {
                            var nsdata3 = NSDataOfCell()
                            nsdata3 = ary.objectAtIndex(j) as! NSDataOfCell
                            if(nsdata3.level == "1")
                            {
                                
                                if(nsdata.BXID == nsdata3.BXID)
                                {
                                    ary.removeObjectAtIndex(j)
                                }
                            }
                            
                        }
                    }
                    itemArry.setArray(ary as [AnyObject])
                    tv.reloadData()
                    
                }
            }else{
                
            }
        }
        
    }
    func jiSuanChongDIYue(id:String,indexpath:NSIndexPath) -> NSDictionary
    {
        var index = 0
        var chongDJinE:float_t = 0
        for dic in detileArry
        {
            if(dic.objectForKey("BX_ID") as! String == id)
            {
                //计算第一层的cell 下面有几个二级cell
                index += 1
                
                let idIndex = dic.objectForKey("BXS_ID") as! String
                let arr =  chongDiArry[0] as! NSArray
                for(var i = 0; i < arr.count;i++)
                {
                    let chongDi =  arr.objectAtIndex(i) as! NSDictionary
                    let bs = chongDi.objectForKey("BXS_ID") as! String
                    if(bs == idIndex)
                    {
                       
                         let jintE = chongDi.objectForKey("BC_hongDi") as? String
                        if(jintE != nil)
                        {
                            chongDJinE += float_t(jintE!)!
                        }
                    }
                }

                
            }
        }
        
        index =  index + indexpath.row
        let data = ["index":index,"chongDi":chongDJinE]
        return data
    }
    //插入数据的方法
    func chaRuShuJu(dic:NSDictionary,styleName:String,index:Int,chongDi:String) -> NSDataOfCell
    {
        styleId = styleIdDic.objectForKey(styleName) as!String
        let nsdata = NSDataOfCell()
        nsdata.level = "1"
        nsdata.BXID = dic.objectForKey("BX_ID") as! String
        nsdata.BSAId = dic.objectForKey("BX_AID") as! String
        nsdata.BXS_ID = dic.objectForKey("BXS_ID") as! String
        nsdata.styleIdBX = styleId
        nsdata.index = index
        nsdata.zongChongDiYuE = chongDi
        if (styleId == "AC624F0C-3A8E-4A54-A7EC-C2BA0BE7DFBE")
        {
            //差旅费
            nsdata.projectCL = dic.objectForKey("项目名称") as! String
            nsdata.chuFaTimeCL = dic.objectForKey("出发时间") as! String
            nsdata.chuFaLocationCL = dic.objectForKey("出发地点") as! String
            nsdata.suiXingRenCL = dic.objectForKey("随行人") as! String
            nsdata.daoDaTimeCL = dic.objectForKey("到达时间") as! String
            nsdata.daoDaLocationCl = dic.objectForKey("到达地点") as! String
            nsdata.feiYongCl = dic.objectForKey("费用") as! String
            nsdata.jiaoTongGongJuCL = dic.objectForKey("交通工具") as! String
            nsdata.qiTaFeiYongCL = dic.objectForKey("其他费用") as! String
            nsdata.piaoJuZhangShuCl = dic.objectForKey("票据张数") as! String
            nsdata.zhuSuFeiCl = dic.objectForKey("住宿费") as! String
            nsdata.shiNeiJiaoTongFeiCl = dic.objectForKey("市内交通费") as! String
            nsdata.jiHeTiaoZhengCL = dic.objectForKey("稽核调整") as! String
            nsdata.chuChaiTianShuCl = dic.objectForKey("出差天数") as! String
            nsdata.buZhuFeiCl = dic.objectForKey("补助费") as! String
            nsdata.baoXiaoJinECL = dic.objectForKey("报销金额") as! String
        }else if(styleId == "1DC10AAA-5074-482E-9DC4-B6E721EF8C46"){
            //通讯费
            
            nsdata.zhangDanMonthTX = dic.objectForKey("账单月份") as! String
            nsdata.jinETX = dic.objectForKey("金额") as! String
            nsdata.shiBaoJinETX = dic.objectForKey("实报金额") as! String
            nsdata.faPiaoBianHaoTX = dic.objectForKey("发票编号") as! String
            nsdata.beiZhuTX = dic.objectForKey("备注") as! String
            nsdata.baoXiaoBiLiTX = dic.objectForKey("报销比例") as! String
            nsdata.baoXiaoXianETX = dic.objectForKey("报销限额") as! String
            nsdata.dianZiBanTX = dic.objectForKey("电子版") as! String
        }else if(styleId == "999107B6-4A8D-4718-9F14-2ED4C4EEB318"){
            //市内交通费
            nsdata.projectNameJT = dic.objectForKey("项目名称") as! String
            nsdata.chuFaTimeJT = dic.objectForKey("出发时间") as! String
            nsdata.chuFaLocationJT = dic.objectForKey("出发地点") as! String
            nsdata.daoDaTimeJT = dic.objectForKey("到达时间") as! String
            nsdata.daoDaLocationJT = dic.objectForKey("到达地点") as! String
            nsdata.feiYongJT = dic.objectForKey("费用") as! String
            nsdata.submitTimeJT = dic.objectForKey("提交时间") as! String
            nsdata.beiZhuJT = dic.objectForKey("备注") as! String
        }else if(styleId == "BE9F26FC-2D6D-44CB-ADC8-6187BBC196A9"){
            //通用
            nsdata.suoShuXiangMuTY = dic.objectForKey("项目名称") as! String
            nsdata.wuPinNameTY = dic.objectForKey("物品名称") as! String
            nsdata.wuPinStyleTY = dic.objectForKey("物品类别") as! String
            nsdata.xingHaoTY = dic.objectForKey("型号") as! String
            nsdata.jiaGeTY = dic.objectForKey("价格") as! String
            nsdata.numberTY = dic.objectForKey("数量") as! String
            nsdata.gouMaiDateTY = dic.objectForKey("购买日期") as! String
            nsdata.piaoJuNumberTY = dic.objectForKey("票据张数") as! String
            nsdata.baoXiaoJinETY = dic.objectForKey("金额") as! String
            nsdata.beiZhuTY = dic.objectForKey("备注") as! String
        }else if(styleId == "F67C2ABE-62C0-40DE-BF6A-4A1046AC4F3E" || styleId == "F67C2ABE-62C0-40DE-BF1A-111046AC413E")
        {
            //培训费  会议费
            nsdata.suoShuXiangMuPX = dic.objectForKey("项目名称") as! String
            nsdata.baoXiaoJinEPX = dic.objectForKey("报销金额") as! String
            nsdata.baoXiaoShiYouPX = dic.objectForKey("报销事由") as! String
            nsdata.submitTimePX = dic.objectForKey("提交时间") as! String
            nsdata.fuJianPX = dic.objectForKey("附件") as! String
        }
        return nsdata
    }
    //MARK:返回每种类型的Nib
    func returnStyleCellNib(nsdata:NSDataOfCell,indexpath:NSIndexPath) -> UITableViewCell
    {
        let id =  nsdata.styleIdBX
        if (id == "AC624F0C-3A8E-4A54-A7EC-C2BA0BE7DFBE")
        {
            //差旅费
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellCL")
            let name = ["项目名称","出发时间","出发地点","到达时间","到达地点","随行人","费用","交通工具","其他费用","票据张数","住宿费","市内交通费","稽核调整","出差天数","补助费","报销金额","冲抵"]
            let values = ["\(nsdata.projectCL)","\(nsdata.chuFaTimeCL)","\(nsdata.chuFaLocationCL)","\(nsdata.daoDaTimeCL)","\(nsdata.daoDaLocationCl)","\(nsdata.suiXingRenCL)","\(nsdata.feiYongCl)","\(nsdata.jiaoTongGongJuCL)","\(nsdata.qiTaFeiYongCL)","\(nsdata.piaoJuZhangShuCl)","\(nsdata.zhuSuFeiCl)","\(nsdata.shiNeiJiaoTongFeiCl)","\(nsdata.jiHeTiaoZhengCL)","\(nsdata.chuChaiTianShuCl)","\(nsdata.buZhuFeiCl)","\(nsdata.baoXiaoJinECL)","\(nsdata.BXS_ID)"]
            
            var index = ""
            if(nsdata.index == indexpath.row)
            {
                index = "1"
            }
            addCellLabel(name, value: values,cells:cell, chongDiYuE:nsdata.zongChongDiYuE, indexflag: index)
            return cell
        }else if(id == "1DC10AAA-5074-482E-9DC4-B6E721EF8C46"){
            //通讯费
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellTX")
            let name = ["账单月份","金额","实报金额","发票编号","备注","报销比例","报销限额","电子版"]
            let values = ["\(nsdata.zhangDanMonthTX)","\(nsdata.jinETX)","\(nsdata.shiBaoJinETX)","\(nsdata.faPiaoBianHaoTX)","\(nsdata.beiZhuTX)","\(nsdata.baoXiaoBiLiTX)","\(nsdata.baoXiaoXianETX)","\(nsdata.dianZiBanTX)"]
            
            var index = ""
            if(nsdata.index == indexpath.row)
            {
                index = "1"
            }
            addCellLabel(name, value: values,cells:cell, chongDiYuE:nsdata.zongChongDiYuE, indexflag: index)
            return cell
        
        }else if(id == "999107B6-4A8D-4718-9F14-2ED4C4EEB318"){
            //市内交通费
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellJT")
            let name = ["出发时间","出发地点","到达时间","到达地点","费用","项目名称","提交时间","备注","冲抵"]
            let values = ["\(nsdata.chuFaTimeJT)","\(nsdata.chuFaLocationJT)","\(nsdata.daoDaTimeJT)","\(nsdata.daoDaLocationJT)","\(nsdata.feiYongJT)","\(nsdata.projectNameJT)","\(nsdata.submitTimeJT)","\(nsdata.beiZhuJT)","\(nsdata.BXS_ID)"]
            
            var index = ""
            if(nsdata.index == indexpath.row)
            {
                index = "1"
            }
            addCellLabel(name, value: values,cells:cell, chongDiYuE:nsdata.zongChongDiYuE, indexflag: index)
            return cell
        }else if(id == "BE9F26FC-2D6D-44CB-ADC8-6187BBC196A9"){
            //通用
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellTY")
            let name = ["所属项目","物品名称","物品类别","型号","价格","数量","购买日期","票据张数","报销金额","备注","冲抵"]
            let values = ["\(nsdata.suoShuXiangMuTY)","\(nsdata.wuPinNameTY)","\(nsdata.wuPinStyleTY)","\(nsdata.xingHaoTY)","\(nsdata.jiaGeTY)","\(nsdata.numberTY)","\(nsdata.gouMaiDateTY)","\(nsdata.piaoJuZhangShuCl)","\(nsdata.baoXiaoJinETY)","\(nsdata.beiZhuTY)","\(nsdata.BXS_ID)"]
            
            var index = ""
            if(nsdata.index == indexpath.row)
            {
                index = "1"
            }
            addCellLabel(name, value: values,cells:cell, chongDiYuE:nsdata.zongChongDiYuE, indexflag: index)
            
            return cell
        }else if(id == "F67C2ABE-62C0-40DE-BF6A-4A1046AC4F3E" || id == "F67C2ABE-62C0-40DE-BF1A-111046AC413E"){
            //培训费 会议费
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellPX")
            let name = ["所属项目","报销金额","报销事由","提交时间","附件","冲抵"]
            let values = ["\(nsdata.suoShuXiangMuPX)","\(nsdata.baoXiaoJinEPX)","\(nsdata.baoXiaoShiYouPX)","\(nsdata.submitTimePX)","\(nsdata.fuJianPX)","\(nsdata.BXS_ID)"]
            
            var index = ""
            if(nsdata.index == indexpath.row)
            {
                index = "1"
            }
            addCellLabel(name, value: values,cells:cell, chongDiYuE:nsdata.zongChongDiYuE, indexflag: index)
            return cell
        } else{
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell3")

            return cell
        }
    }
    //添加二级cell的label
    func addCellLabel(name:NSArray,value:NSArray,cells:UITableViewCell,chongDiYuE:String,indexflag:String)
    {
        
        var h:CGFloat = 0.0
        let labelH:CGFloat = 15.0
        for(var i = 0;i < name.count;i++){
            
            if(name.objectAtIndex(i) as! String != "冲抵")
            {
                let nameLab = UILabel()
                nameLab.frame = CGRectMake(10,h,100,labelH)
                
                cells.contentView.addSubview(nameLab)
                
                nameLab.text = name.objectAtIndex(i) as? String
               
                if(name.objectAtIndex(i) as! String == "电子版" || name.objectAtIndex(i) as! String == "附件")
                {
                    let btn =  baoXIaoDownFileBtn()
                    btn.url = value.objectAtIndex(i) as! String
                    btn.frame = CGRectMake(CGRectGetMaxX(nameLab.frame),h,CGRectGetWidth(UIScreen.mainScreen().bounds)-CGRectGetWidth(nameLab.frame),labelH)
                    btn.setTitle(value.objectAtIndex(i) as? String, forState: UIControlState.Normal)
                    btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(16.0)
                    btn.titleLabel?.textAlignment = NSTextAlignment.Left
                    btn.addTarget(self, action: Selector("downLoadBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
                    cells.contentView.addSubview(btn)
                    
                }else{
                    let valueLab = UILabel()
                    valueLab.frame = CGRectMake(CGRectGetMaxX(nameLab.frame),h,CGRectGetWidth(UIScreen.mainScreen().bounds)-CGRectGetWidth(nameLab.frame),labelH)
                    valueLab.text = value.objectAtIndex(i) as? String
                    cells.contentView.addSubview(valueLab)
                }
            }else {
                
                let view = addChongDiLabel(value.objectAtIndex(i) as! String,h:h)
               
                if(CGRectGetHeight(view.frame) > 50)
                {
                    cells.contentView.addSubview(view)
                    h = h + CGRectGetHeight(view.frame)
                    
                    let yuE = UILabel()
                    yuE.frame = CGRectMake(0,h+20,CGRectGetWidth(UIScreen.mainScreen().bounds),20)
                    yuE.textColor = UIColor.redColor()
                    
                    if(indexflag == "1")
                    {
                        yuE.text = "借款余额:" + chongDiYuE
                        cells.contentView.addSubview(yuE)
                        h = h + CGRectGetHeight(yuE.frame) + 1
                    }else{
                        h = h + 1
                    }

                }else{
                 h = h - 15
                }
               
            }
            h = h + labelH + 5
        }

        cellH = h
        let line = UILabel()
        line.frame = CGRectMake(0,cellH-1,CGRectGetWidth(UIScreen.mainScreen().bounds),1)
        line.backgroundColor = UIColor.grayColor()
        cells.contentView.addSubview(line)
    }
    func addChongDiLabel(id:String,h:CGFloat) ->UIView
    {
        let labelH:CGFloat = 15.0
        var h2:CGFloat = 0.0
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.greenColor().CGColor
        view.layer.borderWidth = 1
        
        let title = UILabel()
        title.frame = CGRectMake(0, 0,CGRectGetWidth(UIScreen.mainScreen().bounds)-20, 30)
        title.text = "冲抵借款"
        title.textAlignment = NSTextAlignment.Center
        
        view.addSubview(title)
        h2 = CGRectGetHeight(title.frame)
        let arr =  chongDiArry[0] as! NSArray
        for(var i = 0; i < arr.count;i++)
        {
            let dic =  arr.objectAtIndex(i) as! NSDictionary
            let bs = dic.objectForKey("BXS_ID") as! String
            
            if(bs == id)
            {
                for(var i = 0;i < 5; i++)
                {
                    let nameL = UILabel()
                    nameL.frame =  CGRectMake(10,h2,100,labelH)
                    nameL.textAlignment = NSTextAlignment.Center
                    view.addSubview(nameL)
                    
                    let value = UILabel()
                    value.frame =  CGRectMake(CGRectGetMaxX(nameL.frame),h2,CGRectGetWidth(UIScreen.mainScreen().bounds)-CGRectGetWidth(nameL.frame),labelH)
                    view.addSubview(value)
                    
                    if(i == 0)
                    {
                        nameL.text = "借款金额"
                        value.text = dic.objectForKey("BD_Total") as? String
                    }else if(i == 1){
                        nameL.text = "时间"
                        value.text = dic.objectForKey("BD_Time") as? String
                    }else if(i == 2){
                        nameL.text = "项目"
                        value.text = dic.objectForKey("XM_Name") as? String
                    }else if(i == 3){
                        nameL.text = "已还金额"
                        value.text = dic.objectForKey("YiHuanJinE") as? String
                    }else if(i == 4){
                        nameL.text = "本次冲抵"
                        value.text = dic.objectForKey("BC_hongDi") as? String
                    }
                    
                    h2 = h2 + labelH + 2
                }

            }
        }
        view.frame = CGRectMake(10, h+10,CGRectGetWidth(UIScreen.mainScreen().bounds)-20,h2)
        return view
    }
    //MARK:图片和文件下载的触发事件
    func downLoadBtnAction(button:UIButton)
    {
        let btn = button as! baoXIaoDownFileBtn
        let downURL = GetService + btn.url
        //获取后缀
        let ary = downURL.componentsSeparatedByString(".")
        let separe = ary.last
        //获取名字
        let nameAry = downURL.componentsSeparatedByString("/")
        let name = nameAry.last
        
        if(separe == "png"||separe == "jpg"||separe == "bmp"||separe == "jpeg"||separe == "gif"||separe == "PNG"||separe == "JPG"||separe == "BMP"||separe == "JPEG"||separe == "GIF")
        {
            //图片下载
            let url2 = NSURL(string: downURL)
            let image = UIImage(data: NSData(contentsOfURL: url2!)!)
            showImage = showImageView(frame: CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen.mainScreen().bounds)))
            showImage.name = name!
            showImage.imge = image!
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(showImage)
            window?.makeKeyAndVisible()
        }else{
            //文件下载
            downfile = downLoadFile(frame:CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen.mainScreen().bounds)))
            downfile.url = downURL
            downfile.name = name!
            downfile.delegate = self
            downfile.VC = VC
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(downfile)
            window?.makeKeyAndVisible()
        }
        
    }
    //MARK:downLoadProtocol
    func openDownLoadFile(name: String)
    {
        openfile = openDownloadFile(frame:CGRectMake(0,0,CGRectGetWidth(UIScreen.mainScreen().bounds),CGRectGetHeight(UIScreen.mainScreen().bounds)))
        openfile.name = name
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(openfile)
        window?.makeKeyAndVisible()
    }
    //MARK:点击rightItem 来进行显示 通过和退回的视图
    func reshframe(rightFlag:String)
    {
        if(rightFlag == "1")
        {
            if(itemArry.count > 0)
            {
                rightBtnFlag = rightFlag
                rightBtn.tag = 2
                rightBtn.setTitle("取消", forState: UIControlState.Normal)
                tv.frame = CGRectMake(0,CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(segmentV.frame)-40)
                buttomView = baoXiaoBottomView()
                buttomView.backgroundColor = UIColor.whiteColor()
                buttomView.delegate = self
                buttomView.frame = CGRectMake(0,CGRectGetMaxY(tv.frame),CGRectGetWidth(tv.frame), 40)
                self.addSubview(buttomView)
            }
        }else{
            rightBtnFlag = rightFlag
            rightBtn.tag = 1
            rightBtn.setTitle("批", forState: UIControlState.Normal)
            tv.frame = CGRectMake(0,CGRectGetMaxY(segmentV.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(segmentV.frame))
            buttomView.removeFromSuperview()
        }
        tv.reloadData()
    }
    //MARK:baoXiaoBottomProtocol
    func tuiHuiAction(button: UIButton) {
        
        piFuLoadData("0", id: getId())
    }
    func tongGuoAction(button: UIButton) {
        piFuLoadData("1", id: getId())
    }
    //MAKR:获取批复选中的id
    func getId()->String
    {
        var kqid = ""
        if(itemArry.count > 0)
        {
            for(var i = 0; i < itemArry.count; ++i)
            {
                let nsdata = itemArry.objectAtIndex(i) as! NSDataOfCell
                
                    var id = ""
                    if(nsdata.selectFlag == "1")
                    {
                        //取考勤的id
                        id = nsdata.BXID
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
        VC.presentViewController(alertView, animated:true , completion: nil)
    }
}
