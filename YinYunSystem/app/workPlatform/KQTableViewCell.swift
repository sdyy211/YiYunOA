//
//  TableViewCell.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/2/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class KQTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
