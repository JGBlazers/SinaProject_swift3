//
//  CustomNavBarTitleViewBtn.swift
//  SinaProject
//
//  Created by FCG on 2017/2/13.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

// 自定义导航栏的标题View

class CustomNavBarTitleViewBtn: UIButton {
    
    var imageW : CGFloat = 13.0
    var imageH : CGFloat = 7.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
        
    }
    
    
    // 修改按钮中的label和imageView的frame的方式常规有一下两种
    
    /*
    // 方式一：重写imageRect(forContentRect contentRect: CGRect) -> CGRect 和 titleRect(forContentRect contentRect: CGRect) -> CGRect  这两个方法，重新排列位置
    // MARK: --------   重写系统图标排列的方法  --------
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: contentRect.size.width - imageW, y: contentRect.size.height / 2 - imageH / 2, width: imageW, height: imageH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: contentRect.size.height / 2 - 10, width: contentRect.size.width - imageW, height: 20)
    }
     */
    
    // 方式二：直接在layoutSubviews这个方法中排列
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 按钮的标题标签位置为0
        titleLabel!.frame.origin.x = 0
        
        // 图片在标题后面
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
