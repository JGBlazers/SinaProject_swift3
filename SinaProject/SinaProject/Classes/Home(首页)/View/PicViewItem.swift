//
//  PicViewItem.swift
//  SinaProject
//
//  Created by FCG on 2017/3/3.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit
import SDWebImage

class PicViewItem: UICollectionViewCell {
    
    // MARK: --------   拖线  --------
    /**  配图  */
    @IBOutlet weak var iconImgView: UIImageView!
    
    // MARK: --------   系统回调  --------
    /**  图片的URL  */
    
    
    var picUrl : URL? {
        didSet {
            guard let picUrl = picUrl else {
                print("没有图片的URL")
                return
            }
            
            iconImgView.sd_setImage(with: picUrl, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
