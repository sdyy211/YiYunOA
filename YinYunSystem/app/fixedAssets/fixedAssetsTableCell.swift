//
//  fixedAssetsTableCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class fixedAssetsTableCell: UITableViewCell {

    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var phone: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
