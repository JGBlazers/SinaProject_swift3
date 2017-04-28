//
//  UITextView-swift
//  表情键盘
//
//  Created by FCG on 2017/3/8.
//  Copyright © 2017年 FCG. All rights reserved.
//

import UIKit

// MARK: --------  本类的作用是插入表情进对应的textView的光标位置  --------

extension UITextView {
    
    // MARK: --------   图文混排，插入表情  --------
    func insertExpresstionToTextView(expressionModel : ExpressionModel)
    {
        
        // 如果是删除键，就回删一位
        if expressionModel.isRemove {
            deleteBackward()
            return
        }
        
        // 如果是空表情，就不做操作
        if expressionModel.isEmpty {
            return
        }
        
        // 判断是否是emoji表情
        if expressionModel.pngPathString == nil {
            
            // 获取光标的位置
            let textRange = selectedTextRange!
            // 在光标的位置上插入表情
            replace(textRange, withText: expressionModel.codeString!)
            return
        } else {
            
            // 创建附件对象  因为在附件的属性中，添加属于这个图片的对应中文名，所以自定义一个附件类
            let attachament = ExpressionTextAttachment()
            // 给附件添加图片
            attachament.image = UIImage(contentsOfFile: expressionModel.pngPathString!)
            attachament.expressionChs = expressionModel.chs!
            // 设置图片的大小和位置
            // 根据当前输入框的字体大小来设置图片的大小
            let font = self.font!
            attachament.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            
            // 将附件转成属性字符串
            let attrString = NSAttributedString(attachment: attachament)
            
            // 将当前输入框的内容转成可变的属性字符串
            let mutableAttrString = NSMutableAttributedString(attributedString: attributedText)
            
            // 获取光标所在位置
            let rang = selectedRange
            
            // 在光标的位置，把属性字符串拼接到可变属性字符串中
            mutableAttrString.replaceCharacters(in: rang, with: attrString)
            
            // 将属性字符串赋值给textView
            attributedText = mutableAttrString
            
            // 属性字符串对textView赋值的时候，会出现改变了textView的大小和光标所在的位置
            // 处理一：对textView的字体大小重新赋值
            self.font = font
            // 处理二：将光标锁定在当前插入表情的后一位
            selectedRange = NSMakeRange(rang.location + 1, 0)
        }
    }
    
    // MARK: --------   获取图文混排后的字符串  --------
    func getTextViewText() -> String {
        
        // 将textView的属性字符串改成可变属性字符串
        let mutableAttr = NSMutableAttributedString(attributedString: attributedText)
        
        // 遍历这个属性字符串
        // 要遍历的这个字符串的位置和宽度
        let range = NSMakeRange(0, mutableAttr.length)
        
        /**  遍历属性字符串的过程中，所遍历出来的元素
         *  [String : Any] : 遍历属性字符串的过程中，所遍历出来的元素
         *  NSRange : 遍历属性字符串的过程中，所遍历出来的元素所在的range
         *  UnsafeMutablePointer<ObjCBool> 需要传入一个可变的无符号bool值指针，一般传‘_’
         */
        mutableAttr.enumerateAttributes(in: range, options: []) { (elementDic, elementRange, _) in
            /*  打印可以知道规律:当如果是有图片的地方，会存在NSAttachment这个相关的对象，而这个对象就是在配置图文的时候所匹配进去的ExpressionTextAttachment，所以当这个对象存在的情况下，将这个对象中的chs替换掉原有图片的位置
             print(elementDic)
             print(range)
             */
            
            if let textAttachment = elementDic["NSAttachment"] as? ExpressionTextAttachment {
                mutableAttr.replaceCharacters(in: elementRange, with: textAttachment.expressionChs!)
            }
        }
        
        // 最后的字符串
        return mutableAttr.string
    }
}

// MARK: --------   拓展NSTextAttachment  --------
class ExpressionTextAttachment: NSTextAttachment {
    
    /**  附件图片对应的中文名字  */
    var expressionChs : String?
    
    
}
