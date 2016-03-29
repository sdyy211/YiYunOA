//
//  addressMethod.swift
//  YinYunSystem
//
//  Created by Mac on 16/1/13.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class addressMethod: NSObject {

    class var sharedInstance : addressMethod {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : addressMethod? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = addressMethod()
        }
        return Static.instance!
    }

    //将数据解析成中文拼音的方法
    func dealAddressData(array:NSMutableArray,str:String)->NSDictionary
    {
        let arrayA:NSMutableArray = NSMutableArray() ;
        let arrayB:NSMutableArray = NSMutableArray() ;
        let arrayC:NSMutableArray = NSMutableArray() ;
        let arrayD:NSMutableArray = NSMutableArray() ;
        let arrayE:NSMutableArray = NSMutableArray() ;
        let arrayF:NSMutableArray = NSMutableArray() ;
        let arrayG:NSMutableArray = NSMutableArray() ;
        let arrayH:NSMutableArray = NSMutableArray() ;
        let arrayI:NSMutableArray = NSMutableArray() ;
        let arrayJ:NSMutableArray = NSMutableArray() ;
        let arrayK:NSMutableArray = NSMutableArray() ;
        let arrayL:NSMutableArray = NSMutableArray() ;
        let arrayM:NSMutableArray = NSMutableArray() ;
        let arrayN:NSMutableArray = NSMutableArray() ;
        let arrayO:NSMutableArray = NSMutableArray() ;
        let arrayP:NSMutableArray = NSMutableArray() ;
        let arrayQ:NSMutableArray = NSMutableArray() ;
        let arrayR:NSMutableArray = NSMutableArray() ;
        let arrayS:NSMutableArray = NSMutableArray() ;
        let arrayT:NSMutableArray = NSMutableArray() ;
        let arrayU:NSMutableArray = NSMutableArray() ;
        let arrayV:NSMutableArray = NSMutableArray() ;
        let arrayW:NSMutableArray = NSMutableArray() ;
        let arrayX:NSMutableArray = NSMutableArray() ;
        let arrayY:NSMutableArray = NSMutableArray() ;
        let arrayZ:NSMutableArray = NSMutableArray() ;
        let arrayOther:NSMutableArray = NSMutableArray() ;
        let arrayData:NSMutableArray = NSMutableArray() ;
        let sectionTitle:NSMutableArray = NSMutableArray() ;
        
        
        for(var i = 0; i < array.count ; ++i)
        {
            let dic = array.objectAtIndex(i) as! NSDictionary
            let name = dic.objectForKey("U_Name") as! String
            let pinyin:String = self.tochinesePinYin(name)
            if(pinyin == "A")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayA.addObject(string)
            }else  if(pinyin == "B")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayB.addObject(string)
            }else  if(pinyin == "C")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayC.addObject(string)
            }else  if(pinyin == "D")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayD.addObject(string)
            }else  if(pinyin == "E")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayE.addObject(string)
            }else  if(pinyin == "F")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayF.addObject(string)
            }else  if(pinyin == "G")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayG.addObject(string)
            }else  if(pinyin == "H")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayH.addObject(string)
            }else  if(pinyin == "I")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayI.addObject(string)
            }else  if(pinyin == "J")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayJ.addObject(string)
            }else  if(pinyin == "K")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayK.addObject(string)
            }else  if(pinyin == "L")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayL.addObject(string)
            }else  if(pinyin == "M")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayM.addObject(string)
            }else  if(pinyin == "N")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayN.addObject(string)
            }else  if(pinyin == "O")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayO.addObject(string)
            }else  if(pinyin == "P")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayP.addObject(string)
            }else  if(pinyin == "Q")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayQ.addObject(string)
            }else  if(pinyin == "R")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayR.addObject(string)
            }else  if(pinyin == "S")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayS.addObject(string)
            }else  if(pinyin == "T")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayT.addObject(string)
            }else  if(pinyin == "U")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayU.addObject(string)
            }else  if(pinyin == "V")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayV.addObject(string)
            }else  if(pinyin == "W")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayW.addObject(string)
            }else  if(pinyin == "X")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayX.addObject(string)
            }else  if(pinyin == "Y")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayY.addObject(string)
            }else  if(pinyin == "Z")
            {
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayZ.addObject(string)
            }else{
                let string =  array.objectAtIndex(i) as! NSDictionary
                arrayOther.addObject(string)
            }
            
        }
        if(arrayA.count>0)
        {
            arrayData.addObject(arrayA)
            sectionTitle.addObject("A")
        }
        if(arrayB.count > 0)
        {
            arrayData.addObject(arrayB)
            sectionTitle.addObject("B")
        }
        if(arrayC.count > 0)
        {
            arrayData.addObject(arrayC)
            sectionTitle.addObject("C")
        }
        if(arrayD.count > 0)
        {
            arrayData.addObject(arrayD)
            sectionTitle.addObject("D")
        }
        if(arrayE.count > 0)
        {
            arrayData.addObject(arrayE)
            sectionTitle.addObject("E")
        }
        if(arrayF.count > 0)
        {
            arrayData.addObject(arrayF)
            sectionTitle.addObject("F")
        }
        if(arrayG.count > 0)
        {
            arrayData.addObject(arrayG)
            sectionTitle.addObject("G")
        }
        if(arrayH.count > 0)
        {
            arrayData.addObject(arrayH)
            sectionTitle.addObject("H")
        }
        if(arrayI.count > 0)
        {
            arrayData.addObject(arrayI)
            sectionTitle.addObject("I")
        }
        if(arrayJ.count > 0)
        {
            arrayData.addObject(arrayJ)
            sectionTitle.addObject("J")
        }
        if(arrayK.count > 0)
        {
            arrayData.addObject(arrayK)
            sectionTitle.addObject("K")
        }
        if(arrayL.count > 0)
        {
            arrayData.addObject(arrayL)
            sectionTitle.addObject("L")
        }
        if(arrayM.count > 0)
        {
            arrayData.addObject(arrayM)
            sectionTitle.addObject("M")
        }
        if(arrayN.count > 0)
        {
            arrayData.addObject(arrayN)
            sectionTitle.addObject("N")
        }
        if(arrayO.count > 0)
        {
            arrayData.addObject(arrayO)
            sectionTitle.addObject("O")
        }
        if(arrayP.count > 0)
        {
            arrayData.addObject(arrayP)
            sectionTitle.addObject("P")
        }
        if(arrayQ.count > 0)
        {
            arrayData.addObject(arrayQ)
            sectionTitle.addObject("Q")
        }
        if(arrayR.count > 0)
        {
            arrayData.addObject(arrayR)
            sectionTitle.addObject("R")
        }
        if(arrayS.count > 0)
        {
            arrayData.addObject(arrayS)
            sectionTitle.addObject("S")
        }
        if(arrayT.count > 0)
        {
            arrayData.addObject(arrayT)
            sectionTitle.addObject("T")
        }
        if(arrayU.count > 0)
        {
            arrayData.addObject(arrayU)
            sectionTitle.addObject("U")
        }
        if(arrayV.count > 0)
        {
            arrayData.addObject(arrayV)
            sectionTitle.addObject("V")
        }
        if(arrayW.count > 0)
        {
            arrayData.addObject(arrayW)
            sectionTitle.addObject("W")
        }
        if(arrayX.count > 0)
        {
            arrayData.addObject(arrayX)
            sectionTitle.addObject("X")
        }
        if(arrayY.count > 0)
        {
            arrayData.addObject(arrayY)
            sectionTitle.addObject("Y")
        }
        if(arrayZ.count > 0)
        {
            arrayData.addObject(arrayZ)
            sectionTitle.addObject("Z")
        }
        if(arrayOther.count > 0)
        {
            arrayData.addObject(arrayOther)
            sectionTitle.addObject("#")
        }
       
        let titleArry:NSArray = NSArray(array: sectionTitle)
        let dicA:NSDictionary = NSDictionary(objects:arrayData as [AnyObject],forKeys:titleArry as! [NSCopying])
        return dicA;
    }
    func tochinesePinYin(name:String) -> String
    {
        //转成了可变字符串
        let  str:NSMutableString  = NSMutableString(string:name)
        //先转换为带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformMandarinLatin,false)
        //再转换为不带声调的拼音
        CFStringTransform(str, nil, kCFStringTransformStripDiacritics,false)
       
        //转化为大写拼音
        let  pinYin:NSString = str.capitalizedString;
        //获取并返回首字母s
        return pinYin.substringToIndex(1)
    }
}
