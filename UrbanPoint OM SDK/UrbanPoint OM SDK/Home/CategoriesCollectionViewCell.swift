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
    var task: URLSessionDataTask?
    
    struct ViewModel{
        let categoryImage: URL
    }
    
    func configureCellWith(_ viewModel: CategoriesCollectionViewCell.ViewModel){
        // Assign Image to ImageView
        categoryImageViewContainer.shadow(shadowColor: Colors.urbanPointGrey,

                                          shadowRadius: 1,
                                          shadowOpacity: 0.3)
        
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.sd_setImage(with: viewModel.categoryImage)
    }
    
    
    override func prepareForReuse() {
        categoryImageView.image = nil
        task?.cancel()
        super.prepareForReuse()
        
    }
    
    

    
    
    
}
