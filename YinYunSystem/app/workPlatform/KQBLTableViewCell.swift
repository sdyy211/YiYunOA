//
//  KQBLTableViewCell.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/16.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQBLTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
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
