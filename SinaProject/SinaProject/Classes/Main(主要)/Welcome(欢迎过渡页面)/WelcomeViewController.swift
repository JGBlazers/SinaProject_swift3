//
//  WelcomeViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/2/27.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    // MARK: --------   xib拉线  --------
    @IBOutlet weak var headImgViewBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var headImgView: UIImageView!
    // MARK: --------   系统回调  --------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 头像url字符串
        let urlString = AccountInfoModel.shareInstance.infoTool?.avatar_large
        
        // 头像url   可选类型后面跟着??和一个对应这个可选类型的值的时候，标识，可选类型有值就取，没值为nil的时候取后面的值
        let url = URL(string: urlString ?? "")
        
        // 给头像赋值
        headImgView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 3.0, delay: 0.01, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: [], animations: {
            
            self.headImgViewBottomCons.constant = kScreenSize().height - 200;
            self.view.layoutIfNeeded()
        }) { (_) in
            
            // 回tabbar
            UIApplication.shared.keyWindow?.rootViewController = MainViewController()
        }
    }

}
