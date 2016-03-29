//
//  NSDataOfCell.swift
//  YinYunSystem
//
//  Created by Mac on 16/3/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
class NSDataOfCell{
    
    //第一层cell
    var name = ""
    var selectFlag = ""     //这是在批复状态下选中的标示
    var style = ""          //报销的类型
    var styleIdBX = ""      //报销类型的id
    var time = ""           //一级cell的时间
    var level = ""          //几级cell的标示
    var zongFeiYong = ""
    var selectState = ""    //这是在没有点击批复的时候状态
    var BXID = ""
    var BSAId = ""
    //第二层cell
    //通讯费
    var BXSID = ""
    var zhangDanMonthTX = ""  //账单月份
    var jinETX = ""             //金额
    var shiBaoJinETX = ""       //实报金额
    var faPiaoBianHaoTX = ""    //发票编号
    var beiZhuTX = ""           //备注
    var baoXiaoBiLiTX = ""      //报销比例
    var baoXiaoXianETX = ""     //报销限额
    var dianZiBanTX = ""        //电子版
    
    //差旅费
    var projectCL = ""          //项目名称
    var chuFaTimeCL = ""        //出发时间
    var chuFaLocationCL = ""    //出发地点
    var suiXingRenCL = ""       //随性人数
    var daoDaTimeCL = ""        //到达时间
    var daoDaLocationCl = ""      //到达地点
    var feiYongCl = ""          //费用
    var jiaoTongGongJuCL = ""   //交通工具
    var qiTaFeiYongCL = ""      //其他费用
    var piaoJuZhangShuCl = ""   //票数张数
    var zhuSuFeiCl = ""         //住宿费
    var shiNeiJiaoTongFeiCl = ""//市内交通费
    var jiHeTiaoZhengCL = ""    //稽核调整
    var chuChaiTianShuCl = ""   //出差天数
    var buZhuFeiCl = ""         //补助费
    var baoXiaoJinECL = ""        //报销金额
    
    
    //市内交通费
    var chuFaTimeJT = ""          //出发时间
    var chuFaLocationJT = ""          //出发地点
    var daoDaTimeJT = ""              //到达时间
    var daoDaLocationJT  = ""         // 到达地点
    var feiYongJT = ""              //费用
    var projectNameJT = ""          //项目名称
    var submitTimeJT = ""             //提交时间
    var beiZhuJT = ""                  //备注
    
    //通用
    var suoShuXiangMuTY = ""            //所属项目
    var wuPinNameTY = ""                //物品名称
    var wuPinStyleTY = ""                 //物品类别
    var xingHaoTY = ""                  //型号
    var jiaGeTY = ""                      //价格
    var numberTY = ""                   //数量
    var gouMaiDateTY = ""                 //购买日期
    var piaoJuNumberTY = ""                  //票据张数
    var baoXiaoJinETY = ""                   //报销金额
    var beiZhuTY = ""                       //备注
    
    //培训费，会议费
    var suoShuXiangMuPX = ""            //所属项目
    var baoXiaoJinEPX = ""              //报销金额
    var baoXiaoShiYouPX = ""            //报销事由
    var submitTimePX = ""               //提交时间
    var fuJianPX = ""                   //上传附件
}