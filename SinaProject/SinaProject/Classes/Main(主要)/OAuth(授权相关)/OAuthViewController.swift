//
//  OAuthViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/2/15.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK: --------   控件属性相关  --------
    
    /// webView
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: --------   系统回调相关  --------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSelfUI()
        
        // webView的加载
        loadWebView()
    }
    
}

// MARK: --------   创建本类UI  --------
extension OAuthViewController {
    
    func createSelfUI() {
        
        // 添加导航栏左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftItemClick))
        
        // 添加导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(rightItemClick))
        
        // 添加标题
        title = "登录页面"
    }
    
    func loadWebView() {
        
        // 授权地址
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&redirect_uri=\(redirect_uri)"
        
        // 授权地址的URL  因为URL是可选类型，这里要进行判断URL是否为nil
        guard let url = URL(string: urlString) else {
            return
        }
        
        // URL请求
        let request = URLRequest(url: url)
        
        // webView 开始加载
        webView.loadRequest(request)
    }
}

// MARK: --------   按钮的点击事件  --------
extension OAuthViewController {
    
    // 关闭 按钮的点击
    @objc func leftItemClick() {
        
        dismiss(animated: true, completion: nil)
    }
    
    // 填充 按钮的点击   在点击填充按钮的时候，将设置的账号和密码，通过js和swift交互的方式，填充到登录页面的，对应的输入框中
    @objc func rightItemClick() {
        
        // js代码中，获取账号输入框，并且将账号填充到输入框中
        let jsUserNameCode = "document.getElementById('userId').value='<#你的新浪账号#>';"
        
        // js代码中，获取密码输入框，并且将密码填充到输入框中
        let jsPasswordCode = "document.getElementById('passwd').value='<#你的新浪账号密码#>';"
        
        // 要执行的js代码
        let jsCode = jsUserNameCode + jsPasswordCode
        
        // 执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}


// MARK: --------   UIWebView 的代理方法  --------
extension OAuthViewController : UIWebViewDelegate {
    
    // webView即将加载URL的时候调用
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request.url!.absoluteString)
        
        // 因为此时的url是可选类型，所以要判断url是否为nil
        guard let url = request.url else {
            return true
        }
        
        // 当要执行的url字符串包含了回调地址，就说明已经授权成功了，所以在此处做拦截，并且截取此时url字符串中code=后面的字符串
        let urlString = url.absoluteString
        guard urlString.contains("code=") else {
            return true
        }
        
        print("授权成功了，现在要截取code了 == \(urlString)")
        // 截取code=号后面的字符串   是可选类型，因为在上面已经对url字符串是否包含code=做了判断，所以此处可以强制解包
        let code = urlString.components(separatedBy: "code=").last!
        
        // print("code == \(code)")
        
        sendRequestGetAccessToken(code: code)
        
        return false
    }
    
    // 开始加载
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    // 加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    
    // 加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
}

// MARK: --------   发接口  --------
extension OAuthViewController {
    
    // MARK: --------   获取access_token  --------
    func sendRequestGetAccessToken(code : String) {
        
        let params : [String : Any] = ["code" : code, "client_id" : App_Key, "client_secret" : App_Secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri]
        
        AFNRequestTool.shareInstance.sendRequest(requestType: .POST, urlStringType: .oauth2_access_token, parameters: params) { [unowned self] (result, error) in
            
            if error != nil {
                
                print(error!)
                return
            }
            
            guard let accountDic = result else {
                print("没有获取到授权成功之后的数据")
                return
            }
            let infoTool = AccountInfoTool(accountDic: accountDic as! [String : Any])
            
            // 直接打印infoTool的话，打印的结果是这个类的内存地址相关的信息，不过如果重写infoTool这个类的
//            print(infoTool)
            
            self.sendRequestGetUserInfo(accountInfo: infoTool)
        }
    }
    
    // MARK: --------   根据用户ID获取用户信息  --------
    func sendRequestGetUserInfo(accountInfo : AccountInfoTool) {
        
        // 组装参数
        let params = ["access_token" : accountInfo.access_token, "uid" : accountInfo.uid, "screen_name" : ""]
        
        // 发送请求
        AFNRequestTool.shareInstance.sendRequest(requestType: .GET, urlStringType: .users_show, parameters: params) { (result, error) in
            
            if error != nil {
                
                print(error!)
                return
            }
            
            guard let userDic = result as? [String : Any] else {
                
                print("没有当前用户的数据")
                return
            }
            
            accountInfo.avatar_large = userDic["avatar_large"] as? String
            accountInfo.screen_name = userDic["screen_name"] as? String
            
            // 通过归档(序列化)的方式存储账号相关的信息，方便需要的时候用，比如登录的判断
            // 序列化
            NSKeyedArchiver.archiveRootObject(accountInfo, toFile: AccountInfoModel.shareInstance.filePath)
            
            // 4.因为账号单例类，第一时间就已经初始化过了，然后进行到授权成功之后，要对单例类中的账号等相关进行赋值，不然单例类中的账号信息模型就保留着授权前面的值，也就是空值了
            AccountInfoModel.shareInstance.infoTool = accountInfo
            
            // 去欢迎界面
            let welcomeVC = WelcomeViewController()
            UIApplication.shared.keyWindow?.rootViewController = welcomeVC
        }
    }
}




