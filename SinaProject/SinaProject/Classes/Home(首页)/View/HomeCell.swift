//
//  HomeCell.swift
//  SinaProject
//
//  Created by FCG on 2017/3/1.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15

class HomeCell: UITableViewCell {
    
    let itemCellID = "PICVIEWITEM"
    
    // MARK: --------   xib拖线  --------
    // 原微博相关
    /**  头像  */
    @IBOutlet weak var headImgView: UIImageView!
    
    /**  认证图标  */
    @IBOutlet weak var verifiedImgView: UIImageView!
    
    /**  昵称  */
    @IBOutlet weak var nicknameLabel: UILabel!
    
    /**  vip图标  */
    @IBOutlet weak var vipImgView: UIImageView!
    
    /**  创建时间  */
    @IBOutlet weak var createAtLabel: UILabel!
    
    /**  来源  */
    @IBOutlet weak var sourceLabel: UILabel!
    
    /**  正文  */
    @IBOutlet weak var contentLabel: UILabel!
    
    /**  配体View  */
    @IBOutlet weak var picView: UICollectionView!
    
    /**  配图View的图层  */
    @IBOutlet weak var picViewLayout: UICollectionViewFlowLayout!
    
    /**  底部按钮工具栏  拉出来是为了计算cell的高度  */
    @IBOutlet weak var bottomTool: UIView!
    
    
    
    //  转发的微博相关
    /**  转发的微博正文  */
    @IBOutlet weak var retweetedContentLabel: UILabel!
    
    /**  转发微博的背景View， 有转发微博就显示，没有转发微博就隐藏  */
    @IBOutlet weak var retweetedBgView: UIView!
    
    /**  正文的宽度约束  */
    @IBOutlet weak var contentWidthCons: NSLayoutConstraint!
    
    /**  配图View的宽度  */
    @IBOutlet weak var picViewWidthCons: NSLayoutConstraint!
    
    /**  配图View的高度  */
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    
    /**  配图底部距离按钮栏顶部的约束  这个约束，在没有配图的情况下，设置为0，有配图的情况下，设置10  */
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    /**  转发微博的正文顶部距离原创微博的底部约束  这个约束，在没有转发微博的情况下，设置为0，有转发微博的情况下，设置15  */
    @IBOutlet weak var retweeted_TextTopCons: NSLayoutConstraint!
    
    
    // MARK: --------   系统回调  --------
    // 间隔
    let marginXY : CGFloat = 10
    // cell中的空间的左间距为 15
    let leftMarginXY : CGFloat = 15
    
    var picUrlArray : [URL] = [URL]() {
        
        didSet {
            picView.reloadData()
        }
    }
    
    
    /**  处理过后的微博模型 viewModel  */
    var viewModel : HomeViewModel? {
        
        didSet{
            
            guard let viewModel = viewModel else {
                return
            }
            
            // 原微博相关 ---
            
            // 头像
            headImgView.sd_setImage(with: viewModel.headImgUrl, placeholderImage: UIImage(named: "avatar_default_small"))
            
            // 认证图标
            verifiedImgView.image = viewModel.verifiedImg
            
            // 昵称
            nicknameLabel.text = viewModel.homeModel?.user?.screen_name
            
            // vip图标
            vipImgView.image = viewModel.vipImg
            
            // 创建时间
            createAtLabel.text = viewModel.created_at_Text
            
            // 来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            } else {
                sourceLabel.text = nil
            }
            
            // 正文
            contentLabel.attributedText = FindExpression.shareInstace.changeExpressionAttributedString(oldString: viewModel.homeModel?.text, titleFont: contentLabel.font)
            
            // print("配图的url == \(viewModel.pic_urls_custom)")
            
            // 转发的微博相关 ----
            // 判断是否存在转发微博和判断是否存在转发微博的正文
            if viewModel.homeModel?.retweeted_status != nil {
                
                if let retweeted_screenName = viewModel.homeModel?.retweeted_status?.user?.screen_name, let retweetedContent = viewModel.homeModel?.retweeted_status?.text {
                    
                    retweetedContentLabel.text = "@" + "\(retweeted_screenName): " + retweetedContent
                    retweetedContentLabel.attributedText = FindExpression.shareInstace.changeExpressionAttributedString(oldString: retweetedContentLabel.text, titleFont: retweetedContentLabel.font)
                    
                    // 能来这里，表示有转发微博，转发微博的背景显示出来
                    retweetedBgView.isHidden = false
                    
                    // 设置转发微博正文距离原创微博的约束
                    retweeted_TextTopCons.constant = 15
                }
            } else {
                
                retweetedContentLabel.text = nil
                
                // 能来这里，表示没有转发微博，转发微博的背景隐藏
                retweetedBgView.isHidden = true
                
                // 设置转发微博正文距离原创微博的约束
                retweeted_TextTopCons.constant = 0
            }
            
            let picViewLayout = calculatePicViewLayout(picCount: viewModel.pic_urls_custom.count)
            picViewWidthCons.constant = picViewLayout.0
            picViewHeightCons.constant = picViewLayout.1
            
            
            picUrlArray = viewModel.pic_urls_custom
            
            
            // 计算cell的高度  首先调用强制布局的方法，然后将底部工具栏的最大高度作为cell的高度
            // 强制布局
            self.layoutIfNeeded()
            // 获取cell的最大高度
            viewModel.rowHeight = bottomTool.frame.maxY
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentWidthCons.constant = kScreenSize().width - 2 * edgeMargin
    
        picView.dataSource = self
        picView.delegate = self
        
        picView.register(UINib(nibName: "PicViewItem", bundle: nil), forCellWithReuseIdentifier: itemCellID)
    }
}

extension HomeCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrlArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellID, for: indexPath) as! PicViewItem
        
        item.picUrl = picUrlArray[indexPath.row]
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objDic : [String : Any] = ["indexPath" : indexPath, "images" : picUrlArray]
        // 开启通知监听图片item的点击
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kClickImageItem"), object: nil, userInfo: objDic)
    }
}

extension HomeCell {
    
    func calculatePicViewLayout(picCount : Int) -> (width : CGFloat, height : CGFloat) {
        
        
        // 当count == 0  picView的宽度和高度为0
        if picCount == 0 {
            
            // 在没有配图的情况下，配图View距离底部的高度为0
            picViewBottomCons.constant = 0
            return (0, 0)
        }
        
        // 在有配图的情况下，配图View距离底部的高度为15
        picViewBottomCons.constant = 15
        
        // 当count == 1 的时候，显示图片原有的大小
        if picCount == 1 {
            
            // 从内存中取出图片
            let image = SDImageCache.shared().imageFromDiskCache(forKey: viewModel?.pic_urls_custom.first?.absoluteString)
            
            if let image = image {
                
                // 一张图片并且存在的情况下，item的大小为图片的原始大小
                picViewLayout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
                
                // 一般情况下，通过SDWebImage存图片时，图片会被默认压缩一般大小，所以这里取出来的图片实际大小是 * 2
                return (image.size.width * 2, image.size.height * 2)
            } else {
                // 一张图片并且不存在的情况下，item的大小为图片的原始大小为(0, 0)
                picViewLayout.itemSize = CGSize(width: 0, height: 0)
                return (0, 0)
            }
        }
        
        let otherWH = (kScreenSize().width - 2 * marginXY - 2 * leftMarginXY) / 3
        
        // 其他情况下，item的大小为
        picViewLayout.itemSize = CGSize(width: otherWH, height: otherWH)
        
        // 当count == 4 的时候，层田字排列, 高度 == 宽度 == 按照一排3个排列
        if picCount == 4 {
            
            let width = 2 * otherWH + marginXY
            let height = 2 * otherWH + marginXY
            
            return (width, height)
        }
        
        // 其他的情况
        // 宽度 == 屏宽 - 2 * leftMarginXY
        let width = kScreenSize().width - 2 * leftMarginXY
        
        // 图片一共排列多少行
        let lineCount = (CGFloat)((picCount - 1) / 3 + 1)
        let height = lineCount * otherWH + (lineCount - 1.0) * marginXY
        
        return (width, height)
    }
}
