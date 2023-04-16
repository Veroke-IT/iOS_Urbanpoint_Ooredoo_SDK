//
//  Extension+UIImageView.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

extension UIImage{
    static func loadImageWithName(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Appbundle, with: nil)
    }
}
