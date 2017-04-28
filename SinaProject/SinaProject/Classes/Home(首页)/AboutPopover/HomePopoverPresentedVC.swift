//
//  HomePopoverPresentedVC.swift
//  SinaProject
//
//  Created by FCG on 2017/2/13.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class HomePopoverPresentedVC: UIPresentationController {
    
    // MARK: --------   弹出的View的frame，开启这个属性，然后这个frame由外面传过来进行赋值，不在本类写死  --------
    var presentedViewRect: CGRect = CGRect.zero
    
    
    // MARK: --------   懒加载  --------
    lazy var coverView : UIView = UIView()
    
    
    // 要动态设置弹出的视图打下，需要拦截系统的containerViewDidLayoutSubviews或者containerViewWillLayoutSubviews方法
    // 注意，因为在containerViewDidLayoutSubviews这个方法中，视图已经排列完成了，在这个方法中设置，容易存在隐患，所以要是将要排列的时候就要设置containerViewWillLayoutSubviews
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView!.frame = presentedViewRect
        
        // 添加遮罩，让在点击遮罩的时候下模态
        addCoverView()
    }
    
}

// 创建本类UI
extension HomePopoverPresentedVC {
    
    // 添加遮罩
    func addCoverView() {
        
        // 1、添加遮罩
        containerView?.insertSubview(coverView, at: 0)
        
        // 2、设置遮罩的背景
        coverView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        
        // 3、这只遮罩的frame
        coverView.frame = containerView!.bounds
        
        // 给遮罩添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        coverView.addGestureRecognizer(tap)
    }
}

// MARK: --------   监听点击事件  --------
extension HomePopoverPresentedVC {
    
    func tapClick(tap : UITapGestureRecognizer) {
        
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
