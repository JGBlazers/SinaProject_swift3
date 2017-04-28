//
//  NSString-String.swift
//  SinaProject
//
//  Created by FCG on 2017/1/17.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

extension String {
    
    func calculateStringSize(text : String?, textMaxSize : CGSize, textFont : UIFont) -> CGSize {
        
        var textSize = CGSize(width: 0, height: 0)
        
        guard let string = text else {
            print("字符串不能为空")
            return textSize
        }
        
        textSize = string.boundingRect(with: CGSize(width: 100, height: 100), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : textFont] , context: nil).size;
        return textSize
    }
    
    
}


