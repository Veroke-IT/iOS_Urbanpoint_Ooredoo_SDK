//
//  Extension+UIView.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/8/23.
//

import UIKit

extension UIView{
    
    @IBInspectable
    var borderColor: UIColor?{
        get{
            UIColor(cgColor: layer.borderColor!)
        }
        set{
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat{
        get{
            layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    
    
    
    func shadow(shadowColor: UIColor? = nil,
                shadowOffset: CGSize = .zero,
                shadowRadius: CGFloat = 0,
                shadowOpacity: Float = 0,
                shadowPath: CGPath? = nil){
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath
    }
    
    func addGradientBackground(startColor: UIColor,endColor: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at:0)
        self.backgroundColor = .clear
    }
    

    
}

extension UICollectionViewFlowLayout{
    open override var flipsHorizontallyInOppositeLayoutDirection: Bool{
        return true
    }
}
