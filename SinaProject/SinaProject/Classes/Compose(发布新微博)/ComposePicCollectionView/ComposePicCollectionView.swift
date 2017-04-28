//
//  ComposePicCollectionView.swift
//  SinaProject
//
//  Created by FCG on 2017/3/6.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ComposePicCollectionView: UICollectionView {
    
    /**  相片墙的itemID  */
    let kComposePicCollectionViewCellID = "ComposePicCollectionViewCellID"
    
    /**  item的间距  */
    let edgeMargin : CGFloat = 15.0
    
    /**  图片数组  */
    var photos : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 获取layout，设置item的大小和间距等
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWH = (kScreenSize().width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        
        // 设置内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
        
        dataSource = self
        
        register(UINib(nibName: "ComposePicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kComposePicCollectionViewCellID)
        
    }

}

extension ComposePicCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1 + photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: kComposePicCollectionViewCellID, for: indexPath) as! ComposePicCollectionViewCell
        
        item.photo = (indexPath.row <= photos.count - 1) ? photos[indexPath.row] : nil
        
        return item
    }
}
