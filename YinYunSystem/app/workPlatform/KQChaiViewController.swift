//
//  KQChaiViewController.swift
//  YinYunSystem
//  出差页面控制器
//  Created by 魏辉 on 16/1/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQChaiViewController: UIViewController, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate {
    
    
    @IBOutlet weak var locationTF: UILabel!
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var firstLocationLabel: UILabel!
    @IBOutlet weak var lastLocationLabel: UILabel!
    
    @IBOutlet weak var firstBT: UIButton!
    @IBOutlet weak var lastBT: UIButton!
    
    

    var httpRequest: HttpRequest!
    // 定位服务
    var locationService: BMKLocationService!
    //当前用户位置
    var userLocation: BMKUserLocation!
    
    // 地理信息搜索
    var locationSearch: BMKGeoCodeSearch!
    // 逆地理信息编码
    var locationOption: BMKReverseGeoCodeOption!
    
    //签到分类
    var num = 0

    //目的地坐标经纬度
    var latitude = ""
    var longitude = ""
    //是否确定了目的地
    var haveAddress = false
    //目的地标题
    var addressTitle = ""
    //当前时间点的出差事件
    var currentChai = KQData()

    override func viewDidLoad() {
        super.viewDidLoad()
        httpRequest = HttpRequest()
        httpRequest.delegate = self
        setLocation()
        dateCompare()
        if currentChai.id != "" {
            
            let bodyStr = "kqid=\(currentChai.id)"
//            print(currentChai.id)
            do {
                try httpRequest.Post2(GetService + "/Mobile/Mobile/JGetTravelKQData", str: bodyStr)
                
            } catch {
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //获取当前时间信息
    func getDate(str: String) -> String{
        let date = NSDate()
        let datefor = NSDateFormatter()
        datefor.dateFormat = str
        let dateStr = datefor.stringFromDate(date)

        
        return dateStr
        
    }
    //日期比较
    func dateCompare() {
        let currentDate = NSDate()
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        for val in todayChai {
            let start = dateFormater.dateFromString(val.startTime)
            let end = dateFormater.dateFromString(val.endTime)
            if currentDate == end?.earlierDate(currentDate) && currentDate == start?.laterDate(currentDate) {
                currentChai = val
                
            }
            
        }
        
    }
    //定位功能设置
    func setLocation() {
        //定位设置
        //定位功能初始化
        locationService = BMKLocationService()
        locationService.delegate = self
        //设置定位精确度
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        //指定最小距离更新
        locationService.distanceFilter = 10
        
        locationService.startUserLocationService()
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        self.userLocation = userLocation
//        print(userLocation.title)
//        print(userLocation.heading)
        
        //获取定位信息后关闭定位功能
        self.locationService.stopUserLocationService()
        if num != 0 {
            setGEO()
        }
    }
    
    //逆地理信息检索
    func setGEO() {
        locationSearch = BMKGeoCodeSearch()
        locationSearch.delegate = self
        let locationCoordinate = userLocation.location.coordinate
        locationOption = BMKReverseGeoCodeOption()
        locationOption.reverseGeoPoint = locationCoordinate
        let flag = locationSearch.reverseGeoCode(locationOption)
        if flag {
            print("反geo检索发送成功！")
        } else {
            print("反geo检索发送失败！")
        }
    }
    //获取逆地理信息检索返回值
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            if num == 1 {
                firstLocationLabel.text = result.address

                firstTimeLabel.text = "\(getDate("HH:mm:ss"))--打卡"
                firstBT.alpha = 0.2
                firstBT.enabled = false
                self.firstBT.setTitle("已签", forState: .Normal)
                //向后台发送数据
                sendIndex()
                
            } else if num == 2 {
                lastLocationLabel.text = result.address
                lastTimeLabel.text = "\(getDate("HH:mm:ss"))--打卡"
                lastBT.alpha = 0.2
                lastBT.enabled = false
                self.lastBT.setTitle("已签", forState: .Normal)
                //向后台发送数据
                sendIndex()
                
            }
        } else {
            print("抱歉，未找到结果")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        //打卡提交
    func sendIndex() {
        let kqid = currentChai.id//考勤ID
        let address = locationTF!.text!//考勤出差地址
        let weidu = latitude//考勤出差地址经度
        let jingdu = longitude//考勤出差地址纬度
        let time = getDate("yyyy-MM-dd HH:mm:ss")//打卡时间
        var pass = ""//是否超出范围
        let dKaddress = firstLocationLabel!.text!//打卡地址
        let dKjindu = userLocation.location.coordinate.longitude//打卡经度
        let dKweidu = userLocation.location.coordinate.latitude//打卡纬度
        
        //计算距离
        let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: Double(weidu)!, longitude: Double(weidu)!))
        let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: dKweidu, longitude: dKjindu))
        let distance = BMKMetersBetweenMapPoints(point1, point2)
        
        if distance <= 5000 {
            pass = "是"
        } else {
            pass = "否"
        }
        let bodyStr = "kqid=\(kqid)&address=\(address)&jingdu=\(jingdu)&weidu=\(weidu)&time=\(time)&pass=\(pass)&DKaddress=\(dKaddress)&DKjingdu=\(dKjindu)&DKweidu=\(dKweidu)&num=\(num)"
        do {
            try httpRequest.Post2(GetService + "/Mobile/Mobile/JAddTravelKQData", str: bodyStr)
        } catch {
            
        }
    }
    
    
}

private typealias Https = KQChaiViewController

extension Https: HttpProtocol {
    
    func didResponse(result: NSDictionary) {
        //获取当天的时间string
        let nowDate = NSDate()
        let dateFor = NSDateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd"
        let today = dateFor.stringFromDate(nowDate)
        
        if let data = result["dt"] {
            let json = JSON(data)
            //            print(json)
            for val in json {
                let time = (val.1["G_Time"].string! as NSString).substringWithRange(NSMakeRange(0, 10))
                locationTF.text = val.1["G_Address"].string
                //判断是否有目的地值
                if val.1["G_Address"].string != nil {
                    self.haveAddress = true
                }
                self.latitude = val.1["G_WeiDu"].string!
                self.longitude = val.1["G_JingDu"].string!
                //判断是否有当天的数据
                if today == time {
                    if val.1["G_Num"].string == "1" {
                        firstTimeLabel.text = (val.1["G_Time"].string! as NSString).substringWithRange(NSMakeRange(11, 8)) + "--打卡"
                        firstLocationLabel.text = val.1["G_TAddress"].string
                        self.firstBT.alpha = 0.2
                        self.firstBT.enabled = false
                        self.firstBT.setTitle("已签", forState: .Normal)
                    } else if val.1["G_Num"].string == "2" {
                        lastTimeLabel.text = (val.1["G_Time"].string! as NSString).substringWithRange(NSMakeRange(11, 8)) + "--打卡"
                        lastLocationLabel.text = val.1["G_TAddress"].string
                        self.lastBT.alpha = 0.2
                        self.lastBT.enabled = false
                        self.lastBT.setTitle("已签", forState: .Normal)
                    }
                }
            }
        }
        
        let flag = result["flag"] as! Int
        if flag != 1 {
            
            let alert = UIAlertController(title: "警告", message: "打卡出错，请检查网络重新打卡！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                if self.num == 1 {
                    self.firstLocationLabel.text = "签到地址"
                    self.firstTimeLabel.text = "打卡时间"
                    self.firstBT.alpha = 1
                    self.firstBT.enabled = true
                    self.firstBT.setTitle("签到", forState: .Normal)
                } else if self.num == 2 {
                    self.lastLocationLabel.text = "签到地址"
                    self.lastTimeLabel.text = "打卡时间"
                    self.lastBT.alpha = 1
                    self.lastBT.enabled = true
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        //        num = 0
    }

}

private typealias Segues = KQChaiViewController

extension Segues {
    //反向转场
    @IBAction func unwindToChai(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToChaiDone(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CheckMapSegue" {
            if let vc = segue.destinationViewController as? KQChaiMapCheckViewController {
                vc.latitute = self.latitude
                vc.longtitute = self.longitude
                vc.addressTitle = self.locationTF.text!
            }
        }
    }

}

private typealias Buttons = KQChaiViewController

extension Buttons {
    
    @IBAction func mapButton(sender: UIButton) {
        dateCompare()
        
        if currentChai.type == "" {
            let alert = UIAlertController(title: "警告", message: "请先新建出差事件再标注地址！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if haveAddress == false{
            performSegueWithIdentifier("MapSegue", sender: self)
        } else if haveAddress == true {
            performSegueWithIdentifier("CheckMapSegue", sender: self)
        }
    }
    
    @IBAction func firstButton(sender: UIButton) {
        if locationTF.text == "请标注出差地址" {
            let alert = UIAlertController(title: "警告", message: "请先标注出差地址再打卡！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if haveAddress == false{
            let alert = UIAlertController(title: "确认", message: "目的地标注为\(locationTF!.text!),点击签到后不能修改，请确认是否继续！", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let done = UIAlertAction(title: "继续", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
                self.haveAddress = true
                self.num = 1
                self.setLocation()
            })
            alert.addAction(done)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if haveAddress == true {
            self.num = 1
            self.setLocation()
        }
        
        
    }
    
    @IBAction func lastButton(sender: UIButton) {
        
        
        if firstBT.enabled == true {
            let alert = UIAlertController(title: "警告", message: "请先进行上班打卡！", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let dateFor = NSDateFormatter()
            //            dateFor.dateFormat = "HH:mm:ss"
            dateFor.dateFormat = "HH"
            let down1 = Int(dateFor.stringFromDate(NSDate()))
            let up1 = Int((firstTimeLabel.text! as NSString).substringWithRange(NSMakeRange(0, 2)))
            if up1 == down1 {
                dateFor.dateFormat = "mm"
                let down2 = Int(dateFor.stringFromDate(NSDate()))
                let up2 = Int((firstTimeLabel.text! as NSString).substringWithRange(NSMakeRange(3, 2)))
                if (up2! + 5) >= down2 {
                    let alert = UIAlertController(title: "警告", message: "上下班打卡间隔小于5分钟！", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    num = 2
                    setLocation()
                }
                //            } else if (up1! + 3) >= down1! {
                //                let alert = UIAlertController(title: "警告", message: "上下班打卡间隔小于3小时！", preferredStyle: UIAlertControllerStyle.Alert)
                //                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                //                alert.addAction(action)
                //                self.presentViewController(alert, animated: true, completion: nil)
            } else if up1 < down1{
                num = 2
                setLocation()
                
            }
        }
        
    }
    
}


