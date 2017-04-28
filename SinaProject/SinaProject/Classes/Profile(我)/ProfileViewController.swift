//
//  ProfileViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    lazy var bgImgView : UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        bgAlertView.setBgAlertViewInfo(imageName: "visitordiscover_image_profile", alertTitle: "登录后，您的微博、相册、个人资料会显示在这里，展示给别人")
        
        bgImgView.image = UIImage(named: "popover_background")
        view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            
            make.width.equalTo(200)
            make.height.equalTo(300)
            make.center.equalTo(self.view)
        }
        
    }

}
