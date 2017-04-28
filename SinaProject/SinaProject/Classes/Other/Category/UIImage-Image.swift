//
//  UIImage-Image.swift
//  SinaProject
//
//  Created by FCG on 2017/1/19.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

func resizableImage(imageName : String, top : CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIImage {
    
    var image : UIImage? = UIImage(named: imageName)
    image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: UIImageResizingMode.stretch)
    return image!;
}
