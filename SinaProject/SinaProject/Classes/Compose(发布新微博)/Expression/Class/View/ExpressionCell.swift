//
//  ExpressionCell.swift
//  表情键盘
//
//  Created by FCG on 2017/3/7.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

class ExpressionCell: UICollectionViewCell {
    
    /**  表情模型  */
    var expressionModel : ExpressionModel? {
        
        didSet {
            
            guard let expressionModel = expressionModel else {
                return
            }
            
            expresstionBtn.setTitle(expressionModel.codeString, for: .normal)
            
            expresstionBtn.setImage(UIImage(contentsOfFile: expressionModel.pngPathString ?? ""), for: .normal)
            
            if expressionModel.isRemove {
                
                expresstionBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    
    var expresstionBtn : UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        expresstionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32.0)
        expresstionBtn.isUserInteractionEnabled = false
        expresstionBtn.frame = bounds
        addSubview(expresstionBtn)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
