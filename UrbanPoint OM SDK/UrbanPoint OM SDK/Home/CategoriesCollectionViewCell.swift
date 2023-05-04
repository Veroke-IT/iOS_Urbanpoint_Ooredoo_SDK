//
//  CategoriesCollectionViewCell.swift
//  UrbanPoint OM SDK
//
//  Created by MamooN_ on 3/9/23.
//

import UIKit



class CategoriesCollectionViewCell: UICollectionViewCell {

    static let identifier = "CategoriesCollectionViewCell"
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryImageViewContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    var task: URLSessionDataTask?
    
    struct ViewModel{
        let categoryImage: URL?
        let name: String
    }
    
    func configureCellWith(_ viewModel: CategoriesCollectionViewCell.ViewModel){
       

        //categoryImageViewContainer.bringSubviewToFront(categoryImageView)
        nameLabel.text = viewModel.name
        categoryImageView.sd_setImage(with: viewModel.categoryImage,placeholderImage: placeHolderImage)
    }
    
    
    override func prepareForReuse() {
        //categoryImageView.image = nil
       // task?.cancel()
        super.prepareForReuse()
        
    }
    
    

    
    
    
}
