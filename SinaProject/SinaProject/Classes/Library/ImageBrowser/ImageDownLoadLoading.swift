//
//  ImageDownLoadLoading.swift
//  SinaProject
//
//  Created by FCG on 2017/3/9.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ImageDownLoadLoading: UIView {
    
    var progress : CGFloat = 0 {
        
        didSet {
            
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let loadingCemter = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        let radius = rect.width * 0.5 - 3
        
        let startAngle = (CGFloat)(-M_PI_2)
        
        let endAngle = (CGFloat)(3 * M_PI_2)
        
        // 创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: loadingCemter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLine(to: loadingCemter)
        path.close()
        
        UIColor.red.setFill()
        
        path.fill()
    }
}
