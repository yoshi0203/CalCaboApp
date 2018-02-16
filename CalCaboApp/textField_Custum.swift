//
//  textField_Custum.swift
//  CalCaboApp
//
//  Created by yamanaka on 2018/01/16.
//  Copyright © 2018年 yamanaka. All rights reserved.
//
//  TextFieldのデザインを設定するカスタムクラス
//

import UIKit

@IBDesignable
class textField_Custum : UITextField{
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
    
    //文字数設定
    //なんで動いてるのかわからん
    private var maxLengths = [UITextField: Int]()
    
    @IBInspectable var maxLength: Int {
        get{
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set{
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else{
            return
        }
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        
        #if swift(>=4.0)
            text = String(prospectiveText[..<maxCharIndex])
        #else
            text = prospectiveText.substring(to: macCharIndex)
        #endif
        selectedTextRange = selection
    }
        
    
}
