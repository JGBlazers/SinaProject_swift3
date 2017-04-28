//
//  UIBarbuttonItem-Extension.swift
//  SinaProject
//
//  Created by FCG on 2017/2/13.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 普通情况下所需item
    convenience init(imageName : String) {
        self.init()
        
        let item = UIButton(type: .custom)
        item.setImage(UIImage(named: imageName), for: .normal);
        item.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted);
        item.sizeToFit()
        
        self.customView = item
    }
    
    // 导航栏的返回按钮
    
    
}
