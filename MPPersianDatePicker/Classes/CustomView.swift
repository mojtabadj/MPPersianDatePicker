//
//  CustomView.swift
//  Hotelyar
//
//  Created by Admin on 4/4/1396 AP.
//  Copyright © 1396 Admin. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}
