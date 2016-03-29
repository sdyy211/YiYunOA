//
//  AuditDetileTableViewCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/20.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AuditDetileTableViewCell: UITableViewCell {

    @IBOutlet weak var projectL: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var shiyou: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
