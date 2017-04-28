//
//  FindExpression.swift
//  正则表达式的简单使用
//
//  Created by FCG on 2017/3/8.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

// MARK: --------   本类的作用是将微博的正文传过来，然后直接转换成对应表情chs的带有图片的属性字符串  --------
class FindExpression: NSObject {
    
    // MARK: --------   本类单例化  --------
    static let shareInstace : FindExpression = FindExpression()
    
    // MARK: --------   表情的处理的类  --------
    fileprivate let expManager : ExpressionManager = ExpressionManager()
    
    // 根据传过来的表情标记chs的字符串，转换成带有表情图片的属性字符串
    func changeExpressionAttributedString(oldString : String?, titleFont : UIFont) -> NSMutableAttributedString? {
        
        /********************  匹配新浪微博的数据  ********************/
        
        guard let oldString = oldString else {
            return nil
        }
        
        // 需要匹配的字符串
        
        let mutableAttri = NSMutableAttributedString(string: oldString)
        
        // 制定正则表达式的规则  @.*?:  表示：从'@'开始':'号结束，中间的任意符号用'.'表示，如果在'.'号后面不追加'?'号的话，会从第一个'@'开始，到最后一个':'号结束，这样子不对，所以需要加个'?'号，匹配一次，截出来一次再接着匹配
        let pattern = "@.*?:|【.*?】|#.*?#|\\[.*?\\]|http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
        
        /** 创建正则表达式
         *  因为正则表达式的创建构造函数中，有一个throws的标记，表示这个方法有可能会存在异常，需要对这个异常做处理
         *  返回的对象是一个可选类型，需要对这个正则表达式的对象做校验
         */
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        /** 开始匹配
         *  调用下面的匹配字符串的方法，返回的是一个[NSTextCheckingResult]，表示返回来的是NSTextCheckingResult类型的数组
         *  range表示匹配的字符串从哪里开始扫描到哪里结束，通常是匹配整一个字符串
         */
        let results = regex.matches(in: oldString, options: [], range: NSMakeRange(0, oldString.characters.count))
        
        /** 遍历返回来的[NSTextCheckingResult]数组 */
        for i in (0 ..< results.count).reversed() {
            // 根据规则匹配出来的字符串
            let subString = (oldString as NSString).substring(with: results[i].range)
            
            // 将表情对应的图片组装成属性字符串赋值给label
            if subString.contains("["), subString.contains("]") {
                
                guard let newString = expressionChsChangeToImagePath(subString: subString) else {
                    return nil
                }
                
                let attrachemt = NSTextAttachment()
                attrachemt.image = UIImage(contentsOfFile: newString)
                attrachemt.bounds = CGRect(x: 0, y: -4, width: titleFont.lineHeight, height: titleFont.lineHeight)
                
                let attri = NSAttributedString(attachment: attrachemt)
                
                mutableAttri.replaceCharacters(in: results[i].range, with: attri)
            }
        }
        return mutableAttri
    }
    
    fileprivate func expressionChsChangeToImagePath(subString : String) -> String? {
        
        for expPackage in expManager.expressionList {
            
            for expressionModel in expPackage.expressionModels {
                
                if expressionModel.chs == subString {
                    
                    return expressionModel.pngPathString
                }
            }
        }
        return nil
    }
    
}
