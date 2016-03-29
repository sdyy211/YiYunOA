//
//  segmentView.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
@objc protocol segmentProtocol{
    func getSegmentDidchange(index:String)
}

class segmentView: UIView,UIScrollViewDelegate{

    var myscrollView : UIScrollView?
    var segmentArray = NSArray()
    var segmented = UISegmentedControl()
    var itemsWith = 80
    var delegate:segmentProtocol?
     override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func drawRect(rect: CGRect) {
       
        segmented = UISegmentedControl(items: segmentArray as [AnyObject])
        let with = itemsWith*segmentArray.count
        
        segmented.frame = CGRectMake(0,0,CGFloat(with), CGRectGetHeight(self.frame))
        segmented.selectedSegmentIndex=0
        segmented.setBackgroundImage(UIImage(named:"inchoose"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        segmented.addTarget(self, action:"segmentDidchange:",forControlEvents: UIControlEvents.ValueChanged)
        
        myscrollView = UIScrollView()
        myscrollView!.frame = CGRectMake(0,0,CGRectGetWidth(self.frame),40)
        myscrollView!.contentSize = CGSize(width: CGFloat(with),height:0)
        
        myscrollView!.delegate = self
        myscrollView?.delegate = self;
        myscrollView?.directionalLockEnabled = true
        myscrollView!.alwaysBounceVertical = false
        myscrollView?.showsHorizontalScrollIndicator = false
        myscrollView!.backgroundColor = UIColor.whiteColor()
        myscrollView?.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        myscrollView!.addSubview(segmented)
        self.addSubview(myscrollView!)
    }
    func segmentDidchange(segmented:UISegmentedControl)
    {
        var str = ""
        str = segmentArray.objectAtIndex(segmented.selectedSegmentIndex) as! String
        delegate?.getSegmentDidchange(str)
    }



}
