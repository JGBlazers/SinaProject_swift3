//
//  AccountInfoModel.swift
//  SinaProject
//
//  Created by FCG on 2017/2/23.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class AccountInfoModel {
    
    static let shareInstance : AccountInfoModel = AccountInfoModel()
    
    /**  账号信息工具类  */
    var infoTool : AccountInfoTool?
    
    /**  沙盒路径  */
    var filePath : String {
        
        // 沙盒路径
        var filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        // 根据存账号信息的路径，拼接完整的文件路径
        filePath = filePath + "/account.plist"
        print(filePath)
        return filePath
    }
    
    /**  判断是否登录且存储的账号信息是否在有效的登录时间内  */
    var isLogin : Bool {
        
        // 判断是否有登录过的账号信息
        guard let infoTool = infoTool else {
            return false
        }
        
        // 判断是否存在时间
        guard let expiresDate = infoTool.expiresDate else {
            return false
        }
        
        /** 判断是否过期
         *  OrderedSame            前者和后者相等
         *  OrderedAscending       前者小于后者
         *  OrderedDescending      前者大于后者
         */
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    
    // 读取本地存储的登录账号信息并且解档
    init() {
        
        infoTool = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? AccountInfoTool
    }
    
}
