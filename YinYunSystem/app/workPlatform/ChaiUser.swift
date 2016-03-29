//
//  ChaiUser.swift
//  YinYunSystem
//
//  Created by 魏辉 on 16/3/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

struct ChaiUser {
    var id: String
//    var department: String
    var name: String
//    var uname: String
//    var email: String
//    var phone: String
//    var telephone: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}