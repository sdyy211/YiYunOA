//
//  myselfMeetRoomDetileCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/2/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class myselfMeetRoomDetileCell: UITableViewCell {

    @IBOutlet weak var meetRoom: UILabel!
    @IBOutlet weak var meetName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var meetphone: UILabel!
    @IBOutlet weak var mayFeiPeiBtn: UIButton!
    @IBOutlet weak var meetType: UILabel!
    
    @IBOutlet weak var meetRemebers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
