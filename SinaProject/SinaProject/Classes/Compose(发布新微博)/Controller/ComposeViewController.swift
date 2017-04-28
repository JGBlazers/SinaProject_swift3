//
//  ComposeViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/3/5.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    
    // MARK: --------   拖线  --------
    // UI相关
    /**  输入框  */
    @IBOutlet weak var textView: ComposeTextView!
    
    /**  相片墙  */
    @IBOutlet weak var picView: ComposePicCollectionView!
    
    // 约束相关
    /**  工具栏的底部约束  */
    @IBOutlet weak var tooBarBottomCons: NSLayoutConstraint!
    
    /**  图片墙的高度  */
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    
    // MARK: --------   懒加载  --------
    /**  导航标题  */
    lazy var titleView : ComposeNavigationTitleView = {
        
        let titleView = ComposeNavigationTitleView()
        titleView.bounds = CGRect(x: 0, y: 0, width: kScreenSize().width - 2 * 60, height: 40)
        return titleView
    }()
    
    /**  表情键盘控制器  */
    lazy var expressionVC : ExpressionViewController = ExpressionViewController { [unowned self] (expresstion) in
        
        self.textView.insertExpresstionToTextView(expressionModel: expresstion)
        self.textViewDidChange(self.textView)
    }
    
    /**  图片数组  */
    lazy var photos : [UIImage] = [UIImage]()
    
    // MARK: --------   系统回调  --------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置导航栏按钮
        setupNavigationBar()
        
        // 添加本类所需通知
        addSelfNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: --------  配置本类UI  --------
extension ComposeViewController {
    
    func setupNavigationBar() {
        
        // 导航栏左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(closeItemClick))
        
        // 导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(composeItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 配置标题
        navigationItem.titleView = titleView
    }
    
}

// MARK: --------   添加本类所需通知  --------
extension ComposeViewController {
    
    func addSelfNotification() {
        
        // 监听键盘的状态
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notif:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 监听添加图片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotos), name: NSNotification.Name(rawValue: "kAddPhotosNotif"), object: nil)
        
        // 监听添加图片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(delPhotos(notif:)), name: NSNotification.Name(rawValue: "kDelPhotosNotif"), object: nil)
        
        
    }
}

// MARK: --------   输入框的代理方法  --------
extension ComposeViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text as NSString
        self.textView.placeHoderLabel.isHidden = !(text.length == 0)
        navigationItem.rightBarButtonItem?.isEnabled = !(text.length == 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        textView.resignFirstResponder()
    }
}

// MARK: --------   本类监听事件  --------
extension ComposeViewController {
    
    // MARK: --------   导航栏左边按钮的点击  --------
    @objc func closeItemClick() {
        
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: --------   导航栏右边边按钮的点击 发布微博  --------
    @objc func composeItemClick() {
        
        textView.resignFirstResponder()
        
        let status = textView.getTextViewText()
        let access_token = AccountInfoModel.shareInstance.infoTool?.access_token
        
        // 参数
        let params : [String : Any] = ["access_token" : access_token ?? "",
                                       "status" : status]
        
        
        // 发布微博回调闭包
        // 1、定义成功的回调闭包
        let finishCallBack = { (_ result : Any?, _ error : Error?) -> () in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("微博发布成功")
            self.dismiss(animated: true, completion: nil)
        };
        
        let image = photos.first
        if image != nil {
            
            AFNRequestTool.shareInstance.upLoadImageRequest(urlStringType: .statuses_upload, parameters: params, images: [image], finished: finishCallBack)
            
        } else {
            
            AFNRequestTool.shareInstance.sendRequest(requestType: .POST, urlStringType: .statuses_update, parameters: params, finished: finishCallBack)
        }
    }
    
    // MARK: --------   点击选择图片  --------
    @IBAction func showPicViewBtnClick() {
        
        textView.resignFirstResponder()
        
        picViewHeightCons.constant = kScreenSize().height * 0.6
        UIView.animate(withDuration: 0.25) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: --------   切换表情键盘  --------
    @IBAction func changeExpressionViewBtnClick() {
        
        // 下落键盘
        textView.resignFirstResponder()
        
        // 切换表情键盘
        textView.inputView = expressionVC.view
        
        // 弹出键盘
        textView.becomeFirstResponder()
    }
    
    // MARK: --------   转成键盘输入  --------
    @IBAction func normalInputBtnClick() {
        
        textView.becomeFirstResponder()
    }
    
    // -------------- 通知监听 --------------
    
    // MARK: --------   监听键盘的弹出和下落  --------
    @objc func keyboardWillChangeFrame(notif : Notification) {
        
        let duration = notif.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        
        let rect = (notif.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        self.tooBarBottomCons.constant = kScreenSize().height - rect.origin.y
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: --------   添加图片  --------
    @objc func addPhotos() {
        
        // 判断是否可以打开相册
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return;
        }
        
        // 初始化图片控制器
        let photoLibraryVC = UIImagePickerController()
        
        // 相片来源
        photoLibraryVC.sourceType = .photoLibrary
        
        // 设置代理
        photoLibraryVC.delegate = self
        
        // 弹出控制器
        present(photoLibraryVC, animated: true, completion: nil)
    }
    
    // MARK: --------   删除图片  --------
    @objc func delPhotos(notif : Notification) {
        
        // 判断需要删除的图片是否存在
        guard let delImage = notif.object as? UIImage else {
            return
        }
        
        // 判断这个图片在图片数组中的索引
        guard let delIndex = photos.index(of: delImage) else {
            return
        }
        
        photos.remove(at: delIndex)
        
        picView.photos = photos
    }
    
}

// MARK: --------   图片库的代理方法  --------
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photos.append(image)
        
        picView.photos = photos
        
        dismiss(animated: true, completion: nil)
    }
    
}
