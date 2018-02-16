//
//  button_Custum.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/16.
//  Copyright © 2018年 yamanaka. All rights reserved.
//

import UIKit

@IBDesignable
class buttton_Custum : UIButton{
    //枠線の色
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor ?? nil }
    }
    
    //枠線の幅
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    //枠の角丸設定
    @IBInspectable var cornerRadius: CGFloat = 1.0 {
        didSet{
            layer.cornerRadius = cornerRadius
            //layer.masksToBounds = cornerRadius > 0.0
            self.clipsToBounds = true
        }
    }
}

