//
//  UPCategoriesCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/15/23.
//

import UIKit

class UPCategoriesCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "UPCategoriesCollectionViewCell"
    @IBOutlet weak var imageView: UIImageView!
 
    internal func configureCell(with url: URL){
        imageView.sd_setImage(with: url)
    }
    
}
