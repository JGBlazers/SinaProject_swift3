//
//  HomeViewModel.swift
//  SinaProject
//
//  Created by FCG on 2017/3/1.
//  Copyright © 2017年 FCG. All rights reserved.
//

/**
 *  此类专门对首页微博数据，进行处理
 */

import UIKit

class HomeViewModel: NSObject {
    
    /**  首页数据模型  */
    var homeModel : HomeModel?
    
    
    // MARK: --------   根据接口数据，按照自己需要，将数据进行处理  --------
    
    /**  认证类型，因为对应的认证类型，有对应的类型图片，所以此处按照类型的不同，匹配成对应的图片，到时候，直接用  */
    var verifiedImg : UIImage?
    
    /**  是否是会员或者是会员时的会员等级等级，因为对应的会员等级，有对应的类型图片，所以此处匹配成对应的图片，到时候，直接用  */
    var vipImg : UIImage?
    
    /**  来源 -- 处理  */
    var sourceText : String?
    
    /**  时间 -- 处理  */
    var created_at_Text : String?
    
    /**  头像的URL -- 处理  */
    var headImgUrl : URL?
    
    /**  自定义配图的URL -- 处理  */
    var pic_urls_custom : [URL] = [URL]()
    
    /**  该条微博的单元格的高度，放在模型中，是为了能直接的去取出cell的高度  */
    var rowHeight : CGFloat = 0
    
    
    init(homeModel : HomeModel) {
        
        self.homeModel = homeModel
        
        // <a href=\"http://app.weibo.com/t/feed/6e3owN\" rel=\"nofollow\">iPhone 7 Plus</a>
        // 找到需要的iPhone 7 Plus  的起始位置和最终位置，算出lenge
        if let source = homeModel.source, source != "" {
            
            // 起始位置  下面的方法，能在遍历这个字符串的过程中，只要找到字符串中的第一个‘>’为开始位置，因为索取的值在它的右边第一位，所以这里要加1
            let startIndex = (source as NSString).range(of: ">").location + 1
            
            // 最终位置
            let endIndex = (source as NSString).range(of: "</").location
            
            // 在起点和终点之间的宽度
            let lenge = endIndex - startIndex
            
            // 从source中，截取自己想要的字符串
            sourceText = (source as NSString).substring(with: NSMakeRange(startIndex, lenge))
        }
        
        // 处理时间
        if let created_at = homeModel.created_at {
            created_at_Text = NSDate.changeDate(currentDateString: created_at)
        }
        
        
        /**  用户认证类型  -1没有认证， 0个人认证， 235企业认证， 220达人认证  */
        switch homeModel.user?.verified_type ?? 0 {
        case 0:
            verifiedImg = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImg = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImg = UIImage(named: "avatar_grassroot")
        default:
            verifiedImg = nil
        }
        
        /**  时间 -- 处理  */
        let mbrank = homeModel.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImg = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        /**  头像的URL -- 处理  */
        let urlString = homeModel.user?.profile_image_url ?? ""
        headImgUrl = URL(string: urlString)
        
        /**  自定义配图的URL -- 处理  */
        /** 原创微博和转发微博的配图逻辑
         *  没有转发微博时，配图为原创微博的个数
         *  有转发微博时，那么转发的这个人，不管有没有添加图片进行转发，它的配图肯定为0，所以判断发表的微博的配图只要不等于0，那么该条微博就肯定是原创微博
         *  有转发微博时，要展示的是转发的这条微博的个数
         */
        
        // 因为配图接收的数组声明成[[String : Any]]，所以就算是没有配图的情况下，返回的也肯定是[]，而不是nil，所以这里就可以直接解包
        let picUrls = homeModel.pic_urls!.count != 0 ? homeModel.pic_urls : homeModel.retweeted_status?.pic_urls
        
        if let picUrls = picUrls {
            
            for picUrlDic : [String : Any] in picUrls {
                
                guard let picUrlString = picUrlDic["thumbnail_pic"] else {
                    
                    // 如果没有配图的url字符串的时候，直接continue，不要用return或者是break
                    continue
                }
                
                // 配图转成url
                guard let url = URL(string: picUrlString as! String) else {
                    // url不存在
                    continue
                }
                
                pic_urls_custom.append(url);
            }
        }
        
//        print(pic_urls_custom)
    }
}
