//
//  PhotoBrowserAnimator.swift
//  SinaProject
//
//  Created by FCG on 2017/3/9.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    /**  是否是上模态  */
    fileprivate var isPressented : Bool = true
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPressented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPressented = false
        return self
    }
}

extension PhotoBrowserAnimator : UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPressented == true {
            presentedAnimation(using: transitionContext)
        } else {
            dismissedAnimation(using: transitionContext)
        }
    }
    
    /// 上模态
    func presentedAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2、将弹出的View添加到containerView
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.3 执行动画
        presentedView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView.alpha = 1.0
        }) { (_) in
            // 3.5 动画执行完成之后，告诉动画上下文
            transitionContext.completeTransition(true)
        }
    }
    
    /// 下模态
    func dismissedAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取弹出的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        // 2、将弹出的View添加到containerView
        transitionContext.containerView.addSubview(dismissedView)
        
        // 3.3 执行动画
        dismissedView.alpha = 1.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissedView.alpha = 0.0
        }) { (_) in
            dismissedView.removeFromSuperview()
            // 3.5 动画执行完成之后，告诉动画上下文
            transitionContext.completeTransition(true)
        }
    }
}
