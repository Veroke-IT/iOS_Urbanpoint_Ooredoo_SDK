//
//  Extension+UIImageView.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

extension UIImage{
    static func loadImageWithName(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Appbundle, compatibleWith: nil)
    }
    func imageWith(newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
            
        return image.withRenderingMode(renderingMode)
    }
}

extension UIImageView{
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 1
        containerView.layer.cornerRadius = cornerRadious
      
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
    

}
