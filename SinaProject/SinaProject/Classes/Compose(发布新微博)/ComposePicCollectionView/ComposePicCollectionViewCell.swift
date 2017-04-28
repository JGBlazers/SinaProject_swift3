//
//  ComposePicCollectionViewCell.swift
//  SinaProject
//
//  Created by FCG on 2017/3/6.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ComposePicCollectionViewCell: UICollectionViewCell {
    
    // MARK: --------   UI拖线  --------
    /**  背景按钮  */
    @IBOutlet weak var bgBtn: UIButton!
    /**  相片  */
    @IBOutlet weak var photoImgView: UIImageView!
    /**  删除按钮  */
    @IBOutlet weak var delBtn: UIButton!
    
    // MARK: --------   相片墙的图片  --------
    var photo : UIImage? {
        
        didSet{
            
            if photo != nil {
                
                bgBtn.isHidden = true
                photoImgView.isHidden = false
                delBtn.isHidden = false
                
                photoImgView.image = photo!
            } else {
                
                bgBtn.isHidden = false
                photoImgView.isHidden = true
                delBtn.isHidden = true
                
                bgBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                bgBtn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), for: .highlighted)
            }
        }
    }
    
}

// MARK: --------   监听事件  --------
extension ComposePicCollectionViewCell {
    
    // 添加相片按钮的点击
    @IBAction func addPhotoBtnClick() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kAddPhotosNotif"), object: nil)
    }
    
    // 删除相片按钮的点击
    @IBAction func delPhotoBtnClick() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kDelPhotosNotif"), object: photo)
    }
    
}
