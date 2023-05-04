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
        imageView.sd_setImage(with: url,placeholderImage: placeHolderImage)
    }
    
    override func prepareForReuse() {
        //categoryImageView.image = nil
       // task?.cancel()
        super.prepareForReuse()
        
    }
    

    

    
}
