//
//  ProjectBgAlertView.swift
//  SinaProject
//
//  Created by FCG on 2017/1/17.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ProjectBgAlertView: UIView {
    
    // 大转盘
    lazy var rotationView : UIImageView = {
        
        // 默认图片
        let rotationView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        rotationView.sizeToFit()
        return rotationView
    }()
    
    // 遮挡大转盘下方的背景view
    lazy var masksView : UIImageView = {
        
        let maskView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        maskView.sizeToFit()
        return maskView
    }()
    
    // 转盘里面的图标
    lazy var iconView : UIImageView = {
        
        let iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        iconView.sizeToFit()
        iconView.contentMode = .center;
        return iconView
    }()
    
    // 提示标签
    lazy var alertLabel : UILabel = {
        
        let alertLabel = UILabel()
        alertLabel.text = "关注一些人，回这里看看有什么惊喜"
        alertLabel.textAlignment = .center
        alertLabel.textColor = UIColor.lightGray
        alertLabel.font = UIFont.systemFont(ofSize: 16.0)
        alertLabel.numberOfLines = 0
        return alertLabel
    }()
    
    // 注册按钮
    lazy var registerBtn : UIButton = {
        
        let registerBtn = UIButton()
        registerBtn.setBackgroundImage(resizableImage(imageName: "common_button_white_disable", top: 5, left: 5, bottom: 5, right: 5), for: .normal)
        registerBtn.setTitle("注 册", for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        registerBtn.setTitleColor(UIColor.orange, for: .normal)
        
        return registerBtn
    }()
    
    // 登录按钮
    lazy var loginBtn : UIButton = {
        
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(resizableImage(imageName: "common_button_white_disable", top: 5, left: 5, bottom: 5, right: 5), for: .normal)
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        loginBtn.setTitleColor(UIColor.gray, for: .normal)
        
        return loginBtn
    }()
    
    // MARK: --------   在构造方法中，创建UI  --------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 大转盘
        self.addSubview(rotationView)
        
        // 遮挡大转盘下方的背景view
        self.addSubview(masksView)
        
        // 转盘里面的图标
        self.addSubview(iconView)
        
        // 出错提示
        self.addSubview(alertLabel)
        
        // 注册按钮
        self.addSubview(registerBtn)
        
        // 登录按钮
        self.addSubview(loginBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: --------   排列UI  --------
extension ProjectBgAlertView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = RGBA(R: 238, G: 238, B: 238, A: 1)
        
        // 背景图标
        rotationView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 3);
        
        // 遮罩图标
        masksView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 3 + 20)
        
        // 最中心的标志性图标(背景图中的小房子)
        iconView.center = rotationView.center
        
        // 出错提示
        let labelX = 30.0 as CGFloat
        let labelY = rotationView.frame.maxY + 10
        let labelW = kSreenSize.width - 2 * labelX
        // 标签的字符串大小
        let alertLabelS = String().calculateStringSize(text: alertLabel.text, textMaxSize: CGSize(width: labelW, height: CGFloat(MAXFLOAT)) , textFont: alertLabel.font)
        
        let labelH = max(alertLabelS.height, 20)
        
        alertLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        
        // 注册和登录按钮
        let btnW = 80.0 as CGFloat
        let intevalX = (frame.width - btnW * 2) / 3
        let btnY = alertLabel.frame.maxY + 20
        let btnH = 35 as CGFloat
        
        registerBtn.frame = CGRect(x: intevalX, y: btnY, width: btnW, height: btnH)
        
        loginBtn.frame = CGRect(x: intevalX * 2 + btnW, y: btnY, width: btnW, height: btnH)
    }
}

// MARK: --------   添加动画  --------
extension ProjectBgAlertView {
    
    // MARK: --------   给转盘添加转动动画  --------transform.rotation.z
    func AddRotationViewAnim() {
        
        // 初始化动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 开始值
        rotationAnim.fromValue = 0
        
        // 结束值
        rotationAnim.toValue = M_PI * 2
        
        // 执行动画的次数
        rotationAnim.repeatCount = MAXFLOAT
        
        // 设置一个周期动画的时间
        rotationAnim.duration = 5
        
        // 进入后台或者是切换到其他视图控制器的时候，是否关闭动画
        rotationAnim.isRemovedOnCompletion = false
        
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
}

// MARK: --------   设置背景图片和标题  --------
extension ProjectBgAlertView {
    
    func setBgAlertViewInfo(imageName : String, alertTitle : String) {
        
        if (imageName as NSString).length > 0 {
            iconView.image = UIImage.init(named: imageName)
        }
        
        alertLabel.text = alertTitle
        
        /// 隐藏灰色遮罩
        masksView.isHidden = true
        
        /// 隐藏转盘
        rotationView.isHidden = true
        
    }
}
