//
//  User.swift
//  SinaProject
//
//  Created by FCG on 2017/2/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // MARK: --------   在微博信息里面，有个发表微博的用户的信息，在本类进行解析  --------
    
    /**  头像  */
    var profile_image_url : String?
    
    /**  昵称  */
    var screen_name : String?
    
    /**  用户认证类型  -1没有认证， 0个人认证， 235企业认证， 220达人认证  */
    var verified_type : Int = -1
    
    /**  用户会员等级 0表示没有会员，1.2.3...表示会员等级  */
    var mbrank : Int = 0
    
    init(userDic : [String : Any]) {
        super.init()
        setValuesForKeys(userDic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
