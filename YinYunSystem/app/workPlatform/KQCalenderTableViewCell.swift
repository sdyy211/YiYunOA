//
//  KQCalenderTableViewCell.swift
//  YinYunSystem
//  工作日历页面cell
//  Created by 魏辉 on 16/1/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQCalenderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateButton: UIButton!

    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var chooseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
