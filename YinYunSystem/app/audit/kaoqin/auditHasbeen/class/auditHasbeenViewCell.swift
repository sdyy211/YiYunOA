//
//  auditHasbeenViewCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class auditHasbeenViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var auditName: UILabel!
    @IBOutlet weak var state: UILabel!
    
    @IBOutlet weak var cellBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
