//
//  yongZhangDetileView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc  protocol yongZhangProtocol{
//    func setLoadData()
    func trueBtnAct(button:UIButton,id:String)
    func exitBtnAct(button:UIButton,id:String)
}
class yongZhangDetileView: UIView,UITableViewDelegate,UITableViewDataSource{

    var tv = UITableView()
    var url = ""
    var viewController = UIViewController()
    var dataDic = NSDictionary()
    var titleArry = NSArray()
    var keyArry = NSArray()
    var delegate:yongZhangProtocol?
    var backView = UIView()
    var headerView = UIView()
    var footerView = UIView()
    var nameKey = ""
    var departmentKey = ""
    var state = "0"
    override init(frame: CGRect) {
        super.init(frame: frame)
        tv.delegate = self
        tv.dataSource = self
        tv.frame = CGRectMake(0, 0, 320,200)
//        self.tv.estimatedRowHeight = 52
        self.tv.rowHeight = UITableViewAutomaticDimension
        
        self.addSubview(tv)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    //MARK:tableviewdDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArry.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        tableView.registerNib(UINib(nibName: "yongZhangDetileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        var cell:yongZhangDetileTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! yongZhangDetileTableViewCell
	
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let label = UILabel()
        label.frame = CGRectMake(0,5,100,20)
        label.text = titleArry.objectAtIndex(indexPath.row) as? String
        cell.contentView.addSubview(label)
        
        let label2 = UILabel()
        label2.frame = CGRectMake(CGRectGetMaxX(label.frame),5,CGRectGetWidth(tv.frame)-CGRectGetMaxX(label.frame),20)
        label2.numberOfLines = 0
        label2.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let contentStr =  dataDic.objectForKey((keyArry.objectAtIndex(indexPath.row) as? String)!) as? String
        label2.text = contentStr
        cell.contentView.addSubview(label2)
        

        
        
        
        
//        let  str = label2.text
//        let statusLabelSize = str!.sizeWithAttributes([NSFontAttributeName :12.0])
//        print("\(statusLabelSize)")
//        cell.titleL.text = titleArry.objectAtIndex(indexPath.row) as? String
//        cell.contentL.text = dataDic.objectForKey((keyArry.objectAtIndex(indexPath.row) as? String)!) as? String
//        cell.contentL.numberOfLines = 0
        return cell
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        let leftWith:CGFloat = 15
        let with = (CGRectGetWidth(self.frame) - leftWith*2)
        let h = 6*50+100
        let xh = CGRectGetHeight(self.frame)
        let heightY = (xh - CGFloat(h+80))/2
        
        headerView = UIView()
        headerView.layer.cornerRadius = 6
        headerView.frame = CGRectMake(leftWith, heightY, with, 50)
        headerView.backgroundColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 204.0/255.0, alpha: 1)
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0,CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame))
        label.textAlignment = NSTextAlignment.Center
        label.text = "\( dataDic.objectForKey(nameKey) as! String)(\(dataDic.objectForKey(departmentKey) as! String))"
        label.textColor = UIColor.whiteColor()
        headerView.addSubview(label)
        self.addSubview(headerView)
        
        tv.frame = CGRectMake(leftWith, CGRectGetMaxY(headerView.frame), with,CGFloat(h)-20)
//        tv.estimatedRowHeight = 52
//        tv.rowHeight = UITableViewAutomaticDimension
        tv.reloadData()
        
        footerView = UIView()
        footerView.frame = CGRectMake(CGRectGetMinX(tv.frame),CGRectGetMaxY(tv.frame),CGRectGetWidth(tv.frame),60)
        footerView.backgroundColor = UIColor.whiteColor()
        
        let leftW:CGFloat = 20
        let btnWith = (CGRectGetWidth(tv.frame)-leftW*2)/2-20
        
        
        let btn = UIButton()
        btn.frame = CGRectMake(leftW, 15,btnWith,CGRectGetHeight(footerView.frame)-30)
        btn.setTitle("退回", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "exitBtn"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector("exitBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnCenter = CGRectGetWidth(tv.frame)-CGRectGetMaxX(btn.frame)-20-btnWith
        let btn2 = UIButton()
        btn2.frame = CGRectMake(CGRectGetMaxX(btn.frame)+btnCenter, 15,btnWith,CGRectGetHeight(btn.frame))
        btn2.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        btn2.setTitle("通过", forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn2.addTarget(self, action: Selector("trueBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnWith2 = CGRectGetWidth(tv.frame)-40
        let btn3 = UIButton()
        btn3.frame = CGRectMake(20, 15,btnWith2,CGRectGetHeight(btn.frame))
        btn3.setBackgroundImage(UIImage(named: "trueBtn"), forState: UIControlState.Normal)
        btn3.setTitle("返回", forState: UIControlState.Normal)
        btn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn3.addTarget(self, action: Selector("backAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let lineL = UILabel()
        lineL.frame = CGRectMake(0, 0,CGRectGetWidth(tv.frame), 1)
        lineL.backgroundColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1)
        
        
        footerView.addSubview(lineL)
        if(state == "0")
        {
            footerView.addSubview(btn)
            footerView.addSubview(btn2)
        }else{
            footerView.addSubview(btn3)
        }
        self.addSubview(footerView)
    }
    func exitBtnAction(button:UIButton)
    {
        let id = dataDic.objectForKey("BD_ID") as! String
        delegate?.exitBtnAct(button,id: id)
    }
    func trueBtnAction(button:UIButton)
    {
        let id = dataDic.objectForKey("BD_ID") as! String
        delegate?.trueBtnAct(button,id: id)
    }
    func backAction(button:UIButton)
    {
        self.removeFromSuperview()
    }

}
extension NSString {
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            textSize = self.sizeWithAttributes(attributes as? [String : AnyObject])
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as? [String : AnyObject], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}