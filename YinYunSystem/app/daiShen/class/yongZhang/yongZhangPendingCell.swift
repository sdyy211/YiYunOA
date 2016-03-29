//
//  yongZhangPendingCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/9.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class yongZhangPendingCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var yongzhangImage: UIImageView!
    @IBOutlet weak var department: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var state: UILabel!
    
    @IBOutlet weak var cellbackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
