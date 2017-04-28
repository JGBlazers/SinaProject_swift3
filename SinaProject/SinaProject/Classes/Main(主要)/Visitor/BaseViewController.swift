//
//  BaseViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/18.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    // MARK: --------   懒加载背景提示图  --------
    lazy var bgAlertView : ProjectBgAlertView = ProjectBgAlertView()
    
    lazy var isLogin : Bool = {
        
        // MARK: --------   账号相关的信息已经提到账号模型单例类中了，具体操作可查看单例类  --------
        
        let isLogin = AccountInfoModel.shareInstance.isLogin
        
        return isLogin
    }()
    
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNaviBarLeftAndRightItem()
    }

}

// MARK: --------   创建子类共有UI  --------
extension BaseViewController {
    
    func setupVisitorView() {
        
        view = bgAlertView
        bgAlertView.registerBtn.addTarget(self, action: #selector(leftItemClick), for: .touchUpInside)
        bgAlertView.loginBtn.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
    }
    
    func setupNaviBarLeftAndRightItem() {
        
        // 导航栏左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(leftItemClick))
        
        // 导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(rightItemClick))
    }
}

// MARK: --------   按钮的点击事件  --------
extension BaseViewController {
    
    // 导航栏左边按钮的点击事件
    @objc func leftItemClick() {
        
        print("注册按钮")
        
    }
    
    // 导航栏右边按钮的点击事件
    @objc func rightItemClick() {
        
        // 点击登陆的按钮的时候，弹出登录页面
        let oauthVC = OAuthViewController()
        
        // 给登录界面添加到导航控制器中
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        
        // 模态弹出授权登录页面
        present(oauthNav, animated: true, completion: nil)
    }
}
