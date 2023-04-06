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

        if let url = URL(string: "https://urbanpoint-storage.azureedge.net/test/uploads_staging/uploads/" + outlet.outletImage){
          //  task = outletImageView.downloadImageFromURL(url: url)
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
