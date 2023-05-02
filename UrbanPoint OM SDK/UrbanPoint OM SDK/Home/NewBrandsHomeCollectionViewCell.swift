//
//  NewBrandsHomeCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 4/2/23.
//

import UIKit

class NewBrandsHomeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NewBrandsHomeCollectionViewCell"
    
    @IBOutlet weak var outletCategoryLabel: UILabel!
    @IBOutlet weak var outletImageView: UIImageView!
    @IBOutlet weak var outletTitleLabel: UILabel!
    var task: URLSessionDataTask?
    
    internal func configureOutletCellWith(_ outlet: NewBrand){

        if let url = URL(string: imageBaseURL + outlet.outletLogo){
            outletImageView.sd_setImage(with: url,placeholderImage: placeHolderImage)
        }
        outletCategoryLabel.text = outlet.categoryName
        outletTitleLabel.text = outlet.parentOutletName
    }

    override func prepareForReuse() {
        outletImageView.image = nil
        task?.cancel()
        super.prepareForReuse()
        
    }
    
    
}
