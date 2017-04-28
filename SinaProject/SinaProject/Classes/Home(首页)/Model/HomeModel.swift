//
//  HomeModel.swift
//  SinaProject
//
//  Created by FCG on 2017/2/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class HomeModel : NSObject {
    
    // MARK: --------   接口返回的数据字段  --------
    /**  微博创建的时间  */
    var created_at : String? 
    
    /**  来源  */
    var source : String? 
    
    /**  正文  */
    var text : String?
    
    /**  微博的ID  */
    var mid : Int = 0
    
    /**  微博配图数组  */
    var pic_urls : [[String : Any]]?
    
    /**  用户模型  */
    var user : User?
    
    /**  转发的微博模型  */
    var retweeted_status : HomeModel?
    
    
    // MARK: --------   将获取的当前微博条数传过来  --------
    init(dataDic : [String : Any]) {
        super.init()
        
        setValuesForKeys(dataDic)
        
        // 因为在微博字典用的user这个对象，不会直接通过kvc的映射方式，直接转换，所以这里需要对user这个对象进行字典转模型
        if let userDic = dataDic["user"] as? [String : Any] {
            
            user = User(userDic: userDic)
        }
        
        // 微博数据中，取出所转发的微博数据，进行转模型
        if let retweetedStatus = dataDic["retweeted_status"] as? [String : Any] {
            
            retweeted_status = HomeModel(dataDic: retweetedStatus)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    
}
