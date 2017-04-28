//
//  NSDate-date.swift
//  新浪微博时间处理
//
//  Created by FCG on 2017/2/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

extension NSDate {
    
    // 根据传过来的时间字符串，按照设定的时间字符串格式，返回对应的时间字符串
    class func changeDate(currentDateString : String) -> String {
        
        /*
         1分钟内:刚刚
         1小时内:15分钟前
         1天内:3小时前
         昨天: 昨天 03:24
         一年内: 02-23 03:24
         一年后: 2015-2-23 03:23
         */
        
        // 1、定义时间字符串 此时间字符串的格式：星期 月份 日 时:分:秒 区 年
        // let created_at = "Mon Apr 26 13:40:02 +0800 2014"
        
        // 2、时间字符串 -> 时间对象
        // 2.1、时间转换器
        let dateFormatter = DateFormatter()
        
        // 2.2、根据时间字符串，定义转换格式
        dateFormatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        // 2.3、配置本地化对象
        dateFormatter.locale = Locale(identifier: "en")
        
        // 转换时间对象，因为返回的时间对象是可选类型，所以要判断时间对象是否为nil
        guard let created_date = dateFormatter.date(from: currentDateString) else {
            
            print("时间转换失败")
            return ""
        }
        
        // 3、获取当前时间
        let currentDate = Date()
        
        // 4、判断两个时间的大概时间差   date.timeIntervalSince(date) : 标识某个时间到某个时间的时间差，如果前面打，就正数，反之为负数
        let inteval = currentDate.timeIntervalSince(created_date)
        
        // 5、时间段的判断
        // 5.1 一分钟内
        if inteval < 60 { // 一分钟内
            return "刚刚"
        }
        // 5.2 1个小时内
        if inteval < 60 * 60 { // 1个小时内
            return "\((Int)(inteval / 60))分钟前"
        }
        // 5.3 1天内
        if inteval < 60 * 60 * 24 { // 1天内
            return "\((Int)(inteval / (60 * 60)))小时前"
        }
        
        // 5.4、判断是否是昨天
        // 5.4.1、要判断是否是昨天，需要将用到日历对象
        let calendar = NSCalendar.current
        
        // 5.4.2 是否是昨天
        let isYesterday = calendar.isDateInYesterday(created_date)
        
        // 5.4.3 判断是否是昨天
        if isYesterday == true {
            
            // 1、将时间转换成时间字符串
            dateFormatter.dateFormat = "昨天 HH:mm"
            return dateFormatter.string(from: created_date)
        }
        
        // 5.5 判断是否是1年内还是超过1年
        // 5.5.1、判断是否是1年内还是超过1年，需要借用到时间组件这个对象
        let dateComponents = calendar.dateComponents([.year], from: created_date, to: currentDate)
        
        // 判断是否是1年内
        //        一年内: 02-23 03:24
        //        一年后: 2015-2-23 03:23
        
        guard let yearIndex = dateComponents.year else {
            print("没有转出年")
            return ""
        }
        
        if yearIndex < 1 {
            dateFormatter.dateFormat = "MM-dd HH:mm"
            let timeString = dateFormatter.string(from: created_date)
            return timeString
        }
        
        // 超过一年的时候
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let timeString = dateFormatter.string(from: created_date)
        return timeString
    }
}
