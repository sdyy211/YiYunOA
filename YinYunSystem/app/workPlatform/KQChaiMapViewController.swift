//
//  KQChaiMapViewController.swift
//  YinYunSystem
//  出差目的地地图页面控制器
//  Created by 魏辉 on 16/1/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQChaiMapViewController: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate {
    
    
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var searchBT: UIButton!
    
    //百度地图视图
    var mapView: BMKMapView!
    // Poi搜索
    var poiSearch: BMKPoiSearch!
    // 定位服务
    var locationService:BMKLocationService!
    //当前用户位置
    var userLocation: BMKUserLocation!
    //选择的地址
    var chooseLocation = ""
    var chooseTitle = ""
    //目的地坐标
    var coordinate:CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityTF.delegate = self
        locationTF.delegate = self
        
        // 地图界面初始化
        mapView = BMKMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.zoomLevel = 6
        mapView.isSelectedAnnotationViewFront = true
        // 创建地图视图约束
        var constraints = [NSLayoutConstraint]()
        constraints.append(mapView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor))
        constraints.append(mapView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor))
        constraints.append(mapView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor))
        constraints.append(mapView.topAnchor.constraintEqualToAnchor(searchBT.bottomAnchor, constant: 23))
        self.view.addConstraints(constraints)
        
        //Poi 搜索初始化
        poiSearch = BMKPoiSearch()

    }
    
 
    // MARK: 定位
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        self.userLocation = userLocation
    }
    
    // MARK: 覆盖物协议设置
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 生成重用标示 ID
        let annotationViewID = "Mark"
        
        //检查是否有重用的缓存
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewID) as? BMKPinAnnotationView
        // 缓存若没有命中，则自己构造一个
        if annotationView == nil {
            annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewID)
            annotationView?.pinColor = UInt(BMKPinAnnotationColorRed)
            //设置标注动画效果
            annotationView?.animatesDrop = true
        }
        
        //设置位置
        annotationView!.centerOffset = CGPointMake(0, -((annotationView!.frame.size.height) * 0.5))
        annotationView?.annotation = annotation
        //单机弹出泡泡
        annotationView?.canShowCallout = true
        // 设置是否可以拖拽
        annotationView?.draggable = false
        
        return annotationView
    }
    
    func mapView(mapView: BMKMapView!, didSelectAnnotationView view: BMKAnnotationView!) {
        mapView.bringSubviewToFront(view)
        mapView.setNeedsDisplay()

        let alert = UIAlertController(title: "确认地址:\(view.annotation.title!())", message: view.annotation.subtitle!(), preferredStyle: UIAlertControllerStyle.ActionSheet)
        let action = UIAlertAction(title: "选中", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.chooseLocation = view.annotation.title!() + "\n" + view.annotation.subtitle!()
            self.chooseTitle = view.annotation.title!()
            self.coordinate = view.annotation.coordinate
            self.performSegueWithIdentifier("UnwindToChaiDone", sender: self)
        }
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Poi 搜索的相关方法实现
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        // 清除屏幕中所有的annotation
        let array = mapView.annotations
        mapView.removeAnnotations(array)
        if errorCode.rawValue == 0 {
            
            for i in 0..<poiResult.poiInfoList.count {
                let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                let item = BMKPointAnnotation()
                item.coordinate = poi.pt
                item.title = poi.name
                item.subtitle = poi.address
                mapView.addAnnotation(item)
                if i == 0 {
                    //将第一个点的坐标移到屏幕中央
                    mapView.centerCoordinate = poi.pt
                    mapView.zoomLevel = 14

                }
            }
            
            //定位设置
            locationService = BMKLocationService()
            locationService.delegate = self
            //设置定位精确度
            locationService.desiredAccuracy = kCLLocationAccuracyBest
            //指定最小距离更新
            locationService.distanceFilter = 10
            locationService.startUserLocationService()
            mapView.showsUserLocation = true
            mapView.updateLocationData(userLocation)
            
        } else {
            print("获取poi失败")
        }
    }
    // MARK: 内存管理
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 协议代理设置
    
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放济南
        poiSearch.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        poiSearch.delegate = nil
    }
}

private typealias Segues = KQChaiMapViewController

extension Segues {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UnwindToChaiDone" {
            if chooseLocation == "" {
                let alert = UIAlertController(title: "警告", message: "未选中地址，无法保存", preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let viewController = segue.destinationViewController as! KQChaiViewController
            viewController.locationTF.text = chooseLocation
            viewController.addressTitle = chooseTitle
            viewController.latitude = String(self.coordinate.latitude)
            viewController.longitude = String(self.coordinate.longitude)
            //            viewController.haveAddress = true
        }
    }
}

private typealias TextFieldDelegate = KQChaiMapViewController

extension TextFieldDelegate: UITextFieldDelegate {
    // 点击return会隐藏键盘
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityTF.resignFirstResponder()
        locationTF.resignFirstResponder()
        textField.resignFirstResponder()
        
        return true
    }
    
    //点击空白处会隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.cityTF.resignFirstResponder()
        self.locationTF.resignFirstResponder()
    }

}

private typealias Buttons = KQChaiMapViewController

extension Buttons {
    
    @IBAction func searchButton(sender: UIButton) {
        
        self.cityTF.resignFirstResponder()
        self.locationTF.resignFirstResponder()
        
        let city = cityTF.text
        let location = locationTF.text
        
        if city == "" || location == "" {
            let alert = UIAlertController(title: "警告", message: "有选项未输入，无法查询", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        let citySearchOption = BMKCitySearchOption()
        citySearchOption.pageIndex = 0
        citySearchOption.pageCapacity = 20
        citySearchOption.city = cityTF.text
        citySearchOption.keyword = locationTF.text
        
        if poiSearch.poiSearchInCity(citySearchOption) {
            print("城市内检索发送成功！")
        } else {
            print("城市内检索发送失败！")
        }
        
    }
    @IBAction func doneButton(sender: UIBarButtonItem) {
        
    }

}

