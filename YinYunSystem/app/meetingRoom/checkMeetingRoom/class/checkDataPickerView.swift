//
//  checkDataPickerView.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol dataProtocol{
    func getData(data:String)
}
class checkDataPickerView: UIView {

    var delegate:dataProtocol?
    var checkDataPicker = UIDatePicker()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    func initView()
    {
        let toolView = UIView()
        toolView.frame = CGRectMake(0, 0,CGRectGetWidth(UIScreen.mainScreen().bounds),35)
        toolView.backgroundColor = UIColor.blackColor()
        self.addSubview(toolView)
        
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRectMake(0, 0,50,CGRectGetHeight(toolView.frame))
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: Selector("cancelBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)

        let tureBtn =  UIButton()
        tureBtn.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen().bounds)-50,0,50,CGRectGetHeight(toolView.frame))
        tureBtn.setTitle("确定", forState: UIControlState.Normal)
        tureBtn.addTarget(self, action: Selector("tureBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        toolView.addSubview(cancelBtn)
        toolView.addSubview(tureBtn)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        checkDataPicker = UIDatePicker(frame: CGRectMake(0,CGRectGetMaxY(toolView.frame),CGRectGetWidth(toolView.frame),220-CGRectGetHeight(toolView.frame)))
        checkDataPicker.backgroundColor = UIColor.groupTableViewBackgroundColor()
        checkDataPicker.datePickerMode = UIDatePickerMode.Date
        
        
//        let maxDate = dateFormatter.dateFromString("1900-01-01")
//        let minDate = dateFormatter.dateFromString("2099-01-01")

//        let maxDate = dateFormatter.dateFromString("1900-01-01")
//        dataPicker.maximumDate = maxDate
//        dataPicker.maximumDate = minDate
        checkDataPicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(checkDataPicker)
        
    }
    func cancelBtnAction(button:UIButton)
    {
        self.removeFromSuperview()
    }
    func tureBtnAction(button:UIButton)
    {
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.stringFromDate(checkDataPicker.date)
        delegate?.getData(dateString)
        self.removeFromSuperview()
    }
    func datePickerValueChange(sender: UIDatePicker)
    {

    }
    override func drawRect(rect: CGRect) {
        // Drawing code
    }


}
