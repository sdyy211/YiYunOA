//
//  fixedDetileBorrowView.swift
//  固定资产的借用设备页面
//
//  Created by Mac on 16/1/15.
//
//

import UIKit
import AVFoundation
class fixedDetileBorrowView: UIView,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate{

    var tv:UITableView = UITableView()
    var cv:UIView = UIView()
    var vc :UINavigationController = UINavigationController();
    var megDic:NSDictionary = NSDictionary()
    var itemArry:NSArray = NSArray()
    var titleArry:NSArray = NSArray()
    var height:CGFloat = 0
    var with:CGFloat = 300
    
    
//    var session = AVCaptureSession()
//    var preView: AVCaptureVideoPreviewLayer!
//    
//    var device : AVCaptureDevice!
//    var input  : AVCaptureDeviceInput!
//    var output : AVCaptureMetadataOutput!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleArry = NSArray(objects:"设备名称","设备号","借用人","借用人电话","部门名称","借用日期","借用原因")
        let index:Int = (titleArry.count) * 35 
        height = CGFloat(Float(index))+80
        
        self.tag = 0
        
        let button:UIButton = UIButton()
        button.frame = CGRectMake(40,20,200,40);
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("扫一扫", forState:UIControlState.Normal)
        button.addTarget(self, action:Selector("buttonAction"), forControlEvents:UIControlEvents.TouchUpInside)
        cv.addSubview(button)
        
        cv.frame =  CGRectMake((CGRectGetWidth(UIScreen.mainScreen().bounds)-with)/2,(CGRectGetHeight(UIScreen.mainScreen().bounds)-height)/2, with, height)
        cv.backgroundColor = UIColor.whiteColor()
        cv.tag = 1
        cv.layer.cornerRadius = 20
        self.addSubview(cv)
    }
    func initCV()
    {
        var value:CGFloat = 60
        for(var i=0 ; i<7 ; ++i)
        {
            let label:UILabel = UILabel()
            label.frame = CGRectMake(0, value, CGRectGetWidth(self.cv.frame),25)
            label.backgroundColor = UIColor.redColor()
            let str:String = self.data(i)
            label.text = "\(titleArry.objectAtIndex(i)) : \(str)"
            label.tag = i
            value += 27
            cv.addSubview(label)
        }
        let textView:UITextView = UITextView()
        textView.frame = CGRectMake(0,value, CGRectGetWidth(self.cv.frame),80)
        cv.addSubview(textView)
    }
    func data(index:Int) ->String
    {
        var str:String = ""
        let meg:NSDictionary = megDic.objectForKey("meg") as! NSDictionary
        switch(index)
        {
        case 0:
            str = megDic.objectForKey("dev") as! String
            break;
        case 1:
            str = megDic.objectForKey("dev_num") as! String
            break;
        case 2:
            str = "使用登录用户的信息"
            break;
        case 3:
            str = "使用登录用户的信息"
            break;
        case 4:
            str = "使用登录用户的信息"
            break;
        case 5:
            str = "使用登录用户的信息"
            break;
        case 5:
            str = ""
            break;
        default:
            break;
        }
        return str
    }
    func buttonAction()
    {
//        self.removeFromSuperview()f c
        let QR:QrCodeViewController = QrCodeViewController()
        vc.pushViewController(QR, animated: true)
    }
    override func drawRect(rect: CGRect) {
         initCV()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for(var i=0 ; i < touches.count ; ++i)
        {
            print("\(touches.first)")
            
        }
        let touch:UITouch = touches.first!
        if(touch.view?.tag == 0)
        {
            self.removeFromSuperview()
        }else if(touch.view?.tag == 1)
        {
//            cv.removeFromSuperview()
        }
    }

}
