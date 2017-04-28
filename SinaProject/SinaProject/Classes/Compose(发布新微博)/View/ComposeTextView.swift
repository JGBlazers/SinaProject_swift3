//
//  ComposeTextView.swift
//  SinaProject
//
//  Created by FCG on 2017/3/5.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    // MARK: --------   懒加载  --------
    /**  占位标题  */
    lazy var placeHoderLabel : UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 配置本类UI
        setupUI()
    }
    
}

// MARK: --------   配置本类UI  --------
extension ComposeTextView {
    
    func setupUI() {
    
        // 添加占位标题
        addSubview(placeHoderLabel)
        
        // 设置标题属性
        placeHoderLabel.font = font
        placeHoderLabel.textColor = UIColor.lightGray
        placeHoderLabel.text = "分享新鲜事..."
        
        placeHoderLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left).offset(12)
        }
        
        textContainerInset = UIEdgeInsetsMake(10, 8, 0, 10)
    }
}
