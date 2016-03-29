//
//  personalTableViewCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class personalTableViewCell: UITableViewCell {
    @IBOutlet weak var titleName: UILabel!

    @IBOutlet weak var contentL: UILabel!
    
    @IBOutlet weak var contentText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
