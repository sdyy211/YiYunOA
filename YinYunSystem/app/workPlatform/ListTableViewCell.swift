//
//  ListTableViewCell.swift
//  YinYunSystem
//  会议室选择框cell
//  Created by 魏辉 on 16/1/13.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
//会议室选择框cell
class ListTableViewCell: UITableViewCell {
    //时间
    @IBOutlet weak var dateLabel: UILabel!
    //可选择按钮，选定会议室使用时间
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var bt2: UIButton!
    @IBOutlet weak var bt3: UIButton!
    @IBOutlet weak var bt4: UIButton!
    
    //获取会议室时间选择按钮位置
    @IBAction func button(sender: UIButton) {
   
        switch sender.tag {
        case 0 :
            if bt1.backgroundColor == UIColor.yellowColor() {
                bt1.backgroundColor = UIColor.greenColor()
            } else {
                bt1.backgroundColor = UIColor.yellowColor()
            }
        case 1:
            if bt2.backgroundColor == UIColor.yellowColor() {
                bt2.backgroundColor = UIColor.greenColor()
            } else {
                bt2.backgroundColor = UIColor.yellowColor()
            }
        case 2:
            if bt3.backgroundColor == UIColor.yellowColor() {
                bt3.backgroundColor = UIColor.greenColor()
            } else {
                bt3.backgroundColor = UIColor.yellowColor()
            }
        case 3:
            if bt4.backgroundColor == UIColor.yellowColor() {
                bt4.backgroundColor = UIColor.greenColor()
            } else {
                bt4.backgroundColor = UIColor.yellowColor()
            }
        default:
            return
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
