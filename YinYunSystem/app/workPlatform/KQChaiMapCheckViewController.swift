//
//  KQChaiMapCheckViewController.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQChaiMapCheckViewController: UIViewController, BMKMapViewDelegate, BMKPoiSearchDelegate, BMKGeneralDelegate, BMKLocationServiceDelegate {
    
    var mapview: BMKMapView?
    // 定位服务
    var locationService:BMKLocationService!
    //当前用户位置
    var userLocation: BMKUserLocation!
    var latitute = ""
    var longtitute = ""
    var addressTitle = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let locManager = CLLocationManager()
//        locManager.requestWhenInUseAuthorization()

        //36.643694, 117.047790
        mapview = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mapview?.region = BMKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(latitute)!, longitude: Double(longtitute)!), span: BMKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))
        mapview?.zoomLevel = 17.5
        mapview?.showsUserLocation = true
        
        self.view.addSubview(mapview!)
        
        //定位设置
        locationService = BMKLocationService()
        locationService.delegate = self
        //设置定位精确度
        locationService.desiredAccuracy = kCLLocationAccuracyBest
        //指定最小距离更新
        locationService.distanceFilter = 10
        locationService.startUserLocationService()
        mapview!.showsUserLocation = true
        mapview!.updateLocationData(userLocation)
        

    }
    
    // MARK: 定位
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        mapview!.updateLocationData(userLocation)
        self.userLocation = userLocation
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapview?.viewWillAppear()
        mapview?.delegate = nil
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapview?.viewWillDisappear()
        mapview?.delegate = nil

        
    }
    
    override func viewDidAppear(animated: Bool) {
        //添加一个PointAnnotation   36.6496910000,117.0552460000
        let annotation = BMKPointAnnotation()
        let coor = CLLocationCoordinate2D(latitude: Double(latitute)!, longitude: Double(longtitute)!)
        annotation.coordinate = coor
        annotation.title = "目的地"
        annotation.subtitle = addressTitle
        mapview?.addAnnotation(annotation)

    }
    
    func onGetPermissionState(iError: Int32) {
        print(iError)
    }
    
 
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKindOfClass(BMKPointAnnotation) {
            let newAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "myAnnotation")
            newAnnotationView.pinColor = UInt(BMKPinAnnotationColorPurple)
            newAnnotationView.animatesDrop = true
            return newAnnotationView
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
