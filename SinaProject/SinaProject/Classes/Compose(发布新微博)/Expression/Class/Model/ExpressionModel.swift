//
//  ExpressionModel.swift
//  表情键盘
//
//  Created by FCG on 2017/3/7.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ExpressionModel: NSObject {
    
    // MARK: --------   数据源的所需字段  --------
    /**  这个是emoji表情的对应的十六进制编码  */
    var code : String? {
        
        didSet {
            
            guard let code = code else {
                return
            }
            
            // 创建扫描器
            let scanner = Scanner(string: code)
            
            // 创建一个承接扫描后的值的变量
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            // 将扫描后的值，转成字符
            let char = Character(UnicodeScalar(value)!)
            
            codeString = String(char)
        }
    }
    
    /**  浪小花和默认的图片名  */
    var png : String? {
        
        didSet {
            
            guard let png = png else {
                return
            }
            
            pngPathString = Bundle.main.bundlePath + "/" + "Emoticons.bundle" + png
        }
    }
    
    /**  浪小花和默认的图片表示的文字  */
    var chs : String?
    
    
    // MARK: --------   处理过来的字段  --------
    /**  转换后的表情字符串  */
    var codeString : String?
    /**  完整的表情图片路径  */
    var pngPathString : String?
    /**  是否是删除按钮  */
    var isRemove : Bool = false
    /**  是否是删除按钮  */
    var isEmpty : Bool = false
    
    
    
    // MARK: --------   数据中的表情的数据转模型调用的方法  --------
    init(expressionDic : [String : String]) {
        super.init()
        
        setValuesForKeys(expressionDic)
    }
    
    // MARK: --------   是否是删除按钮的构造方法  --------
    init(isRemove : Bool) {
        super.init()
        self.isRemove = isRemove
    }
    
    // MARK: --------   是否是空数组的构造方法  --------
    init(isEmpty : Bool) {
        super.init()
        self.isEmpty = isEmpty
    }
    
    
    // 打印本类
    override var description: String {
        return dictionaryWithValues(forKeys: ["codeString", "pngPathString", "chs"]).description
    }
    
    
    // 使用KVC映射来取值的时候，防止没有对应值的键
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
