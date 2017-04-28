//
//  PopoverAnimator.swift
//  SinaProject
//
//  Created by FCG on 2017/2/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    
    // 通过这个属性来判断是否是弹出动画还是动画消失，也就是上模态还是下模态，默认是上模态
    var isPresentAnimation = true
    
    // MARK: --------   弹出的View的frame，开启这个属性，然后这个frame由外面传过来进行赋值，不在本类写死  --------
    var presentedViewRect: CGRect = CGRect.zero
    
    // MARK: --------   添加闭包，将弹出、消失的状态返回去，方便做导航标题按钮的图标的变化  --------
    var callBack: ((_ isPresent : Bool) -> ())?
    
    /*
    override init() {
        
    }
    */
    /** 注意
     *  1：如果自定义了一个构造函数，但是没有对系统默认的构造函数进行重写的话，那么自定义构造行数会覆盖掉系统的构造函数，所以需要打开上面就可以调用系统的构造函数了
     *  2：当前类的方法中，一般是可以直接调用该类的方法或者是属性的，但是有两种情况是必须要用到使用self调用方法和属性，1、属性名重复的时候；2、在闭包中
     */
    
    //
    init(callBack: @escaping ((_ isPresent : Bool) -> ())) {
        
        self.callBack = callBack
    }
    
}

// MARK: --------   自定义转场的代理方法  --------
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    
    /// 改变弹出的View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // 要动态设置弹出的VC的视图大小，需要自定义UIPresentationController，然后在自定义的UIPresentationController中进行设置
        
        let popoverPresentedVC = HomePopoverPresentedVC(presentedViewController: presented, presenting: presenting);
        
        popoverPresentedVC.presentedViewRect = presentedViewRect
        
        return popoverPresentedVC
    }
    
    /// 目的是为了改变弹出动画(需要自定义转场动画)
    /* UIViewControllerAnimatedTransitioning 在这个方法中，需要返回这个协议，意思也就是说，需要在当前类中遵守这个协议
     
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // 设置动画控制属性为上模态
        isPresentAnimation = true
        
        // 将弹出的状态动过闭包传递会首页
        callBack!(isPresentAnimation)
        
        // 当前页如果遵守了UIViewControllerAnimatedTransitioning这个协议，就必须要实现这个协议中必须要实现的方法，在这个类的拓展中，实现这个协议的必须实现的方法
        return self
    }
    
    // 目的是为了改变下模态动画(自定义动画)
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 设置动画控制属性为上模态
        isPresentAnimation = false
        
        // 将弹出的状态动过闭包传递会首页
        callBack!(isPresentAnimation)
        
        return self
    }
    
    /*  模态时的动画代理方法有下面几种，可自定了解
     - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
     
     - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
     
     - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;
     
     - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;
     
     - (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);
     */
    
}

// MARK: --------   实现UIViewControllerAnimatedTransitioning中的必须要实现的方法和自定义转场动画  --------
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    /// 执行动画的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    /// 在这个方法中，实现动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresentAnimation == true {
            
            presentedAnimation(using: transitionContext)
        } else {
            
            dismissedAnimation(using: transitionContext)
        }
    }
    
    /// 上模态
    func presentedAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取弹出的View
        /*  forKey 对于下面这个key需要传的值有下面两种(只有这两种)，也就是UITransitionContextViewKey这个枚举有下面两种值
         *  from, 获取消失的View
         *  to    获取弹出的View
         */
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // 2、将弹出的View添加到containerView
        transitionContext.containerView.addSubview(presentedView)
        
        // 3、给presentedView添加和执行动画  动画原理：设置要弹出的View的宽度不变，高度是由0到设定的高度，正常弹出默认值是(1.0，1.0)，所以此处设置成(1.0, 0)
        // 3.1 设置动画
        presentedView.transform = CGAffineTransform(scaleX: 1, y: 0)
        
        // 3.2 给动画加上锚点，不然会默认从中间向上下两边做动画，锚点默认的是执行动画的View的(0.5, 0.5)的位置，此处需要设置成(0.5, 0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        // 3.3 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            // 3.4 还原原有presentedView的大小
            presentedView.transform = CGAffineTransform.identity
            
        }) { (_) in // (<#Bool#>)  如果需要这个返回来的值，就直接给返回来的值设置变量名(isFinish)就好，如果不需要就直接(_)
            
            // 3.5 动画执行完成之后，告诉动画上下文
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissedAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 1、获取消失的View
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        // 2、执行动画 动画原理：在原有的大小的基础上，高度设置从下往上缩小到0的过程
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            // 3、添加动画类型  此处不能直接设置成0.0，因为iOS中，对于处理临界值非常不理想，所以要设置成0.000001，小点的值
            dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
            
        }) { (_) in
            
            // 4、移除消失的View
            dismissedView.removeFromSuperview()
            // 5、动画执行完成之后，告诉动画上下文
            transitionContext.completeTransition(true)
        }
    }
}
