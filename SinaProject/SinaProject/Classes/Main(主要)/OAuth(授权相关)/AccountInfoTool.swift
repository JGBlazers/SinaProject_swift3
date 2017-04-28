//
//  AccountInfoTool.swift
//  SinaProject
//
//  Created by FCG on 2017/2/17.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class AccountInfoTool: NSObject, NSCoding {
    
    // MARK: --------   属性  --------
    
    // 授权成功后返回的access token
    var access_token : String?
    
    // 因为expires_in是多少秒后的数字，所以要在对expires_in赋值的时候，将expires_in转成过期的时间
    var expiresDate : NSDate?
    
    // 授权的有效时间，也就是从授权成功后，多长时间失效 --> 秒
    var expires_in : TimeInterval = 0 {
        
        didSet { // 拦截set方法，在这个方法中，将expires_in转成过期时间expiresDate
            
            // timeIntervalSinceNow表示从现在开始，多少秒后的时间
            expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 当前登录的用户ID
    var uid : String?
    
    
    // 用户昵称
    var screen_name : String?
    
    // 用户头像
    var avatar_large : String?
    
    
    init(accountDic : [String : Any]) {
        super.init()
        
        setValuesForKeys(accountDic)
        if let token = access_token {
            print(token)
        }
    }
    
    // 保证在键值对映射的过程中，json字典中有的字段，因为在本类没有声明，导致程序闪退
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // 重写这个description属性，就可以在直接输出本类对象的时候，将描述方法中的设定内容传回去打印
    // 比如说，我在其他类中，初始化本类的对象为infoTool，然后print(infoTool)的时候，打印的就是这里面return的内容了
    override var description: String {
        
        // 在这个方法中，把本类的传过来的字典，打印出去，而实现这个效果就需要用来模型转字典的方法了，如下所示
        // 注意，在自动字典转模型，模型转字典的过程中，要保证属性和json字典的键是一样的，且模型转字典的时候，要注意将需要描述的属性的属性名一模一样的写出来
        return dictionaryWithValues(forKeys: ["access_token", "expiresDate", "uid", "screen_name", "avatar_large"]).description
    }
    
    
    // MARK: --------   归档和解档  归档和解档必须要写在class这边，不能写在extension里面  --------
    
    // 解档
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expiresDate = aDecoder.decodeObject(forKey: "expiresDate") as? NSDate
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    // 归档
    func encode(with coder: NSCoder) {
        
        coder.encode(access_token, forKey: "access_token")
        coder.encode(expiresDate, forKey: "expiresDate")
        coder.encode(uid, forKey: "uid")
        coder.encode(screen_name, forKey: "screen_name")
        coder.encode(avatar_large, forKey: "avatar_large")
    }
}

// MARK: --------   错误的写法  --------
//extension AccountInfoTool: NSCoding {
//    
//    required init?(coder aDecoder: NSCoder) {
//        
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        
//    }
//}
