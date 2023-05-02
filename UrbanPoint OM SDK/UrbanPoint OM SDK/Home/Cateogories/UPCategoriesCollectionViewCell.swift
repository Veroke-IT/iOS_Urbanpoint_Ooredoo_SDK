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
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    internal func configureCell(with url: URL,name: String){
        categoryName.text = name
        imageView.sd_setImage(with: url) { image, error, cache, url in
            if error != nil{
                DispatchQueue.main.async {[weak self] in
                    self?.imageView.isHidden = true
                    self?.containerView.backgroundColor = Colors.urbanPointGrey
                }
            }
        }
    }
    

    
}
