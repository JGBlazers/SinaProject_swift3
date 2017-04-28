//
//  Definition.swift
//  SinaProject
//
//  Created by FCG on 2017/1/17.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

let kSreenSize = UIScreen.main.bounds.size

// MARK: --------   新浪微博相关的Key  --------
let App_Key = "<#enter your App_Key#>"
let App_Secret = "<#enter your App_Secret#>"
let redirect_uri = "<#enter your redirect_uri#>"


func RGBA( R : CGFloat, G : CGFloat, B : CGFloat, A : CGFloat) -> UIColor {
    
    return UIColor(red: (R / 256), green: (G / 256), blue: (B / 256), alpha: A)
}

// MARK: --------   随机色  --------
func arcColor() -> UIColor {
//    256 as! UInt
    
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    return UIColor.init(red:red, green:green, blue:blue , alpha: 1)
}

func kScreenSize() -> CGSize {
    
    return UIScreen.main.bounds.size
}

///// 自定义Log
//func JGLog<T>(_ messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
//    
//    #if DEBUG
//        
//        let fileName = (file as NSString).lastPathComponent
//        
//        JGLog("\(fileName):(\(lineNum))-\(messsage)")
//        
//    #endif
//}
