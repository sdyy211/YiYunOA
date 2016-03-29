//
//  KQApplyTableViewCell.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQApplyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    @IBOutlet weak var chooseImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
