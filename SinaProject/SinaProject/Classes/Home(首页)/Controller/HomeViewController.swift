//
//  HomeViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/1/14.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    // MARK: --------   懒加载属性  --------
    lazy var titleBtnView : CustomNavBarTitleViewBtn = CustomNavBarTitleViewBtn()
    
    // MARK: --------   用来实现动画效果、承接和遵守协议的自定义的动画类的对象  --------
    // weak var weakSelf = self/[weak self]/[unowned self]  都可以防止闭包的循环引用，1要在方法中，2是self必须不为空，3比较常用，self可以为空
    lazy var popoverAnim : PopoverAnimator = PopoverAnimator { [unowned self] (isPresent) in
        
        self.titleBtnView.isSelected = isPresent
    }
    
    /// 针对控制器中的View的需要，处理出来的一个HomeViewModel，这个模型中，既包括了微博模型，也包括了处理后的数据
    lazy var viewModelList : [HomeViewModel] = [HomeViewModel]()
    
    /// 创建导航栏底部弹出来的数据更新提示label
    lazy var alertLabel : UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor.orange
        label.frame = CGRect(x: 0, y: 10, width: kScreenSize().width, height: 34)
        label.text = "暂无数据更新"
        label.isHidden = true
        return label
    }()
    
    lazy var animatorTool : PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK: --------   系统回调方法  --------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1、判断是否登录，如果不登录，显示背景提示图相关
        if !isLogin {
            bgAlertView.AddRotationViewAnim()
            return;
        }
        
        // 2、配置导航栏
        setupNavigationBar()
        
        // 3、配置tableView
        setTableViewProperty()
        
        // 创建导航栏底部弹出来的数据更新提示label
        createAlertLabel()
        
        // 4、开启通知监听图片item的点击
        NotificationCenter.default.addObserver(self, selector: #selector(clickImageItem(notif:)), name: NSNotification.Name(rawValue: "kClickImageItem"), object: nil)
    }
    
}

// MARK: --------   配置导航栏  --------
extension HomeViewController {
    
    // MARK: --------   配置导航栏  --------
    func setupNavigationBar() {
        
        // 1、设置导航栏左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention");
        
        // 2、设置导航栏右边按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop");
        
        // 3、设置导航标题View   按钮带参数的点击方法 #selector(titleBtnViewClick(titleBtnView:)) 或者 #selector(titleBtnViewClick)都可以，不带参数的直接 #selector(titleBtnViewClick)
        titleBtnView.setTitle("coder", for: .normal)
        titleBtnView.addTarget(self, action: #selector(titleBtnViewClick(titleBtnView:)), for: .touchUpInside)
        navigationItem.titleView = titleBtnView
    }
    
    // MARK: --------   创建导航栏底部弹出来的数据更新提示label  --------
    func createAlertLabel() {
        navigationController?.navigationBar.insertSubview(alertLabel, at: 0)
    }
    
    // MARK: --------   弹出提示框  --------
    func showAlertView(dataCount : Int) {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.alertLabel.text = dataCount == 0 ? "暂无最新数据" : "\(dataCount)条新微博"
            self.alertLabel.isHidden = false
            self.alertLabel.frame.origin.y = 44
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.alertLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.alertLabel.isHidden = true
            })
        }
        
    }
    
    // 配置tableView
    func setTableViewProperty() {
        
        tableView.backgroundColor = RGBA(R: 242, G: 242, B: 242, A: 1)
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "HomeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HOMECELL")
        
        // 集成刷新库
        
        // 初始化下拉刷新控件
        allocHeaderRefresh()
        
        // 初始化上拉加载更多控件
        allocFooterRefresh()
    }
    
    // MARK: --------   初始化下拉刷新控件  --------
    func allocHeaderRefresh() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        // 设置下拉控件的相关提示标题
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("松开自动刷新", for: .pulling)
        header?.setTitle("正在努力的加载中...", for: .refreshing)
        // 将下拉对象添加到表头中
        tableView.mj_header = header
        // 一进来就刷新
        tableView.mj_header.beginRefreshing()
    }
    
    // MARK: --------   初始化上拉加载更多控件  --------
    func allocFooterRefresh() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
    }
}

// MARK: --------   UITableView DataSource/Delegate  --------
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "HOMECELL"
        let cell : HomeCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! HomeCell
        
        cell.viewModel = viewModelList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = viewModelList[indexPath.row]
        
        return viewModel.rowHeight
    }
}

// MARK: --------   请求本类数据  --------
extension HomeViewController {
    
    // MARK: --------   下拉刷新  --------
    @objc func loadNewData() {
        
        sendRequstGetHomeData(isLoadNewData: true)
    }
    
    // MARK: --------   上拉加载更多  --------
    @objc func loadMoreData() {
        sendRequstGetHomeData(isLoadNewData: false)
    }
    
    // MARK: --------   发送请求  --------
    func sendRequstGetHomeData(isLoadNewData : Bool) {
        
        /** 微博的上下拉加载数据时，应该追加的参数区分
         *  since_id 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
         *  max_id 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
         */
        
        var since_id : Int = 0
        var max_id : Int = 0
        
        // 判断是否是下拉刷新
        if isLoadNewData {
            // 下拉参数配置
            since_id = viewModelList.first?.homeModel?.mid ?? 0
        } else {
            // 上拉参数配置
            max_id = viewModelList.last?.homeModel?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        // 请求参数
        let params = [
            "since_id" : "\(since_id)",
            "max_id" : "\(max_id)",
            "access_token" : AccountInfoModel.shareInstance.infoTool?.access_token ?? ""
        ]
        
        // 发送请求
        AFNRequestTool.shareInstance.sendRequest(requestType: .GET, urlStringType: .statuses_home_timeline, parameters: params) { (result, error) in
            
            if error != nil {
                print("请求出错")
                return
            }
            
            // 判断result是否为空
            guard let dataDic = result as? [String : Any] else {
                
                print("没有返回数据")
                return
            }
            
            // 判断从数据字典中，取出微博数组是否为空
            guard let statuses = dataDic["statuses"] as? [[String : Any]] else {
                
                print("取不出对应的微博数组")
                return
            }
            
            // 字典数组转模型数组
            var tempViewModels = [HomeViewModel]()
            for weiboDic in statuses {
                
                let homeModel = HomeModel.init(dataDic: weiboDic)
                tempViewModels.append(HomeViewModel(homeModel: homeModel))
            }
            
            if isLoadNewData {  // 如果是下拉刷新，就把数据加载到原有微博模型的前面
                self.viewModelList = tempViewModels + self.viewModelList
            } else {    // 如果是上拉加载更多，把数据加载在原有数据的后面
                self.viewModelList += tempViewModels
            }
            
            // 刷新表
            //self.tableView.reloadData()
            
            // 为了能在单元格的配图展示的时候，在1张图片时，显示图片的实际大小，所以这里需要提前将图片缓存起来
            self.cacheImage(viewModels: tempViewModels)
        }
        
    }
    
    func cacheImage(viewModels : [HomeViewModel]) {
        
        // 因为SDWebImage下载图片时异步下载的，要想把图片都缓存成功之后，再执行刷新表格的操作，需要用到多线程，这里以GCD为例，需要用到队列组，然后再将刷新表格的操作放在所有子线程图片下载完成之后
        let group = DispatchGroup()
        
        for viewModel in viewModelList {
            
            if viewModel.pic_urls_custom.count == 1 {
                
                for picUrl in viewModel.pic_urls_custom {
                    
                    // 将当前的下载操作添加到组中
                    group.enter()
                    SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                        // 下载成功后离开当前组
                        group.leave()
                    })
                }
            }
        }
        
        // 全部加载完后通过闭包通知调用者
        group.notify(queue: DispatchQueue.main) {
            
            // 刷新表格
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showAlertView(dataCount: viewModels.count)
        }
    }
}

// MARK: --------   监听事件  --------
extension HomeViewController {
    
    @objc func titleBtnViewClick(titleBtnView : CustomNavBarTitleViewBtn) {
        
        titleBtnView.isSelected = !titleBtnView.isSelected
        
        let popoverVC = ShowPopoverVC();
        
        // 模态的方式中，默认模态方式是在模态完成之后，原有界面会被系统移除掉，因为需要在模态之后保留所被盖住的首页(页面)，所以需要对模态的方式进行赋值
        popoverVC.modalPresentationStyle = .custom // 在模态的效果中，只有在custom的这个效果，才能保留模态后的原有页面
        
        /*
        // 模态的转场动画
        popoverVC.modalTransitionStyle = .coverVertical // 包括垂直
        popoverVC.modalTransitionStyle = .crossDissolve // 淡入淡出
        popoverVC.modalTransitionStyle = .flipHorizontal // 水平翻转
        popoverVC.modalTransitionStyle = .partialCurl // 部分卷曲
        */
        
        // 关于transitioningDelegate的这个代理，有个传个对象给他，也可以理解成，需要有一个对象去遵守也承接这个代理，如果使用当前类的对象(self)的话，本类代码太多，可读性差，所以创建一个新的类来承接这个代理，简化代码
        popoverVC.transitioningDelegate = popoverAnim
        
        // 要弹出的视图控制器的View
        var viewRect = self.view.frame
        viewRect.origin.y = 55
        viewRect.size.width = 200
        viewRect.size.height = 300
        viewRect.origin.x = UIScreen.main.bounds.size.width / 2 - viewRect.size.width / 2
        popoverAnim.presentedViewRect = viewRect
        
        
        navigationController?.present(popoverVC, animated: true, completion: nil)
    }
    
    @objc func clickImageItem(notif: Notification) {
        
        let indexPath = notif.userInfo!["indexPath"] as! IndexPath
        
        let images = notif.userInfo!["images"] as! [URL]
        
        let browerVC = BrowserRootViewController(indexPath: indexPath, images: images)
        
        browerVC.modalPresentationStyle = .custom
        browerVC.transitioningDelegate = animatorTool
        
        present(browerVC, animated: true, completion: nil)
    }
}















































































































































































































