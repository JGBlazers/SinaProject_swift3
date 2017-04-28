//
//  BrowserRootViewController.swift
//  SinaProject
//
//  Created by FCG on 2017/3/9.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class BrowserRootViewController: UIViewController {
    
    // MARK: --------   全局属性  --------
    /**  索引  */
    fileprivate var indexPath : IndexPath
    
    /**  图片数组  */
    fileprivate var images : [URL]
    
    // MARK: --------   懒加载  --------
    /**  图片展示View  */
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CustomCollectionViewFlowLayout())
    /**  索引  */
    let collectionViewCellID = "kImageShowViewItem"
    
    // MARK: --------   保存按钮  --------
    lazy var saveBtn : UIButton = UIButton()
    
    
    // MARK: --------   自定义构造函数  --------
    init(indexPath : IndexPath, images : [URL]) {
        
        self.images = images
        
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建本类UI
        setupSelfUI()
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }

}

// MARK: --------   创建本类UI  --------
extension BrowserRootViewController {
    
    fileprivate func setupSelfUI() {
        
        // 添加本类UI
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        
        // picVie的属性配置
        collectionView.frame = view.bounds
        collectionView.frame.size.width += 15
        collectionView.register(ImageBrowerCell.classForCoder(), forCellWithReuseIdentifier: collectionViewCellID)
        collectionView.dataSource = self
        
        // 保存按钮
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = UIColor.lightGray
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        saveBtn.layer.cornerRadius = 30
        saveBtn.layer.masksToBounds = true
        saveBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
    }
    
}

// MARK: --------   UICollectionView 的数据源方法和代理方法  --------
extension BrowserRootViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! ImageBrowerCell
        
        cell.image = images[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
}

// MARK: --------   监听事件  --------
extension BrowserRootViewController : ImageBrowerCellDelegate {
    
    // 点击保存按钮
    @objc fileprivate func saveBtnClick() {
        
        let cell = collectionView.visibleCells.first as! ImageBrowerCell
        
        guard let picImage = cell.picView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(picImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        
        
    }
    
    // MARK: --------   cell中的图片的点击  --------
    func imageViewClick() {
        dismiss(animated: true, completion: nil)
    }
    
    // 保存图片必须要实现的方法
    @objc fileprivate func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo: Any) {
        
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        print(showInfo)
    }
}


// MARK: --------   UICollectionViewFlowLayout  --------
class CustomCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        
    }
}
