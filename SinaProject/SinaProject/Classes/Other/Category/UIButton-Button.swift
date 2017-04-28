//
//  UIButton-Button.swift
//  SinaProject
//
//  Created by FCG on 2017/1/18.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName : String, bgImageName : String) {
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        
        sizeToFit()
    }
    
    convenience init(btnTitle : String, bgColor : UIColor, fontSize : CGFloat) {
        self.init()
        
        setTitle(btnTitle, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        backgroundColor = bgColor
        
    }
}
