//
//  ExpressionManager.swift
//  表情键盘
//
//  Created by FCG on 2017/3/7.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ExpressionManager {
    
    /**  表情模型数组  */
    var expressionList : [ExpressionPackageTool] = [ExpressionPackageTool]()
    
    init() {
        
        // 最近使用的表情
        expressionList.append(ExpressionPackageTool(folderName: ""))
        
        // 默认表情
        expressionList.append(ExpressionPackageTool(folderName: "com.sina.default"))
        
        // 墨迹表情  emoji
        expressionList.append(ExpressionPackageTool(folderName: "com.apple.emoji"))
            
        // 浪小花
        expressionList.append(ExpressionPackageTool(folderName: "com.sina.lxh"))
    }
}
