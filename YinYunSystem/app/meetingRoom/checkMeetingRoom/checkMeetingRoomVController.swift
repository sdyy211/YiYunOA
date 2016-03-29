//
//  checkMeetingRoomVController.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class checkMeetingRoomVController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,dataProtocol,selectRoomDelegate,HttpProtocol,UIAlertViewDelegate{
    var url = "/Mobile/Mobile/JMGetList"
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var meetingHomeTextField: UITextField!
    
    @IBOutlet weak var dateTextfield: UITextField!
    
    var request = HttpRequest()
    //默认的处室
    var roomStr = "207"
    
    var tv:UITableView = UITableView()
    var cv : UICollectionView?
    var sv : UIScrollView?
    var selectRoom = checkSelectRoomView()
    var dataPicker = checkDataPickerView()
    var cellHeight:CGFloat = 30
    var btnWith:CGFloat = 0
    //tableview 的宽度
    var tvWith:CGFloat = (CGRectGetWidth(UIScreen.mainScreen().bounds)-30)/7
    var scrollPoint:CGPoint = CGPoint(x: 0, y: 0)
    
    var tvItemArry = NSMutableArray(objects:"8点","9点","10点","11点","12点","13点","14点","15点","16点","17点","18点","19点","20点")
    //存储选择的时间段
    var selectItem = NSMutableArray(capacity:2)
    //存储之前预订的会议室（时间段）
    var hasSelectItem = NSMutableArray()
    //存储后台返回的会议室的id
    var roomIdDic = NSDictionary()
    
    var resultDate = NSDictionary()
    var titleTime = UILabel()
    var time = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "会议室"
        addLeftItem()
        addRightItem()
        request.delegate = self
        initTimeView()
        initView()
      
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
        selectRoom.removeFromSuperview()
        dataPicker.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func addRightItem()
    {
        let btn1 = UIButton(frame: CGRectMake(0, 0,60, 30))
        btn1.setTitle("下一步", forState: UIControlState.Normal)
        btn1.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        btn1.titleLabel?.textAlignment = NSTextAlignment.Right
        btn1.addTarget(self, action: Selector("rightItemAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        let item2=UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item2
    }
    //MARK: 下一步的点击事件
    func rightItemAction(send:UIButton)
    {
        self.performSegueWithIdentifier("pushHYSQ", sender:self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        meetingHomeTextField.text = "\(roomStr)室"
        
        let nowDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.stringFromDate(nowDate)
        dateTextfield.text = dateStr
        loadData()
    }
    //MARK:请求数据
    func loadData()
    {
        selectItem.removeAllObjects()
        hasSelectItem.removeAllObjects()
        loadingAnimationMethod.sharedInstance.startAnimation()
        let str = ["meeting":roomStr,"time":dateTextfield.text!]
        request.Get(GetService + url, parameters : str)
    }
    func didResponse(result: NSDictionary) {
        loadingAnimationMethod.sharedInstance.endAnimation()
        resultDate = NSDictionary(dictionary: result)
        roomIdDic = (resultDate.objectForKey("values") as? NSDictionary)!
        getMaxOrMinValue()
        cv?.reloadData()
    }
    //得到已经选时间段的处理方法
    func getMaxOrMinValue()
    {
        let ary = resultDate.objectForKey("rows")
        
        for(var i = 0;i < ary?.count;++i)
        {
            let dic = ary?.objectAtIndex(i) as! NSDictionary
            let min =  dic.objectForKey("Q_StartTime") as! String
            let minValue = dealMinDate(min)
            let max =  dic.objectForKey("Q_EndTime") as! String
            let maxValue = dealMaxDate(max)
            let hasArry = NSArray(objects:minValue,maxValue)
            hasSelectItem.addObject(hasArry)
        }

    }
    //将日期转成数字的方法
    func dealMinDate(str:String)->NSInteger
    {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timer = formatter.dateFromString(str)
        
        let formatter2:NSDateFormatter = NSDateFormatter()
        formatter2.dateFormat = "HH:mm"
        let dateStr = formatter2.stringFromDate(timer!)
        
        let arry =  dateStr.componentsSeparatedByString(":") as NSArray
        var value = NSInteger()
        for(var i = 0; i < arry.count;++i)
        {
            if(i == 0)
            {
                let str = arry.objectAtIndex(i) as? String
                value = (NSInteger(str!)!-8)*6
            }else if(i == 1){
                let str = arry.objectAtIndex(i) as? String
                value = value + (NSInteger(str!)!/10)
            }
        }
        return value
    }
    //将日期转成数字的方法
    func dealMaxDate(str:String)->NSInteger
    {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timer = formatter.dateFromString(str)
        
        let formatter2:NSDateFormatter = NSDateFormatter()
        formatter2.dateFormat = "HH:mm"
        let dateStr = formatter2.stringFromDate(timer!)
        
        let arry =  dateStr.componentsSeparatedByString(":") as NSArray
        var value = NSInteger()
        for(var i = 0; i < arry.count;++i)
        {
            if(i == 0)
            {
                let str = arry.objectAtIndex(i) as? String
                value = (NSInteger(str!)!-8)*6
            }else if(i == 1){
                let str = arry.objectAtIndex(i) as? String
                value = value + (NSInteger(str!)!/10)-1
            }
        }
        return value
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func initView()
    {
        meetingHomeTextField.delegate = self
        dateTextfield.delegate = self
        //添加tableview
        tv = UITableView()
        tv.frame =  CGRectMake(10,CGRectGetMaxY(timeView.frame),tvWith,CGRectGetHeight(UIScreen.mainScreen().bounds)-CGRectGetMaxY(timeView.frame))
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = true
        tv.scrollEnabled = false
        self.view.addSubview(tv)
        
        //添加scrollView
        sv = UIScrollView()
        sv!.frame = CGRectMake(CGRectGetMaxX(tv.frame),CGRectGetMaxY(timeView.frame),(CGRectGetWidth(UIScreen.mainScreen().bounds) - CGRectGetMaxX(time.frame)-10),CGRectGetHeight(tv.frame))
        sv!.backgroundColor = UIColor.whiteColor()
        sv!.delegate = self
        sv!.bounces = false
        sv!.contentSize = CGSize(width: btnWith*6,height: CGFloat(tvItemArry.count)*cellHeight)
        self.view.addSubview(sv!)
        //添加 collectionview
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        cv = UICollectionView(frame: CGRectMake(0, 0,CGRectGetWidth((sv?.frame)!),CGRectGetHeight((sv?.frame)!)),collectionViewLayout:layout)
        cv?.registerClass(checkMeetingRoomCollectionCell.self, forCellWithReuseIdentifier:"cell")
        cv?.delegate = self
        cv?.dataSource = self
        cv?.backgroundColor = UIColor.whiteColor()
        layout.itemSize = CGSizeMake(btnWith,cellHeight)
        sv?.addSubview(cv!)
    }
    func initTimeView()
    {
        time = UILabel()
        time.frame = CGRectMake(10, 2, tvWith,26)
        time.text = "时间"
        time.font = UIFont.systemFontOfSize(12.0)
        time.textColor = UIColor.whiteColor()
        time.textAlignment = NSTextAlignment.Center
        time.backgroundColor = UIColor(red: 155.0/255.0, green: 192.0/255.0, blue: 216.0/255.0, alpha: 1)
        timeView.addSubview(time)
        // 这是计算collection的宽度
        btnWith = (CGRectGetWidth(UIScreen.mainScreen().bounds) - CGRectGetMaxX(time.frame)-10)/6
        
        titleTime = UILabel()
        titleTime.frame = CGRectMake(CGRectGetMaxX(time.frame)+1, 2,CGRectGetWidth(UIScreen.mainScreen().bounds)-CGRectGetMaxX(time.frame)-10-btnWith-3,26)
        titleTime.text = "预订情况"
        titleTime.font = UIFont.systemFontOfSize(12.0)
        titleTime.textColor = UIColor.whiteColor()
        titleTime.textAlignment = NSTextAlignment.Center
        titleTime.backgroundColor = UIColor(red: 155.0/255.0, green: 192.0/255.0, blue: 216.0/255.0, alpha: 1)
        timeView.addSubview(titleTime)
        
        let btn = UIButton()
        btn.frame = CGRectMake(CGRectGetMaxX(titleTime.frame)+1,CGRectGetMinY(titleTime.frame),btnWith,CGRectGetHeight(titleTime.frame))
        btn.setTitle("清除", forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(12.0)
        btn.backgroundColor = UIColor(red: 155.0/255.0, green: 192.0/255.0, blue: 216.0/255.0, alpha: 1)
        btn.addTarget(self, action: Selector("clearBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        timeView.addSubview(btn)
        
    }
    func getData(data: String) {
        dateTextfield.text = data
        dateTextfield.resignFirstResponder()
        loadData()
    }
    
    func getRoomName(roomName: String) {
        roomStr = roomName
        meetingHomeTextField.text = roomStr + "室"
        meetingHomeTextField.resignFirstResponder()
        loadData()
    }
    //Mark  UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
       
        selectRoom.removeFromSuperview()
        
        if(textField.tag == 1)
        {
             meetingHomeTextField.resignFirstResponder()
            selectRoom.removeFromSuperview()
            let itemAry = NSMutableArray(objects:"207","217","415")
            var height = CGFloat(itemAry.count) * 30
            if(height > 350)
            {
                height = 350
            }
            selectRoom = checkSelectRoomView()
            selectRoom.delegate = self
            selectRoom.frame = CGRectMake(CGRectGetMinX(meetingHomeTextField.frame)-4,CGRectGetMaxY(meetingHomeTextField.frame)+CGRectGetMinY(headerView.frame),CGRectGetWidth(meetingHomeTextField.frame), height)
            selectRoom.itemArray = itemAry
            selectRoom.backgroundColor = UIColor.whiteColor()
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(selectRoom)
            
        }else if(textField.tag == 2){
            dateTextfield.resignFirstResponder()
            dataPicker.removeFromSuperview()
            dataPicker = checkDataPickerView(frame: CGRectMake(0,CGRectGetHeight(UIScreen.mainScreen().bounds)-220,CGRectGetWidth(UIScreen.mainScreen().bounds), 220))
            
            dataPicker.delegate = self
            dataPicker.backgroundColor = UIColor.whiteColor()
            let window = UIApplication.sharedApplication().keyWindow
            window?.addSubview(dataPicker)
        }else{
            meetingHomeTextField.resignFirstResponder()
            dateTextfield.resignFirstResponder()
        }
        
    }
    //MARK: tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvItemArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight;
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0, tvWith, cellHeight-1)
        label.text = tvItemArry.objectAtIndex(indexPath.row) as? String
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(12.0)
        cell.contentView.addSubview(label)
        
        //横
        let line = UILabel()
        line.frame = CGRectMake(0,CGRectGetMaxY(label.frame), tvWith,1)
        line.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(line)
        //竖
        let shu = UILabel()
        shu.frame = CGRectMake(CGRectGetWidth(label.frame)-1,0,1,cellHeight-1)
        shu.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(shu)
        
        cell.backgroundColor = UIColor(colorLiteralRed: 238.0/255.0, green: 247.0/255.0, blue: 244.0/255.0, alpha: 1)
        return cell
    }
    //MARK:  collectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (tvItemArry.count * 6)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     
        selectRoom.removeFromSuperview()
        dataPicker.removeFromSuperview()
        collectionView.registerNib(UINib(nibName:"checkMeetingRoomCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let cell:checkMeetingRoomCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! checkMeetingRoomCollectionCell
        cell.backgroundColor = UIColor(colorLiteralRed: 226.0/255.0, green: 236.0/255.0, blue: 243.0/255.0, alpha: 1)
//        cell.rightLine.hidden = false
//        cell.backgroundView = UIImageView(image: UIImage(named:"inchoose"))
        //判断自己选择的会议室时间段
        cell.rightLine.hidden = false
        cell.bow.hidden = false
        if(selectItem.count > 0)
        {
            if(selectItem.count == 1)
            {
                let minvalue:NSInteger = selectItem.objectAtIndex(0) as! NSInteger
                if(minvalue == indexPath.row)
                {
                    cell.backgroundColor = UIColor.blueColor()
                }
            }else if(selectItem.count == 2){
                let minvalue:NSInteger = selectItem.objectAtIndex(0) as! NSInteger
                let maxvalue:NSInteger = selectItem.objectAtIndex(1) as! NSInteger
                for(var i = minvalue; i <= maxvalue; ++i)
                {
                    if(indexPath.row == i)
                    {
                        cell.backgroundColor = UIColor.blueColor()
                    }
                }
            }
        }
        //判断已经预订的会议室时间
        if(hasSelectItem.count > 0)
        {
            
            for(var i = 0; i < hasSelectItem.count;++i)
            {
                let arry = hasSelectItem.objectAtIndex(i) as! NSArray
                if(arry.count > 0)
                {
                    if(arry.count == 1)
                    {
                        let minvalue:NSInteger = arry.objectAtIndex(0) as! NSInteger
                        if(minvalue == indexPath.row)
                        {
                             cell.backgroundColor = UIColor(colorLiteralRed: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
//                            cell.backgroundView = UIImageView(image: UIImage(named:"choosed"))
                        }
                    }else if(arry.count == 2){
                        let minvalue:NSInteger = arry.objectAtIndex(0) as! NSInteger
                        let maxvalue:NSInteger = arry.objectAtIndex(1) as! NSInteger
                        
                        for(var i = minvalue; i <= maxvalue; ++i)
                        {
                            if(indexPath.row == i)
                            {
                                
                                let remainderNum = i%6-1
                                let hour = i/6+8
                                var index = 0
                                for(var j = minvalue; j <= maxvalue; ++j)
                                {
                                    let hour2 = minvalue/6+8
                                    //判断是否在最小时间的一样。
                                    if(hour == hour2)
                                    {
                                        cell.bow.hidden = false
                                    }else{
                                        let remainderNum2 = j%6-1
                                        
                                        if(remainderNum == remainderNum2)
                                        {
                                            if(i == j)
                                            {
                                                break
                                            }else{
                                                index = index + 1
                                            }
                                        }
                                    
                                    }
                                }
                                if(index >= 1)
                                {
                                    cell.bow.hidden = true
                                }
                                if(maxvalue == indexPath.row)
                                {
                                    cell.rightLine.hidden = false
                                }else{
                                    cell.rightLine.hidden = true
                                }

                                cell.backgroundColor = UIColor(colorLiteralRed: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1)
//                                cell.backgroundView = UIImageView(image: UIImage(named:"choosed"))
                            }
                        }
                    }
                }
                
            }
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0,0,0,0)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        resignFirstORRemove()
        addSelecyItemMethod(indexPath)
    }
    //添加item 的方法
    func addSelecyItemMethod(indexPath:NSIndexPath)
    {
        if(selectItem.count <= 2 ){
            
            if(selectItem.count == 2)
            {
                let minvalue:NSInteger = selectItem.objectAtIndex(0) as! NSInteger
                let maxvalue:NSInteger = selectItem.objectAtIndex(1) as! NSInteger
                let flag =  panduan(indexPath, value:maxvalue)
                if(flag == 1)
                {
                    if(indexPath.row < minvalue)
                    {
                        selectItem.replaceObjectAtIndex(0, withObject:indexPath.row)
                    }
                    if(indexPath.row > minvalue && indexPath.row < maxvalue)
                    {
                        let middle = (minvalue + maxvalue)/2
                        if(indexPath.row < middle)
                        {
                            selectItem.replaceObjectAtIndex(0, withObject:indexPath.row)
                            
                        }
                        if(indexPath.row > middle)
                        {
                            
                            selectItem.replaceObjectAtIndex(1, withObject:indexPath.row)
                            
                        }
                        if(indexPath.row == middle)
                        {
                            selectItem.replaceObjectAtIndex(1, withObject:indexPath.row)
                        }
                    }
                    if(indexPath.row > maxvalue)
                    {
                        selectItem.replaceObjectAtIndex(1, withObject:indexPath.row)
                    }
                    if(indexPath.row == minvalue)
                    {
                        if(maxvalue == minvalue)
                        {
                            selectItem.removeAllObjects()
                        }else{
                            selectItem.replaceObjectAtIndex(0, withObject:indexPath.row+1)
                        }
                    }
                    if(indexPath.row == maxvalue)
                    {
                        if(maxvalue == minvalue)
                        {
                            selectItem.removeAllObjects()
                        }else{
                            selectItem.replaceObjectAtIndex(1, withObject:indexPath.row-1)
                        }
                    }
                    cv!.reloadData()
                }else if(flag == 2){
                    
                }else if(flag == 3){
                    alter("警告", message: "不能在选中的情况下查看详情")
                }else if(flag == 0){
                    alter("警告", message: "不能选择此时间段，因为此时间段已经被预订")
                }
                
            }else if(selectItem.count == 1){
                //判断不添加相同的数
                let value = selectItem.objectAtIndex(0) as! NSInteger
                if(indexPath.row != value)
                {
                    if(value > indexPath.row)
                    {
                       let flag =  panduan(indexPath, value:value)
                       if(flag == 1)
                       {
                        selectItem.replaceObjectAtIndex(0, withObject:indexPath.row)
                        selectItem.addObject(value)
                       }else if(flag == 2){
                        
                       }else if(flag == 3){
                        alter("警告", message: "不能在选中的情况下查看详情")
                       }else if(flag == 0){
                        alter("警告", message: "不能选择此时间段，因为此时间段已经被预订")
                        }
                        
                    }else{
                        let flag =  panduan(indexPath, value:value)
                        if(flag == 1)
                        {
                            selectItem.addObject(indexPath.row)
                        }else if(flag == 2){
                            
                        }else if(flag == 3){
                            alter("警告", message: "不能在选中的情况下查看详情")
                        }else if(flag == 0){
                            alter("警告", message: "不能选择此时间段，因为此时间段已经被预订")
                        }
                    }
                    cv!.reloadData()
                }else if(indexPath.row == value){
                    selectItem.removeAllObjects()
                    cv!.reloadData()
                }
            }else if(selectItem.count == 0){
                let flag =  panduan(indexPath, value:0)
                if(flag == 1)
                {
                    selectItem.addObject(indexPath.row)
                    cv!.reloadData()
                }else if(flag == 2){
                    
                }else if(flag == 3){
                    alter("警告", message: "不能在选中的情况下查看详情")
                }else if(flag == 0){
                    alter("警告", message: "不能选择此时间段，因为此时间段已经被预订")
                }
            }
        }

    }
    func alter(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }
    //判断在点击的范围是否在所有预订时间的范围之内 flag = 0 显示不能在已选择的范围内选择  flag = 1 能进行选择  flag ＝ 2 能进行跳转  flag ＝ 3 判断不能选择了时间段进行跳转
    func panduan(index:NSIndexPath,value:NSInteger)->NSInteger
    {
        var flage = NSInteger()
        if(value == 0)
        {
            if(hasSelectItem.count > 0)
            {
                for(var i = 0;i < hasSelectItem.count; ++i)
                {
                    let arry = hasSelectItem.objectAtIndex(i) as! NSArray
                    let minValue = arry.objectAtIndex(0) as! NSInteger
                    let maxValue = arry.objectAtIndex(1) as! NSInteger
                    if(index.row > minValue && index.row < maxValue)
                    {
                        if(selectItem.count > 0)
                        {
                            flage = 3
                            break
                        }else{
                            flage = 2
                            jumpDetilePage(i)
                            continue
                        }
                       
                    }else if(index.row == minValue || index.row == maxValue){
                        if(selectItem.count > 0)
                        {
                            flage = 3
                             break
                        }else{
                            flage = 2
                            jumpDetilePage(i)
                            continue
                        }
                       
                    }else if(index.row < minValue){
                        flage = 1
                        break
                    }else if(index.row > maxValue){
                        flage = 1
                    }
                }
            }else{
                flage = 1
            }
        }else{
            if(index.row < value)
            {
                if(hasSelectItem.count > 0)
                {
                    for(var i = 0;i < hasSelectItem.count; ++i)
                    {
                        let arry = hasSelectItem.objectAtIndex(i) as! NSArray
                        let minValue = arry.objectAtIndex(0) as! NSInteger
                        let maxValue = arry.objectAtIndex(1) as! NSInteger
                        if(index.row > minValue && index.row < maxValue)
                        {
                            flage = 0
                            break
                        }else if(index.row < minValue && value > maxValue){
                            flage = 0
                            break
                        }else if(index.row == minValue || index.row == maxValue){
                            if(selectItem.count > 0)
                            {
                                flage = 3
                                break
                            }else{
                                flage = 2
                                jumpDetilePage(i)
                                continue
                            }
                        }else {
                            flage = 1
//                            break
                        }
                        
                    }

                }else{
                    flage = 1
                }
            }else if(index.row > value){
                if(hasSelectItem.count > 0)
                {
                    
                    for(var i = 0;i < hasSelectItem.count; ++i)
                    {
                        let arry = hasSelectItem.objectAtIndex(i) as! NSArray
                        let minValue = arry.objectAtIndex(0) as! NSInteger
                        let maxValue = arry.objectAtIndex(1) as! NSInteger
                        if(index.row > minValue && index.row < maxValue)
                        {
                            if(selectItem.count > 0)
                            {
                                 flage = 3
                            }else{
                                 flage = 0
                            }
                            break
                        }else if(value < minValue && index.row > maxValue){
                            flage = 0
                            break
                        }else if(index.row == minValue || index.row == maxValue){
                            if(selectItem.count > 0)
                            {
                                flage = 3
                                break
                            }else{
                                flage = 2
                                jumpDetilePage(i)
                                continue
                            }
                        }else if(value < index.row && index.row > maxValue && value > maxValue){
                            
                                flage = 1
                        }else {
                            flage = 1
                            break
                        }
                        
                    }
                }else{
                    flage = 1
                }
               
            }else{
                flage = 1
            }

        }
        return flage
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        resignFirstORRemove()
        if(scrollView.classForCoder.isSubclassOfClass(tv.classForCoder))
        {
            let point:CGPoint = scrollView.contentOffset
            let point2:CGPoint = CGPointMake(scrollPoint.x, point.y)
            sv!.setContentOffset(point2, animated:true)
            
        }else{
            scrollPoint  = scrollView.contentOffset;
            let table1Point = CGPointMake(0, scrollPoint.y);
            tv.setContentOffset(table1Point, animated: false)
        }
    }
    func alter2(title:String,message:String)
    {
        let alertView =  UIAlertController.init(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertViewCancelAction: UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertView.addAction(alertViewCancelAction)
        self.presentViewController(alertView, animated:true , completion: nil)
    }

    // MARK: 计算时间的方法..
    func dealMin(index:NSInteger)->String
    {
        let integerNum = index/6
        let remainderNum = index%6
        var timeStr = ""
        if(remainderNum == 0){
            timeStr = "\(integerNum+8):00"
        }else{
            if(remainderNum*10+10 == 60)
            {
                timeStr = "\(integerNum+9):00"
            }else{
                timeStr = "\(integerNum+8):\(remainderNum*10)"
            }
        }
        return timeStr
    }

    func dealMax(index:NSInteger)->String
    {
        let integerNum = index/6
        let remainderNum = index%6
        var timeStr = ""
        
        if(remainderNum*10+10 == 60)
        {
            timeStr = "\(integerNum+9):00"
        }else{
            timeStr = "\(integerNum+8):\(remainderNum*10+10)"
        }
       return timeStr
    }
    // MARK:当选择一个item时，对时间的判断
    func dealMaxorMinOfOneSelectItem(index:NSInteger)->NSMutableDictionary
    {
        let timeDic = NSMutableDictionary()
        let integerNum = index/6
        let remainderNum = index%6
        var timeMax = ""
        var timeMin = ""
        
        if(remainderNum*10 == 0)
        {
            timeMin = "\(integerNum+8):00"
        }else{
            timeMin = "\(integerNum+8):\(remainderNum*10)"
        }
        timeDic.setValue(timeMin, forKey: "min")
        if(remainderNum*10+10 == 60)
        {
            timeMax = "\(integerNum+9):00"
            
        }else{
            timeMax = "\(integerNum+8):\(remainderNum*10+10)"
        }
        timeDic.setValue(timeMax, forKey: "max")

        return timeDic
    }

    func resignFirstORRemove()
    {
        selectRoom.removeFromSuperview()
        meetingHomeTextField.resignFirstResponder()
        dateTextfield.resignFirstResponder()

    }
    // MARK: 清除按钮的点击事件
    @IBAction func clearBtnAction(sender: AnyObject) {
        selectItem.removeAllObjects()
        cv?.reloadData()
//        loadData()
    }
    // MARK: 点击已选中时间段的范围进行跳转页面
    func jumpDetilePage(row:NSInteger)
    {
        let ary = resultDate.objectForKey("rows")
//        let data  =  ary?.objectAtIndex(row) as? NSDictionary
        let dataArray = NSMutableArray()
        dataArray.addObject(ary!.objectAtIndex(row))

//        self.performSegueWithIdentifier("checkPushDetile", sender:self)
//        let vc:fixedAssetsViewController = fixedAssetsViewController()
        let vc:myselfMeetRoomDetileVController = myselfMeetRoomDetileVController()
        vc.itemArry = dataArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: 跳转页面的函数
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var maxTime = ""
        var minTime = ""
        var timeDic = NSMutableDictionary()
        if(meetingHomeTextField.text == nil || dateTextfield.text == nil)
        {
            alter2("提示", message:"请检查选择的处室和时间是否为空。。")
        }else{
            if(selectItem.count == 0)
            {
                alter2("提示", message:"请检查选中的开始时间和结束时间。。")
            }else{
                if(selectItem.count == 1)
                {
                    let value = selectItem.objectAtIndex(0)
                    timeDic = dealMaxorMinOfOneSelectItem(NSInteger(value as! NSNumber))
                    minTime = timeDic.objectForKey("min") as! String
                    maxTime = timeDic.objectForKey("max") as! String
                    
                }else if(selectItem.count == 2){
                    for(var i=0;i < selectItem.count;++i)
                    {
                        let value = selectItem.objectAtIndex(i)
                        if(i == 0)
                        {
                            minTime = dealMin(NSInteger(value as! NSNumber))
                        }else if(i == 1){
                            maxTime = dealMax(NSInteger(value as! NSNumber))
                        }
                    }
                }
            
                let  channel:checkMeetingRoomApplyVController = segue.destinationViewController as! checkMeetingRoomApplyVController
                channel.roomName = meetingHomeTextField.text!
                channel.startTime = "\(dateTextfield.text!) \(minTime):00"
                channel.endTime = "\(dateTextfield.text!) \(maxTime):00"
                channel.roomId = roomIdDic.objectForKey("\(roomStr)会议室") as! String
                channel.style = "1"
            }
        }
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignFirstORRemove()
        selectRoom.removeFromSuperview()
        dataPicker.removeFromSuperview()
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
