//
//  ExpressionPackageTool.swift
//  表情键盘
//
//  Created by FCG on 2017/3/7.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ExpressionPackageTool: NSObject {
    
    /**  表情模型包  */
    var expressionModels : [ExpressionModel] = [ExpressionModel]()
    
    // MARK: --------   转模型的构造方法  --------
    init(folderName : String) {
        super.init()
        
        if folderName == "" {
            // 如果是最近的表情的话，给最近表情数组，添加20个空模型和1个删除按钮
            addEmptyModel(recentlyUser: true)
            return
        }
        
        let filePath = Bundle.main.path(forResource: "\(folderName)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        
        let expressionArray = NSArray(contentsOfFile: filePath)! as! [[String : String]]
        
        // 遍历数组
        
        for var i in 0 ..< expressionArray.count {
            
            var expressionDic = expressionArray[i]
            
            // 处理数据中的png，因为数据中的png只是显示文件名，这里把图片的文件夹也拼接上
            let expression_png = expressionDic["png"]
            if var expression_png = expression_png {
                expression_png = "/\(folderName)/\(expression_png)"
                expressionDic["png"] = expression_png
            }
            
            expressionModels.append(ExpressionModel(expressionDic: expressionDic))
            
            // 因为每一页都有20个表情，所以要在每页的第21的位置上插入删除按钮
            if (i + 1) % 20 == 0 {
                i -= 1
                expressionModels.append(ExpressionModel(isRemove: true))
            }
        }
        
        addEmptyModel(recentlyUser: false)
    }
    
    // MARK: --------   添加空数组和删除按钮  --------
    // recentlyUser是否是最近使用的数组
    fileprivate func addEmptyModel(recentlyUser : Bool) {
        
        // 判断还需要添加多少个模型  因为第21个是删除按钮
        let count = expressionModels.count % 21
        
        // 当count == 0 并且 不是最近使用的表情的数组的时候，就直接返回
        if count == 0 && !recentlyUser {
            return
        }
        
        for _ in count ..< 20 {
            // 添加空白表情
            expressionModels.append(ExpressionModel(isEmpty: true))
        }
        
        // 添加删除按钮
        expressionModels.append(ExpressionModel(isRemove: true))
    }
}
