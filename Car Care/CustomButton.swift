//
//  CustomButton.swift
//  CustomizeInterfaceBuilder
//
//  Created by Andi Setiyadi on 4/20/16.
//  Copyright © 2016 Devhubs. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: Float = 0.0
    @IBInspectable var borderWidth: Float = 0.0
    @IBInspectable var borderColor: UIColor = UIColor.clearColor()
  
    
    override func drawRect(rect: CGRect) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.CGColor
    }
    
}
