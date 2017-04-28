//
//  AFNetRequestURLTool.swift
//  SinaProject
//
//  Created by FCG on 2017/2/16.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

/// url字符串的枚举
enum URLStringType {
    
    /**  OAuth2的access_token接口  */
    case oauth2_access_token
    /**  根据用户ID获取用户信息  */
    case users_show
    /**  获取当前登录用户及其所关注（授权）用户的最新微博  */
    case statuses_home_timeline
    /**  发布一条新微博  */
    case statuses_update
    /**  发布一条带有图片的新微博  */
    case statuses_upload
    
    case defalut_case   // 默认的是这个
}

class AFNetRequestURLTool: NSObject {
    
    static let shareInstance : AFNetRequestURLTool = AFNetRequestURLTool()
    
    func getUrlString(urlStringType : URLStringType) -> String {
        
        var urlString = ""
        
        
        switch urlStringType {
            
        case .oauth2_access_token:
            urlString = "https://api.weibo.com/oauth2/access_token"
            
        case .users_show:
            urlString = "https://api.weibo.com/2/users/show.json"
            
        case .statuses_home_timeline:
            urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
            
        case .statuses_update:
            urlString = "https://api.weibo.com/2/statuses/update.json"
            
        case .statuses_upload:
            urlString = "https://api.weibo.com/2/statuses/upload.json"
            
            
            
        default:
            urlString = ""
        }
        
        return urlString
    }
}
