//
//  ExpressionViewController.swift
//  表情键盘
//
//  Created by FCG on 2017/3/7.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ExpressionViewController: UIViewController {
    
    /**  创建表情展示View  */
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: ExpressionCollectionViewLayout())
    
    /**  标签展示View的cellID  */
    let kExpressionCellID = "ExpressionCellID"
    
    /**  创建底部工具栏  */
    lazy var bottomToolBar : UIToolbar = UIToolbar()
    
    /**  表情文件管理对象  */
    lazy var expManager : ExpressionManager = ExpressionManager()
    
    // MARK: --------   将点击的表情模型传回去  --------
    var callBack : ((_ expresionModel : ExpressionModel)->())
    
    // MARK: --------   自定义构造方法  --------
    init(callBack : @escaping (_ expresionModel : ExpressionModel)->()) {
        
        self.callBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(colorLiteralRed: 242.0 / 256.0, green: 242.0 / 256.0, blue: 242.0 / 256.0, alpha: 242.0 / 256.0)
        
        // 创建本类UI
        setupSelfUI()
    }
}

// MARK: --------   创建本类UI  --------
extension ExpressionViewController {
    
    fileprivate func setupSelfUI() {
        
        // 添加本类视图
        view.addSubview(collectionView)
        view.addSubview(bottomToolBar)
        
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 242.0 / 256.0, green: 242.0 / 256.0, blue: 242.0 / 256.0, alpha: 242.0 / 256.0)
        bottomToolBar.backgroundColor = UIColor.lightGray
        
        // 配置约束
        setupLayout()
        
        // 工具栏的UI配置和创建
        addBottomToolBarItem()
        
        // 配置表情展示的View
        setupPicCollectionView()
    }
    
    // MARK: --------   配置约束  --------
    private func setupLayout() {
        
        // 添加约束
        // 在添加约束钱，必须要设置这个属性
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomToolBar.translatesAutoresizingMaskIntoConstraints = false
        
        // 在做约束时，需要告知约束的对应的视图对象
        let views : [String : Any] = ["bottomToolBar" : bottomToolBar, "collectionView" : collectionView]
        // 给视图添加约束
        var horizontal_Cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomToolBar]-0-|", options: [], metrics: nil, views: views)
        horizontal_Cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[bottomToolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(horizontal_Cons)
    }
    
    // MARK: --------   工具栏的UI配置和创建  --------
    private func addBottomToolBarItem() {
        
        let titles : [String] = ["最近", "默认", "emoji", "浪小花"]
        
        var itemArray = [UIBarButtonItem]()
        for i in 0 ..< titles.count {
            
            let item = UIBarButtonItem(title: titles[i], style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = i
            
            itemArray.append(item)
            // 每次添加一个按钮后，都要添加一个弹簧item，是两个item之间能往两边弹开
            itemArray.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        // 移除最后一个item右边的弹窗，两边不需要间距
        itemArray.removeLast()
        bottomToolBar.items = itemArray
        bottomToolBar.tintColor = UIColor.orange
        
    }
    
    // MARK: --------   配置表情展示的View  --------
    private func setupPicCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ExpressionCell.classForCoder(), forCellWithReuseIdentifier: kExpressionCellID)
    }
}

// MARK: --------   UICollectionView DataSource/Delegate  --------
extension ExpressionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return expManager.expressionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let packageTool = expManager.expressionList[section]
        
        return packageTool.expressionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: kExpressionCellID, for: indexPath) as! ExpressionCell
        
        let packageTool = expManager.expressionList[indexPath.section]
        let expressionModel = packageTool.expressionModels[indexPath.row]
        item.expressionModel = expressionModel
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let packageTool = expManager.expressionList[indexPath.section]
        let expressionModel = packageTool.expressionModels[indexPath.row]
        
        // 插入表情到最近表情的处理
        insertRecentlyExpression(expressionModel: expressionModel)
        
        // 将选中的表情传回上个页面，方便在输入框的地方进行输入
        callBack(expressionModel)
    }
    
    private func insertRecentlyExpression(expressionModel : ExpressionModel) {
        
        // 判断是否点击的是空表情
        if expressionModel.isEmpty {
            return
        }
        
        // 判断是否点击的是删除按钮
        if expressionModel.isRemove {
            return
        }
        
        // 拿到最近使用的表情数组
        let recentlyUserPackage = expManager.expressionList[0]
        
        // 判断在最近使用的表情数组中，是否已经存在了这个表情模型，如果存在就找到这个表情在这个数组中的索引
        if recentlyUserPackage.expressionModels.contains(expressionModel), let index = recentlyUserPackage.expressionModels.index(of: expressionModel) {
            
            // 移除掉数组中已经存在的这个模型
            recentlyUserPackage.expressionModels.remove(at: index)
        } else {
            
            // 如果这个表情没有存在数组中，移除掉删除按钮前面那个表情
            recentlyUserPackage.expressionModels.remove(at: 19)
        }
        
        // 将新使用的这个表情插入到数组中的第一个位置
        recentlyUserPackage.expressionModels.insert(expressionModel, at: 0)
    }
}

// MARK: --------   监听事件  --------
extension ExpressionViewController {
    
    // 工具栏按钮的点击
    @objc func itemClick(item : UIBarButtonItem) {
        
        let itemTag = item.tag
        if itemTag <= expManager.expressionList.count - 1 {
            
            // 切换对应的区
            collectionView.scrollToItem(at: IndexPath(item: 0, section: itemTag), at: .left, animated: true)
        }
    }
    
}


// MARK: --------   这个是表情展示CollectionView的自定义Cell  --------
class ExpressionCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        // 设置item的大小
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        
        // 设置最小行间距和最小区间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 设置滑动collectionView的滚动方向
        scrollDirection = .horizontal
        
        // 设置collctionView的父类的一些属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        // item行之间的夹缝间距
        let itemMargin = (collectionView!.bounds.height - itemWH * 3) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(itemMargin, 0, itemMargin, 0)
    }
}



















