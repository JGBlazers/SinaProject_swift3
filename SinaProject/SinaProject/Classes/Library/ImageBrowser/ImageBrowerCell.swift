//
//  ImageBrowerCell.swift
//  SinaProject
//
//  Created by FCG on 2017/3/9.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SDWebImage

// MARK: --------   给本类添加代理  --------
protocol ImageBrowerCellDelegate : NSObjectProtocol {
    
    // 图片的点击
    func imageViewClick()
}

class ImageBrowerCell: UICollectionViewCell {
    
    // MARK: --------   懒加载  --------
    /**  背景滑动视图  */
    lazy var scrollView : UIScrollView = UIScrollView()
    
    /**  图片  */
    lazy var picView : UIImageView = UIImageView()
    
    /**  下载图片时候的Loading  */
    lazy var loading : ImageDownLoadLoading = ImageDownLoadLoading()
    
    // MARK: --------   全局变量  --------
    /**  图片数组  */
    var image : URL? {
        
        didSet {
            
            setupPicViewOfImage(imageUrl: image)
        }
    }
    
    // MARK: --------   描述代理属性  --------
    var delegate : ImageBrowerCellDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 配置本类UI
        setupSelfUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: --------   配置本类UI  --------
extension ImageBrowerCell {
    
    fileprivate func setupSelfUI() {
        
        // 添加本类UI
        addSubview(scrollView)
        scrollView.addSubview(picView)
        addSubview(loading)
        
        // 设置滑动视图的属性
        scrollView.frame = bounds
        scrollView.frame.size.width -= 15
        
        // 设置图片的属性
        picView.frame = scrollView.bounds
        
        // 设置loading的属性
        loading.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        loading.center = CGPoint(x: kScreenSize().width * 0.5, y: kScreenSize().height * 0.5)
        loading.isHidden = true
        loading.backgroundColor = UIColor.clear
        
        // 给图片添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickImageTap))
        picView.addGestureRecognizer(tap)
        picView.isUserInteractionEnabled = true
    }
}

// MARK: --------   赋值  --------
extension ImageBrowerCell {
    
    fileprivate func setupPicViewOfImage(imageUrl :URL?) {
        
        guard let imageUrl = imageUrl else {
            return
        }
        
        let bigImageUrlString = (imageUrl.absoluteString as NSString).replacingOccurrences(of: "/thumbnail/", with: "/large/")
        
        let smallImg = SDImageCache.shared().imageFromDiskCache(forKey: imageUrl.absoluteString)!
        
        self.loading.isHidden = false
        picView.sd_setImage(with: URL(string: bigImageUrlString), placeholderImage: smallImg, options: [], progress: { (downLoadLength, allLength) in
            
            self.loading.isHidden = false
            self.loading.progress = CGFloat(downLoadLength) / CGFloat(allLength)
        }) { (_, _, _, _) in
            self.loading.isHidden = true
        }
        
        let picViewW = kScreenSize().width
        let picViewH = smallImg.size.height / smallImg.size.width * picViewW
        var picViewY = (kScreenSize().height - picViewH) * 0.5
        if picViewY < 0 {
            picViewY = 0
        }
        picView.frame = CGRect(x: 0, y: picViewY, width: picViewW, height: picViewH)
        
        scrollView.contentSize = CGSize(width: 0, height: picViewH)
    }
}

// MARK: --------   监听事件  --------
extension ImageBrowerCell {
    
    // MARK: --------   图片的点击  --------
    @objc fileprivate func clickImageTap() {
        
        delegate?.imageViewClick()
    }
    
}
