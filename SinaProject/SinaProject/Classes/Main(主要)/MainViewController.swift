//
//  MainViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    lazy var addBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 遍历tabbar的所有按钮，并且将加默认的加号按钮设置不能点击
        setTabbarItemsEnable()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加子控制器
        addChildViewController()
        
        // 创建加号按钮
        createAddBtn()
    }
    
        
}

// MARK: --------   创建子控制器  --------
extension MainViewController {
    
    func addChildViewController() {
        // 首页
        self.addChildViewController(childVC: HomeViewController(), imageName: "tabbar_home", title: "首页")
        
        // 消息
        self.addChildViewController(childVC: MessageViewController(), imageName: "tabbar_message_center", title: "消息")
        
        // 加好按钮对应的控制器，添加一个空白的页面给tabbar
        self.addChildViewController(childVC: UIViewController(), imageName: "", title: "")
        
        // 发现
        self.addChildViewController(childVC: DiscoverViewController(), imageName: "tabbar_discover", title: "发现")
        
        // 我
        self.addChildViewController(childVC: ProfileViewController(), imageName: "tabbar_profile", title: "我")
        
    }
    
    /// 添加自控制器
    private func addChildViewController(childVC: UIViewController, imageName : String, title : String) {
        
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        let nav = UINavigationController(rootViewController: childVC)
        
        self.addChildViewController(nav)
    }
}

// MARK: --------   创建和处理UI  --------
extension MainViewController {
    
    // 遍历tabbar的所有按钮，并且将加默认的加号按钮设置不能点击
    func setTabbarItemsEnable() {
        for i in 0 ..< tabBar.items!.count {
            
            let item = tabBar.items![i]
            if i == 2 {
                item.isEnabled = false
                continue
            }
        }
    }
    
    // 创建加号按钮
    func createAddBtn() {
        
        // 在tabbar上添加加号按钮
        tabBar.addSubview(addBtn)
        
        // 设置加号按钮的属性
        addBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height / 2)
        
        // 给加号按钮添加点击事件
        addBtn.addTarget(self, action: #selector(MainViewController.addBtnClick), for: .touchUpInside)
    }
    
}

// MARK: --------   按钮的点击事件  --------
extension MainViewController {
    
    @objc func addBtnClick() {
        
        let composeVC = ComposeViewController()
        
        let nav = UINavigationController(rootViewController: composeVC)
        
        present(nav, animated: true, completion: nil)
    }
}








    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

//class MainViewController: UITabBarController {
//
//    // 这种方式的写法，可以根据json文件，动态生成tabbar的主控制器
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)  else {
//            JGLog("没有找到这个文件")
//            return
//        }
//        
//        
//        
//        // 因为不是plist文件，不能直接的用数组接收，要转成字符串或者是NSData
//        guard let fileData = NSData.init(contentsOfFile: filePath) else {
//            JGLog("这个文件没有数据")
//            return
//        }
//        
//        /** 在调用系统的方法时，在方法后面带有throws的时候，说明，这个方法会抛出异常，如果抛出异常时，需要对异常进行处理
//         *   方式一：直接使用try ，标识，该异常由程序员手动处理，处理如下所示
//             do { // 如果没有异常，就直接输入要用到的变量类型    这种做法，会将接下来所有的代码都写在这个do里面，不常用
//                let jsonContent = try JSONSerialization.jsonObject(with: fileData as Data, options: .allowFragments)
//             } catch {
//                JGLog(error) // 在异常的catch中，系统会提供一个error，在error中，就描述了这个异常
//             }
//         
//         *   方式二：直接使用try! ，表示这个方法不处理异常，非常危险，因为在出现异常的时候，就会直接崩溃， 如下：      最好不要用
//             let jsonContent = try! JSONSerialization.jsonObject(with: fileData as Data, options: .allowFragments)
//         
//         *   方式三：使用try? 的方式，表示该异常由系统进行处理，如果没有异常，就直接输出该类型的可选类型，如果异常就直接输出nil  一般使用这种方式
//             let jsonContent = try? JSONSerialization.jsonObject(with: fileData as Data, options: .allowFragments)
//         */
//        
//        guard let jsonContent = try? JSONSerialization.jsonObject(with: fileData as Data, options: .allowFragments) else {
//            return
//        }
//        
//        // 转成数组
//        guard let jsonArray = jsonContent as? [[String : AnyObject]] else {
//            return
//        }
//        
//        for dict  in jsonArray {
//            guard let vcName = dict["vcName"] as? String else {
//                break;
//            }
//            guard let imageName = dict["imageName"] as? String else {
//                break;
//            }
//            guard let title = dict["title"] as? String else {
//                break;
//            }
//            
//            addChildViewController(childVCName: vcName, imageName: imageName, title: title)
//        }
//        
//    }
//    
//    /// 添加自控制器
//    func addChildViewController(childVCName: String, imageName : String, title : String) {
//        
//        // 拿到命名空间
//        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
//            JGLog("没有找到命名空间")
//            return
//        }
//        
//        // 找到类
//        guard let vcClass = NSClassFromString(nameSpace + "." + childVCName) else {
//            JGLog("没有找到对应的类")
//            return
//        }
//        
//        // 转成控制器类型
//        guard let vcType = vcClass as? UIViewController.Type else {
//            JGLog("没有这个类")
//            return
//        }
//        
//        // 初始化这个类
//        let childVC = vcType.init()
//        
//        childVC.title = title
//        childVC.tabBarItem.image = UIImage(named: imageName)
//        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
//        
//        let nav = UINavigationController(rootViewController: childVC)
//        
//        addChildViewController(nav)
//    }
//    
//}
