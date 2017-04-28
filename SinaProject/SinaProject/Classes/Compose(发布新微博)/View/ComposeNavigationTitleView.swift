//
//  ComposeNavigationTitleView.swift
//  SinaProject
//
//  Created by FCG on 2017/3/5.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ComposeNavigationTitleView: UIView {

    // MARK: --------   系统回调  --------
    /**  导航标题  */
    let titleLabel : UILabel = UILabel()

    /**  导航栏上的当前登录账号的名字  */
    let nameLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 创建本类UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: --------   创建本类UI  --------
extension ComposeNavigationTitleView {
    
    func setupUI() {
    
        addSubview(titleLabel)
        addSubview(nameLabel)
        
        // 标题的配置
        titleLabel.text = "发微博"
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        
        titleLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        // 名字
        nameLabel.text = AccountInfoModel.shareInstance.infoTool?.screen_name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 13.0)
        nameLabel.textColor = UIColor.lightGray
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
}
