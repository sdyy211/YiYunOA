//
//  baoXiaoTableViewCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class baoXiaoTableViewCell: UITableViewCell {
    @IBOutlet weak var cusView: UIView!

    @IBOutlet weak var style: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var feiYong: UILabel!
    
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
