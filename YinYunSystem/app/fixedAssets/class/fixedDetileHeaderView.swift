//
//  fixedDetileHeaderView.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class fixedDetileHeaderView: UIView {

    var label:UILabel = UILabel()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        label.frame = CGRectMake(100,0, 80,80)
        label.backgroundColor = UIColor.redColor()
        
        self.addSubview(label)
    }

    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = 20
    }


}
